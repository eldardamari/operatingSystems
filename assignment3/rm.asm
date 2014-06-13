
_rm:     file format elf32-i386


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

  if(argc < 2){
    1009:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    100d:	7f 19                	jg     1028 <main+0x28>
    printf(2, "Usage: rm files...\n");
    100f:	c7 44 24 04 23 18 00 	movl   $0x1823,0x4(%esp)
    1016:	00 
    1017:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    101e:	e8 39 04 00 00       	call   145c <printf>
    exit();
    1023:	e8 b4 02 00 00       	call   12dc <exit>
  }

  for(i = 1; i < argc; i++){
    1028:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    102f:	00 
    1030:	eb 4e                	jmp    1080 <main+0x80>
    if(unlink(argv[i]) < 0){
    1032:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1036:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    103d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1040:	01 d0                	add    %edx,%eax
    1042:	8b 00                	mov    (%eax),%eax
    1044:	89 04 24             	mov    %eax,(%esp)
    1047:	e8 e0 02 00 00       	call   132c <unlink>
    104c:	85 c0                	test   %eax,%eax
    104e:	79 2c                	jns    107c <main+0x7c>
      printf(2, "rm: %s failed to delete\n", argv[i]);
    1050:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1054:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    105b:	8b 45 0c             	mov    0xc(%ebp),%eax
    105e:	01 d0                	add    %edx,%eax
    1060:	8b 00                	mov    (%eax),%eax
    1062:	89 44 24 08          	mov    %eax,0x8(%esp)
    1066:	c7 44 24 04 37 18 00 	movl   $0x1837,0x4(%esp)
    106d:	00 
    106e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1075:	e8 e2 03 00 00       	call   145c <printf>
      break;
    107a:	eb 0d                	jmp    1089 <main+0x89>
  if(argc < 2){
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
    107c:	ff 44 24 1c          	incl   0x1c(%esp)
    1080:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1084:	3b 45 08             	cmp    0x8(%ebp),%eax
    1087:	7c a9                	jl     1032 <main+0x32>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
    1089:	e8 4e 02 00 00       	call   12dc <exit>
    108e:	66 90                	xchg   %ax,%ax

00001090 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1090:	55                   	push   %ebp
    1091:	89 e5                	mov    %esp,%ebp
    1093:	57                   	push   %edi
    1094:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1095:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1098:	8b 55 10             	mov    0x10(%ebp),%edx
    109b:	8b 45 0c             	mov    0xc(%ebp),%eax
    109e:	89 cb                	mov    %ecx,%ebx
    10a0:	89 df                	mov    %ebx,%edi
    10a2:	89 d1                	mov    %edx,%ecx
    10a4:	fc                   	cld    
    10a5:	f3 aa                	rep stos %al,%es:(%edi)
    10a7:	89 ca                	mov    %ecx,%edx
    10a9:	89 fb                	mov    %edi,%ebx
    10ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
    10ae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10b1:	5b                   	pop    %ebx
    10b2:	5f                   	pop    %edi
    10b3:	5d                   	pop    %ebp
    10b4:	c3                   	ret    

000010b5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10b5:	55                   	push   %ebp
    10b6:	89 e5                	mov    %esp,%ebp
    10b8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    10bb:	8b 45 08             	mov    0x8(%ebp),%eax
    10be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    10c1:	90                   	nop
    10c2:	8b 45 0c             	mov    0xc(%ebp),%eax
    10c5:	8a 10                	mov    (%eax),%dl
    10c7:	8b 45 08             	mov    0x8(%ebp),%eax
    10ca:	88 10                	mov    %dl,(%eax)
    10cc:	8b 45 08             	mov    0x8(%ebp),%eax
    10cf:	8a 00                	mov    (%eax),%al
    10d1:	84 c0                	test   %al,%al
    10d3:	0f 95 c0             	setne  %al
    10d6:	ff 45 08             	incl   0x8(%ebp)
    10d9:	ff 45 0c             	incl   0xc(%ebp)
    10dc:	84 c0                	test   %al,%al
    10de:	75 e2                	jne    10c2 <strcpy+0xd>
    ;
  return os;
    10e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10e3:	c9                   	leave  
    10e4:	c3                   	ret    

000010e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10e5:	55                   	push   %ebp
    10e6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10e8:	eb 06                	jmp    10f0 <strcmp+0xb>
    p++, q++;
    10ea:	ff 45 08             	incl   0x8(%ebp)
    10ed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10f0:	8b 45 08             	mov    0x8(%ebp),%eax
    10f3:	8a 00                	mov    (%eax),%al
    10f5:	84 c0                	test   %al,%al
    10f7:	74 0e                	je     1107 <strcmp+0x22>
    10f9:	8b 45 08             	mov    0x8(%ebp),%eax
    10fc:	8a 10                	mov    (%eax),%dl
    10fe:	8b 45 0c             	mov    0xc(%ebp),%eax
    1101:	8a 00                	mov    (%eax),%al
    1103:	38 c2                	cmp    %al,%dl
    1105:	74 e3                	je     10ea <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1107:	8b 45 08             	mov    0x8(%ebp),%eax
    110a:	8a 00                	mov    (%eax),%al
    110c:	0f b6 d0             	movzbl %al,%edx
    110f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1112:	8a 00                	mov    (%eax),%al
    1114:	0f b6 c0             	movzbl %al,%eax
    1117:	89 d1                	mov    %edx,%ecx
    1119:	29 c1                	sub    %eax,%ecx
    111b:	89 c8                	mov    %ecx,%eax
}
    111d:	5d                   	pop    %ebp
    111e:	c3                   	ret    

0000111f <strlen>:

uint
strlen(char *s)
{
    111f:	55                   	push   %ebp
    1120:	89 e5                	mov    %esp,%ebp
    1122:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1125:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    112c:	eb 03                	jmp    1131 <strlen+0x12>
    112e:	ff 45 fc             	incl   -0x4(%ebp)
    1131:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1134:	8b 45 08             	mov    0x8(%ebp),%eax
    1137:	01 d0                	add    %edx,%eax
    1139:	8a 00                	mov    (%eax),%al
    113b:	84 c0                	test   %al,%al
    113d:	75 ef                	jne    112e <strlen+0xf>
    ;
  return n;
    113f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1142:	c9                   	leave  
    1143:	c3                   	ret    

00001144 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1144:	55                   	push   %ebp
    1145:	89 e5                	mov    %esp,%ebp
    1147:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    114a:	8b 45 10             	mov    0x10(%ebp),%eax
    114d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1151:	8b 45 0c             	mov    0xc(%ebp),%eax
    1154:	89 44 24 04          	mov    %eax,0x4(%esp)
    1158:	8b 45 08             	mov    0x8(%ebp),%eax
    115b:	89 04 24             	mov    %eax,(%esp)
    115e:	e8 2d ff ff ff       	call   1090 <stosb>
  return dst;
    1163:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1166:	c9                   	leave  
    1167:	c3                   	ret    

00001168 <strchr>:

char*
strchr(const char *s, char c)
{
    1168:	55                   	push   %ebp
    1169:	89 e5                	mov    %esp,%ebp
    116b:	83 ec 04             	sub    $0x4,%esp
    116e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1171:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1174:	eb 12                	jmp    1188 <strchr+0x20>
    if(*s == c)
    1176:	8b 45 08             	mov    0x8(%ebp),%eax
    1179:	8a 00                	mov    (%eax),%al
    117b:	3a 45 fc             	cmp    -0x4(%ebp),%al
    117e:	75 05                	jne    1185 <strchr+0x1d>
      return (char*)s;
    1180:	8b 45 08             	mov    0x8(%ebp),%eax
    1183:	eb 11                	jmp    1196 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1185:	ff 45 08             	incl   0x8(%ebp)
    1188:	8b 45 08             	mov    0x8(%ebp),%eax
    118b:	8a 00                	mov    (%eax),%al
    118d:	84 c0                	test   %al,%al
    118f:	75 e5                	jne    1176 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1191:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1196:	c9                   	leave  
    1197:	c3                   	ret    

00001198 <gets>:

char*
gets(char *buf, int max)
{
    1198:	55                   	push   %ebp
    1199:	89 e5                	mov    %esp,%ebp
    119b:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    119e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11a5:	eb 42                	jmp    11e9 <gets+0x51>
    cc = read(0, &c, 1);
    11a7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    11ae:	00 
    11af:	8d 45 ef             	lea    -0x11(%ebp),%eax
    11b2:	89 44 24 04          	mov    %eax,0x4(%esp)
    11b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    11bd:	e8 32 01 00 00       	call   12f4 <read>
    11c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11c9:	7e 29                	jle    11f4 <gets+0x5c>
      break;
    buf[i++] = c;
    11cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11ce:	8b 45 08             	mov    0x8(%ebp),%eax
    11d1:	01 c2                	add    %eax,%edx
    11d3:	8a 45 ef             	mov    -0x11(%ebp),%al
    11d6:	88 02                	mov    %al,(%edx)
    11d8:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
    11db:	8a 45 ef             	mov    -0x11(%ebp),%al
    11de:	3c 0a                	cmp    $0xa,%al
    11e0:	74 13                	je     11f5 <gets+0x5d>
    11e2:	8a 45 ef             	mov    -0x11(%ebp),%al
    11e5:	3c 0d                	cmp    $0xd,%al
    11e7:	74 0c                	je     11f5 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ec:	40                   	inc    %eax
    11ed:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11f0:	7c b5                	jl     11a7 <gets+0xf>
    11f2:	eb 01                	jmp    11f5 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    11f4:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11f8:	8b 45 08             	mov    0x8(%ebp),%eax
    11fb:	01 d0                	add    %edx,%eax
    11fd:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1200:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1203:	c9                   	leave  
    1204:	c3                   	ret    

00001205 <stat>:

int
stat(char *n, struct stat *st)
{
    1205:	55                   	push   %ebp
    1206:	89 e5                	mov    %esp,%ebp
    1208:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    120b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1212:	00 
    1213:	8b 45 08             	mov    0x8(%ebp),%eax
    1216:	89 04 24             	mov    %eax,(%esp)
    1219:	e8 fe 00 00 00       	call   131c <open>
    121e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1221:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1225:	79 07                	jns    122e <stat+0x29>
    return -1;
    1227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    122c:	eb 23                	jmp    1251 <stat+0x4c>
  r = fstat(fd, st);
    122e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1231:	89 44 24 04          	mov    %eax,0x4(%esp)
    1235:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1238:	89 04 24             	mov    %eax,(%esp)
    123b:	e8 f4 00 00 00       	call   1334 <fstat>
    1240:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1243:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1246:	89 04 24             	mov    %eax,(%esp)
    1249:	e8 b6 00 00 00       	call   1304 <close>
  return r;
    124e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1251:	c9                   	leave  
    1252:	c3                   	ret    

00001253 <atoi>:

int
atoi(const char *s)
{
    1253:	55                   	push   %ebp
    1254:	89 e5                	mov    %esp,%ebp
    1256:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1259:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1260:	eb 21                	jmp    1283 <atoi+0x30>
    n = n*10 + *s++ - '0';
    1262:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1265:	89 d0                	mov    %edx,%eax
    1267:	c1 e0 02             	shl    $0x2,%eax
    126a:	01 d0                	add    %edx,%eax
    126c:	d1 e0                	shl    %eax
    126e:	89 c2                	mov    %eax,%edx
    1270:	8b 45 08             	mov    0x8(%ebp),%eax
    1273:	8a 00                	mov    (%eax),%al
    1275:	0f be c0             	movsbl %al,%eax
    1278:	01 d0                	add    %edx,%eax
    127a:	83 e8 30             	sub    $0x30,%eax
    127d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1280:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1283:	8b 45 08             	mov    0x8(%ebp),%eax
    1286:	8a 00                	mov    (%eax),%al
    1288:	3c 2f                	cmp    $0x2f,%al
    128a:	7e 09                	jle    1295 <atoi+0x42>
    128c:	8b 45 08             	mov    0x8(%ebp),%eax
    128f:	8a 00                	mov    (%eax),%al
    1291:	3c 39                	cmp    $0x39,%al
    1293:	7e cd                	jle    1262 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1295:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1298:	c9                   	leave  
    1299:	c3                   	ret    

0000129a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    129a:	55                   	push   %ebp
    129b:	89 e5                	mov    %esp,%ebp
    129d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    12a0:	8b 45 08             	mov    0x8(%ebp),%eax
    12a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    12a6:	8b 45 0c             	mov    0xc(%ebp),%eax
    12a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    12ac:	eb 10                	jmp    12be <memmove+0x24>
    *dst++ = *src++;
    12ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
    12b1:	8a 10                	mov    (%eax),%dl
    12b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12b6:	88 10                	mov    %dl,(%eax)
    12b8:	ff 45 fc             	incl   -0x4(%ebp)
    12bb:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    12c2:	0f 9f c0             	setg   %al
    12c5:	ff 4d 10             	decl   0x10(%ebp)
    12c8:	84 c0                	test   %al,%al
    12ca:	75 e2                	jne    12ae <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    12cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12cf:	c9                   	leave  
    12d0:	c3                   	ret    
    12d1:	66 90                	xchg   %ax,%ax
    12d3:	90                   	nop

000012d4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12d4:	b8 01 00 00 00       	mov    $0x1,%eax
    12d9:	cd 40                	int    $0x40
    12db:	c3                   	ret    

000012dc <exit>:
SYSCALL(exit)
    12dc:	b8 02 00 00 00       	mov    $0x2,%eax
    12e1:	cd 40                	int    $0x40
    12e3:	c3                   	ret    

000012e4 <wait>:
SYSCALL(wait)
    12e4:	b8 03 00 00 00       	mov    $0x3,%eax
    12e9:	cd 40                	int    $0x40
    12eb:	c3                   	ret    

000012ec <pipe>:
SYSCALL(pipe)
    12ec:	b8 04 00 00 00       	mov    $0x4,%eax
    12f1:	cd 40                	int    $0x40
    12f3:	c3                   	ret    

000012f4 <read>:
SYSCALL(read)
    12f4:	b8 05 00 00 00       	mov    $0x5,%eax
    12f9:	cd 40                	int    $0x40
    12fb:	c3                   	ret    

000012fc <write>:
SYSCALL(write)
    12fc:	b8 10 00 00 00       	mov    $0x10,%eax
    1301:	cd 40                	int    $0x40
    1303:	c3                   	ret    

00001304 <close>:
SYSCALL(close)
    1304:	b8 15 00 00 00       	mov    $0x15,%eax
    1309:	cd 40                	int    $0x40
    130b:	c3                   	ret    

0000130c <kill>:
SYSCALL(kill)
    130c:	b8 06 00 00 00       	mov    $0x6,%eax
    1311:	cd 40                	int    $0x40
    1313:	c3                   	ret    

00001314 <exec>:
SYSCALL(exec)
    1314:	b8 07 00 00 00       	mov    $0x7,%eax
    1319:	cd 40                	int    $0x40
    131b:	c3                   	ret    

0000131c <open>:
SYSCALL(open)
    131c:	b8 0f 00 00 00       	mov    $0xf,%eax
    1321:	cd 40                	int    $0x40
    1323:	c3                   	ret    

00001324 <mknod>:
SYSCALL(mknod)
    1324:	b8 11 00 00 00       	mov    $0x11,%eax
    1329:	cd 40                	int    $0x40
    132b:	c3                   	ret    

0000132c <unlink>:
SYSCALL(unlink)
    132c:	b8 12 00 00 00       	mov    $0x12,%eax
    1331:	cd 40                	int    $0x40
    1333:	c3                   	ret    

00001334 <fstat>:
SYSCALL(fstat)
    1334:	b8 08 00 00 00       	mov    $0x8,%eax
    1339:	cd 40                	int    $0x40
    133b:	c3                   	ret    

0000133c <link>:
SYSCALL(link)
    133c:	b8 13 00 00 00       	mov    $0x13,%eax
    1341:	cd 40                	int    $0x40
    1343:	c3                   	ret    

00001344 <mkdir>:
SYSCALL(mkdir)
    1344:	b8 14 00 00 00       	mov    $0x14,%eax
    1349:	cd 40                	int    $0x40
    134b:	c3                   	ret    

0000134c <chdir>:
SYSCALL(chdir)
    134c:	b8 09 00 00 00       	mov    $0x9,%eax
    1351:	cd 40                	int    $0x40
    1353:	c3                   	ret    

00001354 <dup>:
SYSCALL(dup)
    1354:	b8 0a 00 00 00       	mov    $0xa,%eax
    1359:	cd 40                	int    $0x40
    135b:	c3                   	ret    

0000135c <getpid>:
SYSCALL(getpid)
    135c:	b8 0b 00 00 00       	mov    $0xb,%eax
    1361:	cd 40                	int    $0x40
    1363:	c3                   	ret    

00001364 <sbrk>:
SYSCALL(sbrk)
    1364:	b8 0c 00 00 00       	mov    $0xc,%eax
    1369:	cd 40                	int    $0x40
    136b:	c3                   	ret    

0000136c <sleep>:
SYSCALL(sleep)
    136c:	b8 0d 00 00 00       	mov    $0xd,%eax
    1371:	cd 40                	int    $0x40
    1373:	c3                   	ret    

00001374 <uptime>:
SYSCALL(uptime)
    1374:	b8 0e 00 00 00       	mov    $0xe,%eax
    1379:	cd 40                	int    $0x40
    137b:	c3                   	ret    

0000137c <cowfork>:
SYSCALL(cowfork) //3.4
    137c:	b8 16 00 00 00       	mov    $0x16,%eax
    1381:	cd 40                	int    $0x40
    1383:	c3                   	ret    

00001384 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1384:	55                   	push   %ebp
    1385:	89 e5                	mov    %esp,%ebp
    1387:	83 ec 28             	sub    $0x28,%esp
    138a:	8b 45 0c             	mov    0xc(%ebp),%eax
    138d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1390:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1397:	00 
    1398:	8d 45 f4             	lea    -0xc(%ebp),%eax
    139b:	89 44 24 04          	mov    %eax,0x4(%esp)
    139f:	8b 45 08             	mov    0x8(%ebp),%eax
    13a2:	89 04 24             	mov    %eax,(%esp)
    13a5:	e8 52 ff ff ff       	call   12fc <write>
}
    13aa:	c9                   	leave  
    13ab:	c3                   	ret    

000013ac <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13ac:	55                   	push   %ebp
    13ad:	89 e5                	mov    %esp,%ebp
    13af:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    13b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13b9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13bd:	74 17                	je     13d6 <printint+0x2a>
    13bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13c3:	79 11                	jns    13d6 <printint+0x2a>
    neg = 1;
    13c5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13cc:	8b 45 0c             	mov    0xc(%ebp),%eax
    13cf:	f7 d8                	neg    %eax
    13d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13d4:	eb 06                	jmp    13dc <printint+0x30>
  } else {
    x = xx;
    13d6:	8b 45 0c             	mov    0xc(%ebp),%eax
    13d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
    13e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13e9:	ba 00 00 00 00       	mov    $0x0,%edx
    13ee:	f7 f1                	div    %ecx
    13f0:	89 d0                	mov    %edx,%eax
    13f2:	8a 80 94 2a 00 00    	mov    0x2a94(%eax),%al
    13f8:	8d 4d dc             	lea    -0x24(%ebp),%ecx
    13fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
    13fe:	01 ca                	add    %ecx,%edx
    1400:	88 02                	mov    %al,(%edx)
    1402:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
    1405:	8b 55 10             	mov    0x10(%ebp),%edx
    1408:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    140b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    140e:	ba 00 00 00 00       	mov    $0x0,%edx
    1413:	f7 75 d4             	divl   -0x2c(%ebp)
    1416:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1419:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    141d:	75 c4                	jne    13e3 <printint+0x37>
  if(neg)
    141f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1423:	74 2c                	je     1451 <printint+0xa5>
    buf[i++] = '-';
    1425:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1428:	8b 45 f4             	mov    -0xc(%ebp),%eax
    142b:	01 d0                	add    %edx,%eax
    142d:	c6 00 2d             	movb   $0x2d,(%eax)
    1430:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
    1433:	eb 1c                	jmp    1451 <printint+0xa5>
    putc(fd, buf[i]);
    1435:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1438:	8b 45 f4             	mov    -0xc(%ebp),%eax
    143b:	01 d0                	add    %edx,%eax
    143d:	8a 00                	mov    (%eax),%al
    143f:	0f be c0             	movsbl %al,%eax
    1442:	89 44 24 04          	mov    %eax,0x4(%esp)
    1446:	8b 45 08             	mov    0x8(%ebp),%eax
    1449:	89 04 24             	mov    %eax,(%esp)
    144c:	e8 33 ff ff ff       	call   1384 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1451:	ff 4d f4             	decl   -0xc(%ebp)
    1454:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1458:	79 db                	jns    1435 <printint+0x89>
    putc(fd, buf[i]);
}
    145a:	c9                   	leave  
    145b:	c3                   	ret    

0000145c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    145c:	55                   	push   %ebp
    145d:	89 e5                	mov    %esp,%ebp
    145f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1462:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1469:	8d 45 0c             	lea    0xc(%ebp),%eax
    146c:	83 c0 04             	add    $0x4,%eax
    146f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1472:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1479:	e9 78 01 00 00       	jmp    15f6 <printf+0x19a>
    c = fmt[i] & 0xff;
    147e:	8b 55 0c             	mov    0xc(%ebp),%edx
    1481:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1484:	01 d0                	add    %edx,%eax
    1486:	8a 00                	mov    (%eax),%al
    1488:	0f be c0             	movsbl %al,%eax
    148b:	25 ff 00 00 00       	and    $0xff,%eax
    1490:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1493:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1497:	75 2c                	jne    14c5 <printf+0x69>
      if(c == '%'){
    1499:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    149d:	75 0c                	jne    14ab <printf+0x4f>
        state = '%';
    149f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    14a6:	e9 48 01 00 00       	jmp    15f3 <printf+0x197>
      } else {
        putc(fd, c);
    14ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    14ae:	0f be c0             	movsbl %al,%eax
    14b1:	89 44 24 04          	mov    %eax,0x4(%esp)
    14b5:	8b 45 08             	mov    0x8(%ebp),%eax
    14b8:	89 04 24             	mov    %eax,(%esp)
    14bb:	e8 c4 fe ff ff       	call   1384 <putc>
    14c0:	e9 2e 01 00 00       	jmp    15f3 <printf+0x197>
      }
    } else if(state == '%'){
    14c5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14c9:	0f 85 24 01 00 00    	jne    15f3 <printf+0x197>
      if(c == 'd'){
    14cf:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14d3:	75 2d                	jne    1502 <printf+0xa6>
        printint(fd, *ap, 10, 1);
    14d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14d8:	8b 00                	mov    (%eax),%eax
    14da:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    14e1:	00 
    14e2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14e9:	00 
    14ea:	89 44 24 04          	mov    %eax,0x4(%esp)
    14ee:	8b 45 08             	mov    0x8(%ebp),%eax
    14f1:	89 04 24             	mov    %eax,(%esp)
    14f4:	e8 b3 fe ff ff       	call   13ac <printint>
        ap++;
    14f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14fd:	e9 ea 00 00 00       	jmp    15ec <printf+0x190>
      } else if(c == 'x' || c == 'p'){
    1502:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1506:	74 06                	je     150e <printf+0xb2>
    1508:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    150c:	75 2d                	jne    153b <printf+0xdf>
        printint(fd, *ap, 16, 0);
    150e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1511:	8b 00                	mov    (%eax),%eax
    1513:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    151a:	00 
    151b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1522:	00 
    1523:	89 44 24 04          	mov    %eax,0x4(%esp)
    1527:	8b 45 08             	mov    0x8(%ebp),%eax
    152a:	89 04 24             	mov    %eax,(%esp)
    152d:	e8 7a fe ff ff       	call   13ac <printint>
        ap++;
    1532:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1536:	e9 b1 00 00 00       	jmp    15ec <printf+0x190>
      } else if(c == 's'){
    153b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    153f:	75 43                	jne    1584 <printf+0x128>
        s = (char*)*ap;
    1541:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1544:	8b 00                	mov    (%eax),%eax
    1546:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1549:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    154d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1551:	75 25                	jne    1578 <printf+0x11c>
          s = "(null)";
    1553:	c7 45 f4 50 18 00 00 	movl   $0x1850,-0xc(%ebp)
        while(*s != 0){
    155a:	eb 1c                	jmp    1578 <printf+0x11c>
          putc(fd, *s);
    155c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    155f:	8a 00                	mov    (%eax),%al
    1561:	0f be c0             	movsbl %al,%eax
    1564:	89 44 24 04          	mov    %eax,0x4(%esp)
    1568:	8b 45 08             	mov    0x8(%ebp),%eax
    156b:	89 04 24             	mov    %eax,(%esp)
    156e:	e8 11 fe ff ff       	call   1384 <putc>
          s++;
    1573:	ff 45 f4             	incl   -0xc(%ebp)
    1576:	eb 01                	jmp    1579 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1578:	90                   	nop
    1579:	8b 45 f4             	mov    -0xc(%ebp),%eax
    157c:	8a 00                	mov    (%eax),%al
    157e:	84 c0                	test   %al,%al
    1580:	75 da                	jne    155c <printf+0x100>
    1582:	eb 68                	jmp    15ec <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1584:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1588:	75 1d                	jne    15a7 <printf+0x14b>
        putc(fd, *ap);
    158a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    158d:	8b 00                	mov    (%eax),%eax
    158f:	0f be c0             	movsbl %al,%eax
    1592:	89 44 24 04          	mov    %eax,0x4(%esp)
    1596:	8b 45 08             	mov    0x8(%ebp),%eax
    1599:	89 04 24             	mov    %eax,(%esp)
    159c:	e8 e3 fd ff ff       	call   1384 <putc>
        ap++;
    15a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15a5:	eb 45                	jmp    15ec <printf+0x190>
      } else if(c == '%'){
    15a7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15ab:	75 17                	jne    15c4 <printf+0x168>
        putc(fd, c);
    15ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15b0:	0f be c0             	movsbl %al,%eax
    15b3:	89 44 24 04          	mov    %eax,0x4(%esp)
    15b7:	8b 45 08             	mov    0x8(%ebp),%eax
    15ba:	89 04 24             	mov    %eax,(%esp)
    15bd:	e8 c2 fd ff ff       	call   1384 <putc>
    15c2:	eb 28                	jmp    15ec <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15c4:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    15cb:	00 
    15cc:	8b 45 08             	mov    0x8(%ebp),%eax
    15cf:	89 04 24             	mov    %eax,(%esp)
    15d2:	e8 ad fd ff ff       	call   1384 <putc>
        putc(fd, c);
    15d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15da:	0f be c0             	movsbl %al,%eax
    15dd:	89 44 24 04          	mov    %eax,0x4(%esp)
    15e1:	8b 45 08             	mov    0x8(%ebp),%eax
    15e4:	89 04 24             	mov    %eax,(%esp)
    15e7:	e8 98 fd ff ff       	call   1384 <putc>
      }
      state = 0;
    15ec:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    15f3:	ff 45 f0             	incl   -0x10(%ebp)
    15f6:	8b 55 0c             	mov    0xc(%ebp),%edx
    15f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15fc:	01 d0                	add    %edx,%eax
    15fe:	8a 00                	mov    (%eax),%al
    1600:	84 c0                	test   %al,%al
    1602:	0f 85 76 fe ff ff    	jne    147e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1608:	c9                   	leave  
    1609:	c3                   	ret    
    160a:	66 90                	xchg   %ax,%ax

0000160c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    160c:	55                   	push   %ebp
    160d:	89 e5                	mov    %esp,%ebp
    160f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1612:	8b 45 08             	mov    0x8(%ebp),%eax
    1615:	83 e8 08             	sub    $0x8,%eax
    1618:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    161b:	a1 b0 2a 00 00       	mov    0x2ab0,%eax
    1620:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1623:	eb 24                	jmp    1649 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1625:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1628:	8b 00                	mov    (%eax),%eax
    162a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    162d:	77 12                	ja     1641 <free+0x35>
    162f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1632:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1635:	77 24                	ja     165b <free+0x4f>
    1637:	8b 45 fc             	mov    -0x4(%ebp),%eax
    163a:	8b 00                	mov    (%eax),%eax
    163c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    163f:	77 1a                	ja     165b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1641:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1644:	8b 00                	mov    (%eax),%eax
    1646:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1649:	8b 45 f8             	mov    -0x8(%ebp),%eax
    164c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    164f:	76 d4                	jbe    1625 <free+0x19>
    1651:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1654:	8b 00                	mov    (%eax),%eax
    1656:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1659:	76 ca                	jbe    1625 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    165b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    165e:	8b 40 04             	mov    0x4(%eax),%eax
    1661:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1668:	8b 45 f8             	mov    -0x8(%ebp),%eax
    166b:	01 c2                	add    %eax,%edx
    166d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1670:	8b 00                	mov    (%eax),%eax
    1672:	39 c2                	cmp    %eax,%edx
    1674:	75 24                	jne    169a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1676:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1679:	8b 50 04             	mov    0x4(%eax),%edx
    167c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    167f:	8b 00                	mov    (%eax),%eax
    1681:	8b 40 04             	mov    0x4(%eax),%eax
    1684:	01 c2                	add    %eax,%edx
    1686:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1689:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    168c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    168f:	8b 00                	mov    (%eax),%eax
    1691:	8b 10                	mov    (%eax),%edx
    1693:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1696:	89 10                	mov    %edx,(%eax)
    1698:	eb 0a                	jmp    16a4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    169a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    169d:	8b 10                	mov    (%eax),%edx
    169f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16a2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    16a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a7:	8b 40 04             	mov    0x4(%eax),%eax
    16aa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b4:	01 d0                	add    %edx,%eax
    16b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16b9:	75 20                	jne    16db <free+0xcf>
    p->s.size += bp->s.size;
    16bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16be:	8b 50 04             	mov    0x4(%eax),%edx
    16c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16c4:	8b 40 04             	mov    0x4(%eax),%eax
    16c7:	01 c2                	add    %eax,%edx
    16c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16cc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16d2:	8b 10                	mov    (%eax),%edx
    16d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d7:	89 10                	mov    %edx,(%eax)
    16d9:	eb 08                	jmp    16e3 <free+0xd7>
  } else
    p->s.ptr = bp;
    16db:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16de:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16e1:	89 10                	mov    %edx,(%eax)
  freep = p;
    16e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e6:	a3 b0 2a 00 00       	mov    %eax,0x2ab0
}
    16eb:	c9                   	leave  
    16ec:	c3                   	ret    

000016ed <morecore>:

static Header*
morecore(uint nu)
{
    16ed:	55                   	push   %ebp
    16ee:	89 e5                	mov    %esp,%ebp
    16f0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    16f3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    16fa:	77 07                	ja     1703 <morecore+0x16>
    nu = 4096;
    16fc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1703:	8b 45 08             	mov    0x8(%ebp),%eax
    1706:	c1 e0 03             	shl    $0x3,%eax
    1709:	89 04 24             	mov    %eax,(%esp)
    170c:	e8 53 fc ff ff       	call   1364 <sbrk>
    1711:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1714:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1718:	75 07                	jne    1721 <morecore+0x34>
    return 0;
    171a:	b8 00 00 00 00       	mov    $0x0,%eax
    171f:	eb 22                	jmp    1743 <morecore+0x56>
  hp = (Header*)p;
    1721:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1724:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1727:	8b 45 f0             	mov    -0x10(%ebp),%eax
    172a:	8b 55 08             	mov    0x8(%ebp),%edx
    172d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1730:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1733:	83 c0 08             	add    $0x8,%eax
    1736:	89 04 24             	mov    %eax,(%esp)
    1739:	e8 ce fe ff ff       	call   160c <free>
  return freep;
    173e:	a1 b0 2a 00 00       	mov    0x2ab0,%eax
}
    1743:	c9                   	leave  
    1744:	c3                   	ret    

00001745 <malloc>:

void*
malloc(uint nbytes)
{
    1745:	55                   	push   %ebp
    1746:	89 e5                	mov    %esp,%ebp
    1748:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    174b:	8b 45 08             	mov    0x8(%ebp),%eax
    174e:	83 c0 07             	add    $0x7,%eax
    1751:	c1 e8 03             	shr    $0x3,%eax
    1754:	40                   	inc    %eax
    1755:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1758:	a1 b0 2a 00 00       	mov    0x2ab0,%eax
    175d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1760:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1764:	75 23                	jne    1789 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    1766:	c7 45 f0 a8 2a 00 00 	movl   $0x2aa8,-0x10(%ebp)
    176d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1770:	a3 b0 2a 00 00       	mov    %eax,0x2ab0
    1775:	a1 b0 2a 00 00       	mov    0x2ab0,%eax
    177a:	a3 a8 2a 00 00       	mov    %eax,0x2aa8
    base.s.size = 0;
    177f:	c7 05 ac 2a 00 00 00 	movl   $0x0,0x2aac
    1786:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1789:	8b 45 f0             	mov    -0x10(%ebp),%eax
    178c:	8b 00                	mov    (%eax),%eax
    178e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1791:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1794:	8b 40 04             	mov    0x4(%eax),%eax
    1797:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    179a:	72 4d                	jb     17e9 <malloc+0xa4>
      if(p->s.size == nunits)
    179c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    179f:	8b 40 04             	mov    0x4(%eax),%eax
    17a2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    17a5:	75 0c                	jne    17b3 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    17a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17aa:	8b 10                	mov    (%eax),%edx
    17ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17af:	89 10                	mov    %edx,(%eax)
    17b1:	eb 26                	jmp    17d9 <malloc+0x94>
      else {
        p->s.size -= nunits;
    17b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17b6:	8b 40 04             	mov    0x4(%eax),%eax
    17b9:	89 c2                	mov    %eax,%edx
    17bb:	2b 55 ec             	sub    -0x14(%ebp),%edx
    17be:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c7:	8b 40 04             	mov    0x4(%eax),%eax
    17ca:	c1 e0 03             	shl    $0x3,%eax
    17cd:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17d6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17dc:	a3 b0 2a 00 00       	mov    %eax,0x2ab0
      return (void*)(p + 1);
    17e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e4:	83 c0 08             	add    $0x8,%eax
    17e7:	eb 38                	jmp    1821 <malloc+0xdc>
    }
    if(p == freep)
    17e9:	a1 b0 2a 00 00       	mov    0x2ab0,%eax
    17ee:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    17f1:	75 1b                	jne    180e <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    17f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17f6:	89 04 24             	mov    %eax,(%esp)
    17f9:	e8 ef fe ff ff       	call   16ed <morecore>
    17fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1801:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1805:	75 07                	jne    180e <malloc+0xc9>
        return 0;
    1807:	b8 00 00 00 00       	mov    $0x0,%eax
    180c:	eb 13                	jmp    1821 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    180e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1811:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1814:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1817:	8b 00                	mov    (%eax),%eax
    1819:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    181c:	e9 70 ff ff ff       	jmp    1791 <malloc+0x4c>
}
    1821:	c9                   	leave  
    1822:	c3                   	ret    
