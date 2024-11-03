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


actor {

  var patient = Map.new <Text, Types.Patient> ();

  // public func inputName(name : Text) : async Text {
  //   let patientName: Text = name;
  // };

  // public func inputAge(age: Nat): (){
  //   let patientAge: Nat = age;
  // };

  // public func inputDiagnosis(disease: Text): async Text{
  //   let patientDiagnosis: Text = disease;
  // };

  
  // public shared func (): async {

  // };



  public func updateMedicalData(data: Types.Patient): async Text {
    var sha = SHA3.Keccak(512);
    let hello = Blob.toArray(Text.encodeUtf8(data.patientFullName));
    let space = Blob.toArray(Text.encodeUtf8(" "));
    let world = Blob.toArray(Text.encodeUtf8(data.patientbrithDate));
    sha.update(hello);
    sha.update(space);
    sha.update(world);
    let result = sha.finalize();
    let hexSymbols = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];
    let id:Text = Array.foldLeft<Nat8, Text>(result, "", func (acc, byte) {
      let highNibble = Text.fromChar(hexSymbols[Nat8.toNat((byte / 16)) % 16]);
      let lowNibble = Text.fromChar(hexSymbols[Nat8.toNat(byte % 16)]);
      acc # highNibble # lowNibble;
    });
    Map.set(patient, thash, id, data);
    return "Upload Succefull!"# id;
  };
  
  public query func GetMedicaldata(id: Text): async ?Types.getInfo{
    return Map.get(patient, thash, id)
  };
};
