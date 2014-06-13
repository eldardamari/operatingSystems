
_kill:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 1){
    1009:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    100d:	7f 19                	jg     1028 <main+0x28>
    printf(2, "usage: kill pid...\n");
    100f:	c7 44 24 04 fb 17 00 	movl   $0x17fb,0x4(%esp)
    1016:	00 
    1017:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    101e:	e8 11 04 00 00       	call   1434 <printf>
    exit();
    1023:	e8 8c 02 00 00       	call   12b4 <exit>
  }
  for(i=1; i<argc; i++)
    1028:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    102f:	00 
    1030:	eb 26                	jmp    1058 <main+0x58>
    kill(atoi(argv[i]));
    1032:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1036:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    103d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1040:	01 d0                	add    %edx,%eax
    1042:	8b 00                	mov    (%eax),%eax
    1044:	89 04 24             	mov    %eax,(%esp)
    1047:	e8 df 01 00 00       	call   122b <atoi>
    104c:	89 04 24             	mov    %eax,(%esp)
    104f:	e8 90 02 00 00       	call   12e4 <kill>

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
    1054:	ff 44 24 1c          	incl   0x1c(%esp)
    1058:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    105c:	3b 45 08             	cmp    0x8(%ebp),%eax
    105f:	7c d1                	jl     1032 <main+0x32>
    kill(atoi(argv[i]));
  exit();
    1061:	e8 4e 02 00 00       	call   12b4 <exit>
    1066:	66 90                	xchg   %ax,%ax

00001068 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1068:	55                   	push   %ebp
    1069:	89 e5                	mov    %esp,%ebp
    106b:	57                   	push   %edi
    106c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    106d:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1070:	8b 55 10             	mov    0x10(%ebp),%edx
    1073:	8b 45 0c             	mov    0xc(%ebp),%eax
    1076:	89 cb                	mov    %ecx,%ebx
    1078:	89 df                	mov    %ebx,%edi
    107a:	89 d1                	mov    %edx,%ecx
    107c:	fc                   	cld    
    107d:	f3 aa                	rep stos %al,%es:(%edi)
    107f:	89 ca                	mov    %ecx,%edx
    1081:	89 fb                	mov    %edi,%ebx
    1083:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1086:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1089:	5b                   	pop    %ebx
    108a:	5f                   	pop    %edi
    108b:	5d                   	pop    %ebp
    108c:	c3                   	ret    

0000108d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    108d:	55                   	push   %ebp
    108e:	89 e5                	mov    %esp,%ebp
    1090:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1093:	8b 45 08             	mov    0x8(%ebp),%eax
    1096:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1099:	90                   	nop
    109a:	8b 45 0c             	mov    0xc(%ebp),%eax
    109d:	8a 10                	mov    (%eax),%dl
    109f:	8b 45 08             	mov    0x8(%ebp),%eax
    10a2:	88 10                	mov    %dl,(%eax)
    10a4:	8b 45 08             	mov    0x8(%ebp),%eax
    10a7:	8a 00                	mov    (%eax),%al
    10a9:	84 c0                	test   %al,%al
    10ab:	0f 95 c0             	setne  %al
    10ae:	ff 45 08             	incl   0x8(%ebp)
    10b1:	ff 45 0c             	incl   0xc(%ebp)
    10b4:	84 c0                	test   %al,%al
    10b6:	75 e2                	jne    109a <strcpy+0xd>
    ;
  return os;
    10b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10bb:	c9                   	leave  
    10bc:	c3                   	ret    

000010bd <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10bd:	55                   	push   %ebp
    10be:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10c0:	eb 06                	jmp    10c8 <strcmp+0xb>
    p++, q++;
    10c2:	ff 45 08             	incl   0x8(%ebp)
    10c5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10c8:	8b 45 08             	mov    0x8(%ebp),%eax
    10cb:	8a 00                	mov    (%eax),%al
    10cd:	84 c0                	test   %al,%al
    10cf:	74 0e                	je     10df <strcmp+0x22>
    10d1:	8b 45 08             	mov    0x8(%ebp),%eax
    10d4:	8a 10                	mov    (%eax),%dl
    10d6:	8b 45 0c             	mov    0xc(%ebp),%eax
    10d9:	8a 00                	mov    (%eax),%al
    10db:	38 c2                	cmp    %al,%dl
    10dd:	74 e3                	je     10c2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10df:	8b 45 08             	mov    0x8(%ebp),%eax
    10e2:	8a 00                	mov    (%eax),%al
    10e4:	0f b6 d0             	movzbl %al,%edx
    10e7:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ea:	8a 00                	mov    (%eax),%al
    10ec:	0f b6 c0             	movzbl %al,%eax
    10ef:	89 d1                	mov    %edx,%ecx
    10f1:	29 c1                	sub    %eax,%ecx
    10f3:	89 c8                	mov    %ecx,%eax
}
    10f5:	5d                   	pop    %ebp
    10f6:	c3                   	ret    

