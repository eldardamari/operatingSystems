
_init:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 e4 f0             	and    $0xfffffff0,%esp
    1006:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    1009:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1010:	00 
    1011:	c7 04 24 aa 18 00 00 	movl   $0x18aa,(%esp)
    1018:	e8 83 03 00 00       	call   13a0 <open>
    101d:	85 c0                	test   %eax,%eax
    101f:	79 30                	jns    1051 <main+0x51>
    mknod("console", 1, 1);
    1021:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1028:	00 
    1029:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    1030:	00 
    1031:	c7 04 24 aa 18 00 00 	movl   $0x18aa,(%esp)
    1038:	e8 6b 03 00 00       	call   13a8 <mknod>
    open("console", O_RDWR);
    103d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1044:	00 
    1045:	c7 04 24 aa 18 00 00 	movl   $0x18aa,(%esp)
    104c:	e8 4f 03 00 00       	call   13a0 <open>
  }
  dup(0);  // stdout
    1051:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1058:	e8 7b 03 00 00       	call   13d8 <dup>
  dup(0);  // stderr
    105d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1064:	e8 6f 03 00 00       	call   13d8 <dup>
    1069:	eb 01                	jmp    106c <main+0x6c>
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
    106b:	90                   	nop
  }
  dup(0);  // stdout
  dup(0);  // stderr

  for(;;){
    printf(1, "init: starting sh\n");
    106c:	c7 44 24 04 b2 18 00 	movl   $0x18b2,0x4(%esp)
    1073:	00 
    1074:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    107b:	e8 60 04 00 00       	call   14e0 <printf>
    pid = fork();
    1080:	e8 d3 02 00 00       	call   1358 <fork>
    1085:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
    1089:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    108e:	79 19                	jns    10a9 <main+0xa9>
      printf(1, "init: fork failed\n");
    1090:	c7 44 24 04 c5 18 00 	movl   $0x18c5,0x4(%esp)
    1097:	00 
    1098:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    109f:	e8 3c 04 00 00       	call   14e0 <printf>
      exit();
    10a4:	e8 b7 02 00 00       	call   1360 <exit>
    }
    if(pid == 0){
    10a9:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    10ae:	75 41                	jne    10f1 <main+0xf1>
      exec("sh", argv);
    10b0:	c7 44 24 04 3c 2b 00 	movl   $0x2b3c,0x4(%esp)
    10b7:	00 
    10b8:	c7 04 24 a7 18 00 00 	movl   $0x18a7,(%esp)
    10bf:	e8 d4 02 00 00       	call   1398 <exec>
      printf(1, "init: exec sh failed\n");
    10c4:	c7 44 24 04 d8 18 00 	movl   $0x18d8,0x4(%esp)
    10cb:	00 
    10cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10d3:	e8 08 04 00 00       	call   14e0 <printf>
      exit();
    10d8:	e8 83 02 00 00       	call   1360 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
    10dd:	c7 44 24 04 ee 18 00 	movl   $0x18ee,0x4(%esp)
    10e4:	00 
    10e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10ec:	e8 ef 03 00 00       	call   14e0 <printf>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
    10f1:	e8 72 02 00 00       	call   1368 <wait>
    10f6:	89 44 24 18          	mov    %eax,0x18(%esp)
    10fa:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
    10ff:	0f 88 66 ff ff ff    	js     106b <main+0x6b>
    1105:	8b 44 24 18          	mov    0x18(%esp),%eax
    1109:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
    110d:	75 ce                	jne    10dd <main+0xdd>
      printf(1, "zombie!\n");
  }
    110f:	e9 57 ff ff ff       	jmp    106b <main+0x6b>

00001114 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1114:	55                   	push   %ebp
    1115:	89 e5                	mov    %esp,%ebp
    1117:	57                   	push   %edi
    1118:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1119:	8b 4d 08             	mov    0x8(%ebp),%ecx
    111c:	8b 55 10             	mov    0x10(%ebp),%edx
    111f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1122:	89 cb                	mov    %ecx,%ebx
    1124:	89 df                	mov    %ebx,%edi
    1126:	89 d1                	mov    %edx,%ecx
    1128:	fc                   	cld    
    1129:	f3 aa                	rep stos %al,%es:(%edi)
    112b:	89 ca                	mov    %ecx,%edx
    112d:	89 fb                	mov    %edi,%ebx
    112f:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1132:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1135:	5b                   	pop    %ebx
    1136:	5f                   	pop    %edi
    1137:	5d                   	pop    %ebp
    1138:	c3                   	ret    

