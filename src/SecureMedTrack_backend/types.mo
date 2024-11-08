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
        patientDiagnosis: Text;
    //     medicine: Text;
    //     condition: Text;
    //     medication: Text;
    };
    public type Record = {
        patientFullName: Text;
        patientBirthDate: Text;
        patientDiagnosis: Text;
        patientAge: Nat;
    //     medicine: Text;
    //     condition: Text;
    //     medication: Text;
    //     lastVisit: Text;
    };
    public type Patient = Map.Map<Date, Record>;
    public type GetAllData = [(Date,Record)];
    public type GetSingleData = Record;
    public type DataBase = Map.Map<ID, Patient>;
};