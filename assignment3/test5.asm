
_test5:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	53                   	push   %ebx
    1004:	83 e4 f0             	and    $0xfffffff0,%esp
    1007:	83 ec 20             	sub    $0x20,%esp
    int pid;

	printf(1,"allocationg a value in parent\n",getpid());
    100a:	e8 d9 06 00 00       	call   16e8 <getpid>
    100f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1013:	c7 44 24 04 b0 1b 00 	movl   $0x1bb0,0x4(%esp)
    101a:	00 
    101b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1022:	e8 c1 07 00 00       	call   17e8 <printf>
	int* value = malloc(sizeof(int));
    1027:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
    102e:	e8 9e 0a 00 00       	call   1ad1 <malloc>
    1033:	89 44 24 1c          	mov    %eax,0x1c(%esp)
	*value = 99999;
    1037:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    103b:	c7 00 9f 86 01 00    	movl   $0x1869f,(%eax)
	printf(1,"value's address: %p\n", value);
    1041:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1045:	89 44 24 08          	mov    %eax,0x8(%esp)
    1049:	c7 44 24 04 cf 1b 00 	movl   $0x1bcf,0x4(%esp)
    1050:	00 
    1051:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1058:	e8 8b 07 00 00       	call   17e8 <printf>
	printf(1,"value = %d\n",*value);
    105d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1061:	8b 00                	mov    (%eax),%eax
    1063:	89 44 24 08          	mov    %eax,0x8(%esp)
    1067:	c7 44 24 04 e4 1b 00 	movl   $0x1be4,0x4(%esp)
    106e:	00 
    106f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1076:	e8 6d 07 00 00       	call   17e8 <printf>

	printf(1,"Parent %d is forking a child using fork()\n",getpid());
    107b:	e8 68 06 00 00       	call   16e8 <getpid>
    1080:	89 44 24 08          	mov    %eax,0x8(%esp)
    1084:	c7 44 24 04 f0 1b 00 	movl   $0x1bf0,0x4(%esp)
    108b:	00 
    108c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1093:	e8 50 07 00 00       	call   17e8 <printf>
	if (fork() == 0) {
    1098:	e8 c3 05 00 00       	call   1660 <fork>
    109d:	85 c0                	test   %eax,%eax
    109f:	75 53                	jne    10f4 <main+0xf4>
		printf(1, "child %d value's address is: %p\n", getpid(), value);
    10a1:	e8 42 06 00 00       	call   16e8 <getpid>
    10a6:	8b 54 24 1c          	mov    0x1c(%esp),%edx
    10aa:	89 54 24 0c          	mov    %edx,0xc(%esp)
    10ae:	89 44 24 08          	mov    %eax,0x8(%esp)
    10b2:	c7 44 24 04 1c 1c 00 	movl   $0x1c1c,0x4(%esp)
    10b9:	00 
    10ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10c1:	e8 22 07 00 00       	call   17e8 <printf>
		printf(1, "child %d is only sleeping, press ^p\n", getpid());
    10c6:	e8 1d 06 00 00       	call   16e8 <getpid>
    10cb:	89 44 24 08          	mov    %eax,0x8(%esp)
    10cf:	c7 44 24 04 40 1c 00 	movl   $0x1c40,0x4(%esp)
    10d6:	00 
    10d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10de:	e8 05 07 00 00       	call   17e8 <printf>
		sleep(500);
    10e3:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
    10ea:	e8 09 06 00 00       	call   16f8 <sleep>
		/*goto done;*/
        exit();
    10ef:	e8 74 05 00 00       	call   1668 <exit>
	} 

    pid = wait();
    10f4:	e8 77 05 00 00       	call   1670 <wait>
    10f9:	89 44 24 18          	mov    %eax,0x18(%esp)
    printf(1,"\nchild %d is dead, let's continue\n\n",pid);
    10fd:	8b 44 24 18          	mov    0x18(%esp),%eax
    1101:	89 44 24 08          	mov    %eax,0x8(%esp)
    1105:	c7 44 24 04 68 1c 00 	movl   $0x1c68,0x4(%esp)
    110c:	00 
    110d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1114:	e8 cf 06 00 00       	call   17e8 <printf>
    sleep(100);
    1119:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
    1120:	e8 d3 05 00 00       	call   16f8 <sleep>

    printf(1,"Parent %d is forking another child using cowfork()\n",getpid());
    1125:	e8 be 05 00 00       	call   16e8 <getpid>
    112a:	89 44 24 08          	mov    %eax,0x8(%esp)
    112e:	c7 44 24 04 8c 1c 00 	movl   $0x1c8c,0x4(%esp)
    1135:	00 
    1136:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    113d:	e8 a6 06 00 00       	call   17e8 <printf>
    if (cowfork() == 0) {
    1142:	e8 c1 05 00 00       	call   1708 <cowfork>
    1147:	85 c0                	test   %eax,%eax
    1149:	75 53                	jne    119e <main+0x19e>
        printf(1, "child %d value's address is: %p\n", getpid(), value);
    114b:	e8 98 05 00 00       	call   16e8 <getpid>
    1150:	8b 54 24 1c          	mov    0x1c(%esp),%edx
    1154:	89 54 24 0c          	mov    %edx,0xc(%esp)
    1158:	89 44 24 08          	mov    %eax,0x8(%esp)
    115c:	c7 44 24 04 1c 1c 00 	movl   $0x1c1c,0x4(%esp)
    1163:	00 
    1164:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    116b:	e8 78 06 00 00       	call   17e8 <printf>
        printf(1, "child %d is only sleeping, press ^p\n", getpid());
    1170:	e8 73 05 00 00       	call   16e8 <getpid>
    1175:	89 44 24 08          	mov    %eax,0x8(%esp)
    1179:	c7 44 24 04 40 1c 00 	movl   $0x1c40,0x4(%esp)
    1180:	00 
    1181:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1188:	e8 5b 06 00 00       	call   17e8 <printf>
        sleep(500);
    118d:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
    1194:	e8 5f 05 00 00       	call   16f8 <sleep>
        /*goto done;*/
        exit();
    1199:	e8 ca 04 00 00       	call   1668 <exit>
    }

    pid = wait();
    119e:	e8 cd 04 00 00       	call   1670 <wait>
    11a3:	89 44 24 18          	mov    %eax,0x18(%esp)
    printf(1,"\nchild %d is dead, let's continue\n\n",pid);
    11a7:	8b 44 24 18          	mov    0x18(%esp),%eax
    11ab:	89 44 24 08          	mov    %eax,0x8(%esp)
    11af:	c7 44 24 04 68 1c 00 	movl   $0x1c68,0x4(%esp)
    11b6:	00 
    11b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11be:	e8 25 06 00 00       	call   17e8 <printf>
    sleep(100);
    11c3:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
    11ca:	e8 29 05 00 00       	call   16f8 <sleep>

    printf(1,"Parent %d is forking another child using cowfork()\n",getpid());
    11cf:	e8 14 05 00 00       	call   16e8 <getpid>
    11d4:	89 44 24 08          	mov    %eax,0x8(%esp)
    11d8:	c7 44 24 04 8c 1c 00 	movl   $0x1c8c,0x4(%esp)
    11df:	00 
    11e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11e7:	e8 fc 05 00 00       	call   17e8 <printf>
    if (cowfork() == 0) {
    11ec:	e8 17 05 00 00       	call   1708 <cowfork>
    11f1:	85 c0                	test   %eax,%eax
    11f3:	0f 85 a9 00 00 00    	jne    12a2 <main+0x2a2>
        printf(1, "child %d value's address is: %p\n", getpid(), value);
    11f9:	e8 ea 04 00 00       	call   16e8 <getpid>
    11fe:	8b 54 24 1c          	mov    0x1c(%esp),%edx
    1202:	89 54 24 0c          	mov    %edx,0xc(%esp)
    1206:	89 44 24 08          	mov    %eax,0x8(%esp)
    120a:	c7 44 24 04 1c 1c 00 	movl   $0x1c1c,0x4(%esp)
    1211:	00 
    1212:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1219:	e8 ca 05 00 00       	call   17e8 <printf>
        *value = 11111;
    121e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1222:	c7 00 67 2b 00 00    	movl   $0x2b67,(%eax)
        printf(1, "child %d changed the value, now value = %d\n", getpid(),*value);
    1228:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    122c:	8b 18                	mov    (%eax),%ebx
    122e:	e8 b5 04 00 00       	call   16e8 <getpid>
    1233:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    1237:	89 44 24 08          	mov    %eax,0x8(%esp)
    123b:	c7 44 24 04 c0 1c 00 	movl   $0x1cc0,0x4(%esp)
    1242:	00 
    1243:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    124a:	e8 99 05 00 00       	call   17e8 <printf>
        printf(1, "child %d value's address is: %p\n", getpid(), value);
    124f:	e8 94 04 00 00       	call   16e8 <getpid>
    1254:	8b 54 24 1c          	mov    0x1c(%esp),%edx
    1258:	89 54 24 0c          	mov    %edx,0xc(%esp)
    125c:	89 44 24 08          	mov    %eax,0x8(%esp)
    1260:	c7 44 24 04 1c 1c 00 	movl   $0x1c1c,0x4(%esp)
    1267:	00 
    1268:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    126f:	e8 74 05 00 00       	call   17e8 <printf>
        printf(1, "child %d is now sleeping, press ^p\n", getpid());
    1274:	e8 6f 04 00 00       	call   16e8 <getpid>
    1279:	89 44 24 08          	mov    %eax,0x8(%esp)
    127d:	c7 44 24 04 ec 1c 00 	movl   $0x1cec,0x4(%esp)
    1284:	00 
    1285:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    128c:	e8 57 05 00 00       	call   17e8 <printf>
        sleep(500);
    1291:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
    1298:	e8 5b 04 00 00       	call   16f8 <sleep>
        /*goto done;*/
        exit();
    129d:	e8 c6 03 00 00       	call   1668 <exit>
    }

    pid = wait();
    12a2:	e8 c9 03 00 00       	call   1670 <wait>
    12a7:	89 44 24 18          	mov    %eax,0x18(%esp)

    printf(1,"\nchild %d is dead, let's continue\n",pid);
    12ab:	8b 44 24 18          	mov    0x18(%esp),%eax
    12af:	89 44 24 08          	mov    %eax,0x8(%esp)
    12b3:	c7 44 24 04 10 1d 00 	movl   $0x1d10,0x4(%esp)
    12ba:	00 
    12bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12c2:	e8 21 05 00 00       	call   17e8 <printf>
    printf(1,"******Parent %d is forking 2 childs using cowfork()******\n",getpid());
    12c7:	e8 1c 04 00 00       	call   16e8 <getpid>
    12cc:	89 44 24 08          	mov    %eax,0x8(%esp)
    12d0:	c7 44 24 04 34 1d 00 	movl   $0x1d34,0x4(%esp)
    12d7:	00 
    12d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12df:	e8 04 05 00 00       	call   17e8 <printf>

    if ((pid = cowfork()) == 0) {
    12e4:	e8 1f 04 00 00       	call   1708 <cowfork>
    12e9:	89 44 24 18          	mov    %eax,0x18(%esp)
    12ed:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
    12f2:	75 7d                	jne    1371 <main+0x371>
        printf(1, "child %d value's address is: %p\n", getpid(), value);
    12f4:	e8 ef 03 00 00       	call   16e8 <getpid>
    12f9:	8b 54 24 1c          	mov    0x1c(%esp),%edx
    12fd:	89 54 24 0c          	mov    %edx,0xc(%esp)
    1301:	89 44 24 08          	mov    %eax,0x8(%esp)
    1305:	c7 44 24 04 1c 1c 00 	movl   $0x1c1c,0x4(%esp)
    130c:	00 
    130d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1314:	e8 cf 04 00 00       	call   17e8 <printf>
        *value = 22222;
    1319:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    131d:	c7 00 ce 56 00 00    	movl   $0x56ce,(%eax)
        printf(1, "child %d changed the value, now value = %d\n", getpid(),*value);
    1323:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    1327:	8b 18                	mov    (%eax),%ebx
    1329:	e8 ba 03 00 00       	call   16e8 <getpid>
    132e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
    1332:	89 44 24 08          	mov    %eax,0x8(%esp)
    1336:	c7 44 24 04 c0 1c 00 	movl   $0x1cc0,0x4(%esp)
    133d:	00 
    133e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1345:	e8 9e 04 00 00       	call   17e8 <printf>
        printf(1, "child %d value's address is: %p\n", getpid(), value);
    134a:	e8 99 03 00 00       	call   16e8 <getpid>
    134f:	8b 54 24 1c          	mov    0x1c(%esp),%edx
    1353:	89 54 24 0c          	mov    %edx,0xc(%esp)
    1357:	89 44 24 08          	mov    %eax,0x8(%esp)
    135b:	c7 44 24 04 1c 1c 00 	movl   $0x1c1c,0x4(%esp)
    1362:	00 
    1363:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    136a:	e8 79 04 00 00       	call   17e8 <printf>
        while(1)
        {}
    136f:	eb fe                	jmp    136f <main+0x36f>
        exit();
    }
    if (cowfork() == 0) {
    1371:	e8 92 03 00 00       	call   1708 <cowfork>
    1376:	85 c0                	test   %eax,%eax
    1378:	75 3a                	jne    13b4 <main+0x3b4>

        printf(1, "child %d is now sleeping, press ^p\n", getpid());
    137a:	e8 69 03 00 00       	call   16e8 <getpid>
    137f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1383:	c7 44 24 04 ec 1c 00 	movl   $0x1cec,0x4(%esp)
    138a:	00 
    138b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1392:	e8 51 04 00 00       	call   17e8 <printf>
        sleep(500);
    1397:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
    139e:	e8 55 03 00 00       	call   16f8 <sleep>
        kill(pid);
    13a3:	8b 44 24 18          	mov    0x18(%esp),%eax
    13a7:	89 04 24             	mov    %eax,(%esp)
    13aa:	e8 e9 02 00 00       	call   1698 <kill>
        exit();
    13af:	e8 b4 02 00 00       	call   1668 <exit>
    } 
    printf(1,"\nparent %d is wating for nothing\n",pid);
    13b4:	8b 44 24 18          	mov    0x18(%esp),%eax
    13b8:	89 44 24 08          	mov    %eax,0x8(%esp)
    13bc:	c7 44 24 04 70 1d 00 	movl   $0x1d70,0x4(%esp)
    13c3:	00 
    13c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13cb:	e8 18 04 00 00       	call   17e8 <printf>
    wait();
    13d0:	e8 9b 02 00 00       	call   1670 <wait>
    wait();
    13d5:	e8 96 02 00 00       	call   1670 <wait>

    printf(1,"\nchild %d is dead, let's finish\n",pid);
    13da:	8b 44 24 18          	mov    0x18(%esp),%eax
    13de:	89 44 24 08          	mov    %eax,0x8(%esp)
    13e2:	c7 44 24 04 94 1d 00 	movl   $0x1d94,0x4(%esp)
    13e9:	00 
    13ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13f1:	e8 f2 03 00 00       	call   17e8 <printf>
    printf(1,"all kids are dead");
    13f6:	c7 44 24 04 b5 1d 00 	movl   $0x1db5,0x4(%esp)
    13fd:	00 
    13fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1405:	e8 de 03 00 00       	call   17e8 <printf>
    sleep(200);
    140a:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
    1411:	e8 e2 02 00 00       	call   16f8 <sleep>

    exit();
    1416:	e8 4d 02 00 00       	call   1668 <exit>
    141b:	90                   	nop

