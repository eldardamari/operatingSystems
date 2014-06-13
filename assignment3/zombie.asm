
_zombie:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
    1009:	e8 5a 02 00 00       	call   1268 <fork>
    100e:	85 c0                	test   %eax,%eax
    1010:	7e 0c                	jle    101e <main+0x1e>
    sleep(5);  // Let child exit before parent.
    1012:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
    1019:	e8 e2 02 00 00       	call   1300 <sleep>
  exit();
    101e:	e8 4d 02 00 00       	call   1270 <exit>
    1023:	90                   	nop

00001024 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1024:	55                   	push   %ebp
    1025:	89 e5                	mov    %esp,%ebp
    1027:	57                   	push   %edi
    1028:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1029:	8b 4d 08             	mov    0x8(%ebp),%ecx
    102c:	8b 55 10             	mov    0x10(%ebp),%edx
    102f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1032:	89 cb                	mov    %ecx,%ebx
    1034:	89 df                	mov    %ebx,%edi
    1036:	89 d1                	mov    %edx,%ecx
    1038:	fc                   	cld    
    1039:	f3 aa                	rep stos %al,%es:(%edi)
    103b:	89 ca                	mov    %ecx,%edx
    103d:	89 fb                	mov    %edi,%ebx
    103f:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1042:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1045:	5b                   	pop    %ebx
    1046:	5f                   	pop    %edi
    1047:	5d                   	pop    %ebp
    1048:	c3                   	ret    

00001049 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1049:	55                   	push   %ebp
    104a:	89 e5                	mov    %esp,%ebp
    104c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    104f:	8b 45 08             	mov    0x8(%ebp),%eax
    1052:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1055:	90                   	nop
    1056:	8b 45 0c             	mov    0xc(%ebp),%eax
    1059:	8a 10                	mov    (%eax),%dl
    105b:	8b 45 08             	mov    0x8(%ebp),%eax
    105e:	88 10                	mov    %dl,(%eax)
    1060:	8b 45 08             	mov    0x8(%ebp),%eax
    1063:	8a 00                	mov    (%eax),%al
    1065:	84 c0                	test   %al,%al
    1067:	0f 95 c0             	setne  %al
    106a:	ff 45 08             	incl   0x8(%ebp)
    106d:	ff 45 0c             	incl   0xc(%ebp)
    1070:	84 c0                	test   %al,%al
    1072:	75 e2                	jne    1056 <strcpy+0xd>
    ;
  return os;
    1074:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1077:	c9                   	leave  
    1078:	c3                   	ret    

00001079 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1079:	55                   	push   %ebp
    107a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    107c:	eb 06                	jmp    1084 <strcmp+0xb>
    p++, q++;
    107e:	ff 45 08             	incl   0x8(%ebp)
    1081:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1084:	8b 45 08             	mov    0x8(%ebp),%eax
    1087:	8a 00                	mov    (%eax),%al
    1089:	84 c0                	test   %al,%al
    108b:	74 0e                	je     109b <strcmp+0x22>
    108d:	8b 45 08             	mov    0x8(%ebp),%eax
    1090:	8a 10                	mov    (%eax),%dl
    1092:	8b 45 0c             	mov    0xc(%ebp),%eax
    1095:	8a 00                	mov    (%eax),%al
    1097:	38 c2                	cmp    %al,%dl
    1099:	74 e3                	je     107e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    109b:	8b 45 08             	mov    0x8(%ebp),%eax
    109e:	8a 00                	mov    (%eax),%al
    10a0:	0f b6 d0             	movzbl %al,%edx
    10a3:	8b 45 0c             	mov    0xc(%ebp),%eax
    10a6:	8a 00                	mov    (%eax),%al
    10a8:	0f b6 c0             	movzbl %al,%eax
    10ab:	89 d1                	mov    %edx,%ecx
    10ad:	29 c1                	sub    %eax,%ecx
    10af:	89 c8                	mov    %ecx,%eax
}
    10b1:	5d                   	pop    %ebp
    10b2:	c3                   	ret    

000010b3 <strlen>:

