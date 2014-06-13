
_ls:     file format elf32-i386


Disassembly of section .text:

00001000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	53                   	push   %ebx
    1004:	83 ec 24             	sub    $0x24,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    1007:	8b 45 08             	mov    0x8(%ebp),%eax
    100a:	89 04 24             	mov    %eax,(%esp)
    100d:	e8 d1 03 00 00       	call   13e3 <strlen>
    1012:	8b 55 08             	mov    0x8(%ebp),%edx
    1015:	01 d0                	add    %edx,%eax
    1017:	89 45 f4             	mov    %eax,-0xc(%ebp)
    101a:	eb 03                	jmp    101f <fmtname+0x1f>
    101c:	ff 4d f4             	decl   -0xc(%ebp)
    101f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1022:	3b 45 08             	cmp    0x8(%ebp),%eax
    1025:	72 09                	jb     1030 <fmtname+0x30>
    1027:	8b 45 f4             	mov    -0xc(%ebp),%eax
    102a:	8a 00                	mov    (%eax),%al
    102c:	3c 2f                	cmp    $0x2f,%al
    102e:	75 ec                	jne    101c <fmtname+0x1c>
    ;
  p++;
    1030:	ff 45 f4             	incl   -0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    1033:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1036:	89 04 24             	mov    %eax,(%esp)
    1039:	e8 a5 03 00 00       	call   13e3 <strlen>
    103e:	83 f8 0d             	cmp    $0xd,%eax
    1041:	76 05                	jbe    1048 <fmtname+0x48>
    return p;
    1043:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1046:	eb 5f                	jmp    10a7 <fmtname+0xa7>
  memmove(buf, p, strlen(p));
    1048:	8b 45 f4             	mov    -0xc(%ebp),%eax
    104b:	89 04 24             	mov    %eax,(%esp)
    104e:	e8 90 03 00 00       	call   13e3 <strlen>
    1053:	89 44 24 08          	mov    %eax,0x8(%esp)
    1057:	8b 45 f4             	mov    -0xc(%ebp),%eax
    105a:	89 44 24 04          	mov    %eax,0x4(%esp)
    105e:	c7 04 24 dc 2d 00 00 	movl   $0x2ddc,(%esp)
    1065:	e8 f4 04 00 00       	call   155e <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
    106a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    106d:	89 04 24             	mov    %eax,(%esp)
    1070:	e8 6e 03 00 00       	call   13e3 <strlen>
    1075:	ba 0e 00 00 00       	mov    $0xe,%edx
    107a:	89 d3                	mov    %edx,%ebx
    107c:	29 c3                	sub    %eax,%ebx
    107e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1081:	89 04 24             	mov    %eax,(%esp)
    1084:	e8 5a 03 00 00       	call   13e3 <strlen>
    1089:	05 dc 2d 00 00       	add    $0x2ddc,%eax
    108e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
    1092:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
    1099:	00 
    109a:	89 04 24             	mov    %eax,(%esp)
    109d:	e8 66 03 00 00       	call   1408 <memset>
  return buf;
    10a2:	b8 dc 2d 00 00       	mov    $0x2ddc,%eax
}
    10a7:	83 c4 24             	add    $0x24,%esp
    10aa:	5b                   	pop    %ebx
    10ab:	5d                   	pop    %ebp
    10ac:	c3                   	ret    

000010ad <ls>:

