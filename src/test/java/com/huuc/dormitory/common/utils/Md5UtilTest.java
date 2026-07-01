package com.huuc.dormitory.common.utils;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Md5Util单元测试
 */
@DisplayName("Md5Util工具类测试")
class Md5UtilTest {

    @Test
    @DisplayName("encrypt_正常加密_返回32位小写十六进制")
    void encrypt_正常加密_返回32位小写十六进制() {
        String result = Md5Util.encrypt("test123");

        assertNotNull(result);
        assertEquals(32, result.length());
        assertTrue(result.matches("[0-9a-f]+"));
    }

    @Test
    @DisplayName("encrypt_相同输入_返回相同结果")
    void encrypt_相同输入_返回相同结果() {
        String result1 = Md5Util.encrypt("password");
        String result2 = Md5Util.encrypt("password");

        assertEquals(result1, result2);
    }

    @Test
    @DisplayName("encrypt_不同输入_返回不同结果")
    void encrypt_不同输入_返回不同结果() {
        String result1 = Md5Util.encrypt("password1");
        String result2 = Md5Util.encrypt("password2");

        assertNotEquals(result1, result2);
    }

    @Test
    @DisplayName("encrypt_输入null_返回null")
    void encrypt_输入null_返回null() {
        String result = Md5Util.encrypt(null);

        assertNull(result);
    }

    @Test
    @DisplayName("verify_密码匹配_返回true")
    void verify_密码匹配_返回true() {
        String password = "huuc13800138000";
        String encrypted = Md5Util.encrypt(password);

        assertTrue(Md5Util.verify(password, encrypted));
    }

    @Test
    @DisplayName("verify_密码不匹配_返回false")
    void verify_密码不匹配_返回false() {
        String encrypted = Md5Util.encrypt("correct_password");

        assertFalse(Md5Util.verify("wrong_password", encrypted));
    }

    @Test
    @DisplayName("verify_密码为null_返回false")
    void verify_密码为null_返回false() {
        String encrypted = Md5Util.encrypt("password");

        assertFalse(Md5Util.verify(null, encrypted));
    }

    @Test
    @DisplayName("verify_加密密码为null_返回false")
    void verify_加密密码为null_返回false() {
        assertFalse(Md5Util.verify("password", null));
    }

    @Test
    @DisplayName("verify_两者都为null_返回false")
    void verify_两者都为null_返回false() {
        assertFalse(Md5Util.verify(null, null));
    }
}
