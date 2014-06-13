
_wc:     file format elf32-i386


Disassembly of section .text:

00001000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 48             	sub    $0x48,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
    1006:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    100d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1010:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1013:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1016:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
    1019:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1020:	eb 62                	jmp    1084 <wc+0x84>
    for(i=0; i<n; i++){
    1022:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1029:	eb 51                	jmp    107c <wc+0x7c>
      c++;
    102b:	ff 45 e8             	incl   -0x18(%ebp)
      if(buf[i] == '\n')
    102e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1031:	05 40 2c 00 00       	add    $0x2c40,%eax
    1036:	8a 00                	mov    (%eax),%al
    1038:	3c 0a                	cmp    $0xa,%al
    103a:	75 03                	jne    103f <wc+0x3f>
        l++;
    103c:	ff 45 f0             	incl   -0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
    103f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1042:	05 40 2c 00 00       	add    $0x2c40,%eax
    1047:	8a 00                	mov    (%eax),%al
    1049:	0f be c0             	movsbl %al,%eax
    104c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1050:	c7 04 24 67 19 00 00 	movl   $0x1967,(%esp)
    1057:	e8 50 02 00 00       	call   12ac <strchr>
    105c:	85 c0                	test   %eax,%eax
    105e:	74 09                	je     1069 <wc+0x69>
        inword = 0;
    1060:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    1067:	eb 10                	jmp    1079 <wc+0x79>
      else if(!inword){
    1069:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    106d:	75 0a                	jne    1079 <wc+0x79>
        w++;
    106f:	ff 45 ec             	incl   -0x14(%ebp)
        inword = 1;
    1072:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
    1079:	ff 45 f4             	incl   -0xc(%ebp)
    107c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    107f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    1082:	7c a7                	jl     102b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1084:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    108b:	00 
    108c:	c7 44 24 04 40 2c 00 	movl   $0x2c40,0x4(%esp)
    1093:	00 
    1094:	8b 45 08             	mov    0x8(%ebp),%eax
    1097:	89 04 24             	mov    %eax,(%esp)
    109a:	e8 99 03 00 00       	call   1438 <read>
    109f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    10a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    10a6:	0f 8f 76 ff ff ff    	jg     1022 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
    10ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
    10b0:	79 19                	jns    10cb <wc+0xcb>
    printf(1, "wc: read error\n");
    10b2:	c7 44 24 04 6d 19 00 	movl   $0x196d,0x4(%esp)
    10b9:	00 
    10ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10c1:	e8 da 04 00 00       	call   15a0 <printf>
    exit();
    10c6:	e8 55 03 00 00       	call   1420 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
    10cb:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ce:	89 44 24 14          	mov    %eax,0x14(%esp)
    10d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10d5:	89 44 24 10          	mov    %eax,0x10(%esp)
    10d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    10dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
    10e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10e3:	89 44 24 08          	mov    %eax,0x8(%esp)
    10e7:	c7 44 24 04 7d 19 00 	movl   $0x197d,0x4(%esp)
    10ee:	00 
    10ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10f6:	e8 a5 04 00 00       	call   15a0 <printf>
}
    10fb:	c9                   	leave  
    10fc:	c3                   	ret    

000010fd <main>:

int
main(int argc, char *argv[])
{
    10fd:	55                   	push   %ebp
    10fe:	89 e5                	mov    %esp,%ebp
    1100:	83 e4 f0             	and    $0xfffffff0,%esp
    1103:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
    1106:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    110a:	7f 19                	jg     1125 <main+0x28>
    wc(0, "");
    110c:	c7 44 24 04 8a 19 00 	movl   $0x198a,0x4(%esp)
    1113:	00 
    1114:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    111b:	e8 e0 fe ff ff       	call   1000 <wc>
    exit();
    1120:	e8 fb 02 00 00       	call   1420 <exit>
  }

  for(i = 1; i < argc; i++){
    1125:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    112c:	00 
    112d:	e9 8e 00 00 00       	jmp    11c0 <main+0xc3>
    if((fd = open(argv[i], 0)) < 0){
    1132:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1136:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    113d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1140:	01 d0                	add    %edx,%eax
    1142:	8b 00                	mov    (%eax),%eax
    1144:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    114b:	00 
    114c:	89 04 24             	mov    %eax,(%esp)
    114f:	e8 0c 03 00 00       	call   1460 <open>
    1154:	89 44 24 18          	mov    %eax,0x18(%esp)
    1158:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
    115d:	79 2f                	jns    118e <main+0x91>
      printf(1, "cat: cannot open %s\n", argv[i]);
    115f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1163:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    116a:	8b 45 0c             	mov    0xc(%ebp),%eax
    116d:	01 d0                	add    %edx,%eax
    116f:	8b 00                	mov    (%eax),%eax
    1171:	89 44 24 08          	mov    %eax,0x8(%esp)
    1175:	c7 44 24 04 8b 19 00 	movl   $0x198b,0x4(%esp)
    117c:	00 
    117d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1184:	e8 17 04 00 00       	call   15a0 <printf>
      exit();
    1189:	e8 92 02 00 00       	call   1420 <exit>
    }
    wc(fd, argv[i]);
    118e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1192:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1199:	8b 45 0c             	mov    0xc(%ebp),%eax
    119c:	01 d0                	add    %edx,%eax
    119e:	8b 00                	mov    (%eax),%eax
    11a0:	89 44 24 04          	mov    %eax,0x4(%esp)
    11a4:	8b 44 24 18          	mov    0x18(%esp),%eax
    11a8:	89 04 24             	mov    %eax,(%esp)
    11ab:	e8 50 fe ff ff       	call   1000 <wc>
    close(fd);
    11b0:	8b 44 24 18          	mov    0x18(%esp),%eax
    11b4:	89 04 24             	mov    %eax,(%esp)
    11b7:	e8 8c 02 00 00       	call   1448 <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
    11bc:	ff 44 24 1c          	incl   0x1c(%esp)
    11c0:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    11c4:	3b 45 08             	cmp    0x8(%ebp),%eax
    11c7:	0f 8c 65 ff ff ff    	jl     1132 <main+0x35>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
    11cd:	e8 4e 02 00 00       	call   1420 <exit>
    11d2:	66 90                	xchg   %ax,%ax

000011d4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    11d4:	55                   	push   %ebp
    11d5:	89 e5                	mov    %esp,%ebp
    11d7:	57                   	push   %edi
    11d8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    11d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
    11dc:	8b 55 10             	mov    0x10(%ebp),%edx
    11df:	8b 45 0c             	mov    0xc(%ebp),%eax
    11e2:	89 cb                	mov    %ecx,%ebx
    11e4:	89 df                	mov    %ebx,%edi
    11e6:	89 d1                	mov    %edx,%ecx
    11e8:	fc                   	cld    
    11e9:	f3 aa                	rep stos %al,%es:(%edi)
    11eb:	89 ca                	mov    %ecx,%edx
    11ed:	89 fb                	mov    %edi,%ebx
    11ef:	89 5d 08             	mov    %ebx,0x8(%ebp)
    11f2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    11f5:	5b                   	pop    %ebx
    11f6:	5f                   	pop    %edi
    11f7:	5d                   	pop    %ebp
    11f8:	c3                   	ret    

000011f9 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    11f9:	55                   	push   %ebp
    11fa:	89 e5                	mov    %esp,%ebp
    11fc:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    11ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1202:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1205:	90                   	nop
    1206:	8b 45 0c             	mov    0xc(%ebp),%eax
    1209:	8a 10                	mov    (%eax),%dl
    120b:	8b 45 08             	mov    0x8(%ebp),%eax
    120e:	88 10                	mov    %dl,(%eax)
    1210:	8b 45 08             	mov    0x8(%ebp),%eax
    1213:	8a 00                	mov    (%eax),%al
    1215:	84 c0                	test   %al,%al
    1217:	0f 95 c0             	setne  %al
    121a:	ff 45 08             	incl   0x8(%ebp)
    121d:	ff 45 0c             	incl   0xc(%ebp)
    1220:	84 c0                	test   %al,%al
    1222:	75 e2                	jne    1206 <strcpy+0xd>
    ;
  return os;
    1224:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1227:	c9                   	leave  
    1228:	c3                   	ret    

00001229 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1229:	55                   	push   %ebp
    122a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    122c:	eb 06                	jmp    1234 <strcmp+0xb>
    p++, q++;
    122e:	ff 45 08             	incl   0x8(%ebp)
    1231:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1234:	8b 45 08             	mov    0x8(%ebp),%eax
    1237:	8a 00                	mov    (%eax),%al
    1239:	84 c0                	test   %al,%al
    123b:	74 0e                	je     124b <strcmp+0x22>
    123d:	8b 45 08             	mov    0x8(%ebp),%eax
    1240:	8a 10                	mov    (%eax),%dl
    1242:	8b 45 0c             	mov    0xc(%ebp),%eax
    1245:	8a 00                	mov    (%eax),%al
    1247:	38 c2                	cmp    %al,%dl
    1249:	74 e3                	je     122e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    124b:	8b 45 08             	mov    0x8(%ebp),%eax
    124e:	8a 00                	mov    (%eax),%al
    1250:	0f b6 d0             	movzbl %al,%edx
    1253:	8b 45 0c             	mov    0xc(%ebp),%eax
    1256:	8a 00                	mov    (%eax),%al
    1258:	0f b6 c0             	movzbl %al,%eax
    125b:	89 d1                	mov    %edx,%ecx
    125d:	29 c1                	sub    %eax,%ecx
    125f:	89 c8                	mov    %ecx,%eax
}
    1261:	5d                   	pop    %ebp
    1262:	c3                   	ret    

00001263 <strlen>:

uint
strlen(char *s)
{
    1263:	55                   	push   %ebp
    1264:	89 e5                	mov    %esp,%ebp
    1266:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1269:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1270:	eb 03                	jmp    1275 <strlen+0x12>
    1272:	ff 45 fc             	incl   -0x4(%ebp)
    1275:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1278:	8b 45 08             	mov    0x8(%ebp),%eax
    127b:	01 d0                	add    %edx,%eax
    127d:	8a 00                	mov    (%eax),%al
    127f:	84 c0                	test   %al,%al
    1281:	75 ef                	jne    1272 <strlen+0xf>
    ;
  return n;
    1283:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1286:	c9                   	leave  
    1287:	c3                   	ret    

00001288 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1288:	55                   	push   %ebp
    1289:	89 e5                	mov    %esp,%ebp
    128b:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    128e:	8b 45 10             	mov    0x10(%ebp),%eax
    1291:	89 44 24 08          	mov    %eax,0x8(%esp)
    1295:	8b 45 0c             	mov    0xc(%ebp),%eax
    1298:	89 44 24 04          	mov    %eax,0x4(%esp)
    129c:	8b 45 08             	mov    0x8(%ebp),%eax
    129f:	89 04 24             	mov    %eax,(%esp)
    12a2:	e8 2d ff ff ff       	call   11d4 <stosb>
  return dst;
    12a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12aa:	c9                   	leave  
    12ab:	c3                   	ret    

000012ac <strchr>:

char*
strchr(const char *s, char c)
{
    12ac:	55                   	push   %ebp
    12ad:	89 e5                	mov    %esp,%ebp
    12af:	83 ec 04             	sub    $0x4,%esp
    12b2:	8b 45 0c             	mov    0xc(%ebp),%eax
    12b5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    12b8:	eb 12                	jmp    12cc <strchr+0x20>
    if(*s == c)
    12ba:	8b 45 08             	mov    0x8(%ebp),%eax
    12bd:	8a 00                	mov    (%eax),%al
    12bf:	3a 45 fc             	cmp    -0x4(%ebp),%al
    12c2:	75 05                	jne    12c9 <strchr+0x1d>
      return (char*)s;
    12c4:	8b 45 08             	mov    0x8(%ebp),%eax
    12c7:	eb 11                	jmp    12da <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    12c9:	ff 45 08             	incl   0x8(%ebp)
    12cc:	8b 45 08             	mov    0x8(%ebp),%eax
    12cf:	8a 00                	mov    (%eax),%al
    12d1:	84 c0                	test   %al,%al
    12d3:	75 e5                	jne    12ba <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    12d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
    12da:	c9                   	leave  
    12db:	c3                   	ret    

000012dc <gets>:

char*
gets(char *buf, int max)
{
    12dc:	55                   	push   %ebp
    12dd:	89 e5                	mov    %esp,%ebp
    12df:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    12e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    12e9:	eb 42                	jmp    132d <gets+0x51>
    cc = read(0, &c, 1);
    12eb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    12f2:	00 
    12f3:	8d 45 ef             	lea    -0x11(%ebp),%eax
    12f6:	89 44 24 04          	mov    %eax,0x4(%esp)
    12fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1301:	e8 32 01 00 00       	call   1438 <read>
    1306:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1309:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    130d:	7e 29                	jle    1338 <gets+0x5c>
      break;
    buf[i++] = c;
    130f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1312:	8b 45 08             	mov    0x8(%ebp),%eax
    1315:	01 c2                	add    %eax,%edx
    1317:	8a 45 ef             	mov    -0x11(%ebp),%al
    131a:	88 02                	mov    %al,(%edx)
    131c:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
    131f:	8a 45 ef             	mov    -0x11(%ebp),%al
    1322:	3c 0a                	cmp    $0xa,%al
    1324:	74 13                	je     1339 <gets+0x5d>
    1326:	8a 45 ef             	mov    -0x11(%ebp),%al
    1329:	3c 0d                	cmp    $0xd,%al
    132b:	74 0c                	je     1339 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    132d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1330:	40                   	inc    %eax
    1331:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1334:	7c b5                	jl     12eb <gets+0xf>
    1336:	eb 01                	jmp    1339 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    1338:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1339:	8b 55 f4             	mov    -0xc(%ebp),%edx
    133c:	8b 45 08             	mov    0x8(%ebp),%eax
    133f:	01 d0                	add    %edx,%eax
    1341:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1344:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1347:	c9                   	leave  
    1348:	c3                   	ret    

00001349 <stat>:

int
stat(char *n, struct stat *st)
{
    1349:	55                   	push   %ebp
    134a:	89 e5                	mov    %esp,%ebp
    134c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    134f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1356:	00 
    1357:	8b 45 08             	mov    0x8(%ebp),%eax
    135a:	89 04 24             	mov    %eax,(%esp)
    135d:	e8 fe 00 00 00       	call   1460 <open>
    1362:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1365:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1369:	79 07                	jns    1372 <stat+0x29>
    return -1;
    136b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1370:	eb 23                	jmp    1395 <stat+0x4c>
  r = fstat(fd, st);
    1372:	8b 45 0c             	mov    0xc(%ebp),%eax
    1375:	89 44 24 04          	mov    %eax,0x4(%esp)
    1379:	8b 45 f4             	mov    -0xc(%ebp),%eax
    137c:	89 04 24             	mov    %eax,(%esp)
    137f:	e8 f4 00 00 00       	call   1478 <fstat>
    1384:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1387:	8b 45 f4             	mov    -0xc(%ebp),%eax
    138a:	89 04 24             	mov    %eax,(%esp)
    138d:	e8 b6 00 00 00       	call   1448 <close>
  return r;
    1392:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1395:	c9                   	leave  
    1396:	c3                   	ret    

00001397 <atoi>:

int
atoi(const char *s)
{
    1397:	55                   	push   %ebp
    1398:	89 e5                	mov    %esp,%ebp
    139a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    139d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    13a4:	eb 21                	jmp    13c7 <atoi+0x30>
    n = n*10 + *s++ - '0';
    13a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
    13a9:	89 d0                	mov    %edx,%eax
    13ab:	c1 e0 02             	shl    $0x2,%eax
    13ae:	01 d0                	add    %edx,%eax
    13b0:	d1 e0                	shl    %eax
    13b2:	89 c2                	mov    %eax,%edx
    13b4:	8b 45 08             	mov    0x8(%ebp),%eax
    13b7:	8a 00                	mov    (%eax),%al
    13b9:	0f be c0             	movsbl %al,%eax
    13bc:	01 d0                	add    %edx,%eax
    13be:	83 e8 30             	sub    $0x30,%eax
    13c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    13c4:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    13c7:	8b 45 08             	mov    0x8(%ebp),%eax
    13ca:	8a 00                	mov    (%eax),%al
    13cc:	3c 2f                	cmp    $0x2f,%al
    13ce:	7e 09                	jle    13d9 <atoi+0x42>
    13d0:	8b 45 08             	mov    0x8(%ebp),%eax
    13d3:	8a 00                	mov    (%eax),%al
    13d5:	3c 39                	cmp    $0x39,%al
    13d7:	7e cd                	jle    13a6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    13d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13dc:	c9                   	leave  
    13dd:	c3                   	ret    

000013de <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    13de:	55                   	push   %ebp
    13df:	89 e5                	mov    %esp,%ebp
    13e1:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    13e4:	8b 45 08             	mov    0x8(%ebp),%eax
    13e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    13ea:	8b 45 0c             	mov    0xc(%ebp),%eax
    13ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    13f0:	eb 10                	jmp    1402 <memmove+0x24>
    *dst++ = *src++;
    13f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13f5:	8a 10                	mov    (%eax),%dl
    13f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13fa:	88 10                	mov    %dl,(%eax)
    13fc:	ff 45 fc             	incl   -0x4(%ebp)
    13ff:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1402:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    1406:	0f 9f c0             	setg   %al
    1409:	ff 4d 10             	decl   0x10(%ebp)
    140c:	84 c0                	test   %al,%al
    140e:	75 e2                	jne    13f2 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1410:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1413:	c9                   	leave  
    1414:	c3                   	ret    
    1415:	66 90                	xchg   %ax,%ax
    1417:	90                   	nop

00001418 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1418:	b8 01 00 00 00       	mov    $0x1,%eax
    141d:	cd 40                	int    $0x40
    141f:	c3                   	ret    

00001420 <exit>:
SYSCALL(exit)
    1420:	b8 02 00 00 00       	mov    $0x2,%eax
    1425:	cd 40                	int    $0x40
    1427:	c3                   	ret    

00001428 <wait>:
SYSCALL(wait)
    1428:	b8 03 00 00 00       	mov    $0x3,%eax
    142d:	cd 40                	int    $0x40
    142f:	c3                   	ret    

00001430 <pipe>:
SYSCALL(pipe)
    1430:	b8 04 00 00 00       	mov    $0x4,%eax
    1435:	cd 40                	int    $0x40
    1437:	c3                   	ret    

00001438 <read>:
SYSCALL(read)
    1438:	b8 05 00 00 00       	mov    $0x5,%eax
    143d:	cd 40                	int    $0x40
    143f:	c3                   	ret    

00001440 <write>:
SYSCALL(write)
    1440:	b8 10 00 00 00       	mov    $0x10,%eax
    1445:	cd 40                	int    $0x40
    1447:	c3                   	ret    

00001448 <close>:
SYSCALL(close)
    1448:	b8 15 00 00 00       	mov    $0x15,%eax
    144d:	cd 40                	int    $0x40
    144f:	c3                   	ret    

00001450 <kill>:
SYSCALL(kill)
    1450:	b8 06 00 00 00       	mov    $0x6,%eax
    1455:	cd 40                	int    $0x40
    1457:	c3                   	ret    

00001458 <exec>:
SYSCALL(exec)
    1458:	b8 07 00 00 00       	mov    $0x7,%eax
    145d:	cd 40                	int    $0x40
    145f:	c3                   	ret    

00001460 <open>:
SYSCALL(open)
    1460:	b8 0f 00 00 00       	mov    $0xf,%eax
    1465:	cd 40                	int    $0x40
    1467:	c3                   	ret    

00001468 <mknod>:
SYSCALL(mknod)
    1468:	b8 11 00 00 00       	mov    $0x11,%eax
    146d:	cd 40                	int    $0x40
    146f:	c3                   	ret    

00001470 <unlink>:
SYSCALL(unlink)
    1470:	b8 12 00 00 00       	mov    $0x12,%eax
    1475:	cd 40                	int    $0x40
    1477:	c3                   	ret    

00001478 <fstat>:
SYSCALL(fstat)
    1478:	b8 08 00 00 00       	mov    $0x8,%eax
    147d:	cd 40                	int    $0x40
    147f:	c3                   	ret    

00001480 <link>:
SYSCALL(link)
    1480:	b8 13 00 00 00       	mov    $0x13,%eax
    1485:	cd 40                	int    $0x40
    1487:	c3                   	ret    

00001488 <mkdir>:
SYSCALL(mkdir)
    1488:	b8 14 00 00 00       	mov    $0x14,%eax
    148d:	cd 40                	int    $0x40
    148f:	c3                   	ret    

00001490 <chdir>:
SYSCALL(chdir)
    1490:	b8 09 00 00 00       	mov    $0x9,%eax
    1495:	cd 40                	int    $0x40
    1497:	c3                   	ret    

00001498 <dup>:
SYSCALL(dup)
    1498:	b8 0a 00 00 00       	mov    $0xa,%eax
    149d:	cd 40                	int    $0x40
    149f:	c3                   	ret    

000014a0 <getpid>:
SYSCALL(getpid)
    14a0:	b8 0b 00 00 00       	mov    $0xb,%eax
    14a5:	cd 40                	int    $0x40
    14a7:	c3                   	ret    

000014a8 <sbrk>:
SYSCALL(sbrk)
    14a8:	b8 0c 00 00 00       	mov    $0xc,%eax
    14ad:	cd 40                	int    $0x40
    14af:	c3                   	ret    

000014b0 <sleep>:
SYSCALL(sleep)
    14b0:	b8 0d 00 00 00       	mov    $0xd,%eax
    14b5:	cd 40                	int    $0x40
    14b7:	c3                   	ret    

000014b8 <uptime>:
SYSCALL(uptime)
    14b8:	b8 0e 00 00 00       	mov    $0xe,%eax
    14bd:	cd 40                	int    $0x40
    14bf:	c3                   	ret    

000014c0 <cowfork>:
SYSCALL(cowfork) //3.4
    14c0:	b8 16 00 00 00       	mov    $0x16,%eax
    14c5:	cd 40                	int    $0x40
    14c7:	c3                   	ret    

000014c8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    14c8:	55                   	push   %ebp
    14c9:	89 e5                	mov    %esp,%ebp
    14cb:	83 ec 28             	sub    $0x28,%esp
    14ce:	8b 45 0c             	mov    0xc(%ebp),%eax
    14d1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    14d4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    14db:	00 
    14dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
    14df:	89 44 24 04          	mov    %eax,0x4(%esp)
    14e3:	8b 45 08             	mov    0x8(%ebp),%eax
    14e6:	89 04 24             	mov    %eax,(%esp)
    14e9:	e8 52 ff ff ff       	call   1440 <write>
}
    14ee:	c9                   	leave  
    14ef:	c3                   	ret    

000014f0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    14f0:	55                   	push   %ebp
    14f1:	89 e5                	mov    %esp,%ebp
    14f3:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    14f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    14fd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1501:	74 17                	je     151a <printint+0x2a>
    1503:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1507:	79 11                	jns    151a <printint+0x2a>
    neg = 1;
    1509:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1510:	8b 45 0c             	mov    0xc(%ebp),%eax
    1513:	f7 d8                	neg    %eax
    1515:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1518:	eb 06                	jmp    1520 <printint+0x30>
  } else {
    x = xx;
    151a:	8b 45 0c             	mov    0xc(%ebp),%eax
    151d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1520:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1527:	8b 4d 10             	mov    0x10(%ebp),%ecx
    152a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    152d:	ba 00 00 00 00       	mov    $0x0,%edx
    1532:	f7 f1                	div    %ecx
    1534:	89 d0                	mov    %edx,%eax
    1536:	8a 80 04 2c 00 00    	mov    0x2c04(%eax),%al
    153c:	8d 4d dc             	lea    -0x24(%ebp),%ecx
    153f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1542:	01 ca                	add    %ecx,%edx
    1544:	88 02                	mov    %al,(%edx)
    1546:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
    1549:	8b 55 10             	mov    0x10(%ebp),%edx
    154c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    154f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1552:	ba 00 00 00 00       	mov    $0x0,%edx
    1557:	f7 75 d4             	divl   -0x2c(%ebp)
    155a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    155d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1561:	75 c4                	jne    1527 <printint+0x37>
  if(neg)
    1563:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1567:	74 2c                	je     1595 <printint+0xa5>
    buf[i++] = '-';
    1569:	8d 55 dc             	lea    -0x24(%ebp),%edx
    156c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    156f:	01 d0                	add    %edx,%eax
    1571:	c6 00 2d             	movb   $0x2d,(%eax)
    1574:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
    1577:	eb 1c                	jmp    1595 <printint+0xa5>
    putc(fd, buf[i]);
    1579:	8d 55 dc             	lea    -0x24(%ebp),%edx
    157c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    157f:	01 d0                	add    %edx,%eax
    1581:	8a 00                	mov    (%eax),%al
    1583:	0f be c0             	movsbl %al,%eax
    1586:	89 44 24 04          	mov    %eax,0x4(%esp)
    158a:	8b 45 08             	mov    0x8(%ebp),%eax
    158d:	89 04 24             	mov    %eax,(%esp)
    1590:	e8 33 ff ff ff       	call   14c8 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1595:	ff 4d f4             	decl   -0xc(%ebp)
    1598:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    159c:	79 db                	jns    1579 <printint+0x89>
    putc(fd, buf[i]);
}
    159e:	c9                   	leave  
    159f:	c3                   	ret    

000015a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    15a0:	55                   	push   %ebp
    15a1:	89 e5                	mov    %esp,%ebp
    15a3:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    15a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    15ad:	8d 45 0c             	lea    0xc(%ebp),%eax
    15b0:	83 c0 04             	add    $0x4,%eax
    15b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    15b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    15bd:	e9 78 01 00 00       	jmp    173a <printf+0x19a>
    c = fmt[i] & 0xff;
    15c2:	8b 55 0c             	mov    0xc(%ebp),%edx
    15c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15c8:	01 d0                	add    %edx,%eax
    15ca:	8a 00                	mov    (%eax),%al
    15cc:	0f be c0             	movsbl %al,%eax
    15cf:	25 ff 00 00 00       	and    $0xff,%eax
    15d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    15d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    15db:	75 2c                	jne    1609 <printf+0x69>
      if(c == '%'){
    15dd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15e1:	75 0c                	jne    15ef <printf+0x4f>
        state = '%';
    15e3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    15ea:	e9 48 01 00 00       	jmp    1737 <printf+0x197>
      } else {
        putc(fd, c);
    15ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15f2:	0f be c0             	movsbl %al,%eax
    15f5:	89 44 24 04          	mov    %eax,0x4(%esp)
    15f9:	8b 45 08             	mov    0x8(%ebp),%eax
    15fc:	89 04 24             	mov    %eax,(%esp)
    15ff:	e8 c4 fe ff ff       	call   14c8 <putc>
    1604:	e9 2e 01 00 00       	jmp    1737 <printf+0x197>
      }
    } else if(state == '%'){
    1609:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    160d:	0f 85 24 01 00 00    	jne    1737 <printf+0x197>
      if(c == 'd'){
    1613:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1617:	75 2d                	jne    1646 <printf+0xa6>
        printint(fd, *ap, 10, 1);
    1619:	8b 45 e8             	mov    -0x18(%ebp),%eax
    161c:	8b 00                	mov    (%eax),%eax
    161e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1625:	00 
    1626:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    162d:	00 
    162e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1632:	8b 45 08             	mov    0x8(%ebp),%eax
    1635:	89 04 24             	mov    %eax,(%esp)
    1638:	e8 b3 fe ff ff       	call   14f0 <printint>
        ap++;
    163d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1641:	e9 ea 00 00 00       	jmp    1730 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
    1646:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    164a:	74 06                	je     1652 <printf+0xb2>
    164c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1650:	75 2d                	jne    167f <printf+0xdf>
        printint(fd, *ap, 16, 0);
    1652:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1655:	8b 00                	mov    (%eax),%eax
    1657:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    165e:	00 
    165f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1666:	00 
    1667:	89 44 24 04          	mov    %eax,0x4(%esp)
    166b:	8b 45 08             	mov    0x8(%ebp),%eax
    166e:	89 04 24             	mov    %eax,(%esp)
    1671:	e8 7a fe ff ff       	call   14f0 <printint>
        ap++;
    1676:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    167a:	e9 b1 00 00 00       	jmp    1730 <printf+0x190>
      } else if(c == 's'){
    167f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1683:	75 43                	jne    16c8 <printf+0x128>
        s = (char*)*ap;
    1685:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1688:	8b 00                	mov    (%eax),%eax
    168a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    168d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1691:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1695:	75 25                	jne    16bc <printf+0x11c>
          s = "(null)";
    1697:	c7 45 f4 a0 19 00 00 	movl   $0x19a0,-0xc(%ebp)
        while(*s != 0){
    169e:	eb 1c                	jmp    16bc <printf+0x11c>
          putc(fd, *s);
    16a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16a3:	8a 00                	mov    (%eax),%al
    16a5:	0f be c0             	movsbl %al,%eax
    16a8:	89 44 24 04          	mov    %eax,0x4(%esp)
    16ac:	8b 45 08             	mov    0x8(%ebp),%eax
    16af:	89 04 24             	mov    %eax,(%esp)
    16b2:	e8 11 fe ff ff       	call   14c8 <putc>
          s++;
    16b7:	ff 45 f4             	incl   -0xc(%ebp)
    16ba:	eb 01                	jmp    16bd <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    16bc:	90                   	nop
    16bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16c0:	8a 00                	mov    (%eax),%al
    16c2:	84 c0                	test   %al,%al
    16c4:	75 da                	jne    16a0 <printf+0x100>
    16c6:	eb 68                	jmp    1730 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    16c8:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    16cc:	75 1d                	jne    16eb <printf+0x14b>
        putc(fd, *ap);
    16ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16d1:	8b 00                	mov    (%eax),%eax
    16d3:	0f be c0             	movsbl %al,%eax
    16d6:	89 44 24 04          	mov    %eax,0x4(%esp)
    16da:	8b 45 08             	mov    0x8(%ebp),%eax
    16dd:	89 04 24             	mov    %eax,(%esp)
    16e0:	e8 e3 fd ff ff       	call   14c8 <putc>
        ap++;
    16e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    16e9:	eb 45                	jmp    1730 <printf+0x190>
      } else if(c == '%'){
    16eb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    16ef:	75 17                	jne    1708 <printf+0x168>
        putc(fd, c);
    16f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16f4:	0f be c0             	movsbl %al,%eax
    16f7:	89 44 24 04          	mov    %eax,0x4(%esp)
    16fb:	8b 45 08             	mov    0x8(%ebp),%eax
    16fe:	89 04 24             	mov    %eax,(%esp)
    1701:	e8 c2 fd ff ff       	call   14c8 <putc>
    1706:	eb 28                	jmp    1730 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1708:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    170f:	00 
    1710:	8b 45 08             	mov    0x8(%ebp),%eax
    1713:	89 04 24             	mov    %eax,(%esp)
    1716:	e8 ad fd ff ff       	call   14c8 <putc>
        putc(fd, c);
    171b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    171e:	0f be c0             	movsbl %al,%eax
    1721:	89 44 24 04          	mov    %eax,0x4(%esp)
    1725:	8b 45 08             	mov    0x8(%ebp),%eax
    1728:	89 04 24             	mov    %eax,(%esp)
    172b:	e8 98 fd ff ff       	call   14c8 <putc>
      }
      state = 0;
    1730:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1737:	ff 45 f0             	incl   -0x10(%ebp)
    173a:	8b 55 0c             	mov    0xc(%ebp),%edx
    173d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1740:	01 d0                	add    %edx,%eax
    1742:	8a 00                	mov    (%eax),%al
    1744:	84 c0                	test   %al,%al
    1746:	0f 85 76 fe ff ff    	jne    15c2 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    174c:	c9                   	leave  
    174d:	c3                   	ret    
    174e:	66 90                	xchg   %ax,%ax

00001750 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1750:	55                   	push   %ebp
    1751:	89 e5                	mov    %esp,%ebp
    1753:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1756:	8b 45 08             	mov    0x8(%ebp),%eax
    1759:	83 e8 08             	sub    $0x8,%eax
    175c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    175f:	a1 28 2c 00 00       	mov    0x2c28,%eax
    1764:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1767:	eb 24                	jmp    178d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1769:	8b 45 fc             	mov    -0x4(%ebp),%eax
    176c:	8b 00                	mov    (%eax),%eax
    176e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1771:	77 12                	ja     1785 <free+0x35>
    1773:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1776:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1779:	77 24                	ja     179f <free+0x4f>
    177b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    177e:	8b 00                	mov    (%eax),%eax
    1780:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1783:	77 1a                	ja     179f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1785:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1788:	8b 00                	mov    (%eax),%eax
    178a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    178d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1790:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1793:	76 d4                	jbe    1769 <free+0x19>
    1795:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1798:	8b 00                	mov    (%eax),%eax
    179a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    179d:	76 ca                	jbe    1769 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    179f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17a2:	8b 40 04             	mov    0x4(%eax),%eax
    17a5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    17ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17af:	01 c2                	add    %eax,%edx
    17b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17b4:	8b 00                	mov    (%eax),%eax
    17b6:	39 c2                	cmp    %eax,%edx
    17b8:	75 24                	jne    17de <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    17ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17bd:	8b 50 04             	mov    0x4(%eax),%edx
    17c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17c3:	8b 00                	mov    (%eax),%eax
    17c5:	8b 40 04             	mov    0x4(%eax),%eax
    17c8:	01 c2                	add    %eax,%edx
    17ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17cd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    17d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17d3:	8b 00                	mov    (%eax),%eax
    17d5:	8b 10                	mov    (%eax),%edx
    17d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17da:	89 10                	mov    %edx,(%eax)
    17dc:	eb 0a                	jmp    17e8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    17de:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17e1:	8b 10                	mov    (%eax),%edx
    17e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17e6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    17e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17eb:	8b 40 04             	mov    0x4(%eax),%eax
    17ee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    17f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17f8:	01 d0                	add    %edx,%eax
    17fa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17fd:	75 20                	jne    181f <free+0xcf>
    p->s.size += bp->s.size;
    17ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1802:	8b 50 04             	mov    0x4(%eax),%edx
    1805:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1808:	8b 40 04             	mov    0x4(%eax),%eax
    180b:	01 c2                	add    %eax,%edx
    180d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1810:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1813:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1816:	8b 10                	mov    (%eax),%edx
    1818:	8b 45 fc             	mov    -0x4(%ebp),%eax
    181b:	89 10                	mov    %edx,(%eax)
    181d:	eb 08                	jmp    1827 <free+0xd7>
  } else
    p->s.ptr = bp;
    181f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1822:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1825:	89 10                	mov    %edx,(%eax)
  freep = p;
    1827:	8b 45 fc             	mov    -0x4(%ebp),%eax
    182a:	a3 28 2c 00 00       	mov    %eax,0x2c28
}
    182f:	c9                   	leave  
    1830:	c3                   	ret    

00001831 <morecore>:

static Header*
morecore(uint nu)
{
    1831:	55                   	push   %ebp
    1832:	89 e5                	mov    %esp,%ebp
    1834:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1837:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    183e:	77 07                	ja     1847 <morecore+0x16>
    nu = 4096;
    1840:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1847:	8b 45 08             	mov    0x8(%ebp),%eax
    184a:	c1 e0 03             	shl    $0x3,%eax
    184d:	89 04 24             	mov    %eax,(%esp)
    1850:	e8 53 fc ff ff       	call   14a8 <sbrk>
    1855:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1858:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    185c:	75 07                	jne    1865 <morecore+0x34>
    return 0;
    185e:	b8 00 00 00 00       	mov    $0x0,%eax
    1863:	eb 22                	jmp    1887 <morecore+0x56>
  hp = (Header*)p;
    1865:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1868:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    186b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    186e:	8b 55 08             	mov    0x8(%ebp),%edx
    1871:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1874:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1877:	83 c0 08             	add    $0x8,%eax
    187a:	89 04 24             	mov    %eax,(%esp)
    187d:	e8 ce fe ff ff       	call   1750 <free>
  return freep;
    1882:	a1 28 2c 00 00       	mov    0x2c28,%eax
}
    1887:	c9                   	leave  
    1888:	c3                   	ret    

00001889 <malloc>:

void*
malloc(uint nbytes)
{
    1889:	55                   	push   %ebp
    188a:	89 e5                	mov    %esp,%ebp
    188c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    188f:	8b 45 08             	mov    0x8(%ebp),%eax
    1892:	83 c0 07             	add    $0x7,%eax
    1895:	c1 e8 03             	shr    $0x3,%eax
    1898:	40                   	inc    %eax
    1899:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    189c:	a1 28 2c 00 00       	mov    0x2c28,%eax
    18a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    18a8:	75 23                	jne    18cd <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    18aa:	c7 45 f0 20 2c 00 00 	movl   $0x2c20,-0x10(%ebp)
    18b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18b4:	a3 28 2c 00 00       	mov    %eax,0x2c28
    18b9:	a1 28 2c 00 00       	mov    0x2c28,%eax
    18be:	a3 20 2c 00 00       	mov    %eax,0x2c20
    base.s.size = 0;
    18c3:	c7 05 24 2c 00 00 00 	movl   $0x0,0x2c24
    18ca:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18d0:	8b 00                	mov    (%eax),%eax
    18d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    18d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18d8:	8b 40 04             	mov    0x4(%eax),%eax
    18db:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    18de:	72 4d                	jb     192d <malloc+0xa4>
      if(p->s.size == nunits)
    18e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18e3:	8b 40 04             	mov    0x4(%eax),%eax
    18e6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    18e9:	75 0c                	jne    18f7 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    18eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18ee:	8b 10                	mov    (%eax),%edx
    18f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18f3:	89 10                	mov    %edx,(%eax)
    18f5:	eb 26                	jmp    191d <malloc+0x94>
      else {
        p->s.size -= nunits;
    18f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18fa:	8b 40 04             	mov    0x4(%eax),%eax
    18fd:	89 c2                	mov    %eax,%edx
    18ff:	2b 55 ec             	sub    -0x14(%ebp),%edx
    1902:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1905:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1908:	8b 45 f4             	mov    -0xc(%ebp),%eax
    190b:	8b 40 04             	mov    0x4(%eax),%eax
    190e:	c1 e0 03             	shl    $0x3,%eax
    1911:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1914:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1917:	8b 55 ec             	mov    -0x14(%ebp),%edx
    191a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    191d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1920:	a3 28 2c 00 00       	mov    %eax,0x2c28
      return (void*)(p + 1);
    1925:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1928:	83 c0 08             	add    $0x8,%eax
    192b:	eb 38                	jmp    1965 <malloc+0xdc>
    }
    if(p == freep)
    192d:	a1 28 2c 00 00       	mov    0x2c28,%eax
    1932:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1935:	75 1b                	jne    1952 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    1937:	8b 45 ec             	mov    -0x14(%ebp),%eax
    193a:	89 04 24             	mov    %eax,(%esp)
    193d:	e8 ef fe ff ff       	call   1831 <morecore>
    1942:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1945:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1949:	75 07                	jne    1952 <malloc+0xc9>
        return 0;
    194b:	b8 00 00 00 00       	mov    $0x0,%eax
    1950:	eb 13                	jmp    1965 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1952:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1955:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1958:	8b 45 f4             	mov    -0xc(%ebp),%eax
    195b:	8b 00                	mov    (%eax),%eax
    195d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1960:	e9 70 ff ff ff       	jmp    18d5 <malloc+0x4c>
}
    1965:	c9                   	leave  
    1966:	c3                   	ret    
