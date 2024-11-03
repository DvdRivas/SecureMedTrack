import Types "types";
import Map "mo:map/Map";
import {thash} "mo:map/Map";
import Text "mo:base/Text";
import Nat "mo:base/Nat";

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
    Map.set(patient, thash, data.patientFullName, data);
    return "Upload Succefull!";
  };

  public query func GetMedicaldata(id: Text): async ?Types.getInfo{
    return Map.get(patient, thash, id)
  };
};
