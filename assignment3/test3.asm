
_test3:     file format elf32-i386


Disassembly of section .text:

00001000 <testFunction>:

    for(i = 0 ; i < 30 ; i++) {
        printf(1,"%c ",ptr[i]);
    }
    printf(1,"\n");*/
void testFunction(){
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 18             	sub    $0x18,%esp
    printf(1, "***printFunc***\n");
    1006:	c7 44 24 04 10 18 00 	movl   $0x1810,0x4(%esp)
    100d:	00 
    100e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1015:	e8 2e 04 00 00       	call   1448 <printf>
}
    101a:	c9                   	leave  
    101b:	c3                   	ret    

0000101c <main>:

int main (int argc, char** argv){  
    101c:	55                   	push   %ebp
    101d:	89 e5                	mov    %esp,%ebp
    101f:	83 e4 f0             	and    $0xfffffff0,%esp
    1022:	83 ec 10             	sub    $0x10,%esp
    testFunction();
    1025:	e8 d6 ff ff ff       	call   1000 <testFunction>
    printf(1, "writing to text section started\n");  
    102a:	c7 44 24 04 24 18 00 	movl   $0x1824,0x4(%esp)
    1031:	00 
    1032:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1039:	e8 0a 04 00 00       	call   1448 <printf>
    *((int*)testFunction) = 99;
    103e:	b8 00 10 00 00       	mov    $0x1000,%eax
    1043:	c7 00 63 00 00 00    	movl   $0x63,(%eax)
    printf(1, "writing to text section finished\n");
    1049:	c7 44 24 04 48 18 00 	movl   $0x1848,0x4(%esp)
    1050:	00 
    1051:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1058:	e8 eb 03 00 00       	call   1448 <printf>

    if (!fork()) {
    105d:	e8 5e 02 00 00       	call   12c0 <fork>
    1062:	85 c0                	test   %eax,%eax
    1064:	75 07                	jne    106d <main+0x51>
        testFunction();  
    1066:	e8 95 ff ff ff       	call   1000 <testFunction>
    106b:	eb 05                	jmp    1072 <main+0x56>
    } else {
        testFunction();  
    106d:	e8 8e ff ff ff       	call   1000 <testFunction>
    }
    wait();
    1072:	e8 59 02 00 00       	call   12d0 <wait>
    exit();  
    1077:	e8 4c 02 00 00       	call   12c8 <exit>

0000107c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    107c:	55                   	push   %ebp
    107d:	89 e5                	mov    %esp,%ebp
    107f:	57                   	push   %edi
    1080:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1081:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1084:	8b 55 10             	mov    0x10(%ebp),%edx
    1087:	8b 45 0c             	mov    0xc(%ebp),%eax
    108a:	89 cb                	mov    %ecx,%ebx
    108c:	89 df                	mov    %ebx,%edi
    108e:	89 d1                	mov    %edx,%ecx
    1090:	fc                   	cld    
    1091:	f3 aa                	rep stos %al,%es:(%edi)
    1093:	89 ca                	mov    %ecx,%edx
    1095:	89 fb                	mov    %edi,%ebx
    1097:	89 5d 08             	mov    %ebx,0x8(%ebp)
    109a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    109d:	5b                   	pop    %ebx
    109e:	5f                   	pop    %edi
    109f:	5d                   	pop    %ebp
    10a0:	c3                   	ret    

000010a1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10a1:	55                   	push   %ebp
    10a2:	89 e5                	mov    %esp,%ebp
    10a4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    10a7:	8b 45 08             	mov    0x8(%ebp),%eax
    10aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    10ad:	90                   	nop
    10ae:	8b 45 0c             	mov    0xc(%ebp),%eax
    10b1:	8a 10                	mov    (%eax),%dl
    10b3:	8b 45 08             	mov    0x8(%ebp),%eax
    10b6:	88 10                	mov    %dl,(%eax)
    10b8:	8b 45 08             	mov    0x8(%ebp),%eax
    10bb:	8a 00                	mov    (%eax),%al
    10bd:	84 c0                	test   %al,%al
    10bf:	0f 95 c0             	setne  %al
    10c2:	ff 45 08             	incl   0x8(%ebp)
    10c5:	ff 45 0c             	incl   0xc(%ebp)
    10c8:	84 c0                	test   %al,%al
    10ca:	75 e2                	jne    10ae <strcpy+0xd>
    ;
  return os;
    10cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10cf:	c9                   	leave  
    10d0:	c3                   	ret    

000010d1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10d1:	55                   	push   %ebp
    10d2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10d4:	eb 06                	jmp    10dc <strcmp+0xb>
    p++, q++;
    10d6:	ff 45 08             	incl   0x8(%ebp)
    10d9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10dc:	8b 45 08             	mov    0x8(%ebp),%eax
    10df:	8a 00                	mov    (%eax),%al
    10e1:	84 c0                	test   %al,%al
    10e3:	74 0e                	je     10f3 <strcmp+0x22>
    10e5:	8b 45 08             	mov    0x8(%ebp),%eax
    10e8:	8a 10                	mov    (%eax),%dl
    10ea:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ed:	8a 00                	mov    (%eax),%al
    10ef:	38 c2                	cmp    %al,%dl
    10f1:	74 e3                	je     10d6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10f3:	8b 45 08             	mov    0x8(%ebp),%eax
    10f6:	8a 00                	mov    (%eax),%al
    10f8:	0f b6 d0             	movzbl %al,%edx
    10fb:	8b 45 0c             	mov    0xc(%ebp),%eax
    10fe:	8a 00                	mov    (%eax),%al
    1100:	0f b6 c0             	movzbl %al,%eax
    1103:	89 d1                	mov    %edx,%ecx
    1105:	29 c1                	sub    %eax,%ecx
    1107:	89 c8                	mov    %ecx,%eax
}
    1109:	5d                   	pop    %ebp
    110a:	c3                   	ret    

