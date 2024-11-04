import Text "mo:base/Text";
import Blob "mo:base/Blob";
import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";
import Types "types";
import SHA3 "mo:sha3";
import Map "mo:map/Map";
import {thash} "mo:map/Map";


module Mod {
    public func GetID(patientBirthDate: Text, patientFullName: Text): Types.ID {
        var sha = SHA3.Keccak(256);
        let name = Blob.toArray(Text.encodeUtf8(patientFullName));
        let bd = Blob.toArray(Text.encodeUtf8(patientBirthDate));
        sha.update(name);
        sha.update(bd);
        let result = sha.finalize();
        let hexSymbols = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];
            let idToReturn:Types.ID = Array.foldLeft<Nat8, Text>(result, "", func (acc, byte) {
            let highNibble = Text.fromChar(hexSymbols[Nat8.toNat((byte / 16)) % 16]);
            let lowNibble = Text.fromChar(hexSymbols[Nat8.toNat(byte % 16)]);
            acc # highNibble # lowNibble;
        });
        return idToReturn;
    };
    public func Look4Patient(dataBase:Types.DataBase, id:Types.ID): ?Types.Patient {
        return Map.get(dataBase, thash, id);
    };

}