00001139 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1139:	55                   	push   %ebp
    113a:	89 e5                	mov    %esp,%ebp
    113c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    113f:	8b 45 08             	mov    0x8(%ebp),%eax
    1142:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1145:	90                   	nop
    1146:	8b 45 0c             	mov    0xc(%ebp),%eax
    1149:	8a 10                	mov    (%eax),%dl
    114b:	8b 45 08             	mov    0x8(%ebp),%eax
    114e:	88 10                	mov    %dl,(%eax)
    1150:	8b 45 08             	mov    0x8(%ebp),%eax
    1153:	8a 00                	mov    (%eax),%al
    1155:	84 c0                	test   %al,%al
    1157:	0f 95 c0             	setne  %al
    115a:	ff 45 08             	incl   0x8(%ebp)
    115d:	ff 45 0c             	incl   0xc(%ebp)
    1160:	84 c0                	test   %al,%al
    1162:	75 e2                	jne    1146 <strcpy+0xd>
    ;
  return os;
    1164:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1167:	c9                   	leave  
    1168:	c3                   	ret    

00001169 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1169:	55                   	push   %ebp
    116a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    116c:	eb 06                	jmp    1174 <strcmp+0xb>
    p++, q++;
    116e:	ff 45 08             	incl   0x8(%ebp)
    1171:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1174:	8b 45 08             	mov    0x8(%ebp),%eax
    1177:	8a 00                	mov    (%eax),%al
    1179:	84 c0                	test   %al,%al
    117b:	74 0e                	je     118b <strcmp+0x22>
    117d:	8b 45 08             	mov    0x8(%ebp),%eax
    1180:	8a 10                	mov    (%eax),%dl
    1182:	8b 45 0c             	mov    0xc(%ebp),%eax
    1185:	8a 00                	mov    (%eax),%al
    1187:	38 c2                	cmp    %al,%dl
    1189:	74 e3                	je     116e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    118b:	8b 45 08             	mov    0x8(%ebp),%eax
    118e:	8a 00                	mov    (%eax),%al
    1190:	0f b6 d0             	movzbl %al,%edx
    1193:	8b 45 0c             	mov    0xc(%ebp),%eax
    1196:	8a 00                	mov    (%eax),%al
    1198:	0f b6 c0             	movzbl %al,%eax
    119b:	89 d1                	mov    %edx,%ecx
    119d:	29 c1                	sub    %eax,%ecx
    119f:	89 c8                	mov    %ecx,%eax
}
    11a1:	5d                   	pop    %ebp
    11a2:	c3                   	ret    

000011a3 <strlen>:

