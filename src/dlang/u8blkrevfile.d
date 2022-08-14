// --------------------------------------------------------------------- //
//                                                                       //
// --------------------------------------------------------------------- //
// 
// Copyright 2021 Raphael Couturier <the.real.zumkyzek.2013@outlook.com>
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// 
// --------------------------------------------------------------------- //
//                                                                       //
// --------------------------------------------------------------------- //
import std.conv;
import std.file;
static import std.file;
import std.stdio;
import std.format;
import std.string;
import std.algorithm;
import std.conv : to;
import std.typecons;
//
string U8BlkRevFile_OutputPath_s_GLOBAL="";
uint U8BlkRevFile_SmpBlk_n_GLOBAL=1024;
//
void U8BlkRevFile_FromFile_FUNC(File File_o_ARGS,uint SmpLen_n_ARGS)
{
    auto Data_a_u8_LOCAL=new ubyte[U8BlkRevFile_SmpBlk_n_GLOBAL];
    uint SmpLen_n_LOCAL=SmpLen_n_ARGS;
    uint SmpBlk_n_LOCAL=U8BlkRevFile_SmpBlk_n_GLOBAL;
    uint IdxO_n_LOCAL=0;
    uint IdxI_n_LOCAL=0;
    uint IdxJ_n_LOCAL=0;
    while (0<SmpLen_n_LOCAL)
    {
        if (SmpLen_n_LOCAL<SmpBlk_n_LOCAL)
        {
            SmpBlk_n_LOCAL=SmpLen_n_LOCAL;
        }
        Data_a_u8_LOCAL=File_o_ARGS.rawRead(Data_a_u8_LOCAL);
        IdxO_n_LOCAL=Data_a_u8_LOCAL.length;
        if (0<IdxO_n_LOCAL)
        {
            IdxI_n_LOCAL=0;
            IdxJ_n_LOCAL=IdxO_n_LOCAL-1;
            while (IdxJ_n_LOCAL>IdxI_n_LOCAL)
            {
                ubyte V_u8_LOCAL=Data_a_u8_LOCAL[IdxJ_n_LOCAL];
                Data_a_u8_LOCAL[IdxJ_n_LOCAL]=Data_a_u8_LOCAL[IdxI_n_LOCAL];
                --IdxJ_n_LOCAL;
                Data_a_u8_LOCAL[IdxI_n_LOCAL]=V_u8_LOCAL;
                ++IdxI_n_LOCAL;
            }
            std.file.append(U8BlkRevFile_OutputPath_s_GLOBAL,Data_a_u8_LOCAL);
        }
        SmpLen_n_LOCAL-=SmpBlk_n_LOCAL;
    }
}
//
int U8BlkRevFile_FromName_FUNC(string FilePath_s_ARGS)
{
    if (U8BlkRevFile_OutputPath_s_GLOBAL.exists)
    {
        remove(U8BlkRevFile_OutputPath_s_GLOBAL);
    }

    auto File_o_LOCAL=File(FilePath_s_ARGS,"rb");
    File_o_LOCAL.seek(0,SEEK_END);
    uint RawSize_n_LOCAL=cast(uint)File_o_LOCAL.tell();
    uint SmpLen_n_LOCAL=RawSize_n_LOCAL/1;
    File_o_LOCAL.seek(0,SEEK_SET);

    U8BlkRevFile_FromFile_FUNC(File_o_LOCAL,SmpLen_n_LOCAL);

    File_o_LOCAL.close();

    return 0;
}
//
int U8BlkRevFile_main_FUNC(string[] ArgsFull_a_ARGS)
{
    if (0<ArgsFull_a_ARGS.length)
    {
        bool ParamCan_b_LOCAL=true;
        bool SmpBlk_b_LOCAL=false;
        bool OutputPath_b_LOCAL=false;
        foreach (string WordArg_s_LOCAL; ArgsFull_a_ARGS)
        {
            if (ParamCan_b_LOCAL && SmpBlk_b_LOCAL)
            {
                U8BlkRevFile_SmpBlk_n_GLOBAL=parse!uint(WordArg_s_LOCAL);
                SmpBlk_b_LOCAL=false;
            }
            else if (ParamCan_b_LOCAL && OutputPath_b_LOCAL)
            {
                U8BlkRevFile_OutputPath_s_GLOBAL=WordArg_s_LOCAL;
                OutputPath_b_LOCAL=false;
            }
            else if (ParamCan_b_LOCAL && ("-s"==WordArg_s_LOCAL || "--block-size"==WordArg_s_LOCAL))
            {
                SmpBlk_b_LOCAL=true;
            }
            else if (ParamCan_b_LOCAL && ("-o"==WordArg_s_LOCAL || "--output"==WordArg_s_LOCAL))
            {
                OutputPath_b_LOCAL=true;
            }
            else
            {
                ParamCan_b_LOCAL=false;
                int Result_n_LOCAL=U8BlkRevFile_FromName_FUNC(WordArg_s_LOCAL);
                if (0!=Result_n_LOCAL)
                {
                    return Result_n_LOCAL;
                }
            }
        }
    }

    return 0;
}
//
int main(string[] ArgsFull_a_ARGS)
{
    if (null!=ArgsFull_a_ARGS && 0<ArgsFull_a_ARGS.length)
    {
        string[] ArgsFull_a_LOCAL=ArgsFull_a_ARGS[1..$];
        return U8BlkRevFile_main_FUNC(ArgsFull_a_LOCAL);
    }

    return 0;
}

// --- //
