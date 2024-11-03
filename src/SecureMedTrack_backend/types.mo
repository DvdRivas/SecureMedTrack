import Nat "mo:base/Nat";
import Result "mo:base/Result";
import Map "mo:map/Map";

module Types{
    public type Name = Text;
    public type Patient = {
        // id: Text;
        date: Text;
        patientFullName: Text;
        patientbrithDate: Text;
        patientAge: Nat;
        patientDiagnosis: Text;
    //     medicine: Text;
    //     condition: Text;
    //     medication: Text;
    //     lastVisit: Text;
    };
    public type getInfo = Patient;
};