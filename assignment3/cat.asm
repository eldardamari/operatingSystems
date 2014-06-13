
_cat:     file format elf32-i386


Disassembly of section .text:

00001000 <cat>:

char buf[512];

void
cat(int fd)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
    1006:	eb 1b                	jmp    1023 <cat+0x23>
    write(1, buf, n);
    1008:	8b 45 f4             	mov    -0xc(%ebp),%eax
    100b:	89 44 24 08          	mov    %eax,0x8(%esp)
    100f:	c7 44 24 04 80 2b 00 	movl   $0x2b80,0x4(%esp)
    1016:	00 
    1017:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    101e:	e8 65 03 00 00       	call   1388 <write>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
    1023:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    102a:	00 
    102b:	c7 44 24 04 80 2b 00 	movl   $0x2b80,0x4(%esp)
    1032:	00 
    1033:	8b 45 08             	mov    0x8(%ebp),%eax
    1036:	89 04 24             	mov    %eax,(%esp)
    1039:	e8 42 03 00 00       	call   1380 <read>
    103e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1041:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1045:	7f c1                	jg     1008 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
    1047:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    104b:	79 19                	jns    1066 <cat+0x66>
    printf(1, "cat: read error\n");
    104d:	c7 44 24 04 af 18 00 	movl   $0x18af,0x4(%esp)
    1054:	00 
    1055:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    105c:	e8 87 04 00 00       	call   14e8 <printf>
    exit();
    1061:	e8 02 03 00 00       	call   1368 <exit>
  }
}
    1066:	c9                   	leave  
    1067:	c3                   	ret    

00001068 <main>:

int
main(int argc, char *argv[])
{
    1068:	55                   	push   %ebp
    1069:	89 e5                	mov    %esp,%ebp
    106b:	83 e4 f0             	and    $0xfffffff0,%esp
    106e:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
    1071:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    1075:	7f 11                	jg     1088 <main+0x20>
    cat(0);
    1077:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    107e:	e8 7d ff ff ff       	call   1000 <cat>
    exit();
    1083:	e8 e0 02 00 00       	call   1368 <exit>
  }

  for(i = 1; i < argc; i++){
    1088:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    108f:	00 
    1090:	eb 78                	jmp    110a <main+0xa2>
    if((fd = open(argv[i], 0)) < 0){
    1092:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1096:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    109d:	8b 45 0c             	mov    0xc(%ebp),%eax
    10a0:	01 d0                	add    %edx,%eax
    10a2:	8b 00                	mov    (%eax),%eax
    10a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    10ab:	00 
    10ac:	89 04 24             	mov    %eax,(%esp)
    10af:	e8 f4 02 00 00       	call   13a8 <open>
    10b4:	89 44 24 18          	mov    %eax,0x18(%esp)
    10b8:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
    10bd:	79 2f                	jns    10ee <main+0x86>
      printf(1, "cat: cannot open %s\n", argv[i]);
    10bf:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    10c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    10ca:	8b 45 0c             	mov    0xc(%ebp),%eax
    10cd:	01 d0                	add    %edx,%eax
    10cf:	8b 00                	mov    (%eax),%eax
    10d1:	89 44 24 08          	mov    %eax,0x8(%esp)
    10d5:	c7 44 24 04 c0 18 00 	movl   $0x18c0,0x4(%esp)
    10dc:	00 
    10dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10e4:	e8 ff 03 00 00       	call   14e8 <printf>
      exit();
    10e9:	e8 7a 02 00 00       	call   1368 <exit>
    }
    cat(fd);
    10ee:	8b 44 24 18          	mov    0x18(%esp),%eax
    10f2:	89 04 24             	mov    %eax,(%esp)
    10f5:	e8 06 ff ff ff       	call   1000 <cat>
    close(fd);
    10fa:	8b 44 24 18          	mov    0x18(%esp),%eax
    10fe:	89 04 24             	mov    %eax,(%esp)
    1101:	e8 8a 02 00 00       	call   1390 <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
    1106:	ff 44 24 1c          	incl   0x1c(%esp)
    110a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    110e:	3b 45 08             	cmp    0x8(%ebp),%eax
    1111:	0f 8c 7b ff ff ff    	jl     1092 <main+0x2a>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
    1117:	e8 4c 02 00 00       	call   1368 <exit>

0000111c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    111c:	55                   	push   %ebp
    111d:	89 e5                	mov    %esp,%ebp
    111f:	57                   	push   %edi
    1120:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1121:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1124:	8b 55 10             	mov    0x10(%ebp),%edx
    1127:	8b 45 0c             	mov    0xc(%ebp),%eax
    112a:	89 cb                	mov    %ecx,%ebx
    112c:	89 df                	mov    %ebx,%edi
    112e:	89 d1                	mov    %edx,%ecx
    1130:	fc                   	cld    
    1131:	f3 aa                	rep stos %al,%es:(%edi)
    1133:	89 ca                	mov    %ecx,%edx
    1135:	89 fb                	mov    %edi,%ebx
    1137:	89 5d 08             	mov    %ebx,0x8(%ebp)
    113a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    113d:	5b                   	pop    %ebx
    113e:	5f                   	pop    %edi
    113f:	5d                   	pop    %ebp
    1140:	c3                   	ret    

00001141 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1141:	55                   	push   %ebp
    1142:	89 e5                	mov    %esp,%ebp
    1144:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1147:	8b 45 08             	mov    0x8(%ebp),%eax
    114a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    114d:	90                   	nop
    114e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1151:	8a 10                	mov    (%eax),%dl
    1153:	8b 45 08             	mov    0x8(%ebp),%eax
    1156:	88 10                	mov    %dl,(%eax)
    1158:	8b 45 08             	mov    0x8(%ebp),%eax
    115b:	8a 00                	mov    (%eax),%al
    115d:	84 c0                	test   %al,%al
    115f:	0f 95 c0             	setne  %al
    1162:	ff 45 08             	incl   0x8(%ebp)
    1165:	ff 45 0c             	incl   0xc(%ebp)
    1168:	84 c0                	test   %al,%al
    116a:	75 e2                	jne    114e <strcpy+0xd>
    ;
  return os;
    116c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    116f:	c9                   	leave  
    1170:	c3                   	ret    

00001171 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1171:	55                   	push   %ebp
    1172:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1174:	eb 06                	jmp    117c <strcmp+0xb>
    p++, q++;
    1176:	ff 45 08             	incl   0x8(%ebp)
    1179:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    117c:	8b 45 08             	mov    0x8(%ebp),%eax
    117f:	8a 00                	mov    (%eax),%al
    1181:	84 c0                	test   %al,%al
    1183:	74 0e                	je     1193 <strcmp+0x22>
    1185:	8b 45 08             	mov    0x8(%ebp),%eax
    1188:	8a 10                	mov    (%eax),%dl
    118a:	8b 45 0c             	mov    0xc(%ebp),%eax
    118d:	8a 00                	mov    (%eax),%al
    118f:	38 c2                	cmp    %al,%dl
    1191:	74 e3                	je     1176 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1193:	8b 45 08             	mov    0x8(%ebp),%eax
    1196:	8a 00                	mov    (%eax),%al
    1198:	0f b6 d0             	movzbl %al,%edx
    119b:	8b 45 0c             	mov    0xc(%ebp),%eax
    119e:	8a 00                	mov    (%eax),%al
    11a0:	0f b6 c0             	movzbl %al,%eax
    11a3:	89 d1                	mov    %edx,%ecx
    11a5:	29 c1                	sub    %eax,%ecx
    11a7:	89 c8                	mov    %ecx,%eax
}
    11a9:	5d                   	pop    %ebp
    11aa:	c3                   	ret    