0000110b <strlen>:

uint
strlen(char *s)
{
    110b:	55                   	push   %ebp
    110c:	89 e5                	mov    %esp,%ebp
    110e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1111:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1118:	eb 03                	jmp    111d <strlen+0x12>
    111a:	ff 45 fc             	incl   -0x4(%ebp)
    111d:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1120:	8b 45 08             	mov    0x8(%ebp),%eax
    1123:	01 d0                	add    %edx,%eax
    1125:	8a 00                	mov    (%eax),%al
    1127:	84 c0                	test   %al,%al
    1129:	75 ef                	jne    111a <strlen+0xf>
    ;
  return n;
    112b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    112e:	c9                   	leave  
    112f:	c3                   	ret    

00001130 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1130:	55                   	push   %ebp
    1131:	89 e5                	mov    %esp,%ebp
    1133:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1136:	8b 45 10             	mov    0x10(%ebp),%eax
    1139:	89 44 24 08          	mov    %eax,0x8(%esp)
    113d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1140:	89 44 24 04          	mov    %eax,0x4(%esp)
    1144:	8b 45 08             	mov    0x8(%ebp),%eax
    1147:	89 04 24             	mov    %eax,(%esp)
    114a:	e8 2d ff ff ff       	call   107c <stosb>
  return dst;
    114f:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1152:	c9                   	leave  
    1153:	c3                   	ret    

00001154 <strchr>:

char*
strchr(const char *s, char c)
{
    1154:	55                   	push   %ebp
    1155:	89 e5                	mov    %esp,%ebp
    1157:	83 ec 04             	sub    $0x4,%esp
    115a:	8b 45 0c             	mov    0xc(%ebp),%eax
    115d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1160:	eb 12                	jmp    1174 <strchr+0x20>
    if(*s == c)
    1162:	8b 45 08             	mov    0x8(%ebp),%eax
    1165:	8a 00                	mov    (%eax),%al
    1167:	3a 45 fc             	cmp    -0x4(%ebp),%al
    116a:	75 05                	jne    1171 <strchr+0x1d>
      return (char*)s;
    116c:	8b 45 08             	mov    0x8(%ebp),%eax
    116f:	eb 11                	jmp    1182 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1171:	ff 45 08             	incl   0x8(%ebp)
    1174:	8b 45 08             	mov    0x8(%ebp),%eax
    1177:	8a 00                	mov    (%eax),%al
    1179:	84 c0                	test   %al,%al
    117b:	75 e5                	jne    1162 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    117d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1182:	c9                   	leave  
    1183:	c3                   	ret    

00001184 <gets>:

char*
gets(char *buf, int max)
{
    1184:	55                   	push   %ebp
    1185:	89 e5                	mov    %esp,%ebp
    1187:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    118a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1191:	eb 42                	jmp    11d5 <gets+0x51>
    cc = read(0, &c, 1);
    1193:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    119a:	00 
    119b:	8d 45 ef             	lea    -0x11(%ebp),%eax
    119e:	89 44 24 04          	mov    %eax,0x4(%esp)
    11a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    11a9:	e8 32 01 00 00       	call   12e0 <read>
    11ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11b5:	7e 29                	jle    11e0 <gets+0x5c>
      break;
    buf[i++] = c;
    11b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11ba:	8b 45 08             	mov    0x8(%ebp),%eax
    11bd:	01 c2                	add    %eax,%edx
    11bf:	8a 45 ef             	mov    -0x11(%ebp),%al
    11c2:	88 02                	mov    %al,(%edx)
    11c4:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
    11c7:	8a 45 ef             	mov    -0x11(%ebp),%al
    11ca:	3c 0a                	cmp    $0xa,%al
    11cc:	74 13                	je     11e1 <gets+0x5d>
    11ce:	8a 45 ef             	mov    -0x11(%ebp),%al
    11d1:	3c 0d                	cmp    $0xd,%al
    11d3:	74 0c                	je     11e1 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11d8:	40                   	inc    %eax
    11d9:	3b 45 0c             	cmp    0xc(%ebp),%eax
    11dc:	7c b5                	jl     1193 <gets+0xf>
    11de:	eb 01                	jmp    11e1 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    11e0:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    11e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    11e4:	8b 45 08             	mov    0x8(%ebp),%eax
    11e7:	01 d0                	add    %edx,%eax
    11e9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    11ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11ef:	c9                   	leave  
    11f0:	c3                   	ret    

000011f1 <stat>:

int
stat(char *n, struct stat *st)
{
    11f1:	55                   	push   %ebp
    11f2:	89 e5                	mov    %esp,%ebp
    11f4:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    11fe:	00 
    11ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1202:	89 04 24             	mov    %eax,(%esp)
    1205:	e8 fe 00 00 00       	call   1308 <open>
    120a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    120d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1211:	79 07                	jns    121a <stat+0x29>
    return -1;
    1213:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1218:	eb 23                	jmp    123d <stat+0x4c>
  r = fstat(fd, st);
    121a:	8b 45 0c             	mov    0xc(%ebp),%eax
    121d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1221:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1224:	89 04 24             	mov    %eax,(%esp)
    1227:	e8 f4 00 00 00       	call   1320 <fstat>
    122c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    122f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1232:	89 04 24             	mov    %eax,(%esp)
    1235:	e8 b6 00 00 00       	call   12f0 <close>
  return r;
    123a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    123d:	c9                   	leave  
    123e:	c3                   	ret    

0000123f <atoi>:

int
atoi(const char *s)
{
    123f:	55                   	push   %ebp
    1240:	89 e5                	mov    %esp,%ebp
    1242:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1245:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    124c:	eb 21                	jmp    126f <atoi+0x30>
    n = n*10 + *s++ - '0';
    124e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1251:	89 d0                	mov    %edx,%eax
    1253:	c1 e0 02             	shl    $0x2,%eax
    1256:	01 d0                	add    %edx,%eax
    1258:	d1 e0                	shl    %eax
    125a:	89 c2                	mov    %eax,%edx
    125c:	8b 45 08             	mov    0x8(%ebp),%eax
    125f:	8a 00                	mov    (%eax),%al
    1261:	0f be c0             	movsbl %al,%eax
    1264:	01 d0                	add    %edx,%eax
    1266:	83 e8 30             	sub    $0x30,%eax
    1269:	89 45 fc             	mov    %eax,-0x4(%ebp)
    126c:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    126f:	8b 45 08             	mov    0x8(%ebp),%eax
    1272:	8a 00                	mov    (%eax),%al
    1274:	3c 2f                	cmp    $0x2f,%al
    1276:	7e 09                	jle    1281 <atoi+0x42>
    1278:	8b 45 08             	mov    0x8(%ebp),%eax
    127b:	8a 00                	mov    (%eax),%al
    127d:	3c 39                	cmp    $0x39,%al
    127f:	7e cd                	jle    124e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1281:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1284:	c9                   	leave  
    1285:	c3                   	ret    

00001286 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1286:	55                   	push   %ebp
    1287:	89 e5                	mov    %esp,%ebp
    1289:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    128c:	8b 45 08             	mov    0x8(%ebp),%eax
    128f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1292:	8b 45 0c             	mov    0xc(%ebp),%eax
    1295:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1298:	eb 10                	jmp    12aa <memmove+0x24>
    *dst++ = *src++;
    129a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    129d:	8a 10                	mov    (%eax),%dl
    129f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    12a2:	88 10                	mov    %dl,(%eax)
    12a4:	ff 45 fc             	incl   -0x4(%ebp)
    12a7:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    12aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    12ae:	0f 9f c0             	setg   %al
    12b1:	ff 4d 10             	decl   0x10(%ebp)
    12b4:	84 c0                	test   %al,%al
    12b6:	75 e2                	jne    129a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    12b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12bb:	c9                   	leave  
    12bc:	c3                   	ret    
    12bd:	66 90                	xchg   %ax,%ax
    12bf:	90                   	nop

000012c0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    12c0:	b8 01 00 00 00       	mov    $0x1,%eax
    12c5:	cd 40                	int    $0x40
    12c7:	c3                   	ret    

000012c8 <exit>:
SYSCALL(exit)
    12c8:	b8 02 00 00 00       	mov    $0x2,%eax
    12cd:	cd 40                	int    $0x40
    12cf:	c3                   	ret    

000012d0 <wait>:
SYSCALL(wait)
    12d0:	b8 03 00 00 00       	mov    $0x3,%eax
    12d5:	cd 40                	int    $0x40
    12d7:	c3                   	ret    

000012d8 <pipe>:
SYSCALL(pipe)
    12d8:	b8 04 00 00 00       	mov    $0x4,%eax
    12dd:	cd 40                	int    $0x40
    12df:	c3                   	ret    

000012e0 <read>:
SYSCALL(read)
    12e0:	b8 05 00 00 00       	mov    $0x5,%eax
    12e5:	cd 40                	int    $0x40
    12e7:	c3                   	ret    

000012e8 <write>:
SYSCALL(write)
    12e8:	b8 10 00 00 00       	mov    $0x10,%eax
    12ed:	cd 40                	int    $0x40
    12ef:	c3                   	ret    

000012f0 <close>:
SYSCALL(close)
    12f0:	b8 15 00 00 00       	mov    $0x15,%eax
    12f5:	cd 40                	int    $0x40
    12f7:	c3                   	ret    

000012f8 <kill>:
SYSCALL(kill)
    12f8:	b8 06 00 00 00       	mov    $0x6,%eax
    12fd:	cd 40                	int    $0x40
    12ff:	c3                   	ret    

00001300 <exec>:
SYSCALL(exec)
    1300:	b8 07 00 00 00       	mov    $0x7,%eax
    1305:	cd 40                	int    $0x40
    1307:	c3                   	ret    

00001308 <open>:
SYSCALL(open)
    1308:	b8 0f 00 00 00       	mov    $0xf,%eax
    130d:	cd 40                	int    $0x40
    130f:	c3                   	ret    

00001310 <mknod>:
SYSCALL(mknod)
    1310:	b8 11 00 00 00       	mov    $0x11,%eax
    1315:	cd 40                	int    $0x40
    1317:	c3                   	ret    

00001318 <unlink>:
SYSCALL(unlink)
    1318:	b8 12 00 00 00       	mov    $0x12,%eax
    131d:	cd 40                	int    $0x40
    131f:	c3                   	ret    

00001320 <fstat>:
SYSCALL(fstat)
    1320:	b8 08 00 00 00       	mov    $0x8,%eax
    1325:	cd 40                	int    $0x40
    1327:	c3                   	ret    

00001328 <link>:
SYSCALL(link)
    1328:	b8 13 00 00 00       	mov    $0x13,%eax
    132d:	cd 40                	int    $0x40
    132f:	c3                   	ret    

00001330 <mkdir>:
SYSCALL(mkdir)
    1330:	b8 14 00 00 00       	mov    $0x14,%eax
    1335:	cd 40                	int    $0x40
    1337:	c3                   	ret    

00001338 <chdir>:
SYSCALL(chdir)
    1338:	b8 09 00 00 00       	mov    $0x9,%eax
    133d:	cd 40                	int    $0x40
    133f:	c3                   	ret    

00001340 <dup>:
SYSCALL(dup)
    1340:	b8 0a 00 00 00       	mov    $0xa,%eax
    1345:	cd 40                	int    $0x40
    1347:	c3                   	ret    

00001348 <getpid>:
SYSCALL(getpid)
    1348:	b8 0b 00 00 00       	mov    $0xb,%eax
    134d:	cd 40                	int    $0x40
    134f:	c3                   	ret    

00001350 <sbrk>:
SYSCALL(sbrk)
    1350:	b8 0c 00 00 00       	mov    $0xc,%eax
    1355:	cd 40                	int    $0x40
    1357:	c3                   	ret    

00001358 <sleep>:
SYSCALL(sleep)
    1358:	b8 0d 00 00 00       	mov    $0xd,%eax
    135d:	cd 40                	int    $0x40
    135f:	c3                   	ret    

00001360 <uptime>:
SYSCALL(uptime)
    1360:	b8 0e 00 00 00       	mov    $0xe,%eax
    1365:	cd 40                	int    $0x40
    1367:	c3                   	ret    

00001368 <cowfork>:
SYSCALL(cowfork) //3.4
    1368:	b8 16 00 00 00       	mov    $0x16,%eax
    136d:	cd 40                	int    $0x40
    136f:	c3                   	ret    

00001370 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1370:	55                   	push   %ebp
    1371:	89 e5                	mov    %esp,%ebp
    1373:	83 ec 28             	sub    $0x28,%esp
    1376:	8b 45 0c             	mov    0xc(%ebp),%eax
    1379:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    137c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1383:	00 
    1384:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1387:	89 44 24 04          	mov    %eax,0x4(%esp)
    138b:	8b 45 08             	mov    0x8(%ebp),%eax
    138e:	89 04 24             	mov    %eax,(%esp)
    1391:	e8 52 ff ff ff       	call   12e8 <write>
}
    1396:	c9                   	leave  
    1397:	c3                   	ret    

00001398 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1398:	55                   	push   %ebp
    1399:	89 e5                	mov    %esp,%ebp
    139b:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    139e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    13a5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    13a9:	74 17                	je     13c2 <printint+0x2a>
    13ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13af:	79 11                	jns    13c2 <printint+0x2a>
    neg = 1;
    13b1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    13b8:	8b 45 0c             	mov    0xc(%ebp),%eax
    13bb:	f7 d8                	neg    %eax
    13bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    13c0:	eb 06                	jmp    13c8 <printint+0x30>
  } else {
    x = xx;
    13c2:	8b 45 0c             	mov    0xc(%ebp),%eax
    13c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    13c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    13cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
    13d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13d5:	ba 00 00 00 00       	mov    $0x0,%edx
    13da:	f7 f1                	div    %ecx
    13dc:	89 d0                	mov    %edx,%eax
    13de:	8a 80 d0 2a 00 00    	mov    0x2ad0(%eax),%al
    13e4:	8d 4d dc             	lea    -0x24(%ebp),%ecx
    13e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
    13ea:	01 ca                	add    %ecx,%edx
    13ec:	88 02                	mov    %al,(%edx)
    13ee:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
    13f1:	8b 55 10             	mov    0x10(%ebp),%edx
    13f4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    13f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    13fa:	ba 00 00 00 00       	mov    $0x0,%edx
    13ff:	f7 75 d4             	divl   -0x2c(%ebp)
    1402:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1405:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1409:	75 c4                	jne    13cf <printint+0x37>
  if(neg)
    140b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    140f:	74 2c                	je     143d <printint+0xa5>
    buf[i++] = '-';
    1411:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1414:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1417:	01 d0                	add    %edx,%eax
    1419:	c6 00 2d             	movb   $0x2d,(%eax)
    141c:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
    141f:	eb 1c                	jmp    143d <printint+0xa5>
    putc(fd, buf[i]);
    1421:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1424:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1427:	01 d0                	add    %edx,%eax
    1429:	8a 00                	mov    (%eax),%al
    142b:	0f be c0             	movsbl %al,%eax
    142e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1432:	8b 45 08             	mov    0x8(%ebp),%eax
    1435:	89 04 24             	mov    %eax,(%esp)
    1438:	e8 33 ff ff ff       	call   1370 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    143d:	ff 4d f4             	decl   -0xc(%ebp)
    1440:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1444:	79 db                	jns    1421 <printint+0x89>
    putc(fd, buf[i]);
}
    1446:	c9                   	leave  
    1447:	c3                   	ret    

00001448 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1448:	55                   	push   %ebp
    1449:	89 e5                	mov    %esp,%ebp
    144b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    144e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1455:	8d 45 0c             	lea    0xc(%ebp),%eax
    1458:	83 c0 04             	add    $0x4,%eax
    145b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    145e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1465:	e9 78 01 00 00       	jmp    15e2 <printf+0x19a>
    c = fmt[i] & 0xff;
    146a:	8b 55 0c             	mov    0xc(%ebp),%edx
    146d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1470:	01 d0                	add    %edx,%eax
    1472:	8a 00                	mov    (%eax),%al
    1474:	0f be c0             	movsbl %al,%eax
    1477:	25 ff 00 00 00       	and    $0xff,%eax
    147c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    147f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1483:	75 2c                	jne    14b1 <printf+0x69>
      if(c == '%'){
    1485:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1489:	75 0c                	jne    1497 <printf+0x4f>
        state = '%';
    148b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1492:	e9 48 01 00 00       	jmp    15df <printf+0x197>
      } else {
        putc(fd, c);
    1497:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    149a:	0f be c0             	movsbl %al,%eax
    149d:	89 44 24 04          	mov    %eax,0x4(%esp)
    14a1:	8b 45 08             	mov    0x8(%ebp),%eax
    14a4:	89 04 24             	mov    %eax,(%esp)
    14a7:	e8 c4 fe ff ff       	call   1370 <putc>
    14ac:	e9 2e 01 00 00       	jmp    15df <printf+0x197>
      }
    } else if(state == '%'){
    14b1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    14b5:	0f 85 24 01 00 00    	jne    15df <printf+0x197>
      if(c == 'd'){
    14bb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    14bf:	75 2d                	jne    14ee <printf+0xa6>
        printint(fd, *ap, 10, 1);
    14c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14c4:	8b 00                	mov    (%eax),%eax
    14c6:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    14cd:	00 
    14ce:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    14d5:	00 
    14d6:	89 44 24 04          	mov    %eax,0x4(%esp)
    14da:	8b 45 08             	mov    0x8(%ebp),%eax
    14dd:	89 04 24             	mov    %eax,(%esp)
    14e0:	e8 b3 fe ff ff       	call   1398 <printint>
        ap++;
    14e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14e9:	e9 ea 00 00 00       	jmp    15d8 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
    14ee:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    14f2:	74 06                	je     14fa <printf+0xb2>
    14f4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    14f8:	75 2d                	jne    1527 <printf+0xdf>
        printint(fd, *ap, 16, 0);
    14fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14fd:	8b 00                	mov    (%eax),%eax
    14ff:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1506:	00 
    1507:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    150e:	00 
    150f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1513:	8b 45 08             	mov    0x8(%ebp),%eax
    1516:	89 04 24             	mov    %eax,(%esp)
    1519:	e8 7a fe ff ff       	call   1398 <printint>
        ap++;
    151e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1522:	e9 b1 00 00 00       	jmp    15d8 <printf+0x190>
      } else if(c == 's'){
    1527:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    152b:	75 43                	jne    1570 <printf+0x128>
        s = (char*)*ap;
    152d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1530:	8b 00                	mov    (%eax),%eax
    1532:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1535:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1539:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    153d:	75 25                	jne    1564 <printf+0x11c>
          s = "(null)";
    153f:	c7 45 f4 6a 18 00 00 	movl   $0x186a,-0xc(%ebp)
        while(*s != 0){
    1546:	eb 1c                	jmp    1564 <printf+0x11c>
          putc(fd, *s);
    1548:	8b 45 f4             	mov    -0xc(%ebp),%eax
    154b:	8a 00                	mov    (%eax),%al
    154d:	0f be c0             	movsbl %al,%eax
    1550:	89 44 24 04          	mov    %eax,0x4(%esp)
    1554:	8b 45 08             	mov    0x8(%ebp),%eax
    1557:	89 04 24             	mov    %eax,(%esp)
    155a:	e8 11 fe ff ff       	call   1370 <putc>
          s++;
    155f:	ff 45 f4             	incl   -0xc(%ebp)
    1562:	eb 01                	jmp    1565 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1564:	90                   	nop
    1565:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1568:	8a 00                	mov    (%eax),%al
    156a:	84 c0                	test   %al,%al
    156c:	75 da                	jne    1548 <printf+0x100>
    156e:	eb 68                	jmp    15d8 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1570:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1574:	75 1d                	jne    1593 <printf+0x14b>
        putc(fd, *ap);
    1576:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1579:	8b 00                	mov    (%eax),%eax
    157b:	0f be c0             	movsbl %al,%eax
    157e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1582:	8b 45 08             	mov    0x8(%ebp),%eax
    1585:	89 04 24             	mov    %eax,(%esp)
    1588:	e8 e3 fd ff ff       	call   1370 <putc>
        ap++;
    158d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1591:	eb 45                	jmp    15d8 <printf+0x190>
      } else if(c == '%'){
    1593:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1597:	75 17                	jne    15b0 <printf+0x168>
        putc(fd, c);
    1599:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    159c:	0f be c0             	movsbl %al,%eax
    159f:	89 44 24 04          	mov    %eax,0x4(%esp)
    15a3:	8b 45 08             	mov    0x8(%ebp),%eax
    15a6:	89 04 24             	mov    %eax,(%esp)
    15a9:	e8 c2 fd ff ff       	call   1370 <putc>
    15ae:	eb 28                	jmp    15d8 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    15b0:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    15b7:	00 
    15b8:	8b 45 08             	mov    0x8(%ebp),%eax
    15bb:	89 04 24             	mov    %eax,(%esp)
    15be:	e8 ad fd ff ff       	call   1370 <putc>
        putc(fd, c);
    15c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15c6:	0f be c0             	movsbl %al,%eax
    15c9:	89 44 24 04          	mov    %eax,0x4(%esp)
    15cd:	8b 45 08             	mov    0x8(%ebp),%eax
    15d0:	89 04 24             	mov    %eax,(%esp)
    15d3:	e8 98 fd ff ff       	call   1370 <putc>
      }
      state = 0;
    15d8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    15df:	ff 45 f0             	incl   -0x10(%ebp)
    15e2:	8b 55 0c             	mov    0xc(%ebp),%edx
    15e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15e8:	01 d0                	add    %edx,%eax
    15ea:	8a 00                	mov    (%eax),%al
    15ec:	84 c0                	test   %al,%al
    15ee:	0f 85 76 fe ff ff    	jne    146a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    15f4:	c9                   	leave  
    15f5:	c3                   	ret    
    15f6:	66 90                	xchg   %ax,%ax

000015f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    15f8:	55                   	push   %ebp
    15f9:	89 e5                	mov    %esp,%ebp
    15fb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    15fe:	8b 45 08             	mov    0x8(%ebp),%eax
    1601:	83 e8 08             	sub    $0x8,%eax
    1604:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1607:	a1 ec 2a 00 00       	mov    0x2aec,%eax
    160c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    160f:	eb 24                	jmp    1635 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1611:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1614:	8b 00                	mov    (%eax),%eax
    1616:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1619:	77 12                	ja     162d <free+0x35>
    161b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    161e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1621:	77 24                	ja     1647 <free+0x4f>
    1623:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1626:	8b 00                	mov    (%eax),%eax
    1628:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    162b:	77 1a                	ja     1647 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    162d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1630:	8b 00                	mov    (%eax),%eax
    1632:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1635:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1638:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    163b:	76 d4                	jbe    1611 <free+0x19>
    163d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1640:	8b 00                	mov    (%eax),%eax
    1642:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1645:	76 ca                	jbe    1611 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1647:	8b 45 f8             	mov    -0x8(%ebp),%eax
    164a:	8b 40 04             	mov    0x4(%eax),%eax
    164d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1654:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1657:	01 c2                	add    %eax,%edx
    1659:	8b 45 fc             	mov    -0x4(%ebp),%eax
    165c:	8b 00                	mov    (%eax),%eax
    165e:	39 c2                	cmp    %eax,%edx
    1660:	75 24                	jne    1686 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1662:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1665:	8b 50 04             	mov    0x4(%eax),%edx
    1668:	8b 45 fc             	mov    -0x4(%ebp),%eax
    166b:	8b 00                	mov    (%eax),%eax
    166d:	8b 40 04             	mov    0x4(%eax),%eax
    1670:	01 c2                	add    %eax,%edx
    1672:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1675:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1678:	8b 45 fc             	mov    -0x4(%ebp),%eax
    167b:	8b 00                	mov    (%eax),%eax
    167d:	8b 10                	mov    (%eax),%edx
    167f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1682:	89 10                	mov    %edx,(%eax)
    1684:	eb 0a                	jmp    1690 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1686:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1689:	8b 10                	mov    (%eax),%edx
    168b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    168e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1690:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1693:	8b 40 04             	mov    0x4(%eax),%eax
    1696:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    169d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16a0:	01 d0                	add    %edx,%eax
    16a2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16a5:	75 20                	jne    16c7 <free+0xcf>
    p->s.size += bp->s.size;
    16a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16aa:	8b 50 04             	mov    0x4(%eax),%edx
    16ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16b0:	8b 40 04             	mov    0x4(%eax),%eax
    16b3:	01 c2                	add    %eax,%edx
    16b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    16bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16be:	8b 10                	mov    (%eax),%edx
    16c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c3:	89 10                	mov    %edx,(%eax)
    16c5:	eb 08                	jmp    16cf <free+0xd7>
  } else
    p->s.ptr = bp;
    16c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ca:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16cd:	89 10                	mov    %edx,(%eax)
  freep = p;
    16cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d2:	a3 ec 2a 00 00       	mov    %eax,0x2aec
}
    16d7:	c9                   	leave  
    16d8:	c3                   	ret    

000016d9 <morecore>:

static Header*
morecore(uint nu)
{
    16d9:	55                   	push   %ebp
    16da:	89 e5                	mov    %esp,%ebp
    16dc:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    16df:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    16e6:	77 07                	ja     16ef <morecore+0x16>
    nu = 4096;
    16e8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    16ef:	8b 45 08             	mov    0x8(%ebp),%eax
    16f2:	c1 e0 03             	shl    $0x3,%eax
    16f5:	89 04 24             	mov    %eax,(%esp)
    16f8:	e8 53 fc ff ff       	call   1350 <sbrk>
    16fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1700:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1704:	75 07                	jne    170d <morecore+0x34>
    return 0;
    1706:	b8 00 00 00 00       	mov    $0x0,%eax
    170b:	eb 22                	jmp    172f <morecore+0x56>
  hp = (Header*)p;
    170d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1710:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1713:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1716:	8b 55 08             	mov    0x8(%ebp),%edx
    1719:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    171c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    171f:	83 c0 08             	add    $0x8,%eax
    1722:	89 04 24             	mov    %eax,(%esp)
    1725:	e8 ce fe ff ff       	call   15f8 <free>
  return freep;
    172a:	a1 ec 2a 00 00       	mov    0x2aec,%eax
}
    172f:	c9                   	leave  
    1730:	c3                   	ret    

00001731 <malloc>:

void*
malloc(uint nbytes)
{
    1731:	55                   	push   %ebp
    1732:	89 e5                	mov    %esp,%ebp
    1734:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1737:	8b 45 08             	mov    0x8(%ebp),%eax
    173a:	83 c0 07             	add    $0x7,%eax
    173d:	c1 e8 03             	shr    $0x3,%eax
    1740:	40                   	inc    %eax
    1741:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1744:	a1 ec 2a 00 00       	mov    0x2aec,%eax
    1749:	89 45 f0             	mov    %eax,-0x10(%ebp)
    174c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1750:	75 23                	jne    1775 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    1752:	c7 45 f0 e4 2a 00 00 	movl   $0x2ae4,-0x10(%ebp)
    1759:	8b 45 f0             	mov    -0x10(%ebp),%eax
    175c:	a3 ec 2a 00 00       	mov    %eax,0x2aec
    1761:	a1 ec 2a 00 00       	mov    0x2aec,%eax
    1766:	a3 e4 2a 00 00       	mov    %eax,0x2ae4
    base.s.size = 0;
    176b:	c7 05 e8 2a 00 00 00 	movl   $0x0,0x2ae8
    1772:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1775:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1778:	8b 00                	mov    (%eax),%eax
    177a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    177d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1780:	8b 40 04             	mov    0x4(%eax),%eax
    1783:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1786:	72 4d                	jb     17d5 <malloc+0xa4>
      if(p->s.size == nunits)
    1788:	8b 45 f4             	mov    -0xc(%ebp),%eax
    178b:	8b 40 04             	mov    0x4(%eax),%eax
    178e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1791:	75 0c                	jne    179f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    1793:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1796:	8b 10                	mov    (%eax),%edx
    1798:	8b 45 f0             	mov    -0x10(%ebp),%eax
    179b:	89 10                	mov    %edx,(%eax)
    179d:	eb 26                	jmp    17c5 <malloc+0x94>
      else {
        p->s.size -= nunits;
    179f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a2:	8b 40 04             	mov    0x4(%eax),%eax
    17a5:	89 c2                	mov    %eax,%edx
    17a7:	2b 55 ec             	sub    -0x14(%ebp),%edx
    17aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17ad:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    17b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17b3:	8b 40 04             	mov    0x4(%eax),%eax
    17b6:	c1 e0 03             	shl    $0x3,%eax
    17b9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    17bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
    17c2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    17c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17c8:	a3 ec 2a 00 00       	mov    %eax,0x2aec
      return (void*)(p + 1);
    17cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d0:	83 c0 08             	add    $0x8,%eax
    17d3:	eb 38                	jmp    180d <malloc+0xdc>
    }
    if(p == freep)
    17d5:	a1 ec 2a 00 00       	mov    0x2aec,%eax
    17da:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    17dd:	75 1b                	jne    17fa <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    17df:	8b 45 ec             	mov    -0x14(%ebp),%eax
    17e2:	89 04 24             	mov    %eax,(%esp)
    17e5:	e8 ef fe ff ff       	call   16d9 <morecore>
    17ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    17ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17f1:	75 07                	jne    17fa <malloc+0xc9>
        return 0;
    17f3:	b8 00 00 00 00       	mov    $0x0,%eax
    17f8:	eb 13                	jmp    180d <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1800:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1803:	8b 00                	mov    (%eax),%eax
    1805:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1808:	e9 70 ff ff ff       	jmp    177d <malloc+0x4c>
}
    180d:	c9                   	leave  
    180e:	c3                   	ret    