void
ls(char *path)
{
    10ad:	55                   	push   %ebp
    10ae:	89 e5                	mov    %esp,%ebp
    10b0:	57                   	push   %edi
    10b1:	56                   	push   %esi
    10b2:	53                   	push   %ebx
    10b3:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
    10b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    10c0:	00 
    10c1:	8b 45 08             	mov    0x8(%ebp),%eax
    10c4:	89 04 24             	mov    %eax,(%esp)
    10c7:	e8 14 05 00 00       	call   15e0 <open>
    10cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    10cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    10d3:	79 20                	jns    10f5 <ls+0x48>
    printf(2, "ls: cannot open %s\n", path);
    10d5:	8b 45 08             	mov    0x8(%ebp),%eax
    10d8:	89 44 24 08          	mov    %eax,0x8(%esp)
    10dc:	c7 44 24 04 e7 1a 00 	movl   $0x1ae7,0x4(%esp)
    10e3:	00 
    10e4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    10eb:	e8 30 06 00 00       	call   1720 <printf>
    10f0:	e9 fc 01 00 00       	jmp    12f1 <ls+0x244>
    return;
  }
  
  if(fstat(fd, &st) < 0){
    10f5:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
    10fb:	89 44 24 04          	mov    %eax,0x4(%esp)
    10ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1102:	89 04 24             	mov    %eax,(%esp)
    1105:	e8 ee 04 00 00       	call   15f8 <fstat>
    110a:	85 c0                	test   %eax,%eax
    110c:	79 2b                	jns    1139 <ls+0x8c>
    printf(2, "ls: cannot stat %s\n", path);
    110e:	8b 45 08             	mov    0x8(%ebp),%eax
    1111:	89 44 24 08          	mov    %eax,0x8(%esp)
    1115:	c7 44 24 04 fb 1a 00 	movl   $0x1afb,0x4(%esp)
    111c:	00 
    111d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1124:	e8 f7 05 00 00       	call   1720 <printf>
    close(fd);
    1129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    112c:	89 04 24             	mov    %eax,(%esp)
    112f:	e8 94 04 00 00       	call   15c8 <close>
    1134:	e9 b8 01 00 00       	jmp    12f1 <ls+0x244>
    return;
  }
  
  switch(st.type){
    1139:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
    113f:	98                   	cwtl   
    1140:	83 f8 01             	cmp    $0x1,%eax
    1143:	74 52                	je     1197 <ls+0xea>
    1145:	83 f8 02             	cmp    $0x2,%eax
    1148:	0f 85 98 01 00 00    	jne    12e6 <ls+0x239>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    114e:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
    1154:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
    115a:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
    1160:	0f bf d8             	movswl %ax,%ebx
    1163:	8b 45 08             	mov    0x8(%ebp),%eax
    1166:	89 04 24             	mov    %eax,(%esp)
    1169:	e8 92 fe ff ff       	call   1000 <fmtname>
    116e:	89 7c 24 14          	mov    %edi,0x14(%esp)
    1172:	89 74 24 10          	mov    %esi,0x10(%esp)
    1176:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    117a:	89 44 24 08          	mov    %eax,0x8(%esp)
    117e:	c7 44 24 04 0f 1b 00 	movl   $0x1b0f,0x4(%esp)
    1185:	00 
    1186:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    118d:	e8 8e 05 00 00       	call   1720 <printf>
    break;
    1192:	e9 4f 01 00 00       	jmp    12e6 <ls+0x239>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
    1197:	8b 45 08             	mov    0x8(%ebp),%eax
    119a:	89 04 24             	mov    %eax,(%esp)
    119d:	e8 41 02 00 00       	call   13e3 <strlen>
    11a2:	83 c0 10             	add    $0x10,%eax
    11a5:	3d 00 02 00 00       	cmp    $0x200,%eax
    11aa:	76 19                	jbe    11c5 <ls+0x118>
      printf(1, "ls: path too long\n");
    11ac:	c7 44 24 04 1c 1b 00 	movl   $0x1b1c,0x4(%esp)
    11b3:	00 
    11b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11bb:	e8 60 05 00 00       	call   1720 <printf>
      break;
    11c0:	e9 21 01 00 00       	jmp    12e6 <ls+0x239>
    }
    strcpy(buf, path);
    11c5:	8b 45 08             	mov    0x8(%ebp),%eax
    11c8:	89 44 24 04          	mov    %eax,0x4(%esp)
    11cc:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
    11d2:	89 04 24             	mov    %eax,(%esp)
    11d5:	e8 9f 01 00 00       	call   1379 <strcpy>
    p = buf+strlen(buf);
    11da:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
    11e0:	89 04 24             	mov    %eax,(%esp)
    11e3:	e8 fb 01 00 00       	call   13e3 <strlen>
    11e8:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
    11ee:	01 d0                	add    %edx,%eax
    11f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
    11f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
    11f6:	c6 00 2f             	movb   $0x2f,(%eax)
    11f9:	ff 45 e0             	incl   -0x20(%ebp)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
    11fc:	e9 be 00 00 00       	jmp    12bf <ls+0x212>
      if(de.inum == 0)
    1201:	8b 85 d0 fd ff ff    	mov    -0x230(%ebp),%eax
    1207:	66 85 c0             	test   %ax,%ax
    120a:	0f 84 ae 00 00 00    	je     12be <ls+0x211>
        continue;
      memmove(p, de.name, DIRSIZ);
    1210:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
    1217:	00 
    1218:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
    121e:	83 c0 02             	add    $0x2,%eax
    1221:	89 44 24 04          	mov    %eax,0x4(%esp)
    1225:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1228:	89 04 24             	mov    %eax,(%esp)
    122b:	e8 2e 03 00 00       	call   155e <memmove>
      p[DIRSIZ] = 0;
    1230:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1233:	83 c0 0e             	add    $0xe,%eax
    1236:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
    1239:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
    123f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1243:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
    1249:	89 04 24             	mov    %eax,(%esp)
    124c:	e8 78 02 00 00       	call   14c9 <stat>
    1251:	85 c0                	test   %eax,%eax
    1253:	79 20                	jns    1275 <ls+0x1c8>
        printf(1, "ls: cannot stat %s\n", buf);
    1255:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
    125b:	89 44 24 08          	mov    %eax,0x8(%esp)
    125f:	c7 44 24 04 fb 1a 00 	movl   $0x1afb,0x4(%esp)
    1266:	00 
    1267:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    126e:	e8 ad 04 00 00       	call   1720 <printf>
        continue;
    1273:	eb 4a                	jmp    12bf <ls+0x212>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    1275:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
    127b:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
    1281:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
    1287:	0f bf d8             	movswl %ax,%ebx
    128a:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
    1290:	89 04 24             	mov    %eax,(%esp)
    1293:	e8 68 fd ff ff       	call   1000 <fmtname>
    1298:	89 7c 24 14          	mov    %edi,0x14(%esp)
    129c:	89 74 24 10          	mov    %esi,0x10(%esp)
    12a0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    12a4:	89 44 24 08          	mov    %eax,0x8(%esp)
    12a8:	c7 44 24 04 0f 1b 00 	movl   $0x1b0f,0x4(%esp)
    12af:	00 
    12b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12b7:	e8 64 04 00 00       	call   1720 <printf>
    12bc:	eb 01                	jmp    12bf <ls+0x212>
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
    12be:	90                   	nop
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
    12bf:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    12c6:	00 
    12c7:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
    12cd:	89 44 24 04          	mov    %eax,0x4(%esp)
    12d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    12d4:	89 04 24             	mov    %eax,(%esp)
    12d7:	e8 dc 02 00 00       	call   15b8 <read>
    12dc:	83 f8 10             	cmp    $0x10,%eax
    12df:	0f 84 1c ff ff ff    	je     1201 <ls+0x154>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
    12e5:	90                   	nop
  }
  close(fd);
    12e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    12e9:	89 04 24             	mov    %eax,(%esp)
    12ec:	e8 d7 02 00 00       	call   15c8 <close>
}
    12f1:	81 c4 5c 02 00 00    	add    $0x25c,%esp
    12f7:	5b                   	pop    %ebx
    12f8:	5e                   	pop    %esi
    12f9:	5f                   	pop    %edi
    12fa:	5d                   	pop    %ebp
    12fb:	c3                   	ret    

000012fc <main>:

int
main(int argc, char *argv[])
{
    12fc:	55                   	push   %ebp
    12fd:	89 e5                	mov    %esp,%ebp
    12ff:	83 e4 f0             	and    $0xfffffff0,%esp
    1302:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
    1305:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
    1309:	7f 11                	jg     131c <main+0x20>
    ls(".");
    130b:	c7 04 24 2f 1b 00 00 	movl   $0x1b2f,(%esp)
    1312:	e8 96 fd ff ff       	call   10ad <ls>
    exit();
    1317:	e8 84 02 00 00       	call   15a0 <exit>
  }
  for(i=1; i<argc; i++)
    131c:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
    1323:	00 
    1324:	eb 1e                	jmp    1344 <main+0x48>
    ls(argv[i]);
    1326:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    132a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1331:	8b 45 0c             	mov    0xc(%ebp),%eax
    1334:	01 d0                	add    %edx,%eax
    1336:	8b 00                	mov    (%eax),%eax
    1338:	89 04 24             	mov    %eax,(%esp)
    133b:	e8 6d fd ff ff       	call   10ad <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    1340:	ff 44 24 1c          	incl   0x1c(%esp)
    1344:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1348:	3b 45 08             	cmp    0x8(%ebp),%eax
    134b:	7c d9                	jl     1326 <main+0x2a>
    ls(argv[i]);
  exit();
    134d:	e8 4e 02 00 00       	call   15a0 <exit>
    1352:	66 90                	xchg   %ax,%ax

00001354 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1354:	55                   	push   %ebp
    1355:	89 e5                	mov    %esp,%ebp
    1357:	57                   	push   %edi
    1358:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1359:	8b 4d 08             	mov    0x8(%ebp),%ecx
    135c:	8b 55 10             	mov    0x10(%ebp),%edx
    135f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1362:	89 cb                	mov    %ecx,%ebx
    1364:	89 df                	mov    %ebx,%edi
    1366:	89 d1                	mov    %edx,%ecx
    1368:	fc                   	cld    
    1369:	f3 aa                	rep stos %al,%es:(%edi)
    136b:	89 ca                	mov    %ecx,%edx
    136d:	89 fb                	mov    %edi,%ebx
    136f:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1372:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1375:	5b                   	pop    %ebx
    1376:	5f                   	pop    %edi
    1377:	5d                   	pop    %ebp
    1378:	c3                   	ret    

00001379 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1379:	55                   	push   %ebp
    137a:	89 e5                	mov    %esp,%ebp
    137c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    137f:	8b 45 08             	mov    0x8(%ebp),%eax
    1382:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1385:	90                   	nop
    1386:	8b 45 0c             	mov    0xc(%ebp),%eax
    1389:	8a 10                	mov    (%eax),%dl
    138b:	8b 45 08             	mov    0x8(%ebp),%eax
    138e:	88 10                	mov    %dl,(%eax)
    1390:	8b 45 08             	mov    0x8(%ebp),%eax
    1393:	8a 00                	mov    (%eax),%al
    1395:	84 c0                	test   %al,%al
    1397:	0f 95 c0             	setne  %al
    139a:	ff 45 08             	incl   0x8(%ebp)
    139d:	ff 45 0c             	incl   0xc(%ebp)
    13a0:	84 c0                	test   %al,%al
    13a2:	75 e2                	jne    1386 <strcpy+0xd>
    ;
  return os;
    13a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    13a7:	c9                   	leave  
    13a8:	c3                   	ret    

000013a9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    13a9:	55                   	push   %ebp
    13aa:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    13ac:	eb 06                	jmp    13b4 <strcmp+0xb>
    p++, q++;
    13ae:	ff 45 08             	incl   0x8(%ebp)
    13b1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    13b4:	8b 45 08             	mov    0x8(%ebp),%eax
    13b7:	8a 00                	mov    (%eax),%al
    13b9:	84 c0                	test   %al,%al
    13bb:	74 0e                	je     13cb <strcmp+0x22>
    13bd:	8b 45 08             	mov    0x8(%ebp),%eax
    13c0:	8a 10                	mov    (%eax),%dl
    13c2:	8b 45 0c             	mov    0xc(%ebp),%eax
    13c5:	8a 00                	mov    (%eax),%al
    13c7:	38 c2                	cmp    %al,%dl
    13c9:	74 e3                	je     13ae <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    13cb:	8b 45 08             	mov    0x8(%ebp),%eax
    13ce:	8a 00                	mov    (%eax),%al
    13d0:	0f b6 d0             	movzbl %al,%edx
    13d3:	8b 45 0c             	mov    0xc(%ebp),%eax
    13d6:	8a 00                	mov    (%eax),%al
    13d8:	0f b6 c0             	movzbl %al,%eax
    13db:	89 d1                	mov    %edx,%ecx
    13dd:	29 c1                	sub    %eax,%ecx
    13df:	89 c8                	mov    %ecx,%eax
}
    13e1:	5d                   	pop    %ebp
    13e2:	c3                   	ret    

000013e3 <strlen>:

uint
strlen(char *s)
{
    13e3:	55                   	push   %ebp
    13e4:	89 e5                	mov    %esp,%ebp
    13e6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    13e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    13f0:	eb 03                	jmp    13f5 <strlen+0x12>
    13f2:	ff 45 fc             	incl   -0x4(%ebp)
    13f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
    13f8:	8b 45 08             	mov    0x8(%ebp),%eax
    13fb:	01 d0                	add    %edx,%eax
    13fd:	8a 00                	mov    (%eax),%al
    13ff:	84 c0                	test   %al,%al
    1401:	75 ef                	jne    13f2 <strlen+0xf>
    ;
  return n;
    1403:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1406:	c9                   	leave  
    1407:	c3                   	ret    

00001408 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1408:	55                   	push   %ebp
    1409:	89 e5                	mov    %esp,%ebp
    140b:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    140e:	8b 45 10             	mov    0x10(%ebp),%eax
    1411:	89 44 24 08          	mov    %eax,0x8(%esp)
    1415:	8b 45 0c             	mov    0xc(%ebp),%eax
    1418:	89 44 24 04          	mov    %eax,0x4(%esp)
    141c:	8b 45 08             	mov    0x8(%ebp),%eax
    141f:	89 04 24             	mov    %eax,(%esp)
    1422:	e8 2d ff ff ff       	call   1354 <stosb>
  return dst;
    1427:	8b 45 08             	mov    0x8(%ebp),%eax
}
    142a:	c9                   	leave  
    142b:	c3                   	ret    