0000141c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    141c:	55                   	push   %ebp
    141d:	89 e5                	mov    %esp,%ebp
    141f:	57                   	push   %edi
    1420:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1421:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1424:	8b 55 10             	mov    0x10(%ebp),%edx
    1427:	8b 45 0c             	mov    0xc(%ebp),%eax
    142a:	89 cb                	mov    %ecx,%ebx
    142c:	89 df                	mov    %ebx,%edi
    142e:	89 d1                	mov    %edx,%ecx
    1430:	fc                   	cld    
    1431:	f3 aa                	rep stos %al,%es:(%edi)
    1433:	89 ca                	mov    %ecx,%edx
    1435:	89 fb                	mov    %edi,%ebx
    1437:	89 5d 08             	mov    %ebx,0x8(%ebp)
    143a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    143d:	5b                   	pop    %ebx
    143e:	5f                   	pop    %edi
    143f:	5d                   	pop    %ebp
    1440:	c3                   	ret    

00001441 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1441:	55                   	push   %ebp
    1442:	89 e5                	mov    %esp,%ebp
    1444:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1447:	8b 45 08             	mov    0x8(%ebp),%eax
    144a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    144d:	90                   	nop
    144e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1451:	8a 10                	mov    (%eax),%dl
    1453:	8b 45 08             	mov    0x8(%ebp),%eax
    1456:	88 10                	mov    %dl,(%eax)
    1458:	8b 45 08             	mov    0x8(%ebp),%eax
    145b:	8a 00                	mov    (%eax),%al
    145d:	84 c0                	test   %al,%al
    145f:	0f 95 c0             	setne  %al
    1462:	ff 45 08             	incl   0x8(%ebp)
    1465:	ff 45 0c             	incl   0xc(%ebp)
    1468:	84 c0                	test   %al,%al
    146a:	75 e2                	jne    144e <strcpy+0xd>
    ;
  return os;
    146c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    146f:	c9                   	leave  
    1470:	c3                   	ret    

