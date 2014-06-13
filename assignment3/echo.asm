
_echo:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 20             	sub    $0x20,%esp
  int i;

  for(i = 1; i < argc; i++)
    1009:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    1010:	00 
    1011:	eb 48                	jmp    105b <main+0x5b>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
    1013:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1017:	40                   	inc    %eax
    1018:	3b 45 08             	cmp    0x8(%ebp),%eax
    101b:	7d 07                	jge    1024 <main+0x24>
    101d:	b8 ff 17 00 00       	mov    $0x17ff,%eax
    1022:	eb 05                	jmp    1029 <main+0x29>
    1024:	b8 01 18 00 00       	mov    $0x1801,%eax
    1029:	8b 54 24 1c          	mov    0x1c(%esp),%edx
    102d:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
    1034:	8b 55 0c             	mov    0xc(%ebp),%edx
    1037:	01 ca                	add    %ecx,%edx
    1039:	8b 12                	mov    (%edx),%edx
    103b:	89 44 24 0c          	mov    %eax,0xc(%esp)
    103f:	89 54 24 08          	mov    %edx,0x8(%esp)
    1043:	c7 44 24 04 03 18 00 	movl   $0x1803,0x4(%esp)
    104a:	00 
    104b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1052:	e8 e1 03 00 00       	call   1438 <printf>
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
    1057:	ff 44 24 1c          	incl   0x1c(%esp)
    105b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    105f:	3b 45 08             	cmp    0x8(%ebp),%eax
    1062:	7c af                	jl     1013 <main+0x13>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
    1064:	e8 4f 02 00 00       	call   12b8 <exit>
    1069:	66 90                	xchg   %ax,%ax
    106b:	90                   	nop

0000106c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    106c:	55                   	push   %ebp
    106d:	89 e5                	mov    %esp,%ebp
    106f:	57                   	push   %edi
    1070:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1071:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1074:	8b 55 10             	mov    0x10(%ebp),%edx
    1077:	8b 45 0c             	mov    0xc(%ebp),%eax
    107a:	89 cb                	mov    %ecx,%ebx
    107c:	89 df                	mov    %ebx,%edi
    107e:	89 d1                	mov    %edx,%ecx
    1080:	fc                   	cld    
    1081:	f3 aa                	rep stos %al,%es:(%edi)
    1083:	89 ca                	mov    %ecx,%edx
    1085:	89 fb                	mov    %edi,%ebx
    1087:	89 5d 08             	mov    %ebx,0x8(%ebp)
    108a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    108d:	5b                   	pop    %ebx
    108e:	5f                   	pop    %edi
    108f:	5d                   	pop    %ebp
    1090:	c3                   	ret    

00001091 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1091:	55                   	push   %ebp
    1092:	89 e5                	mov    %esp,%ebp
    1094:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1097:	8b 45 08             	mov    0x8(%ebp),%eax
    109a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    109d:	90                   	nop
    109e:	8b 45 0c             	mov    0xc(%ebp),%eax
    10a1:	8a 10                	mov    (%eax),%dl
    10a3:	8b 45 08             	mov    0x8(%ebp),%eax
    10a6:	88 10                	mov    %dl,(%eax)
    10a8:	8b 45 08             	mov    0x8(%ebp),%eax
    10ab:	8a 00                	mov    (%eax),%al
    10ad:	84 c0                	test   %al,%al
    10af:	0f 95 c0             	setne  %al
    10b2:	ff 45 08             	incl   0x8(%ebp)
    10b5:	ff 45 0c             	incl   0xc(%ebp)
    10b8:	84 c0                	test   %al,%al
    10ba:	75 e2                	jne    109e <strcpy+0xd>
    ;
  return os;
    10bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10bf:	c9                   	leave  
    10c0:	c3                   	ret    

