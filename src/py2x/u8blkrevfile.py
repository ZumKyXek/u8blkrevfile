#!env python2
# --------------------------------------------------------------------- #
#                                                                       #
# --------------------------------------------------------------------- #
# 
# Copyright 2021 Raphael Couturier <the.real.zumkyzek.2013@outlook.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# 
# --------------------------------------------------------------------- #
#                                                                       #
# --------------------------------------------------------------------- #
import os
import sys
import array
import string
#
U8BlkRevFile_OutputPath_s_GLOBAL=""
U8BlkRevFile_SmpBlk_n_GLOBAL=1024
#
def U8BlkRevFile_FromFile_FUNC(File_o_ARGS,SmpLen_n_ARGS):
    #
    global U8BlkRevFile_SmpBlk_n_GLOBAL
    global U8BlkRevFile_OutputPath_s_GLOBAL
    #
    File_o_LOCAL=open(U8BlkRevFile_OutputPath_s_GLOBAL, 'ab')
    #
    SmpLen_n_LOCAL=SmpLen_n_ARGS
    SmpBlk_n_LOCAL=U8BlkRevFile_SmpBlk_n_GLOBAL
    #
    while 0<SmpLen_n_LOCAL:
        #
        if SmpLen_n_LOCAL<SmpBlk_n_LOCAL:
            SmpBlk_n_LOCAL=SmpLen_n_LOCAL
        #
        Data_a_u8_LOCAL=array.array('B')
        try:
            Data_a_u8_LOCAL.fromfile(File_o_ARGS,SmpBlk_n_LOCAL)
        except:
            SmpLen_n_LOCAL=0
        #
        IdxO_n_LOCAL=len(Data_a_u8_LOCAL)
        if 0<IdxO_n_LOCAL:
            #
            IdxI_n_LOCAL=0
            IdxJ_n_LOCAL=IdxO_n_LOCAL-1
            #
            while IdxJ_n_LOCAL>IdxI_n_LOCAL:
                #
                V_u8_LOCAL=Data_a_u8_LOCAL[IdxJ_n_LOCAL]
                Data_a_u8_LOCAL[IdxJ_n_LOCAL]=Data_a_u8_LOCAL[IdxI_n_LOCAL]
                IdxJ_n_LOCAL-=1
                Data_a_u8_LOCAL[IdxI_n_LOCAL]=V_u8_LOCAL
                IdxI_n_LOCAL+=1
                #
            #
            Data_a_u8_LOCAL.tofile(File_o_LOCAL)
            #
        #
        Data_a_u8_LOCAL=None
        SmpLen_n_LOCAL-=SmpBlk_n_LOCAL
        #
    #
    File_o_LOCAL.close()
    File_o_LOCAL=None
    #
def U8BlkRevFile_FromName_FUNC(FilePath_s_ARGS):
    #
    if "-"!=FilePath_s_ARGS:
        #
        File_o_LOCAL=open(FilePath_s_ARGS, 'rb')
        #
        File_o_LOCAL.seek(0,os.SEEK_END)
        SmpLen_n_LOCAL=File_o_LOCAL.tell()
        File_o_LOCAL.seek(0,os.SEEK_SET)
        #
        U8BlkRevFile_FromFile_FUNC(File_o_LOCAL,SmpLen_n_LOCAL)
        File_o_LOCAL.close()
        #
    else:
        #
        U8BlkRevFile_FromFile_FUNC(sys.stdin)
        #
    #
    return 0
    #
#
def U8BlkRevFile_main_FUNC(ArgsFull_a_s_ARGS):
    #
    global U8BlkRevFile_SmpBlk_n_GLOBAL
    global U8BlkRevFile_OutputPath_s_GLOBAL
    #
    if 0<len(ArgsFull_a_s_ARGS):
        #
        ParamCan_b_LOCAL=True
        SmpBlk_b_LOCAL=False
        OutputPath_b_LOCAL=False
        for WordArg_s_LOCAL in ArgsFull_a_s_ARGS:
            #
            if ParamCan_b_LOCAL and SmpBlk_b_LOCAL:
                #
                U8BlkRevFile_SmpBlk_n_GLOBAL=int(WordArg_s_LOCAL)
                SmpBlk_b_LOCAL=False
                #
            #
            elif ParamCan_b_LOCAL and OutputPath_b_LOCAL:
                #
                U8BlkRevFile_OutputPath_s_GLOBAL=WordArg_s_LOCAL
                OutputPath_b_LOCAL=False
                #
            #
            elif ParamCan_b_LOCAL and (WordArg_s_LOCAL=="-s" or WordArg_s_LOCAL=="--block-size"):
                #
                SmpBlk_b_LOCAL=True
                #
            #
            elif ParamCan_b_LOCAL and (WordArg_s_LOCAL=="-o" or WordArg_s_LOCAL=="--output"):
                #
                OutputPath_b_LOCAL=True
                #
            #
            else:
                #
                ParamCan_b_LOCAL=False
                Result_n_LOCAL=U8BlkRevFile_FromName_FUNC(WordArg_s_LOCAL)
                if 0!=Result_n_LOCAL:
                    #
                    return Result_n_LOCAL
                    #
                #
            #
        #
    #
    return 0
    #
#
if __name__ == '__main__':
    #
    U8BlkRevFile_main_FUNC(sys.argv[1:])
    #
#