0000142c <strchr>:

char*
strchr(const char *s, char c)
{
    142c:	55                   	push   %ebp
    142d:	89 e5                	mov    %esp,%ebp
    142f:	83 ec 04             	sub    $0x4,%esp
    1432:	8b 45 0c             	mov    0xc(%ebp),%eax
    1435:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1438:	eb 12                	jmp    144c <strchr+0x20>
    if(*s == c)
    143a:	8b 45 08             	mov    0x8(%ebp),%eax
    143d:	8a 00                	mov    (%eax),%al
    143f:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1442:	75 05                	jne    1449 <strchr+0x1d>
      return (char*)s;
    1444:	8b 45 08             	mov    0x8(%ebp),%eax
    1447:	eb 11                	jmp    145a <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1449:	ff 45 08             	incl   0x8(%ebp)
    144c:	8b 45 08             	mov    0x8(%ebp),%eax
    144f:	8a 00                	mov    (%eax),%al
    1451:	84 c0                	test   %al,%al
    1453:	75 e5                	jne    143a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1455:	b8 00 00 00 00       	mov    $0x0,%eax
}
    145a:	c9                   	leave  
    145b:	c3                   	ret    

0000145c <gets>:

char*
gets(char *buf, int max)
{
    145c:	55                   	push   %ebp
    145d:	89 e5                	mov    %esp,%ebp
    145f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1462:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1469:	eb 42                	jmp    14ad <gets+0x51>
    cc = read(0, &c, 1);
    146b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1472:	00 
    1473:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1476:	89 44 24 04          	mov    %eax,0x4(%esp)
    147a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1481:	e8 32 01 00 00       	call   15b8 <read>
    1486:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1489:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    148d:	7e 29                	jle    14b8 <gets+0x5c>
      break;
    buf[i++] = c;
    148f:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1492:	8b 45 08             	mov    0x8(%ebp),%eax
    1495:	01 c2                	add    %eax,%edx
    1497:	8a 45 ef             	mov    -0x11(%ebp),%al
    149a:	88 02                	mov    %al,(%edx)
    149c:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
    149f:	8a 45 ef             	mov    -0x11(%ebp),%al
    14a2:	3c 0a                	cmp    $0xa,%al
    14a4:	74 13                	je     14b9 <gets+0x5d>
    14a6:	8a 45 ef             	mov    -0x11(%ebp),%al
    14a9:	3c 0d                	cmp    $0xd,%al
    14ab:	74 0c                	je     14b9 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    14ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14b0:	40                   	inc    %eax
    14b1:	3b 45 0c             	cmp    0xc(%ebp),%eax
    14b4:	7c b5                	jl     146b <gets+0xf>
    14b6:	eb 01                	jmp    14b9 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    14b8:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    14b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14bc:	8b 45 08             	mov    0x8(%ebp),%eax
    14bf:	01 d0                	add    %edx,%eax
    14c1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    14c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
    14c7:	c9                   	leave  
    14c8:	c3                   	ret    

000014c9 <stat>:

int
stat(char *n, struct stat *st)
{
    14c9:	55                   	push   %ebp
    14ca:	89 e5                	mov    %esp,%ebp
    14cc:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    14cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    14d6:	00 
    14d7:	8b 45 08             	mov    0x8(%ebp),%eax
    14da:	89 04 24             	mov    %eax,(%esp)
    14dd:	e8 fe 00 00 00       	call   15e0 <open>
    14e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    14e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14e9:	79 07                	jns    14f2 <stat+0x29>
    return -1;
    14eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    14f0:	eb 23                	jmp    1515 <stat+0x4c>
  r = fstat(fd, st);
    14f2:	8b 45 0c             	mov    0xc(%ebp),%eax
    14f5:	89 44 24 04          	mov    %eax,0x4(%esp)
    14f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14fc:	89 04 24             	mov    %eax,(%esp)
    14ff:	e8 f4 00 00 00       	call   15f8 <fstat>
    1504:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1507:	8b 45 f4             	mov    -0xc(%ebp),%eax
    150a:	89 04 24             	mov    %eax,(%esp)
    150d:	e8 b6 00 00 00       	call   15c8 <close>
  return r;
    1512:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1515:	c9                   	leave  
    1516:	c3                   	ret    

00001517 <atoi>:

int
atoi(const char *s)
{
    1517:	55                   	push   %ebp
    1518:	89 e5                	mov    %esp,%ebp
    151a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    151d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1524:	eb 21                	jmp    1547 <atoi+0x30>
    n = n*10 + *s++ - '0';
    1526:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1529:	89 d0                	mov    %edx,%eax
    152b:	c1 e0 02             	shl    $0x2,%eax
    152e:	01 d0                	add    %edx,%eax
    1530:	d1 e0                	shl    %eax
    1532:	89 c2                	mov    %eax,%edx
    1534:	8b 45 08             	mov    0x8(%ebp),%eax
    1537:	8a 00                	mov    (%eax),%al
    1539:	0f be c0             	movsbl %al,%eax
    153c:	01 d0                	add    %edx,%eax
    153e:	83 e8 30             	sub    $0x30,%eax
    1541:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1544:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1547:	8b 45 08             	mov    0x8(%ebp),%eax
    154a:	8a 00                	mov    (%eax),%al
    154c:	3c 2f                	cmp    $0x2f,%al
    154e:	7e 09                	jle    1559 <atoi+0x42>
    1550:	8b 45 08             	mov    0x8(%ebp),%eax
    1553:	8a 00                	mov    (%eax),%al
    1555:	3c 39                	cmp    $0x39,%al
    1557:	7e cd                	jle    1526 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1559:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    155c:	c9                   	leave  
    155d:	c3                   	ret    

0000155e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    155e:	55                   	push   %ebp
    155f:	89 e5                	mov    %esp,%ebp
    1561:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1564:	8b 45 08             	mov    0x8(%ebp),%eax
    1567:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    156a:	8b 45 0c             	mov    0xc(%ebp),%eax
    156d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1570:	eb 10                	jmp    1582 <memmove+0x24>
    *dst++ = *src++;
    1572:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1575:	8a 10                	mov    (%eax),%dl
    1577:	8b 45 fc             	mov    -0x4(%ebp),%eax
    157a:	88 10                	mov    %dl,(%eax)
    157c:	ff 45 fc             	incl   -0x4(%ebp)
    157f:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1582:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    1586:	0f 9f c0             	setg   %al
    1589:	ff 4d 10             	decl   0x10(%ebp)
    158c:	84 c0                	test   %al,%al
    158e:	75 e2                	jne    1572 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1590:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1593:	c9                   	leave  
    1594:	c3                   	ret    
    1595:	66 90                	xchg   %ax,%ax
    1597:	90                   	nop

00001598 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1598:	b8 01 00 00 00       	mov    $0x1,%eax
    159d:	cd 40                	int    $0x40
    159f:	c3                   	ret    

000015a0 <exit>:
SYSCALL(exit)
    15a0:	b8 02 00 00 00       	mov    $0x2,%eax
    15a5:	cd 40                	int    $0x40
    15a7:	c3                   	ret    

000015a8 <wait>:
SYSCALL(wait)
    15a8:	b8 03 00 00 00       	mov    $0x3,%eax
    15ad:	cd 40                	int    $0x40
    15af:	c3                   	ret    

000015b0 <pipe>:
SYSCALL(pipe)
    15b0:	b8 04 00 00 00       	mov    $0x4,%eax
    15b5:	cd 40                	int    $0x40
    15b7:	c3                   	ret    

000015b8 <read>:
SYSCALL(read)
    15b8:	b8 05 00 00 00       	mov    $0x5,%eax
    15bd:	cd 40                	int    $0x40
    15bf:	c3                   	ret    

000015c0 <write>:
SYSCALL(write)
    15c0:	b8 10 00 00 00       	mov    $0x10,%eax
    15c5:	cd 40                	int    $0x40
    15c7:	c3                   	ret    

000015c8 <close>:
SYSCALL(close)
    15c8:	b8 15 00 00 00       	mov    $0x15,%eax
    15cd:	cd 40                	int    $0x40
    15cf:	c3                   	ret    

000015d0 <kill>:
SYSCALL(kill)
    15d0:	b8 06 00 00 00       	mov    $0x6,%eax
    15d5:	cd 40                	int    $0x40
    15d7:	c3                   	ret    

000015d8 <exec>:
SYSCALL(exec)
    15d8:	b8 07 00 00 00       	mov    $0x7,%eax
    15dd:	cd 40                	int    $0x40
    15df:	c3                   	ret    

000015e0 <open>:
SYSCALL(open)
    15e0:	b8 0f 00 00 00       	mov    $0xf,%eax
    15e5:	cd 40                	int    $0x40
    15e7:	c3                   	ret    

000015e8 <mknod>:
SYSCALL(mknod)
    15e8:	b8 11 00 00 00       	mov    $0x11,%eax
    15ed:	cd 40                	int    $0x40
    15ef:	c3                   	ret    

000015f0 <unlink>:
SYSCALL(unlink)
    15f0:	b8 12 00 00 00       	mov    $0x12,%eax
    15f5:	cd 40                	int    $0x40
    15f7:	c3                   	ret    

000015f8 <fstat>:
SYSCALL(fstat)
    15f8:	b8 08 00 00 00       	mov    $0x8,%eax
    15fd:	cd 40                	int    $0x40
    15ff:	c3                   	ret    

00001600 <link>:
SYSCALL(link)
    1600:	b8 13 00 00 00       	mov    $0x13,%eax
    1605:	cd 40                	int    $0x40
    1607:	c3                   	ret    

00001608 <mkdir>:
SYSCALL(mkdir)
    1608:	b8 14 00 00 00       	mov    $0x14,%eax
    160d:	cd 40                	int    $0x40
    160f:	c3                   	ret    

00001610 <chdir>:
SYSCALL(chdir)
    1610:	b8 09 00 00 00       	mov    $0x9,%eax
    1615:	cd 40                	int    $0x40
    1617:	c3                   	ret    

00001618 <dup>:
SYSCALL(dup)
    1618:	b8 0a 00 00 00       	mov    $0xa,%eax
    161d:	cd 40                	int    $0x40
    161f:	c3                   	ret    

00001620 <getpid>:
SYSCALL(getpid)
    1620:	b8 0b 00 00 00       	mov    $0xb,%eax
    1625:	cd 40                	int    $0x40
    1627:	c3                   	ret    

00001628 <sbrk>:
SYSCALL(sbrk)
    1628:	b8 0c 00 00 00       	mov    $0xc,%eax
    162d:	cd 40                	int    $0x40
    162f:	c3                   	ret    

00001630 <sleep>:
SYSCALL(sleep)
    1630:	b8 0d 00 00 00       	mov    $0xd,%eax
    1635:	cd 40                	int    $0x40
    1637:	c3                   	ret    

00001638 <uptime>:
SYSCALL(uptime)
    1638:	b8 0e 00 00 00       	mov    $0xe,%eax
    163d:	cd 40                	int    $0x40
    163f:	c3                   	ret    

00001640 <cowfork>:
SYSCALL(cowfork) //3.4
    1640:	b8 16 00 00 00       	mov    $0x16,%eax
    1645:	cd 40                	int    $0x40
    1647:	c3                   	ret    

00001648 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1648:	55                   	push   %ebp
    1649:	89 e5                	mov    %esp,%ebp
    164b:	83 ec 28             	sub    $0x28,%esp
    164e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1651:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1654:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    165b:	00 
    165c:	8d 45 f4             	lea    -0xc(%ebp),%eax
    165f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1663:	8b 45 08             	mov    0x8(%ebp),%eax
    1666:	89 04 24             	mov    %eax,(%esp)
    1669:	e8 52 ff ff ff       	call   15c0 <write>
}
    166e:	c9                   	leave  
    166f:	c3                   	ret    

00001670 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1670:	55                   	push   %ebp
    1671:	89 e5                	mov    %esp,%ebp
    1673:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1676:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    167d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1681:	74 17                	je     169a <printint+0x2a>
    1683:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1687:	79 11                	jns    169a <printint+0x2a>
    neg = 1;
    1689:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1690:	8b 45 0c             	mov    0xc(%ebp),%eax
    1693:	f7 d8                	neg    %eax
    1695:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1698:	eb 06                	jmp    16a0 <printint+0x30>
  } else {
    x = xx;
    169a:	8b 45 0c             	mov    0xc(%ebp),%eax
    169d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    16a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    16a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
    16aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16ad:	ba 00 00 00 00       	mov    $0x0,%edx
    16b2:	f7 f1                	div    %ecx
    16b4:	89 d0                	mov    %edx,%eax
    16b6:	8a 80 c8 2d 00 00    	mov    0x2dc8(%eax),%al
    16bc:	8d 4d dc             	lea    -0x24(%ebp),%ecx
    16bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
    16c2:	01 ca                	add    %ecx,%edx
    16c4:	88 02                	mov    %al,(%edx)
    16c6:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
    16c9:	8b 55 10             	mov    0x10(%ebp),%edx
    16cc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    16cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16d2:	ba 00 00 00 00       	mov    $0x0,%edx
    16d7:	f7 75 d4             	divl   -0x2c(%ebp)
    16da:	89 45 ec             	mov    %eax,-0x14(%ebp)
    16dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    16e1:	75 c4                	jne    16a7 <printint+0x37>
  if(neg)
    16e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    16e7:	74 2c                	je     1715 <printint+0xa5>
    buf[i++] = '-';
    16e9:	8d 55 dc             	lea    -0x24(%ebp),%edx
    16ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16ef:	01 d0                	add    %edx,%eax
    16f1:	c6 00 2d             	movb   $0x2d,(%eax)
    16f4:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
    16f7:	eb 1c                	jmp    1715 <printint+0xa5>
    putc(fd, buf[i]);
    16f9:	8d 55 dc             	lea    -0x24(%ebp),%edx
    16fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16ff:	01 d0                	add    %edx,%eax
    1701:	8a 00                	mov    (%eax),%al
    1703:	0f be c0             	movsbl %al,%eax
    1706:	89 44 24 04          	mov    %eax,0x4(%esp)
    170a:	8b 45 08             	mov    0x8(%ebp),%eax
    170d:	89 04 24             	mov    %eax,(%esp)
    1710:	e8 33 ff ff ff       	call   1648 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1715:	ff 4d f4             	decl   -0xc(%ebp)
    1718:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    171c:	79 db                	jns    16f9 <printint+0x89>
    putc(fd, buf[i]);
}
    171e:	c9                   	leave  
    171f:	c3                   	ret    

00001720 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1720:	55                   	push   %ebp
    1721:	89 e5                	mov    %esp,%ebp
    1723:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1726:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    172d:	8d 45 0c             	lea    0xc(%ebp),%eax
    1730:	83 c0 04             	add    $0x4,%eax
    1733:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1736:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    173d:	e9 78 01 00 00       	jmp    18ba <printf+0x19a>
    c = fmt[i] & 0xff;
    1742:	8b 55 0c             	mov    0xc(%ebp),%edx
    1745:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1748:	01 d0                	add    %edx,%eax
    174a:	8a 00                	mov    (%eax),%al
    174c:	0f be c0             	movsbl %al,%eax
    174f:	25 ff 00 00 00       	and    $0xff,%eax
    1754:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1757:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    175b:	75 2c                	jne    1789 <printf+0x69>
      if(c == '%'){
    175d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1761:	75 0c                	jne    176f <printf+0x4f>
        state = '%';
    1763:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    176a:	e9 48 01 00 00       	jmp    18b7 <printf+0x197>
      } else {
        putc(fd, c);
    176f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1772:	0f be c0             	movsbl %al,%eax
    1775:	89 44 24 04          	mov    %eax,0x4(%esp)
    1779:	8b 45 08             	mov    0x8(%ebp),%eax
    177c:	89 04 24             	mov    %eax,(%esp)
    177f:	e8 c4 fe ff ff       	call   1648 <putc>
    1784:	e9 2e 01 00 00       	jmp    18b7 <printf+0x197>
      }
    } else if(state == '%'){
    1789:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    178d:	0f 85 24 01 00 00    	jne    18b7 <printf+0x197>
      if(c == 'd'){
    1793:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1797:	75 2d                	jne    17c6 <printf+0xa6>
        printint(fd, *ap, 10, 1);
    1799:	8b 45 e8             	mov    -0x18(%ebp),%eax
    179c:	8b 00                	mov    (%eax),%eax
    179e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    17a5:	00 
    17a6:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    17ad:	00 
    17ae:	89 44 24 04          	mov    %eax,0x4(%esp)
    17b2:	8b 45 08             	mov    0x8(%ebp),%eax
    17b5:	89 04 24             	mov    %eax,(%esp)
    17b8:	e8 b3 fe ff ff       	call   1670 <printint>
        ap++;
    17bd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    17c1:	e9 ea 00 00 00       	jmp    18b0 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
    17c6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    17ca:	74 06                	je     17d2 <printf+0xb2>
    17cc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    17d0:	75 2d                	jne    17ff <printf+0xdf>
        printint(fd, *ap, 16, 0);
    17d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17d5:	8b 00                	mov    (%eax),%eax
    17d7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    17de:	00 
    17df:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    17e6:	00 
    17e7:	89 44 24 04          	mov    %eax,0x4(%esp)
    17eb:	8b 45 08             	mov    0x8(%ebp),%eax
    17ee:	89 04 24             	mov    %eax,(%esp)
    17f1:	e8 7a fe ff ff       	call   1670 <printint>
        ap++;
    17f6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    17fa:	e9 b1 00 00 00       	jmp    18b0 <printf+0x190>
      } else if(c == 's'){
    17ff:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1803:	75 43                	jne    1848 <printf+0x128>
        s = (char*)*ap;
    1805:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1808:	8b 00                	mov    (%eax),%eax
    180a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    180d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1811:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1815:	75 25                	jne    183c <printf+0x11c>
          s = "(null)";
    1817:	c7 45 f4 31 1b 00 00 	movl   $0x1b31,-0xc(%ebp)
        while(*s != 0){
    181e:	eb 1c                	jmp    183c <printf+0x11c>
          putc(fd, *s);
    1820:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1823:	8a 00                	mov    (%eax),%al
    1825:	0f be c0             	movsbl %al,%eax
    1828:	89 44 24 04          	mov    %eax,0x4(%esp)
    182c:	8b 45 08             	mov    0x8(%ebp),%eax
    182f:	89 04 24             	mov    %eax,(%esp)
    1832:	e8 11 fe ff ff       	call   1648 <putc>
          s++;
    1837:	ff 45 f4             	incl   -0xc(%ebp)
    183a:	eb 01                	jmp    183d <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    183c:	90                   	nop
    183d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1840:	8a 00                	mov    (%eax),%al
    1842:	84 c0                	test   %al,%al
    1844:	75 da                	jne    1820 <printf+0x100>
    1846:	eb 68                	jmp    18b0 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1848:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    184c:	75 1d                	jne    186b <printf+0x14b>
        putc(fd, *ap);
    184e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1851:	8b 00                	mov    (%eax),%eax
    1853:	0f be c0             	movsbl %al,%eax
    1856:	89 44 24 04          	mov    %eax,0x4(%esp)
    185a:	8b 45 08             	mov    0x8(%ebp),%eax
    185d:	89 04 24             	mov    %eax,(%esp)
    1860:	e8 e3 fd ff ff       	call   1648 <putc>
        ap++;
    1865:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1869:	eb 45                	jmp    18b0 <printf+0x190>
      } else if(c == '%'){
    186b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    186f:	75 17                	jne    1888 <printf+0x168>
        putc(fd, c);
    1871:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1874:	0f be c0             	movsbl %al,%eax
    1877:	89 44 24 04          	mov    %eax,0x4(%esp)
    187b:	8b 45 08             	mov    0x8(%ebp),%eax
    187e:	89 04 24             	mov    %eax,(%esp)
    1881:	e8 c2 fd ff ff       	call   1648 <putc>
    1886:	eb 28                	jmp    18b0 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1888:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    188f:	00 
    1890:	8b 45 08             	mov    0x8(%ebp),%eax
    1893:	89 04 24             	mov    %eax,(%esp)
    1896:	e8 ad fd ff ff       	call   1648 <putc>
        putc(fd, c);
    189b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    189e:	0f be c0             	movsbl %al,%eax
    18a1:	89 44 24 04          	mov    %eax,0x4(%esp)
    18a5:	8b 45 08             	mov    0x8(%ebp),%eax
    18a8:	89 04 24             	mov    %eax,(%esp)
    18ab:	e8 98 fd ff ff       	call   1648 <putc>
      }
      state = 0;
    18b0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    18b7:	ff 45 f0             	incl   -0x10(%ebp)
    18ba:	8b 55 0c             	mov    0xc(%ebp),%edx
    18bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18c0:	01 d0                	add    %edx,%eax
    18c2:	8a 00                	mov    (%eax),%al
    18c4:	84 c0                	test   %al,%al
    18c6:	0f 85 76 fe ff ff    	jne    1742 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    18cc:	c9                   	leave  
    18cd:	c3                   	ret    
    18ce:	66 90                	xchg   %ax,%ax

000018d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    18d0:	55                   	push   %ebp
    18d1:	89 e5                	mov    %esp,%ebp
    18d3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    18d6:	8b 45 08             	mov    0x8(%ebp),%eax
    18d9:	83 e8 08             	sub    $0x8,%eax
    18dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    18df:	a1 f4 2d 00 00       	mov    0x2df4,%eax
    18e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    18e7:	eb 24                	jmp    190d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    18e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18ec:	8b 00                	mov    (%eax),%eax
    18ee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    18f1:	77 12                	ja     1905 <free+0x35>
    18f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18f6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    18f9:	77 24                	ja     191f <free+0x4f>
    18fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18fe:	8b 00                	mov    (%eax),%eax
    1900:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1903:	77 1a                	ja     191f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1905:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1908:	8b 00                	mov    (%eax),%eax
    190a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    190d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1910:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1913:	76 d4                	jbe    18e9 <free+0x19>
    1915:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1918:	8b 00                	mov    (%eax),%eax
    191a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    191d:	76 ca                	jbe    18e9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    191f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1922:	8b 40 04             	mov    0x4(%eax),%eax
    1925:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    192c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    192f:	01 c2                	add    %eax,%edx
    1931:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1934:	8b 00                	mov    (%eax),%eax
    1936:	39 c2                	cmp    %eax,%edx
    1938:	75 24                	jne    195e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    193a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    193d:	8b 50 04             	mov    0x4(%eax),%edx
    1940:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1943:	8b 00                	mov    (%eax),%eax
    1945:	8b 40 04             	mov    0x4(%eax),%eax
    1948:	01 c2                	add    %eax,%edx
    194a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    194d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1950:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1953:	8b 00                	mov    (%eax),%eax
    1955:	8b 10                	mov    (%eax),%edx
    1957:	8b 45 f8             	mov    -0x8(%ebp),%eax
    195a:	89 10                	mov    %edx,(%eax)
    195c:	eb 0a                	jmp    1968 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    195e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1961:	8b 10                	mov    (%eax),%edx
    1963:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1966:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1968:	8b 45 fc             	mov    -0x4(%ebp),%eax
    196b:	8b 40 04             	mov    0x4(%eax),%eax
    196e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1975:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1978:	01 d0                	add    %edx,%eax
    197a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    197d:	75 20                	jne    199f <free+0xcf>
    p->s.size += bp->s.size;
    197f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1982:	8b 50 04             	mov    0x4(%eax),%edx
    1985:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1988:	8b 40 04             	mov    0x4(%eax),%eax
    198b:	01 c2                	add    %eax,%edx
    198d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1990:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1993:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1996:	8b 10                	mov    (%eax),%edx
    1998:	8b 45 fc             	mov    -0x4(%ebp),%eax
    199b:	89 10                	mov    %edx,(%eax)
    199d:	eb 08                	jmp    19a7 <free+0xd7>
  } else
    p->s.ptr = bp;
    199f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19a2:	8b 55 f8             	mov    -0x8(%ebp),%edx
    19a5:	89 10                	mov    %edx,(%eax)
  freep = p;
    19a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19aa:	a3 f4 2d 00 00       	mov    %eax,0x2df4
}
    19af:	c9                   	leave  
    19b0:	c3                   	ret    

