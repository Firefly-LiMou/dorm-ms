package com.huuc.dormitory.common.utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * MD5加密工具类
 */
public class Md5Util {

    /**
     * 对字符串进行MD5加密
     *
     * @param source 原始字符串
     * @return 32位小写十六进制MD5值，source为null时返回null
     */
    public static String encrypt(String source) {
        if (source == null) {
            return null;
        }
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] bytes = md.digest(source.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                String hex = Integer.toHexString(b & 0xFF);
                if (hex.length() < 2) {
                    sb.append(0);
                }
                sb.append(hex);
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("MD5加密失败", e);
        }
    }

    /**
     * 验证密码是否正确
     *
     * @param password         明文密码
     * @param encryptedPassword 加密后的密码
     * @return 密码匹配返回true，否则返回false
     */
    public static boolean verify(String password, String encryptedPassword) {
        if (password == null || encryptedPassword == null) {
            return false;
        }
        return encrypt(password).equals(encryptedPassword);
    }
}
