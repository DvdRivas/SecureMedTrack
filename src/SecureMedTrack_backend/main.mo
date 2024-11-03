import Types "types";
import Map "mo:map/Map";
import {thash} "mo:map/Map";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Blob "mo:base/Blob";
import SHA3 "mo:sha3";
import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";
import Option "mo:base/Option";
import Iter "mo:base/Iter";


actor {

  var patient = Map.new <Types.Date, Types.Fields> ();
  var dataBase = Map.new <Types.ID, Map.Map<Types.Date, Types.Fields>> ();
  var date: Types.Date = "";

  public func setDate(inputDate: Types.Date): async Text {
    date := inputDate;
    return "Date Saved!";
  };

  public func updateMedicalData(data: Types.Fields): async Text {
    var sha = SHA3.Keccak(512);
    let name = Blob.toArray(Text.encodeUtf8(data.patientFullName));
    let bd = Blob.toArray(Text.encodeUtf8(data.patientBirthDate));
    sha.update(name);
    sha.update(bd);
    let result = sha.finalize();
    let hexSymbols = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];
    let id:Types.ID = Array.foldLeft<Nat8, Text>(result, "", func (acc, byte) {
      let highNibble = Text.fromChar(hexSymbols[Nat8.toNat((byte / 16)) % 16]);
      let lowNibble = Text.fromChar(hexSymbols[Nat8.toNat(byte % 16)]);
      acc # highNibble # lowNibble;
    });

    let nullToFalse: ?Bool = Map.contains(dataBase, thash, id);
    let idState: Bool = Option.get(nullToFalse, false);
    if (idState == true){
      Map.set(patient, thash, date, data);
      Map.set(dataBase, thash, id, patient);
      return "User Found, Upload Succefull!"
    } else {
      Map.set(patient, thash, date, data);
      Map.set(dataBase, thash, id, patient);
      return "Register Created, Upload Succefull!"
    };
  };
  
  public query func GetMedicalData(inputID: Types.RequestID): async ?Types.GetAllData{

    var sha = SHA3.Keccak(512);
    let name = Blob.toArray(Text.encodeUtf8(inputID.patientFullName));
    let bd = Blob.toArray(Text.encodeUtf8(inputID.patientBirthDate));
    sha.update(name);
    sha.update(bd);
    let result = sha.finalize();
    let hexSymbols = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];
    let id:Types.ID = Array.foldLeft<Nat8, Text>(result, "", func (acc, byte) {
      let highNibble = Text.fromChar(hexSymbols[Nat8.toNat((byte / 16)) % 16]);
      let lowNibble = Text.fromChar(hexSymbols[Nat8.toNat(byte % 16)]);
      acc # highNibble # lowNibble;
    });

    let look4Patient:?Types.Patient = Map.get(dataBase, thash, id);
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
    var sha = SHA3.Keccak(512);
    let name = Blob.toArray(Text.encodeUtf8(inputDate.patientFullName));
    let bd = Blob.toArray(Text.encodeUtf8(inputDate.patientBirthDate));
    sha.update(name);
    sha.update(bd);
    let result = sha.finalize();
    let hexSymbols = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];
    let id:Types.ID = Array.foldLeft<Nat8, Text>(result, "", func (acc, byte) {
      let highNibble = Text.fromChar(hexSymbols[Nat8.toNat((byte / 16)) % 16]);
      let lowNibble = Text.fromChar(hexSymbols[Nat8.toNat(byte % 16)]);
      acc # highNibble # lowNibble;
    });

    let look4Patient:?Types.Patient = Map.get(dataBase, thash, id);
    switch look4Patient {
      case (?lookValue){
        return Map.get(lookValue, thash, inputDate.date)
        // return ?Iter.toArray(Map.entries(lookValue));
      };
      case null {
        return null;
      };
    };

  };
};
