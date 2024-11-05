import Types "types";
import Map "mo:map/Map";
import {thash} "mo:map/Map";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Mod "private"

actor {
  var dataBase = Map.new <Types.ID, Types.Patient> ();
  var date: Types.Date = "";

  public func setDate(inputDate: Types.Date): async Text {
    date := inputDate;
    return "Date Saved!";
  };

  public func updateMedicalData(data: Types.Fields): async Text {
    if (date == ""){
      return "Please, set the date first"
    } else {
      let id: Types.ID = Mod.GetID(data.patientBirthDate, data.patientFullName);
      let patientHist: Types.Patient = switch (Map.get(dataBase, thash, id)) {
        case (?found) {
          found 
        };
        case null {
          
          let newPatient = Map.new<Types.Date, Types.Fields>();
          Map.set(newPatient, thash, date, data);          
          Map.set(dataBase, thash, id, newPatient);        

          return "Register and User Created, Upload Successful!";
        };
      };
      let validDate: Bool = Mod.GetValidDate(patientHist, date);
      if (validDate) {
        var i:Nat = 1;
        loop {
          var dateBackup: Text = date;
          dateBackup := dateBackup # "-" # Nat.toText(i);
          if (Mod.GetValidDate(patientHist, dateBackup)) {
            i += 1;
          } else {
            Map.set(patientHist, thash, dateBackup, data);
            Map.set(dataBase, thash, id, patientHist);
            return "Date already registered!. Entry upload with date: " # dateBackup;
          };
        }
        
      } else {
        Map.set(patientHist, thash, date, data);
        Map.set(dataBase, thash, id, patientHist);
        return "User Found, Entry Created and Upload Successful!"
      };
    };

  };
  
  public query func getAllIds(): async ?[Types.ID]{
    return ?Iter.toArray(Map.keys(dataBase))
  };


  public query func GetMedicalData(inputID: Types.RequestID): async ?Types.GetAllData{

    let id: Types.ID = Mod.GetID(inputID.patientBirthDate, inputID.patientFullName);
    let look4Patient:?Types.Patient = Mod.Look4Patient(dataBase, id);
    switch look4Patient {
      case (?lookValue){
        return ?Iter.toArray(Map.entries(lookValue));
      };
      case null {
        return null;
      };
    };
  };

  public query func GetDataByDate(inputDate: Types.RequestDate): async ?Types.GetSingleData {

    let id: Types.ID = Mod.GetID(inputDate.patientBirthDate, inputDate.patientFullName);
    let look4Patient:?Types.Patient = Map.get(dataBase, thash, id);
    switch look4Patient {
      case (?lookValue){
        return Map.get(lookValue, thash, inputDate.date)
      };
      case null {
        return null;
      };
    };

  };
};
