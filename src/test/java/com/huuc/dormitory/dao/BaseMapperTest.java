package com.huuc.dormitory.dao;

import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

/**
 * Mapper测试基类
 * 加载Spring DAO上下文，使用事务自动回滚
 */
@ExtendWith(SpringExtension.class)
@ContextConfiguration(locations = "classpath:spring/spring-dao-test.xml")
@Transactional
@Sql(scripts = "classpath:test.sql", executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD)
public abstract class BaseMapperTest {
}
