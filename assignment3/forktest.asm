
_forktest:     file format elf32-i386


Disassembly of section .text:

00001000 <printf>:

#define N  100

void
printf(int fd, char *s, ...)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 18             	sub    $0x18,%esp
  write(fd, s, strlen(s));
    1006:	8b 45 0c             	mov    0xc(%ebp),%eax
    1009:	89 04 24             	mov    %eax,(%esp)
    100c:	e8 8a 01 00 00       	call   119b <strlen>
    1011:	89 44 24 08          	mov    %eax,0x8(%esp)
    1015:	8b 45 0c             	mov    0xc(%ebp),%eax
    1018:	89 44 24 04          	mov    %eax,0x4(%esp)
    101c:	8b 45 08             	mov    0x8(%ebp),%eax
    101f:	89 04 24             	mov    %eax,(%esp)
    1022:	e8 51 03 00 00       	call   1378 <write>
}
    1027:	c9                   	leave  
    1028:	c3                   	ret    

00001029 <forktest>:

void
forktest(void)
{
    1029:	55                   	push   %ebp
    102a:	89 e5                	mov    %esp,%ebp
    102c:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
    102f:	c7 44 24 04 00 14 00 	movl   $0x1400,0x4(%esp)
    1036:	00 
    1037:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    103e:	e8 bd ff ff ff       	call   1000 <printf>

  for(n=0; n<N; n++) {
    1043:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    104a:	eb 1c                	jmp    1068 <forktest+0x3f>
    pid = cowfork();
    104c:	e8 a7 03 00 00       	call   13f8 <cowfork>
    1051:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    1054:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1058:	78 16                	js     1070 <forktest+0x47>
      break;
    if(pid == 0)
    105a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    105e:	75 05                	jne    1065 <forktest+0x3c>
      exit();
    1060:	e8 f3 02 00 00       	call   1358 <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<N; n++) {
    1065:	ff 45 f4             	incl   -0xc(%ebp)
    1068:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    106c:	7e de                	jle    104c <forktest+0x23>
    106e:	eb 01                	jmp    1071 <forktest+0x48>
    pid = cowfork();
    if(pid < 0)
      break;
    1070:	90                   	nop
    if(pid == 0)
      exit();
  }
  
  if(n == N) {
    1071:	83 7d f4 64          	cmpl   $0x64,-0xc(%ebp)
    1075:	75 46                	jne    10bd <forktest+0x94>
    printf(1, "fork claimed to work N times!\n", N);
    1077:	c7 44 24 08 64 00 00 	movl   $0x64,0x8(%esp)
    107e:	00 
    107f:	c7 44 24 04 0c 14 00 	movl   $0x140c,0x4(%esp)
    1086:	00 
    1087:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    108e:	e8 6d ff ff ff       	call   1000 <printf>
    exit();
    1093:	e8 c0 02 00 00       	call   1358 <exit>
  }
  
  for(; n > 0; n--) {
    if(wait() < 0){
    1098:	e8 c3 02 00 00       	call   1360 <wait>
    109d:	85 c0                	test   %eax,%eax
    109f:	79 19                	jns    10ba <forktest+0x91>
      printf(1, "wait stopped early\n");
    10a1:	c7 44 24 04 2b 14 00 	movl   $0x142b,0x4(%esp)
    10a8:	00 
    10a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10b0:	e8 4b ff ff ff       	call   1000 <printf>
      exit();
    10b5:	e8 9e 02 00 00       	call   1358 <exit>
  if(n == N) {
    printf(1, "fork claimed to work N times!\n", N);
    exit();
  }
  
  for(; n > 0; n--) {
    10ba:	ff 4d f4             	decl   -0xc(%ebp)
    10bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10c1:	7f d5                	jg     1098 <forktest+0x6f>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1) {
    10c3:	e8 98 02 00 00       	call   1360 <wait>
    10c8:	83 f8 ff             	cmp    $0xffffffff,%eax
    10cb:	74 19                	je     10e6 <forktest+0xbd>
    printf(1, "wait got too many\n");
    10cd:	c7 44 24 04 3f 14 00 	movl   $0x143f,0x4(%esp)
    10d4:	00 
    10d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10dc:	e8 1f ff ff ff       	call   1000 <printf>
    exit();
    10e1:	e8 72 02 00 00       	call   1358 <exit>
  }
  
  printf(1, "fork test OK\n");
    10e6:	c7 44 24 04 52 14 00 	movl   $0x1452,0x4(%esp)
    10ed:	00 
    10ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10f5:	e8 06 ff ff ff       	call   1000 <printf>
}
    10fa:	c9                   	leave  
    10fb:	c3                   	ret    

000010fc <main>:

int
main(void)
{
    10fc:	55                   	push   %ebp
    10fd:	89 e5                	mov    %esp,%ebp
    10ff:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
    1102:	e8 22 ff ff ff       	call   1029 <forktest>
  exit();
    1107:	e8 4c 02 00 00       	call   1358 <exit>

0000110c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    110c:	55                   	push   %ebp
    110d:	89 e5                	mov    %esp,%ebp
    110f:	57                   	push   %edi
    1110:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1111:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1114:	8b 55 10             	mov    0x10(%ebp),%edx
    1117:	8b 45 0c             	mov    0xc(%ebp),%eax
    111a:	89 cb                	mov    %ecx,%ebx
    111c:	89 df                	mov    %ebx,%edi
    111e:	89 d1                	mov    %edx,%ecx
    1120:	fc                   	cld    
    1121:	f3 aa                	rep stos %al,%es:(%edi)
    1123:	89 ca                	mov    %ecx,%edx
    1125:	89 fb                	mov    %edi,%ebx
    1127:	89 5d 08             	mov    %ebx,0x8(%ebp)
    112a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    112d:	5b                   	pop    %ebx
    112e:	5f                   	pop    %edi
    112f:	5d                   	pop    %ebp
    1130:	c3                   	ret    

00001131 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1131:	55                   	push   %ebp
    1132:	89 e5                	mov    %esp,%ebp
    1134:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1137:	8b 45 08             	mov    0x8(%ebp),%eax
    113a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    113d:	90                   	nop
    113e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1141:	8a 10                	mov    (%eax),%dl
    1143:	8b 45 08             	mov    0x8(%ebp),%eax
    1146:	88 10                	mov    %dl,(%eax)
    1148:	8b 45 08             	mov    0x8(%ebp),%eax
    114b:	8a 00                	mov    (%eax),%al
    114d:	84 c0                	test   %al,%al
    114f:	0f 95 c0             	setne  %al
    1152:	ff 45 08             	incl   0x8(%ebp)
    1155:	ff 45 0c             	incl   0xc(%ebp)
    1158:	84 c0                	test   %al,%al
    115a:	75 e2                	jne    113e <strcpy+0xd>
    ;
  return os;
    115c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    115f:	c9                   	leave  
    1160:	c3                   	ret    

00001161 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1161:	55                   	push   %ebp
    1162:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1164:	eb 06                	jmp    116c <strcmp+0xb>
    p++, q++;
    1166:	ff 45 08             	incl   0x8(%ebp)
    1169:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    116c:	8b 45 08             	mov    0x8(%ebp),%eax
    116f:	8a 00                	mov    (%eax),%al
    1171:	84 c0                	test   %al,%al
    1173:	74 0e                	je     1183 <strcmp+0x22>
    1175:	8b 45 08             	mov    0x8(%ebp),%eax
    1178:	8a 10                	mov    (%eax),%dl
    117a:	8b 45 0c             	mov    0xc(%ebp),%eax
    117d:	8a 00                	mov    (%eax),%al
    117f:	38 c2                	cmp    %al,%dl
    1181:	74 e3                	je     1166 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1183:	8b 45 08             	mov    0x8(%ebp),%eax
    1186:	8a 00                	mov    (%eax),%al
    1188:	0f b6 d0             	movzbl %al,%edx
    118b:	8b 45 0c             	mov    0xc(%ebp),%eax
    118e:	8a 00                	mov    (%eax),%al
    1190:	0f b6 c0             	movzbl %al,%eax
    1193:	89 d1                	mov    %edx,%ecx
    1195:	29 c1                	sub    %eax,%ecx
    1197:	89 c8                	mov    %ecx,%eax
}
    1199:	5d                   	pop    %ebp
    119a:	c3                   	ret    

0000119b <strlen>:

uint
strlen(char *s)
{
    119b:	55                   	push   %ebp
    119c:	89 e5                	mov    %esp,%ebp
    119e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11a8:	eb 03                	jmp    11ad <strlen+0x12>
    11aa:	ff 45 fc             	incl   -0x4(%ebp)
    11ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11b0:	8b 45 08             	mov    0x8(%ebp),%eax
    11b3:	01 d0                	add    %edx,%eax
    11b5:	8a 00                	mov    (%eax),%al
    11b7:	84 c0                	test   %al,%al
    11b9:	75 ef                	jne    11aa <strlen+0xf>
    ;
  return n;
    11bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11be:	c9                   	leave  
    11bf:	c3                   	ret    

000011c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11c0:	55                   	push   %ebp
    11c1:	89 e5                	mov    %esp,%ebp
    11c3:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    11c6:	8b 45 10             	mov    0x10(%ebp),%eax
    11c9:	89 44 24 08          	mov    %eax,0x8(%esp)
    11cd:	8b 45 0c             	mov    0xc(%ebp),%eax
    11d0:	89 44 24 04          	mov    %eax,0x4(%esp)
    11d4:	8b 45 08             	mov    0x8(%ebp),%eax
    11d7:	89 04 24             	mov    %eax,(%esp)
    11da:	e8 2d ff ff ff       	call   110c <stosb>
  return dst;
    11df:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11e2:	c9                   	leave  
    11e3:	c3                   	ret    

000011e4 <strchr>:

char*
strchr(const char *s, char c)
{
    11e4:	55                   	push   %ebp
    11e5:	89 e5                	mov    %esp,%ebp
    11e7:	83 ec 04             	sub    $0x4,%esp
    11ea:	8b 45 0c             	mov    0xc(%ebp),%eax
    11ed:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    11f0:	eb 12                	jmp    1204 <strchr+0x20>
    if(*s == c)
    11f2:	8b 45 08             	mov    0x8(%ebp),%eax
    11f5:	8a 00                	mov    (%eax),%al
    11f7:	3a 45 fc             	cmp    -0x4(%ebp),%al
    11fa:	75 05                	jne    1201 <strchr+0x1d>
      return (char*)s;
    11fc:	8b 45 08             	mov    0x8(%ebp),%eax
    11ff:	eb 11                	jmp    1212 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1201:	ff 45 08             	incl   0x8(%ebp)
    1204:	8b 45 08             	mov    0x8(%ebp),%eax
    1207:	8a 00                	mov    (%eax),%al
    1209:	84 c0                	test   %al,%al
    120b:	75 e5                	jne    11f2 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    120d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1212:	c9                   	leave  
    1213:	c3                   	ret    

00001214 <gets>:

char*
gets(char *buf, int max)
{
    1214:	55                   	push   %ebp
    1215:	89 e5                	mov    %esp,%ebp
    1217:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    121a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1221:	eb 42                	jmp    1265 <gets+0x51>
    cc = read(0, &c, 1);
    1223:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    122a:	00 
    122b:	8d 45 ef             	lea    -0x11(%ebp),%eax
    122e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1232:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1239:	e8 32 01 00 00       	call   1370 <read>
    123e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1241:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1245:	7e 29                	jle    1270 <gets+0x5c>
      break;
    buf[i++] = c;
    1247:	8b 55 f4             	mov    -0xc(%ebp),%edx
    124a:	8b 45 08             	mov    0x8(%ebp),%eax
    124d:	01 c2                	add    %eax,%edx
    124f:	8a 45 ef             	mov    -0x11(%ebp),%al
    1252:	88 02                	mov    %al,(%edx)
    1254:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
    1257:	8a 45 ef             	mov    -0x11(%ebp),%al
    125a:	3c 0a                	cmp    $0xa,%al
    125c:	74 13                	je     1271 <gets+0x5d>
    125e:	8a 45 ef             	mov    -0x11(%ebp),%al
    1261:	3c 0d                	cmp    $0xd,%al
    1263:	74 0c                	je     1271 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1265:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1268:	40                   	inc    %eax
    1269:	3b 45 0c             	cmp    0xc(%ebp),%eax
    126c:	7c b5                	jl     1223 <gets+0xf>
    126e:	eb 01                	jmp    1271 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    1270:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1271:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1274:	8b 45 08             	mov    0x8(%ebp),%eax
    1277:	01 d0                	add    %edx,%eax
    1279:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    127c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    127f:	c9                   	leave  
    1280:	c3                   	ret    

00001281 <stat>:

int
stat(char *n, struct stat *st)
{
    1281:	55                   	push   %ebp
    1282:	89 e5                	mov    %esp,%ebp
    1284:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1287:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    128e:	00 
    128f:	8b 45 08             	mov    0x8(%ebp),%eax
    1292:	89 04 24             	mov    %eax,(%esp)
    1295:	e8 fe 00 00 00       	call   1398 <open>
    129a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    129d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12a1:	79 07                	jns    12aa <stat+0x29>
    return -1;
    12a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12a8:	eb 23                	jmp    12cd <stat+0x4c>
  r = fstat(fd, st);
    12aa:	8b 45 0c             	mov    0xc(%ebp),%eax
    12ad:	89 44 24 04          	mov    %eax,0x4(%esp)
    12b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12b4:	89 04 24             	mov    %eax,(%esp)
    12b7:	e8 f4 00 00 00       	call   13b0 <fstat>
    12bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    12bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12c2:	89 04 24             	mov    %eax,(%esp)
    12c5:	e8 b6 00 00 00       	call   1380 <close>
  return r;
    12ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    12cd:	c9                   	leave  
    12ce:	c3                   	ret    

000012cf <atoi>:

int
atoi(const char *s)
{
    12cf:	55                   	push   %ebp
    12d0:	89 e5                	mov    %esp,%ebp
    12d2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    12d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    12dc:	eb 21                	jmp    12ff <atoi+0x30>
    n = n*10 + *s++ - '0';
    12de:	8b 55 fc             	mov    -0x4(%ebp),%edx
    12e1:	89 d0                	mov    %edx,%eax
    12e3:	c1 e0 02             	shl    $0x2,%eax
    12e6:	01 d0                	add    %edx,%eax
    12e8:	d1 e0                	shl    %eax
    12ea:	89 c2                	mov    %eax,%edx
    12ec:	8b 45 08             	mov    0x8(%ebp),%eax
    12ef:	8a 00                	mov    (%eax),%al
    12f1:	0f be c0             	movsbl %al,%eax
    12f4:	01 d0                	add    %edx,%eax
    12f6:	83 e8 30             	sub    $0x30,%eax
    12f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    12fc:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    12ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1302:	8a 00                	mov    (%eax),%al
    1304:	3c 2f                	cmp    $0x2f,%al
    1306:	7e 09                	jle    1311 <atoi+0x42>
    1308:	8b 45 08             	mov    0x8(%ebp),%eax
    130b:	8a 00                	mov    (%eax),%al
    130d:	3c 39                	cmp    $0x39,%al
    130f:	7e cd                	jle    12de <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1311:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1314:	c9                   	leave  
    1315:	c3                   	ret    

00001316 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1316:	55                   	push   %ebp
    1317:	89 e5                	mov    %esp,%ebp
    1319:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    131c:	8b 45 08             	mov    0x8(%ebp),%eax
    131f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1322:	8b 45 0c             	mov    0xc(%ebp),%eax
    1325:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1328:	eb 10                	jmp    133a <memmove+0x24>
    *dst++ = *src++;
    132a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    132d:	8a 10                	mov    (%eax),%dl
    132f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1332:	88 10                	mov    %dl,(%eax)
    1334:	ff 45 fc             	incl   -0x4(%ebp)
    1337:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    133a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    133e:	0f 9f c0             	setg   %al
    1341:	ff 4d 10             	decl   0x10(%ebp)
    1344:	84 c0                	test   %al,%al
    1346:	75 e2                	jne    132a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1348:	8b 45 08             	mov    0x8(%ebp),%eax
}
    134b:	c9                   	leave  
    134c:	c3                   	ret    
    134d:	66 90                	xchg   %ax,%ax
    134f:	90                   	nop

00001350 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1350:	b8 01 00 00 00       	mov    $0x1,%eax
    1355:	cd 40                	int    $0x40
    1357:	c3                   	ret    

00001358 <exit>:
SYSCALL(exit)
    1358:	b8 02 00 00 00       	mov    $0x2,%eax
    135d:	cd 40                	int    $0x40
    135f:	c3                   	ret    

00001360 <wait>:
SYSCALL(wait)
    1360:	b8 03 00 00 00       	mov    $0x3,%eax
    1365:	cd 40                	int    $0x40
    1367:	c3                   	ret    

00001368 <pipe>:
SYSCALL(pipe)
    1368:	b8 04 00 00 00       	mov    $0x4,%eax
    136d:	cd 40                	int    $0x40
    136f:	c3                   	ret    

00001370 <read>:
SYSCALL(read)
    1370:	b8 05 00 00 00       	mov    $0x5,%eax
    1375:	cd 40                	int    $0x40
    1377:	c3                   	ret    

00001378 <write>:
SYSCALL(write)
    1378:	b8 10 00 00 00       	mov    $0x10,%eax
    137d:	cd 40                	int    $0x40
    137f:	c3                   	ret    

00001380 <close>:
SYSCALL(close)
    1380:	b8 15 00 00 00       	mov    $0x15,%eax
    1385:	cd 40                	int    $0x40
    1387:	c3                   	ret    

00001388 <kill>:
SYSCALL(kill)
    1388:	b8 06 00 00 00       	mov    $0x6,%eax
    138d:	cd 40                	int    $0x40
    138f:	c3                   	ret    

00001390 <exec>:
SYSCALL(exec)
    1390:	b8 07 00 00 00       	mov    $0x7,%eax
    1395:	cd 40                	int    $0x40
    1397:	c3                   	ret    

00001398 <open>:
SYSCALL(open)
    1398:	b8 0f 00 00 00       	mov    $0xf,%eax
    139d:	cd 40                	int    $0x40
    139f:	c3                   	ret    

000013a0 <mknod>:
SYSCALL(mknod)
    13a0:	b8 11 00 00 00       	mov    $0x11,%eax
    13a5:	cd 40                	int    $0x40
    13a7:	c3                   	ret    

000013a8 <unlink>:
SYSCALL(unlink)
    13a8:	b8 12 00 00 00       	mov    $0x12,%eax
    13ad:	cd 40                	int    $0x40
    13af:	c3                   	ret    

000013b0 <fstat>:
SYSCALL(fstat)
    13b0:	b8 08 00 00 00       	mov    $0x8,%eax
    13b5:	cd 40                	int    $0x40
    13b7:	c3                   	ret    

000013b8 <link>:
SYSCALL(link)
    13b8:	b8 13 00 00 00       	mov    $0x13,%eax
    13bd:	cd 40                	int    $0x40
    13bf:	c3                   	ret    

000013c0 <mkdir>:
SYSCALL(mkdir)
    13c0:	b8 14 00 00 00       	mov    $0x14,%eax
    13c5:	cd 40                	int    $0x40
    13c7:	c3                   	ret    

000013c8 <chdir>:
SYSCALL(chdir)
    13c8:	b8 09 00 00 00       	mov    $0x9,%eax
    13cd:	cd 40                	int    $0x40
    13cf:	c3                   	ret    

000013d0 <dup>:
SYSCALL(dup)
    13d0:	b8 0a 00 00 00       	mov    $0xa,%eax
    13d5:	cd 40                	int    $0x40
    13d7:	c3                   	ret    

000013d8 <getpid>:
SYSCALL(getpid)
    13d8:	b8 0b 00 00 00       	mov    $0xb,%eax
    13dd:	cd 40                	int    $0x40
    13df:	c3                   	ret    

000013e0 <sbrk>:
SYSCALL(sbrk)
    13e0:	b8 0c 00 00 00       	mov    $0xc,%eax
    13e5:	cd 40                	int    $0x40
    13e7:	c3                   	ret    

000013e8 <sleep>:
SYSCALL(sleep)
    13e8:	b8 0d 00 00 00       	mov    $0xd,%eax
    13ed:	cd 40                	int    $0x40
    13ef:	c3                   	ret    

000013f0 <uptime>:
SYSCALL(uptime)
    13f0:	b8 0e 00 00 00       	mov    $0xe,%eax
    13f5:	cd 40                	int    $0x40
    13f7:	c3                   	ret    

000013f8 <cowfork>:
SYSCALL(cowfork) //3.4
    13f8:	b8 16 00 00 00       	mov    $0x16,%eax
    13fd:	cd 40                	int    $0x40
    13ff:	c3                   	ret    
