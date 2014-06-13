
_grep:     file format elf32-i386


Disassembly of section .text:

00001000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
    1006:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    100d:	e9 bb 00 00 00       	jmp    10cd <grep+0xcd>
    m += n;
    1012:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1015:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
    1018:	c7 45 f0 40 20 00 00 	movl   $0x2040,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
    101f:	eb 4f                	jmp    1070 <grep+0x70>
      *q = 0;
    1021:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1024:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
    1027:	8b 45 f0             	mov    -0x10(%ebp),%eax
    102a:	89 44 24 04          	mov    %eax,0x4(%esp)
    102e:	8b 45 08             	mov    0x8(%ebp),%eax
    1031:	89 04 24             	mov    %eax,(%esp)
    1034:	e8 bd 01 00 00       	call   11f6 <match>
    1039:	85 c0                	test   %eax,%eax
    103b:	74 2c                	je     1069 <grep+0x69>
        *q = '\n';
    103d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1040:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
    1043:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1046:	40                   	inc    %eax
    1047:	89 c2                	mov    %eax,%edx
    1049:	8b 45 f0             	mov    -0x10(%ebp),%eax
    104c:	89 d1                	mov    %edx,%ecx
    104e:	29 c1                	sub    %eax,%ecx
    1050:	89 c8                	mov    %ecx,%eax
    1052:	89 44 24 08          	mov    %eax,0x8(%esp)
    1056:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1059:	89 44 24 04          	mov    %eax,0x4(%esp)
    105d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1064:	e8 4b 05 00 00       	call   15b4 <write>
      }
      p = q+1;
    1069:	8b 45 e8             	mov    -0x18(%ebp),%eax
    106c:	40                   	inc    %eax
    106d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    m += n;
    p = buf;
    while((q = strchr(p, '\n')) != 0){
    1070:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
    1077:	00 
    1078:	8b 45 f0             	mov    -0x10(%ebp),%eax
    107b:	89 04 24             	mov    %eax,(%esp)
    107e:	e8 9d 03 00 00       	call   1420 <strchr>
    1083:	89 45 e8             	mov    %eax,-0x18(%ebp)
    1086:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    108a:	75 95                	jne    1021 <grep+0x21>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
    108c:	81 7d f0 40 20 00 00 	cmpl   $0x2040,-0x10(%ebp)
    1093:	75 07                	jne    109c <grep+0x9c>
      m = 0;
    1095:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
    109c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10a0:	7e 2b                	jle    10cd <grep+0xcd>
      m -= p - buf;
    10a2:	ba 40 20 00 00       	mov    $0x2040,%edx
    10a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10aa:	89 d1                	mov    %edx,%ecx
    10ac:	29 c1                	sub    %eax,%ecx
    10ae:	89 c8                	mov    %ecx,%eax
    10b0:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
    10b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10b6:	89 44 24 08          	mov    %eax,0x8(%esp)
    10ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10bd:	89 44 24 04          	mov    %eax,0x4(%esp)
    10c1:	c7 04 24 40 20 00 00 	movl   $0x2040,(%esp)
    10c8:	e8 85 04 00 00       	call   1552 <memmove>
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
    10cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10d0:	ba 00 04 00 00       	mov    $0x400,%edx
    10d5:	89 d1                	mov    %edx,%ecx
    10d7:	29 c1                	sub    %eax,%ecx
    10d9:	89 c8                	mov    %ecx,%eax
    10db:	8b 55 f4             	mov    -0xc(%ebp),%edx
    10de:	81 c2 40 20 00 00    	add    $0x2040,%edx
    10e4:	89 44 24 08          	mov    %eax,0x8(%esp)
    10e8:	89 54 24 04          	mov    %edx,0x4(%esp)
    10ec:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ef:	89 04 24             	mov    %eax,(%esp)
    10f2:	e8 b5 04 00 00       	call   15ac <read>
    10f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    10fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    10fe:	0f 8f 0e ff ff ff    	jg     1012 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
    1104:	c9                   	leave  
    1105:	c3                   	ret    

00001106 <main>:

int
main(int argc, char *argv[])
{
    1106:	55                   	push   %ebp
    1107:	89 e5                	mov    %esp,%ebp
    1109:	83 e4 f0             	and    $0xfffffff0,%esp
    110c:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
    110f:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    1113:	7f 19                	jg     112e <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
    1115:	c7 44 24 04 dc 1a 00 	movl   $0x1adc,0x4(%esp)
    111c:	00 
    111d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1124:	e8 eb 05 00 00       	call   1714 <printf>
    exit();
    1129:	e8 66 04 00 00       	call   1594 <exit>
  }
  pattern = argv[1];
    112e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1131:	8b 40 04             	mov    0x4(%eax),%eax
    1134:	89 44 24 18          	mov    %eax,0x18(%esp)
  
  if(argc <= 2){
    1138:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
    113c:	7f 19                	jg     1157 <main+0x51>
    grep(pattern, 0);
    113e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1145:	00 
    1146:	8b 44 24 18          	mov    0x18(%esp),%eax
    114a:	89 04 24             	mov    %eax,(%esp)
    114d:	e8 ae fe ff ff       	call   1000 <grep>
    exit();
    1152:	e8 3d 04 00 00       	call   1594 <exit>
  }

  for(i = 2; i < argc; i++){
    1157:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
    115e:	00 
    115f:	e9 80 00 00 00       	jmp    11e4 <main+0xde>
    if((fd = open(argv[i], 0)) < 0){
    1164:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1168:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    116f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1172:	01 d0                	add    %edx,%eax
    1174:	8b 00                	mov    (%eax),%eax
    1176:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    117d:	00 
    117e:	89 04 24             	mov    %eax,(%esp)
    1181:	e8 4e 04 00 00       	call   15d4 <open>
    1186:	89 44 24 14          	mov    %eax,0x14(%esp)
    118a:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
    118f:	79 2f                	jns    11c0 <main+0xba>
      printf(1, "grep: cannot open %s\n", argv[i]);
    1191:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1195:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    119c:	8b 45 0c             	mov    0xc(%ebp),%eax
    119f:	01 d0                	add    %edx,%eax
    11a1:	8b 00                	mov    (%eax),%eax
    11a3:	89 44 24 08          	mov    %eax,0x8(%esp)
    11a7:	c7 44 24 04 fc 1a 00 	movl   $0x1afc,0x4(%esp)
    11ae:	00 
    11af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11b6:	e8 59 05 00 00       	call   1714 <printf>
      exit();
    11bb:	e8 d4 03 00 00       	call   1594 <exit>
    }
    grep(pattern, fd);
    11c0:	8b 44 24 14          	mov    0x14(%esp),%eax
    11c4:	89 44 24 04          	mov    %eax,0x4(%esp)
    11c8:	8b 44 24 18          	mov    0x18(%esp),%eax
    11cc:	89 04 24             	mov    %eax,(%esp)
    11cf:	e8 2c fe ff ff       	call   1000 <grep>
    close(fd);
    11d4:	8b 44 24 14          	mov    0x14(%esp),%eax
    11d8:	89 04 24             	mov    %eax,(%esp)
    11db:	e8 dc 03 00 00       	call   15bc <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
    11e0:	ff 44 24 1c          	incl   0x1c(%esp)
    11e4:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    11e8:	3b 45 08             	cmp    0x8(%ebp),%eax
    11eb:	0f 8c 73 ff ff ff    	jl     1164 <main+0x5e>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
    11f1:	e8 9e 03 00 00       	call   1594 <exit>

000011f6 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
    11f6:	55                   	push   %ebp
    11f7:	89 e5                	mov    %esp,%ebp
    11f9:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
    11fc:	8b 45 08             	mov    0x8(%ebp),%eax
    11ff:	8a 00                	mov    (%eax),%al
    1201:	3c 5e                	cmp    $0x5e,%al
    1203:	75 17                	jne    121c <match+0x26>
    return matchhere(re+1, text);
    1205:	8b 45 08             	mov    0x8(%ebp),%eax
    1208:	8d 50 01             	lea    0x1(%eax),%edx
    120b:	8b 45 0c             	mov    0xc(%ebp),%eax
    120e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1212:	89 14 24             	mov    %edx,(%esp)
    1215:	e8 37 00 00 00       	call   1251 <matchhere>
    121a:	eb 33                	jmp    124f <match+0x59>
  do{  // must look at empty string
    if(matchhere(re, text))
    121c:	8b 45 0c             	mov    0xc(%ebp),%eax
    121f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1223:	8b 45 08             	mov    0x8(%ebp),%eax
    1226:	89 04 24             	mov    %eax,(%esp)
    1229:	e8 23 00 00 00       	call   1251 <matchhere>
    122e:	85 c0                	test   %eax,%eax
    1230:	74 07                	je     1239 <match+0x43>
      return 1;
    1232:	b8 01 00 00 00       	mov    $0x1,%eax
    1237:	eb 16                	jmp    124f <match+0x59>
  }while(*text++ != '\0');
    1239:	8b 45 0c             	mov    0xc(%ebp),%eax
    123c:	8a 00                	mov    (%eax),%al
    123e:	84 c0                	test   %al,%al
    1240:	0f 95 c0             	setne  %al
    1243:	ff 45 0c             	incl   0xc(%ebp)
    1246:	84 c0                	test   %al,%al
    1248:	75 d2                	jne    121c <match+0x26>
  return 0;
    124a:	b8 00 00 00 00       	mov    $0x0,%eax
}
    124f:	c9                   	leave  
    1250:	c3                   	ret    

00001251 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
    1251:	55                   	push   %ebp
    1252:	89 e5                	mov    %esp,%ebp
    1254:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
    1257:	8b 45 08             	mov    0x8(%ebp),%eax
    125a:	8a 00                	mov    (%eax),%al
    125c:	84 c0                	test   %al,%al
    125e:	75 0a                	jne    126a <matchhere+0x19>
    return 1;
    1260:	b8 01 00 00 00       	mov    $0x1,%eax
    1265:	e9 8c 00 00 00       	jmp    12f6 <matchhere+0xa5>
  if(re[1] == '*')
    126a:	8b 45 08             	mov    0x8(%ebp),%eax
    126d:	40                   	inc    %eax
    126e:	8a 00                	mov    (%eax),%al
    1270:	3c 2a                	cmp    $0x2a,%al
    1272:	75 23                	jne    1297 <matchhere+0x46>
    return matchstar(re[0], re+2, text);
    1274:	8b 45 08             	mov    0x8(%ebp),%eax
    1277:	8d 48 02             	lea    0x2(%eax),%ecx
    127a:	8b 45 08             	mov    0x8(%ebp),%eax
    127d:	8a 00                	mov    (%eax),%al
    127f:	0f be c0             	movsbl %al,%eax
    1282:	8b 55 0c             	mov    0xc(%ebp),%edx
    1285:	89 54 24 08          	mov    %edx,0x8(%esp)
    1289:	89 4c 24 04          	mov    %ecx,0x4(%esp)
    128d:	89 04 24             	mov    %eax,(%esp)
    1290:	e8 63 00 00 00       	call   12f8 <matchstar>
    1295:	eb 5f                	jmp    12f6 <matchhere+0xa5>
  if(re[0] == '$' && re[1] == '\0')
    1297:	8b 45 08             	mov    0x8(%ebp),%eax
    129a:	8a 00                	mov    (%eax),%al
    129c:	3c 24                	cmp    $0x24,%al
    129e:	75 19                	jne    12b9 <matchhere+0x68>
    12a0:	8b 45 08             	mov    0x8(%ebp),%eax
    12a3:	40                   	inc    %eax
    12a4:	8a 00                	mov    (%eax),%al
    12a6:	84 c0                	test   %al,%al
    12a8:	75 0f                	jne    12b9 <matchhere+0x68>
    return *text == '\0';
    12aa:	8b 45 0c             	mov    0xc(%ebp),%eax
    12ad:	8a 00                	mov    (%eax),%al
    12af:	84 c0                	test   %al,%al
    12b1:	0f 94 c0             	sete   %al
    12b4:	0f b6 c0             	movzbl %al,%eax
    12b7:	eb 3d                	jmp    12f6 <matchhere+0xa5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    12b9:	8b 45 0c             	mov    0xc(%ebp),%eax
    12bc:	8a 00                	mov    (%eax),%al
    12be:	84 c0                	test   %al,%al
    12c0:	74 2f                	je     12f1 <matchhere+0xa0>
    12c2:	8b 45 08             	mov    0x8(%ebp),%eax
    12c5:	8a 00                	mov    (%eax),%al
    12c7:	3c 2e                	cmp    $0x2e,%al
    12c9:	74 0e                	je     12d9 <matchhere+0x88>
    12cb:	8b 45 08             	mov    0x8(%ebp),%eax
    12ce:	8a 10                	mov    (%eax),%dl
    12d0:	8b 45 0c             	mov    0xc(%ebp),%eax
    12d3:	8a 00                	mov    (%eax),%al
    12d5:	38 c2                	cmp    %al,%dl
    12d7:	75 18                	jne    12f1 <matchhere+0xa0>
    return matchhere(re+1, text+1);
    12d9:	8b 45 0c             	mov    0xc(%ebp),%eax
    12dc:	8d 50 01             	lea    0x1(%eax),%edx
    12df:	8b 45 08             	mov    0x8(%ebp),%eax
    12e2:	40                   	inc    %eax
    12e3:	89 54 24 04          	mov    %edx,0x4(%esp)
    12e7:	89 04 24             	mov    %eax,(%esp)
    12ea:	e8 62 ff ff ff       	call   1251 <matchhere>
    12ef:	eb 05                	jmp    12f6 <matchhere+0xa5>
  return 0;
    12f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
    12f6:	c9                   	leave  
    12f7:	c3                   	ret    

000012f8 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
    12f8:	55                   	push   %ebp
    12f9:	89 e5                	mov    %esp,%ebp
    12fb:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
    12fe:	8b 45 10             	mov    0x10(%ebp),%eax
    1301:	89 44 24 04          	mov    %eax,0x4(%esp)
    1305:	8b 45 0c             	mov    0xc(%ebp),%eax
    1308:	89 04 24             	mov    %eax,(%esp)
    130b:	e8 41 ff ff ff       	call   1251 <matchhere>
    1310:	85 c0                	test   %eax,%eax
    1312:	74 07                	je     131b <matchstar+0x23>
      return 1;
    1314:	b8 01 00 00 00       	mov    $0x1,%eax
    1319:	eb 29                	jmp    1344 <matchstar+0x4c>
  }while(*text!='\0' && (*text++==c || c=='.'));
    131b:	8b 45 10             	mov    0x10(%ebp),%eax
    131e:	8a 00                	mov    (%eax),%al
    1320:	84 c0                	test   %al,%al
    1322:	74 1b                	je     133f <matchstar+0x47>
    1324:	8b 45 10             	mov    0x10(%ebp),%eax
    1327:	8a 00                	mov    (%eax),%al
    1329:	0f be c0             	movsbl %al,%eax
    132c:	3b 45 08             	cmp    0x8(%ebp),%eax
    132f:	0f 94 c0             	sete   %al
    1332:	ff 45 10             	incl   0x10(%ebp)
    1335:	84 c0                	test   %al,%al
    1337:	75 c5                	jne    12fe <matchstar+0x6>
    1339:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
    133d:	74 bf                	je     12fe <matchstar+0x6>
  return 0;
    133f:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1344:	c9                   	leave  
    1345:	c3                   	ret    
    1346:	66 90                	xchg   %ax,%ax