000010c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10c1:	55                   	push   %ebp
    10c2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10c4:	eb 06                	jmp    10cc <strcmp+0xb>
    p++, q++;
    10c6:	ff 45 08             	incl   0x8(%ebp)
    10c9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10cc:	8b 45 08             	mov    0x8(%ebp),%eax
    10cf:	8a 00                	mov    (%eax),%al
    10d1:	84 c0                	test   %al,%al
    10d3:	74 0e                	je     10e3 <strcmp+0x22>
    10d5:	8b 45 08             	mov    0x8(%ebp),%eax
    10d8:	8a 10                	mov    (%eax),%dl
    10da:	8b 45 0c             	mov    0xc(%ebp),%eax
    10dd:	8a 00                	mov    (%eax),%al
    10df:	38 c2                	cmp    %al,%dl
    10e1:	74 e3                	je     10c6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10e3:	8b 45 08             	mov    0x8(%ebp),%eax
    10e6:	8a 00                	mov    (%eax),%al
    10e8:	0f b6 d0             	movzbl %al,%edx
    10eb:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ee:	8a 00                	mov    (%eax),%al
    10f0:	0f b6 c0             	movzbl %al,%eax
    10f3:	89 d1                	mov    %edx,%ecx
    10f5:	29 c1                	sub    %eax,%ecx
    10f7:	89 c8                	mov    %ecx,%eax
}
    10f9:	5d                   	pop    %ebp
    10fa:	c3                   	ret    

000010fb <strlen>:

uint
strlen(char *s)
{
    10fb:	55                   	push   %ebp
    10fc:	89 e5                	mov    %esp,%ebp
    10fe:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1101:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1108:	eb 03                	jmp    110d <strlen+0x12>
    110a:	ff 45 fc             	incl   -0x4(%ebp)
    110d:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1110:	8b 45 08             	mov    0x8(%ebp),%eax
    1113:	01 d0                	add    %edx,%eax
    1115:	8a 00                	mov    (%eax),%al
    1117:	84 c0                	test   %al,%al
    1119:	75 ef                	jne    110a <strlen+0xf>
    ;
  return n;
    111b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    111e:	c9                   	leave  
    111f:	c3                   	ret    

00001120 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1120:	55                   	push   %ebp
    1121:	89 e5                	mov    %esp,%ebp
    1123:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1126:	8b 45 10             	mov    0x10(%ebp),%eax
    1129:	89 44 24 08          	mov    %eax,0x8(%esp)
    112d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1130:	89 44 24 04          	mov    %eax,0x4(%esp)
    1134:	8b 45 08             	mov    0x8(%ebp),%eax
    1137:	89 04 24             	mov    %eax,(%esp)
    113a:	e8 2d ff ff ff       	call   106c <stosb>
  return dst;
    113f:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1142:	c9                   	leave  
    1143:	c3                   	ret    

00001144 <strchr>:

char*
strchr(const char *s, char c)
{
    1144:	55                   	push   %ebp
    1145:	89 e5                	mov    %esp,%ebp
    1147:	83 ec 04             	sub    $0x4,%esp
    114a:	8b 45 0c             	mov    0xc(%ebp),%eax
    114d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1150:	eb 12                	jmp    1164 <strchr+0x20>
    if(*s == c)
    1152:	8b 45 08             	mov    0x8(%ebp),%eax
    1155:	8a 00                	mov    (%eax),%al
    1157:	3a 45 fc             	cmp    -0x4(%ebp),%al
    115a:	75 05                	jne    1161 <strchr+0x1d>
      return (char*)s;
    115c:	8b 45 08             	mov    0x8(%ebp),%eax
    115f:	eb 11                	jmp    1172 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1161:	ff 45 08             	incl   0x8(%ebp)
    1164:	8b 45 08             	mov    0x8(%ebp),%eax
    1167:	8a 00                	mov    (%eax),%al
    1169:	84 c0                	test   %al,%al
    116b:	75 e5                	jne    1152 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    116d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1172:	c9                   	leave  
    1173:	c3                   	ret    

00001174 <gets>:

char*
gets(char *buf, int max)
{
    1174:	55                   	push   %ebp
    1175:	89 e5                	mov    %esp,%ebp
    1177:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    117a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1181:	eb 42                	jmp    11c5 <gets+0x51>
    cc = read(0, &c, 1);
    1183:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    118a:	00 
    118b:	8d 45 ef             	lea    -0x11(%ebp),%eax
    118e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1192:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1199:	e8 32 01 00 00       	call   12d0 <read>
    119e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11a5:	7e 29                	jle    11d0 <gets+0x5c>
      break;
    buf[i++] = c;
    11a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11aa:	8b 45 08             	mov    0x8(%ebp),%eax
    11ad:	01 c2                	add    %eax,%edx
    11af:	8a 45 ef             	mov    -0x11(%ebp),%al
    11b2:	88 02                	mov    %al,(%edx)
    11b4:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
    11b7:	8a 45 ef             	mov    -0x11(%ebp),%al
    11ba:	3c 0a                	cmp    $0xa,%al
    11bc:	74 13                	je     11d1 <gets+0x5d>
    11be:	8a 45 ef             	mov    -0x11(%ebp),%al
    11c1:	3c 0d                	cmp    $0xd,%al
    11c3:	74 0c                	je     11d1 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11c8:	40                   	inc    %eax
    11c9:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11cc:	7c b5                	jl     1183 <gets+0xf>
    11ce:	eb 01                	jmp    11d1 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    11d0:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11d4:	8b 45 08             	mov    0x8(%ebp),%eax
    11d7:	01 d0                	add    %edx,%eax
    11d9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11df:	c9                   	leave  
    11e0:	c3                   	ret    

000011e1 <stat>:

int
stat(char *n, struct stat *st)
{
    11e1:	55                   	push   %ebp
    11e2:	89 e5                	mov    %esp,%ebp
    11e4:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11e7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11ee:	00 
    11ef:	8b 45 08             	mov    0x8(%ebp),%eax
    11f2:	89 04 24             	mov    %eax,(%esp)
    11f5:	e8 fe 00 00 00       	call   12f8 <open>
    11fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    11fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1201:	79 07                	jns    120a <stat+0x29>
    return -1;
    1203:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1208:	eb 23                	jmp    122d <stat+0x4c>
  r = fstat(fd, st);
    120a:	8b 45 0c             	mov    0xc(%ebp),%eax
    120d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1211:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1214:	89 04 24             	mov    %eax,(%esp)
    1217:	e8 f4 00 00 00       	call   1310 <fstat>
    121c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    121f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1222:	89 04 24             	mov    %eax,(%esp)
    1225:	e8 b6 00 00 00       	call   12e0 <close>
  return r;
    122a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    122d:	c9                   	leave  
    122e:	c3                   	ret    

0000122f <atoi>:

int
atoi(const char *s)
{
    122f:	55                   	push   %ebp
    1230:	89 e5                	mov    %esp,%ebp
    1232:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1235:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    123c:	eb 21                	jmp    125f <atoi+0x30>
    n = n*10 + *s++ - '0';
    123e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1241:	89 d0                	mov    %edx,%eax
    1243:	c1 e0 02             	shl    $0x2,%eax
    1246:	01 d0                	add    %edx,%eax
    1248:	d1 e0                	shl    %eax
    124a:	89 c2                	mov    %eax,%edx
    124c:	8b 45 08             	mov    0x8(%ebp),%eax
    124f:	8a 00                	mov    (%eax),%al
    1251:	0f be c0             	movsbl %al,%eax
    1254:	01 d0                	add    %edx,%eax
    1256:	83 e8 30             	sub    $0x30,%eax
    1259:	89 45 fc             	mov    %eax,-0x4(%ebp)
    125c:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    125f:	8b 45 08             	mov    0x8(%ebp),%eax
    1262:	8a 00                	mov    (%eax),%al
    1264:	3c 2f                	cmp    $0x2f,%al
    1266:	7e 09                	jle    1271 <atoi+0x42>
    1268:	8b 45 08             	mov    0x8(%ebp),%eax
    126b:	8a 00                	mov    (%eax),%al
    126d:	3c 39                	cmp    $0x39,%al
    126f:	7e cd                	jle    123e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1271:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1274:	c9                   	leave  
    1275:	c3                   	ret    

00001276 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1276:	55                   	push   %ebp
    1277:	89 e5                	mov    %esp,%ebp
    1279:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    127c:	8b 45 08             	mov    0x8(%ebp),%eax
    127f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1282:	8b 45 0c             	mov    0xc(%ebp),%eax
    1285:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1288:	eb 10                	jmp    129a <memmove+0x24>
    *dst++ = *src++;
    128a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    128d:	8a 10                	mov    (%eax),%dl
    128f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1292:	88 10                	mov    %dl,(%eax)
    1294:	ff 45 fc             	incl   -0x4(%ebp)
    1297:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    129a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    129e:	0f 9f c0             	setg   %al
    12a1:	ff 4d 10             	decl   0x10(%ebp)
    12a4:	84 c0                	test   %al,%al
    12a6:	75 e2                	jne    128a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    12a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12ab:	c9                   	leave  
    12ac:	c3                   	ret    
    12ad:	66 90                	xchg   %ax,%ax
    12af:	90                   	nop

000012b0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12b0:	b8 01 00 00 00       	mov    $0x1,%eax
    12b5:	cd 40                	int    $0x40
    12b7:	c3                   	ret    

000012b8 <exit>:
SYSCALL(exit)
    12b8:	b8 02 00 00 00       	mov    $0x2,%eax
    12bd:	cd 40                	int    $0x40
    12bf:	c3                   	ret    

000012c0 <wait>:
SYSCALL(wait)
    12c0:	b8 03 00 00 00       	mov    $0x3,%eax
    12c5:	cd 40                	int    $0x40
    12c7:	c3                   	ret    

000012c8 <pipe>:
SYSCALL(pipe)
    12c8:	b8 04 00 00 00       	mov    $0x4,%eax
    12cd:	cd 40                	int    $0x40
    12cf:	c3                   	ret    

000012d0 <read>:
SYSCALL(read)
    12d0:	b8 05 00 00 00       	mov    $0x5,%eax
    12d5:	cd 40                	int    $0x40
    12d7:	c3                   	ret    

000012d8 <write>:
SYSCALL(write)
    12d8:	b8 10 00 00 00       	mov    $0x10,%eax
    12dd:	cd 40                	int    $0x40
    12df:	c3                   	ret    

000012e0 <close>:
SYSCALL(close)
    12e0:	b8 15 00 00 00       	mov    $0x15,%eax
    12e5:	cd 40                	int    $0x40
    12e7:	c3                   	ret    

000012e8 <kill>:
SYSCALL(kill)
    12e8:	b8 06 00 00 00       	mov    $0x6,%eax
    12ed:	cd 40                	int    $0x40
    12ef:	c3                   	ret    

000012f0 <exec>:
SYSCALL(exec)
    12f0:	b8 07 00 00 00       	mov    $0x7,%eax
    12f5:	cd 40                	int    $0x40
    12f7:	c3                   	ret    

000012f8 <open>:
SYSCALL(open)
    12f8:	b8 0f 00 00 00       	mov    $0xf,%eax
    12fd:	cd 40                	int    $0x40
    12ff:	c3                   	ret    

00001300 <mknod>:
SYSCALL(mknod)
    1300:	b8 11 00 00 00       	mov    $0x11,%eax
    1305:	cd 40                	int    $0x40
    1307:	c3                   	ret    

00001308 <unlink>:
SYSCALL(unlink)
    1308:	b8 12 00 00 00       	mov    $0x12,%eax
    130d:	cd 40                	int    $0x40
    130f:	c3                   	ret    

00001310 <fstat>:
SYSCALL(fstat)
    1310:	b8 08 00 00 00       	mov    $0x8,%eax
    1315:	cd 40                	int    $0x40
    1317:	c3                   	ret    

00001318 <link>:
SYSCALL(link)
    1318:	b8 13 00 00 00       	mov    $0x13,%eax
    131d:	cd 40                	int    $0x40
    131f:	c3                   	ret    

00001320 <mkdir>:
SYSCALL(mkdir)
    1320:	b8 14 00 00 00       	mov    $0x14,%eax
    1325:	cd 40                	int    $0x40
    1327:	c3                   	ret    

00001328 <chdir>:
SYSCALL(chdir)
    1328:	b8 09 00 00 00       	mov    $0x9,%eax
    132d:	cd 40                	int    $0x40
    132f:	c3                   	ret    

00001330 <dup>:
SYSCALL(dup)
    1330:	b8 0a 00 00 00       	mov    $0xa,%eax
    1335:	cd 40                	int    $0x40
    1337:	c3                   	ret    

00001338 <getpid>:
SYSCALL(getpid)
    1338:	b8 0b 00 00 00       	mov    $0xb,%eax
    133d:	cd 40                	int    $0x40
    133f:	c3                   	ret    

00001340 <sbrk>:
SYSCALL(sbrk)
    1340:	b8 0c 00 00 00       	mov    $0xc,%eax
    1345:	cd 40                	int    $0x40
    1347:	c3                   	ret    

00001348 <sleep>:
SYSCALL(sleep)
    1348:	b8 0d 00 00 00       	mov    $0xd,%eax
    134d:	cd 40                	int    $0x40
    134f:	c3                   	ret    

00001350 <uptime>:
SYSCALL(uptime)
    1350:	b8 0e 00 00 00       	mov    $0xe,%eax
    1355:	cd 40                	int    $0x40
    1357:	c3                   	ret    

00001358 <cowfork>:
SYSCALL(cowfork) //3.4
    1358:	b8 16 00 00 00       	mov    $0x16,%eax
    135d:	cd 40                	int    $0x40
    135f:	c3                   	ret    

00001360 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1360:	55                   	push   %ebp
    1361:	89 e5                	mov    %esp,%ebp
    1363:	83 ec 28             	sub    $0x28,%esp
    1366:	8b 45 0c             	mov    0xc(%ebp),%eax
    1369:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    136c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1373:	00 
    1374:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1377:	89 44 24 04          	mov    %eax,0x4(%esp)
    137b:	8b 45 08             	mov    0x8(%ebp),%eax
    137e:	89 04 24             	mov    %eax,(%esp)
    1381:	e8 52 ff ff ff       	call   12d8 <write>
}
    1386:	c9                   	leave  
    1387:	c3                   	ret    

00001388 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1388:	55                   	push   %ebp
    1389:	89 e5                	mov    %esp,%ebp
    138b:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    138e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1395:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1399:	74 17                	je     13b2 <printint+0x2a>
    139b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    139f:	79 11                	jns    13b2 <printint+0x2a>
    neg = 1;
    13a1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13a8:	8b 45 0c             	mov    0xc(%ebp),%eax
    13ab:	f7 d8                	neg    %eax
    13ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13b0:	eb 06                	jmp    13b8 <printint+0x30>
  } else {
    x = xx;
    13b2:	8b 45 0c             	mov    0xc(%ebp),%eax
    13b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
    13c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13c5:	ba 00 00 00 00       	mov    $0x0,%edx
    13ca:	f7 f1                	div    %ecx
    13cc:	89 d0                	mov    %edx,%eax
    13ce:	8a 80 4c 2a 00 00    	mov    0x2a4c(%eax),%al
    13d4:	8d 4d dc             	lea    -0x24(%ebp),%ecx
    13d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
    13da:	01 ca                	add    %ecx,%edx
    13dc:	88 02                	mov    %al,(%edx)
    13de:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
    13e1:	8b 55 10             	mov    0x10(%ebp),%edx
    13e4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    13e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13ea:	ba 00 00 00 00       	mov    $0x0,%edx
    13ef:	f7 75 d4             	divl   -0x2c(%ebp)
    13f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    13f9:	75 c4                	jne    13bf <printint+0x37>
  if(neg)
    13fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13ff:	74 2c                	je     142d <printint+0xa5>
    buf[i++] = '-';
    1401:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1404:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1407:	01 d0                	add    %edx,%eax
    1409:	c6 00 2d             	movb   $0x2d,(%eax)
    140c:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
    140f:	eb 1c                	jmp    142d <printint+0xa5>
    putc(fd, buf[i]);
    1411:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1414:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1417:	01 d0                	add    %edx,%eax
    1419:	8a 00                	mov    (%eax),%al
    141b:	0f be c0             	movsbl %al,%eax
    141e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1422:	8b 45 08             	mov    0x8(%ebp),%eax
    1425:	89 04 24             	mov    %eax,(%esp)
    1428:	e8 33 ff ff ff       	call   1360 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    142d:	ff 4d f4             	decl   -0xc(%ebp)
    1430:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1434:	79 db                	jns    1411 <printint+0x89>
    putc(fd, buf[i]);
}
    1436:	c9                   	leave  
    1437:	c3                   	ret    

00001438 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1438:	55                   	push   %ebp
    1439:	89 e5                	mov    %esp,%ebp
    143b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    143e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1445:	8d 45 0c             	lea    0xc(%ebp),%eax
    1448:	83 c0 04             	add    $0x4,%eax
    144b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    144e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1455:	e9 78 01 00 00       	jmp    15d2 <printf+0x19a>
    c = fmt[i] & 0xff;
    145a:	8b 55 0c             	mov    0xc(%ebp),%edx
    145d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1460:	01 d0                	add    %edx,%eax
    1462:	8a 00                	mov    (%eax),%al
    1464:	0f be c0             	movsbl %al,%eax
    1467:	25 ff 00 00 00       	and    $0xff,%eax
    146c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    146f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1473:	75 2c                	jne    14a1 <printf+0x69>
      if(c == '%'){
    1475:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1479:	75 0c                	jne    1487 <printf+0x4f>
        state = '%';
    147b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1482:	e9 48 01 00 00       	jmp    15cf <printf+0x197>
      } else {
        putc(fd, c);
    1487:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    148a:	0f be c0             	movsbl %al,%eax
    148d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1491:	8b 45 08             	mov    0x8(%ebp),%eax
    1494:	89 04 24             	mov    %eax,(%esp)
    1497:	e8 c4 fe ff ff       	call   1360 <putc>
    149c:	e9 2e 01 00 00       	jmp    15cf <printf+0x197>
      }
    } else if(state == '%'){
    14a1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14a5:	0f 85 24 01 00 00    	jne    15cf <printf+0x197>
      if(c == 'd'){
    14ab:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14af:	75 2d                	jne    14de <printf+0xa6>
        printint(fd, *ap, 10, 1);
    14b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14b4:	8b 00                	mov    (%eax),%eax
    14b6:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    14bd:	00 
    14be:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14c5:	00 
    14c6:	89 44 24 04          	mov    %eax,0x4(%esp)
    14ca:	8b 45 08             	mov    0x8(%ebp),%eax
    14cd:	89 04 24             	mov    %eax,(%esp)
    14d0:	e8 b3 fe ff ff       	call   1388 <printint>
        ap++;
    14d5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14d9:	e9 ea 00 00 00       	jmp    15c8 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
    14de:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    14e2:	74 06                	je     14ea <printf+0xb2>
    14e4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    14e8:	75 2d                	jne    1517 <printf+0xdf>
        printint(fd, *ap, 16, 0);
    14ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14ed:	8b 00                	mov    (%eax),%eax
    14ef:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    14f6:	00 
    14f7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    14fe:	00 
    14ff:	89 44 24 04          	mov    %eax,0x4(%esp)
    1503:	8b 45 08             	mov    0x8(%ebp),%eax
    1506:	89 04 24             	mov    %eax,(%esp)
    1509:	e8 7a fe ff ff       	call   1388 <printint>
        ap++;
    150e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1512:	e9 b1 00 00 00       	jmp    15c8 <printf+0x190>
      } else if(c == 's'){
    1517:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    151b:	75 43                	jne    1560 <printf+0x128>
        s = (char*)*ap;
    151d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1520:	8b 00                	mov    (%eax),%eax
    1522:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1525:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1529:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    152d:	75 25                	jne    1554 <printf+0x11c>
          s = "(null)";
    152f:	c7 45 f4 08 18 00 00 	movl   $0x1808,-0xc(%ebp)
        while(*s != 0){
    1536:	eb 1c                	jmp    1554 <printf+0x11c>
          putc(fd, *s);
    1538:	8b 45 f4             	mov    -0xc(%ebp),%eax
    153b:	8a 00                	mov    (%eax),%al
    153d:	0f be c0             	movsbl %al,%eax
    1540:	89 44 24 04          	mov    %eax,0x4(%esp)
    1544:	8b 45 08             	mov    0x8(%ebp),%eax
    1547:	89 04 24             	mov    %eax,(%esp)
    154a:	e8 11 fe ff ff       	call   1360 <putc>
          s++;
    154f:	ff 45 f4             	incl   -0xc(%ebp)
    1552:	eb 01                	jmp    1555 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1554:	90                   	nop
    1555:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1558:	8a 00                	mov    (%eax),%al
    155a:	84 c0                	test   %al,%al
    155c:	75 da                	jne    1538 <printf+0x100>
    155e:	eb 68                	jmp    15c8 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1560:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1564:	75 1d                	jne    1583 <printf+0x14b>
        putc(fd, *ap);
    1566:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1569:	8b 00                	mov    (%eax),%eax
    156b:	0f be c0             	movsbl %al,%eax
    156e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1572:	8b 45 08             	mov    0x8(%ebp),%eax
    1575:	89 04 24             	mov    %eax,(%esp)
    1578:	e8 e3 fd ff ff       	call   1360 <putc>
        ap++;
    157d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1581:	eb 45                	jmp    15c8 <printf+0x190>
      } else if(c == '%'){
    1583:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1587:	75 17                	jne    15a0 <printf+0x168>
        putc(fd, c);
    1589:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    158c:	0f be c0             	movsbl %al,%eax
    158f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1593:	8b 45 08             	mov    0x8(%ebp),%eax
    1596:	89 04 24             	mov    %eax,(%esp)
    1599:	e8 c2 fd ff ff       	call   1360 <putc>
    159e:	eb 28                	jmp    15c8 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15a0:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    15a7:	00 
    15a8:	8b 45 08             	mov    0x8(%ebp),%eax
    15ab:	89 04 24             	mov    %eax,(%esp)
    15ae:	e8 ad fd ff ff       	call   1360 <putc>
        putc(fd, c);
    15b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15b6:	0f be c0             	movsbl %al,%eax
    15b9:	89 44 24 04          	mov    %eax,0x4(%esp)
    15bd:	8b 45 08             	mov    0x8(%ebp),%eax
    15c0:	89 04 24             	mov    %eax,(%esp)
    15c3:	e8 98 fd ff ff       	call   1360 <putc>
      }
      state = 0;
    15c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    15cf:	ff 45 f0             	incl   -0x10(%ebp)
    15d2:	8b 55 0c             	mov    0xc(%ebp),%edx
    15d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15d8:	01 d0                	add    %edx,%eax
    15da:	8a 00                	mov    (%eax),%al
    15dc:	84 c0                	test   %al,%al
    15de:	0f 85 76 fe ff ff    	jne    145a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    15e4:	c9                   	leave  
    15e5:	c3                   	ret    
    15e6:	66 90                	xchg   %ax,%ax

000015e8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15e8:	55                   	push   %ebp
    15e9:	89 e5                	mov    %esp,%ebp
    15eb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    15ee:	8b 45 08             	mov    0x8(%ebp),%eax
    15f1:	83 e8 08             	sub    $0x8,%eax
    15f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15f7:	a1 68 2a 00 00       	mov    0x2a68,%eax
    15fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    15ff:	eb 24                	jmp    1625 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1601:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1604:	8b 00                	mov    (%eax),%eax
    1606:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1609:	77 12                	ja     161d <free+0x35>
    160b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    160e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1611:	77 24                	ja     1637 <free+0x4f>
    1613:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1616:	8b 00                	mov    (%eax),%eax
    1618:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    161b:	77 1a                	ja     1637 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    161d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1620:	8b 00                	mov    (%eax),%eax
    1622:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1625:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1628:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    162b:	76 d4                	jbe    1601 <free+0x19>
    162d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1630:	8b 00                	mov    (%eax),%eax
    1632:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1635:	76 ca                	jbe    1601 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1637:	8b 45 f8             	mov    -0x8(%ebp),%eax
    163a:	8b 40 04             	mov    0x4(%eax),%eax
    163d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1644:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1647:	01 c2                	add    %eax,%edx
    1649:	8b 45 fc             	mov    -0x4(%ebp),%eax
    164c:	8b 00                	mov    (%eax),%eax
    164e:	39 c2                	cmp    %eax,%edx
    1650:	75 24                	jne    1676 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1652:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1655:	8b 50 04             	mov    0x4(%eax),%edx
    1658:	8b 45 fc             	mov    -0x4(%ebp),%eax
    165b:	8b 00                	mov    (%eax),%eax
    165d:	8b 40 04             	mov    0x4(%eax),%eax
    1660:	01 c2                	add    %eax,%edx
    1662:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1665:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1668:	8b 45 fc             	mov    -0x4(%ebp),%eax
    166b:	8b 00                	mov    (%eax),%eax
    166d:	8b 10                	mov    (%eax),%edx
    166f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1672:	89 10                	mov    %edx,(%eax)
    1674:	eb 0a                	jmp    1680 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1676:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1679:	8b 10                	mov    (%eax),%edx
    167b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    167e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1680:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1683:	8b 40 04             	mov    0x4(%eax),%eax
    1686:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    168d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1690:	01 d0                	add    %edx,%eax
    1692:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1695:	75 20                	jne    16b7 <free+0xcf>
    p->s.size += bp->s.size;
    1697:	8b 45 fc             	mov    -0x4(%ebp),%eax
    169a:	8b 50 04             	mov    0x4(%eax),%edx
    169d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a0:	8b 40 04             	mov    0x4(%eax),%eax
    16a3:	01 c2                	add    %eax,%edx
    16a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16ae:	8b 10                	mov    (%eax),%edx
    16b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b3:	89 10                	mov    %edx,(%eax)
    16b5:	eb 08                	jmp    16bf <free+0xd7>
  } else
    p->s.ptr = bp;
    16b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ba:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16bd:	89 10                	mov    %edx,(%eax)
  freep = p;
    16bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c2:	a3 68 2a 00 00       	mov    %eax,0x2a68
}
    16c7:	c9                   	leave  
    16c8:	c3                   	ret    

000016c9 <morecore>:

static Header*
morecore(uint nu)
{
    16c9:	55                   	push   %ebp
    16ca:	89 e5                	mov    %esp,%ebp
    16cc:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    16cf:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    16d6:	77 07                	ja     16df <morecore+0x16>
    nu = 4096;
    16d8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    16df:	8b 45 08             	mov    0x8(%ebp),%eax
    16e2:	c1 e0 03             	shl    $0x3,%eax
    16e5:	89 04 24             	mov    %eax,(%esp)
    16e8:	e8 53 fc ff ff       	call   1340 <sbrk>
    16ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    16f0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    16f4:	75 07                	jne    16fd <morecore+0x34>
    return 0;
    16f6:	b8 00 00 00 00       	mov    $0x0,%eax
    16fb:	eb 22                	jmp    171f <morecore+0x56>
  hp = (Header*)p;
    16fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1700:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1703:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1706:	8b 55 08             	mov    0x8(%ebp),%edx
    1709:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    170c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    170f:	83 c0 08             	add    $0x8,%eax
    1712:	89 04 24             	mov    %eax,(%esp)
    1715:	e8 ce fe ff ff       	call   15e8 <free>
  return freep;
    171a:	a1 68 2a 00 00       	mov    0x2a68,%eax
}
    171f:	c9                   	leave  
    1720:	c3                   	ret    

00001721 <malloc>:

void*
malloc(uint nbytes)
{
    1721:	55                   	push   %ebp
    1722:	89 e5                	mov    %esp,%ebp
    1724:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1727:	8b 45 08             	mov    0x8(%ebp),%eax
    172a:	83 c0 07             	add    $0x7,%eax
    172d:	c1 e8 03             	shr    $0x3,%eax
    1730:	40                   	inc    %eax
    1731:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1734:	a1 68 2a 00 00       	mov    0x2a68,%eax
    1739:	89 45 f0             	mov    %eax,-0x10(%ebp)
    173c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1740:	75 23                	jne    1765 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    1742:	c7 45 f0 60 2a 00 00 	movl   $0x2a60,-0x10(%ebp)
    1749:	8b 45 f0             	mov    -0x10(%ebp),%eax
    174c:	a3 68 2a 00 00       	mov    %eax,0x2a68
    1751:	a1 68 2a 00 00       	mov    0x2a68,%eax
    1756:	a3 60 2a 00 00       	mov    %eax,0x2a60
    base.s.size = 0;
    175b:	c7 05 64 2a 00 00 00 	movl   $0x0,0x2a64
    1762:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1765:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1768:	8b 00                	mov    (%eax),%eax
    176a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    176d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1770:	8b 40 04             	mov    0x4(%eax),%eax
    1773:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1776:	72 4d                	jb     17c5 <malloc+0xa4>
      if(p->s.size == nunits)
    1778:	8b 45 f4             	mov    -0xc(%ebp),%eax
    177b:	8b 40 04             	mov    0x4(%eax),%eax
    177e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1781:	75 0c                	jne    178f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    1783:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1786:	8b 10                	mov    (%eax),%edx
    1788:	8b 45 f0             	mov    -0x10(%ebp),%eax
    178b:	89 10                	mov    %edx,(%eax)
    178d:	eb 26                	jmp    17b5 <malloc+0x94>
      else {
        p->s.size -= nunits;
    178f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1792:	8b 40 04             	mov    0x4(%eax),%eax
    1795:	89 c2                	mov    %eax,%edx
    1797:	2b 55 ec             	sub    -0x14(%ebp),%edx
    179a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    179d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a3:	8b 40 04             	mov    0x4(%eax),%eax
    17a6:	c1 e0 03             	shl    $0x3,%eax
    17a9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17af:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17b2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17b8:	a3 68 2a 00 00       	mov    %eax,0x2a68
      return (void*)(p + 1);
    17bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c0:	83 c0 08             	add    $0x8,%eax
    17c3:	eb 38                	jmp    17fd <malloc+0xdc>
    }
    if(p == freep)
    17c5:	a1 68 2a 00 00       	mov    0x2a68,%eax
    17ca:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    17cd:	75 1b                	jne    17ea <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    17cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17d2:	89 04 24             	mov    %eax,(%esp)
    17d5:	e8 ef fe ff ff       	call   16c9 <morecore>
    17da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    17dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17e1:	75 07                	jne    17ea <malloc+0xc9>
        return 0;
    17e3:	b8 00 00 00 00       	mov    $0x0,%eax
    17e8:	eb 13                	jmp    17fd <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    17f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17f3:	8b 00                	mov    (%eax),%eax
    17f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    17f8:	e9 70 ff ff ff       	jmp    176d <malloc+0x4c>
}
    17fd:	c9                   	leave  
    17fe:	c3                   	ret    