uint
strlen(char *s)
{
    10b3:	55                   	push   %ebp
    10b4:	89 e5                	mov    %esp,%ebp
    10b6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    10b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    10c0:	eb 03                	jmp    10c5 <strlen+0x12>
    10c2:	ff 45 fc             	incl   -0x4(%ebp)
    10c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
    10c8:	8b 45 08             	mov    0x8(%ebp),%eax
    10cb:	01 d0                	add    %edx,%eax
    10cd:	8a 00                	mov    (%eax),%al
    10cf:	84 c0                	test   %al,%al
    10d1:	75 ef                	jne    10c2 <strlen+0xf>
    ;
  return n;
    10d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10d6:	c9                   	leave  
    10d7:	c3                   	ret    

000010d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    10d8:	55                   	push   %ebp
    10d9:	89 e5                	mov    %esp,%ebp
    10db:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    10de:	8b 45 10             	mov    0x10(%ebp),%eax
    10e1:	89 44 24 08          	mov    %eax,0x8(%esp)
    10e5:	8b 45 0c             	mov    0xc(%ebp),%eax
    10e8:	89 44 24 04          	mov    %eax,0x4(%esp)
    10ec:	8b 45 08             	mov    0x8(%ebp),%eax
    10ef:	89 04 24             	mov    %eax,(%esp)
    10f2:	e8 2d ff ff ff       	call   1024 <stosb>
  return dst;
    10f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
    10fa:	c9                   	leave  
    10fb:	c3                   	ret    

000010fc <strchr>:

char*
strchr(const char *s, char c)
{
    10fc:	55                   	push   %ebp
    10fd:	89 e5                	mov    %esp,%ebp
    10ff:	83 ec 04             	sub    $0x4,%esp
    1102:	8b 45 0c             	mov    0xc(%ebp),%eax
    1105:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1108:	eb 12                	jmp    111c <strchr+0x20>
    if(*s == c)
    110a:	8b 45 08             	mov    0x8(%ebp),%eax
    110d:	8a 00                	mov    (%eax),%al
    110f:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1112:	75 05                	jne    1119 <strchr+0x1d>
      return (char*)s;
    1114:	8b 45 08             	mov    0x8(%ebp),%eax
    1117:	eb 11                	jmp    112a <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1119:	ff 45 08             	incl   0x8(%ebp)
    111c:	8b 45 08             	mov    0x8(%ebp),%eax
    111f:	8a 00                	mov    (%eax),%al
    1121:	84 c0                	test   %al,%al
    1123:	75 e5                	jne    110a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1125:	b8 00 00 00 00       	mov    $0x0,%eax
}
    112a:	c9                   	leave  
    112b:	c3                   	ret    

0000112c <gets>:

char*
gets(char *buf, int max)
{
    112c:	55                   	push   %ebp
    112d:	89 e5                	mov    %esp,%ebp
    112f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1132:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1139:	eb 42                	jmp    117d <gets+0x51>
    cc = read(0, &c, 1);
    113b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1142:	00 
    1143:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1146:	89 44 24 04          	mov    %eax,0x4(%esp)
    114a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1151:	e8 32 01 00 00       	call   1288 <read>
    1156:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1159:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    115d:	7e 29                	jle    1188 <gets+0x5c>
      break;
    buf[i++] = c;
    115f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1162:	8b 45 08             	mov    0x8(%ebp),%eax
    1165:	01 c2                	add    %eax,%edx
    1167:	8a 45 ef             	mov    -0x11(%ebp),%al
    116a:	88 02                	mov    %al,(%edx)
    116c:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
    116f:	8a 45 ef             	mov    -0x11(%ebp),%al
    1172:	3c 0a                	cmp    $0xa,%al
    1174:	74 13                	je     1189 <gets+0x5d>
    1176:	8a 45 ef             	mov    -0x11(%ebp),%al
    1179:	3c 0d                	cmp    $0xd,%al
    117b:	74 0c                	je     1189 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    117d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1180:	40                   	inc    %eax
    1181:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1184:	7c b5                	jl     113b <gets+0xf>
    1186:	eb 01                	jmp    1189 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    1188:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1189:	8b 55 f4             	mov    -0xc(%ebp),%edx
    118c:	8b 45 08             	mov    0x8(%ebp),%eax
    118f:	01 d0                	add    %edx,%eax
    1191:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1194:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1197:	c9                   	leave  
    1198:	c3                   	ret    

00001199 <stat>:

int
stat(char *n, struct stat *st)
{
    1199:	55                   	push   %ebp
    119a:	89 e5                	mov    %esp,%ebp
    119c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    119f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11a6:	00 
    11a7:	8b 45 08             	mov    0x8(%ebp),%eax
    11aa:	89 04 24             	mov    %eax,(%esp)
    11ad:	e8 fe 00 00 00       	call   12b0 <open>
    11b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    11b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11b9:	79 07                	jns    11c2 <stat+0x29>
    return -1;
    11bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    11c0:	eb 23                	jmp    11e5 <stat+0x4c>
  r = fstat(fd, st);
    11c2:	8b 45 0c             	mov    0xc(%ebp),%eax
    11c5:	89 44 24 04          	mov    %eax,0x4(%esp)
    11c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11cc:	89 04 24             	mov    %eax,(%esp)
    11cf:	e8 f4 00 00 00       	call   12c8 <fstat>
    11d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    11d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11da:	89 04 24             	mov    %eax,(%esp)
    11dd:	e8 b6 00 00 00       	call   1298 <close>
  return r;
    11e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    11e5:	c9                   	leave  
    11e6:	c3                   	ret    

000011e7 <atoi>:

int
atoi(const char *s)
{
    11e7:	55                   	push   %ebp
    11e8:	89 e5                	mov    %esp,%ebp
    11ea:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    11ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    11f4:	eb 21                	jmp    1217 <atoi+0x30>
    n = n*10 + *s++ - '0';
    11f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11f9:	89 d0                	mov    %edx,%eax
    11fb:	c1 e0 02             	shl    $0x2,%eax
    11fe:	01 d0                	add    %edx,%eax
    1200:	d1 e0                	shl    %eax
    1202:	89 c2                	mov    %eax,%edx
    1204:	8b 45 08             	mov    0x8(%ebp),%eax
    1207:	8a 00                	mov    (%eax),%al
    1209:	0f be c0             	movsbl %al,%eax
    120c:	01 d0                	add    %edx,%eax
    120e:	83 e8 30             	sub    $0x30,%eax
    1211:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1214:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1217:	8b 45 08             	mov    0x8(%ebp),%eax
    121a:	8a 00                	mov    (%eax),%al
    121c:	3c 2f                	cmp    $0x2f,%al
    121e:	7e 09                	jle    1229 <atoi+0x42>
    1220:	8b 45 08             	mov    0x8(%ebp),%eax
    1223:	8a 00                	mov    (%eax),%al
    1225:	3c 39                	cmp    $0x39,%al
    1227:	7e cd                	jle    11f6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1229:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    122c:	c9                   	leave  
    122d:	c3                   	ret    

0000122e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    122e:	55                   	push   %ebp
    122f:	89 e5                	mov    %esp,%ebp
    1231:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1234:	8b 45 08             	mov    0x8(%ebp),%eax
    1237:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    123a:	8b 45 0c             	mov    0xc(%ebp),%eax
    123d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1240:	eb 10                	jmp    1252 <memmove+0x24>
    *dst++ = *src++;
    1242:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1245:	8a 10                	mov    (%eax),%dl
    1247:	8b 45 fc             	mov    -0x4(%ebp),%eax
    124a:	88 10                	mov    %dl,(%eax)
    124c:	ff 45 fc             	incl   -0x4(%ebp)
    124f:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1252:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    1256:	0f 9f c0             	setg   %al
    1259:	ff 4d 10             	decl   0x10(%ebp)
    125c:	84 c0                	test   %al,%al
    125e:	75 e2                	jne    1242 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1260:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1263:	c9                   	leave  
    1264:	c3                   	ret    
    1265:	66 90                	xchg   %ax,%ax
    1267:	90                   	nop

00001268 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1268:	b8 01 00 00 00       	mov    $0x1,%eax
    126d:	cd 40                	int    $0x40
    126f:	c3                   	ret    

00001270 <exit>:
SYSCALL(exit)
    1270:	b8 02 00 00 00       	mov    $0x2,%eax
    1275:	cd 40                	int    $0x40
    1277:	c3                   	ret    

00001278 <wait>:
SYSCALL(wait)
    1278:	b8 03 00 00 00       	mov    $0x3,%eax
    127d:	cd 40                	int    $0x40
    127f:	c3                   	ret    

00001280 <pipe>:
SYSCALL(pipe)
    1280:	b8 04 00 00 00       	mov    $0x4,%eax
    1285:	cd 40                	int    $0x40
    1287:	c3                   	ret    

00001288 <read>:
SYSCALL(read)
    1288:	b8 05 00 00 00       	mov    $0x5,%eax
    128d:	cd 40                	int    $0x40
    128f:	c3                   	ret    

00001290 <write>:
SYSCALL(write)
    1290:	b8 10 00 00 00       	mov    $0x10,%eax
    1295:	cd 40                	int    $0x40
    1297:	c3                   	ret    

00001298 <close>:
SYSCALL(close)
    1298:	b8 15 00 00 00       	mov    $0x15,%eax
    129d:	cd 40                	int    $0x40
    129f:	c3                   	ret    

000012a0 <kill>:
SYSCALL(kill)
    12a0:	b8 06 00 00 00       	mov    $0x6,%eax
    12a5:	cd 40                	int    $0x40
    12a7:	c3                   	ret    

000012a8 <exec>:
SYSCALL(exec)
    12a8:	b8 07 00 00 00       	mov    $0x7,%eax
    12ad:	cd 40                	int    $0x40
    12af:	c3                   	ret    

000012b0 <open>:
SYSCALL(open)
    12b0:	b8 0f 00 00 00       	mov    $0xf,%eax
    12b5:	cd 40                	int    $0x40
    12b7:	c3                   	ret    

000012b8 <mknod>:
SYSCALL(mknod)
    12b8:	b8 11 00 00 00       	mov    $0x11,%eax
    12bd:	cd 40                	int    $0x40
    12bf:	c3                   	ret    

000012c0 <unlink>:
SYSCALL(unlink)
    12c0:	b8 12 00 00 00       	mov    $0x12,%eax
    12c5:	cd 40                	int    $0x40
    12c7:	c3                   	ret    

000012c8 <fstat>:
SYSCALL(fstat)
    12c8:	b8 08 00 00 00       	mov    $0x8,%eax
    12cd:	cd 40                	int    $0x40
    12cf:	c3                   	ret    

000012d0 <link>:
SYSCALL(link)
    12d0:	b8 13 00 00 00       	mov    $0x13,%eax
    12d5:	cd 40                	int    $0x40
    12d7:	c3                   	ret    

000012d8 <mkdir>:
SYSCALL(mkdir)
    12d8:	b8 14 00 00 00       	mov    $0x14,%eax
    12dd:	cd 40                	int    $0x40
    12df:	c3                   	ret    

000012e0 <chdir>:
SYSCALL(chdir)
    12e0:	b8 09 00 00 00       	mov    $0x9,%eax
    12e5:	cd 40                	int    $0x40
    12e7:	c3                   	ret    

000012e8 <dup>:
SYSCALL(dup)
    12e8:	b8 0a 00 00 00       	mov    $0xa,%eax
    12ed:	cd 40                	int    $0x40
    12ef:	c3                   	ret    

000012f0 <getpid>:
SYSCALL(getpid)
    12f0:	b8 0b 00 00 00       	mov    $0xb,%eax
    12f5:	cd 40                	int    $0x40
    12f7:	c3                   	ret    

000012f8 <sbrk>:
SYSCALL(sbrk)
    12f8:	b8 0c 00 00 00       	mov    $0xc,%eax
    12fd:	cd 40                	int    $0x40
    12ff:	c3                   	ret    

00001300 <sleep>:
SYSCALL(sleep)
    1300:	b8 0d 00 00 00       	mov    $0xd,%eax
    1305:	cd 40                	int    $0x40
    1307:	c3                   	ret    

00001308 <uptime>:
SYSCALL(uptime)
    1308:	b8 0e 00 00 00       	mov    $0xe,%eax
    130d:	cd 40                	int    $0x40
    130f:	c3                   	ret    

00001310 <cowfork>:
SYSCALL(cowfork) //3.4
    1310:	b8 16 00 00 00       	mov    $0x16,%eax
    1315:	cd 40                	int    $0x40
    1317:	c3                   	ret    

00001318 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1318:	55                   	push   %ebp
    1319:	89 e5                	mov    %esp,%ebp
    131b:	83 ec 28             	sub    $0x28,%esp
    131e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1321:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1324:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    132b:	00 
    132c:	8d 45 f4             	lea    -0xc(%ebp),%eax
    132f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1333:	8b 45 08             	mov    0x8(%ebp),%eax
    1336:	89 04 24             	mov    %eax,(%esp)
    1339:	e8 52 ff ff ff       	call   1290 <write>
}
    133e:	c9                   	leave  
    133f:	c3                   	ret    

00001340 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1340:	55                   	push   %ebp
    1341:	89 e5                	mov    %esp,%ebp
    1343:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1346:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    134d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1351:	74 17                	je     136a <printint+0x2a>
    1353:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1357:	79 11                	jns    136a <printint+0x2a>
    neg = 1;
    1359:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1360:	8b 45 0c             	mov    0xc(%ebp),%eax
    1363:	f7 d8                	neg    %eax
    1365:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1368:	eb 06                	jmp    1370 <printint+0x30>
  } else {
    x = xx;
    136a:	8b 45 0c             	mov    0xc(%ebp),%eax
    136d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1370:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1377:	8b 4d 10             	mov    0x10(%ebp),%ecx
    137a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    137d:	ba 00 00 00 00       	mov    $0x0,%edx
    1382:	f7 f1                	div    %ecx
    1384:	89 d0                	mov    %edx,%eax
    1386:	8a 80 fc 29 00 00    	mov    0x29fc(%eax),%al
    138c:	8d 4d dc             	lea    -0x24(%ebp),%ecx
    138f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1392:	01 ca                	add    %ecx,%edx
    1394:	88 02                	mov    %al,(%edx)
    1396:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
    1399:	8b 55 10             	mov    0x10(%ebp),%edx
    139c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    139f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13a2:	ba 00 00 00 00       	mov    $0x0,%edx
    13a7:	f7 75 d4             	divl   -0x2c(%ebp)
    13aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    13b1:	75 c4                	jne    1377 <printint+0x37>
  if(neg)
    13b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13b7:	74 2c                	je     13e5 <printint+0xa5>
    buf[i++] = '-';
    13b9:	8d 55 dc             	lea    -0x24(%ebp),%edx
    13bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13bf:	01 d0                	add    %edx,%eax
    13c1:	c6 00 2d             	movb   $0x2d,(%eax)
    13c4:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
    13c7:	eb 1c                	jmp    13e5 <printint+0xa5>
    putc(fd, buf[i]);
    13c9:	8d 55 dc             	lea    -0x24(%ebp),%edx
    13cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13cf:	01 d0                	add    %edx,%eax
    13d1:	8a 00                	mov    (%eax),%al
    13d3:	0f be c0             	movsbl %al,%eax
    13d6:	89 44 24 04          	mov    %eax,0x4(%esp)
    13da:	8b 45 08             	mov    0x8(%ebp),%eax
    13dd:	89 04 24             	mov    %eax,(%esp)
    13e0:	e8 33 ff ff ff       	call   1318 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    13e5:	ff 4d f4             	decl   -0xc(%ebp)
    13e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    13ec:	79 db                	jns    13c9 <printint+0x89>
    putc(fd, buf[i]);
}
    13ee:	c9                   	leave  
    13ef:	c3                   	ret    

000013f0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    13f0:	55                   	push   %ebp
    13f1:	89 e5                	mov    %esp,%ebp
    13f3:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    13f6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    13fd:	8d 45 0c             	lea    0xc(%ebp),%eax
    1400:	83 c0 04             	add    $0x4,%eax
    1403:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1406:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    140d:	e9 78 01 00 00       	jmp    158a <printf+0x19a>
    c = fmt[i] & 0xff;
    1412:	8b 55 0c             	mov    0xc(%ebp),%edx
    1415:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1418:	01 d0                	add    %edx,%eax
    141a:	8a 00                	mov    (%eax),%al
    141c:	0f be c0             	movsbl %al,%eax
    141f:	25 ff 00 00 00       	and    $0xff,%eax
    1424:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1427:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    142b:	75 2c                	jne    1459 <printf+0x69>
      if(c == '%'){
    142d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1431:	75 0c                	jne    143f <printf+0x4f>
        state = '%';
    1433:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    143a:	e9 48 01 00 00       	jmp    1587 <printf+0x197>
      } else {
        putc(fd, c);
    143f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1442:	0f be c0             	movsbl %al,%eax
    1445:	89 44 24 04          	mov    %eax,0x4(%esp)
    1449:	8b 45 08             	mov    0x8(%ebp),%eax
    144c:	89 04 24             	mov    %eax,(%esp)
    144f:	e8 c4 fe ff ff       	call   1318 <putc>
    1454:	e9 2e 01 00 00       	jmp    1587 <printf+0x197>
      }
    } else if(state == '%'){
    1459:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    145d:	0f 85 24 01 00 00    	jne    1587 <printf+0x197>
      if(c == 'd'){
    1463:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1467:	75 2d                	jne    1496 <printf+0xa6>
        printint(fd, *ap, 10, 1);
    1469:	8b 45 e8             	mov    -0x18(%ebp),%eax
    146c:	8b 00                	mov    (%eax),%eax
    146e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1475:	00 
    1476:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    147d:	00 
    147e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1482:	8b 45 08             	mov    0x8(%ebp),%eax
    1485:	89 04 24             	mov    %eax,(%esp)
    1488:	e8 b3 fe ff ff       	call   1340 <printint>
        ap++;
    148d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1491:	e9 ea 00 00 00       	jmp    1580 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
    1496:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    149a:	74 06                	je     14a2 <printf+0xb2>
    149c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    14a0:	75 2d                	jne    14cf <printf+0xdf>
        printint(fd, *ap, 16, 0);
    14a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14a5:	8b 00                	mov    (%eax),%eax
    14a7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    14ae:	00 
    14af:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    14b6:	00 
    14b7:	89 44 24 04          	mov    %eax,0x4(%esp)
    14bb:	8b 45 08             	mov    0x8(%ebp),%eax
    14be:	89 04 24             	mov    %eax,(%esp)
    14c1:	e8 7a fe ff ff       	call   1340 <printint>
        ap++;
    14c6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14ca:	e9 b1 00 00 00       	jmp    1580 <printf+0x190>
      } else if(c == 's'){
    14cf:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    14d3:	75 43                	jne    1518 <printf+0x128>
        s = (char*)*ap;
    14d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14d8:	8b 00                	mov    (%eax),%eax
    14da:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    14dd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    14e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14e5:	75 25                	jne    150c <printf+0x11c>
          s = "(null)";
    14e7:	c7 45 f4 b7 17 00 00 	movl   $0x17b7,-0xc(%ebp)
        while(*s != 0){
    14ee:	eb 1c                	jmp    150c <printf+0x11c>
          putc(fd, *s);
    14f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14f3:	8a 00                	mov    (%eax),%al
    14f5:	0f be c0             	movsbl %al,%eax
    14f8:	89 44 24 04          	mov    %eax,0x4(%esp)
    14fc:	8b 45 08             	mov    0x8(%ebp),%eax
    14ff:	89 04 24             	mov    %eax,(%esp)
    1502:	e8 11 fe ff ff       	call   1318 <putc>
          s++;
    1507:	ff 45 f4             	incl   -0xc(%ebp)
    150a:	eb 01                	jmp    150d <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    150c:	90                   	nop
    150d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1510:	8a 00                	mov    (%eax),%al
    1512:	84 c0                	test   %al,%al
    1514:	75 da                	jne    14f0 <printf+0x100>
    1516:	eb 68                	jmp    1580 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1518:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    151c:	75 1d                	jne    153b <printf+0x14b>
        putc(fd, *ap);
    151e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1521:	8b 00                	mov    (%eax),%eax
    1523:	0f be c0             	movsbl %al,%eax
    1526:	89 44 24 04          	mov    %eax,0x4(%esp)
    152a:	8b 45 08             	mov    0x8(%ebp),%eax
    152d:	89 04 24             	mov    %eax,(%esp)
    1530:	e8 e3 fd ff ff       	call   1318 <putc>
        ap++;
    1535:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1539:	eb 45                	jmp    1580 <printf+0x190>
      } else if(c == '%'){
    153b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    153f:	75 17                	jne    1558 <printf+0x168>
        putc(fd, c);
    1541:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1544:	0f be c0             	movsbl %al,%eax
    1547:	89 44 24 04          	mov    %eax,0x4(%esp)
    154b:	8b 45 08             	mov    0x8(%ebp),%eax
    154e:	89 04 24             	mov    %eax,(%esp)
    1551:	e8 c2 fd ff ff       	call   1318 <putc>
    1556:	eb 28                	jmp    1580 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1558:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    155f:	00 
    1560:	8b 45 08             	mov    0x8(%ebp),%eax
    1563:	89 04 24             	mov    %eax,(%esp)
    1566:	e8 ad fd ff ff       	call   1318 <putc>
        putc(fd, c);
    156b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    156e:	0f be c0             	movsbl %al,%eax
    1571:	89 44 24 04          	mov    %eax,0x4(%esp)
    1575:	8b 45 08             	mov    0x8(%ebp),%eax
    1578:	89 04 24             	mov    %eax,(%esp)
    157b:	e8 98 fd ff ff       	call   1318 <putc>
      }
      state = 0;
    1580:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1587:	ff 45 f0             	incl   -0x10(%ebp)
    158a:	8b 55 0c             	mov    0xc(%ebp),%edx
    158d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1590:	01 d0                	add    %edx,%eax
    1592:	8a 00                	mov    (%eax),%al
    1594:	84 c0                	test   %al,%al
    1596:	0f 85 76 fe ff ff    	jne    1412 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    159c:	c9                   	leave  
    159d:	c3                   	ret    
    159e:	66 90                	xchg   %ax,%ax

000015a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15a0:	55                   	push   %ebp
    15a1:	89 e5                	mov    %esp,%ebp
    15a3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    15a6:	8b 45 08             	mov    0x8(%ebp),%eax
    15a9:	83 e8 08             	sub    $0x8,%eax
    15ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15af:	a1 18 2a 00 00       	mov    0x2a18,%eax
    15b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    15b7:	eb 24                	jmp    15dd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15bc:	8b 00                	mov    (%eax),%eax
    15be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    15c1:	77 12                	ja     15d5 <free+0x35>
    15c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    15c9:	77 24                	ja     15ef <free+0x4f>
    15cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15ce:	8b 00                	mov    (%eax),%eax
    15d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    15d3:	77 1a                	ja     15ef <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15d8:	8b 00                	mov    (%eax),%eax
    15da:	89 45 fc             	mov    %eax,-0x4(%ebp)
    15dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    15e3:	76 d4                	jbe    15b9 <free+0x19>
    15e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15e8:	8b 00                	mov    (%eax),%eax
    15ea:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    15ed:	76 ca                	jbe    15b9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    15ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15f2:	8b 40 04             	mov    0x4(%eax),%eax
    15f5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    15fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15ff:	01 c2                	add    %eax,%edx
    1601:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1604:	8b 00                	mov    (%eax),%eax
    1606:	39 c2                	cmp    %eax,%edx
    1608:	75 24                	jne    162e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    160a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    160d:	8b 50 04             	mov    0x4(%eax),%edx
    1610:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1613:	8b 00                	mov    (%eax),%eax
    1615:	8b 40 04             	mov    0x4(%eax),%eax
    1618:	01 c2                	add    %eax,%edx
    161a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    161d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1620:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1623:	8b 00                	mov    (%eax),%eax
    1625:	8b 10                	mov    (%eax),%edx
    1627:	8b 45 f8             	mov    -0x8(%ebp),%eax
    162a:	89 10                	mov    %edx,(%eax)
    162c:	eb 0a                	jmp    1638 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    162e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1631:	8b 10                	mov    (%eax),%edx
    1633:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1636:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1638:	8b 45 fc             	mov    -0x4(%ebp),%eax
    163b:	8b 40 04             	mov    0x4(%eax),%eax
    163e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1645:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1648:	01 d0                	add    %edx,%eax
    164a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    164d:	75 20                	jne    166f <free+0xcf>
    p->s.size += bp->s.size;
    164f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1652:	8b 50 04             	mov    0x4(%eax),%edx
    1655:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1658:	8b 40 04             	mov    0x4(%eax),%eax
    165b:	01 c2                	add    %eax,%edx
    165d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1660:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1663:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1666:	8b 10                	mov    (%eax),%edx
    1668:	8b 45 fc             	mov    -0x4(%ebp),%eax
    166b:	89 10                	mov    %edx,(%eax)
    166d:	eb 08                	jmp    1677 <free+0xd7>
  } else
    p->s.ptr = bp;
    166f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1672:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1675:	89 10                	mov    %edx,(%eax)
  freep = p;
    1677:	8b 45 fc             	mov    -0x4(%ebp),%eax
    167a:	a3 18 2a 00 00       	mov    %eax,0x2a18
}
    167f:	c9                   	leave  
    1680:	c3                   	ret    

00001681 <morecore>:

static Header*
morecore(uint nu)
{
    1681:	55                   	push   %ebp
    1682:	89 e5                	mov    %esp,%ebp
    1684:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1687:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    168e:	77 07                	ja     1697 <morecore+0x16>
    nu = 4096;
    1690:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1697:	8b 45 08             	mov    0x8(%ebp),%eax
    169a:	c1 e0 03             	shl    $0x3,%eax
    169d:	89 04 24             	mov    %eax,(%esp)
    16a0:	e8 53 fc ff ff       	call   12f8 <sbrk>
    16a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    16a8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    16ac:	75 07                	jne    16b5 <morecore+0x34>
    return 0;
    16ae:	b8 00 00 00 00       	mov    $0x0,%eax
    16b3:	eb 22                	jmp    16d7 <morecore+0x56>
  hp = (Header*)p;
    16b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    16bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16be:	8b 55 08             	mov    0x8(%ebp),%edx
    16c1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    16c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16c7:	83 c0 08             	add    $0x8,%eax
    16ca:	89 04 24             	mov    %eax,(%esp)
    16cd:	e8 ce fe ff ff       	call   15a0 <free>
  return freep;
    16d2:	a1 18 2a 00 00       	mov    0x2a18,%eax
}
    16d7:	c9                   	leave  
    16d8:	c3                   	ret    

000016d9 <malloc>:

void*
malloc(uint nbytes)
{
    16d9:	55                   	push   %ebp
    16da:	89 e5                	mov    %esp,%ebp
    16dc:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    16df:	8b 45 08             	mov    0x8(%ebp),%eax
    16e2:	83 c0 07             	add    $0x7,%eax
    16e5:	c1 e8 03             	shr    $0x3,%eax
    16e8:	40                   	inc    %eax
    16e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    16ec:	a1 18 2a 00 00       	mov    0x2a18,%eax
    16f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    16f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    16f8:	75 23                	jne    171d <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    16fa:	c7 45 f0 10 2a 00 00 	movl   $0x2a10,-0x10(%ebp)
    1701:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1704:	a3 18 2a 00 00       	mov    %eax,0x2a18
    1709:	a1 18 2a 00 00       	mov    0x2a18,%eax
    170e:	a3 10 2a 00 00       	mov    %eax,0x2a10
    base.s.size = 0;
    1713:	c7 05 14 2a 00 00 00 	movl   $0x0,0x2a14
    171a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    171d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1720:	8b 00                	mov    (%eax),%eax
    1722:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1725:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1728:	8b 40 04             	mov    0x4(%eax),%eax
    172b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    172e:	72 4d                	jb     177d <malloc+0xa4>
      if(p->s.size == nunits)
    1730:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1733:	8b 40 04             	mov    0x4(%eax),%eax
    1736:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1739:	75 0c                	jne    1747 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    173b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    173e:	8b 10                	mov    (%eax),%edx
    1740:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1743:	89 10                	mov    %edx,(%eax)
    1745:	eb 26                	jmp    176d <malloc+0x94>
      else {
        p->s.size -= nunits;
    1747:	8b 45 f4             	mov    -0xc(%ebp),%eax
    174a:	8b 40 04             	mov    0x4(%eax),%eax
    174d:	89 c2                	mov    %eax,%edx
    174f:	2b 55 ec             	sub    -0x14(%ebp),%edx
    1752:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1755:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1758:	8b 45 f4             	mov    -0xc(%ebp),%eax
    175b:	8b 40 04             	mov    0x4(%eax),%eax
    175e:	c1 e0 03             	shl    $0x3,%eax
    1761:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1764:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1767:	8b 55 ec             	mov    -0x14(%ebp),%edx
    176a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    176d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1770:	a3 18 2a 00 00       	mov    %eax,0x2a18
      return (void*)(p + 1);
    1775:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1778:	83 c0 08             	add    $0x8,%eax
    177b:	eb 38                	jmp    17b5 <malloc+0xdc>
    }
    if(p == freep)
    177d:	a1 18 2a 00 00       	mov    0x2a18,%eax
    1782:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1785:	75 1b                	jne    17a2 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    1787:	8b 45 ec             	mov    -0x14(%ebp),%eax
    178a:	89 04 24             	mov    %eax,(%esp)
    178d:	e8 ef fe ff ff       	call   1681 <morecore>
    1792:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1795:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1799:	75 07                	jne    17a2 <malloc+0xc9>
        return 0;
    179b:	b8 00 00 00 00       	mov    $0x0,%eax
    17a0:	eb 13                	jmp    17b5 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    17a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ab:	8b 00                	mov    (%eax),%eax
    17ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    17b0:	e9 70 ff ff ff       	jmp    1725 <malloc+0x4c>
}
    17b5:	c9                   	leave  
    17b6:	c3                   	ret    