00001348 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1348:	55                   	push   %ebp
    1349:	89 e5                	mov    %esp,%ebp
    134b:	57                   	push   %edi
    134c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    134d:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1350:	8b 55 10             	mov    0x10(%ebp),%edx
    1353:	8b 45 0c             	mov    0xc(%ebp),%eax
    1356:	89 cb                	mov    %ecx,%ebx
    1358:	89 df                	mov    %ebx,%edi
    135a:	89 d1                	mov    %edx,%ecx
    135c:	fc                   	cld    
    135d:	f3 aa                	rep stos %al,%es:(%edi)
    135f:	89 ca                	mov    %ecx,%edx
    1361:	89 fb                	mov    %edi,%ebx
    1363:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1366:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1369:	5b                   	pop    %ebx
    136a:	5f                   	pop    %edi
    136b:	5d                   	pop    %ebp
    136c:	c3                   	ret    

0000136d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    136d:	55                   	push   %ebp
    136e:	89 e5                	mov    %esp,%ebp
    1370:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1373:	8b 45 08             	mov    0x8(%ebp),%eax
    1376:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1379:	90                   	nop
    137a:	8b 45 0c             	mov    0xc(%ebp),%eax
    137d:	8a 10                	mov    (%eax),%dl
    137f:	8b 45 08             	mov    0x8(%ebp),%eax
    1382:	88 10                	mov    %dl,(%eax)
    1384:	8b 45 08             	mov    0x8(%ebp),%eax
    1387:	8a 00                	mov    (%eax),%al
    1389:	84 c0                	test   %al,%al
    138b:	0f 95 c0             	setne  %al
    138e:	ff 45 08             	incl   0x8(%ebp)
    1391:	ff 45 0c             	incl   0xc(%ebp)
    1394:	84 c0                	test   %al,%al
    1396:	75 e2                	jne    137a <strcpy+0xd>
    ;
  return os;
    1398:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    139b:	c9                   	leave  
    139c:	c3                   	ret    

