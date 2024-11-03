import Nat "mo:base/Nat";
import Result "mo:base/Result";
import Map "mo:map/Map";

module Types{
    public type Name = Text;
    public type Patient = {
    //     id: Int;
        date: Text;
        patientFullName: Text;
        patientAge: Nat;
        patientDiagnosis: Text;
    //     medicine: Text;
    //     condition: Text;
    //     medication: Text;
    //     lastVisit: Text;
    };
    public type getInfo = Patient;
};