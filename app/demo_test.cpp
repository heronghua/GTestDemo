#include <gtest/gtest.h>
#include <android/log.h>

int add(int a, int b)
{
    return a+b;
}

TEST(MathTest,Addition)
{
    EXPECT_EQ(add(2,3),5);
    EXPECT_EQ(add(-1,1),0);
    EXPECT_EQ(add(100,200),300);
}

TEST(AndroidLogTest,Output)
{
    __android_log_print(ANDROID_LOG_INFO,"GTest","Running Android test");
    EXPECT_TRUE(true);
}

int main(int argc, char **argv)
{
    ::testing::InitGoogleTest(&argc,argv);
    return RUN_ALL_TESTS();
}
