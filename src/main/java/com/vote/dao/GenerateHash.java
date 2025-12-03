package com.vote.dao;
import org.mindrot.jbcrypt.BCrypt;

public class GenerateHash {
    public static void main(String[] args) {
        String password = "admin123";
        String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
        System.out.println("Hash généré : " + hashed);
    }
}
