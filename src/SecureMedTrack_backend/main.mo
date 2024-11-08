import Types "types";
import Map "mo:map/Map";
import {thash} "mo:map/Map";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Mod "private";


actor {
  var dataBase = Map.new <Types.ID, Types.Patient> ();

  stable var actualDate: Text = Mod.GetCurrentDate();
  public query func ActualDate(): async Text {
    actualDate := Mod.GetCurrentDate();
    return actualDate
  };

  public func updateMedicalData(data: Types.Fields): async Text {
    let date: Text = Mod.GetCurrentDate();
    let record: Types.Record = {
      patientFullName = data.patientFullName;
      patientBirthDate = data.patientBirthDate;
      patientDiagnosis = data.patientDiagnosis;
      patientAge = Mod.GetAge(data.patientBirthDate);
  //     medicine = Text;
  //     condition = Text;
  //     medication = Text;
  //     lastVisit = Text;
    };
    if (date == ""){
      return "Please, set the date first"
    } else {
      let id: Types.ID = Mod.GetID(data.patientBirthDate, data.patientFullName);
      let patientHist: Types.Patient = switch (Map.get(dataBase, thash, id)) {
        case (?found) {
          found 
        };
        case null {
          
          let newPatient = Map.new<Types.Date, Types.Record>();
          Map.set(newPatient, thash, date, record);          
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
            Map.set(patientHist, thash, dateBackup, record);
            Map.set(dataBase, thash, id, patientHist);
            return "Date already registered!. Entry upload with date: " # dateBackup;
          };
        }
        
      } else {
        Map.set(patientHist, thash, date, record);
        Map.set(dataBase, thash, id, patientHist);
        return "User Found, Entry Created and Upload Successful!"
      };
    };

  };
  
  // public query func getAllIds(): async ?[Types.ID]{
  //   return ?Iter.toArray(Map.keys(dataBase))
  // };


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
 
//  public func Age(bd: Text): async Nat {
//   return Mod.GetAge(bd);
//  };

};
