import Nat "mo:base/Nat";
import Result "mo:base/Result";
import Map "mo:map/Map";

module Types{
    public type Date = Text;
    public type ID = Text;
    public type RequestID = {
        patientBirthDate: Text;
        patientFullName: Text
    };
    public type RequestDate = {
        patientBirthDate: Text;
        patientFullName: Text;
        date: Text;
    };
    public type Fields = {
        patientFullName: Text;
        patientBirthDate: Text;
        patientAge: Nat;
        patientDiagnosis: Text;
    //     medicine: Text;
    //     condition: Text;
    //     medication: Text;
    //     lastVisit: Text;
    };
    public type Patient = Map.Map<Date, Fields>;
    public type GetAllData = [(Date,Fields)];
    public type GetSingleData = Fields
};