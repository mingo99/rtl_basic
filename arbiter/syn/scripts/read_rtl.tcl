#记录DC过程中对RTL做的修改，给后面形式验证等step提供
set_svf "read_rtl.svf"

#读入RTL，语法分析
analyze -f sverilog {
    ../src/rtl/mtx_arb.v
    ../src/rtl/pri_arb.v
    ../src/rtl/rr_arb.v
}
#构建层次关系
elaborate $TOP_LEVEL > ./log/elaborate.log

current_design $TOP_LEVEL
#检查综合工程中是否缺少子模块
link
which sram.db
if {[link] == 0} {
    #echo "Link Error"
    exit
}

#例化模块的名字修改
uniquify

#网表中可能存在assign语句，这会对布局布线产生影响,可能原因有：1.多个输出port连接在一个内部net上; 2.从输入port不经过任何逻辑直接到输出port上; 3.三态门引起的assign
#为了解决1和2，可以在综合前使用如下语句
set_fix_multiple_port_nets -all -buffer_constants

check_design > ./log/check_design.log

#GTECH网表
write -f verilog -hier -output ./out/${TOP_LEVEL}_pre.v
write -f ddc -hier -output ./out/${TOP_LEVEL}_pre.ddc