000011ab <strlen>:

uint
strlen(char *s)
{
    11ab:	55                   	push   %ebp
    11ac:	89 e5                	mov    %esp,%ebp
    11ae:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11b8:	eb 03                	jmp    11bd <strlen+0x12>
    11ba:	ff 45 fc             	incl   -0x4(%ebp)
    11bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11c0:	8b 45 08             	mov    0x8(%ebp),%eax
    11c3:	01 d0                	add    %edx,%eax
    11c5:	8a 00                	mov    (%eax),%al
    11c7:	84 c0                	test   %al,%al
    11c9:	75 ef                	jne    11ba <strlen+0xf>
    ;
  return n;
    11cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11ce:	c9                   	leave  
    11cf:	c3                   	ret    

000011d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11d0:	55                   	push   %ebp
    11d1:	89 e5                	mov    %esp,%ebp
    11d3:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    11d6:	8b 45 10             	mov    0x10(%ebp),%eax
    11d9:	89 44 24 08          	mov    %eax,0x8(%esp)
    11dd:	8b 45 0c             	mov    0xc(%ebp),%eax
    11e0:	89 44 24 04          	mov    %eax,0x4(%esp)
    11e4:	8b 45 08             	mov    0x8(%ebp),%eax
    11e7:	89 04 24             	mov    %eax,(%esp)
    11ea:	e8 2d ff ff ff       	call   111c <stosb>
  return dst;
    11ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11f2:	c9                   	leave  
    11f3:	c3                   	ret    

000011f4 <strchr>:

char*
strchr(const char *s, char c)
{
    11f4:	55                   	push   %ebp
    11f5:	89 e5                	mov    %esp,%ebp
    11f7:	83 ec 04             	sub    $0x4,%esp
    11fa:	8b 45 0c             	mov    0xc(%ebp),%eax
    11fd:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1200:	eb 12                	jmp    1214 <strchr+0x20>
    if(*s == c)
    1202:	8b 45 08             	mov    0x8(%ebp),%eax
    1205:	8a 00                	mov    (%eax),%al
    1207:	3a 45 fc             	cmp    -0x4(%ebp),%al
    120a:	75 05                	jne    1211 <strchr+0x1d>
      return (char*)s;
    120c:	8b 45 08             	mov    0x8(%ebp),%eax
    120f:	eb 11                	jmp    1222 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1211:	ff 45 08             	incl   0x8(%ebp)
    1214:	8b 45 08             	mov    0x8(%ebp),%eax
    1217:	8a 00                	mov    (%eax),%al
    1219:	84 c0                	test   %al,%al
    121b:	75 e5                	jne    1202 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    121d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1222:	c9                   	leave  
    1223:	c3                   	ret    

00001224 <gets>:

char*
gets(char *buf, int max)
{
    1224:	55                   	push   %ebp
    1225:	89 e5                	mov    %esp,%ebp
    1227:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    122a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1231:	eb 42                	jmp    1275 <gets+0x51>
    cc = read(0, &c, 1);
    1233:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    123a:	00 
    123b:	8d 45 ef             	lea    -0x11(%ebp),%eax
    123e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1242:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1249:	e8 32 01 00 00       	call   1380 <read>
    124e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1251:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1255:	7e 29                	jle    1280 <gets+0x5c>
      break;
    buf[i++] = c;
    1257:	8b 55 f4             	mov    -0xc(%ebp),%edx
    125a:	8b 45 08             	mov    0x8(%ebp),%eax
    125d:	01 c2                	add    %eax,%edx
    125f:	8a 45 ef             	mov    -0x11(%ebp),%al
    1262:	88 02                	mov    %al,(%edx)
    1264:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
    1267:	8a 45 ef             	mov    -0x11(%ebp),%al
    126a:	3c 0a                	cmp    $0xa,%al
    126c:	74 13                	je     1281 <gets+0x5d>
    126e:	8a 45 ef             	mov    -0x11(%ebp),%al
    1271:	3c 0d                	cmp    $0xd,%al
    1273:	74 0c                	je     1281 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1275:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1278:	40                   	inc    %eax
    1279:	3b 45 0c             	cmp    0xc(%ebp),%eax
    127c:	7c b5                	jl     1233 <gets+0xf>
    127e:	eb 01                	jmp    1281 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    1280:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1281:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1284:	8b 45 08             	mov    0x8(%ebp),%eax
    1287:	01 d0                	add    %edx,%eax
    1289:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    128c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    128f:	c9                   	leave  
    1290:	c3                   	ret    

00001291 <stat>:

int
stat(char *n, struct stat *st)
{
    1291:	55                   	push   %ebp
    1292:	89 e5                	mov    %esp,%ebp
    1294:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1297:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    129e:	00 
    129f:	8b 45 08             	mov    0x8(%ebp),%eax
    12a2:	89 04 24             	mov    %eax,(%esp)
    12a5:	e8 fe 00 00 00       	call   13a8 <open>
    12aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    12ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12b1:	79 07                	jns    12ba <stat+0x29>
    return -1;
    12b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12b8:	eb 23                	jmp    12dd <stat+0x4c>
  r = fstat(fd, st);
    12ba:	8b 45 0c             	mov    0xc(%ebp),%eax
    12bd:	89 44 24 04          	mov    %eax,0x4(%esp)
    12c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12c4:	89 04 24             	mov    %eax,(%esp)
    12c7:	e8 f4 00 00 00       	call   13c0 <fstat>
    12cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    12cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12d2:	89 04 24             	mov    %eax,(%esp)
    12d5:	e8 b6 00 00 00       	call   1390 <close>
  return r;
    12da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    12dd:	c9                   	leave  
    12de:	c3                   	ret    

000012df <atoi>:

int
atoi(const char *s)
{
    12df:	55                   	push   %ebp
    12e0:	89 e5                	mov    %esp,%ebp
    12e2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    12e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    12ec:	eb 21                	jmp    130f <atoi+0x30>
    n = n*10 + *s++ - '0';
    12ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
    12f1:	89 d0                	mov    %edx,%eax
    12f3:	c1 e0 02             	shl    $0x2,%eax
    12f6:	01 d0                	add    %edx,%eax
    12f8:	d1 e0                	shl    %eax
    12fa:	89 c2                	mov    %eax,%edx
    12fc:	8b 45 08             	mov    0x8(%ebp),%eax
    12ff:	8a 00                	mov    (%eax),%al
    1301:	0f be c0             	movsbl %al,%eax
    1304:	01 d0                	add    %edx,%eax
    1306:	83 e8 30             	sub    $0x30,%eax
    1309:	89 45 fc             	mov    %eax,-0x4(%ebp)
    130c:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    130f:	8b 45 08             	mov    0x8(%ebp),%eax
    1312:	8a 00                	mov    (%eax),%al
    1314:	3c 2f                	cmp    $0x2f,%al
    1316:	7e 09                	jle    1321 <atoi+0x42>
    1318:	8b 45 08             	mov    0x8(%ebp),%eax
    131b:	8a 00                	mov    (%eax),%al
    131d:	3c 39                	cmp    $0x39,%al
    131f:	7e cd                	jle    12ee <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1321:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1324:	c9                   	leave  
    1325:	c3                   	ret    

00001326 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1326:	55                   	push   %ebp
    1327:	89 e5                	mov    %esp,%ebp
    1329:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    132c:	8b 45 08             	mov    0x8(%ebp),%eax
    132f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1332:	8b 45 0c             	mov    0xc(%ebp),%eax
    1335:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1338:	eb 10                	jmp    134a <memmove+0x24>
    *dst++ = *src++;
    133a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    133d:	8a 10                	mov    (%eax),%dl
    133f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1342:	88 10                	mov    %dl,(%eax)
    1344:	ff 45 fc             	incl   -0x4(%ebp)
    1347:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    134a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    134e:	0f 9f c0             	setg   %al
    1351:	ff 4d 10             	decl   0x10(%ebp)
    1354:	84 c0                	test   %al,%al
    1356:	75 e2                	jne    133a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1358:	8b 45 08             	mov    0x8(%ebp),%eax
}
    135b:	c9                   	leave  
    135c:	c3                   	ret    
    135d:	66 90                	xchg   %ax,%ax
    135f:	90                   	nop

00001360 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1360:	b8 01 00 00 00       	mov    $0x1,%eax
    1365:	cd 40                	int    $0x40
    1367:	c3                   	ret    

00001368 <exit>:
SYSCALL(exit)
    1368:	b8 02 00 00 00       	mov    $0x2,%eax
    136d:	cd 40                	int    $0x40
    136f:	c3                   	ret    

00001370 <wait>:
SYSCALL(wait)
    1370:	b8 03 00 00 00       	mov    $0x3,%eax
    1375:	cd 40                	int    $0x40
    1377:	c3                   	ret    

00001378 <pipe>:
SYSCALL(pipe)
    1378:	b8 04 00 00 00       	mov    $0x4,%eax
    137d:	cd 40                	int    $0x40
    137f:	c3                   	ret    

00001380 <read>:
SYSCALL(read)
    1380:	b8 05 00 00 00       	mov    $0x5,%eax
    1385:	cd 40                	int    $0x40
    1387:	c3                   	ret    

00001388 <write>:
SYSCALL(write)
    1388:	b8 10 00 00 00       	mov    $0x10,%eax
    138d:	cd 40                	int    $0x40
    138f:	c3                   	ret    

00001390 <close>:
SYSCALL(close)
    1390:	b8 15 00 00 00       	mov    $0x15,%eax
    1395:	cd 40                	int    $0x40
    1397:	c3                   	ret    

00001398 <kill>:
SYSCALL(kill)
    1398:	b8 06 00 00 00       	mov    $0x6,%eax
    139d:	cd 40                	int    $0x40
    139f:	c3                   	ret    

000013a0 <exec>:
SYSCALL(exec)
    13a0:	b8 07 00 00 00       	mov    $0x7,%eax
    13a5:	cd 40                	int    $0x40
    13a7:	c3                   	ret    

000013a8 <open>:
SYSCALL(open)
    13a8:	b8 0f 00 00 00       	mov    $0xf,%eax
    13ad:	cd 40                	int    $0x40
    13af:	c3                   	ret    

000013b0 <mknod>:
SYSCALL(mknod)
    13b0:	b8 11 00 00 00       	mov    $0x11,%eax
    13b5:	cd 40                	int    $0x40
    13b7:	c3                   	ret    

000013b8 <unlink>:
SYSCALL(unlink)
    13b8:	b8 12 00 00 00       	mov    $0x12,%eax
    13bd:	cd 40                	int    $0x40
    13bf:	c3                   	ret    

000013c0 <fstat>:
SYSCALL(fstat)
    13c0:	b8 08 00 00 00       	mov    $0x8,%eax
    13c5:	cd 40                	int    $0x40
    13c7:	c3                   	ret    

000013c8 <link>:
SYSCALL(link)
    13c8:	b8 13 00 00 00       	mov    $0x13,%eax
    13cd:	cd 40                	int    $0x40
    13cf:	c3                   	ret    

000013d0 <mkdir>:
SYSCALL(mkdir)
    13d0:	b8 14 00 00 00       	mov    $0x14,%eax
    13d5:	cd 40                	int    $0x40
    13d7:	c3                   	ret    

000013d8 <chdir>:
SYSCALL(chdir)
    13d8:	b8 09 00 00 00       	mov    $0x9,%eax
    13dd:	cd 40                	int    $0x40
    13df:	c3                   	ret    

000013e0 <dup>:
SYSCALL(dup)
    13e0:	b8 0a 00 00 00       	mov    $0xa,%eax
    13e5:	cd 40                	int    $0x40
    13e7:	c3                   	ret    

000013e8 <getpid>:
SYSCALL(getpid)
    13e8:	b8 0b 00 00 00       	mov    $0xb,%eax
    13ed:	cd 40                	int    $0x40
    13ef:	c3                   	ret    

000013f0 <sbrk>:
SYSCALL(sbrk)
    13f0:	b8 0c 00 00 00       	mov    $0xc,%eax
    13f5:	cd 40                	int    $0x40
    13f7:	c3                   	ret    

000013f8 <sleep>:
SYSCALL(sleep)
    13f8:	b8 0d 00 00 00       	mov    $0xd,%eax
    13fd:	cd 40                	int    $0x40
    13ff:	c3                   	ret    

00001400 <uptime>:
SYSCALL(uptime)
    1400:	b8 0e 00 00 00       	mov    $0xe,%eax
    1405:	cd 40                	int    $0x40
    1407:	c3                   	ret    

00001408 <cowfork>:
SYSCALL(cowfork) //3.4
    1408:	b8 16 00 00 00       	mov    $0x16,%eax
    140d:	cd 40                	int    $0x40
    140f:	c3                   	ret    

00001410 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1410:	55                   	push   %ebp
    1411:	89 e5                	mov    %esp,%ebp
    1413:	83 ec 28             	sub    $0x28,%esp
    1416:	8b 45 0c             	mov    0xc(%ebp),%eax
    1419:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    141c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1423:	00 
    1424:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1427:	89 44 24 04          	mov    %eax,0x4(%esp)
    142b:	8b 45 08             	mov    0x8(%ebp),%eax
    142e:	89 04 24             	mov    %eax,(%esp)
    1431:	e8 52 ff ff ff       	call   1388 <write>
}
    1436:	c9                   	leave  
    1437:	c3                   	ret    

00001438 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1438:	55                   	push   %ebp
    1439:	89 e5                	mov    %esp,%ebp
    143b:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    143e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1445:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1449:	74 17                	je     1462 <printint+0x2a>
    144b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    144f:	79 11                	jns    1462 <printint+0x2a>
    neg = 1;
    1451:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1458:	8b 45 0c             	mov    0xc(%ebp),%eax
    145b:	f7 d8                	neg    %eax
    145d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1460:	eb 06                	jmp    1468 <printint+0x30>
  } else {
    x = xx;
    1462:	8b 45 0c             	mov    0xc(%ebp),%eax
    1465:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1468:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    146f:	8b 4d 10             	mov    0x10(%ebp),%ecx
    1472:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1475:	ba 00 00 00 00       	mov    $0x0,%edx
    147a:	f7 f1                	div    %ecx
    147c:	89 d0                	mov    %edx,%eax
    147e:	8a 80 38 2b 00 00    	mov    0x2b38(%eax),%al
    1484:	8d 4d dc             	lea    -0x24(%ebp),%ecx
    1487:	8b 55 f4             	mov    -0xc(%ebp),%edx
    148a:	01 ca                	add    %ecx,%edx
    148c:	88 02                	mov    %al,(%edx)
    148e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
    1491:	8b 55 10             	mov    0x10(%ebp),%edx
    1494:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    1497:	8b 45 ec             	mov    -0x14(%ebp),%eax
    149a:	ba 00 00 00 00       	mov    $0x0,%edx
    149f:	f7 75 d4             	divl   -0x2c(%ebp)
    14a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14a9:	75 c4                	jne    146f <printint+0x37>
  if(neg)
    14ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14af:	74 2c                	je     14dd <printint+0xa5>
    buf[i++] = '-';
    14b1:	8d 55 dc             	lea    -0x24(%ebp),%edx
    14b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14b7:	01 d0                	add    %edx,%eax
    14b9:	c6 00 2d             	movb   $0x2d,(%eax)
    14bc:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
    14bf:	eb 1c                	jmp    14dd <printint+0xa5>
    putc(fd, buf[i]);
    14c1:	8d 55 dc             	lea    -0x24(%ebp),%edx
    14c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14c7:	01 d0                	add    %edx,%eax
    14c9:	8a 00                	mov    (%eax),%al
    14cb:	0f be c0             	movsbl %al,%eax
    14ce:	89 44 24 04          	mov    %eax,0x4(%esp)
    14d2:	8b 45 08             	mov    0x8(%ebp),%eax
    14d5:	89 04 24             	mov    %eax,(%esp)
    14d8:	e8 33 ff ff ff       	call   1410 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    14dd:	ff 4d f4             	decl   -0xc(%ebp)
    14e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14e4:	79 db                	jns    14c1 <printint+0x89>
    putc(fd, buf[i]);
}
    14e6:	c9                   	leave  
    14e7:	c3                   	ret    

000014e8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    14e8:	55                   	push   %ebp
    14e9:	89 e5                	mov    %esp,%ebp
    14eb:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    14ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    14f5:	8d 45 0c             	lea    0xc(%ebp),%eax
    14f8:	83 c0 04             	add    $0x4,%eax
    14fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    14fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1505:	e9 78 01 00 00       	jmp    1682 <printf+0x19a>
    c = fmt[i] & 0xff;
    150a:	8b 55 0c             	mov    0xc(%ebp),%edx
    150d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1510:	01 d0                	add    %edx,%eax
    1512:	8a 00                	mov    (%eax),%al
    1514:	0f be c0             	movsbl %al,%eax
    1517:	25 ff 00 00 00       	and    $0xff,%eax
    151c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    151f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1523:	75 2c                	jne    1551 <printf+0x69>
      if(c == '%'){
    1525:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1529:	75 0c                	jne    1537 <printf+0x4f>
        state = '%';
    152b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1532:	e9 48 01 00 00       	jmp    167f <printf+0x197>
      } else {
        putc(fd, c);
    1537:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    153a:	0f be c0             	movsbl %al,%eax
    153d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1541:	8b 45 08             	mov    0x8(%ebp),%eax
    1544:	89 04 24             	mov    %eax,(%esp)
    1547:	e8 c4 fe ff ff       	call   1410 <putc>
    154c:	e9 2e 01 00 00       	jmp    167f <printf+0x197>
      }
    } else if(state == '%'){
    1551:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1555:	0f 85 24 01 00 00    	jne    167f <printf+0x197>
      if(c == 'd'){
    155b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    155f:	75 2d                	jne    158e <printf+0xa6>
        printint(fd, *ap, 10, 1);
    1561:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1564:	8b 00                	mov    (%eax),%eax
    1566:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    156d:	00 
    156e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1575:	00 
    1576:	89 44 24 04          	mov    %eax,0x4(%esp)
    157a:	8b 45 08             	mov    0x8(%ebp),%eax
    157d:	89 04 24             	mov    %eax,(%esp)
    1580:	e8 b3 fe ff ff       	call   1438 <printint>
        ap++;
    1585:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1589:	e9 ea 00 00 00       	jmp    1678 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
    158e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1592:	74 06                	je     159a <printf+0xb2>
    1594:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1598:	75 2d                	jne    15c7 <printf+0xdf>
        printint(fd, *ap, 16, 0);
    159a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    159d:	8b 00                	mov    (%eax),%eax
    159f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    15a6:	00 
    15a7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    15ae:	00 
    15af:	89 44 24 04          	mov    %eax,0x4(%esp)
    15b3:	8b 45 08             	mov    0x8(%ebp),%eax
    15b6:	89 04 24             	mov    %eax,(%esp)
    15b9:	e8 7a fe ff ff       	call   1438 <printint>
        ap++;
    15be:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15c2:	e9 b1 00 00 00       	jmp    1678 <printf+0x190>
      } else if(c == 's'){
    15c7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    15cb:	75 43                	jne    1610 <printf+0x128>
        s = (char*)*ap;
    15cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15d0:	8b 00                	mov    (%eax),%eax
    15d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    15d5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    15d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15dd:	75 25                	jne    1604 <printf+0x11c>
          s = "(null)";
    15df:	c7 45 f4 d5 18 00 00 	movl   $0x18d5,-0xc(%ebp)
        while(*s != 0){
    15e6:	eb 1c                	jmp    1604 <printf+0x11c>
          putc(fd, *s);
    15e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15eb:	8a 00                	mov    (%eax),%al
    15ed:	0f be c0             	movsbl %al,%eax
    15f0:	89 44 24 04          	mov    %eax,0x4(%esp)
    15f4:	8b 45 08             	mov    0x8(%ebp),%eax
    15f7:	89 04 24             	mov    %eax,(%esp)
    15fa:	e8 11 fe ff ff       	call   1410 <putc>
          s++;
    15ff:	ff 45 f4             	incl   -0xc(%ebp)
    1602:	eb 01                	jmp    1605 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1604:	90                   	nop
    1605:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1608:	8a 00                	mov    (%eax),%al
    160a:	84 c0                	test   %al,%al
    160c:	75 da                	jne    15e8 <printf+0x100>
    160e:	eb 68                	jmp    1678 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1610:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1614:	75 1d                	jne    1633 <printf+0x14b>
        putc(fd, *ap);
    1616:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1619:	8b 00                	mov    (%eax),%eax
    161b:	0f be c0             	movsbl %al,%eax
    161e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1622:	8b 45 08             	mov    0x8(%ebp),%eax
    1625:	89 04 24             	mov    %eax,(%esp)
    1628:	e8 e3 fd ff ff       	call   1410 <putc>
        ap++;
    162d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1631:	eb 45                	jmp    1678 <printf+0x190>
      } else if(c == '%'){
    1633:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1637:	75 17                	jne    1650 <printf+0x168>
        putc(fd, c);
    1639:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    163c:	0f be c0             	movsbl %al,%eax
    163f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1643:	8b 45 08             	mov    0x8(%ebp),%eax
    1646:	89 04 24             	mov    %eax,(%esp)
    1649:	e8 c2 fd ff ff       	call   1410 <putc>
    164e:	eb 28                	jmp    1678 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1650:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1657:	00 
    1658:	8b 45 08             	mov    0x8(%ebp),%eax
    165b:	89 04 24             	mov    %eax,(%esp)
    165e:	e8 ad fd ff ff       	call   1410 <putc>
        putc(fd, c);
    1663:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1666:	0f be c0             	movsbl %al,%eax
    1669:	89 44 24 04          	mov    %eax,0x4(%esp)
    166d:	8b 45 08             	mov    0x8(%ebp),%eax
    1670:	89 04 24             	mov    %eax,(%esp)
    1673:	e8 98 fd ff ff       	call   1410 <putc>
      }
      state = 0;
    1678:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    167f:	ff 45 f0             	incl   -0x10(%ebp)
    1682:	8b 55 0c             	mov    0xc(%ebp),%edx
    1685:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1688:	01 d0                	add    %edx,%eax
    168a:	8a 00                	mov    (%eax),%al
    168c:	84 c0                	test   %al,%al
    168e:	0f 85 76 fe ff ff    	jne    150a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1694:	c9                   	leave  
    1695:	c3                   	ret    
    1696:	66 90                	xchg   %ax,%ax

00001698 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1698:	55                   	push   %ebp
    1699:	89 e5                	mov    %esp,%ebp
    169b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    169e:	8b 45 08             	mov    0x8(%ebp),%eax
    16a1:	83 e8 08             	sub    $0x8,%eax
    16a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16a7:	a1 68 2b 00 00       	mov    0x2b68,%eax
    16ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16af:	eb 24                	jmp    16d5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16b4:	8b 00                	mov    (%eax),%eax
    16b6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16b9:	77 12                	ja     16cd <free+0x35>
    16bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16c1:	77 24                	ja     16e7 <free+0x4f>
    16c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16c6:	8b 00                	mov    (%eax),%eax
    16c8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16cb:	77 1a                	ja     16e7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d0:	8b 00                	mov    (%eax),%eax
    16d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16db:	76 d4                	jbe    16b1 <free+0x19>
    16dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16e0:	8b 00                	mov    (%eax),%eax
    16e2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16e5:	76 ca                	jbe    16b1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    16e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16ea:	8b 40 04             	mov    0x4(%eax),%eax
    16ed:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    16f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16f7:	01 c2                	add    %eax,%edx
    16f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16fc:	8b 00                	mov    (%eax),%eax
    16fe:	39 c2                	cmp    %eax,%edx
    1700:	75 24                	jne    1726 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1702:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1705:	8b 50 04             	mov    0x4(%eax),%edx
    1708:	8b 45 fc             	mov    -0x4(%ebp),%eax
    170b:	8b 00                	mov    (%eax),%eax
    170d:	8b 40 04             	mov    0x4(%eax),%eax
    1710:	01 c2                	add    %eax,%edx
    1712:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1715:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1718:	8b 45 fc             	mov    -0x4(%ebp),%eax
    171b:	8b 00                	mov    (%eax),%eax
    171d:	8b 10                	mov    (%eax),%edx
    171f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1722:	89 10                	mov    %edx,(%eax)
    1724:	eb 0a                	jmp    1730 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1726:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1729:	8b 10                	mov    (%eax),%edx
    172b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    172e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1730:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1733:	8b 40 04             	mov    0x4(%eax),%eax
    1736:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    173d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1740:	01 d0                	add    %edx,%eax
    1742:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1745:	75 20                	jne    1767 <free+0xcf>
    p->s.size += bp->s.size;
    1747:	8b 45 fc             	mov    -0x4(%ebp),%eax
    174a:	8b 50 04             	mov    0x4(%eax),%edx
    174d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1750:	8b 40 04             	mov    0x4(%eax),%eax
    1753:	01 c2                	add    %eax,%edx
    1755:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1758:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    175b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    175e:	8b 10                	mov    (%eax),%edx
    1760:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1763:	89 10                	mov    %edx,(%eax)
    1765:	eb 08                	jmp    176f <free+0xd7>
  } else
    p->s.ptr = bp;
    1767:	8b 45 fc             	mov    -0x4(%ebp),%eax
    176a:	8b 55 f8             	mov    -0x8(%ebp),%edx
    176d:	89 10                	mov    %edx,(%eax)
  freep = p;
    176f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1772:	a3 68 2b 00 00       	mov    %eax,0x2b68
}
    1777:	c9                   	leave  
    1778:	c3                   	ret    

00001779 <morecore>:

static Header*
morecore(uint nu)
{
    1779:	55                   	push   %ebp
    177a:	89 e5                	mov    %esp,%ebp
    177c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    177f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1786:	77 07                	ja     178f <morecore+0x16>
    nu = 4096;
    1788:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    178f:	8b 45 08             	mov    0x8(%ebp),%eax
    1792:	c1 e0 03             	shl    $0x3,%eax
    1795:	89 04 24             	mov    %eax,(%esp)
    1798:	e8 53 fc ff ff       	call   13f0 <sbrk>
    179d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    17a0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    17a4:	75 07                	jne    17ad <morecore+0x34>
    return 0;
    17a6:	b8 00 00 00 00       	mov    $0x0,%eax
    17ab:	eb 22                	jmp    17cf <morecore+0x56>
  hp = (Header*)p;
    17ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    17b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17b6:	8b 55 08             	mov    0x8(%ebp),%edx
    17b9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    17bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17bf:	83 c0 08             	add    $0x8,%eax
    17c2:	89 04 24             	mov    %eax,(%esp)
    17c5:	e8 ce fe ff ff       	call   1698 <free>
  return freep;
    17ca:	a1 68 2b 00 00       	mov    0x2b68,%eax
}
    17cf:	c9                   	leave  
    17d0:	c3                   	ret    

000017d1 <malloc>:

void*
malloc(uint nbytes)
{
    17d1:	55                   	push   %ebp
    17d2:	89 e5                	mov    %esp,%ebp
    17d4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17d7:	8b 45 08             	mov    0x8(%ebp),%eax
    17da:	83 c0 07             	add    $0x7,%eax
    17dd:	c1 e8 03             	shr    $0x3,%eax
    17e0:	40                   	inc    %eax
    17e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    17e4:	a1 68 2b 00 00       	mov    0x2b68,%eax
    17e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    17ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    17f0:	75 23                	jne    1815 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    17f2:	c7 45 f0 60 2b 00 00 	movl   $0x2b60,-0x10(%ebp)
    17f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17fc:	a3 68 2b 00 00       	mov    %eax,0x2b68
    1801:	a1 68 2b 00 00       	mov    0x2b68,%eax
    1806:	a3 60 2b 00 00       	mov    %eax,0x2b60
    base.s.size = 0;
    180b:	c7 05 64 2b 00 00 00 	movl   $0x0,0x2b64
    1812:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1815:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1818:	8b 00                	mov    (%eax),%eax
    181a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    181d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1820:	8b 40 04             	mov    0x4(%eax),%eax
    1823:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1826:	72 4d                	jb     1875 <malloc+0xa4>
      if(p->s.size == nunits)
    1828:	8b 45 f4             	mov    -0xc(%ebp),%eax
    182b:	8b 40 04             	mov    0x4(%eax),%eax
    182e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1831:	75 0c                	jne    183f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    1833:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1836:	8b 10                	mov    (%eax),%edx
    1838:	8b 45 f0             	mov    -0x10(%ebp),%eax
    183b:	89 10                	mov    %edx,(%eax)
    183d:	eb 26                	jmp    1865 <malloc+0x94>
      else {
        p->s.size -= nunits;
    183f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1842:	8b 40 04             	mov    0x4(%eax),%eax
    1845:	89 c2                	mov    %eax,%edx
    1847:	2b 55 ec             	sub    -0x14(%ebp),%edx
    184a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    184d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1850:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1853:	8b 40 04             	mov    0x4(%eax),%eax
    1856:	c1 e0 03             	shl    $0x3,%eax
    1859:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    185c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    185f:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1862:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1865:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1868:	a3 68 2b 00 00       	mov    %eax,0x2b68
      return (void*)(p + 1);
    186d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1870:	83 c0 08             	add    $0x8,%eax
    1873:	eb 38                	jmp    18ad <malloc+0xdc>
    }
    if(p == freep)
    1875:	a1 68 2b 00 00       	mov    0x2b68,%eax
    187a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    187d:	75 1b                	jne    189a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    187f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1882:	89 04 24             	mov    %eax,(%esp)
    1885:	e8 ef fe ff ff       	call   1779 <morecore>
    188a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    188d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1891:	75 07                	jne    189a <malloc+0xc9>
        return 0;
    1893:	b8 00 00 00 00       	mov    $0x0,%eax
    1898:	eb 13                	jmp    18ad <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    189a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    189d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18a3:	8b 00                	mov    (%eax),%eax
    18a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    18a8:	e9 70 ff ff ff       	jmp    181d <malloc+0x4c>
}
    18ad:	c9                   	leave  
    18ae:	c3                   	ret    
