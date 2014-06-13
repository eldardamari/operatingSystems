
_sh:     file format elf32-i386


Disassembly of section .text:

00001000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    1006:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    100a:	75 05                	jne    1011 <runcmd+0x11>
    exit();
    100c:	e8 17 0f 00 00       	call   1f28 <exit>
  
  switch(cmd->type){
    1011:	8b 45 08             	mov    0x8(%ebp),%eax
    1014:	8b 00                	mov    (%eax),%eax
    1016:	83 f8 05             	cmp    $0x5,%eax
    1019:	77 09                	ja     1024 <runcmd+0x24>
    101b:	8b 04 85 9c 24 00 00 	mov    0x249c(,%eax,4),%eax
    1022:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
    1024:	c7 04 24 70 24 00 00 	movl   $0x2470,(%esp)
    102b:	e8 21 03 00 00       	call   1351 <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
    1030:	8b 45 08             	mov    0x8(%ebp),%eax
    1033:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
    1036:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1039:	8b 40 04             	mov    0x4(%eax),%eax
    103c:	85 c0                	test   %eax,%eax
    103e:	75 05                	jne    1045 <runcmd+0x45>
      exit();
    1040:	e8 e3 0e 00 00       	call   1f28 <exit>
    exec(ecmd->argv[0], ecmd->argv);
    1045:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1048:	8d 50 04             	lea    0x4(%eax),%edx
    104b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    104e:	8b 40 04             	mov    0x4(%eax),%eax
    1051:	89 54 24 04          	mov    %edx,0x4(%esp)
    1055:	89 04 24             	mov    %eax,(%esp)
    1058:	e8 03 0f 00 00       	call   1f60 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
    105d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1060:	8b 40 04             	mov    0x4(%eax),%eax
    1063:	89 44 24 08          	mov    %eax,0x8(%esp)
    1067:	c7 44 24 04 77 24 00 	movl   $0x2477,0x4(%esp)
    106e:	00 
    106f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1076:	e8 2d 10 00 00       	call   20a8 <printf>
    break;
    107b:	e9 84 01 00 00       	jmp    1204 <runcmd+0x204>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    1080:	8b 45 08             	mov    0x8(%ebp),%eax
    1083:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
    1086:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1089:	8b 40 14             	mov    0x14(%eax),%eax
    108c:	89 04 24             	mov    %eax,(%esp)
    108f:	e8 bc 0e 00 00       	call   1f50 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
    1094:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1097:	8b 50 10             	mov    0x10(%eax),%edx
    109a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    109d:	8b 40 08             	mov    0x8(%eax),%eax
    10a0:	89 54 24 04          	mov    %edx,0x4(%esp)
    10a4:	89 04 24             	mov    %eax,(%esp)
    10a7:	e8 bc 0e 00 00       	call   1f68 <open>
    10ac:	85 c0                	test   %eax,%eax
    10ae:	79 23                	jns    10d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
    10b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10b3:	8b 40 08             	mov    0x8(%eax),%eax
    10b6:	89 44 24 08          	mov    %eax,0x8(%esp)
    10ba:	c7 44 24 04 87 24 00 	movl   $0x2487,0x4(%esp)
    10c1:	00 
    10c2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    10c9:	e8 da 0f 00 00       	call   20a8 <printf>
      exit();
    10ce:	e8 55 0e 00 00       	call   1f28 <exit>
    }
    runcmd(rcmd->cmd);
    10d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10d6:	8b 40 04             	mov    0x4(%eax),%eax
    10d9:	89 04 24             	mov    %eax,(%esp)
    10dc:	e8 1f ff ff ff       	call   1000 <runcmd>
    break;
    10e1:	e9 1e 01 00 00       	jmp    1204 <runcmd+0x204>

  case LIST:
    lcmd = (struct listcmd*)cmd;
    10e6:	8b 45 08             	mov    0x8(%ebp),%eax
    10e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
    10ec:	e8 86 02 00 00       	call   1377 <fork1>
    10f1:	85 c0                	test   %eax,%eax
    10f3:	75 0e                	jne    1103 <runcmd+0x103>
      runcmd(lcmd->left);
    10f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    10f8:	8b 40 04             	mov    0x4(%eax),%eax
    10fb:	89 04 24             	mov    %eax,(%esp)
    10fe:	e8 fd fe ff ff       	call   1000 <runcmd>
    wait();
    1103:	e8 28 0e 00 00       	call   1f30 <wait>
    runcmd(lcmd->right);
    1108:	8b 45 ec             	mov    -0x14(%ebp),%eax
    110b:	8b 40 08             	mov    0x8(%eax),%eax
    110e:	89 04 24             	mov    %eax,(%esp)
    1111:	e8 ea fe ff ff       	call   1000 <runcmd>
    break;
    1116:	e9 e9 00 00 00       	jmp    1204 <runcmd+0x204>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    111b:	8b 45 08             	mov    0x8(%ebp),%eax
    111e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pipe(p) < 0)
    1121:	8d 45 dc             	lea    -0x24(%ebp),%eax
    1124:	89 04 24             	mov    %eax,(%esp)
    1127:	e8 0c 0e 00 00       	call   1f38 <pipe>
    112c:	85 c0                	test   %eax,%eax
    112e:	79 0c                	jns    113c <runcmd+0x13c>
      panic("pipe");
    1130:	c7 04 24 97 24 00 00 	movl   $0x2497,(%esp)
    1137:	e8 15 02 00 00       	call   1351 <panic>
    if(fork1() == 0){
    113c:	e8 36 02 00 00       	call   1377 <fork1>
    1141:	85 c0                	test   %eax,%eax
    1143:	75 3b                	jne    1180 <runcmd+0x180>
      close(1);
    1145:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    114c:	e8 ff 0d 00 00       	call   1f50 <close>
      dup(p[1]);
    1151:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1154:	89 04 24             	mov    %eax,(%esp)
    1157:	e8 44 0e 00 00       	call   1fa0 <dup>
      close(p[0]);
    115c:	8b 45 dc             	mov    -0x24(%ebp),%eax
    115f:	89 04 24             	mov    %eax,(%esp)
    1162:	e8 e9 0d 00 00       	call   1f50 <close>
      close(p[1]);
    1167:	8b 45 e0             	mov    -0x20(%ebp),%eax
    116a:	89 04 24             	mov    %eax,(%esp)
    116d:	e8 de 0d 00 00       	call   1f50 <close>
      runcmd(pcmd->left);
    1172:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1175:	8b 40 04             	mov    0x4(%eax),%eax
    1178:	89 04 24             	mov    %eax,(%esp)
    117b:	e8 80 fe ff ff       	call   1000 <runcmd>
    }
    if(fork1() == 0){
    1180:	e8 f2 01 00 00       	call   1377 <fork1>
    1185:	85 c0                	test   %eax,%eax
    1187:	75 3b                	jne    11c4 <runcmd+0x1c4>
      close(0);
    1189:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1190:	e8 bb 0d 00 00       	call   1f50 <close>
      dup(p[0]);
    1195:	8b 45 dc             	mov    -0x24(%ebp),%eax
    1198:	89 04 24             	mov    %eax,(%esp)
    119b:	e8 00 0e 00 00       	call   1fa0 <dup>
      close(p[0]);
    11a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
    11a3:	89 04 24             	mov    %eax,(%esp)
    11a6:	e8 a5 0d 00 00       	call   1f50 <close>
      close(p[1]);
    11ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
    11ae:	89 04 24             	mov    %eax,(%esp)
    11b1:	e8 9a 0d 00 00       	call   1f50 <close>
      runcmd(pcmd->right);
    11b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    11b9:	8b 40 08             	mov    0x8(%eax),%eax
    11bc:	89 04 24             	mov    %eax,(%esp)
    11bf:	e8 3c fe ff ff       	call   1000 <runcmd>
    }
    close(p[0]);
    11c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
    11c7:	89 04 24             	mov    %eax,(%esp)
    11ca:	e8 81 0d 00 00       	call   1f50 <close>
    close(p[1]);
    11cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
    11d2:	89 04 24             	mov    %eax,(%esp)
    11d5:	e8 76 0d 00 00       	call   1f50 <close>
    wait();
    11da:	e8 51 0d 00 00       	call   1f30 <wait>
    wait();
    11df:	e8 4c 0d 00 00       	call   1f30 <wait>
    break;
    11e4:	eb 1e                	jmp    1204 <runcmd+0x204>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
    11e6:	8b 45 08             	mov    0x8(%ebp),%eax
    11e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
    11ec:	e8 86 01 00 00       	call   1377 <fork1>
    11f1:	85 c0                	test   %eax,%eax
    11f3:	75 0e                	jne    1203 <runcmd+0x203>
      runcmd(bcmd->cmd);
    11f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    11f8:	8b 40 04             	mov    0x4(%eax),%eax
    11fb:	89 04 24             	mov    %eax,(%esp)
    11fe:	e8 fd fd ff ff       	call   1000 <runcmd>
    break;
    1203:	90                   	nop
  }
  exit();
    1204:	e8 1f 0d 00 00       	call   1f28 <exit>

00001209 <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
    1209:	55                   	push   %ebp
    120a:	89 e5                	mov    %esp,%ebp
    120c:	83 ec 18             	sub    $0x18,%esp
  printf(2, "$ ");
    120f:	c7 44 24 04 b4 24 00 	movl   $0x24b4,0x4(%esp)
    1216:	00 
    1217:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    121e:	e8 85 0e 00 00       	call   20a8 <printf>
  memset(buf, 0, nbuf);
    1223:	8b 45 0c             	mov    0xc(%ebp),%eax
    1226:	89 44 24 08          	mov    %eax,0x8(%esp)
    122a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1231:	00 
    1232:	8b 45 08             	mov    0x8(%ebp),%eax
    1235:	89 04 24             	mov    %eax,(%esp)
    1238:	e8 53 0b 00 00       	call   1d90 <memset>
  gets(buf, nbuf);
    123d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1240:	89 44 24 04          	mov    %eax,0x4(%esp)
    1244:	8b 45 08             	mov    0x8(%ebp),%eax
    1247:	89 04 24             	mov    %eax,(%esp)
    124a:	e8 95 0b 00 00       	call   1de4 <gets>
  if(buf[0] == 0) // EOF
    124f:	8b 45 08             	mov    0x8(%ebp),%eax
    1252:	8a 00                	mov    (%eax),%al
    1254:	84 c0                	test   %al,%al
    1256:	75 07                	jne    125f <getcmd+0x56>
    return -1;
    1258:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    125d:	eb 05                	jmp    1264 <getcmd+0x5b>
  return 0;
    125f:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1264:	c9                   	leave  
    1265:	c3                   	ret    

00001266 <main>:

int
main(void)
{
    1266:	55                   	push   %ebp
    1267:	89 e5                	mov    %esp,%ebp
    1269:	83 e4 f0             	and    $0xfffffff0,%esp
    126c:	83 ec 20             	sub    $0x20,%esp
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
    126f:	eb 19                	jmp    128a <main+0x24>
    if(fd >= 3){
    1271:	83 7c 24 1c 02       	cmpl   $0x2,0x1c(%esp)
    1276:	7e 12                	jle    128a <main+0x24>
      close(fd);
    1278:	8b 44 24 1c          	mov    0x1c(%esp),%eax
    127c:	89 04 24             	mov    %eax,(%esp)
    127f:	e8 cc 0c 00 00       	call   1f50 <close>
      break;
    1284:	90                   	nop
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    1285:	e9 a6 00 00 00       	jmp    1330 <main+0xca>
{
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
    128a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1291:	00 
    1292:	c7 04 24 b7 24 00 00 	movl   $0x24b7,(%esp)
    1299:	e8 ca 0c 00 00       	call   1f68 <open>
    129e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    12a2:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
    12a7:	79 c8                	jns    1271 <main+0xb>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    12a9:	e9 82 00 00 00       	jmp    1330 <main+0xca>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
    12ae:	a0 20 3a 00 00       	mov    0x3a20,%al
    12b3:	3c 63                	cmp    $0x63,%al
    12b5:	75 54                	jne    130b <main+0xa5>
    12b7:	a0 21 3a 00 00       	mov    0x3a21,%al
    12bc:	3c 64                	cmp    $0x64,%al
    12be:	75 4b                	jne    130b <main+0xa5>
    12c0:	a0 22 3a 00 00       	mov    0x3a22,%al
    12c5:	3c 20                	cmp    $0x20,%al
    12c7:	75 42                	jne    130b <main+0xa5>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
    12c9:	c7 04 24 20 3a 00 00 	movl   $0x3a20,(%esp)
    12d0:	e8 96 0a 00 00       	call   1d6b <strlen>
    12d5:	48                   	dec    %eax
    12d6:	c6 80 20 3a 00 00 00 	movb   $0x0,0x3a20(%eax)
      if(chdir(buf+3) < 0)
    12dd:	c7 04 24 23 3a 00 00 	movl   $0x3a23,(%esp)
    12e4:	e8 af 0c 00 00       	call   1f98 <chdir>
    12e9:	85 c0                	test   %eax,%eax
    12eb:	79 42                	jns    132f <main+0xc9>
        printf(2, "cannot cd %s\n", buf+3);
    12ed:	c7 44 24 08 23 3a 00 	movl   $0x3a23,0x8(%esp)
    12f4:	00 
    12f5:	c7 44 24 04 bf 24 00 	movl   $0x24bf,0x4(%esp)
    12fc:	00 
    12fd:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    1304:	e8 9f 0d 00 00       	call   20a8 <printf>
      continue;
    1309:	eb 24                	jmp    132f <main+0xc9>
    }
    if(fork1() == 0)
    130b:	e8 67 00 00 00       	call   1377 <fork1>
    1310:	85 c0                	test   %eax,%eax
    1312:	75 14                	jne    1328 <main+0xc2>
      runcmd(parsecmd(buf));
    1314:	c7 04 24 20 3a 00 00 	movl   $0x3a20,(%esp)
    131b:	e8 b4 03 00 00       	call   16d4 <parsecmd>
    1320:	89 04 24             	mov    %eax,(%esp)
    1323:	e8 d8 fc ff ff       	call   1000 <runcmd>
    wait();
    1328:	e8 03 0c 00 00       	call   1f30 <wait>
    132d:	eb 01                	jmp    1330 <main+0xca>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    132f:	90                   	nop
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
    1330:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
    1337:	00 
    1338:	c7 04 24 20 3a 00 00 	movl   $0x3a20,(%esp)
    133f:	e8 c5 fe ff ff       	call   1209 <getcmd>
    1344:	85 c0                	test   %eax,%eax
    1346:	0f 89 62 ff ff ff    	jns    12ae <main+0x48>
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
    134c:	e8 d7 0b 00 00       	call   1f28 <exit>

00001351 <panic>:
}

void
panic(char *s)
{
    1351:	55                   	push   %ebp
    1352:	89 e5                	mov    %esp,%ebp
    1354:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
    1357:	8b 45 08             	mov    0x8(%ebp),%eax
    135a:	89 44 24 08          	mov    %eax,0x8(%esp)
    135e:	c7 44 24 04 cd 24 00 	movl   $0x24cd,0x4(%esp)
    1365:	00 
    1366:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    136d:	e8 36 0d 00 00       	call   20a8 <printf>
  exit();
    1372:	e8 b1 0b 00 00       	call   1f28 <exit>

00001377 <fork1>:
}

int
fork1(void)
{
    1377:	55                   	push   %ebp
    1378:	89 e5                	mov    %esp,%ebp
    137a:	83 ec 28             	sub    $0x28,%esp
  int pid;
  
  pid = fork();
    137d:	e8 9e 0b 00 00       	call   1f20 <fork>
    1382:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
    1385:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1389:	75 0c                	jne    1397 <fork1+0x20>
    panic("fork");
    138b:	c7 04 24 d1 24 00 00 	movl   $0x24d1,(%esp)
    1392:	e8 ba ff ff ff       	call   1351 <panic>
  return pid;
    1397:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    139a:	c9                   	leave  
    139b:	c3                   	ret    

0000139c <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
    139c:	55                   	push   %ebp
    139d:	89 e5                	mov    %esp,%ebp
    139f:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    13a2:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
    13a9:	e8 e3 0f 00 00       	call   2391 <malloc>
    13ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
    13b1:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
    13b8:	00 
    13b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    13c0:	00 
    13c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13c4:	89 04 24             	mov    %eax,(%esp)
    13c7:	e8 c4 09 00 00       	call   1d90 <memset>
  cmd->type = EXEC;
    13cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13cf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
    13d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    13d8:	c9                   	leave  
    13d9:	c3                   	ret    

000013da <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
    13da:	55                   	push   %ebp
    13db:	89 e5                	mov    %esp,%ebp
    13dd:	83 ec 28             	sub    $0x28,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
    13e0:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
    13e7:	e8 a5 0f 00 00       	call   2391 <malloc>
    13ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
    13ef:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
    13f6:	00 
    13f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    13fe:	00 
    13ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1402:	89 04 24             	mov    %eax,(%esp)
    1405:	e8 86 09 00 00       	call   1d90 <memset>
  cmd->type = REDIR;
    140a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    140d:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
    1413:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1416:	8b 55 08             	mov    0x8(%ebp),%edx
    1419:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
    141c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    141f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1422:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
    1425:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1428:	8b 55 10             	mov    0x10(%ebp),%edx
    142b:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
    142e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1431:	8b 55 14             	mov    0x14(%ebp),%edx
    1434:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
    1437:	8b 45 f4             	mov    -0xc(%ebp),%eax
    143a:	8b 55 18             	mov    0x18(%ebp),%edx
    143d:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
    1440:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    1443:	c9                   	leave  
    1444:	c3                   	ret    

00001445 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
    1445:	55                   	push   %ebp
    1446:	89 e5                	mov    %esp,%ebp
    1448:	83 ec 28             	sub    $0x28,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
    144b:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    1452:	e8 3a 0f 00 00       	call   2391 <malloc>
    1457:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
    145a:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
    1461:	00 
    1462:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1469:	00 
    146a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    146d:	89 04 24             	mov    %eax,(%esp)
    1470:	e8 1b 09 00 00       	call   1d90 <memset>
  cmd->type = PIPE;
    1475:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1478:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
    147e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1481:	8b 55 08             	mov    0x8(%ebp),%edx
    1484:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
    1487:	8b 45 f4             	mov    -0xc(%ebp),%eax
    148a:	8b 55 0c             	mov    0xc(%ebp),%edx
    148d:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
    1490:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    1493:	c9                   	leave  
    1494:	c3                   	ret    

00001495 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
    1495:	55                   	push   %ebp
    1496:	89 e5                	mov    %esp,%ebp
    1498:	83 ec 28             	sub    $0x28,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    149b:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    14a2:	e8 ea 0e 00 00       	call   2391 <malloc>
    14a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
    14aa:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
    14b1:	00 
    14b2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    14b9:	00 
    14ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14bd:	89 04 24             	mov    %eax,(%esp)
    14c0:	e8 cb 08 00 00       	call   1d90 <memset>
  cmd->type = LIST;
    14c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14c8:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
    14ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14d1:	8b 55 08             	mov    0x8(%ebp),%edx
    14d4:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
    14d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14da:	8b 55 0c             	mov    0xc(%ebp),%edx
    14dd:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
    14e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    14e3:	c9                   	leave  
    14e4:	c3                   	ret    

000014e5 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
    14e5:	55                   	push   %ebp
    14e6:	89 e5                	mov    %esp,%ebp
    14e8:	83 ec 28             	sub    $0x28,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    14eb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
    14f2:	e8 9a 0e 00 00       	call   2391 <malloc>
    14f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
    14fa:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
    1501:	00 
    1502:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1509:	00 
    150a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    150d:	89 04 24             	mov    %eax,(%esp)
    1510:	e8 7b 08 00 00       	call   1d90 <memset>
  cmd->type = BACK;
    1515:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1518:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
    151e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1521:	8b 55 08             	mov    0x8(%ebp),%edx
    1524:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
    1527:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    152a:	c9                   	leave  
    152b:	c3                   	ret    

0000152c <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
    152c:	55                   	push   %ebp
    152d:	89 e5                	mov    %esp,%ebp
    152f:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int ret;
  
  s = *ps;
    1532:	8b 45 08             	mov    0x8(%ebp),%eax
    1535:	8b 00                	mov    (%eax),%eax
    1537:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
    153a:	eb 03                	jmp    153f <gettoken+0x13>
    s++;
    153c:	ff 45 f4             	incl   -0xc(%ebp)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    153f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1542:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1545:	73 1c                	jae    1563 <gettoken+0x37>
    1547:	8b 45 f4             	mov    -0xc(%ebp),%eax
    154a:	8a 00                	mov    (%eax),%al
    154c:	0f be c0             	movsbl %al,%eax
    154f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1553:	c7 04 24 e0 39 00 00 	movl   $0x39e0,(%esp)
    155a:	e8 55 08 00 00       	call   1db4 <strchr>
    155f:	85 c0                	test   %eax,%eax
    1561:	75 d9                	jne    153c <gettoken+0x10>
    s++;
  if(q)
    1563:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    1567:	74 08                	je     1571 <gettoken+0x45>
    *q = s;
    1569:	8b 45 10             	mov    0x10(%ebp),%eax
    156c:	8b 55 f4             	mov    -0xc(%ebp),%edx
    156f:	89 10                	mov    %edx,(%eax)
  ret = *s;
    1571:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1574:	8a 00                	mov    (%eax),%al
    1576:	0f be c0             	movsbl %al,%eax
    1579:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
    157c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    157f:	8a 00                	mov    (%eax),%al
    1581:	0f be c0             	movsbl %al,%eax
    1584:	83 f8 3c             	cmp    $0x3c,%eax
    1587:	7f 1a                	jg     15a3 <gettoken+0x77>
    1589:	83 f8 3b             	cmp    $0x3b,%eax
    158c:	7d 1f                	jge    15ad <gettoken+0x81>
    158e:	83 f8 29             	cmp    $0x29,%eax
    1591:	7f 37                	jg     15ca <gettoken+0x9e>
    1593:	83 f8 28             	cmp    $0x28,%eax
    1596:	7d 15                	jge    15ad <gettoken+0x81>
    1598:	85 c0                	test   %eax,%eax
    159a:	74 7c                	je     1618 <gettoken+0xec>
    159c:	83 f8 26             	cmp    $0x26,%eax
    159f:	74 0c                	je     15ad <gettoken+0x81>
    15a1:	eb 27                	jmp    15ca <gettoken+0x9e>
    15a3:	83 f8 3e             	cmp    $0x3e,%eax
    15a6:	74 0a                	je     15b2 <gettoken+0x86>
    15a8:	83 f8 7c             	cmp    $0x7c,%eax
    15ab:	75 1d                	jne    15ca <gettoken+0x9e>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
    15ad:	ff 45 f4             	incl   -0xc(%ebp)
    break;
    15b0:	eb 6d                	jmp    161f <gettoken+0xf3>
  case '>':
    s++;
    15b2:	ff 45 f4             	incl   -0xc(%ebp)
    if(*s == '>'){
    15b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15b8:	8a 00                	mov    (%eax),%al
    15ba:	3c 3e                	cmp    $0x3e,%al
    15bc:	75 5d                	jne    161b <gettoken+0xef>
      ret = '+';
    15be:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
    15c5:	ff 45 f4             	incl   -0xc(%ebp)
    }
    break;
    15c8:	eb 51                	jmp    161b <gettoken+0xef>
  default:
    ret = 'a';
    15ca:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
    15d1:	eb 03                	jmp    15d6 <gettoken+0xaa>
      s++;
    15d3:	ff 45 f4             	incl   -0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
    15d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15d9:	3b 45 0c             	cmp    0xc(%ebp),%eax
    15dc:	73 40                	jae    161e <gettoken+0xf2>
    15de:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15e1:	8a 00                	mov    (%eax),%al
    15e3:	0f be c0             	movsbl %al,%eax
    15e6:	89 44 24 04          	mov    %eax,0x4(%esp)
    15ea:	c7 04 24 e0 39 00 00 	movl   $0x39e0,(%esp)
    15f1:	e8 be 07 00 00       	call   1db4 <strchr>
    15f6:	85 c0                	test   %eax,%eax
    15f8:	75 24                	jne    161e <gettoken+0xf2>
    15fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15fd:	8a 00                	mov    (%eax),%al
    15ff:	0f be c0             	movsbl %al,%eax
    1602:	89 44 24 04          	mov    %eax,0x4(%esp)
    1606:	c7 04 24 e6 39 00 00 	movl   $0x39e6,(%esp)
    160d:	e8 a2 07 00 00       	call   1db4 <strchr>
    1612:	85 c0                	test   %eax,%eax
    1614:	74 bd                	je     15d3 <gettoken+0xa7>
      s++;
    break;
    1616:	eb 06                	jmp    161e <gettoken+0xf2>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
    1618:	90                   	nop
    1619:	eb 04                	jmp    161f <gettoken+0xf3>
    s++;
    if(*s == '>'){
      ret = '+';
      s++;
    }
    break;
    161b:	90                   	nop
    161c:	eb 01                	jmp    161f <gettoken+0xf3>
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
    161e:	90                   	nop
  }
  if(eq)
    161f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1623:	74 0d                	je     1632 <gettoken+0x106>
    *eq = s;
    1625:	8b 45 14             	mov    0x14(%ebp),%eax
    1628:	8b 55 f4             	mov    -0xc(%ebp),%edx
    162b:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
    162d:	eb 03                	jmp    1632 <gettoken+0x106>
    s++;
    162f:	ff 45 f4             	incl   -0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
    1632:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1635:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1638:	73 1c                	jae    1656 <gettoken+0x12a>
    163a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    163d:	8a 00                	mov    (%eax),%al
    163f:	0f be c0             	movsbl %al,%eax
    1642:	89 44 24 04          	mov    %eax,0x4(%esp)
    1646:	c7 04 24 e0 39 00 00 	movl   $0x39e0,(%esp)
    164d:	e8 62 07 00 00       	call   1db4 <strchr>
    1652:	85 c0                	test   %eax,%eax
    1654:	75 d9                	jne    162f <gettoken+0x103>
    s++;
  *ps = s;
    1656:	8b 45 08             	mov    0x8(%ebp),%eax
    1659:	8b 55 f4             	mov    -0xc(%ebp),%edx
    165c:	89 10                	mov    %edx,(%eax)
  return ret;
    165e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1661:	c9                   	leave  
    1662:	c3                   	ret    

00001663 <peek>:

int
peek(char **ps, char *es, char *toks)
{
    1663:	55                   	push   %ebp
    1664:	89 e5                	mov    %esp,%ebp
    1666:	83 ec 28             	sub    $0x28,%esp
  char *s;
  
  s = *ps;
    1669:	8b 45 08             	mov    0x8(%ebp),%eax
    166c:	8b 00                	mov    (%eax),%eax
    166e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
    1671:	eb 03                	jmp    1676 <peek+0x13>
    s++;
    1673:	ff 45 f4             	incl   -0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
    1676:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1679:	3b 45 0c             	cmp    0xc(%ebp),%eax
    167c:	73 1c                	jae    169a <peek+0x37>
    167e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1681:	8a 00                	mov    (%eax),%al
    1683:	0f be c0             	movsbl %al,%eax
    1686:	89 44 24 04          	mov    %eax,0x4(%esp)
    168a:	c7 04 24 e0 39 00 00 	movl   $0x39e0,(%esp)
    1691:	e8 1e 07 00 00       	call   1db4 <strchr>
    1696:	85 c0                	test   %eax,%eax
    1698:	75 d9                	jne    1673 <peek+0x10>
    s++;
  *ps = s;
    169a:	8b 45 08             	mov    0x8(%ebp),%eax
    169d:	8b 55 f4             	mov    -0xc(%ebp),%edx
    16a0:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
    16a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16a5:	8a 00                	mov    (%eax),%al
    16a7:	84 c0                	test   %al,%al
    16a9:	74 22                	je     16cd <peek+0x6a>
    16ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16ae:	8a 00                	mov    (%eax),%al
    16b0:	0f be c0             	movsbl %al,%eax
    16b3:	89 44 24 04          	mov    %eax,0x4(%esp)
    16b7:	8b 45 10             	mov    0x10(%ebp),%eax
    16ba:	89 04 24             	mov    %eax,(%esp)
    16bd:	e8 f2 06 00 00       	call   1db4 <strchr>
    16c2:	85 c0                	test   %eax,%eax
    16c4:	74 07                	je     16cd <peek+0x6a>
    16c6:	b8 01 00 00 00       	mov    $0x1,%eax
    16cb:	eb 05                	jmp    16d2 <peek+0x6f>
    16cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
    16d2:	c9                   	leave  
    16d3:	c3                   	ret    

000016d4 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
    16d4:	55                   	push   %ebp
    16d5:	89 e5                	mov    %esp,%ebp
    16d7:	53                   	push   %ebx
    16d8:	83 ec 24             	sub    $0x24,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
    16db:	8b 5d 08             	mov    0x8(%ebp),%ebx
    16de:	8b 45 08             	mov    0x8(%ebp),%eax
    16e1:	89 04 24             	mov    %eax,(%esp)
    16e4:	e8 82 06 00 00       	call   1d6b <strlen>
    16e9:	01 d8                	add    %ebx,%eax
    16eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
    16ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16f1:	89 44 24 04          	mov    %eax,0x4(%esp)
    16f5:	8d 45 08             	lea    0x8(%ebp),%eax
    16f8:	89 04 24             	mov    %eax,(%esp)
    16fb:	e8 60 00 00 00       	call   1760 <parseline>
    1700:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
    1703:	c7 44 24 08 d6 24 00 	movl   $0x24d6,0x8(%esp)
    170a:	00 
    170b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    170e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1712:	8d 45 08             	lea    0x8(%ebp),%eax
    1715:	89 04 24             	mov    %eax,(%esp)
    1718:	e8 46 ff ff ff       	call   1663 <peek>
  if(s != es){
    171d:	8b 45 08             	mov    0x8(%ebp),%eax
    1720:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    1723:	74 27                	je     174c <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
    1725:	8b 45 08             	mov    0x8(%ebp),%eax
    1728:	89 44 24 08          	mov    %eax,0x8(%esp)
    172c:	c7 44 24 04 d7 24 00 	movl   $0x24d7,0x4(%esp)
    1733:	00 
    1734:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
    173b:	e8 68 09 00 00       	call   20a8 <printf>
    panic("syntax");
    1740:	c7 04 24 e6 24 00 00 	movl   $0x24e6,(%esp)
    1747:	e8 05 fc ff ff       	call   1351 <panic>
  }
  nulterminate(cmd);
    174c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    174f:	89 04 24             	mov    %eax,(%esp)
    1752:	e8 a4 04 00 00       	call   1bfb <nulterminate>
  return cmd;
    1757:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    175a:	83 c4 24             	add    $0x24,%esp
    175d:	5b                   	pop    %ebx
    175e:	5d                   	pop    %ebp
    175f:	c3                   	ret    

00001760 <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
    1760:	55                   	push   %ebp
    1761:	89 e5                	mov    %esp,%ebp
    1763:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
    1766:	8b 45 0c             	mov    0xc(%ebp),%eax
    1769:	89 44 24 04          	mov    %eax,0x4(%esp)
    176d:	8b 45 08             	mov    0x8(%ebp),%eax
    1770:	89 04 24             	mov    %eax,(%esp)
    1773:	e8 bc 00 00 00       	call   1834 <parsepipe>
    1778:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
    177b:	eb 30                	jmp    17ad <parseline+0x4d>
    gettoken(ps, es, 0, 0);
    177d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1784:	00 
    1785:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    178c:	00 
    178d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1790:	89 44 24 04          	mov    %eax,0x4(%esp)
    1794:	8b 45 08             	mov    0x8(%ebp),%eax
    1797:	89 04 24             	mov    %eax,(%esp)
    179a:	e8 8d fd ff ff       	call   152c <gettoken>
    cmd = backcmd(cmd);
    179f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17a2:	89 04 24             	mov    %eax,(%esp)
    17a5:	e8 3b fd ff ff       	call   14e5 <backcmd>
    17aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
    17ad:	c7 44 24 08 ed 24 00 	movl   $0x24ed,0x8(%esp)
    17b4:	00 
    17b5:	8b 45 0c             	mov    0xc(%ebp),%eax
    17b8:	89 44 24 04          	mov    %eax,0x4(%esp)
    17bc:	8b 45 08             	mov    0x8(%ebp),%eax
    17bf:	89 04 24             	mov    %eax,(%esp)
    17c2:	e8 9c fe ff ff       	call   1663 <peek>
    17c7:	85 c0                	test   %eax,%eax
    17c9:	75 b2                	jne    177d <parseline+0x1d>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
    17cb:	c7 44 24 08 ef 24 00 	movl   $0x24ef,0x8(%esp)
    17d2:	00 
    17d3:	8b 45 0c             	mov    0xc(%ebp),%eax
    17d6:	89 44 24 04          	mov    %eax,0x4(%esp)
    17da:	8b 45 08             	mov    0x8(%ebp),%eax
    17dd:	89 04 24             	mov    %eax,(%esp)
    17e0:	e8 7e fe ff ff       	call   1663 <peek>
    17e5:	85 c0                	test   %eax,%eax
    17e7:	74 46                	je     182f <parseline+0xcf>
    gettoken(ps, es, 0, 0);
    17e9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    17f0:	00 
    17f1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    17f8:	00 
    17f9:	8b 45 0c             	mov    0xc(%ebp),%eax
    17fc:	89 44 24 04          	mov    %eax,0x4(%esp)
    1800:	8b 45 08             	mov    0x8(%ebp),%eax
    1803:	89 04 24             	mov    %eax,(%esp)
    1806:	e8 21 fd ff ff       	call   152c <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
    180b:	8b 45 0c             	mov    0xc(%ebp),%eax
    180e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1812:	8b 45 08             	mov    0x8(%ebp),%eax
    1815:	89 04 24             	mov    %eax,(%esp)
    1818:	e8 43 ff ff ff       	call   1760 <parseline>
    181d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1821:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1824:	89 04 24             	mov    %eax,(%esp)
    1827:	e8 69 fc ff ff       	call   1495 <listcmd>
    182c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
    182f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    1832:	c9                   	leave  
    1833:	c3                   	ret    

00001834 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
    1834:	55                   	push   %ebp
    1835:	89 e5                	mov    %esp,%ebp
    1837:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
    183a:	8b 45 0c             	mov    0xc(%ebp),%eax
    183d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1841:	8b 45 08             	mov    0x8(%ebp),%eax
    1844:	89 04 24             	mov    %eax,(%esp)
    1847:	e8 68 02 00 00       	call   1ab4 <parseexec>
    184c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
    184f:	c7 44 24 08 f1 24 00 	movl   $0x24f1,0x8(%esp)
    1856:	00 
    1857:	8b 45 0c             	mov    0xc(%ebp),%eax
    185a:	89 44 24 04          	mov    %eax,0x4(%esp)
    185e:	8b 45 08             	mov    0x8(%ebp),%eax
    1861:	89 04 24             	mov    %eax,(%esp)
    1864:	e8 fa fd ff ff       	call   1663 <peek>
    1869:	85 c0                	test   %eax,%eax
    186b:	74 46                	je     18b3 <parsepipe+0x7f>
    gettoken(ps, es, 0, 0);
    186d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1874:	00 
    1875:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    187c:	00 
    187d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1880:	89 44 24 04          	mov    %eax,0x4(%esp)
    1884:	8b 45 08             	mov    0x8(%ebp),%eax
    1887:	89 04 24             	mov    %eax,(%esp)
    188a:	e8 9d fc ff ff       	call   152c <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
    188f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1892:	89 44 24 04          	mov    %eax,0x4(%esp)
    1896:	8b 45 08             	mov    0x8(%ebp),%eax
    1899:	89 04 24             	mov    %eax,(%esp)
    189c:	e8 93 ff ff ff       	call   1834 <parsepipe>
    18a1:	89 44 24 04          	mov    %eax,0x4(%esp)
    18a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18a8:	89 04 24             	mov    %eax,(%esp)
    18ab:	e8 95 fb ff ff       	call   1445 <pipecmd>
    18b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
    18b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    18b6:	c9                   	leave  
    18b7:	c3                   	ret    

000018b8 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
    18b8:	55                   	push   %ebp
    18b9:	89 e5                	mov    %esp,%ebp
    18bb:	83 ec 38             	sub    $0x38,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    18be:	e9 f6 00 00 00       	jmp    19b9 <parseredirs+0x101>
    tok = gettoken(ps, es, 0, 0);
    18c3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    18ca:	00 
    18cb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    18d2:	00 
    18d3:	8b 45 10             	mov    0x10(%ebp),%eax
    18d6:	89 44 24 04          	mov    %eax,0x4(%esp)
    18da:	8b 45 0c             	mov    0xc(%ebp),%eax
    18dd:	89 04 24             	mov    %eax,(%esp)
    18e0:	e8 47 fc ff ff       	call   152c <gettoken>
    18e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
    18e8:	8d 45 ec             	lea    -0x14(%ebp),%eax
    18eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
    18ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
    18f2:	89 44 24 08          	mov    %eax,0x8(%esp)
    18f6:	8b 45 10             	mov    0x10(%ebp),%eax
    18f9:	89 44 24 04          	mov    %eax,0x4(%esp)
    18fd:	8b 45 0c             	mov    0xc(%ebp),%eax
    1900:	89 04 24             	mov    %eax,(%esp)
    1903:	e8 24 fc ff ff       	call   152c <gettoken>
    1908:	83 f8 61             	cmp    $0x61,%eax
    190b:	74 0c                	je     1919 <parseredirs+0x61>
      panic("missing file for redirection");
    190d:	c7 04 24 f3 24 00 00 	movl   $0x24f3,(%esp)
    1914:	e8 38 fa ff ff       	call   1351 <panic>
    switch(tok){
    1919:	8b 45 f4             	mov    -0xc(%ebp),%eax
    191c:	83 f8 3c             	cmp    $0x3c,%eax
    191f:	74 0f                	je     1930 <parseredirs+0x78>
    1921:	83 f8 3e             	cmp    $0x3e,%eax
    1924:	74 38                	je     195e <parseredirs+0xa6>
    1926:	83 f8 2b             	cmp    $0x2b,%eax
    1929:	74 61                	je     198c <parseredirs+0xd4>
    192b:	e9 89 00 00 00       	jmp    19b9 <parseredirs+0x101>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
    1930:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1933:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1936:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
    193d:	00 
    193e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1945:	00 
    1946:	89 54 24 08          	mov    %edx,0x8(%esp)
    194a:	89 44 24 04          	mov    %eax,0x4(%esp)
    194e:	8b 45 08             	mov    0x8(%ebp),%eax
    1951:	89 04 24             	mov    %eax,(%esp)
    1954:	e8 81 fa ff ff       	call   13da <redircmd>
    1959:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
    195c:	eb 5b                	jmp    19b9 <parseredirs+0x101>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
    195e:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1961:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1964:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
    196b:	00 
    196c:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
    1973:	00 
    1974:	89 54 24 08          	mov    %edx,0x8(%esp)
    1978:	89 44 24 04          	mov    %eax,0x4(%esp)
    197c:	8b 45 08             	mov    0x8(%ebp),%eax
    197f:	89 04 24             	mov    %eax,(%esp)
    1982:	e8 53 fa ff ff       	call   13da <redircmd>
    1987:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
    198a:	eb 2d                	jmp    19b9 <parseredirs+0x101>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
    198c:	8b 55 ec             	mov    -0x14(%ebp),%edx
    198f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1992:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
    1999:	00 
    199a:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
    19a1:	00 
    19a2:	89 54 24 08          	mov    %edx,0x8(%esp)
    19a6:	89 44 24 04          	mov    %eax,0x4(%esp)
    19aa:	8b 45 08             	mov    0x8(%ebp),%eax
    19ad:	89 04 24             	mov    %eax,(%esp)
    19b0:	e8 25 fa ff ff       	call   13da <redircmd>
    19b5:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
    19b8:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    19b9:	c7 44 24 08 10 25 00 	movl   $0x2510,0x8(%esp)
    19c0:	00 
    19c1:	8b 45 10             	mov    0x10(%ebp),%eax
    19c4:	89 44 24 04          	mov    %eax,0x4(%esp)
    19c8:	8b 45 0c             	mov    0xc(%ebp),%eax
    19cb:	89 04 24             	mov    %eax,(%esp)
    19ce:	e8 90 fc ff ff       	call   1663 <peek>
    19d3:	85 c0                	test   %eax,%eax
    19d5:	0f 85 e8 fe ff ff    	jne    18c3 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
    19db:	8b 45 08             	mov    0x8(%ebp),%eax
}
    19de:	c9                   	leave  
    19df:	c3                   	ret    

000019e0 <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
    19e0:	55                   	push   %ebp
    19e1:	89 e5                	mov    %esp,%ebp
    19e3:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
    19e6:	c7 44 24 08 13 25 00 	movl   $0x2513,0x8(%esp)
    19ed:	00 
    19ee:	8b 45 0c             	mov    0xc(%ebp),%eax
    19f1:	89 44 24 04          	mov    %eax,0x4(%esp)
    19f5:	8b 45 08             	mov    0x8(%ebp),%eax
    19f8:	89 04 24             	mov    %eax,(%esp)
    19fb:	e8 63 fc ff ff       	call   1663 <peek>
    1a00:	85 c0                	test   %eax,%eax
    1a02:	75 0c                	jne    1a10 <parseblock+0x30>
    panic("parseblock");
    1a04:	c7 04 24 15 25 00 00 	movl   $0x2515,(%esp)
    1a0b:	e8 41 f9 ff ff       	call   1351 <panic>
  gettoken(ps, es, 0, 0);
    1a10:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1a17:	00 
    1a18:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    1a1f:	00 
    1a20:	8b 45 0c             	mov    0xc(%ebp),%eax
    1a23:	89 44 24 04          	mov    %eax,0x4(%esp)
    1a27:	8b 45 08             	mov    0x8(%ebp),%eax
    1a2a:	89 04 24             	mov    %eax,(%esp)
    1a2d:	e8 fa fa ff ff       	call   152c <gettoken>
  cmd = parseline(ps, es);
    1a32:	8b 45 0c             	mov    0xc(%ebp),%eax
    1a35:	89 44 24 04          	mov    %eax,0x4(%esp)
    1a39:	8b 45 08             	mov    0x8(%ebp),%eax
    1a3c:	89 04 24             	mov    %eax,(%esp)
    1a3f:	e8 1c fd ff ff       	call   1760 <parseline>
    1a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
    1a47:	c7 44 24 08 20 25 00 	movl   $0x2520,0x8(%esp)
    1a4e:	00 
    1a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1a52:	89 44 24 04          	mov    %eax,0x4(%esp)
    1a56:	8b 45 08             	mov    0x8(%ebp),%eax
    1a59:	89 04 24             	mov    %eax,(%esp)
    1a5c:	e8 02 fc ff ff       	call   1663 <peek>
    1a61:	85 c0                	test   %eax,%eax
    1a63:	75 0c                	jne    1a71 <parseblock+0x91>
    panic("syntax - missing )");
    1a65:	c7 04 24 22 25 00 00 	movl   $0x2522,(%esp)
    1a6c:	e8 e0 f8 ff ff       	call   1351 <panic>
  gettoken(ps, es, 0, 0);
    1a71:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1a78:	00 
    1a79:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    1a80:	00 
    1a81:	8b 45 0c             	mov    0xc(%ebp),%eax
    1a84:	89 44 24 04          	mov    %eax,0x4(%esp)
    1a88:	8b 45 08             	mov    0x8(%ebp),%eax
    1a8b:	89 04 24             	mov    %eax,(%esp)
    1a8e:	e8 99 fa ff ff       	call   152c <gettoken>
  cmd = parseredirs(cmd, ps, es);
    1a93:	8b 45 0c             	mov    0xc(%ebp),%eax
    1a96:	89 44 24 08          	mov    %eax,0x8(%esp)
    1a9a:	8b 45 08             	mov    0x8(%ebp),%eax
    1a9d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aa4:	89 04 24             	mov    %eax,(%esp)
    1aa7:	e8 0c fe ff ff       	call   18b8 <parseredirs>
    1aac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
    1aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    1ab2:	c9                   	leave  
    1ab3:	c3                   	ret    

00001ab4 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
    1ab4:	55                   	push   %ebp
    1ab5:	89 e5                	mov    %esp,%ebp
    1ab7:	83 ec 38             	sub    $0x38,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
    1aba:	c7 44 24 08 13 25 00 	movl   $0x2513,0x8(%esp)
    1ac1:	00 
    1ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
    1ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
    1ac9:	8b 45 08             	mov    0x8(%ebp),%eax
    1acc:	89 04 24             	mov    %eax,(%esp)
    1acf:	e8 8f fb ff ff       	call   1663 <peek>
    1ad4:	85 c0                	test   %eax,%eax
    1ad6:	74 17                	je     1aef <parseexec+0x3b>
    return parseblock(ps, es);
    1ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
    1adb:	89 44 24 04          	mov    %eax,0x4(%esp)
    1adf:	8b 45 08             	mov    0x8(%ebp),%eax
    1ae2:	89 04 24             	mov    %eax,(%esp)
    1ae5:	e8 f6 fe ff ff       	call   19e0 <parseblock>
    1aea:	e9 0a 01 00 00       	jmp    1bf9 <parseexec+0x145>

  ret = execcmd();
    1aef:	e8 a8 f8 ff ff       	call   139c <execcmd>
    1af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
    1af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1afa:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
    1afd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
    1b04:	8b 45 0c             	mov    0xc(%ebp),%eax
    1b07:	89 44 24 08          	mov    %eax,0x8(%esp)
    1b0b:	8b 45 08             	mov    0x8(%ebp),%eax
    1b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b15:	89 04 24             	mov    %eax,(%esp)
    1b18:	e8 9b fd ff ff       	call   18b8 <parseredirs>
    1b1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
    1b20:	e9 8d 00 00 00       	jmp    1bb2 <parseexec+0xfe>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
    1b25:	8d 45 e0             	lea    -0x20(%ebp),%eax
    1b28:	89 44 24 0c          	mov    %eax,0xc(%esp)
    1b2c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    1b2f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1b33:	8b 45 0c             	mov    0xc(%ebp),%eax
    1b36:	89 44 24 04          	mov    %eax,0x4(%esp)
    1b3a:	8b 45 08             	mov    0x8(%ebp),%eax
    1b3d:	89 04 24             	mov    %eax,(%esp)
    1b40:	e8 e7 f9 ff ff       	call   152c <gettoken>
    1b45:	89 45 e8             	mov    %eax,-0x18(%ebp)
    1b48:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1b4c:	0f 84 84 00 00 00    	je     1bd6 <parseexec+0x122>
      break;
    if(tok != 'a')
    1b52:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
    1b56:	74 0c                	je     1b64 <parseexec+0xb0>
      panic("syntax");
    1b58:	c7 04 24 e6 24 00 00 	movl   $0x24e6,(%esp)
    1b5f:	e8 ed f7 ff ff       	call   1351 <panic>
    cmd->argv[argc] = q;
    1b64:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    1b67:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1b6d:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
    1b71:	8b 55 e0             	mov    -0x20(%ebp),%edx
    1b74:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1b77:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1b7a:	83 c1 08             	add    $0x8,%ecx
    1b7d:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
    1b81:	ff 45 f4             	incl   -0xc(%ebp)
    if(argc >= MAXARGS)
    1b84:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1b88:	7e 0c                	jle    1b96 <parseexec+0xe2>
      panic("too many args");
    1b8a:	c7 04 24 35 25 00 00 	movl   $0x2535,(%esp)
    1b91:	e8 bb f7 ff ff       	call   1351 <panic>
    ret = parseredirs(ret, ps, es);
    1b96:	8b 45 0c             	mov    0xc(%ebp),%eax
    1b99:	89 44 24 08          	mov    %eax,0x8(%esp)
    1b9d:	8b 45 08             	mov    0x8(%ebp),%eax
    1ba0:	89 44 24 04          	mov    %eax,0x4(%esp)
    1ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ba7:	89 04 24             	mov    %eax,(%esp)
    1baa:	e8 09 fd ff ff       	call   18b8 <parseredirs>
    1baf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
    1bb2:	c7 44 24 08 43 25 00 	movl   $0x2543,0x8(%esp)
    1bb9:	00 
    1bba:	8b 45 0c             	mov    0xc(%ebp),%eax
    1bbd:	89 44 24 04          	mov    %eax,0x4(%esp)
    1bc1:	8b 45 08             	mov    0x8(%ebp),%eax
    1bc4:	89 04 24             	mov    %eax,(%esp)
    1bc7:	e8 97 fa ff ff       	call   1663 <peek>
    1bcc:	85 c0                	test   %eax,%eax
    1bce:	0f 84 51 ff ff ff    	je     1b25 <parseexec+0x71>
    1bd4:	eb 01                	jmp    1bd7 <parseexec+0x123>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    1bd6:	90                   	nop
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
    1bd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1bda:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1bdd:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
    1be4:	00 
  cmd->eargv[argc] = 0;
    1be5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1be8:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1beb:	83 c2 08             	add    $0x8,%edx
    1bee:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
    1bf5:	00 
  return ret;
    1bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1bf9:	c9                   	leave  
    1bfa:	c3                   	ret    

00001bfb <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
    1bfb:	55                   	push   %ebp
    1bfc:	89 e5                	mov    %esp,%ebp
    1bfe:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    1c01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1c05:	75 0a                	jne    1c11 <nulterminate+0x16>
    return 0;
    1c07:	b8 00 00 00 00       	mov    $0x0,%eax
    1c0c:	e9 c8 00 00 00       	jmp    1cd9 <nulterminate+0xde>
  
  switch(cmd->type){
    1c11:	8b 45 08             	mov    0x8(%ebp),%eax
    1c14:	8b 00                	mov    (%eax),%eax
    1c16:	83 f8 05             	cmp    $0x5,%eax
    1c19:	0f 87 b7 00 00 00    	ja     1cd6 <nulterminate+0xdb>
    1c1f:	8b 04 85 48 25 00 00 	mov    0x2548(,%eax,4),%eax
    1c26:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    1c28:	8b 45 08             	mov    0x8(%ebp),%eax
    1c2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
    1c2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1c35:	eb 13                	jmp    1c4a <nulterminate+0x4f>
      *ecmd->eargv[i] = 0;
    1c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1c3d:	83 c2 08             	add    $0x8,%edx
    1c40:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
    1c44:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
    1c47:	ff 45 f4             	incl   -0xc(%ebp)
    1c4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1c50:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
    1c54:	85 c0                	test   %eax,%eax
    1c56:	75 df                	jne    1c37 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
    1c58:	eb 7c                	jmp    1cd6 <nulterminate+0xdb>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    1c5a:	8b 45 08             	mov    0x8(%ebp),%eax
    1c5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
    1c60:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1c63:	8b 40 04             	mov    0x4(%eax),%eax
    1c66:	89 04 24             	mov    %eax,(%esp)
    1c69:	e8 8d ff ff ff       	call   1bfb <nulterminate>
    *rcmd->efile = 0;
    1c6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1c71:	8b 40 0c             	mov    0xc(%eax),%eax
    1c74:	c6 00 00             	movb   $0x0,(%eax)
    break;
    1c77:	eb 5d                	jmp    1cd6 <nulterminate+0xdb>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
    1c79:	8b 45 08             	mov    0x8(%ebp),%eax
    1c7c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
    1c7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1c82:	8b 40 04             	mov    0x4(%eax),%eax
    1c85:	89 04 24             	mov    %eax,(%esp)
    1c88:	e8 6e ff ff ff       	call   1bfb <nulterminate>
    nulterminate(pcmd->right);
    1c8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1c90:	8b 40 08             	mov    0x8(%eax),%eax
    1c93:	89 04 24             	mov    %eax,(%esp)
    1c96:	e8 60 ff ff ff       	call   1bfb <nulterminate>
    break;
    1c9b:	eb 39                	jmp    1cd6 <nulterminate+0xdb>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
    1c9d:	8b 45 08             	mov    0x8(%ebp),%eax
    1ca0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
    1ca3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1ca6:	8b 40 04             	mov    0x4(%eax),%eax
    1ca9:	89 04 24             	mov    %eax,(%esp)
    1cac:	e8 4a ff ff ff       	call   1bfb <nulterminate>
    nulterminate(lcmd->right);
    1cb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1cb4:	8b 40 08             	mov    0x8(%eax),%eax
    1cb7:	89 04 24             	mov    %eax,(%esp)
    1cba:	e8 3c ff ff ff       	call   1bfb <nulterminate>
    break;
    1cbf:	eb 15                	jmp    1cd6 <nulterminate+0xdb>

  case BACK:
    bcmd = (struct backcmd*)cmd;
    1cc1:	8b 45 08             	mov    0x8(%ebp),%eax
    1cc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
    1cc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1cca:	8b 40 04             	mov    0x4(%eax),%eax
    1ccd:	89 04 24             	mov    %eax,(%esp)
    1cd0:	e8 26 ff ff ff       	call   1bfb <nulterminate>
    break;
    1cd5:	90                   	nop
  }
  return cmd;
    1cd6:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1cd9:	c9                   	leave  
    1cda:	c3                   	ret    
    1cdb:	90                   	nop

00001cdc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    1cdc:	55                   	push   %ebp
    1cdd:	89 e5                	mov    %esp,%ebp
    1cdf:	57                   	push   %edi
    1ce0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1ce1:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1ce4:	8b 55 10             	mov    0x10(%ebp),%edx
    1ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
    1cea:	89 cb                	mov    %ecx,%ebx
    1cec:	89 df                	mov    %ebx,%edi
    1cee:	89 d1                	mov    %edx,%ecx
    1cf0:	fc                   	cld    
    1cf1:	f3 aa                	rep stos %al,%es:(%edi)
    1cf3:	89 ca                	mov    %ecx,%edx
    1cf5:	89 fb                	mov    %edi,%ebx
    1cf7:	89 5d 08             	mov    %ebx,0x8(%ebp)
    1cfa:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1cfd:	5b                   	pop    %ebx
    1cfe:	5f                   	pop    %edi
    1cff:	5d                   	pop    %ebp
    1d00:	c3                   	ret    

00001d01 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1d01:	55                   	push   %ebp
    1d02:	89 e5                	mov    %esp,%ebp
    1d04:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    1d07:	8b 45 08             	mov    0x8(%ebp),%eax
    1d0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1d0d:	90                   	nop
    1d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1d11:	8a 10                	mov    (%eax),%dl
    1d13:	8b 45 08             	mov    0x8(%ebp),%eax
    1d16:	88 10                	mov    %dl,(%eax)
    1d18:	8b 45 08             	mov    0x8(%ebp),%eax
    1d1b:	8a 00                	mov    (%eax),%al
    1d1d:	84 c0                	test   %al,%al
    1d1f:	0f 95 c0             	setne  %al
    1d22:	ff 45 08             	incl   0x8(%ebp)
    1d25:	ff 45 0c             	incl   0xc(%ebp)
    1d28:	84 c0                	test   %al,%al
    1d2a:	75 e2                	jne    1d0e <strcpy+0xd>
    ;
  return os;
    1d2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1d2f:	c9                   	leave  
    1d30:	c3                   	ret    

00001d31 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1d31:	55                   	push   %ebp
    1d32:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1d34:	eb 06                	jmp    1d3c <strcmp+0xb>
    p++, q++;
    1d36:	ff 45 08             	incl   0x8(%ebp)
    1d39:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1d3c:	8b 45 08             	mov    0x8(%ebp),%eax
    1d3f:	8a 00                	mov    (%eax),%al
    1d41:	84 c0                	test   %al,%al
    1d43:	74 0e                	je     1d53 <strcmp+0x22>
    1d45:	8b 45 08             	mov    0x8(%ebp),%eax
    1d48:	8a 10                	mov    (%eax),%dl
    1d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
    1d4d:	8a 00                	mov    (%eax),%al
    1d4f:	38 c2                	cmp    %al,%dl
    1d51:	74 e3                	je     1d36 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1d53:	8b 45 08             	mov    0x8(%ebp),%eax
    1d56:	8a 00                	mov    (%eax),%al
    1d58:	0f b6 d0             	movzbl %al,%edx
    1d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
    1d5e:	8a 00                	mov    (%eax),%al
    1d60:	0f b6 c0             	movzbl %al,%eax
    1d63:	89 d1                	mov    %edx,%ecx
    1d65:	29 c1                	sub    %eax,%ecx
    1d67:	89 c8                	mov    %ecx,%eax
}
    1d69:	5d                   	pop    %ebp
    1d6a:	c3                   	ret    

00001d6b <strlen>:

uint
strlen(char *s)
{
    1d6b:	55                   	push   %ebp
    1d6c:	89 e5                	mov    %esp,%ebp
    1d6e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1d71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1d78:	eb 03                	jmp    1d7d <strlen+0x12>
    1d7a:	ff 45 fc             	incl   -0x4(%ebp)
    1d7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1d80:	8b 45 08             	mov    0x8(%ebp),%eax
    1d83:	01 d0                	add    %edx,%eax
    1d85:	8a 00                	mov    (%eax),%al
    1d87:	84 c0                	test   %al,%al
    1d89:	75 ef                	jne    1d7a <strlen+0xf>
    ;
  return n;
    1d8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1d8e:	c9                   	leave  
    1d8f:	c3                   	ret    

00001d90 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1d90:	55                   	push   %ebp
    1d91:	89 e5                	mov    %esp,%ebp
    1d93:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    1d96:	8b 45 10             	mov    0x10(%ebp),%eax
    1d99:	89 44 24 08          	mov    %eax,0x8(%esp)
    1d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1da0:	89 44 24 04          	mov    %eax,0x4(%esp)
    1da4:	8b 45 08             	mov    0x8(%ebp),%eax
    1da7:	89 04 24             	mov    %eax,(%esp)
    1daa:	e8 2d ff ff ff       	call   1cdc <stosb>
  return dst;
    1daf:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1db2:	c9                   	leave  
    1db3:	c3                   	ret    

00001db4 <strchr>:

char*
strchr(const char *s, char c)
{
    1db4:	55                   	push   %ebp
    1db5:	89 e5                	mov    %esp,%ebp
    1db7:	83 ec 04             	sub    $0x4,%esp
    1dba:	8b 45 0c             	mov    0xc(%ebp),%eax
    1dbd:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1dc0:	eb 12                	jmp    1dd4 <strchr+0x20>
    if(*s == c)
    1dc2:	8b 45 08             	mov    0x8(%ebp),%eax
    1dc5:	8a 00                	mov    (%eax),%al
    1dc7:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1dca:	75 05                	jne    1dd1 <strchr+0x1d>
      return (char*)s;
    1dcc:	8b 45 08             	mov    0x8(%ebp),%eax
    1dcf:	eb 11                	jmp    1de2 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1dd1:	ff 45 08             	incl   0x8(%ebp)
    1dd4:	8b 45 08             	mov    0x8(%ebp),%eax
    1dd7:	8a 00                	mov    (%eax),%al
    1dd9:	84 c0                	test   %al,%al
    1ddb:	75 e5                	jne    1dc2 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1ddd:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1de2:	c9                   	leave  
    1de3:	c3                   	ret    

00001de4 <gets>:

char*
gets(char *buf, int max)
{
    1de4:	55                   	push   %ebp
    1de5:	89 e5                	mov    %esp,%ebp
    1de7:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1dea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1df1:	eb 42                	jmp    1e35 <gets+0x51>
    cc = read(0, &c, 1);
    1df3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1dfa:	00 
    1dfb:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1dfe:	89 44 24 04          	mov    %eax,0x4(%esp)
    1e02:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1e09:	e8 32 01 00 00       	call   1f40 <read>
    1e0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1e11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1e15:	7e 29                	jle    1e40 <gets+0x5c>
      break;
    buf[i++] = c;
    1e17:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1e1a:	8b 45 08             	mov    0x8(%ebp),%eax
    1e1d:	01 c2                	add    %eax,%edx
    1e1f:	8a 45 ef             	mov    -0x11(%ebp),%al
    1e22:	88 02                	mov    %al,(%edx)
    1e24:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
    1e27:	8a 45 ef             	mov    -0x11(%ebp),%al
    1e2a:	3c 0a                	cmp    $0xa,%al
    1e2c:	74 13                	je     1e41 <gets+0x5d>
    1e2e:	8a 45 ef             	mov    -0x11(%ebp),%al
    1e31:	3c 0d                	cmp    $0xd,%al
    1e33:	74 0c                	je     1e41 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e38:	40                   	inc    %eax
    1e39:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1e3c:	7c b5                	jl     1df3 <gets+0xf>
    1e3e:	eb 01                	jmp    1e41 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    1e40:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1e41:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1e44:	8b 45 08             	mov    0x8(%ebp),%eax
    1e47:	01 d0                	add    %edx,%eax
    1e49:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1e4c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1e4f:	c9                   	leave  
    1e50:	c3                   	ret    

00001e51 <stat>:

int
stat(char *n, struct stat *st)
{
    1e51:	55                   	push   %ebp
    1e52:	89 e5                	mov    %esp,%ebp
    1e54:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1e57:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1e5e:	00 
    1e5f:	8b 45 08             	mov    0x8(%ebp),%eax
    1e62:	89 04 24             	mov    %eax,(%esp)
    1e65:	e8 fe 00 00 00       	call   1f68 <open>
    1e6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1e6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1e71:	79 07                	jns    1e7a <stat+0x29>
    return -1;
    1e73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1e78:	eb 23                	jmp    1e9d <stat+0x4c>
  r = fstat(fd, st);
    1e7a:	8b 45 0c             	mov    0xc(%ebp),%eax
    1e7d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e84:	89 04 24             	mov    %eax,(%esp)
    1e87:	e8 f4 00 00 00       	call   1f80 <fstat>
    1e8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e92:	89 04 24             	mov    %eax,(%esp)
    1e95:	e8 b6 00 00 00       	call   1f50 <close>
  return r;
    1e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1e9d:	c9                   	leave  
    1e9e:	c3                   	ret    

00001e9f <atoi>:

int
atoi(const char *s)
{
    1e9f:	55                   	push   %ebp
    1ea0:	89 e5                	mov    %esp,%ebp
    1ea2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1ea5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1eac:	eb 21                	jmp    1ecf <atoi+0x30>
    n = n*10 + *s++ - '0';
    1eae:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1eb1:	89 d0                	mov    %edx,%eax
    1eb3:	c1 e0 02             	shl    $0x2,%eax
    1eb6:	01 d0                	add    %edx,%eax
    1eb8:	d1 e0                	shl    %eax
    1eba:	89 c2                	mov    %eax,%edx
    1ebc:	8b 45 08             	mov    0x8(%ebp),%eax
    1ebf:	8a 00                	mov    (%eax),%al
    1ec1:	0f be c0             	movsbl %al,%eax
    1ec4:	01 d0                	add    %edx,%eax
    1ec6:	83 e8 30             	sub    $0x30,%eax
    1ec9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1ecc:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1ecf:	8b 45 08             	mov    0x8(%ebp),%eax
    1ed2:	8a 00                	mov    (%eax),%al
    1ed4:	3c 2f                	cmp    $0x2f,%al
    1ed6:	7e 09                	jle    1ee1 <atoi+0x42>
    1ed8:	8b 45 08             	mov    0x8(%ebp),%eax
    1edb:	8a 00                	mov    (%eax),%al
    1edd:	3c 39                	cmp    $0x39,%al
    1edf:	7e cd                	jle    1eae <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1ee1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1ee4:	c9                   	leave  
    1ee5:	c3                   	ret    

00001ee6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1ee6:	55                   	push   %ebp
    1ee7:	89 e5                	mov    %esp,%ebp
    1ee9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1eec:	8b 45 08             	mov    0x8(%ebp),%eax
    1eef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
    1ef5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1ef8:	eb 10                	jmp    1f0a <memmove+0x24>
    *dst++ = *src++;
    1efa:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1efd:	8a 10                	mov    (%eax),%dl
    1eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1f02:	88 10                	mov    %dl,(%eax)
    1f04:	ff 45 fc             	incl   -0x4(%ebp)
    1f07:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1f0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    1f0e:	0f 9f c0             	setg   %al
    1f11:	ff 4d 10             	decl   0x10(%ebp)
    1f14:	84 c0                	test   %al,%al
    1f16:	75 e2                	jne    1efa <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1f18:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1f1b:	c9                   	leave  
    1f1c:	c3                   	ret    
    1f1d:	66 90                	xchg   %ax,%ax
    1f1f:	90                   	nop

00001f20 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1f20:	b8 01 00 00 00       	mov    $0x1,%eax
    1f25:	cd 40                	int    $0x40
    1f27:	c3                   	ret    

00001f28 <exit>:
SYSCALL(exit)
    1f28:	b8 02 00 00 00       	mov    $0x2,%eax
    1f2d:	cd 40                	int    $0x40
    1f2f:	c3                   	ret    

00001f30 <wait>:
SYSCALL(wait)
    1f30:	b8 03 00 00 00       	mov    $0x3,%eax
    1f35:	cd 40                	int    $0x40
    1f37:	c3                   	ret    

00001f38 <pipe>:
SYSCALL(pipe)
    1f38:	b8 04 00 00 00       	mov    $0x4,%eax
    1f3d:	cd 40                	int    $0x40
    1f3f:	c3                   	ret    

00001f40 <read>:
SYSCALL(read)
    1f40:	b8 05 00 00 00       	mov    $0x5,%eax
    1f45:	cd 40                	int    $0x40
    1f47:	c3                   	ret    

00001f48 <write>:
SYSCALL(write)
    1f48:	b8 10 00 00 00       	mov    $0x10,%eax
    1f4d:	cd 40                	int    $0x40
    1f4f:	c3                   	ret    

00001f50 <close>:
SYSCALL(close)
    1f50:	b8 15 00 00 00       	mov    $0x15,%eax
    1f55:	cd 40                	int    $0x40
    1f57:	c3                   	ret    

00001f58 <kill>:
SYSCALL(kill)
    1f58:	b8 06 00 00 00       	mov    $0x6,%eax
    1f5d:	cd 40                	int    $0x40
    1f5f:	c3                   	ret    

00001f60 <exec>:
SYSCALL(exec)
    1f60:	b8 07 00 00 00       	mov    $0x7,%eax
    1f65:	cd 40                	int    $0x40
    1f67:	c3                   	ret    

00001f68 <open>:
SYSCALL(open)
    1f68:	b8 0f 00 00 00       	mov    $0xf,%eax
    1f6d:	cd 40                	int    $0x40
    1f6f:	c3                   	ret    

00001f70 <mknod>:
SYSCALL(mknod)
    1f70:	b8 11 00 00 00       	mov    $0x11,%eax
    1f75:	cd 40                	int    $0x40
    1f77:	c3                   	ret    

00001f78 <unlink>:
SYSCALL(unlink)
    1f78:	b8 12 00 00 00       	mov    $0x12,%eax
    1f7d:	cd 40                	int    $0x40
    1f7f:	c3                   	ret    

00001f80 <fstat>:
SYSCALL(fstat)
    1f80:	b8 08 00 00 00       	mov    $0x8,%eax
    1f85:	cd 40                	int    $0x40
    1f87:	c3                   	ret    

00001f88 <link>:
SYSCALL(link)
    1f88:	b8 13 00 00 00       	mov    $0x13,%eax
    1f8d:	cd 40                	int    $0x40
    1f8f:	c3                   	ret    

00001f90 <mkdir>:
SYSCALL(mkdir)
    1f90:	b8 14 00 00 00       	mov    $0x14,%eax
    1f95:	cd 40                	int    $0x40
    1f97:	c3                   	ret    

00001f98 <chdir>:
SYSCALL(chdir)
    1f98:	b8 09 00 00 00       	mov    $0x9,%eax
    1f9d:	cd 40                	int    $0x40
    1f9f:	c3                   	ret    

00001fa0 <dup>:
SYSCALL(dup)
    1fa0:	b8 0a 00 00 00       	mov    $0xa,%eax
    1fa5:	cd 40                	int    $0x40
    1fa7:	c3                   	ret    

00001fa8 <getpid>:
SYSCALL(getpid)
    1fa8:	b8 0b 00 00 00       	mov    $0xb,%eax
    1fad:	cd 40                	int    $0x40
    1faf:	c3                   	ret    

00001fb0 <sbrk>:
SYSCALL(sbrk)
    1fb0:	b8 0c 00 00 00       	mov    $0xc,%eax
    1fb5:	cd 40                	int    $0x40
    1fb7:	c3                   	ret    

00001fb8 <sleep>:
SYSCALL(sleep)
    1fb8:	b8 0d 00 00 00       	mov    $0xd,%eax
    1fbd:	cd 40                	int    $0x40
    1fbf:	c3                   	ret    

00001fc0 <uptime>:
SYSCALL(uptime)
    1fc0:	b8 0e 00 00 00       	mov    $0xe,%eax
    1fc5:	cd 40                	int    $0x40
    1fc7:	c3                   	ret    

00001fc8 <cowfork>:
SYSCALL(cowfork) //3.4
    1fc8:	b8 16 00 00 00       	mov    $0x16,%eax
    1fcd:	cd 40                	int    $0x40
    1fcf:	c3                   	ret    

00001fd0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1fd0:	55                   	push   %ebp
    1fd1:	89 e5                	mov    %esp,%ebp
    1fd3:	83 ec 28             	sub    $0x28,%esp
    1fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
    1fd9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1fdc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1fe3:	00 
    1fe4:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1fe7:	89 44 24 04          	mov    %eax,0x4(%esp)
    1feb:	8b 45 08             	mov    0x8(%ebp),%eax
    1fee:	89 04 24             	mov    %eax,(%esp)
    1ff1:	e8 52 ff ff ff       	call   1f48 <write>
}
    1ff6:	c9                   	leave  
    1ff7:	c3                   	ret    

00001ff8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1ff8:	55                   	push   %ebp
    1ff9:	89 e5                	mov    %esp,%ebp
    1ffb:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1ffe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    2005:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    2009:	74 17                	je     2022 <printint+0x2a>
    200b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    200f:	79 11                	jns    2022 <printint+0x2a>
    neg = 1;
    2011:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    2018:	8b 45 0c             	mov    0xc(%ebp),%eax
    201b:	f7 d8                	neg    %eax
    201d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    2020:	eb 06                	jmp    2028 <printint+0x30>
  } else {
    x = xx;
    2022:	8b 45 0c             	mov    0xc(%ebp),%eax
    2025:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    2028:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    202f:	8b 4d 10             	mov    0x10(%ebp),%ecx
    2032:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2035:	ba 00 00 00 00       	mov    $0x0,%edx
    203a:	f7 f1                	div    %ecx
    203c:	89 d0                	mov    %edx,%eax
    203e:	8a 80 f0 39 00 00    	mov    0x39f0(%eax),%al
    2044:	8d 4d dc             	lea    -0x24(%ebp),%ecx
    2047:	8b 55 f4             	mov    -0xc(%ebp),%edx
    204a:	01 ca                	add    %ecx,%edx
    204c:	88 02                	mov    %al,(%edx)
    204e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
    2051:	8b 55 10             	mov    0x10(%ebp),%edx
    2054:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    2057:	8b 45 ec             	mov    -0x14(%ebp),%eax
    205a:	ba 00 00 00 00       	mov    $0x0,%edx
    205f:	f7 75 d4             	divl   -0x2c(%ebp)
    2062:	89 45 ec             	mov    %eax,-0x14(%ebp)
    2065:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2069:	75 c4                	jne    202f <printint+0x37>
  if(neg)
    206b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    206f:	74 2c                	je     209d <printint+0xa5>
    buf[i++] = '-';
    2071:	8d 55 dc             	lea    -0x24(%ebp),%edx
    2074:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2077:	01 d0                	add    %edx,%eax
    2079:	c6 00 2d             	movb   $0x2d,(%eax)
    207c:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
    207f:	eb 1c                	jmp    209d <printint+0xa5>
    putc(fd, buf[i]);
    2081:	8d 55 dc             	lea    -0x24(%ebp),%edx
    2084:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2087:	01 d0                	add    %edx,%eax
    2089:	8a 00                	mov    (%eax),%al
    208b:	0f be c0             	movsbl %al,%eax
    208e:	89 44 24 04          	mov    %eax,0x4(%esp)
    2092:	8b 45 08             	mov    0x8(%ebp),%eax
    2095:	89 04 24             	mov    %eax,(%esp)
    2098:	e8 33 ff ff ff       	call   1fd0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    209d:	ff 4d f4             	decl   -0xc(%ebp)
    20a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    20a4:	79 db                	jns    2081 <printint+0x89>
    putc(fd, buf[i]);
}
    20a6:	c9                   	leave  
    20a7:	c3                   	ret    

000020a8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    20a8:	55                   	push   %ebp
    20a9:	89 e5                	mov    %esp,%ebp
    20ab:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    20ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    20b5:	8d 45 0c             	lea    0xc(%ebp),%eax
    20b8:	83 c0 04             	add    $0x4,%eax
    20bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    20be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    20c5:	e9 78 01 00 00       	jmp    2242 <printf+0x19a>
    c = fmt[i] & 0xff;
    20ca:	8b 55 0c             	mov    0xc(%ebp),%edx
    20cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    20d0:	01 d0                	add    %edx,%eax
    20d2:	8a 00                	mov    (%eax),%al
    20d4:	0f be c0             	movsbl %al,%eax
    20d7:	25 ff 00 00 00       	and    $0xff,%eax
    20dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    20df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    20e3:	75 2c                	jne    2111 <printf+0x69>
      if(c == '%'){
    20e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    20e9:	75 0c                	jne    20f7 <printf+0x4f>
        state = '%';
    20eb:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    20f2:	e9 48 01 00 00       	jmp    223f <printf+0x197>
      } else {
        putc(fd, c);
    20f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    20fa:	0f be c0             	movsbl %al,%eax
    20fd:	89 44 24 04          	mov    %eax,0x4(%esp)
    2101:	8b 45 08             	mov    0x8(%ebp),%eax
    2104:	89 04 24             	mov    %eax,(%esp)
    2107:	e8 c4 fe ff ff       	call   1fd0 <putc>
    210c:	e9 2e 01 00 00       	jmp    223f <printf+0x197>
      }
    } else if(state == '%'){
    2111:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    2115:	0f 85 24 01 00 00    	jne    223f <printf+0x197>
      if(c == 'd'){
    211b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    211f:	75 2d                	jne    214e <printf+0xa6>
        printint(fd, *ap, 10, 1);
    2121:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2124:	8b 00                	mov    (%eax),%eax
    2126:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    212d:	00 
    212e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    2135:	00 
    2136:	89 44 24 04          	mov    %eax,0x4(%esp)
    213a:	8b 45 08             	mov    0x8(%ebp),%eax
    213d:	89 04 24             	mov    %eax,(%esp)
    2140:	e8 b3 fe ff ff       	call   1ff8 <printint>
        ap++;
    2145:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    2149:	e9 ea 00 00 00       	jmp    2238 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
    214e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    2152:	74 06                	je     215a <printf+0xb2>
    2154:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    2158:	75 2d                	jne    2187 <printf+0xdf>
        printint(fd, *ap, 16, 0);
    215a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    215d:	8b 00                	mov    (%eax),%eax
    215f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    2166:	00 
    2167:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    216e:	00 
    216f:	89 44 24 04          	mov    %eax,0x4(%esp)
    2173:	8b 45 08             	mov    0x8(%ebp),%eax
    2176:	89 04 24             	mov    %eax,(%esp)
    2179:	e8 7a fe ff ff       	call   1ff8 <printint>
        ap++;
    217e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    2182:	e9 b1 00 00 00       	jmp    2238 <printf+0x190>
      } else if(c == 's'){
    2187:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    218b:	75 43                	jne    21d0 <printf+0x128>
        s = (char*)*ap;
    218d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2190:	8b 00                	mov    (%eax),%eax
    2192:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    2195:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    2199:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    219d:	75 25                	jne    21c4 <printf+0x11c>
          s = "(null)";
    219f:	c7 45 f4 60 25 00 00 	movl   $0x2560,-0xc(%ebp)
        while(*s != 0){
    21a6:	eb 1c                	jmp    21c4 <printf+0x11c>
          putc(fd, *s);
    21a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    21ab:	8a 00                	mov    (%eax),%al
    21ad:	0f be c0             	movsbl %al,%eax
    21b0:	89 44 24 04          	mov    %eax,0x4(%esp)
    21b4:	8b 45 08             	mov    0x8(%ebp),%eax
    21b7:	89 04 24             	mov    %eax,(%esp)
    21ba:	e8 11 fe ff ff       	call   1fd0 <putc>
          s++;
    21bf:	ff 45 f4             	incl   -0xc(%ebp)
    21c2:	eb 01                	jmp    21c5 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    21c4:	90                   	nop
    21c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    21c8:	8a 00                	mov    (%eax),%al
    21ca:	84 c0                	test   %al,%al
    21cc:	75 da                	jne    21a8 <printf+0x100>
    21ce:	eb 68                	jmp    2238 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    21d0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    21d4:	75 1d                	jne    21f3 <printf+0x14b>
        putc(fd, *ap);
    21d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    21d9:	8b 00                	mov    (%eax),%eax
    21db:	0f be c0             	movsbl %al,%eax
    21de:	89 44 24 04          	mov    %eax,0x4(%esp)
    21e2:	8b 45 08             	mov    0x8(%ebp),%eax
    21e5:	89 04 24             	mov    %eax,(%esp)
    21e8:	e8 e3 fd ff ff       	call   1fd0 <putc>
        ap++;
    21ed:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    21f1:	eb 45                	jmp    2238 <printf+0x190>
      } else if(c == '%'){
    21f3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    21f7:	75 17                	jne    2210 <printf+0x168>
        putc(fd, c);
    21f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    21fc:	0f be c0             	movsbl %al,%eax
    21ff:	89 44 24 04          	mov    %eax,0x4(%esp)
    2203:	8b 45 08             	mov    0x8(%ebp),%eax
    2206:	89 04 24             	mov    %eax,(%esp)
    2209:	e8 c2 fd ff ff       	call   1fd0 <putc>
    220e:	eb 28                	jmp    2238 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    2210:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    2217:	00 
    2218:	8b 45 08             	mov    0x8(%ebp),%eax
    221b:	89 04 24             	mov    %eax,(%esp)
    221e:	e8 ad fd ff ff       	call   1fd0 <putc>
        putc(fd, c);
    2223:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    2226:	0f be c0             	movsbl %al,%eax
    2229:	89 44 24 04          	mov    %eax,0x4(%esp)
    222d:	8b 45 08             	mov    0x8(%ebp),%eax
    2230:	89 04 24             	mov    %eax,(%esp)
    2233:	e8 98 fd ff ff       	call   1fd0 <putc>
      }
      state = 0;
    2238:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    223f:	ff 45 f0             	incl   -0x10(%ebp)
    2242:	8b 55 0c             	mov    0xc(%ebp),%edx
    2245:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2248:	01 d0                	add    %edx,%eax
    224a:	8a 00                	mov    (%eax),%al
    224c:	84 c0                	test   %al,%al
    224e:	0f 85 76 fe ff ff    	jne    20ca <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    2254:	c9                   	leave  
    2255:	c3                   	ret    
    2256:	66 90                	xchg   %ax,%ax

00002258 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    2258:	55                   	push   %ebp
    2259:	89 e5                	mov    %esp,%ebp
    225b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    225e:	8b 45 08             	mov    0x8(%ebp),%eax
    2261:	83 e8 08             	sub    $0x8,%eax
    2264:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2267:	a1 8c 3a 00 00       	mov    0x3a8c,%eax
    226c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    226f:	eb 24                	jmp    2295 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    2271:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2274:	8b 00                	mov    (%eax),%eax
    2276:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    2279:	77 12                	ja     228d <free+0x35>
    227b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    227e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    2281:	77 24                	ja     22a7 <free+0x4f>
    2283:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2286:	8b 00                	mov    (%eax),%eax
    2288:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    228b:	77 1a                	ja     22a7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    228d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2290:	8b 00                	mov    (%eax),%eax
    2292:	89 45 fc             	mov    %eax,-0x4(%ebp)
    2295:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2298:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    229b:	76 d4                	jbe    2271 <free+0x19>
    229d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    22a0:	8b 00                	mov    (%eax),%eax
    22a2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    22a5:	76 ca                	jbe    2271 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    22a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    22aa:	8b 40 04             	mov    0x4(%eax),%eax
    22ad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    22b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    22b7:	01 c2                	add    %eax,%edx
    22b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    22bc:	8b 00                	mov    (%eax),%eax
    22be:	39 c2                	cmp    %eax,%edx
    22c0:	75 24                	jne    22e6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    22c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    22c5:	8b 50 04             	mov    0x4(%eax),%edx
    22c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    22cb:	8b 00                	mov    (%eax),%eax
    22cd:	8b 40 04             	mov    0x4(%eax),%eax
    22d0:	01 c2                	add    %eax,%edx
    22d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    22d5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    22d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    22db:	8b 00                	mov    (%eax),%eax
    22dd:	8b 10                	mov    (%eax),%edx
    22df:	8b 45 f8             	mov    -0x8(%ebp),%eax
    22e2:	89 10                	mov    %edx,(%eax)
    22e4:	eb 0a                	jmp    22f0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    22e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    22e9:	8b 10                	mov    (%eax),%edx
    22eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    22ee:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    22f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    22f3:	8b 40 04             	mov    0x4(%eax),%eax
    22f6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    22fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2300:	01 d0                	add    %edx,%eax
    2302:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    2305:	75 20                	jne    2327 <free+0xcf>
    p->s.size += bp->s.size;
    2307:	8b 45 fc             	mov    -0x4(%ebp),%eax
    230a:	8b 50 04             	mov    0x4(%eax),%edx
    230d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    2310:	8b 40 04             	mov    0x4(%eax),%eax
    2313:	01 c2                	add    %eax,%edx
    2315:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2318:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    231b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    231e:	8b 10                	mov    (%eax),%edx
    2320:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2323:	89 10                	mov    %edx,(%eax)
    2325:	eb 08                	jmp    232f <free+0xd7>
  } else
    p->s.ptr = bp;
    2327:	8b 45 fc             	mov    -0x4(%ebp),%eax
    232a:	8b 55 f8             	mov    -0x8(%ebp),%edx
    232d:	89 10                	mov    %edx,(%eax)
  freep = p;
    232f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    2332:	a3 8c 3a 00 00       	mov    %eax,0x3a8c
}
    2337:	c9                   	leave  
    2338:	c3                   	ret    

00002339 <morecore>:

static Header*
morecore(uint nu)
{
    2339:	55                   	push   %ebp
    233a:	89 e5                	mov    %esp,%ebp
    233c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    233f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    2346:	77 07                	ja     234f <morecore+0x16>
    nu = 4096;
    2348:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    234f:	8b 45 08             	mov    0x8(%ebp),%eax
    2352:	c1 e0 03             	shl    $0x3,%eax
    2355:	89 04 24             	mov    %eax,(%esp)
    2358:	e8 53 fc ff ff       	call   1fb0 <sbrk>
    235d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    2360:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    2364:	75 07                	jne    236d <morecore+0x34>
    return 0;
    2366:	b8 00 00 00 00       	mov    $0x0,%eax
    236b:	eb 22                	jmp    238f <morecore+0x56>
  hp = (Header*)p;
    236d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2370:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    2373:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2376:	8b 55 08             	mov    0x8(%ebp),%edx
    2379:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    237c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    237f:	83 c0 08             	add    $0x8,%eax
    2382:	89 04 24             	mov    %eax,(%esp)
    2385:	e8 ce fe ff ff       	call   2258 <free>
  return freep;
    238a:	a1 8c 3a 00 00       	mov    0x3a8c,%eax
}
    238f:	c9                   	leave  
    2390:	c3                   	ret    

00002391 <malloc>:

void*
malloc(uint nbytes)
{
    2391:	55                   	push   %ebp
    2392:	89 e5                	mov    %esp,%ebp
    2394:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    2397:	8b 45 08             	mov    0x8(%ebp),%eax
    239a:	83 c0 07             	add    $0x7,%eax
    239d:	c1 e8 03             	shr    $0x3,%eax
    23a0:	40                   	inc    %eax
    23a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    23a4:	a1 8c 3a 00 00       	mov    0x3a8c,%eax
    23a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    23ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    23b0:	75 23                	jne    23d5 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    23b2:	c7 45 f0 84 3a 00 00 	movl   $0x3a84,-0x10(%ebp)
    23b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    23bc:	a3 8c 3a 00 00       	mov    %eax,0x3a8c
    23c1:	a1 8c 3a 00 00       	mov    0x3a8c,%eax
    23c6:	a3 84 3a 00 00       	mov    %eax,0x3a84
    base.s.size = 0;
    23cb:	c7 05 88 3a 00 00 00 	movl   $0x0,0x3a88
    23d2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    23d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    23d8:	8b 00                	mov    (%eax),%eax
    23da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    23dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    23e0:	8b 40 04             	mov    0x4(%eax),%eax
    23e3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    23e6:	72 4d                	jb     2435 <malloc+0xa4>
      if(p->s.size == nunits)
    23e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    23eb:	8b 40 04             	mov    0x4(%eax),%eax
    23ee:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    23f1:	75 0c                	jne    23ff <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    23f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    23f6:	8b 10                	mov    (%eax),%edx
    23f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    23fb:	89 10                	mov    %edx,(%eax)
    23fd:	eb 26                	jmp    2425 <malloc+0x94>
      else {
        p->s.size -= nunits;
    23ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2402:	8b 40 04             	mov    0x4(%eax),%eax
    2405:	89 c2                	mov    %eax,%edx
    2407:	2b 55 ec             	sub    -0x14(%ebp),%edx
    240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    240d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    2410:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2413:	8b 40 04             	mov    0x4(%eax),%eax
    2416:	c1 e0 03             	shl    $0x3,%eax
    2419:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    241c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    241f:	8b 55 ec             	mov    -0x14(%ebp),%edx
    2422:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    2425:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2428:	a3 8c 3a 00 00       	mov    %eax,0x3a8c
      return (void*)(p + 1);
    242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2430:	83 c0 08             	add    $0x8,%eax
    2433:	eb 38                	jmp    246d <malloc+0xdc>
    }
    if(p == freep)
    2435:	a1 8c 3a 00 00       	mov    0x3a8c,%eax
    243a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    243d:	75 1b                	jne    245a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    243f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2442:	89 04 24             	mov    %eax,(%esp)
    2445:	e8 ef fe ff ff       	call   2339 <morecore>
    244a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    244d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2451:	75 07                	jne    245a <malloc+0xc9>
        return 0;
    2453:	b8 00 00 00 00       	mov    $0x0,%eax
    2458:	eb 13                	jmp    246d <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    245a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    245d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    2460:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2463:	8b 00                	mov    (%eax),%eax
    2465:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    2468:	e9 70 ff ff ff       	jmp    23dd <malloc+0x4c>
}
    246d:	c9                   	leave  
    246e:	c3                   	ret    