uint
strlen(char *s)
{
    11a3:	55                   	push   %ebp
    11a4:	89 e5                	mov    %esp,%ebp
    11a6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11b0:	eb 03                	jmp    11b5 <strlen+0x12>
    11b2:	ff 45 fc             	incl   -0x4(%ebp)
    11b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11b8:	8b 45 08             	mov    0x8(%ebp),%eax
    11bb:	01 d0                	add    %edx,%eax
    11bd:	8a 00                	mov    (%eax),%al
    11bf:	84 c0                	test   %al,%al
    11c1:	75 ef                	jne    11b2 <strlen+0xf>
    ;
  return n;
    11c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11c6:	c9                   	leave  
    11c7:	c3                   	ret    

000011c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11c8:	55                   	push   %ebp
    11c9:	89 e5                	mov    %esp,%ebp
    11cb:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    11ce:	8b 45 10             	mov    0x10(%ebp),%eax
    11d1:	89 44 24 08          	mov    %eax,0x8(%esp)
    11d5:	8b 45 0c             	mov    0xc(%ebp),%eax
    11d8:	89 44 24 04          	mov    %eax,0x4(%esp)
    11dc:	8b 45 08             	mov    0x8(%ebp),%eax
    11df:	89 04 24             	mov    %eax,(%esp)
    11e2:	e8 2d ff ff ff       	call   1114 <stosb>
  return dst;
    11e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11ea:	c9                   	leave  
    11eb:	c3                   	ret    

000011ec <strchr>:

char*
strchr(const char *s, char c)
{
    11ec:	55                   	push   %ebp
    11ed:	89 e5                	mov    %esp,%ebp
    11ef:	83 ec 04             	sub    $0x4,%esp
    11f2:	8b 45 0c             	mov    0xc(%ebp),%eax
    11f5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    11f8:	eb 12                	jmp    120c <strchr+0x20>
    if(*s == c)
    11fa:	8b 45 08             	mov    0x8(%ebp),%eax
    11fd:	8a 00                	mov    (%eax),%al
    11ff:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1202:	75 05                	jne    1209 <strchr+0x1d>
      return (char*)s;
    1204:	8b 45 08             	mov    0x8(%ebp),%eax
    1207:	eb 11                	jmp    121a <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1209:	ff 45 08             	incl   0x8(%ebp)
    120c:	8b 45 08             	mov    0x8(%ebp),%eax
    120f:	8a 00                	mov    (%eax),%al
    1211:	84 c0                	test   %al,%al
    1213:	75 e5                	jne    11fa <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1215:	b8 00 00 00 00       	mov    $0x0,%eax
}
    121a:	c9                   	leave  
    121b:	c3                   	ret    

0000121c <gets>:

char*
gets(char *buf, int max)
{
    121c:	55                   	push   %ebp
    121d:	89 e5                	mov    %esp,%ebp
    121f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1222:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1229:	eb 42                	jmp    126d <gets+0x51>
    cc = read(0, &c, 1);
    122b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1232:	00 
    1233:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1236:	89 44 24 04          	mov    %eax,0x4(%esp)
    123a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1241:	e8 32 01 00 00       	call   1378 <read>
    1246:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1249:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    124d:	7e 29                	jle    1278 <gets+0x5c>
      break;
    buf[i++] = c;
    124f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1252:	8b 45 08             	mov    0x8(%ebp),%eax
    1255:	01 c2                	add    %eax,%edx
    1257:	8a 45 ef             	mov    -0x11(%ebp),%al
    125a:	88 02                	mov    %al,(%edx)
    125c:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
    125f:	8a 45 ef             	mov    -0x11(%ebp),%al
    1262:	3c 0a                	cmp    $0xa,%al
    1264:	74 13                	je     1279 <gets+0x5d>
    1266:	8a 45 ef             	mov    -0x11(%ebp),%al
    1269:	3c 0d                	cmp    $0xd,%al
    126b:	74 0c                	je     1279 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    126d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1270:	40                   	inc    %eax
    1271:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1274:	7c b5                	jl     122b <gets+0xf>
    1276:	eb 01                	jmp    1279 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    1278:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1279:	8b 55 f4             	mov    -0xc(%ebp),%edx
    127c:	8b 45 08             	mov    0x8(%ebp),%eax
    127f:	01 d0                	add    %edx,%eax
    1281:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1284:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1287:	c9                   	leave  
    1288:	c3                   	ret    

00001289 <stat>:

int
stat(char *n, struct stat *st)
{
    1289:	55                   	push   %ebp
    128a:	89 e5                	mov    %esp,%ebp
    128c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    128f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1296:	00 
    1297:	8b 45 08             	mov    0x8(%ebp),%eax
    129a:	89 04 24             	mov    %eax,(%esp)
    129d:	e8 fe 00 00 00       	call   13a0 <open>
    12a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    12a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12a9:	79 07                	jns    12b2 <stat+0x29>
    return -1;
    12ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12b0:	eb 23                	jmp    12d5 <stat+0x4c>
  r = fstat(fd, st);
    12b2:	8b 45 0c             	mov    0xc(%ebp),%eax
    12b5:	89 44 24 04          	mov    %eax,0x4(%esp)
    12b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12bc:	89 04 24             	mov    %eax,(%esp)
    12bf:	e8 f4 00 00 00       	call   13b8 <fstat>
    12c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    12c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12ca:	89 04 24             	mov    %eax,(%esp)
    12cd:	e8 b6 00 00 00       	call   1388 <close>
  return r;
    12d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    12d5:	c9                   	leave  
    12d6:	c3                   	ret    

000012d7 <atoi>:

int
atoi(const char *s)
{
    12d7:	55                   	push   %ebp
    12d8:	89 e5                	mov    %esp,%ebp
    12da:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    12dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    12e4:	eb 21                	jmp    1307 <atoi+0x30>
    n = n*10 + *s++ - '0';
    12e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
    12e9:	89 d0                	mov    %edx,%eax
    12eb:	c1 e0 02             	shl    $0x2,%eax
    12ee:	01 d0                	add    %edx,%eax
    12f0:	d1 e0                	shl    %eax
    12f2:	89 c2                	mov    %eax,%edx
    12f4:	8b 45 08             	mov    0x8(%ebp),%eax
    12f7:	8a 00                	mov    (%eax),%al
    12f9:	0f be c0             	movsbl %al,%eax
    12fc:	01 d0                	add    %edx,%eax
    12fe:	83 e8 30             	sub    $0x30,%eax
    1301:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1304:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1307:	8b 45 08             	mov    0x8(%ebp),%eax
    130a:	8a 00                	mov    (%eax),%al
    130c:	3c 2f                	cmp    $0x2f,%al
    130e:	7e 09                	jle    1319 <atoi+0x42>
    1310:	8b 45 08             	mov    0x8(%ebp),%eax
    1313:	8a 00                	mov    (%eax),%al
    1315:	3c 39                	cmp    $0x39,%al
    1317:	7e cd                	jle    12e6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1319:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    131c:	c9                   	leave  
    131d:	c3                   	ret    

0000131e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    131e:	55                   	push   %ebp
    131f:	89 e5                	mov    %esp,%ebp
    1321:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1324:	8b 45 08             	mov    0x8(%ebp),%eax
    1327:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    132a:	8b 45 0c             	mov    0xc(%ebp),%eax
    132d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1330:	eb 10                	jmp    1342 <memmove+0x24>
    *dst++ = *src++;
    1332:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1335:	8a 10                	mov    (%eax),%dl
    1337:	8b 45 fc             	mov    -0x4(%ebp),%eax
    133a:	88 10                	mov    %dl,(%eax)
    133c:	ff 45 fc             	incl   -0x4(%ebp)
    133f:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1342:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    1346:	0f 9f c0             	setg   %al
    1349:	ff 4d 10             	decl   0x10(%ebp)
    134c:	84 c0                	test   %al,%al
    134e:	75 e2                	jne    1332 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1350:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1353:	c9                   	leave  
    1354:	c3                   	ret    
    1355:	66 90                	xchg   %ax,%ax
    1357:	90                   	nop

00001358 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1358:	b8 01 00 00 00       	mov    $0x1,%eax
    135d:	cd 40                	int    $0x40
    135f:	c3                   	ret    

00001360 <exit>:
SYSCALL(exit)
    1360:	b8 02 00 00 00       	mov    $0x2,%eax
    1365:	cd 40                	int    $0x40
    1367:	c3                   	ret    

00001368 <wait>:
SYSCALL(wait)
    1368:	b8 03 00 00 00       	mov    $0x3,%eax
    136d:	cd 40                	int    $0x40
    136f:	c3                   	ret    

00001370 <pipe>:
SYSCALL(pipe)
    1370:	b8 04 00 00 00       	mov    $0x4,%eax
    1375:	cd 40                	int    $0x40
    1377:	c3                   	ret    

00001378 <read>:
SYSCALL(read)
    1378:	b8 05 00 00 00       	mov    $0x5,%eax
    137d:	cd 40                	int    $0x40
    137f:	c3                   	ret    

00001380 <write>:
SYSCALL(write)
    1380:	b8 10 00 00 00       	mov    $0x10,%eax
    1385:	cd 40                	int    $0x40
    1387:	c3                   	ret    

00001388 <close>:
SYSCALL(close)
    1388:	b8 15 00 00 00       	mov    $0x15,%eax
    138d:	cd 40                	int    $0x40
    138f:	c3                   	ret    

00001390 <kill>:
SYSCALL(kill)
    1390:	b8 06 00 00 00       	mov    $0x6,%eax
    1395:	cd 40                	int    $0x40
    1397:	c3                   	ret    

00001398 <exec>:
SYSCALL(exec)
    1398:	b8 07 00 00 00       	mov    $0x7,%eax
    139d:	cd 40                	int    $0x40
    139f:	c3                   	ret    

000013a0 <open>:
SYSCALL(open)
    13a0:	b8 0f 00 00 00       	mov    $0xf,%eax
    13a5:	cd 40                	int    $0x40
    13a7:	c3                   	ret    

000013a8 <mknod>:
SYSCALL(mknod)
    13a8:	b8 11 00 00 00       	mov    $0x11,%eax
    13ad:	cd 40                	int    $0x40
    13af:	c3                   	ret    

000013b0 <unlink>:
SYSCALL(unlink)
    13b0:	b8 12 00 00 00       	mov    $0x12,%eax
    13b5:	cd 40                	int    $0x40
    13b7:	c3                   	ret    

000013b8 <fstat>:
SYSCALL(fstat)
    13b8:	b8 08 00 00 00       	mov    $0x8,%eax
    13bd:	cd 40                	int    $0x40
    13bf:	c3                   	ret    

000013c0 <link>:
SYSCALL(link)
    13c0:	b8 13 00 00 00       	mov    $0x13,%eax
    13c5:	cd 40                	int    $0x40
    13c7:	c3                   	ret    

000013c8 <mkdir>:
SYSCALL(mkdir)
    13c8:	b8 14 00 00 00       	mov    $0x14,%eax
    13cd:	cd 40                	int    $0x40
    13cf:	c3                   	ret    

000013d0 <chdir>:
SYSCALL(chdir)
    13d0:	b8 09 00 00 00       	mov    $0x9,%eax
    13d5:	cd 40                	int    $0x40
    13d7:	c3                   	ret    

000013d8 <dup>:
SYSCALL(dup)
    13d8:	b8 0a 00 00 00       	mov    $0xa,%eax
    13dd:	cd 40                	int    $0x40
    13df:	c3                   	ret    

000013e0 <getpid>:
SYSCALL(getpid)
    13e0:	b8 0b 00 00 00       	mov    $0xb,%eax
    13e5:	cd 40                	int    $0x40
    13e7:	c3                   	ret    

000013e8 <sbrk>:
SYSCALL(sbrk)
    13e8:	b8 0c 00 00 00       	mov    $0xc,%eax
    13ed:	cd 40                	int    $0x40
    13ef:	c3                   	ret    

000013f0 <sleep>:
SYSCALL(sleep)
    13f0:	b8 0d 00 00 00       	mov    $0xd,%eax
    13f5:	cd 40                	int    $0x40
    13f7:	c3                   	ret    

000013f8 <uptime>:
SYSCALL(uptime)
    13f8:	b8 0e 00 00 00       	mov    $0xe,%eax
    13fd:	cd 40                	int    $0x40
    13ff:	c3                   	ret    

00001400 <cowfork>:
SYSCALL(cowfork) //3.4
    1400:	b8 16 00 00 00       	mov    $0x16,%eax
    1405:	cd 40                	int    $0x40
    1407:	c3                   	ret    

00001408 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1408:	55                   	push   %ebp
    1409:	89 e5                	mov    %esp,%ebp
    140b:	83 ec 28             	sub    $0x28,%esp
    140e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1411:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1414:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    141b:	00 
    141c:	8d 45 f4             	lea    -0xc(%ebp),%eax
    141f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1423:	8b 45 08             	mov    0x8(%ebp),%eax
    1426:	89 04 24             	mov    %eax,(%esp)
    1429:	e8 52 ff ff ff       	call   1380 <write>
}
    142e:	c9                   	leave  
    142f:	c3                   	ret    

00001430 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1430:	55                   	push   %ebp
    1431:	89 e5                	mov    %esp,%ebp
    1433:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1436:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    143d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1441:	74 17                	je     145a <printint+0x2a>
    1443:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1447:	79 11                	jns    145a <printint+0x2a>
    neg = 1;
    1449:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1450:	8b 45 0c             	mov    0xc(%ebp),%eax
    1453:	f7 d8                	neg    %eax
    1455:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1458:	eb 06                	jmp    1460 <printint+0x30>
  } else {
    x = xx;
    145a:	8b 45 0c             	mov    0xc(%ebp),%eax
    145d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1460:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1467:	8b 4d 10             	mov    0x10(%ebp),%ecx
    146a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    146d:	ba 00 00 00 00       	mov    $0x0,%edx
    1472:	f7 f1                	div    %ecx
    1474:	89 d0                	mov    %edx,%eax
    1476:	8a 80 44 2b 00 00    	mov    0x2b44(%eax),%al
    147c:	8d 4d dc             	lea    -0x24(%ebp),%ecx
    147f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1482:	01 ca                	add    %ecx,%edx
    1484:	88 02                	mov    %al,(%edx)
    1486:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
    1489:	8b 55 10             	mov    0x10(%ebp),%edx
    148c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    148f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1492:	ba 00 00 00 00       	mov    $0x0,%edx
    1497:	f7 75 d4             	divl   -0x2c(%ebp)
    149a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    149d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14a1:	75 c4                	jne    1467 <printint+0x37>
  if(neg)
    14a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14a7:	74 2c                	je     14d5 <printint+0xa5>
    buf[i++] = '-';
    14a9:	8d 55 dc             	lea    -0x24(%ebp),%edx
    14ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14af:	01 d0                	add    %edx,%eax
    14b1:	c6 00 2d             	movb   $0x2d,(%eax)
    14b4:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
    14b7:	eb 1c                	jmp    14d5 <printint+0xa5>
    putc(fd, buf[i]);
    14b9:	8d 55 dc             	lea    -0x24(%ebp),%edx
    14bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14bf:	01 d0                	add    %edx,%eax
    14c1:	8a 00                	mov    (%eax),%al
    14c3:	0f be c0             	movsbl %al,%eax
    14c6:	89 44 24 04          	mov    %eax,0x4(%esp)
    14ca:	8b 45 08             	mov    0x8(%ebp),%eax
    14cd:	89 04 24             	mov    %eax,(%esp)
    14d0:	e8 33 ff ff ff       	call   1408 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    14d5:	ff 4d f4             	decl   -0xc(%ebp)
    14d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14dc:	79 db                	jns    14b9 <printint+0x89>
    putc(fd, buf[i]);
}
    14de:	c9                   	leave  
    14df:	c3                   	ret    

000014e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    14e0:	55                   	push   %ebp
    14e1:	89 e5                	mov    %esp,%ebp
    14e3:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    14e6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    14ed:	8d 45 0c             	lea    0xc(%ebp),%eax
    14f0:	83 c0 04             	add    $0x4,%eax
    14f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    14f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    14fd:	e9 78 01 00 00       	jmp    167a <printf+0x19a>
    c = fmt[i] & 0xff;
    1502:	8b 55 0c             	mov    0xc(%ebp),%edx
    1505:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1508:	01 d0                	add    %edx,%eax
    150a:	8a 00                	mov    (%eax),%al
    150c:	0f be c0             	movsbl %al,%eax
    150f:	25 ff 00 00 00       	and    $0xff,%eax
    1514:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1517:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    151b:	75 2c                	jne    1549 <printf+0x69>
      if(c == '%'){
    151d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1521:	75 0c                	jne    152f <printf+0x4f>
        state = '%';
    1523:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    152a:	e9 48 01 00 00       	jmp    1677 <printf+0x197>
      } else {
        putc(fd, c);
    152f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1532:	0f be c0             	movsbl %al,%eax
    1535:	89 44 24 04          	mov    %eax,0x4(%esp)
    1539:	8b 45 08             	mov    0x8(%ebp),%eax
    153c:	89 04 24             	mov    %eax,(%esp)
    153f:	e8 c4 fe ff ff       	call   1408 <putc>
    1544:	e9 2e 01 00 00       	jmp    1677 <printf+0x197>
      }
    } else if(state == '%'){
    1549:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    154d:	0f 85 24 01 00 00    	jne    1677 <printf+0x197>
      if(c == 'd'){
    1553:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1557:	75 2d                	jne    1586 <printf+0xa6>
        printint(fd, *ap, 10, 1);
    1559:	8b 45 e8             	mov    -0x18(%ebp),%eax
    155c:	8b 00                	mov    (%eax),%eax
    155e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1565:	00 
    1566:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    156d:	00 
    156e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1572:	8b 45 08             	mov    0x8(%ebp),%eax
    1575:	89 04 24             	mov    %eax,(%esp)
    1578:	e8 b3 fe ff ff       	call   1430 <printint>
        ap++;
    157d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1581:	e9 ea 00 00 00       	jmp    1670 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
    1586:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    158a:	74 06                	je     1592 <printf+0xb2>
    158c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1590:	75 2d                	jne    15bf <printf+0xdf>
        printint(fd, *ap, 16, 0);
    1592:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1595:	8b 00                	mov    (%eax),%eax
    1597:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    159e:	00 
    159f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    15a6:	00 
    15a7:	89 44 24 04          	mov    %eax,0x4(%esp)
    15ab:	8b 45 08             	mov    0x8(%ebp),%eax
    15ae:	89 04 24             	mov    %eax,(%esp)
    15b1:	e8 7a fe ff ff       	call   1430 <printint>
        ap++;
    15b6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15ba:	e9 b1 00 00 00       	jmp    1670 <printf+0x190>
      } else if(c == 's'){
    15bf:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    15c3:	75 43                	jne    1608 <printf+0x128>
        s = (char*)*ap;
    15c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15c8:	8b 00                	mov    (%eax),%eax
    15ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    15cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    15d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15d5:	75 25                	jne    15fc <printf+0x11c>
          s = "(null)";
    15d7:	c7 45 f4 f7 18 00 00 	movl   $0x18f7,-0xc(%ebp)
        while(*s != 0){
    15de:	eb 1c                	jmp    15fc <printf+0x11c>
          putc(fd, *s);
    15e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15e3:	8a 00                	mov    (%eax),%al
    15e5:	0f be c0             	movsbl %al,%eax
    15e8:	89 44 24 04          	mov    %eax,0x4(%esp)
    15ec:	8b 45 08             	mov    0x8(%ebp),%eax
    15ef:	89 04 24             	mov    %eax,(%esp)
    15f2:	e8 11 fe ff ff       	call   1408 <putc>
          s++;
    15f7:	ff 45 f4             	incl   -0xc(%ebp)
    15fa:	eb 01                	jmp    15fd <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    15fc:	90                   	nop
    15fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1600:	8a 00                	mov    (%eax),%al
    1602:	84 c0                	test   %al,%al
    1604:	75 da                	jne    15e0 <printf+0x100>
    1606:	eb 68                	jmp    1670 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1608:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    160c:	75 1d                	jne    162b <printf+0x14b>
        putc(fd, *ap);
    160e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1611:	8b 00                	mov    (%eax),%eax
    1613:	0f be c0             	movsbl %al,%eax
    1616:	89 44 24 04          	mov    %eax,0x4(%esp)
    161a:	8b 45 08             	mov    0x8(%ebp),%eax
    161d:	89 04 24             	mov    %eax,(%esp)
    1620:	e8 e3 fd ff ff       	call   1408 <putc>
        ap++;
    1625:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1629:	eb 45                	jmp    1670 <printf+0x190>
      } else if(c == '%'){
    162b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    162f:	75 17                	jne    1648 <printf+0x168>
        putc(fd, c);
    1631:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1634:	0f be c0             	movsbl %al,%eax
    1637:	89 44 24 04          	mov    %eax,0x4(%esp)
    163b:	8b 45 08             	mov    0x8(%ebp),%eax
    163e:	89 04 24             	mov    %eax,(%esp)
    1641:	e8 c2 fd ff ff       	call   1408 <putc>
    1646:	eb 28                	jmp    1670 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1648:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    164f:	00 
    1650:	8b 45 08             	mov    0x8(%ebp),%eax
    1653:	89 04 24             	mov    %eax,(%esp)
    1656:	e8 ad fd ff ff       	call   1408 <putc>
        putc(fd, c);
    165b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    165e:	0f be c0             	movsbl %al,%eax
    1661:	89 44 24 04          	mov    %eax,0x4(%esp)
    1665:	8b 45 08             	mov    0x8(%ebp),%eax
    1668:	89 04 24             	mov    %eax,(%esp)
    166b:	e8 98 fd ff ff       	call   1408 <putc>
      }
      state = 0;
    1670:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1677:	ff 45 f0             	incl   -0x10(%ebp)
    167a:	8b 55 0c             	mov    0xc(%ebp),%edx
    167d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1680:	01 d0                	add    %edx,%eax
    1682:	8a 00                	mov    (%eax),%al
    1684:	84 c0                	test   %al,%al
    1686:	0f 85 76 fe ff ff    	jne    1502 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    168c:	c9                   	leave  
    168d:	c3                   	ret    
    168e:	66 90                	xchg   %ax,%ax

00001690 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1690:	55                   	push   %ebp
    1691:	89 e5                	mov    %esp,%ebp
    1693:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1696:	8b 45 08             	mov    0x8(%ebp),%eax
    1699:	83 e8 08             	sub    $0x8,%eax
    169c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    169f:	a1 60 2b 00 00       	mov    0x2b60,%eax
    16a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16a7:	eb 24                	jmp    16cd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ac:	8b 00                	mov    (%eax),%eax
    16ae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16b1:	77 12                	ja     16c5 <free+0x35>
    16b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16b6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16b9:	77 24                	ja     16df <free+0x4f>
    16bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16be:	8b 00                	mov    (%eax),%eax
    16c0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16c3:	77 1a                	ja     16df <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c8:	8b 00                	mov    (%eax),%eax
    16ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16d0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16d3:	76 d4                	jbe    16a9 <free+0x19>
    16d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d8:	8b 00                	mov    (%eax),%eax
    16da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16dd:	76 ca                	jbe    16a9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    16df:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16e2:	8b 40 04             	mov    0x4(%eax),%eax
    16e5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16ef:	01 c2                	add    %eax,%edx
    16f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f4:	8b 00                	mov    (%eax),%eax
    16f6:	39 c2                	cmp    %eax,%edx
    16f8:	75 24                	jne    171e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    16fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16fd:	8b 50 04             	mov    0x4(%eax),%edx
    1700:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1703:	8b 00                	mov    (%eax),%eax
    1705:	8b 40 04             	mov    0x4(%eax),%eax
    1708:	01 c2                	add    %eax,%edx
    170a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    170d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1710:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1713:	8b 00                	mov    (%eax),%eax
    1715:	8b 10                	mov    (%eax),%edx
    1717:	8b 45 f8             	mov    -0x8(%ebp),%eax
    171a:	89 10                	mov    %edx,(%eax)
    171c:	eb 0a                	jmp    1728 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    171e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1721:	8b 10                	mov    (%eax),%edx
    1723:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1726:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1728:	8b 45 fc             	mov    -0x4(%ebp),%eax
    172b:	8b 40 04             	mov    0x4(%eax),%eax
    172e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1735:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1738:	01 d0                	add    %edx,%eax
    173a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    173d:	75 20                	jne    175f <free+0xcf>
    p->s.size += bp->s.size;
    173f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1742:	8b 50 04             	mov    0x4(%eax),%edx
    1745:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1748:	8b 40 04             	mov    0x4(%eax),%eax
    174b:	01 c2                	add    %eax,%edx
    174d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1750:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1753:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1756:	8b 10                	mov    (%eax),%edx
    1758:	8b 45 fc             	mov    -0x4(%ebp),%eax
    175b:	89 10                	mov    %edx,(%eax)
    175d:	eb 08                	jmp    1767 <free+0xd7>
  } else
    p->s.ptr = bp;
    175f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1762:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1765:	89 10                	mov    %edx,(%eax)
  freep = p;
    1767:	8b 45 fc             	mov    -0x4(%ebp),%eax
    176a:	a3 60 2b 00 00       	mov    %eax,0x2b60
}
    176f:	c9                   	leave  
    1770:	c3                   	ret    

00001771 <morecore>:

static Header*
morecore(uint nu)
{
    1771:	55                   	push   %ebp
    1772:	89 e5                	mov    %esp,%ebp
    1774:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1777:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    177e:	77 07                	ja     1787 <morecore+0x16>
    nu = 4096;
    1780:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1787:	8b 45 08             	mov    0x8(%ebp),%eax
    178a:	c1 e0 03             	shl    $0x3,%eax
    178d:	89 04 24             	mov    %eax,(%esp)
    1790:	e8 53 fc ff ff       	call   13e8 <sbrk>
    1795:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1798:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    179c:	75 07                	jne    17a5 <morecore+0x34>
    return 0;
    179e:	b8 00 00 00 00       	mov    $0x0,%eax
    17a3:	eb 22                	jmp    17c7 <morecore+0x56>
  hp = (Header*)p;
    17a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    17ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17ae:	8b 55 08             	mov    0x8(%ebp),%edx
    17b1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    17b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17b7:	83 c0 08             	add    $0x8,%eax
    17ba:	89 04 24             	mov    %eax,(%esp)
    17bd:	e8 ce fe ff ff       	call   1690 <free>
  return freep;
    17c2:	a1 60 2b 00 00       	mov    0x2b60,%eax
}
    17c7:	c9                   	leave  
    17c8:	c3                   	ret    

000017c9 <malloc>:

void*
malloc(uint nbytes)
{
    17c9:	55                   	push   %ebp
    17ca:	89 e5                	mov    %esp,%ebp
    17cc:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17cf:	8b 45 08             	mov    0x8(%ebp),%eax
    17d2:	83 c0 07             	add    $0x7,%eax
    17d5:	c1 e8 03             	shr    $0x3,%eax
    17d8:	40                   	inc    %eax
    17d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    17dc:	a1 60 2b 00 00       	mov    0x2b60,%eax
    17e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    17e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    17e8:	75 23                	jne    180d <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    17ea:	c7 45 f0 58 2b 00 00 	movl   $0x2b58,-0x10(%ebp)
    17f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17f4:	a3 60 2b 00 00       	mov    %eax,0x2b60
    17f9:	a1 60 2b 00 00       	mov    0x2b60,%eax
    17fe:	a3 58 2b 00 00       	mov    %eax,0x2b58
    base.s.size = 0;
    1803:	c7 05 5c 2b 00 00 00 	movl   $0x0,0x2b5c
    180a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    180d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1810:	8b 00                	mov    (%eax),%eax
    1812:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1815:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1818:	8b 40 04             	mov    0x4(%eax),%eax
    181b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    181e:	72 4d                	jb     186d <malloc+0xa4>
      if(p->s.size == nunits)
    1820:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1823:	8b 40 04             	mov    0x4(%eax),%eax
    1826:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1829:	75 0c                	jne    1837 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    182b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    182e:	8b 10                	mov    (%eax),%edx
    1830:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1833:	89 10                	mov    %edx,(%eax)
    1835:	eb 26                	jmp    185d <malloc+0x94>
      else {
        p->s.size -= nunits;
    1837:	8b 45 f4             	mov    -0xc(%ebp),%eax
    183a:	8b 40 04             	mov    0x4(%eax),%eax
    183d:	89 c2                	mov    %eax,%edx
    183f:	2b 55 ec             	sub    -0x14(%ebp),%edx
    1842:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1845:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1848:	8b 45 f4             	mov    -0xc(%ebp),%eax
    184b:	8b 40 04             	mov    0x4(%eax),%eax
    184e:	c1 e0 03             	shl    $0x3,%eax
    1851:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1854:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1857:	8b 55 ec             	mov    -0x14(%ebp),%edx
    185a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    185d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1860:	a3 60 2b 00 00       	mov    %eax,0x2b60
      return (void*)(p + 1);
    1865:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1868:	83 c0 08             	add    $0x8,%eax
    186b:	eb 38                	jmp    18a5 <malloc+0xdc>
    }
    if(p == freep)
    186d:	a1 60 2b 00 00       	mov    0x2b60,%eax
    1872:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1875:	75 1b                	jne    1892 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    1877:	8b 45 ec             	mov    -0x14(%ebp),%eax
    187a:	89 04 24             	mov    %eax,(%esp)
    187d:	e8 ef fe ff ff       	call   1771 <morecore>
    1882:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1885:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1889:	75 07                	jne    1892 <malloc+0xc9>
        return 0;
    188b:	b8 00 00 00 00       	mov    $0x0,%eax
    1890:	eb 13                	jmp    18a5 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1892:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1895:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1898:	8b 45 f4             	mov    -0xc(%ebp),%eax
    189b:	8b 00                	mov    (%eax),%eax
    189d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    18a0:	e9 70 ff ff ff       	jmp    1815 <malloc+0x4c>
}
    18a5:	c9                   	leave  
    18a6:	c3                   	ret    