000019b1 <morecore>:

static Header*
morecore(uint nu)
{
    19b1:	55                   	push   %ebp
    19b2:	89 e5                	mov    %esp,%ebp
    19b4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    19b7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    19be:	77 07                	ja     19c7 <morecore+0x16>
    nu = 4096;
    19c0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    19c7:	8b 45 08             	mov    0x8(%ebp),%eax
    19ca:	c1 e0 03             	shl    $0x3,%eax
    19cd:	89 04 24             	mov    %eax,(%esp)
    19d0:	e8 53 fc ff ff       	call   1628 <sbrk>
    19d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    19d8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    19dc:	75 07                	jne    19e5 <morecore+0x34>
    return 0;
    19de:	b8 00 00 00 00       	mov    $0x0,%eax
    19e3:	eb 22                	jmp    1a07 <morecore+0x56>
  hp = (Header*)p;
    19e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    19eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19ee:	8b 55 08             	mov    0x8(%ebp),%edx
    19f1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    19f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19f7:	83 c0 08             	add    $0x8,%eax
    19fa:	89 04 24             	mov    %eax,(%esp)
    19fd:	e8 ce fe ff ff       	call   18d0 <free>
  return freep;
    1a02:	a1 f4 2d 00 00       	mov    0x2df4,%eax
}
    1a07:	c9                   	leave  
    1a08:	c3                   	ret    