000010f7 <strlen>:

uint
strlen(char *s)
{
    10f7:	55                   	push   %ebp
    10f8:	89 e5                	mov    %esp,%ebp
    10fa:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    10fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1104:	eb 03                	jmp    1109 <strlen+0x12>
    1106:	ff 45 fc             	incl   -0x4(%ebp)
    1109:	8b 55 fc             	mov    -0x4(%ebp),%edx
    110c:	8b 45 08             	mov    0x8(%ebp),%eax
    110f:	01 d0                	add    %edx,%eax
    1111:	8a 00                	mov    (%eax),%al
    1113:	84 c0                	test   %al,%al
    1115:	75 ef                	jne    1106 <strlen+0xf>
    ;
  return n;
    1117:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    111a:	c9                   	leave  
    111b:	c3                   	ret    

0000111c <memset>:

void*
memset(void *dst, int c, uint n)
{
    111c:	55                   	push   %ebp
    111d:	89 e5                	mov    %esp,%ebp
    111f:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1122:	8b 45 10             	mov    0x10(%ebp),%eax
    1125:	89 44 24 08          	mov    %eax,0x8(%esp)
    1129:	8b 45 0c             	mov    0xc(%ebp),%eax
    112c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1130:	8b 45 08             	mov    0x8(%ebp),%eax
    1133:	89 04 24             	mov    %eax,(%esp)
    1136:	e8 2d ff ff ff       	call   1068 <stosb>
  return dst;
    113b:	8b 45 08             	mov    0x8(%ebp),%eax
}
    113e:	c9                   	leave  
    113f:	c3                   	ret    

00001140 <strchr>:

char*
strchr(const char *s, char c)
{
    1140:	55                   	push   %ebp
    1141:	89 e5                	mov    %esp,%ebp
    1143:	83 ec 04             	sub    $0x4,%esp
    1146:	8b 45 0c             	mov    0xc(%ebp),%eax
    1149:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    114c:	eb 12                	jmp    1160 <strchr+0x20>
    if(*s == c)
    114e:	8b 45 08             	mov    0x8(%ebp),%eax
    1151:	8a 00                	mov    (%eax),%al
    1153:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1156:	75 05                	jne    115d <strchr+0x1d>
      return (char*)s;
    1158:	8b 45 08             	mov    0x8(%ebp),%eax
    115b:	eb 11                	jmp    116e <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    115d:	ff 45 08             	incl   0x8(%ebp)
    1160:	8b 45 08             	mov    0x8(%ebp),%eax
    1163:	8a 00                	mov    (%eax),%al
    1165:	84 c0                	test   %al,%al
    1167:	75 e5                	jne    114e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1169:	b8 00 00 00 00       	mov    $0x0,%eax
}
    116e:	c9                   	leave  
    116f:	c3                   	ret    

00001170 <gets>:

char*
gets(char *buf, int max)
{
    1170:	55                   	push   %ebp
    1171:	89 e5                	mov    %esp,%ebp
    1173:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1176:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    117d:	eb 42                	jmp    11c1 <gets+0x51>
    cc = read(0, &c, 1);
    117f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1186:	00 
    1187:	8d 45 ef             	lea    -0x11(%ebp),%eax
    118a:	89 44 24 04          	mov    %eax,0x4(%esp)
    118e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1195:	e8 32 01 00 00       	call   12cc <read>
    119a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    119d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11a1:	7e 29                	jle    11cc <gets+0x5c>
      break;
    buf[i++] = c;
    11a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11a6:	8b 45 08             	mov    0x8(%ebp),%eax
    11a9:	01 c2                	add    %eax,%edx
    11ab:	8a 45 ef             	mov    -0x11(%ebp),%al
    11ae:	88 02                	mov    %al,(%edx)
    11b0:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
    11b3:	8a 45 ef             	mov    -0x11(%ebp),%al
    11b6:	3c 0a                	cmp    $0xa,%al
    11b8:	74 13                	je     11cd <gets+0x5d>
    11ba:	8a 45 ef             	mov    -0x11(%ebp),%al
    11bd:	3c 0d                	cmp    $0xd,%al
    11bf:	74 0c                	je     11cd <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11c4:	40                   	inc    %eax
    11c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11c8:	7c b5                	jl     117f <gets+0xf>
    11ca:	eb 01                	jmp    11cd <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    11cc:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11d0:	8b 45 08             	mov    0x8(%ebp),%eax
    11d3:	01 d0                	add    %edx,%eax
    11d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11db:	c9                   	leave  
    11dc:	c3                   	ret    

000011dd <stat>:

int
stat(char *n, struct stat *st)
{
    11dd:	55                   	push   %ebp
    11de:	89 e5                	mov    %esp,%ebp
    11e0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11e3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11ea:	00 
    11eb:	8b 45 08             	mov    0x8(%ebp),%eax
    11ee:	89 04 24             	mov    %eax,(%esp)
    11f1:	e8 fe 00 00 00       	call   12f4 <open>
    11f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    11f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11fd:	79 07                	jns    1206 <stat+0x29>
    return -1;
    11ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1204:	eb 23                	jmp    1229 <stat+0x4c>
  r = fstat(fd, st);
    1206:	8b 45 0c             	mov    0xc(%ebp),%eax
    1209:	89 44 24 04          	mov    %eax,0x4(%esp)
    120d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1210:	89 04 24             	mov    %eax,(%esp)
    1213:	e8 f4 00 00 00       	call   130c <fstat>
    1218:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    121b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    121e:	89 04 24             	mov    %eax,(%esp)
    1221:	e8 b6 00 00 00       	call   12dc <close>
  return r;
    1226:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1229:	c9                   	leave  
    122a:	c3                   	ret    

0000122b <atoi>:

int
atoi(const char *s)
{
    122b:	55                   	push   %ebp
    122c:	89 e5                	mov    %esp,%ebp
    122e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1231:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1238:	eb 21                	jmp    125b <atoi+0x30>
    n = n*10 + *s++ - '0';
    123a:	8b 55 fc             	mov    -0x4(%ebp),%edx
    123d:	89 d0                	mov    %edx,%eax
    123f:	c1 e0 02             	shl    $0x2,%eax
    1242:	01 d0                	add    %edx,%eax
    1244:	d1 e0                	shl    %eax
    1246:	89 c2                	mov    %eax,%edx
    1248:	8b 45 08             	mov    0x8(%ebp),%eax
    124b:	8a 00                	mov    (%eax),%al
    124d:	0f be c0             	movsbl %al,%eax
    1250:	01 d0                	add    %edx,%eax
    1252:	83 e8 30             	sub    $0x30,%eax
    1255:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1258:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    125b:	8b 45 08             	mov    0x8(%ebp),%eax
    125e:	8a 00                	mov    (%eax),%al
    1260:	3c 2f                	cmp    $0x2f,%al
    1262:	7e 09                	jle    126d <atoi+0x42>
    1264:	8b 45 08             	mov    0x8(%ebp),%eax
    1267:	8a 00                	mov    (%eax),%al
    1269:	3c 39                	cmp    $0x39,%al
    126b:	7e cd                	jle    123a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    126d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1270:	c9                   	leave  
    1271:	c3                   	ret    

00001272 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1272:	55                   	push   %ebp
    1273:	89 e5                	mov    %esp,%ebp
    1275:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1278:	8b 45 08             	mov    0x8(%ebp),%eax
    127b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    127e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1281:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1284:	eb 10                	jmp    1296 <memmove+0x24>
    *dst++ = *src++;
    1286:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1289:	8a 10                	mov    (%eax),%dl
    128b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    128e:	88 10                	mov    %dl,(%eax)
    1290:	ff 45 fc             	incl   -0x4(%ebp)
    1293:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1296:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    129a:	0f 9f c0             	setg   %al
    129d:	ff 4d 10             	decl   0x10(%ebp)
    12a0:	84 c0                	test   %al,%al
    12a2:	75 e2                	jne    1286 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    12a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12a7:	c9                   	leave  
    12a8:	c3                   	ret    
    12a9:	66 90                	xchg   %ax,%ax
    12ab:	90                   	nop

000012ac <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12ac:	b8 01 00 00 00       	mov    $0x1,%eax
    12b1:	cd 40                	int    $0x40
    12b3:	c3                   	ret    

000012b4 <exit>:
SYSCALL(exit)
    12b4:	b8 02 00 00 00       	mov    $0x2,%eax
    12b9:	cd 40                	int    $0x40
    12bb:	c3                   	ret    

000012bc <wait>:
SYSCALL(wait)
    12bc:	b8 03 00 00 00       	mov    $0x3,%eax
    12c1:	cd 40                	int    $0x40
    12c3:	c3                   	ret    

000012c4 <pipe>:
SYSCALL(pipe)
    12c4:	b8 04 00 00 00       	mov    $0x4,%eax
    12c9:	cd 40                	int    $0x40
    12cb:	c3                   	ret    

000012cc <read>:
SYSCALL(read)
    12cc:	b8 05 00 00 00       	mov    $0x5,%eax
    12d1:	cd 40                	int    $0x40
    12d3:	c3                   	ret    

000012d4 <write>:
SYSCALL(write)
    12d4:	b8 10 00 00 00       	mov    $0x10,%eax
    12d9:	cd 40                	int    $0x40
    12db:	c3                   	ret    

000012dc <close>:
SYSCALL(close)
    12dc:	b8 15 00 00 00       	mov    $0x15,%eax
    12e1:	cd 40                	int    $0x40
    12e3:	c3                   	ret    

000012e4 <kill>:
SYSCALL(kill)
    12e4:	b8 06 00 00 00       	mov    $0x6,%eax
    12e9:	cd 40                	int    $0x40
    12eb:	c3                   	ret    

000012ec <exec>:
SYSCALL(exec)
    12ec:	b8 07 00 00 00       	mov    $0x7,%eax
    12f1:	cd 40                	int    $0x40
    12f3:	c3                   	ret    

000012f4 <open>:
SYSCALL(open)
    12f4:	b8 0f 00 00 00       	mov    $0xf,%eax
    12f9:	cd 40                	int    $0x40
    12fb:	c3                   	ret    

000012fc <mknod>:
SYSCALL(mknod)
    12fc:	b8 11 00 00 00       	mov    $0x11,%eax
    1301:	cd 40                	int    $0x40
    1303:	c3                   	ret    

00001304 <unlink>:
SYSCALL(unlink)
    1304:	b8 12 00 00 00       	mov    $0x12,%eax
    1309:	cd 40                	int    $0x40
    130b:	c3                   	ret    

0000130c <fstat>:
SYSCALL(fstat)
    130c:	b8 08 00 00 00       	mov    $0x8,%eax
    1311:	cd 40                	int    $0x40
    1313:	c3                   	ret    

00001314 <link>:
SYSCALL(link)
    1314:	b8 13 00 00 00       	mov    $0x13,%eax
    1319:	cd 40                	int    $0x40
    131b:	c3                   	ret    

0000131c <mkdir>:
SYSCALL(mkdir)
    131c:	b8 14 00 00 00       	mov    $0x14,%eax
    1321:	cd 40                	int    $0x40
    1323:	c3                   	ret    

00001324 <chdir>:
SYSCALL(chdir)
    1324:	b8 09 00 00 00       	mov    $0x9,%eax
    1329:	cd 40                	int    $0x40
    132b:	c3                   	ret    

0000132c <dup>:
SYSCALL(dup)
    132c:	b8 0a 00 00 00       	mov    $0xa,%eax
    1331:	cd 40                	int    $0x40
    1333:	c3                   	ret    

00001334 <getpid>:
SYSCALL(getpid)
    1334:	b8 0b 00 00 00       	mov    $0xb,%eax
    1339:	cd 40                	int    $0x40
    133b:	c3                   	ret    

0000133c <sbrk>:
SYSCALL(sbrk)
    133c:	b8 0c 00 00 00       	mov    $0xc,%eax
    1341:	cd 40                	int    $0x40
    1343:	c3                   	ret    

00001344 <sleep>:
SYSCALL(sleep)
    1344:	b8 0d 00 00 00       	mov    $0xd,%eax
    1349:	cd 40                	int    $0x40
    134b:	c3                   	ret    

0000134c <uptime>:
SYSCALL(uptime)
    134c:	b8 0e 00 00 00       	mov    $0xe,%eax
    1351:	cd 40                	int    $0x40
    1353:	c3                   	ret    

00001354 <cowfork>:
SYSCALL(cowfork) //3.4
    1354:	b8 16 00 00 00       	mov    $0x16,%eax
    1359:	cd 40                	int    $0x40
    135b:	c3                   	ret    

0000135c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    135c:	55                   	push   %ebp
    135d:	89 e5                	mov    %esp,%ebp
    135f:	83 ec 28             	sub    $0x28,%esp
    1362:	8b 45 0c             	mov    0xc(%ebp),%eax
    1365:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1368:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    136f:	00 
    1370:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1373:	89 44 24 04          	mov    %eax,0x4(%esp)
    1377:	8b 45 08             	mov    0x8(%ebp),%eax
    137a:	89 04 24             	mov    %eax,(%esp)
    137d:	e8 52 ff ff ff       	call   12d4 <write>
}
    1382:	c9                   	leave  
    1383:	c3                   	ret    

00001384 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1384:	55                   	push   %ebp
    1385:	89 e5                	mov    %esp,%ebp
    1387:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    138a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1391:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1395:	74 17                	je     13ae <printint+0x2a>
    1397:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    139b:	79 11                	jns    13ae <printint+0x2a>
    neg = 1;
    139d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13a4:	8b 45 0c             	mov    0xc(%ebp),%eax
    13a7:	f7 d8                	neg    %eax
    13a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13ac:	eb 06                	jmp    13b4 <printint+0x30>
  } else {
    x = xx;
    13ae:	8b 45 0c             	mov    0xc(%ebp),%eax
    13b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
    13be:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13c1:	ba 00 00 00 00       	mov    $0x0,%edx
    13c6:	f7 f1                	div    %ecx
    13c8:	89 d0                	mov    %edx,%eax
    13ca:	8a 80 54 2a 00 00    	mov    0x2a54(%eax),%al
    13d0:	8d 4d dc             	lea    -0x24(%ebp),%ecx
    13d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
    13d6:	01 ca                	add    %ecx,%edx
    13d8:	88 02                	mov    %al,(%edx)
    13da:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
    13dd:	8b 55 10             	mov    0x10(%ebp),%edx
    13e0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    13e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13e6:	ba 00 00 00 00       	mov    $0x0,%edx
    13eb:	f7 75 d4             	divl   -0x2c(%ebp)
    13ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    13f5:	75 c4                	jne    13bb <printint+0x37>
  if(neg)
    13f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    13fb:	74 2c                	je     1429 <printint+0xa5>
    buf[i++] = '-';
    13fd:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1400:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1403:	01 d0                	add    %edx,%eax
    1405:	c6 00 2d             	movb   $0x2d,(%eax)
    1408:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
    140b:	eb 1c                	jmp    1429 <printint+0xa5>
    putc(fd, buf[i]);
    140d:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1410:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1413:	01 d0                	add    %edx,%eax
    1415:	8a 00                	mov    (%eax),%al
    1417:	0f be c0             	movsbl %al,%eax
    141a:	89 44 24 04          	mov    %eax,0x4(%esp)
    141e:	8b 45 08             	mov    0x8(%ebp),%eax
    1421:	89 04 24             	mov    %eax,(%esp)
    1424:	e8 33 ff ff ff       	call   135c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1429:	ff 4d f4             	decl   -0xc(%ebp)
    142c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1430:	79 db                	jns    140d <printint+0x89>
    putc(fd, buf[i]);
}
    1432:	c9                   	leave  
    1433:	c3                   	ret    

00001434 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1434:	55                   	push   %ebp
    1435:	89 e5                	mov    %esp,%ebp
    1437:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    143a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1441:	8d 45 0c             	lea    0xc(%ebp),%eax
    1444:	83 c0 04             	add    $0x4,%eax
    1447:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    144a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1451:	e9 78 01 00 00       	jmp    15ce <printf+0x19a>
    c = fmt[i] & 0xff;
    1456:	8b 55 0c             	mov    0xc(%ebp),%edx
    1459:	8b 45 f0             	mov    -0x10(%ebp),%eax
    145c:	01 d0                	add    %edx,%eax
    145e:	8a 00                	mov    (%eax),%al
    1460:	0f be c0             	movsbl %al,%eax
    1463:	25 ff 00 00 00       	and    $0xff,%eax
    1468:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    146b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    146f:	75 2c                	jne    149d <printf+0x69>
      if(c == '%'){
    1471:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1475:	75 0c                	jne    1483 <printf+0x4f>
        state = '%';
    1477:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    147e:	e9 48 01 00 00       	jmp    15cb <printf+0x197>
      } else {
        putc(fd, c);
    1483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1486:	0f be c0             	movsbl %al,%eax
    1489:	89 44 24 04          	mov    %eax,0x4(%esp)
    148d:	8b 45 08             	mov    0x8(%ebp),%eax
    1490:	89 04 24             	mov    %eax,(%esp)
    1493:	e8 c4 fe ff ff       	call   135c <putc>
    1498:	e9 2e 01 00 00       	jmp    15cb <printf+0x197>
      }
    } else if(state == '%'){
    149d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14a1:	0f 85 24 01 00 00    	jne    15cb <printf+0x197>
      if(c == 'd'){
    14a7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14ab:	75 2d                	jne    14da <printf+0xa6>
        printint(fd, *ap, 10, 1);
    14ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14b0:	8b 00                	mov    (%eax),%eax
    14b2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    14b9:	00 
    14ba:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14c1:	00 
    14c2:	89 44 24 04          	mov    %eax,0x4(%esp)
    14c6:	8b 45 08             	mov    0x8(%ebp),%eax
    14c9:	89 04 24             	mov    %eax,(%esp)
    14cc:	e8 b3 fe ff ff       	call   1384 <printint>
        ap++;
    14d1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14d5:	e9 ea 00 00 00       	jmp    15c4 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
    14da:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    14de:	74 06                	je     14e6 <printf+0xb2>
    14e0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    14e4:	75 2d                	jne    1513 <printf+0xdf>
        printint(fd, *ap, 16, 0);
    14e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14e9:	8b 00                	mov    (%eax),%eax
    14eb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    14f2:	00 
    14f3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    14fa:	00 
    14fb:	89 44 24 04          	mov    %eax,0x4(%esp)
    14ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1502:	89 04 24             	mov    %eax,(%esp)
    1505:	e8 7a fe ff ff       	call   1384 <printint>
        ap++;
    150a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    150e:	e9 b1 00 00 00       	jmp    15c4 <printf+0x190>
      } else if(c == 's'){
    1513:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1517:	75 43                	jne    155c <printf+0x128>
        s = (char*)*ap;
    1519:	8b 45 e8             	mov    -0x18(%ebp),%eax
    151c:	8b 00                	mov    (%eax),%eax
    151e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1521:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1525:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1529:	75 25                	jne    1550 <printf+0x11c>
          s = "(null)";
    152b:	c7 45 f4 0f 18 00 00 	movl   $0x180f,-0xc(%ebp)
        while(*s != 0){
    1532:	eb 1c                	jmp    1550 <printf+0x11c>
          putc(fd, *s);
    1534:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1537:	8a 00                	mov    (%eax),%al
    1539:	0f be c0             	movsbl %al,%eax
    153c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1540:	8b 45 08             	mov    0x8(%ebp),%eax
    1543:	89 04 24             	mov    %eax,(%esp)
    1546:	e8 11 fe ff ff       	call   135c <putc>
          s++;
    154b:	ff 45 f4             	incl   -0xc(%ebp)
    154e:	eb 01                	jmp    1551 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1550:	90                   	nop
    1551:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1554:	8a 00                	mov    (%eax),%al
    1556:	84 c0                	test   %al,%al
    1558:	75 da                	jne    1534 <printf+0x100>
    155a:	eb 68                	jmp    15c4 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    155c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1560:	75 1d                	jne    157f <printf+0x14b>
        putc(fd, *ap);
    1562:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1565:	8b 00                	mov    (%eax),%eax
    1567:	0f be c0             	movsbl %al,%eax
    156a:	89 44 24 04          	mov    %eax,0x4(%esp)
    156e:	8b 45 08             	mov    0x8(%ebp),%eax
    1571:	89 04 24             	mov    %eax,(%esp)
    1574:	e8 e3 fd ff ff       	call   135c <putc>
        ap++;
    1579:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    157d:	eb 45                	jmp    15c4 <printf+0x190>
      } else if(c == '%'){
    157f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1583:	75 17                	jne    159c <printf+0x168>
        putc(fd, c);
    1585:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1588:	0f be c0             	movsbl %al,%eax
    158b:	89 44 24 04          	mov    %eax,0x4(%esp)
    158f:	8b 45 08             	mov    0x8(%ebp),%eax
    1592:	89 04 24             	mov    %eax,(%esp)
    1595:	e8 c2 fd ff ff       	call   135c <putc>
    159a:	eb 28                	jmp    15c4 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    159c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    15a3:	00 
    15a4:	8b 45 08             	mov    0x8(%ebp),%eax
    15a7:	89 04 24             	mov    %eax,(%esp)
    15aa:	e8 ad fd ff ff       	call   135c <putc>
        putc(fd, c);
    15af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15b2:	0f be c0             	movsbl %al,%eax
    15b5:	89 44 24 04          	mov    %eax,0x4(%esp)
    15b9:	8b 45 08             	mov    0x8(%ebp),%eax
    15bc:	89 04 24             	mov    %eax,(%esp)
    15bf:	e8 98 fd ff ff       	call   135c <putc>
      }
      state = 0;
    15c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    15cb:	ff 45 f0             	incl   -0x10(%ebp)
    15ce:	8b 55 0c             	mov    0xc(%ebp),%edx
    15d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15d4:	01 d0                	add    %edx,%eax
    15d6:	8a 00                	mov    (%eax),%al
    15d8:	84 c0                	test   %al,%al
    15da:	0f 85 76 fe ff ff    	jne    1456 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    15e0:	c9                   	leave  
    15e1:	c3                   	ret    
    15e2:	66 90                	xchg   %ax,%ax

000015e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15e4:	55                   	push   %ebp
    15e5:	89 e5                	mov    %esp,%ebp
    15e7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    15ea:	8b 45 08             	mov    0x8(%ebp),%eax
    15ed:	83 e8 08             	sub    $0x8,%eax
    15f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    15f3:	a1 70 2a 00 00       	mov    0x2a70,%eax
    15f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    15fb:	eb 24                	jmp    1621 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1600:	8b 00                	mov    (%eax),%eax
    1602:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1605:	77 12                	ja     1619 <free+0x35>
    1607:	8b 45 f8             	mov    -0x8(%ebp),%eax
    160a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    160d:	77 24                	ja     1633 <free+0x4f>
    160f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1612:	8b 00                	mov    (%eax),%eax
    1614:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1617:	77 1a                	ja     1633 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1619:	8b 45 fc             	mov    -0x4(%ebp),%eax
    161c:	8b 00                	mov    (%eax),%eax
    161e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1621:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1624:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1627:	76 d4                	jbe    15fd <free+0x19>
    1629:	8b 45 fc             	mov    -0x4(%ebp),%eax
    162c:	8b 00                	mov    (%eax),%eax
    162e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1631:	76 ca                	jbe    15fd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1633:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1636:	8b 40 04             	mov    0x4(%eax),%eax
    1639:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1640:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1643:	01 c2                	add    %eax,%edx
    1645:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1648:	8b 00                	mov    (%eax),%eax
    164a:	39 c2                	cmp    %eax,%edx
    164c:	75 24                	jne    1672 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    164e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1651:	8b 50 04             	mov    0x4(%eax),%edx
    1654:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1657:	8b 00                	mov    (%eax),%eax
    1659:	8b 40 04             	mov    0x4(%eax),%eax
    165c:	01 c2                	add    %eax,%edx
    165e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1661:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1664:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1667:	8b 00                	mov    (%eax),%eax
    1669:	8b 10                	mov    (%eax),%edx
    166b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    166e:	89 10                	mov    %edx,(%eax)
    1670:	eb 0a                	jmp    167c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1672:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1675:	8b 10                	mov    (%eax),%edx
    1677:	8b 45 f8             	mov    -0x8(%ebp),%eax
    167a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    167c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    167f:	8b 40 04             	mov    0x4(%eax),%eax
    1682:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1689:	8b 45 fc             	mov    -0x4(%ebp),%eax
    168c:	01 d0                	add    %edx,%eax
    168e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1691:	75 20                	jne    16b3 <free+0xcf>
    p->s.size += bp->s.size;
    1693:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1696:	8b 50 04             	mov    0x4(%eax),%edx
    1699:	8b 45 f8             	mov    -0x8(%ebp),%eax
    169c:	8b 40 04             	mov    0x4(%eax),%eax
    169f:	01 c2                	add    %eax,%edx
    16a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16aa:	8b 10                	mov    (%eax),%edx
    16ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16af:	89 10                	mov    %edx,(%eax)
    16b1:	eb 08                	jmp    16bb <free+0xd7>
  } else
    p->s.ptr = bp;
    16b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b6:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16b9:	89 10                	mov    %edx,(%eax)
  freep = p;
    16bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16be:	a3 70 2a 00 00       	mov    %eax,0x2a70
}
    16c3:	c9                   	leave  
    16c4:	c3                   	ret    

000016c5 <morecore>:

static Header*
morecore(uint nu)
{
    16c5:	55                   	push   %ebp
    16c6:	89 e5                	mov    %esp,%ebp
    16c8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    16cb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    16d2:	77 07                	ja     16db <morecore+0x16>
    nu = 4096;
    16d4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    16db:	8b 45 08             	mov    0x8(%ebp),%eax
    16de:	c1 e0 03             	shl    $0x3,%eax
    16e1:	89 04 24             	mov    %eax,(%esp)
    16e4:	e8 53 fc ff ff       	call   133c <sbrk>
    16e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    16ec:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    16f0:	75 07                	jne    16f9 <morecore+0x34>
    return 0;
    16f2:	b8 00 00 00 00       	mov    $0x0,%eax
    16f7:	eb 22                	jmp    171b <morecore+0x56>
  hp = (Header*)p;
    16f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    16ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1702:	8b 55 08             	mov    0x8(%ebp),%edx
    1705:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1708:	8b 45 f0             	mov    -0x10(%ebp),%eax
    170b:	83 c0 08             	add    $0x8,%eax
    170e:	89 04 24             	mov    %eax,(%esp)
    1711:	e8 ce fe ff ff       	call   15e4 <free>
  return freep;
    1716:	a1 70 2a 00 00       	mov    0x2a70,%eax
}
    171b:	c9                   	leave  
    171c:	c3                   	ret    

0000171d <malloc>:

void*
malloc(uint nbytes)
{
    171d:	55                   	push   %ebp
    171e:	89 e5                	mov    %esp,%ebp
    1720:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1723:	8b 45 08             	mov    0x8(%ebp),%eax
    1726:	83 c0 07             	add    $0x7,%eax
    1729:	c1 e8 03             	shr    $0x3,%eax
    172c:	40                   	inc    %eax
    172d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1730:	a1 70 2a 00 00       	mov    0x2a70,%eax
    1735:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1738:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    173c:	75 23                	jne    1761 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    173e:	c7 45 f0 68 2a 00 00 	movl   $0x2a68,-0x10(%ebp)
    1745:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1748:	a3 70 2a 00 00       	mov    %eax,0x2a70
    174d:	a1 70 2a 00 00       	mov    0x2a70,%eax
    1752:	a3 68 2a 00 00       	mov    %eax,0x2a68
    base.s.size = 0;
    1757:	c7 05 6c 2a 00 00 00 	movl   $0x0,0x2a6c
    175e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1761:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1764:	8b 00                	mov    (%eax),%eax
    1766:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1769:	8b 45 f4             	mov    -0xc(%ebp),%eax
    176c:	8b 40 04             	mov    0x4(%eax),%eax
    176f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1772:	72 4d                	jb     17c1 <malloc+0xa4>
      if(p->s.size == nunits)
    1774:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1777:	8b 40 04             	mov    0x4(%eax),%eax
    177a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    177d:	75 0c                	jne    178b <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    177f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1782:	8b 10                	mov    (%eax),%edx
    1784:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1787:	89 10                	mov    %edx,(%eax)
    1789:	eb 26                	jmp    17b1 <malloc+0x94>
      else {
        p->s.size -= nunits;
    178b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    178e:	8b 40 04             	mov    0x4(%eax),%eax
    1791:	89 c2                	mov    %eax,%edx
    1793:	2b 55 ec             	sub    -0x14(%ebp),%edx
    1796:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1799:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    179c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    179f:	8b 40 04             	mov    0x4(%eax),%eax
    17a2:	c1 e0 03             	shl    $0x3,%eax
    17a5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17ae:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17b4:	a3 70 2a 00 00       	mov    %eax,0x2a70
      return (void*)(p + 1);
    17b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17bc:	83 c0 08             	add    $0x8,%eax
    17bf:	eb 38                	jmp    17f9 <malloc+0xdc>
    }
    if(p == freep)
    17c1:	a1 70 2a 00 00       	mov    0x2a70,%eax
    17c6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    17c9:	75 1b                	jne    17e6 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    17cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17ce:	89 04 24             	mov    %eax,(%esp)
    17d1:	e8 ef fe ff ff       	call   16c5 <morecore>
    17d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    17d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17dd:	75 07                	jne    17e6 <malloc+0xc9>
        return 0;
    17df:	b8 00 00 00 00       	mov    $0x0,%eax
    17e4:	eb 13                	jmp    17f9 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    17ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ef:	8b 00                	mov    (%eax),%eax
    17f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    17f4:	e9 70 ff ff ff       	jmp    1769 <malloc+0x4c>
}
    17f9:	c9                   	leave  
    17fa:	c3                   	ret    