00001471 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1471:	55                   	push   %ebp
    1472:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1474:	eb 06                	jmp    147c <strcmp+0xb>
    p++, q++;
    1476:	ff 45 08             	incl   0x8(%ebp)
    1479:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    147c:	8b 45 08             	mov    0x8(%ebp),%eax
    147f:	8a 00                	mov    (%eax),%al
    1481:	84 c0                	test   %al,%al
    1483:	74 0e                	je     1493 <strcmp+0x22>
    1485:	8b 45 08             	mov    0x8(%ebp),%eax
    1488:	8a 10                	mov    (%eax),%dl
    148a:	8b 45 0c             	mov    0xc(%ebp),%eax
    148d:	8a 00                	mov    (%eax),%al
    148f:	38 c2                	cmp    %al,%dl
    1491:	74 e3                	je     1476 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1493:	8b 45 08             	mov    0x8(%ebp),%eax
    1496:	8a 00                	mov    (%eax),%al
    1498:	0f b6 d0             	movzbl %al,%edx
    149b:	8b 45 0c             	mov    0xc(%ebp),%eax
    149e:	8a 00                	mov    (%eax),%al
    14a0:	0f b6 c0             	movzbl %al,%eax
    14a3:	89 d1                	mov    %edx,%ecx
    14a5:	29 c1                	sub    %eax,%ecx
    14a7:	89 c8                	mov    %ecx,%eax
}
    14a9:	5d                   	pop    %ebp
    14aa:	c3                   	ret    