00001a09 <malloc>:

void*
malloc(uint nbytes)
{
    1a09:	55                   	push   %ebp
    1a0a:	89 e5                	mov    %esp,%ebp
    1a0c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1a0f:	8b 45 08             	mov    0x8(%ebp),%eax
    1a12:	83 c0 07             	add    $0x7,%eax
    1a15:	c1 e8 03             	shr    $0x3,%eax
    1a18:	40                   	inc    %eax
    1a19:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1a1c:	a1 f4 2d 00 00       	mov    0x2df4,%eax
    1a21:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1a24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1a28:	75 23                	jne    1a4d <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    1a2a:	c7 45 f0 ec 2d 00 00 	movl   $0x2dec,-0x10(%ebp)
    1a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a34:	a3 f4 2d 00 00       	mov    %eax,0x2df4
    1a39:	a1 f4 2d 00 00       	mov    0x2df4,%eax
    1a3e:	a3 ec 2d 00 00       	mov    %eax,0x2dec
    base.s.size = 0;
    1a43:	c7 05 f0 2d 00 00 00 	movl   $0x0,0x2df0
    1a4a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a50:	8b 00                	mov    (%eax),%eax
    1a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a58:	8b 40 04             	mov    0x4(%eax),%eax
    1a5b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1a5e:	72 4d                	jb     1aad <malloc+0xa4>
      if(p->s.size == nunits)
    1a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a63:	8b 40 04             	mov    0x4(%eax),%eax
    1a66:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1a69:	75 0c                	jne    1a77 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    1a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a6e:	8b 10                	mov    (%eax),%edx
    1a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a73:	89 10                	mov    %edx,(%eax)
    1a75:	eb 26                	jmp    1a9d <malloc+0x94>
      else {
        p->s.size -= nunits;
    1a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a7a:	8b 40 04             	mov    0x4(%eax),%eax
    1a7d:	89 c2                	mov    %eax,%edx
    1a7f:	2b 55 ec             	sub    -0x14(%ebp),%edx
    1a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a85:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a8b:	8b 40 04             	mov    0x4(%eax),%eax
    1a8e:	c1 e0 03             	shl    $0x3,%eax
    1a91:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a97:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1a9a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1aa0:	a3 f4 2d 00 00       	mov    %eax,0x2df4
      return (void*)(p + 1);
    1aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aa8:	83 c0 08             	add    $0x8,%eax
    1aab:	eb 38                	jmp    1ae5 <malloc+0xdc>
    }
    if(p == freep)
    1aad:	a1 f4 2d 00 00       	mov    0x2df4,%eax
    1ab2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1ab5:	75 1b                	jne    1ad2 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    1ab7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1aba:	89 04 24             	mov    %eax,(%esp)
    1abd:	e8 ef fe ff ff       	call   19b1 <morecore>
    1ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1ac5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1ac9:	75 07                	jne    1ad2 <malloc+0xc9>
        return 0;
    1acb:	b8 00 00 00 00       	mov    $0x0,%eax
    1ad0:	eb 13                	jmp    1ae5 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ad5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1adb:	8b 00                	mov    (%eax),%eax
    1add:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1ae0:	e9 70 ff ff ff       	jmp    1a55 <malloc+0x4c>
}
    1ae5:	c9                   	leave  
    1ae6:	c3                   	ret    