0000139d <strcmp>:

int
strcmp(const char *p, const char *q)
{
    139d:	55                   	push   %ebp
    139e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    13a0:	eb 06                	jmp    13a8 <strcmp+0xb>
    p++, q++;
    13a2:	ff 45 08             	incl   0x8(%ebp)
    13a5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    13a8:	8b 45 08             	mov    0x8(%ebp),%eax
    13ab:	8a 00                	mov    (%eax),%al
    13ad:	84 c0                	test   %al,%al
    13af:	74 0e                	je     13bf <strcmp+0x22>
    13b1:	8b 45 08             	mov    0x8(%ebp),%eax
    13b4:	8a 10                	mov    (%eax),%dl
    13b6:	8b 45 0c             	mov    0xc(%ebp),%eax
    13b9:	8a 00                	mov    (%eax),%al
    13bb:	38 c2                	cmp    %al,%dl
    13bd:	74 e3                	je     13a2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    13bf:	8b 45 08             	mov    0x8(%ebp),%eax
    13c2:	8a 00                	mov    (%eax),%al
    13c4:	0f b6 d0             	movzbl %al,%edx
    13c7:	8b 45 0c             	mov    0xc(%ebp),%eax
    13ca:	8a 00                	mov    (%eax),%al
    13cc:	0f b6 c0             	movzbl %al,%eax
    13cf:	89 d1                	mov    %edx,%ecx
    13d1:	29 c1                	sub    %eax,%ecx
    13d3:	89 c8                	mov    %ecx,%eax
}
    13d5:	5d                   	pop    %ebp
    13d6:	c3                   	ret    