000014ab <strlen>:

uint
strlen(char *s)
{
    14ab:	55                   	push   %ebp
    14ac:	89 e5                	mov    %esp,%ebp
    14ae:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    14b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    14b8:	eb 03                	jmp    14bd <strlen+0x12>
    14ba:	ff 45 fc             	incl   -0x4(%ebp)
    14bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
    14c0:	8b 45 08             	mov    0x8(%ebp),%eax
    14c3:	01 d0                	add    %edx,%eax
    14c5:	8a 00                	mov    (%eax),%al
    14c7:	84 c0                	test   %al,%al
    14c9:	75 ef                	jne    14ba <strlen+0xf>
    ;
  return n;
    14cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    14ce:	c9                   	leave  
    14cf:	c3                   	ret    

000014d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    14d0:	55                   	push   %ebp
    14d1:	89 e5                	mov    %esp,%ebp
    14d3:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    14d6:	8b 45 10             	mov    0x10(%ebp),%eax
    14d9:	89 44 24 08          	mov    %eax,0x8(%esp)
    14dd:	8b 45 0c             	mov    0xc(%ebp),%eax
    14e0:	89 44 24 04          	mov    %eax,0x4(%esp)
    14e4:	8b 45 08             	mov    0x8(%ebp),%eax
    14e7:	89 04 24             	mov    %eax,(%esp)
    14ea:	e8 2d ff ff ff       	call   141c <stosb>
  return dst;
    14ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
    14f2:	c9                   	leave  
    14f3:	c3                   	ret    

000014f4 <strchr>:

char*
strchr(const char *s, char c)
{
    14f4:	55                   	push   %ebp
    14f5:	89 e5                	mov    %esp,%ebp
    14f7:	83 ec 04             	sub    $0x4,%esp
    14fa:	8b 45 0c             	mov    0xc(%ebp),%eax
    14fd:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1500:	eb 12                	jmp    1514 <strchr+0x20>
    if(*s == c)
    1502:	8b 45 08             	mov    0x8(%ebp),%eax
    1505:	8a 00                	mov    (%eax),%al
    1507:	3a 45 fc             	cmp    -0x4(%ebp),%al
    150a:	75 05                	jne    1511 <strchr+0x1d>
      return (char*)s;
    150c:	8b 45 08             	mov    0x8(%ebp),%eax
    150f:	eb 11                	jmp    1522 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1511:	ff 45 08             	incl   0x8(%ebp)
    1514:	8b 45 08             	mov    0x8(%ebp),%eax
    1517:	8a 00                	mov    (%eax),%al
    1519:	84 c0                	test   %al,%al
    151b:	75 e5                	jne    1502 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    151d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1522:	c9                   	leave  
    1523:	c3                   	ret    

00001524 <gets>:

char*
gets(char *buf, int max)
{
    1524:	55                   	push   %ebp
    1525:	89 e5                	mov    %esp,%ebp
    1527:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    152a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1531:	eb 42                	jmp    1575 <gets+0x51>
    cc = read(0, &c, 1);
    1533:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    153a:	00 
    153b:	8d 45 ef             	lea    -0x11(%ebp),%eax
    153e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1542:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1549:	e8 32 01 00 00       	call   1680 <read>
    154e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1551:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1555:	7e 29                	jle    1580 <gets+0x5c>
      break;
    buf[i++] = c;
    1557:	8b 55 f4             	mov    -0xc(%ebp),%edx
    155a:	8b 45 08             	mov    0x8(%ebp),%eax
    155d:	01 c2                	add    %eax,%edx
    155f:	8a 45 ef             	mov    -0x11(%ebp),%al
    1562:	88 02                	mov    %al,(%edx)
    1564:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
    1567:	8a 45 ef             	mov    -0x11(%ebp),%al
    156a:	3c 0a                	cmp    $0xa,%al
    156c:	74 13                	je     1581 <gets+0x5d>
    156e:	8a 45 ef             	mov    -0x11(%ebp),%al
    1571:	3c 0d                	cmp    $0xd,%al
    1573:	74 0c                	je     1581 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1575:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1578:	40                   	inc    %eax
    1579:	3b 45 0c             	cmp    0xc(%ebp),%eax
    157c:	7c b5                	jl     1533 <gets+0xf>
    157e:	eb 01                	jmp    1581 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    1580:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1581:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1584:	8b 45 08             	mov    0x8(%ebp),%eax
    1587:	01 d0                	add    %edx,%eax
    1589:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    158c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    158f:	c9                   	leave  
    1590:	c3                   	ret    

00001591 <stat>:

int
stat(char *n, struct stat *st)
{
    1591:	55                   	push   %ebp
    1592:	89 e5                	mov    %esp,%ebp
    1594:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1597:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    159e:	00 
    159f:	8b 45 08             	mov    0x8(%ebp),%eax
    15a2:	89 04 24             	mov    %eax,(%esp)
    15a5:	e8 fe 00 00 00       	call   16a8 <open>
    15aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    15ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15b1:	79 07                	jns    15ba <stat+0x29>
    return -1;
    15b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    15b8:	eb 23                	jmp    15dd <stat+0x4c>
  r = fstat(fd, st);
    15ba:	8b 45 0c             	mov    0xc(%ebp),%eax
    15bd:	89 44 24 04          	mov    %eax,0x4(%esp)
    15c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15c4:	89 04 24             	mov    %eax,(%esp)
    15c7:	e8 f4 00 00 00       	call   16c0 <fstat>
    15cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    15cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15d2:	89 04 24             	mov    %eax,(%esp)
    15d5:	e8 b6 00 00 00       	call   1690 <close>
  return r;
    15da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    15dd:	c9                   	leave  
    15de:	c3                   	ret    

000015df <atoi>:

int
atoi(const char *s)
{
    15df:	55                   	push   %ebp
    15e0:	89 e5                	mov    %esp,%ebp
    15e2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    15e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    15ec:	eb 21                	jmp    160f <atoi+0x30>
    n = n*10 + *s++ - '0';
    15ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
    15f1:	89 d0                	mov    %edx,%eax
    15f3:	c1 e0 02             	shl    $0x2,%eax
    15f6:	01 d0                	add    %edx,%eax
    15f8:	d1 e0                	shl    %eax
    15fa:	89 c2                	mov    %eax,%edx
    15fc:	8b 45 08             	mov    0x8(%ebp),%eax
    15ff:	8a 00                	mov    (%eax),%al
    1601:	0f be c0             	movsbl %al,%eax
    1604:	01 d0                	add    %edx,%eax
    1606:	83 e8 30             	sub    $0x30,%eax
    1609:	89 45 fc             	mov    %eax,-0x4(%ebp)
    160c:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    160f:	8b 45 08             	mov    0x8(%ebp),%eax
    1612:	8a 00                	mov    (%eax),%al
    1614:	3c 2f                	cmp    $0x2f,%al
    1616:	7e 09                	jle    1621 <atoi+0x42>
    1618:	8b 45 08             	mov    0x8(%ebp),%eax
    161b:	8a 00                	mov    (%eax),%al
    161d:	3c 39                	cmp    $0x39,%al
    161f:	7e cd                	jle    15ee <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1621:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1624:	c9                   	leave  
    1625:	c3                   	ret    

00001626 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1626:	55                   	push   %ebp
    1627:	89 e5                	mov    %esp,%ebp
    1629:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    162c:	8b 45 08             	mov    0x8(%ebp),%eax
    162f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1632:	8b 45 0c             	mov    0xc(%ebp),%eax
    1635:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1638:	eb 10                	jmp    164a <memmove+0x24>
    *dst++ = *src++;
    163a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    163d:	8a 10                	mov    (%eax),%dl
    163f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1642:	88 10                	mov    %dl,(%eax)
    1644:	ff 45 fc             	incl   -0x4(%ebp)
    1647:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    164a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    164e:	0f 9f c0             	setg   %al
    1651:	ff 4d 10             	decl   0x10(%ebp)
    1654:	84 c0                	test   %al,%al
    1656:	75 e2                	jne    163a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1658:	8b 45 08             	mov    0x8(%ebp),%eax
}
    165b:	c9                   	leave  
    165c:	c3                   	ret    
    165d:	66 90                	xchg   %ax,%ax
    165f:	90                   	nop

00001660 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1660:	b8 01 00 00 00       	mov    $0x1,%eax
    1665:	cd 40                	int    $0x40
    1667:	c3                   	ret    

00001668 <exit>:
SYSCALL(exit)
    1668:	b8 02 00 00 00       	mov    $0x2,%eax
    166d:	cd 40                	int    $0x40
    166f:	c3                   	ret    

00001670 <wait>:
SYSCALL(wait)
    1670:	b8 03 00 00 00       	mov    $0x3,%eax
    1675:	cd 40                	int    $0x40
    1677:	c3                   	ret    

00001678 <pipe>:
SYSCALL(pipe)
    1678:	b8 04 00 00 00       	mov    $0x4,%eax
    167d:	cd 40                	int    $0x40
    167f:	c3                   	ret    

00001680 <read>:
SYSCALL(read)
    1680:	b8 05 00 00 00       	mov    $0x5,%eax
    1685:	cd 40                	int    $0x40
    1687:	c3                   	ret    

00001688 <write>:
SYSCALL(write)
    1688:	b8 10 00 00 00       	mov    $0x10,%eax
    168d:	cd 40                	int    $0x40
    168f:	c3                   	ret    

00001690 <close>:
SYSCALL(close)
    1690:	b8 15 00 00 00       	mov    $0x15,%eax
    1695:	cd 40                	int    $0x40
    1697:	c3                   	ret    

00001698 <kill>:
SYSCALL(kill)
    1698:	b8 06 00 00 00       	mov    $0x6,%eax
    169d:	cd 40                	int    $0x40
    169f:	c3                   	ret    

000016a0 <exec>:
SYSCALL(exec)
    16a0:	b8 07 00 00 00       	mov    $0x7,%eax
    16a5:	cd 40                	int    $0x40
    16a7:	c3                   	ret    

000016a8 <open>:
SYSCALL(open)
    16a8:	b8 0f 00 00 00       	mov    $0xf,%eax
    16ad:	cd 40                	int    $0x40
    16af:	c3                   	ret    

000016b0 <mknod>:
SYSCALL(mknod)
    16b0:	b8 11 00 00 00       	mov    $0x11,%eax
    16b5:	cd 40                	int    $0x40
    16b7:	c3                   	ret    

000016b8 <unlink>:
SYSCALL(unlink)
    16b8:	b8 12 00 00 00       	mov    $0x12,%eax
    16bd:	cd 40                	int    $0x40
    16bf:	c3                   	ret    

000016c0 <fstat>:
SYSCALL(fstat)
    16c0:	b8 08 00 00 00       	mov    $0x8,%eax
    16c5:	cd 40                	int    $0x40
    16c7:	c3                   	ret    

000016c8 <link>:
SYSCALL(link)
    16c8:	b8 13 00 00 00       	mov    $0x13,%eax
    16cd:	cd 40                	int    $0x40
    16cf:	c3                   	ret    

000016d0 <mkdir>:
SYSCALL(mkdir)
    16d0:	b8 14 00 00 00       	mov    $0x14,%eax
    16d5:	cd 40                	int    $0x40
    16d7:	c3                   	ret    

000016d8 <chdir>:
SYSCALL(chdir)
    16d8:	b8 09 00 00 00       	mov    $0x9,%eax
    16dd:	cd 40                	int    $0x40
    16df:	c3                   	ret    

000016e0 <dup>:
SYSCALL(dup)
    16e0:	b8 0a 00 00 00       	mov    $0xa,%eax
    16e5:	cd 40                	int    $0x40
    16e7:	c3                   	ret    

000016e8 <getpid>:
SYSCALL(getpid)
    16e8:	b8 0b 00 00 00       	mov    $0xb,%eax
    16ed:	cd 40                	int    $0x40
    16ef:	c3                   	ret    

000016f0 <sbrk>:
SYSCALL(sbrk)
    16f0:	b8 0c 00 00 00       	mov    $0xc,%eax
    16f5:	cd 40                	int    $0x40
    16f7:	c3                   	ret    

000016f8 <sleep>:
SYSCALL(sleep)
    16f8:	b8 0d 00 00 00       	mov    $0xd,%eax
    16fd:	cd 40                	int    $0x40
    16ff:	c3                   	ret    

00001700 <uptime>:
SYSCALL(uptime)
    1700:	b8 0e 00 00 00       	mov    $0xe,%eax
    1705:	cd 40                	int    $0x40
    1707:	c3                   	ret    

00001708 <cowfork>:
SYSCALL(cowfork) //3.4
    1708:	b8 16 00 00 00       	mov    $0x16,%eax
    170d:	cd 40                	int    $0x40
    170f:	c3                   	ret    

00001710 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1710:	55                   	push   %ebp
    1711:	89 e5                	mov    %esp,%ebp
    1713:	83 ec 28             	sub    $0x28,%esp
    1716:	8b 45 0c             	mov    0xc(%ebp),%eax
    1719:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    171c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1723:	00 
    1724:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1727:	89 44 24 04          	mov    %eax,0x4(%esp)
    172b:	8b 45 08             	mov    0x8(%ebp),%eax
    172e:	89 04 24             	mov    %eax,(%esp)
    1731:	e8 52 ff ff ff       	call   1688 <write>
}
    1736:	c9                   	leave  
    1737:	c3                   	ret    

00001738 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1738:	55                   	push   %ebp
    1739:	89 e5                	mov    %esp,%ebp
    173b:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    173e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1745:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1749:	74 17                	je     1762 <printint+0x2a>
    174b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    174f:	79 11                	jns    1762 <printint+0x2a>
    neg = 1;
    1751:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1758:	8b 45 0c             	mov    0xc(%ebp),%eax
    175b:	f7 d8                	neg    %eax
    175d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1760:	eb 06                	jmp    1768 <printint+0x30>
  } else {
    x = xx;
    1762:	8b 45 0c             	mov    0xc(%ebp),%eax
    1765:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1768:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    176f:	8b 4d 10             	mov    0x10(%ebp),%ecx
    1772:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1775:	ba 00 00 00 00       	mov    $0x0,%edx
    177a:	f7 f1                	div    %ecx
    177c:	89 d0                	mov    %edx,%eax
    177e:	8a 80 0c 30 00 00    	mov    0x300c(%eax),%al
    1784:	8d 4d dc             	lea    -0x24(%ebp),%ecx
    1787:	8b 55 f4             	mov    -0xc(%ebp),%edx
    178a:	01 ca                	add    %ecx,%edx
    178c:	88 02                	mov    %al,(%edx)
    178e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
    1791:	8b 55 10             	mov    0x10(%ebp),%edx
    1794:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    1797:	8b 45 ec             	mov    -0x14(%ebp),%eax
    179a:	ba 00 00 00 00       	mov    $0x0,%edx
    179f:	f7 75 d4             	divl   -0x2c(%ebp)
    17a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    17a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    17a9:	75 c4                	jne    176f <printint+0x37>
  if(neg)
    17ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    17af:	74 2c                	je     17dd <printint+0xa5>
    buf[i++] = '-';
    17b1:	8d 55 dc             	lea    -0x24(%ebp),%edx
    17b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17b7:	01 d0                	add    %edx,%eax
    17b9:	c6 00 2d             	movb   $0x2d,(%eax)
    17bc:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
    17bf:	eb 1c                	jmp    17dd <printint+0xa5>
    putc(fd, buf[i]);
    17c1:	8d 55 dc             	lea    -0x24(%ebp),%edx
    17c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17c7:	01 d0                	add    %edx,%eax
    17c9:	8a 00                	mov    (%eax),%al
    17cb:	0f be c0             	movsbl %al,%eax
    17ce:	89 44 24 04          	mov    %eax,0x4(%esp)
    17d2:	8b 45 08             	mov    0x8(%ebp),%eax
    17d5:	89 04 24             	mov    %eax,(%esp)
    17d8:	e8 33 ff ff ff       	call   1710 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    17dd:	ff 4d f4             	decl   -0xc(%ebp)
    17e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17e4:	79 db                	jns    17c1 <printint+0x89>
    putc(fd, buf[i]);
}
    17e6:	c9                   	leave  
    17e7:	c3                   	ret    

000017e8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    17e8:	55                   	push   %ebp
    17e9:	89 e5                	mov    %esp,%ebp
    17eb:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    17ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    17f5:	8d 45 0c             	lea    0xc(%ebp),%eax
    17f8:	83 c0 04             	add    $0x4,%eax
    17fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    17fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1805:	e9 78 01 00 00       	jmp    1982 <printf+0x19a>
    c = fmt[i] & 0xff;
    180a:	8b 55 0c             	mov    0xc(%ebp),%edx
    180d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1810:	01 d0                	add    %edx,%eax
    1812:	8a 00                	mov    (%eax),%al
    1814:	0f be c0             	movsbl %al,%eax
    1817:	25 ff 00 00 00       	and    $0xff,%eax
    181c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    181f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1823:	75 2c                	jne    1851 <printf+0x69>
      if(c == '%'){
    1825:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1829:	75 0c                	jne    1837 <printf+0x4f>
        state = '%';
    182b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1832:	e9 48 01 00 00       	jmp    197f <printf+0x197>
      } else {
        putc(fd, c);
    1837:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    183a:	0f be c0             	movsbl %al,%eax
    183d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1841:	8b 45 08             	mov    0x8(%ebp),%eax
    1844:	89 04 24             	mov    %eax,(%esp)
    1847:	e8 c4 fe ff ff       	call   1710 <putc>
    184c:	e9 2e 01 00 00       	jmp    197f <printf+0x197>
      }
    } else if(state == '%'){
    1851:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1855:	0f 85 24 01 00 00    	jne    197f <printf+0x197>
      if(c == 'd'){
    185b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    185f:	75 2d                	jne    188e <printf+0xa6>
        printint(fd, *ap, 10, 1);
    1861:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1864:	8b 00                	mov    (%eax),%eax
    1866:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    186d:	00 
    186e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1875:	00 
    1876:	89 44 24 04          	mov    %eax,0x4(%esp)
    187a:	8b 45 08             	mov    0x8(%ebp),%eax
    187d:	89 04 24             	mov    %eax,(%esp)
    1880:	e8 b3 fe ff ff       	call   1738 <printint>
        ap++;
    1885:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1889:	e9 ea 00 00 00       	jmp    1978 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
    188e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1892:	74 06                	je     189a <printf+0xb2>
    1894:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1898:	75 2d                	jne    18c7 <printf+0xdf>
        printint(fd, *ap, 16, 0);
    189a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    189d:	8b 00                	mov    (%eax),%eax
    189f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    18a6:	00 
    18a7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    18ae:	00 
    18af:	89 44 24 04          	mov    %eax,0x4(%esp)
    18b3:	8b 45 08             	mov    0x8(%ebp),%eax
    18b6:	89 04 24             	mov    %eax,(%esp)
    18b9:	e8 7a fe ff ff       	call   1738 <printint>
        ap++;
    18be:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    18c2:	e9 b1 00 00 00       	jmp    1978 <printf+0x190>
      } else if(c == 's'){
    18c7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    18cb:	75 43                	jne    1910 <printf+0x128>
        s = (char*)*ap;
    18cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    18d0:	8b 00                	mov    (%eax),%eax
    18d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    18d5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    18d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18dd:	75 25                	jne    1904 <printf+0x11c>
          s = "(null)";
    18df:	c7 45 f4 c7 1d 00 00 	movl   $0x1dc7,-0xc(%ebp)
        while(*s != 0){
    18e6:	eb 1c                	jmp    1904 <printf+0x11c>
          putc(fd, *s);
    18e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18eb:	8a 00                	mov    (%eax),%al
    18ed:	0f be c0             	movsbl %al,%eax
    18f0:	89 44 24 04          	mov    %eax,0x4(%esp)
    18f4:	8b 45 08             	mov    0x8(%ebp),%eax
    18f7:	89 04 24             	mov    %eax,(%esp)
    18fa:	e8 11 fe ff ff       	call   1710 <putc>
          s++;
    18ff:	ff 45 f4             	incl   -0xc(%ebp)
    1902:	eb 01                	jmp    1905 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1904:	90                   	nop
    1905:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1908:	8a 00                	mov    (%eax),%al
    190a:	84 c0                	test   %al,%al
    190c:	75 da                	jne    18e8 <printf+0x100>
    190e:	eb 68                	jmp    1978 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1910:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1914:	75 1d                	jne    1933 <printf+0x14b>
        putc(fd, *ap);
    1916:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1919:	8b 00                	mov    (%eax),%eax
    191b:	0f be c0             	movsbl %al,%eax
    191e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1922:	8b 45 08             	mov    0x8(%ebp),%eax
    1925:	89 04 24             	mov    %eax,(%esp)
    1928:	e8 e3 fd ff ff       	call   1710 <putc>
        ap++;
    192d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1931:	eb 45                	jmp    1978 <printf+0x190>
      } else if(c == '%'){
    1933:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1937:	75 17                	jne    1950 <printf+0x168>
        putc(fd, c);
    1939:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    193c:	0f be c0             	movsbl %al,%eax
    193f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1943:	8b 45 08             	mov    0x8(%ebp),%eax
    1946:	89 04 24             	mov    %eax,(%esp)
    1949:	e8 c2 fd ff ff       	call   1710 <putc>
    194e:	eb 28                	jmp    1978 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1950:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1957:	00 
    1958:	8b 45 08             	mov    0x8(%ebp),%eax
    195b:	89 04 24             	mov    %eax,(%esp)
    195e:	e8 ad fd ff ff       	call   1710 <putc>
        putc(fd, c);
    1963:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1966:	0f be c0             	movsbl %al,%eax
    1969:	89 44 24 04          	mov    %eax,0x4(%esp)
    196d:	8b 45 08             	mov    0x8(%ebp),%eax
    1970:	89 04 24             	mov    %eax,(%esp)
    1973:	e8 98 fd ff ff       	call   1710 <putc>
      }
      state = 0;
    1978:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    197f:	ff 45 f0             	incl   -0x10(%ebp)
    1982:	8b 55 0c             	mov    0xc(%ebp),%edx
    1985:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1988:	01 d0                	add    %edx,%eax
    198a:	8a 00                	mov    (%eax),%al
    198c:	84 c0                	test   %al,%al
    198e:	0f 85 76 fe ff ff    	jne    180a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1994:	c9                   	leave  
    1995:	c3                   	ret    
    1996:	66 90                	xchg   %ax,%ax

00001998 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1998:	55                   	push   %ebp
    1999:	89 e5                	mov    %esp,%ebp
    199b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    199e:	8b 45 08             	mov    0x8(%ebp),%eax
    19a1:	83 e8 08             	sub    $0x8,%eax
    19a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    19a7:	a1 28 30 00 00       	mov    0x3028,%eax
    19ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
    19af:	eb 24                	jmp    19d5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    19b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19b4:	8b 00                	mov    (%eax),%eax
    19b6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    19b9:	77 12                	ja     19cd <free+0x35>
    19bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19be:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    19c1:	77 24                	ja     19e7 <free+0x4f>
    19c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19c6:	8b 00                	mov    (%eax),%eax
    19c8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    19cb:	77 1a                	ja     19e7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    19cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19d0:	8b 00                	mov    (%eax),%eax
    19d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    19d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    19db:	76 d4                	jbe    19b1 <free+0x19>
    19dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19e0:	8b 00                	mov    (%eax),%eax
    19e2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    19e5:	76 ca                	jbe    19b1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    19e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19ea:	8b 40 04             	mov    0x4(%eax),%eax
    19ed:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    19f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19f7:	01 c2                	add    %eax,%edx
    19f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19fc:	8b 00                	mov    (%eax),%eax
    19fe:	39 c2                	cmp    %eax,%edx
    1a00:	75 24                	jne    1a26 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1a02:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a05:	8b 50 04             	mov    0x4(%eax),%edx
    1a08:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a0b:	8b 00                	mov    (%eax),%eax
    1a0d:	8b 40 04             	mov    0x4(%eax),%eax
    1a10:	01 c2                	add    %eax,%edx
    1a12:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a15:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1a18:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a1b:	8b 00                	mov    (%eax),%eax
    1a1d:	8b 10                	mov    (%eax),%edx
    1a1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a22:	89 10                	mov    %edx,(%eax)
    1a24:	eb 0a                	jmp    1a30 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1a26:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a29:	8b 10                	mov    (%eax),%edx
    1a2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a2e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1a30:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a33:	8b 40 04             	mov    0x4(%eax),%eax
    1a36:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1a3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a40:	01 d0                	add    %edx,%eax
    1a42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1a45:	75 20                	jne    1a67 <free+0xcf>
    p->s.size += bp->s.size;
    1a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a4a:	8b 50 04             	mov    0x4(%eax),%edx
    1a4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a50:	8b 40 04             	mov    0x4(%eax),%eax
    1a53:	01 c2                	add    %eax,%edx
    1a55:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a58:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1a5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1a5e:	8b 10                	mov    (%eax),%edx
    1a60:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a63:	89 10                	mov    %edx,(%eax)
    1a65:	eb 08                	jmp    1a6f <free+0xd7>
  } else
    p->s.ptr = bp;
    1a67:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a6a:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1a6d:	89 10                	mov    %edx,(%eax)
  freep = p;
    1a6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a72:	a3 28 30 00 00       	mov    %eax,0x3028
}
    1a77:	c9                   	leave  
    1a78:	c3                   	ret    

00001a79 <morecore>:

static Header*
morecore(uint nu)
{
    1a79:	55                   	push   %ebp
    1a7a:	89 e5                	mov    %esp,%ebp
    1a7c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1a7f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1a86:	77 07                	ja     1a8f <morecore+0x16>
    nu = 4096;
    1a88:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1a8f:	8b 45 08             	mov    0x8(%ebp),%eax
    1a92:	c1 e0 03             	shl    $0x3,%eax
    1a95:	89 04 24             	mov    %eax,(%esp)
    1a98:	e8 53 fc ff ff       	call   16f0 <sbrk>
    1a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1aa0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1aa4:	75 07                	jne    1aad <morecore+0x34>
    return 0;
    1aa6:	b8 00 00 00 00       	mov    $0x0,%eax
    1aab:	eb 22                	jmp    1acf <morecore+0x56>
  hp = (Header*)p;
    1aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ab0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ab6:	8b 55 08             	mov    0x8(%ebp),%edx
    1ab9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1abf:	83 c0 08             	add    $0x8,%eax
    1ac2:	89 04 24             	mov    %eax,(%esp)
    1ac5:	e8 ce fe ff ff       	call   1998 <free>
  return freep;
    1aca:	a1 28 30 00 00       	mov    0x3028,%eax
}
    1acf:	c9                   	leave  
    1ad0:	c3                   	ret    

00001ad1 <malloc>:

void*
malloc(uint nbytes)
{
    1ad1:	55                   	push   %ebp
    1ad2:	89 e5                	mov    %esp,%ebp
    1ad4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1ad7:	8b 45 08             	mov    0x8(%ebp),%eax
    1ada:	83 c0 07             	add    $0x7,%eax
    1add:	c1 e8 03             	shr    $0x3,%eax
    1ae0:	40                   	inc    %eax
    1ae1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1ae4:	a1 28 30 00 00       	mov    0x3028,%eax
    1ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1aec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1af0:	75 23                	jne    1b15 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    1af2:	c7 45 f0 20 30 00 00 	movl   $0x3020,-0x10(%ebp)
    1af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1afc:	a3 28 30 00 00       	mov    %eax,0x3028
    1b01:	a1 28 30 00 00       	mov    0x3028,%eax
    1b06:	a3 20 30 00 00       	mov    %eax,0x3020
    base.s.size = 0;
    1b0b:	c7 05 24 30 00 00 00 	movl   $0x0,0x3024
    1b12:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b18:	8b 00                	mov    (%eax),%eax
    1b1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b20:	8b 40 04             	mov    0x4(%eax),%eax
    1b23:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1b26:	72 4d                	jb     1b75 <malloc+0xa4>
      if(p->s.size == nunits)
    1b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b2b:	8b 40 04             	mov    0x4(%eax),%eax
    1b2e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1b31:	75 0c                	jne    1b3f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    1b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b36:	8b 10                	mov    (%eax),%edx
    1b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b3b:	89 10                	mov    %edx,(%eax)
    1b3d:	eb 26                	jmp    1b65 <malloc+0x94>
      else {
        p->s.size -= nunits;
    1b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b42:	8b 40 04             	mov    0x4(%eax),%eax
    1b45:	89 c2                	mov    %eax,%edx
    1b47:	2b 55 ec             	sub    -0x14(%ebp),%edx
    1b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b4d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b53:	8b 40 04             	mov    0x4(%eax),%eax
    1b56:	c1 e0 03             	shl    $0x3,%eax
    1b59:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b5f:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1b62:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1b65:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b68:	a3 28 30 00 00       	mov    %eax,0x3028
      return (void*)(p + 1);
    1b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b70:	83 c0 08             	add    $0x8,%eax
    1b73:	eb 38                	jmp    1bad <malloc+0xdc>
    }
    if(p == freep)
    1b75:	a1 28 30 00 00       	mov    0x3028,%eax
    1b7a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1b7d:	75 1b                	jne    1b9a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    1b7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1b82:	89 04 24             	mov    %eax,(%esp)
    1b85:	e8 ef fe ff ff       	call   1a79 <morecore>
    1b8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1b8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1b91:	75 07                	jne    1b9a <malloc+0xc9>
        return 0;
    1b93:	b8 00 00 00 00       	mov    $0x0,%eax
    1b98:	eb 13                	jmp    1bad <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ba3:	8b 00                	mov    (%eax),%eax
    1ba5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1ba8:	e9 70 ff ff ff       	jmp    1b1d <malloc+0x4c>
}
    1bad:	c9                   	leave  
    1bae:	c3                   	ret    
