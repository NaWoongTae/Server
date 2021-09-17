﻿using System;
using System.Collections.Generic;
using System.Text;

namespace PacketGenerator
{
    class PacketFormat
    {
        // ======================= [ 파일 포멧 ] ===================================
        
        // {0} 패킷 이름/번호 목록
        // {1} 패킷 목록
        public static string fileFormat =
@"using System;
using System.Text;
using System.Collections.Generic;
using ServerCore;

// version 0.0.5

public enum PacketID 
{{{0}
}}
{1}";
        // {0} 패킷 이름
        // {1} 패킷 번호
        public static string packetEnumFormat = @"{0} = {1},";

        // ======================= [ 패킷 포멧 ] ===================================

        // {0} 패킷 이름
        // {1} 멤버 변수들
        // {2} 멤버변수 Read
        // {3} 멤버변수 Write
        public static string packetFormat =
@"
class {0}
{{
    {1}

    public void Read(ArraySegment<byte> segment)
    {{
        ushort count = 0;

        ReadOnlySpan<byte> s = new ReadOnlySpan<byte>(segment.Array, segment.Offset, segment.Count);
        count += sizeof(ushort);
        count += sizeof(ushort);

        {2}
    }}

    public ArraySegment<byte> Write()
    {{
        ArraySegment<byte> segment = SendBufferHelper.Open(4096);

        ushort count = 0;
        bool success = true;

        Span<byte> s = new Span<byte>(segment.Array, segment.Offset, segment.Count);

        count += sizeof(ushort);
        success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), (ushort)PacketID.{0});
        count += sizeof(ushort);

        {3}

        success &= BitConverter.TryWriteBytes(s, count);

        if (success == false)
            return null;

        return SendBufferHelper.Close(count);
    }}
}}";
        // {0} 변수 형식
        // {1} 변수 이름
        public static string memberFormat = @"public {0} {1};";

        // {0} 리스트 이름 [대문자]
        // {1} 리스트 이름 [소문자]
        // {2} 멤버 변수들
        // {3} 멤버변수 Read
        // {4} 멤버변수 Write
        public static string memberListFormat =
@"
public class {0}
{{
    {2}

    public void Read(ArraySegment<byte> segment, ref ushort count)
    {{
        ReadOnlySpan<byte> s = new ReadOnlySpan<byte>(segment.Array, segment.Offset, segment.Count);

        {3}
    }}

    public bool Write(ArraySegment<byte> segment, ref ushort count)
    {{
        Span<byte> s = new Span<byte>(segment.Array, segment.Offset, segment.Count);
        bool success = true;

        {4}

        return success;
    }}
}}

public List<{0}> {1}s = new List<{0}>();";

        // {0} 리스트이름 [대문자]
        // {1} 리스트이름 [소문자]
        public static string readListFormat =
@"this.{1}s.Clear();
ushort {1}Len = BitConverter.ToUInt16(s.Slice(count, s.Length - count));
count += sizeof(ushort);
for (int i = 0; i < {1}Len; i++)
{{
    {0} {1} = new {0}();
    {1}.Read(segment, ref count);
    {1}s.Add({1});
}}";

        // {0} 리스트이름 [대문자]
        // {1} 리스트이름 [소문자]
        public static string writeListFormat =
@"success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), (ushort)this.{1}s.Count);
count += sizeof(ushort);
foreach ({0} {1} in this.{1}s)
{{
    success &= {1}.Write(segment, ref count);
}}";

        // {0} 변수 이름
        // {1} To~ 변수 형식
        // {2} 변수 형식
        public static string readFormat =
@"this.{0} = BitConverter.{1}(s.Slice(count, s.Length - count));
count += sizeof({2});";

        // {0} 변수 이름
        public static string readStringFormat =
@"ushort {0}Len = BitConverter.ToUInt16(s.Slice(count, s.Length - count));
count += sizeof(ushort);
{0} = Encoding.Unicode.GetString(s.Slice(count, {0}Len));
count += {0}Len;";

        // {0} 변수 이름
        // {1} 변수 형식
        public static string writeFormat =
@"success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), this.{0});
count += sizeof({1});";

        // {0} 변수 이름
        public static string writeStringFormat =
@"ushort {0}Len = (ushort)Encoding.Unicode.GetBytes(this.{0}, 0, this.{0}.Length, segment.Array, segment.Offset + count + sizeof(ushort));
success &= BitConverter.TryWriteBytes(s.Slice(count, s.Length - count), {0}Len);
count += (ushort)(sizeof(ushort) + {0}Len);";

        // {0} 변수 이름
        // {1} 변수 형식 byte, sbyte
        public static string readByteFormat =
@"this.{0} = ({1})segment.Array[segment.Offset + count];
count += sizeof({1});";

        // {0} 변수 이름
        // {1} 변수 형식 byte, sbyte
        public static string writeByteFormat =
@"segment.Array[segment.Offset + count] = (byte)this.{0};
count += sizeof({1});";


        //s.ToArray(), count + sizeof(ushort));
    }
}