000013d7 <strlen>:

uint
strlen(char *s)
{
    13d7:	55                   	push   %ebp
    13d8:	89 e5                	mov    %esp,%ebp
    13da:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    13dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    13e4:	eb 03                	jmp    13e9 <strlen+0x12>
    13e6:	ff 45 fc             	incl   -0x4(%ebp)
    13e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
    13ec:	8b 45 08             	mov    0x8(%ebp),%eax
    13ef:	01 d0                	add    %edx,%eax
    13f1:	8a 00                	mov    (%eax),%al
    13f3:	84 c0                	test   %al,%al
    13f5:	75 ef                	jne    13e6 <strlen+0xf>
    ;
  return n;
    13f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13fa:	c9                   	leave  
    13fb:	c3                   	ret    

000013fc <memset>:

void*
memset(void *dst, int c, uint n)
{
    13fc:	55                   	push   %ebp
    13fd:	89 e5                	mov    %esp,%ebp
    13ff:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1402:	8b 45 10             	mov    0x10(%ebp),%eax
    1405:	89 44 24 08          	mov    %eax,0x8(%esp)
    1409:	8b 45 0c             	mov    0xc(%ebp),%eax
    140c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1410:	8b 45 08             	mov    0x8(%ebp),%eax
    1413:	89 04 24             	mov    %eax,(%esp)
    1416:	e8 2d ff ff ff       	call   1348 <stosb>
  return dst;
    141b:	8b 45 08             	mov    0x8(%ebp),%eax
}
    141e:	c9                   	leave  
    141f:	c3                   	ret    

00001420 <strchr>:

char*
strchr(const char *s, char c)
{
    1420:	55                   	push   %ebp
    1421:	89 e5                	mov    %esp,%ebp
    1423:	83 ec 04             	sub    $0x4,%esp
    1426:	8b 45 0c             	mov    0xc(%ebp),%eax
    1429:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    142c:	eb 12                	jmp    1440 <strchr+0x20>
    if(*s == c)
    142e:	8b 45 08             	mov    0x8(%ebp),%eax
    1431:	8a 00                	mov    (%eax),%al
    1433:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1436:	75 05                	jne    143d <strchr+0x1d>
      return (char*)s;
    1438:	8b 45 08             	mov    0x8(%ebp),%eax
    143b:	eb 11                	jmp    144e <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    143d:	ff 45 08             	incl   0x8(%ebp)
    1440:	8b 45 08             	mov    0x8(%ebp),%eax
    1443:	8a 00                	mov    (%eax),%al
    1445:	84 c0                	test   %al,%al
    1447:	75 e5                	jne    142e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1449:	b8 00 00 00 00       	mov    $0x0,%eax
}
    144e:	c9                   	leave  
    144f:	c3                   	ret    

00001450 <gets>:

char*
gets(char *buf, int max)
{
    1450:	55                   	push   %ebp
    1451:	89 e5                	mov    %esp,%ebp
    1453:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1456:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    145d:	eb 42                	jmp    14a1 <gets+0x51>
    cc = read(0, &c, 1);
    145f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1466:	00 
    1467:	8d 45 ef             	lea    -0x11(%ebp),%eax
    146a:	89 44 24 04          	mov    %eax,0x4(%esp)
    146e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1475:	e8 32 01 00 00       	call   15ac <read>
    147a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    147d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1481:	7e 29                	jle    14ac <gets+0x5c>
      break;
    buf[i++] = c;
    1483:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1486:	8b 45 08             	mov    0x8(%ebp),%eax
    1489:	01 c2                	add    %eax,%edx
    148b:	8a 45 ef             	mov    -0x11(%ebp),%al
    148e:	88 02                	mov    %al,(%edx)
    1490:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
    1493:	8a 45 ef             	mov    -0x11(%ebp),%al
    1496:	3c 0a                	cmp    $0xa,%al
    1498:	74 13                	je     14ad <gets+0x5d>
    149a:	8a 45 ef             	mov    -0x11(%ebp),%al
    149d:	3c 0d                	cmp    $0xd,%al
    149f:	74 0c                	je     14ad <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    14a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14a4:	40                   	inc    %eax
    14a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
    14a8:	7c b5                	jl     145f <gets+0xf>
    14aa:	eb 01                	jmp    14ad <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    14ac:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    14ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14b0:	8b 45 08             	mov    0x8(%ebp),%eax
    14b3:	01 d0                	add    %edx,%eax
    14b5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    14b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
    14bb:	c9                   	leave  
    14bc:	c3                   	ret    

000014bd <stat>:

int
stat(char *n, struct stat *st)
{
    14bd:	55                   	push   %ebp
    14be:	89 e5                	mov    %esp,%ebp
    14c0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    14c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    14ca:	00 
    14cb:	8b 45 08             	mov    0x8(%ebp),%eax
    14ce:	89 04 24             	mov    %eax,(%esp)
    14d1:	e8 fe 00 00 00       	call   15d4 <open>
    14d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    14d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14dd:	79 07                	jns    14e6 <stat+0x29>
    return -1;
    14df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    14e4:	eb 23                	jmp    1509 <stat+0x4c>
  r = fstat(fd, st);
    14e6:	8b 45 0c             	mov    0xc(%ebp),%eax
    14e9:	89 44 24 04          	mov    %eax,0x4(%esp)
    14ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14f0:	89 04 24             	mov    %eax,(%esp)
    14f3:	e8 f4 00 00 00       	call   15ec <fstat>
    14f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    14fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14fe:	89 04 24             	mov    %eax,(%esp)
    1501:	e8 b6 00 00 00       	call   15bc <close>
  return r;
    1506:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1509:	c9                   	leave  
    150a:	c3                   	ret    

0000150b <atoi>:

int
atoi(const char *s)
{
    150b:	55                   	push   %ebp
    150c:	89 e5                	mov    %esp,%ebp
    150e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1511:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1518:	eb 21                	jmp    153b <atoi+0x30>
    n = n*10 + *s++ - '0';
    151a:	8b 55 fc             	mov    -0x4(%ebp),%edx
    151d:	89 d0                	mov    %edx,%eax
    151f:	c1 e0 02             	shl    $0x2,%eax
    1522:	01 d0                	add    %edx,%eax
    1524:	d1 e0                	shl    %eax
    1526:	89 c2                	mov    %eax,%edx
    1528:	8b 45 08             	mov    0x8(%ebp),%eax
    152b:	8a 00                	mov    (%eax),%al
    152d:	0f be c0             	movsbl %al,%eax
    1530:	01 d0                	add    %edx,%eax
    1532:	83 e8 30             	sub    $0x30,%eax
    1535:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1538:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    153b:	8b 45 08             	mov    0x8(%ebp),%eax
    153e:	8a 00                	mov    (%eax),%al
    1540:	3c 2f                	cmp    $0x2f,%al
    1542:	7e 09                	jle    154d <atoi+0x42>
    1544:	8b 45 08             	mov    0x8(%ebp),%eax
    1547:	8a 00                	mov    (%eax),%al
    1549:	3c 39                	cmp    $0x39,%al
    154b:	7e cd                	jle    151a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    154d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1550:	c9                   	leave  
    1551:	c3                   	ret    

00001552 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1552:	55                   	push   %ebp
    1553:	89 e5                	mov    %esp,%ebp
    1555:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1558:	8b 45 08             	mov    0x8(%ebp),%eax
    155b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    155e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1561:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1564:	eb 10                	jmp    1576 <memmove+0x24>
    *dst++ = *src++;
    1566:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1569:	8a 10                	mov    (%eax),%dl
    156b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    156e:	88 10                	mov    %dl,(%eax)
    1570:	ff 45 fc             	incl   -0x4(%ebp)
    1573:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1576:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    157a:	0f 9f c0             	setg   %al
    157d:	ff 4d 10             	decl   0x10(%ebp)
    1580:	84 c0                	test   %al,%al
    1582:	75 e2                	jne    1566 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1584:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1587:	c9                   	leave  
    1588:	c3                   	ret    
    1589:	66 90                	xchg   %ax,%ax
    158b:	90                   	nop

0000158c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    158c:	b8 01 00 00 00       	mov    $0x1,%eax
    1591:	cd 40                	int    $0x40
    1593:	c3                   	ret    

00001594 <exit>:
SYSCALL(exit)
    1594:	b8 02 00 00 00       	mov    $0x2,%eax
    1599:	cd 40                	int    $0x40
    159b:	c3                   	ret    

0000159c <wait>:
SYSCALL(wait)
    159c:	b8 03 00 00 00       	mov    $0x3,%eax
    15a1:	cd 40                	int    $0x40
    15a3:	c3                   	ret    

000015a4 <pipe>:
SYSCALL(pipe)
    15a4:	b8 04 00 00 00       	mov    $0x4,%eax
    15a9:	cd 40                	int    $0x40
    15ab:	c3                   	ret    

000015ac <read>:
SYSCALL(read)
    15ac:	b8 05 00 00 00       	mov    $0x5,%eax
    15b1:	cd 40                	int    $0x40
    15b3:	c3                   	ret    

000015b4 <write>:
SYSCALL(write)
    15b4:	b8 10 00 00 00       	mov    $0x10,%eax
    15b9:	cd 40                	int    $0x40
    15bb:	c3                   	ret    

000015bc <close>:
SYSCALL(close)
    15bc:	b8 15 00 00 00       	mov    $0x15,%eax
    15c1:	cd 40                	int    $0x40
    15c3:	c3                   	ret    

000015c4 <kill>:
SYSCALL(kill)
    15c4:	b8 06 00 00 00       	mov    $0x6,%eax
    15c9:	cd 40                	int    $0x40
    15cb:	c3                   	ret    

000015cc <exec>:
SYSCALL(exec)
    15cc:	b8 07 00 00 00       	mov    $0x7,%eax
    15d1:	cd 40                	int    $0x40
    15d3:	c3                   	ret    

000015d4 <open>:
SYSCALL(open)
    15d4:	b8 0f 00 00 00       	mov    $0xf,%eax
    15d9:	cd 40                	int    $0x40
    15db:	c3                   	ret    

000015dc <mknod>:
SYSCALL(mknod)
    15dc:	b8 11 00 00 00       	mov    $0x11,%eax
    15e1:	cd 40                	int    $0x40
    15e3:	c3                   	ret    

000015e4 <unlink>:
SYSCALL(unlink)
    15e4:	b8 12 00 00 00       	mov    $0x12,%eax
    15e9:	cd 40                	int    $0x40
    15eb:	c3                   	ret    

000015ec <fstat>:
SYSCALL(fstat)
    15ec:	b8 08 00 00 00       	mov    $0x8,%eax
    15f1:	cd 40                	int    $0x40
    15f3:	c3                   	ret    

000015f4 <link>:
SYSCALL(link)
    15f4:	b8 13 00 00 00       	mov    $0x13,%eax
    15f9:	cd 40                	int    $0x40
    15fb:	c3                   	ret    

000015fc <mkdir>:
SYSCALL(mkdir)
    15fc:	b8 14 00 00 00       	mov    $0x14,%eax
    1601:	cd 40                	int    $0x40
    1603:	c3                   	ret    

00001604 <chdir>:
SYSCALL(chdir)
    1604:	b8 09 00 00 00       	mov    $0x9,%eax
    1609:	cd 40                	int    $0x40
    160b:	c3                   	ret    

0000160c <dup>:
SYSCALL(dup)
    160c:	b8 0a 00 00 00       	mov    $0xa,%eax
    1611:	cd 40                	int    $0x40
    1613:	c3                   	ret    

00001614 <getpid>:
SYSCALL(getpid)
    1614:	b8 0b 00 00 00       	mov    $0xb,%eax
    1619:	cd 40                	int    $0x40
    161b:	c3                   	ret    

0000161c <sbrk>:
SYSCALL(sbrk)
    161c:	b8 0c 00 00 00       	mov    $0xc,%eax
    1621:	cd 40                	int    $0x40
    1623:	c3                   	ret    

00001624 <sleep>:
SYSCALL(sleep)
    1624:	b8 0d 00 00 00       	mov    $0xd,%eax
    1629:	cd 40                	int    $0x40
    162b:	c3                   	ret    

0000162c <uptime>:
SYSCALL(uptime)
    162c:	b8 0e 00 00 00       	mov    $0xe,%eax
    1631:	cd 40                	int    $0x40
    1633:	c3                   	ret    

00001634 <cowfork>:
SYSCALL(cowfork) //3.4
    1634:	b8 16 00 00 00       	mov    $0x16,%eax
    1639:	cd 40                	int    $0x40
    163b:	c3                   	ret    

0000163c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    163c:	55                   	push   %ebp
    163d:	89 e5                	mov    %esp,%ebp
    163f:	83 ec 28             	sub    $0x28,%esp
    1642:	8b 45 0c             	mov    0xc(%ebp),%eax
    1645:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1648:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    164f:	00 
    1650:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1653:	89 44 24 04          	mov    %eax,0x4(%esp)
    1657:	8b 45 08             	mov    0x8(%ebp),%eax
    165a:	89 04 24             	mov    %eax,(%esp)
    165d:	e8 52 ff ff ff       	call   15b4 <write>
}
    1662:	c9                   	leave  
    1663:	c3                   	ret    

00001664 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1664:	55                   	push   %ebp
    1665:	89 e5                	mov    %esp,%ebp
    1667:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    166a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1671:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1675:	74 17                	je     168e <printint+0x2a>
    1677:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    167b:	79 11                	jns    168e <printint+0x2a>
    neg = 1;
    167d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1684:	8b 45 0c             	mov    0xc(%ebp),%eax
    1687:	f7 d8                	neg    %eax
    1689:	89 45 ec             	mov    %eax,-0x14(%ebp)
    168c:	eb 06                	jmp    1694 <printint+0x30>
  } else {
    x = xx;
    168e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1691:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1694:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    169b:	8b 4d 10             	mov    0x10(%ebp),%ecx
    169e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16a1:	ba 00 00 00 00       	mov    $0x0,%edx
    16a6:	f7 f1                	div    %ecx
    16a8:	89 d0                	mov    %edx,%eax
    16aa:	8a 80 00 20 00 00    	mov    0x2000(%eax),%al
    16b0:	8d 4d dc             	lea    -0x24(%ebp),%ecx
    16b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
    16b6:	01 ca                	add    %ecx,%edx
    16b8:	88 02                	mov    %al,(%edx)
    16ba:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
    16bd:	8b 55 10             	mov    0x10(%ebp),%edx
    16c0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    16c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16c6:	ba 00 00 00 00       	mov    $0x0,%edx
    16cb:	f7 75 d4             	divl   -0x2c(%ebp)
    16ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
    16d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    16d5:	75 c4                	jne    169b <printint+0x37>
  if(neg)
    16d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    16db:	74 2c                	je     1709 <printint+0xa5>
    buf[i++] = '-';
    16dd:	8d 55 dc             	lea    -0x24(%ebp),%edx
    16e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16e3:	01 d0                	add    %edx,%eax
    16e5:	c6 00 2d             	movb   $0x2d,(%eax)
    16e8:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
    16eb:	eb 1c                	jmp    1709 <printint+0xa5>
    putc(fd, buf[i]);
    16ed:	8d 55 dc             	lea    -0x24(%ebp),%edx
    16f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16f3:	01 d0                	add    %edx,%eax
    16f5:	8a 00                	mov    (%eax),%al
    16f7:	0f be c0             	movsbl %al,%eax
    16fa:	89 44 24 04          	mov    %eax,0x4(%esp)
    16fe:	8b 45 08             	mov    0x8(%ebp),%eax
    1701:	89 04 24             	mov    %eax,(%esp)
    1704:	e8 33 ff ff ff       	call   163c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1709:	ff 4d f4             	decl   -0xc(%ebp)
    170c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1710:	79 db                	jns    16ed <printint+0x89>
    putc(fd, buf[i]);
}
    1712:	c9                   	leave  
    1713:	c3                   	ret    

00001714 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1714:	55                   	push   %ebp
    1715:	89 e5                	mov    %esp,%ebp
    1717:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    171a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1721:	8d 45 0c             	lea    0xc(%ebp),%eax
    1724:	83 c0 04             	add    $0x4,%eax
    1727:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    172a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1731:	e9 78 01 00 00       	jmp    18ae <printf+0x19a>
    c = fmt[i] & 0xff;
    1736:	8b 55 0c             	mov    0xc(%ebp),%edx
    1739:	8b 45 f0             	mov    -0x10(%ebp),%eax
    173c:	01 d0                	add    %edx,%eax
    173e:	8a 00                	mov    (%eax),%al
    1740:	0f be c0             	movsbl %al,%eax
    1743:	25 ff 00 00 00       	and    $0xff,%eax
    1748:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    174b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    174f:	75 2c                	jne    177d <printf+0x69>
      if(c == '%'){
    1751:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1755:	75 0c                	jne    1763 <printf+0x4f>
        state = '%';
    1757:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    175e:	e9 48 01 00 00       	jmp    18ab <printf+0x197>
      } else {
        putc(fd, c);
    1763:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1766:	0f be c0             	movsbl %al,%eax
    1769:	89 44 24 04          	mov    %eax,0x4(%esp)
    176d:	8b 45 08             	mov    0x8(%ebp),%eax
    1770:	89 04 24             	mov    %eax,(%esp)
    1773:	e8 c4 fe ff ff       	call   163c <putc>
    1778:	e9 2e 01 00 00       	jmp    18ab <printf+0x197>
      }
    } else if(state == '%'){
    177d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1781:	0f 85 24 01 00 00    	jne    18ab <printf+0x197>
      if(c == 'd'){
    1787:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    178b:	75 2d                	jne    17ba <printf+0xa6>
        printint(fd, *ap, 10, 1);
    178d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1790:	8b 00                	mov    (%eax),%eax
    1792:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1799:	00 
    179a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    17a1:	00 
    17a2:	89 44 24 04          	mov    %eax,0x4(%esp)
    17a6:	8b 45 08             	mov    0x8(%ebp),%eax
    17a9:	89 04 24             	mov    %eax,(%esp)
    17ac:	e8 b3 fe ff ff       	call   1664 <printint>
        ap++;
    17b1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    17b5:	e9 ea 00 00 00       	jmp    18a4 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
    17ba:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    17be:	74 06                	je     17c6 <printf+0xb2>
    17c0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    17c4:	75 2d                	jne    17f3 <printf+0xdf>
        printint(fd, *ap, 16, 0);
    17c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17c9:	8b 00                	mov    (%eax),%eax
    17cb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    17d2:	00 
    17d3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    17da:	00 
    17db:	89 44 24 04          	mov    %eax,0x4(%esp)
    17df:	8b 45 08             	mov    0x8(%ebp),%eax
    17e2:	89 04 24             	mov    %eax,(%esp)
    17e5:	e8 7a fe ff ff       	call   1664 <printint>
        ap++;
    17ea:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    17ee:	e9 b1 00 00 00       	jmp    18a4 <printf+0x190>
      } else if(c == 's'){
    17f3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    17f7:	75 43                	jne    183c <printf+0x128>
        s = (char*)*ap;
    17f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17fc:	8b 00                	mov    (%eax),%eax
    17fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1801:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1805:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1809:	75 25                	jne    1830 <printf+0x11c>
          s = "(null)";
    180b:	c7 45 f4 12 1b 00 00 	movl   $0x1b12,-0xc(%ebp)
        while(*s != 0){
    1812:	eb 1c                	jmp    1830 <printf+0x11c>
          putc(fd, *s);
    1814:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1817:	8a 00                	mov    (%eax),%al
    1819:	0f be c0             	movsbl %al,%eax
    181c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1820:	8b 45 08             	mov    0x8(%ebp),%eax
    1823:	89 04 24             	mov    %eax,(%esp)
    1826:	e8 11 fe ff ff       	call   163c <putc>
          s++;
    182b:	ff 45 f4             	incl   -0xc(%ebp)
    182e:	eb 01                	jmp    1831 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1830:	90                   	nop
    1831:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1834:	8a 00                	mov    (%eax),%al
    1836:	84 c0                	test   %al,%al
    1838:	75 da                	jne    1814 <printf+0x100>
    183a:	eb 68                	jmp    18a4 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    183c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1840:	75 1d                	jne    185f <printf+0x14b>
        putc(fd, *ap);
    1842:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1845:	8b 00                	mov    (%eax),%eax
    1847:	0f be c0             	movsbl %al,%eax
    184a:	89 44 24 04          	mov    %eax,0x4(%esp)
    184e:	8b 45 08             	mov    0x8(%ebp),%eax
    1851:	89 04 24             	mov    %eax,(%esp)
    1854:	e8 e3 fd ff ff       	call   163c <putc>
        ap++;
    1859:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    185d:	eb 45                	jmp    18a4 <printf+0x190>
      } else if(c == '%'){
    185f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1863:	75 17                	jne    187c <printf+0x168>
        putc(fd, c);
    1865:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1868:	0f be c0             	movsbl %al,%eax
    186b:	89 44 24 04          	mov    %eax,0x4(%esp)
    186f:	8b 45 08             	mov    0x8(%ebp),%eax
    1872:	89 04 24             	mov    %eax,(%esp)
    1875:	e8 c2 fd ff ff       	call   163c <putc>
    187a:	eb 28                	jmp    18a4 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    187c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1883:	00 
    1884:	8b 45 08             	mov    0x8(%ebp),%eax
    1887:	89 04 24             	mov    %eax,(%esp)
    188a:	e8 ad fd ff ff       	call   163c <putc>
        putc(fd, c);
    188f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1892:	0f be c0             	movsbl %al,%eax
    1895:	89 44 24 04          	mov    %eax,0x4(%esp)
    1899:	8b 45 08             	mov    0x8(%ebp),%eax
    189c:	89 04 24             	mov    %eax,(%esp)
    189f:	e8 98 fd ff ff       	call   163c <putc>
      }
      state = 0;
    18a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    18ab:	ff 45 f0             	incl   -0x10(%ebp)
    18ae:	8b 55 0c             	mov    0xc(%ebp),%edx
    18b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18b4:	01 d0                	add    %edx,%eax
    18b6:	8a 00                	mov    (%eax),%al
    18b8:	84 c0                	test   %al,%al
    18ba:	0f 85 76 fe ff ff    	jne    1736 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    18c0:	c9                   	leave  
    18c1:	c3                   	ret    
    18c2:	66 90                	xchg   %ax,%ax

000018c4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    18c4:	55                   	push   %ebp
    18c5:	89 e5                	mov    %esp,%ebp
    18c7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    18ca:	8b 45 08             	mov    0x8(%ebp),%eax
    18cd:	83 e8 08             	sub    $0x8,%eax
    18d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    18d3:	a1 28 20 00 00       	mov    0x2028,%eax
    18d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    18db:	eb 24                	jmp    1901 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    18dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18e0:	8b 00                	mov    (%eax),%eax
    18e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    18e5:	77 12                	ja     18f9 <free+0x35>
    18e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    18ed:	77 24                	ja     1913 <free+0x4f>
    18ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18f2:	8b 00                	mov    (%eax),%eax
    18f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    18f7:	77 1a                	ja     1913 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    18f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18fc:	8b 00                	mov    (%eax),%eax
    18fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1901:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1904:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1907:	76 d4                	jbe    18dd <free+0x19>
    1909:	8b 45 fc             	mov    -0x4(%ebp),%eax
    190c:	8b 00                	mov    (%eax),%eax
    190e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1911:	76 ca                	jbe    18dd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1913:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1916:	8b 40 04             	mov    0x4(%eax),%eax
    1919:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1920:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1923:	01 c2                	add    %eax,%edx
    1925:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1928:	8b 00                	mov    (%eax),%eax
    192a:	39 c2                	cmp    %eax,%edx
    192c:	75 24                	jne    1952 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    192e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1931:	8b 50 04             	mov    0x4(%eax),%edx
    1934:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1937:	8b 00                	mov    (%eax),%eax
    1939:	8b 40 04             	mov    0x4(%eax),%eax
    193c:	01 c2                	add    %eax,%edx
    193e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1941:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1944:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1947:	8b 00                	mov    (%eax),%eax
    1949:	8b 10                	mov    (%eax),%edx
    194b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    194e:	89 10                	mov    %edx,(%eax)
    1950:	eb 0a                	jmp    195c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1952:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1955:	8b 10                	mov    (%eax),%edx
    1957:	8b 45 f8             	mov    -0x8(%ebp),%eax
    195a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    195c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    195f:	8b 40 04             	mov    0x4(%eax),%eax
    1962:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1969:	8b 45 fc             	mov    -0x4(%ebp),%eax
    196c:	01 d0                	add    %edx,%eax
    196e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1971:	75 20                	jne    1993 <free+0xcf>
    p->s.size += bp->s.size;
    1973:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1976:	8b 50 04             	mov    0x4(%eax),%edx
    1979:	8b 45 f8             	mov    -0x8(%ebp),%eax
    197c:	8b 40 04             	mov    0x4(%eax),%eax
    197f:	01 c2                	add    %eax,%edx
    1981:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1984:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1987:	8b 45 f8             	mov    -0x8(%ebp),%eax
    198a:	8b 10                	mov    (%eax),%edx
    198c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    198f:	89 10                	mov    %edx,(%eax)
    1991:	eb 08                	jmp    199b <free+0xd7>
  } else
    p->s.ptr = bp;
    1993:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1996:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1999:	89 10                	mov    %edx,(%eax)
  freep = p;
    199b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    199e:	a3 28 20 00 00       	mov    %eax,0x2028
}
    19a3:	c9                   	leave  
    19a4:	c3                   	ret    

000019a5 <morecore>:

static Header*
morecore(uint nu)
{
    19a5:	55                   	push   %ebp
    19a6:	89 e5                	mov    %esp,%ebp
    19a8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    19ab:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    19b2:	77 07                	ja     19bb <morecore+0x16>
    nu = 4096;
    19b4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    19bb:	8b 45 08             	mov    0x8(%ebp),%eax
    19be:	c1 e0 03             	shl    $0x3,%eax
    19c1:	89 04 24             	mov    %eax,(%esp)
    19c4:	e8 53 fc ff ff       	call   161c <sbrk>
    19c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    19cc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    19d0:	75 07                	jne    19d9 <morecore+0x34>
    return 0;
    19d2:	b8 00 00 00 00       	mov    $0x0,%eax
    19d7:	eb 22                	jmp    19fb <morecore+0x56>
  hp = (Header*)p;
    19d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    19df:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19e2:	8b 55 08             	mov    0x8(%ebp),%edx
    19e5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    19e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19eb:	83 c0 08             	add    $0x8,%eax
    19ee:	89 04 24             	mov    %eax,(%esp)
    19f1:	e8 ce fe ff ff       	call   18c4 <free>
  return freep;
    19f6:	a1 28 20 00 00       	mov    0x2028,%eax
}
    19fb:	c9                   	leave  
    19fc:	c3                   	ret    

000019fd <malloc>:

void*
malloc(uint nbytes)
{
    19fd:	55                   	push   %ebp
    19fe:	89 e5                	mov    %esp,%ebp
    1a00:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1a03:	8b 45 08             	mov    0x8(%ebp),%eax
    1a06:	83 c0 07             	add    $0x7,%eax
    1a09:	c1 e8 03             	shr    $0x3,%eax
    1a0c:	40                   	inc    %eax
    1a0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1a10:	a1 28 20 00 00       	mov    0x2028,%eax
    1a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1a18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1a1c:	75 23                	jne    1a41 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    1a1e:	c7 45 f0 20 20 00 00 	movl   $0x2020,-0x10(%ebp)
    1a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a28:	a3 28 20 00 00       	mov    %eax,0x2028
    1a2d:	a1 28 20 00 00       	mov    0x2028,%eax
    1a32:	a3 20 20 00 00       	mov    %eax,0x2020
    base.s.size = 0;
    1a37:	c7 05 24 20 00 00 00 	movl   $0x0,0x2024
    1a3e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a44:	8b 00                	mov    (%eax),%eax
    1a46:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a4c:	8b 40 04             	mov    0x4(%eax),%eax
    1a4f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1a52:	72 4d                	jb     1aa1 <malloc+0xa4>
      if(p->s.size == nunits)
    1a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a57:	8b 40 04             	mov    0x4(%eax),%eax
    1a5a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1a5d:	75 0c                	jne    1a6b <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    1a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a62:	8b 10                	mov    (%eax),%edx
    1a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a67:	89 10                	mov    %edx,(%eax)
    1a69:	eb 26                	jmp    1a91 <malloc+0x94>
      else {
        p->s.size -= nunits;
    1a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a6e:	8b 40 04             	mov    0x4(%eax),%eax
    1a71:	89 c2                	mov    %eax,%edx
    1a73:	2b 55 ec             	sub    -0x14(%ebp),%edx
    1a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a79:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a7f:	8b 40 04             	mov    0x4(%eax),%eax
    1a82:	c1 e0 03             	shl    $0x3,%eax
    1a85:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a8b:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1a8e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a94:	a3 28 20 00 00       	mov    %eax,0x2028
      return (void*)(p + 1);
    1a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a9c:	83 c0 08             	add    $0x8,%eax
    1a9f:	eb 38                	jmp    1ad9 <malloc+0xdc>
    }
    if(p == freep)
    1aa1:	a1 28 20 00 00       	mov    0x2028,%eax
    1aa6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1aa9:	75 1b                	jne    1ac6 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    1aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1aae:	89 04 24             	mov    %eax,(%esp)
    1ab1:	e8 ef fe ff ff       	call   19a5 <morecore>
    1ab6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1ab9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1abd:	75 07                	jne    1ac6 <malloc+0xc9>
        return 0;
    1abf:	b8 00 00 00 00       	mov    $0x0,%eax
    1ac4:	eb 13                	jmp    1ad9 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1acf:	8b 00                	mov    (%eax),%eax
    1ad1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1ad4:	e9 70 ff ff ff       	jmp    1a49 <malloc+0x4c>
}
    1ad9:	c9                   	leave  
    1ada:	c3                   	ret    
