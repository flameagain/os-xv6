
user/_sh：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  fprintf(2, "$ ");
      10:	00001597          	auipc	a1,0x1
      14:	31058593          	addi	a1,a1,784 # 1320 <malloc+0x106>
      18:	4509                	li	a0,2
      1a:	00001097          	auipc	ra,0x1
      1e:	11a080e7          	jalr	282(ra) # 1134 <fprintf>
  memset(buf, 0, nbuf);
      22:	864a                	mv	a2,s2
      24:	4581                	li	a1,0
      26:	8526                	mv	a0,s1
      28:	00001097          	auipc	ra,0x1
      2c:	bb2080e7          	jalr	-1102(ra) # bda <memset>
  gets(buf, nbuf);
      30:	85ca                	mv	a1,s2
      32:	8526                	mv	a0,s1
      34:	00001097          	auipc	ra,0x1
      38:	bec080e7          	jalr	-1044(ra) # c20 <gets>
  if(buf[0] == 0) // EOF
      3c:	0004c503          	lbu	a0,0(s1)
      40:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      44:	40a00533          	neg	a0,a0
      48:	60e2                	ld	ra,24(sp)
      4a:	6442                	ld	s0,16(sp)
      4c:	64a2                	ld	s1,8(sp)
      4e:	6902                	ld	s2,0(sp)
      50:	6105                	addi	sp,sp,32
      52:	8082                	ret

0000000000000054 <panic>:
  exit(0);
}

void
panic(char *s)
{
      54:	1141                	addi	sp,sp,-16
      56:	e406                	sd	ra,8(sp)
      58:	e022                	sd	s0,0(sp)
      5a:	0800                	addi	s0,sp,16
      5c:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      5e:	00001597          	auipc	a1,0x1
      62:	2d258593          	addi	a1,a1,722 # 1330 <malloc+0x116>
      66:	4509                	li	a0,2
      68:	00001097          	auipc	ra,0x1
      6c:	0cc080e7          	jalr	204(ra) # 1134 <fprintf>
  exit(1);
      70:	4505                	li	a0,1
      72:	00001097          	auipc	ra,0x1
      76:	d78080e7          	jalr	-648(ra) # dea <exit>

000000000000007a <fork1>:
}

int
fork1(void)
{
      7a:	1141                	addi	sp,sp,-16
      7c:	e406                	sd	ra,8(sp)
      7e:	e022                	sd	s0,0(sp)
      80:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      82:	00001097          	auipc	ra,0x1
      86:	d60080e7          	jalr	-672(ra) # de2 <fork>
  if(pid == -1)
      8a:	57fd                	li	a5,-1
      8c:	00f50663          	beq	a0,a5,98 <fork1+0x1e>
    panic("fork");
  return pid;
}
      90:	60a2                	ld	ra,8(sp)
      92:	6402                	ld	s0,0(sp)
      94:	0141                	addi	sp,sp,16
      96:	8082                	ret
    panic("fork");
      98:	00001517          	auipc	a0,0x1
      9c:	2a050513          	addi	a0,a0,672 # 1338 <malloc+0x11e>
      a0:	00000097          	auipc	ra,0x0
      a4:	fb4080e7          	jalr	-76(ra) # 54 <panic>

00000000000000a8 <runcmd>:
{
      a8:	7179                	addi	sp,sp,-48
      aa:	f406                	sd	ra,40(sp)
      ac:	f022                	sd	s0,32(sp)
      ae:	1800                	addi	s0,sp,48
  if(cmd == 0)
      b0:	c115                	beqz	a0,d4 <runcmd+0x2c>
      b2:	ec26                	sd	s1,24(sp)
      b4:	84aa                	mv	s1,a0
  switch(cmd->type){
      b6:	4118                	lw	a4,0(a0)
      b8:	4795                	li	a5,5
      ba:	02e7e363          	bltu	a5,a4,e0 <runcmd+0x38>
      be:	00056783          	lwu	a5,0(a0)
      c2:	078a                	slli	a5,a5,0x2
      c4:	00001717          	auipc	a4,0x1
      c8:	37470713          	addi	a4,a4,884 # 1438 <malloc+0x21e>
      cc:	97ba                	add	a5,a5,a4
      ce:	439c                	lw	a5,0(a5)
      d0:	97ba                	add	a5,a5,a4
      d2:	8782                	jr	a5
      d4:	ec26                	sd	s1,24(sp)
    exit(1);
      d6:	4505                	li	a0,1
      d8:	00001097          	auipc	ra,0x1
      dc:	d12080e7          	jalr	-750(ra) # dea <exit>
    panic("runcmd");
      e0:	00001517          	auipc	a0,0x1
      e4:	26050513          	addi	a0,a0,608 # 1340 <malloc+0x126>
      e8:	00000097          	auipc	ra,0x0
      ec:	f6c080e7          	jalr	-148(ra) # 54 <panic>
    if(ecmd->argv[0] == 0)
      f0:	6508                	ld	a0,8(a0)
      f2:	c515                	beqz	a0,11e <runcmd+0x76>
    exec(ecmd->argv[0], ecmd->argv);
      f4:	00848593          	addi	a1,s1,8
      f8:	00001097          	auipc	ra,0x1
      fc:	d2a080e7          	jalr	-726(ra) # e22 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     100:	6490                	ld	a2,8(s1)
     102:	00001597          	auipc	a1,0x1
     106:	24658593          	addi	a1,a1,582 # 1348 <malloc+0x12e>
     10a:	4509                	li	a0,2
     10c:	00001097          	auipc	ra,0x1
     110:	028080e7          	jalr	40(ra) # 1134 <fprintf>
  exit(0);
     114:	4501                	li	a0,0
     116:	00001097          	auipc	ra,0x1
     11a:	cd4080e7          	jalr	-812(ra) # dea <exit>
      exit(1);
     11e:	4505                	li	a0,1
     120:	00001097          	auipc	ra,0x1
     124:	cca080e7          	jalr	-822(ra) # dea <exit>
    close(rcmd->fd);
     128:	5148                	lw	a0,36(a0)
     12a:	00001097          	auipc	ra,0x1
     12e:	ce8080e7          	jalr	-792(ra) # e12 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     132:	508c                	lw	a1,32(s1)
     134:	6888                	ld	a0,16(s1)
     136:	00001097          	auipc	ra,0x1
     13a:	cf4080e7          	jalr	-780(ra) # e2a <open>
     13e:	00054763          	bltz	a0,14c <runcmd+0xa4>
    runcmd(rcmd->cmd);
     142:	6488                	ld	a0,8(s1)
     144:	00000097          	auipc	ra,0x0
     148:	f64080e7          	jalr	-156(ra) # a8 <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     14c:	6890                	ld	a2,16(s1)
     14e:	00001597          	auipc	a1,0x1
     152:	20a58593          	addi	a1,a1,522 # 1358 <malloc+0x13e>
     156:	4509                	li	a0,2
     158:	00001097          	auipc	ra,0x1
     15c:	fdc080e7          	jalr	-36(ra) # 1134 <fprintf>
      exit(1);
     160:	4505                	li	a0,1
     162:	00001097          	auipc	ra,0x1
     166:	c88080e7          	jalr	-888(ra) # dea <exit>
    if(fork1() == 0)
     16a:	00000097          	auipc	ra,0x0
     16e:	f10080e7          	jalr	-240(ra) # 7a <fork1>
     172:	e511                	bnez	a0,17e <runcmd+0xd6>
      runcmd(lcmd->left);
     174:	6488                	ld	a0,8(s1)
     176:	00000097          	auipc	ra,0x0
     17a:	f32080e7          	jalr	-206(ra) # a8 <runcmd>
    wait(0);
     17e:	4501                	li	a0,0
     180:	00001097          	auipc	ra,0x1
     184:	c72080e7          	jalr	-910(ra) # df2 <wait>
    runcmd(lcmd->right);
     188:	6888                	ld	a0,16(s1)
     18a:	00000097          	auipc	ra,0x0
     18e:	f1e080e7          	jalr	-226(ra) # a8 <runcmd>
    if(pipe(p) < 0)
     192:	fd840513          	addi	a0,s0,-40
     196:	00001097          	auipc	ra,0x1
     19a:	c64080e7          	jalr	-924(ra) # dfa <pipe>
     19e:	04054363          	bltz	a0,1e4 <runcmd+0x13c>
    if(fork1() == 0){
     1a2:	00000097          	auipc	ra,0x0
     1a6:	ed8080e7          	jalr	-296(ra) # 7a <fork1>
     1aa:	e529                	bnez	a0,1f4 <runcmd+0x14c>
      close(1);
     1ac:	4505                	li	a0,1
     1ae:	00001097          	auipc	ra,0x1
     1b2:	c64080e7          	jalr	-924(ra) # e12 <close>
      dup(p[1]);
     1b6:	fdc42503          	lw	a0,-36(s0)
     1ba:	00001097          	auipc	ra,0x1
     1be:	ca8080e7          	jalr	-856(ra) # e62 <dup>
      close(p[0]);
     1c2:	fd842503          	lw	a0,-40(s0)
     1c6:	00001097          	auipc	ra,0x1
     1ca:	c4c080e7          	jalr	-948(ra) # e12 <close>
      close(p[1]);
     1ce:	fdc42503          	lw	a0,-36(s0)
     1d2:	00001097          	auipc	ra,0x1
     1d6:	c40080e7          	jalr	-960(ra) # e12 <close>
      runcmd(pcmd->left);
     1da:	6488                	ld	a0,8(s1)
     1dc:	00000097          	auipc	ra,0x0
     1e0:	ecc080e7          	jalr	-308(ra) # a8 <runcmd>
      panic("pipe");
     1e4:	00001517          	auipc	a0,0x1
     1e8:	18450513          	addi	a0,a0,388 # 1368 <malloc+0x14e>
     1ec:	00000097          	auipc	ra,0x0
     1f0:	e68080e7          	jalr	-408(ra) # 54 <panic>
    if(fork1() == 0){
     1f4:	00000097          	auipc	ra,0x0
     1f8:	e86080e7          	jalr	-378(ra) # 7a <fork1>
     1fc:	ed05                	bnez	a0,234 <runcmd+0x18c>
      close(0);
     1fe:	00001097          	auipc	ra,0x1
     202:	c14080e7          	jalr	-1004(ra) # e12 <close>
      dup(p[0]);
     206:	fd842503          	lw	a0,-40(s0)
     20a:	00001097          	auipc	ra,0x1
     20e:	c58080e7          	jalr	-936(ra) # e62 <dup>
      close(p[0]);
     212:	fd842503          	lw	a0,-40(s0)
     216:	00001097          	auipc	ra,0x1
     21a:	bfc080e7          	jalr	-1028(ra) # e12 <close>
      close(p[1]);
     21e:	fdc42503          	lw	a0,-36(s0)
     222:	00001097          	auipc	ra,0x1
     226:	bf0080e7          	jalr	-1040(ra) # e12 <close>
      runcmd(pcmd->right);
     22a:	6888                	ld	a0,16(s1)
     22c:	00000097          	auipc	ra,0x0
     230:	e7c080e7          	jalr	-388(ra) # a8 <runcmd>
    close(p[0]);
     234:	fd842503          	lw	a0,-40(s0)
     238:	00001097          	auipc	ra,0x1
     23c:	bda080e7          	jalr	-1062(ra) # e12 <close>
    close(p[1]);
     240:	fdc42503          	lw	a0,-36(s0)
     244:	00001097          	auipc	ra,0x1
     248:	bce080e7          	jalr	-1074(ra) # e12 <close>
    wait(0);
     24c:	4501                	li	a0,0
     24e:	00001097          	auipc	ra,0x1
     252:	ba4080e7          	jalr	-1116(ra) # df2 <wait>
    wait(0);
     256:	4501                	li	a0,0
     258:	00001097          	auipc	ra,0x1
     25c:	b9a080e7          	jalr	-1126(ra) # df2 <wait>
    break;
     260:	bd55                	j	114 <runcmd+0x6c>
    if(fork1() == 0)
     262:	00000097          	auipc	ra,0x0
     266:	e18080e7          	jalr	-488(ra) # 7a <fork1>
     26a:	ea0515e3          	bnez	a0,114 <runcmd+0x6c>
      runcmd(bcmd->cmd);
     26e:	6488                	ld	a0,8(s1)
     270:	00000097          	auipc	ra,0x0
     274:	e38080e7          	jalr	-456(ra) # a8 <runcmd>

0000000000000278 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     278:	1101                	addi	sp,sp,-32
     27a:	ec06                	sd	ra,24(sp)
     27c:	e822                	sd	s0,16(sp)
     27e:	e426                	sd	s1,8(sp)
     280:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     282:	0a800513          	li	a0,168
     286:	00001097          	auipc	ra,0x1
     28a:	f94080e7          	jalr	-108(ra) # 121a <malloc>
     28e:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     290:	0a800613          	li	a2,168
     294:	4581                	li	a1,0
     296:	00001097          	auipc	ra,0x1
     29a:	944080e7          	jalr	-1724(ra) # bda <memset>
  cmd->type = EXEC;
     29e:	4785                	li	a5,1
     2a0:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     2a2:	8526                	mv	a0,s1
     2a4:	60e2                	ld	ra,24(sp)
     2a6:	6442                	ld	s0,16(sp)
     2a8:	64a2                	ld	s1,8(sp)
     2aa:	6105                	addi	sp,sp,32
     2ac:	8082                	ret

00000000000002ae <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2ae:	7139                	addi	sp,sp,-64
     2b0:	fc06                	sd	ra,56(sp)
     2b2:	f822                	sd	s0,48(sp)
     2b4:	f426                	sd	s1,40(sp)
     2b6:	f04a                	sd	s2,32(sp)
     2b8:	ec4e                	sd	s3,24(sp)
     2ba:	e852                	sd	s4,16(sp)
     2bc:	e456                	sd	s5,8(sp)
     2be:	e05a                	sd	s6,0(sp)
     2c0:	0080                	addi	s0,sp,64
     2c2:	8b2a                	mv	s6,a0
     2c4:	8aae                	mv	s5,a1
     2c6:	8a32                	mv	s4,a2
     2c8:	89b6                	mv	s3,a3
     2ca:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2cc:	02800513          	li	a0,40
     2d0:	00001097          	auipc	ra,0x1
     2d4:	f4a080e7          	jalr	-182(ra) # 121a <malloc>
     2d8:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2da:	02800613          	li	a2,40
     2de:	4581                	li	a1,0
     2e0:	00001097          	auipc	ra,0x1
     2e4:	8fa080e7          	jalr	-1798(ra) # bda <memset>
  cmd->type = REDIR;
     2e8:	4789                	li	a5,2
     2ea:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2ec:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     2f0:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     2f4:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     2f8:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     2fc:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     300:	8526                	mv	a0,s1
     302:	70e2                	ld	ra,56(sp)
     304:	7442                	ld	s0,48(sp)
     306:	74a2                	ld	s1,40(sp)
     308:	7902                	ld	s2,32(sp)
     30a:	69e2                	ld	s3,24(sp)
     30c:	6a42                	ld	s4,16(sp)
     30e:	6aa2                	ld	s5,8(sp)
     310:	6b02                	ld	s6,0(sp)
     312:	6121                	addi	sp,sp,64
     314:	8082                	ret

0000000000000316 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     316:	7179                	addi	sp,sp,-48
     318:	f406                	sd	ra,40(sp)
     31a:	f022                	sd	s0,32(sp)
     31c:	ec26                	sd	s1,24(sp)
     31e:	e84a                	sd	s2,16(sp)
     320:	e44e                	sd	s3,8(sp)
     322:	1800                	addi	s0,sp,48
     324:	89aa                	mv	s3,a0
     326:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     328:	4561                	li	a0,24
     32a:	00001097          	auipc	ra,0x1
     32e:	ef0080e7          	jalr	-272(ra) # 121a <malloc>
     332:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     334:	4661                	li	a2,24
     336:	4581                	li	a1,0
     338:	00001097          	auipc	ra,0x1
     33c:	8a2080e7          	jalr	-1886(ra) # bda <memset>
  cmd->type = PIPE;
     340:	478d                	li	a5,3
     342:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     344:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     348:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     34c:	8526                	mv	a0,s1
     34e:	70a2                	ld	ra,40(sp)
     350:	7402                	ld	s0,32(sp)
     352:	64e2                	ld	s1,24(sp)
     354:	6942                	ld	s2,16(sp)
     356:	69a2                	ld	s3,8(sp)
     358:	6145                	addi	sp,sp,48
     35a:	8082                	ret

000000000000035c <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     35c:	7179                	addi	sp,sp,-48
     35e:	f406                	sd	ra,40(sp)
     360:	f022                	sd	s0,32(sp)
     362:	ec26                	sd	s1,24(sp)
     364:	e84a                	sd	s2,16(sp)
     366:	e44e                	sd	s3,8(sp)
     368:	1800                	addi	s0,sp,48
     36a:	89aa                	mv	s3,a0
     36c:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     36e:	4561                	li	a0,24
     370:	00001097          	auipc	ra,0x1
     374:	eaa080e7          	jalr	-342(ra) # 121a <malloc>
     378:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     37a:	4661                	li	a2,24
     37c:	4581                	li	a1,0
     37e:	00001097          	auipc	ra,0x1
     382:	85c080e7          	jalr	-1956(ra) # bda <memset>
  cmd->type = LIST;
     386:	4791                	li	a5,4
     388:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     38a:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     38e:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     392:	8526                	mv	a0,s1
     394:	70a2                	ld	ra,40(sp)
     396:	7402                	ld	s0,32(sp)
     398:	64e2                	ld	s1,24(sp)
     39a:	6942                	ld	s2,16(sp)
     39c:	69a2                	ld	s3,8(sp)
     39e:	6145                	addi	sp,sp,48
     3a0:	8082                	ret

00000000000003a2 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     3a2:	1101                	addi	sp,sp,-32
     3a4:	ec06                	sd	ra,24(sp)
     3a6:	e822                	sd	s0,16(sp)
     3a8:	e426                	sd	s1,8(sp)
     3aa:	e04a                	sd	s2,0(sp)
     3ac:	1000                	addi	s0,sp,32
     3ae:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3b0:	4541                	li	a0,16
     3b2:	00001097          	auipc	ra,0x1
     3b6:	e68080e7          	jalr	-408(ra) # 121a <malloc>
     3ba:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3bc:	4641                	li	a2,16
     3be:	4581                	li	a1,0
     3c0:	00001097          	auipc	ra,0x1
     3c4:	81a080e7          	jalr	-2022(ra) # bda <memset>
  cmd->type = BACK;
     3c8:	4795                	li	a5,5
     3ca:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     3cc:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     3d0:	8526                	mv	a0,s1
     3d2:	60e2                	ld	ra,24(sp)
     3d4:	6442                	ld	s0,16(sp)
     3d6:	64a2                	ld	s1,8(sp)
     3d8:	6902                	ld	s2,0(sp)
     3da:	6105                	addi	sp,sp,32
     3dc:	8082                	ret

00000000000003de <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     3de:	7139                	addi	sp,sp,-64
     3e0:	fc06                	sd	ra,56(sp)
     3e2:	f822                	sd	s0,48(sp)
     3e4:	f426                	sd	s1,40(sp)
     3e6:	f04a                	sd	s2,32(sp)
     3e8:	ec4e                	sd	s3,24(sp)
     3ea:	e852                	sd	s4,16(sp)
     3ec:	e456                	sd	s5,8(sp)
     3ee:	e05a                	sd	s6,0(sp)
     3f0:	0080                	addi	s0,sp,64
     3f2:	8a2a                	mv	s4,a0
     3f4:	892e                	mv	s2,a1
     3f6:	8ab2                	mv	s5,a2
     3f8:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     3fa:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     3fc:	00002997          	auipc	s3,0x2
     400:	8ac98993          	addi	s3,s3,-1876 # 1ca8 <whitespace>
     404:	00b4fe63          	bgeu	s1,a1,420 <gettoken+0x42>
     408:	0004c583          	lbu	a1,0(s1)
     40c:	854e                	mv	a0,s3
     40e:	00000097          	auipc	ra,0x0
     412:	7ee080e7          	jalr	2030(ra) # bfc <strchr>
     416:	c509                	beqz	a0,420 <gettoken+0x42>
    s++;
     418:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     41a:	fe9917e3          	bne	s2,s1,408 <gettoken+0x2a>
     41e:	84ca                	mv	s1,s2
  if(q)
     420:	000a8463          	beqz	s5,428 <gettoken+0x4a>
    *q = s;
     424:	009ab023          	sd	s1,0(s5)
  ret = *s;
     428:	0004c783          	lbu	a5,0(s1)
     42c:	00078a9b          	sext.w	s5,a5
  switch(*s){
     430:	03c00713          	li	a4,60
     434:	06f76663          	bltu	a4,a5,4a0 <gettoken+0xc2>
     438:	03a00713          	li	a4,58
     43c:	00f76e63          	bltu	a4,a5,458 <gettoken+0x7a>
     440:	cf89                	beqz	a5,45a <gettoken+0x7c>
     442:	02600713          	li	a4,38
     446:	00e78963          	beq	a5,a4,458 <gettoken+0x7a>
     44a:	fd87879b          	addiw	a5,a5,-40
     44e:	0ff7f793          	zext.b	a5,a5
     452:	4705                	li	a4,1
     454:	06f76d63          	bltu	a4,a5,4ce <gettoken+0xf0>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     458:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     45a:	000b0463          	beqz	s6,462 <gettoken+0x84>
    *eq = s;
     45e:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     462:	00002997          	auipc	s3,0x2
     466:	84698993          	addi	s3,s3,-1978 # 1ca8 <whitespace>
     46a:	0124fe63          	bgeu	s1,s2,486 <gettoken+0xa8>
     46e:	0004c583          	lbu	a1,0(s1)
     472:	854e                	mv	a0,s3
     474:	00000097          	auipc	ra,0x0
     478:	788080e7          	jalr	1928(ra) # bfc <strchr>
     47c:	c509                	beqz	a0,486 <gettoken+0xa8>
    s++;
     47e:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     480:	fe9917e3          	bne	s2,s1,46e <gettoken+0x90>
     484:	84ca                	mv	s1,s2
  *ps = s;
     486:	009a3023          	sd	s1,0(s4)
  return ret;
}
     48a:	8556                	mv	a0,s5
     48c:	70e2                	ld	ra,56(sp)
     48e:	7442                	ld	s0,48(sp)
     490:	74a2                	ld	s1,40(sp)
     492:	7902                	ld	s2,32(sp)
     494:	69e2                	ld	s3,24(sp)
     496:	6a42                	ld	s4,16(sp)
     498:	6aa2                	ld	s5,8(sp)
     49a:	6b02                	ld	s6,0(sp)
     49c:	6121                	addi	sp,sp,64
     49e:	8082                	ret
  switch(*s){
     4a0:	03e00713          	li	a4,62
     4a4:	02e79163          	bne	a5,a4,4c6 <gettoken+0xe8>
    s++;
     4a8:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     4ac:	0014c703          	lbu	a4,1(s1)
     4b0:	03e00793          	li	a5,62
      s++;
     4b4:	0489                	addi	s1,s1,2
      ret = '+';
     4b6:	02b00a93          	li	s5,43
    if(*s == '>'){
     4ba:	faf700e3          	beq	a4,a5,45a <gettoken+0x7c>
    s++;
     4be:	84b6                	mv	s1,a3
  ret = *s;
     4c0:	03e00a93          	li	s5,62
     4c4:	bf59                	j	45a <gettoken+0x7c>
  switch(*s){
     4c6:	07c00713          	li	a4,124
     4ca:	f8e787e3          	beq	a5,a4,458 <gettoken+0x7a>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4ce:	00001997          	auipc	s3,0x1
     4d2:	7da98993          	addi	s3,s3,2010 # 1ca8 <whitespace>
     4d6:	00001a97          	auipc	s5,0x1
     4da:	7caa8a93          	addi	s5,s5,1994 # 1ca0 <symbols>
     4de:	0524f163          	bgeu	s1,s2,520 <gettoken+0x142>
     4e2:	0004c583          	lbu	a1,0(s1)
     4e6:	854e                	mv	a0,s3
     4e8:	00000097          	auipc	ra,0x0
     4ec:	714080e7          	jalr	1812(ra) # bfc <strchr>
     4f0:	e50d                	bnez	a0,51a <gettoken+0x13c>
     4f2:	0004c583          	lbu	a1,0(s1)
     4f6:	8556                	mv	a0,s5
     4f8:	00000097          	auipc	ra,0x0
     4fc:	704080e7          	jalr	1796(ra) # bfc <strchr>
     500:	e911                	bnez	a0,514 <gettoken+0x136>
      s++;
     502:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     504:	fc991fe3          	bne	s2,s1,4e2 <gettoken+0x104>
  if(eq)
     508:	84ca                	mv	s1,s2
    ret = 'a';
     50a:	06100a93          	li	s5,97
  if(eq)
     50e:	f40b18e3          	bnez	s6,45e <gettoken+0x80>
     512:	bf95                	j	486 <gettoken+0xa8>
    ret = 'a';
     514:	06100a93          	li	s5,97
     518:	b789                	j	45a <gettoken+0x7c>
     51a:	06100a93          	li	s5,97
     51e:	bf35                	j	45a <gettoken+0x7c>
     520:	06100a93          	li	s5,97
  if(eq)
     524:	f20b1de3          	bnez	s6,45e <gettoken+0x80>
     528:	bfb9                	j	486 <gettoken+0xa8>

000000000000052a <peek>:

int
peek(char **ps, char *es, char *toks)
{
     52a:	7139                	addi	sp,sp,-64
     52c:	fc06                	sd	ra,56(sp)
     52e:	f822                	sd	s0,48(sp)
     530:	f426                	sd	s1,40(sp)
     532:	f04a                	sd	s2,32(sp)
     534:	ec4e                	sd	s3,24(sp)
     536:	e852                	sd	s4,16(sp)
     538:	e456                	sd	s5,8(sp)
     53a:	0080                	addi	s0,sp,64
     53c:	8a2a                	mv	s4,a0
     53e:	892e                	mv	s2,a1
     540:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     542:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     544:	00001997          	auipc	s3,0x1
     548:	76498993          	addi	s3,s3,1892 # 1ca8 <whitespace>
     54c:	00b4fe63          	bgeu	s1,a1,568 <peek+0x3e>
     550:	0004c583          	lbu	a1,0(s1)
     554:	854e                	mv	a0,s3
     556:	00000097          	auipc	ra,0x0
     55a:	6a6080e7          	jalr	1702(ra) # bfc <strchr>
     55e:	c509                	beqz	a0,568 <peek+0x3e>
    s++;
     560:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     562:	fe9917e3          	bne	s2,s1,550 <peek+0x26>
     566:	84ca                	mv	s1,s2
  *ps = s;
     568:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     56c:	0004c583          	lbu	a1,0(s1)
     570:	4501                	li	a0,0
     572:	e991                	bnez	a1,586 <peek+0x5c>
}
     574:	70e2                	ld	ra,56(sp)
     576:	7442                	ld	s0,48(sp)
     578:	74a2                	ld	s1,40(sp)
     57a:	7902                	ld	s2,32(sp)
     57c:	69e2                	ld	s3,24(sp)
     57e:	6a42                	ld	s4,16(sp)
     580:	6aa2                	ld	s5,8(sp)
     582:	6121                	addi	sp,sp,64
     584:	8082                	ret
  return *s && strchr(toks, *s);
     586:	8556                	mv	a0,s5
     588:	00000097          	auipc	ra,0x0
     58c:	674080e7          	jalr	1652(ra) # bfc <strchr>
     590:	00a03533          	snez	a0,a0
     594:	b7c5                	j	574 <peek+0x4a>

0000000000000596 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     596:	711d                	addi	sp,sp,-96
     598:	ec86                	sd	ra,88(sp)
     59a:	e8a2                	sd	s0,80(sp)
     59c:	e4a6                	sd	s1,72(sp)
     59e:	e0ca                	sd	s2,64(sp)
     5a0:	fc4e                	sd	s3,56(sp)
     5a2:	f852                	sd	s4,48(sp)
     5a4:	f456                	sd	s5,40(sp)
     5a6:	f05a                	sd	s6,32(sp)
     5a8:	ec5e                	sd	s7,24(sp)
     5aa:	1080                	addi	s0,sp,96
     5ac:	8a2a                	mv	s4,a0
     5ae:	89ae                	mv	s3,a1
     5b0:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     5b2:	00001a97          	auipc	s5,0x1
     5b6:	ddea8a93          	addi	s5,s5,-546 # 1390 <malloc+0x176>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     5ba:	06100b13          	li	s6,97
      panic("missing file for redirection");
    switch(tok){
     5be:	03c00b93          	li	s7,60
  while(peek(ps, es, "<>")){
     5c2:	a02d                	j	5ec <parseredirs+0x56>
      panic("missing file for redirection");
     5c4:	00001517          	auipc	a0,0x1
     5c8:	dac50513          	addi	a0,a0,-596 # 1370 <malloc+0x156>
     5cc:	00000097          	auipc	ra,0x0
     5d0:	a88080e7          	jalr	-1400(ra) # 54 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5d4:	4701                	li	a4,0
     5d6:	4681                	li	a3,0
     5d8:	fa043603          	ld	a2,-96(s0)
     5dc:	fa843583          	ld	a1,-88(s0)
     5e0:	8552                	mv	a0,s4
     5e2:	00000097          	auipc	ra,0x0
     5e6:	ccc080e7          	jalr	-820(ra) # 2ae <redircmd>
     5ea:	8a2a                	mv	s4,a0
  while(peek(ps, es, "<>")){
     5ec:	8656                	mv	a2,s5
     5ee:	85ca                	mv	a1,s2
     5f0:	854e                	mv	a0,s3
     5f2:	00000097          	auipc	ra,0x0
     5f6:	f38080e7          	jalr	-200(ra) # 52a <peek>
     5fa:	cd25                	beqz	a0,672 <parseredirs+0xdc>
    tok = gettoken(ps, es, 0, 0);
     5fc:	4681                	li	a3,0
     5fe:	4601                	li	a2,0
     600:	85ca                	mv	a1,s2
     602:	854e                	mv	a0,s3
     604:	00000097          	auipc	ra,0x0
     608:	dda080e7          	jalr	-550(ra) # 3de <gettoken>
     60c:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     60e:	fa040693          	addi	a3,s0,-96
     612:	fa840613          	addi	a2,s0,-88
     616:	85ca                	mv	a1,s2
     618:	854e                	mv	a0,s3
     61a:	00000097          	auipc	ra,0x0
     61e:	dc4080e7          	jalr	-572(ra) # 3de <gettoken>
     622:	fb6511e3          	bne	a0,s6,5c4 <parseredirs+0x2e>
    switch(tok){
     626:	fb7487e3          	beq	s1,s7,5d4 <parseredirs+0x3e>
     62a:	03e00793          	li	a5,62
     62e:	02f48463          	beq	s1,a5,656 <parseredirs+0xc0>
     632:	02b00793          	li	a5,43
     636:	faf49be3          	bne	s1,a5,5ec <parseredirs+0x56>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     63a:	4705                	li	a4,1
     63c:	20100693          	li	a3,513
     640:	fa043603          	ld	a2,-96(s0)
     644:	fa843583          	ld	a1,-88(s0)
     648:	8552                	mv	a0,s4
     64a:	00000097          	auipc	ra,0x0
     64e:	c64080e7          	jalr	-924(ra) # 2ae <redircmd>
     652:	8a2a                	mv	s4,a0
      break;
     654:	bf61                	j	5ec <parseredirs+0x56>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     656:	4705                	li	a4,1
     658:	60100693          	li	a3,1537
     65c:	fa043603          	ld	a2,-96(s0)
     660:	fa843583          	ld	a1,-88(s0)
     664:	8552                	mv	a0,s4
     666:	00000097          	auipc	ra,0x0
     66a:	c48080e7          	jalr	-952(ra) # 2ae <redircmd>
     66e:	8a2a                	mv	s4,a0
      break;
     670:	bfb5                	j	5ec <parseredirs+0x56>
    }
  }
  return cmd;
}
     672:	8552                	mv	a0,s4
     674:	60e6                	ld	ra,88(sp)
     676:	6446                	ld	s0,80(sp)
     678:	64a6                	ld	s1,72(sp)
     67a:	6906                	ld	s2,64(sp)
     67c:	79e2                	ld	s3,56(sp)
     67e:	7a42                	ld	s4,48(sp)
     680:	7aa2                	ld	s5,40(sp)
     682:	7b02                	ld	s6,32(sp)
     684:	6be2                	ld	s7,24(sp)
     686:	6125                	addi	sp,sp,96
     688:	8082                	ret

000000000000068a <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     68a:	7159                	addi	sp,sp,-112
     68c:	f486                	sd	ra,104(sp)
     68e:	f0a2                	sd	s0,96(sp)
     690:	eca6                	sd	s1,88(sp)
     692:	e0d2                	sd	s4,64(sp)
     694:	fc56                	sd	s5,56(sp)
     696:	1880                	addi	s0,sp,112
     698:	8a2a                	mv	s4,a0
     69a:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     69c:	00001617          	auipc	a2,0x1
     6a0:	cfc60613          	addi	a2,a2,-772 # 1398 <malloc+0x17e>
     6a4:	00000097          	auipc	ra,0x0
     6a8:	e86080e7          	jalr	-378(ra) # 52a <peek>
     6ac:	ed15                	bnez	a0,6e8 <parseexec+0x5e>
     6ae:	e8ca                	sd	s2,80(sp)
     6b0:	e4ce                	sd	s3,72(sp)
     6b2:	f85a                	sd	s6,48(sp)
     6b4:	f45e                	sd	s7,40(sp)
     6b6:	f062                	sd	s8,32(sp)
     6b8:	ec66                	sd	s9,24(sp)
     6ba:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     6bc:	00000097          	auipc	ra,0x0
     6c0:	bbc080e7          	jalr	-1092(ra) # 278 <execcmd>
     6c4:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     6c6:	8656                	mv	a2,s5
     6c8:	85d2                	mv	a1,s4
     6ca:	00000097          	auipc	ra,0x0
     6ce:	ecc080e7          	jalr	-308(ra) # 596 <parseredirs>
     6d2:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     6d4:	008c0913          	addi	s2,s8,8
     6d8:	00001b17          	auipc	s6,0x1
     6dc:	ce0b0b13          	addi	s6,s6,-800 # 13b8 <malloc+0x19e>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     6e0:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     6e4:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     6e6:	a081                	j	726 <parseexec+0x9c>
    return parseblock(ps, es);
     6e8:	85d6                	mv	a1,s5
     6ea:	8552                	mv	a0,s4
     6ec:	00000097          	auipc	ra,0x0
     6f0:	1bc080e7          	jalr	444(ra) # 8a8 <parseblock>
     6f4:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     6f6:	8526                	mv	a0,s1
     6f8:	70a6                	ld	ra,104(sp)
     6fa:	7406                	ld	s0,96(sp)
     6fc:	64e6                	ld	s1,88(sp)
     6fe:	6a06                	ld	s4,64(sp)
     700:	7ae2                	ld	s5,56(sp)
     702:	6165                	addi	sp,sp,112
     704:	8082                	ret
      panic("syntax");
     706:	00001517          	auipc	a0,0x1
     70a:	c9a50513          	addi	a0,a0,-870 # 13a0 <malloc+0x186>
     70e:	00000097          	auipc	ra,0x0
     712:	946080e7          	jalr	-1722(ra) # 54 <panic>
    ret = parseredirs(ret, ps, es);
     716:	8656                	mv	a2,s5
     718:	85d2                	mv	a1,s4
     71a:	8526                	mv	a0,s1
     71c:	00000097          	auipc	ra,0x0
     720:	e7a080e7          	jalr	-390(ra) # 596 <parseredirs>
     724:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     726:	865a                	mv	a2,s6
     728:	85d6                	mv	a1,s5
     72a:	8552                	mv	a0,s4
     72c:	00000097          	auipc	ra,0x0
     730:	dfe080e7          	jalr	-514(ra) # 52a <peek>
     734:	e131                	bnez	a0,778 <parseexec+0xee>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     736:	f9040693          	addi	a3,s0,-112
     73a:	f9840613          	addi	a2,s0,-104
     73e:	85d6                	mv	a1,s5
     740:	8552                	mv	a0,s4
     742:	00000097          	auipc	ra,0x0
     746:	c9c080e7          	jalr	-868(ra) # 3de <gettoken>
     74a:	c51d                	beqz	a0,778 <parseexec+0xee>
    if(tok != 'a')
     74c:	fb951de3          	bne	a0,s9,706 <parseexec+0x7c>
    cmd->argv[argc] = q;
     750:	f9843783          	ld	a5,-104(s0)
     754:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     758:	f9043783          	ld	a5,-112(s0)
     75c:	04f93823          	sd	a5,80(s2)
    argc++;
     760:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     762:	0921                	addi	s2,s2,8
     764:	fb7999e3          	bne	s3,s7,716 <parseexec+0x8c>
      panic("too many args");
     768:	00001517          	auipc	a0,0x1
     76c:	c4050513          	addi	a0,a0,-960 # 13a8 <malloc+0x18e>
     770:	00000097          	auipc	ra,0x0
     774:	8e4080e7          	jalr	-1820(ra) # 54 <panic>
  cmd->argv[argc] = 0;
     778:	098e                	slli	s3,s3,0x3
     77a:	9c4e                	add	s8,s8,s3
     77c:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     780:	040c3c23          	sd	zero,88(s8)
     784:	6946                	ld	s2,80(sp)
     786:	69a6                	ld	s3,72(sp)
     788:	7b42                	ld	s6,48(sp)
     78a:	7ba2                	ld	s7,40(sp)
     78c:	7c02                	ld	s8,32(sp)
     78e:	6ce2                	ld	s9,24(sp)
  return ret;
     790:	b79d                	j	6f6 <parseexec+0x6c>

0000000000000792 <parsepipe>:
{
     792:	7179                	addi	sp,sp,-48
     794:	f406                	sd	ra,40(sp)
     796:	f022                	sd	s0,32(sp)
     798:	ec26                	sd	s1,24(sp)
     79a:	e84a                	sd	s2,16(sp)
     79c:	e44e                	sd	s3,8(sp)
     79e:	1800                	addi	s0,sp,48
     7a0:	892a                	mv	s2,a0
     7a2:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     7a4:	00000097          	auipc	ra,0x0
     7a8:	ee6080e7          	jalr	-282(ra) # 68a <parseexec>
     7ac:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     7ae:	00001617          	auipc	a2,0x1
     7b2:	c1260613          	addi	a2,a2,-1006 # 13c0 <malloc+0x1a6>
     7b6:	85ce                	mv	a1,s3
     7b8:	854a                	mv	a0,s2
     7ba:	00000097          	auipc	ra,0x0
     7be:	d70080e7          	jalr	-656(ra) # 52a <peek>
     7c2:	e909                	bnez	a0,7d4 <parsepipe+0x42>
}
     7c4:	8526                	mv	a0,s1
     7c6:	70a2                	ld	ra,40(sp)
     7c8:	7402                	ld	s0,32(sp)
     7ca:	64e2                	ld	s1,24(sp)
     7cc:	6942                	ld	s2,16(sp)
     7ce:	69a2                	ld	s3,8(sp)
     7d0:	6145                	addi	sp,sp,48
     7d2:	8082                	ret
    gettoken(ps, es, 0, 0);
     7d4:	4681                	li	a3,0
     7d6:	4601                	li	a2,0
     7d8:	85ce                	mv	a1,s3
     7da:	854a                	mv	a0,s2
     7dc:	00000097          	auipc	ra,0x0
     7e0:	c02080e7          	jalr	-1022(ra) # 3de <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     7e4:	85ce                	mv	a1,s3
     7e6:	854a                	mv	a0,s2
     7e8:	00000097          	auipc	ra,0x0
     7ec:	faa080e7          	jalr	-86(ra) # 792 <parsepipe>
     7f0:	85aa                	mv	a1,a0
     7f2:	8526                	mv	a0,s1
     7f4:	00000097          	auipc	ra,0x0
     7f8:	b22080e7          	jalr	-1246(ra) # 316 <pipecmd>
     7fc:	84aa                	mv	s1,a0
  return cmd;
     7fe:	b7d9                	j	7c4 <parsepipe+0x32>

0000000000000800 <parseline>:
{
     800:	7179                	addi	sp,sp,-48
     802:	f406                	sd	ra,40(sp)
     804:	f022                	sd	s0,32(sp)
     806:	ec26                	sd	s1,24(sp)
     808:	e84a                	sd	s2,16(sp)
     80a:	e44e                	sd	s3,8(sp)
     80c:	e052                	sd	s4,0(sp)
     80e:	1800                	addi	s0,sp,48
     810:	892a                	mv	s2,a0
     812:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     814:	00000097          	auipc	ra,0x0
     818:	f7e080e7          	jalr	-130(ra) # 792 <parsepipe>
     81c:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     81e:	00001a17          	auipc	s4,0x1
     822:	baaa0a13          	addi	s4,s4,-1110 # 13c8 <malloc+0x1ae>
     826:	a839                	j	844 <parseline+0x44>
    gettoken(ps, es, 0, 0);
     828:	4681                	li	a3,0
     82a:	4601                	li	a2,0
     82c:	85ce                	mv	a1,s3
     82e:	854a                	mv	a0,s2
     830:	00000097          	auipc	ra,0x0
     834:	bae080e7          	jalr	-1106(ra) # 3de <gettoken>
    cmd = backcmd(cmd);
     838:	8526                	mv	a0,s1
     83a:	00000097          	auipc	ra,0x0
     83e:	b68080e7          	jalr	-1176(ra) # 3a2 <backcmd>
     842:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     844:	8652                	mv	a2,s4
     846:	85ce                	mv	a1,s3
     848:	854a                	mv	a0,s2
     84a:	00000097          	auipc	ra,0x0
     84e:	ce0080e7          	jalr	-800(ra) # 52a <peek>
     852:	f979                	bnez	a0,828 <parseline+0x28>
  if(peek(ps, es, ";")){
     854:	00001617          	auipc	a2,0x1
     858:	b7c60613          	addi	a2,a2,-1156 # 13d0 <malloc+0x1b6>
     85c:	85ce                	mv	a1,s3
     85e:	854a                	mv	a0,s2
     860:	00000097          	auipc	ra,0x0
     864:	cca080e7          	jalr	-822(ra) # 52a <peek>
     868:	e911                	bnez	a0,87c <parseline+0x7c>
}
     86a:	8526                	mv	a0,s1
     86c:	70a2                	ld	ra,40(sp)
     86e:	7402                	ld	s0,32(sp)
     870:	64e2                	ld	s1,24(sp)
     872:	6942                	ld	s2,16(sp)
     874:	69a2                	ld	s3,8(sp)
     876:	6a02                	ld	s4,0(sp)
     878:	6145                	addi	sp,sp,48
     87a:	8082                	ret
    gettoken(ps, es, 0, 0);
     87c:	4681                	li	a3,0
     87e:	4601                	li	a2,0
     880:	85ce                	mv	a1,s3
     882:	854a                	mv	a0,s2
     884:	00000097          	auipc	ra,0x0
     888:	b5a080e7          	jalr	-1190(ra) # 3de <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     88c:	85ce                	mv	a1,s3
     88e:	854a                	mv	a0,s2
     890:	00000097          	auipc	ra,0x0
     894:	f70080e7          	jalr	-144(ra) # 800 <parseline>
     898:	85aa                	mv	a1,a0
     89a:	8526                	mv	a0,s1
     89c:	00000097          	auipc	ra,0x0
     8a0:	ac0080e7          	jalr	-1344(ra) # 35c <listcmd>
     8a4:	84aa                	mv	s1,a0
  return cmd;
     8a6:	b7d1                	j	86a <parseline+0x6a>

00000000000008a8 <parseblock>:
{
     8a8:	7179                	addi	sp,sp,-48
     8aa:	f406                	sd	ra,40(sp)
     8ac:	f022                	sd	s0,32(sp)
     8ae:	ec26                	sd	s1,24(sp)
     8b0:	e84a                	sd	s2,16(sp)
     8b2:	e44e                	sd	s3,8(sp)
     8b4:	1800                	addi	s0,sp,48
     8b6:	84aa                	mv	s1,a0
     8b8:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     8ba:	00001617          	auipc	a2,0x1
     8be:	ade60613          	addi	a2,a2,-1314 # 1398 <malloc+0x17e>
     8c2:	00000097          	auipc	ra,0x0
     8c6:	c68080e7          	jalr	-920(ra) # 52a <peek>
     8ca:	c12d                	beqz	a0,92c <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     8cc:	4681                	li	a3,0
     8ce:	4601                	li	a2,0
     8d0:	85ca                	mv	a1,s2
     8d2:	8526                	mv	a0,s1
     8d4:	00000097          	auipc	ra,0x0
     8d8:	b0a080e7          	jalr	-1270(ra) # 3de <gettoken>
  cmd = parseline(ps, es);
     8dc:	85ca                	mv	a1,s2
     8de:	8526                	mv	a0,s1
     8e0:	00000097          	auipc	ra,0x0
     8e4:	f20080e7          	jalr	-224(ra) # 800 <parseline>
     8e8:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     8ea:	00001617          	auipc	a2,0x1
     8ee:	afe60613          	addi	a2,a2,-1282 # 13e8 <malloc+0x1ce>
     8f2:	85ca                	mv	a1,s2
     8f4:	8526                	mv	a0,s1
     8f6:	00000097          	auipc	ra,0x0
     8fa:	c34080e7          	jalr	-972(ra) # 52a <peek>
     8fe:	cd1d                	beqz	a0,93c <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     900:	4681                	li	a3,0
     902:	4601                	li	a2,0
     904:	85ca                	mv	a1,s2
     906:	8526                	mv	a0,s1
     908:	00000097          	auipc	ra,0x0
     90c:	ad6080e7          	jalr	-1322(ra) # 3de <gettoken>
  cmd = parseredirs(cmd, ps, es);
     910:	864a                	mv	a2,s2
     912:	85a6                	mv	a1,s1
     914:	854e                	mv	a0,s3
     916:	00000097          	auipc	ra,0x0
     91a:	c80080e7          	jalr	-896(ra) # 596 <parseredirs>
}
     91e:	70a2                	ld	ra,40(sp)
     920:	7402                	ld	s0,32(sp)
     922:	64e2                	ld	s1,24(sp)
     924:	6942                	ld	s2,16(sp)
     926:	69a2                	ld	s3,8(sp)
     928:	6145                	addi	sp,sp,48
     92a:	8082                	ret
    panic("parseblock");
     92c:	00001517          	auipc	a0,0x1
     930:	aac50513          	addi	a0,a0,-1364 # 13d8 <malloc+0x1be>
     934:	fffff097          	auipc	ra,0xfffff
     938:	720080e7          	jalr	1824(ra) # 54 <panic>
    panic("syntax - missing )");
     93c:	00001517          	auipc	a0,0x1
     940:	ab450513          	addi	a0,a0,-1356 # 13f0 <malloc+0x1d6>
     944:	fffff097          	auipc	ra,0xfffff
     948:	710080e7          	jalr	1808(ra) # 54 <panic>

000000000000094c <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     94c:	1101                	addi	sp,sp,-32
     94e:	ec06                	sd	ra,24(sp)
     950:	e822                	sd	s0,16(sp)
     952:	e426                	sd	s1,8(sp)
     954:	1000                	addi	s0,sp,32
     956:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     958:	c521                	beqz	a0,9a0 <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     95a:	4118                	lw	a4,0(a0)
     95c:	4795                	li	a5,5
     95e:	04e7e163          	bltu	a5,a4,9a0 <nulterminate+0x54>
     962:	00056783          	lwu	a5,0(a0)
     966:	078a                	slli	a5,a5,0x2
     968:	00001717          	auipc	a4,0x1
     96c:	ae870713          	addi	a4,a4,-1304 # 1450 <malloc+0x236>
     970:	97ba                	add	a5,a5,a4
     972:	439c                	lw	a5,0(a5)
     974:	97ba                	add	a5,a5,a4
     976:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     978:	651c                	ld	a5,8(a0)
     97a:	c39d                	beqz	a5,9a0 <nulterminate+0x54>
     97c:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     980:	67b8                	ld	a4,72(a5)
     982:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     986:	07a1                	addi	a5,a5,8
     988:	ff87b703          	ld	a4,-8(a5)
     98c:	fb75                	bnez	a4,980 <nulterminate+0x34>
     98e:	a809                	j	9a0 <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     990:	6508                	ld	a0,8(a0)
     992:	00000097          	auipc	ra,0x0
     996:	fba080e7          	jalr	-70(ra) # 94c <nulterminate>
    *rcmd->efile = 0;
     99a:	6c9c                	ld	a5,24(s1)
     99c:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     9a0:	8526                	mv	a0,s1
     9a2:	60e2                	ld	ra,24(sp)
     9a4:	6442                	ld	s0,16(sp)
     9a6:	64a2                	ld	s1,8(sp)
     9a8:	6105                	addi	sp,sp,32
     9aa:	8082                	ret
    nulterminate(pcmd->left);
     9ac:	6508                	ld	a0,8(a0)
     9ae:	00000097          	auipc	ra,0x0
     9b2:	f9e080e7          	jalr	-98(ra) # 94c <nulterminate>
    nulterminate(pcmd->right);
     9b6:	6888                	ld	a0,16(s1)
     9b8:	00000097          	auipc	ra,0x0
     9bc:	f94080e7          	jalr	-108(ra) # 94c <nulterminate>
    break;
     9c0:	b7c5                	j	9a0 <nulterminate+0x54>
    nulterminate(lcmd->left);
     9c2:	6508                	ld	a0,8(a0)
     9c4:	00000097          	auipc	ra,0x0
     9c8:	f88080e7          	jalr	-120(ra) # 94c <nulterminate>
    nulterminate(lcmd->right);
     9cc:	6888                	ld	a0,16(s1)
     9ce:	00000097          	auipc	ra,0x0
     9d2:	f7e080e7          	jalr	-130(ra) # 94c <nulterminate>
    break;
     9d6:	b7e9                	j	9a0 <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     9d8:	6508                	ld	a0,8(a0)
     9da:	00000097          	auipc	ra,0x0
     9de:	f72080e7          	jalr	-142(ra) # 94c <nulterminate>
    break;
     9e2:	bf7d                	j	9a0 <nulterminate+0x54>

00000000000009e4 <parsecmd>:
{
     9e4:	7179                	addi	sp,sp,-48
     9e6:	f406                	sd	ra,40(sp)
     9e8:	f022                	sd	s0,32(sp)
     9ea:	ec26                	sd	s1,24(sp)
     9ec:	e84a                	sd	s2,16(sp)
     9ee:	1800                	addi	s0,sp,48
     9f0:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     9f4:	84aa                	mv	s1,a0
     9f6:	00000097          	auipc	ra,0x0
     9fa:	1ba080e7          	jalr	442(ra) # bb0 <strlen>
     9fe:	1502                	slli	a0,a0,0x20
     a00:	9101                	srli	a0,a0,0x20
     a02:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     a04:	85a6                	mv	a1,s1
     a06:	fd840513          	addi	a0,s0,-40
     a0a:	00000097          	auipc	ra,0x0
     a0e:	df6080e7          	jalr	-522(ra) # 800 <parseline>
     a12:	892a                	mv	s2,a0
  peek(&s, es, "");
     a14:	00001617          	auipc	a2,0x1
     a18:	91460613          	addi	a2,a2,-1772 # 1328 <malloc+0x10e>
     a1c:	85a6                	mv	a1,s1
     a1e:	fd840513          	addi	a0,s0,-40
     a22:	00000097          	auipc	ra,0x0
     a26:	b08080e7          	jalr	-1272(ra) # 52a <peek>
  if(s != es){
     a2a:	fd843603          	ld	a2,-40(s0)
     a2e:	00961e63          	bne	a2,s1,a4a <parsecmd+0x66>
  nulterminate(cmd);
     a32:	854a                	mv	a0,s2
     a34:	00000097          	auipc	ra,0x0
     a38:	f18080e7          	jalr	-232(ra) # 94c <nulterminate>
}
     a3c:	854a                	mv	a0,s2
     a3e:	70a2                	ld	ra,40(sp)
     a40:	7402                	ld	s0,32(sp)
     a42:	64e2                	ld	s1,24(sp)
     a44:	6942                	ld	s2,16(sp)
     a46:	6145                	addi	sp,sp,48
     a48:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     a4a:	00001597          	auipc	a1,0x1
     a4e:	9be58593          	addi	a1,a1,-1602 # 1408 <malloc+0x1ee>
     a52:	4509                	li	a0,2
     a54:	00000097          	auipc	ra,0x0
     a58:	6e0080e7          	jalr	1760(ra) # 1134 <fprintf>
    panic("syntax");
     a5c:	00001517          	auipc	a0,0x1
     a60:	94450513          	addi	a0,a0,-1724 # 13a0 <malloc+0x186>
     a64:	fffff097          	auipc	ra,0xfffff
     a68:	5f0080e7          	jalr	1520(ra) # 54 <panic>

0000000000000a6c <main>:
{
     a6c:	7179                	addi	sp,sp,-48
     a6e:	f406                	sd	ra,40(sp)
     a70:	f022                	sd	s0,32(sp)
     a72:	ec26                	sd	s1,24(sp)
     a74:	e84a                	sd	s2,16(sp)
     a76:	e44e                	sd	s3,8(sp)
     a78:	e052                	sd	s4,0(sp)
     a7a:	1800                	addi	s0,sp,48
  while((fd = open("console", O_RDWR)) >= 0){
     a7c:	00001497          	auipc	s1,0x1
     a80:	99c48493          	addi	s1,s1,-1636 # 1418 <malloc+0x1fe>
     a84:	4589                	li	a1,2
     a86:	8526                	mv	a0,s1
     a88:	00000097          	auipc	ra,0x0
     a8c:	3a2080e7          	jalr	930(ra) # e2a <open>
     a90:	00054963          	bltz	a0,aa2 <main+0x36>
    if(fd >= 3){
     a94:	4789                	li	a5,2
     a96:	fea7d7e3          	bge	a5,a0,a84 <main+0x18>
      close(fd);
     a9a:	00000097          	auipc	ra,0x0
     a9e:	378080e7          	jalr	888(ra) # e12 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     aa2:	00001497          	auipc	s1,0x1
     aa6:	21648493          	addi	s1,s1,534 # 1cb8 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     aaa:	06300913          	li	s2,99
     aae:	02000993          	li	s3,32
     ab2:	a819                	j	ac8 <main+0x5c>
    if(fork1() == 0)
     ab4:	fffff097          	auipc	ra,0xfffff
     ab8:	5c6080e7          	jalr	1478(ra) # 7a <fork1>
     abc:	c549                	beqz	a0,b46 <main+0xda>
    wait(0);
     abe:	4501                	li	a0,0
     ac0:	00000097          	auipc	ra,0x0
     ac4:	332080e7          	jalr	818(ra) # df2 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     ac8:	06400593          	li	a1,100
     acc:	8526                	mv	a0,s1
     ace:	fffff097          	auipc	ra,0xfffff
     ad2:	532080e7          	jalr	1330(ra) # 0 <getcmd>
     ad6:	08054463          	bltz	a0,b5e <main+0xf2>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     ada:	0004c783          	lbu	a5,0(s1)
     ade:	fd279be3          	bne	a5,s2,ab4 <main+0x48>
     ae2:	0014c703          	lbu	a4,1(s1)
     ae6:	06400793          	li	a5,100
     aea:	fcf715e3          	bne	a4,a5,ab4 <main+0x48>
     aee:	0024c783          	lbu	a5,2(s1)
     af2:	fd3791e3          	bne	a5,s3,ab4 <main+0x48>
      buf[strlen(buf)-1] = 0;  // chop \n
     af6:	00001a17          	auipc	s4,0x1
     afa:	1c2a0a13          	addi	s4,s4,450 # 1cb8 <buf.0>
     afe:	8552                	mv	a0,s4
     b00:	00000097          	auipc	ra,0x0
     b04:	0b0080e7          	jalr	176(ra) # bb0 <strlen>
     b08:	fff5079b          	addiw	a5,a0,-1
     b0c:	1782                	slli	a5,a5,0x20
     b0e:	9381                	srli	a5,a5,0x20
     b10:	9a3e                	add	s4,s4,a5
     b12:	000a0023          	sb	zero,0(s4)
      if(chdir(buf+3) < 0)
     b16:	00001517          	auipc	a0,0x1
     b1a:	1a550513          	addi	a0,a0,421 # 1cbb <buf.0+0x3>
     b1e:	00000097          	auipc	ra,0x0
     b22:	33c080e7          	jalr	828(ra) # e5a <chdir>
     b26:	fa0551e3          	bgez	a0,ac8 <main+0x5c>
        fprintf(2, "cannot cd %s\n", buf+3);
     b2a:	00001617          	auipc	a2,0x1
     b2e:	19160613          	addi	a2,a2,401 # 1cbb <buf.0+0x3>
     b32:	00001597          	auipc	a1,0x1
     b36:	8ee58593          	addi	a1,a1,-1810 # 1420 <malloc+0x206>
     b3a:	4509                	li	a0,2
     b3c:	00000097          	auipc	ra,0x0
     b40:	5f8080e7          	jalr	1528(ra) # 1134 <fprintf>
     b44:	b751                	j	ac8 <main+0x5c>
      runcmd(parsecmd(buf));
     b46:	00001517          	auipc	a0,0x1
     b4a:	17250513          	addi	a0,a0,370 # 1cb8 <buf.0>
     b4e:	00000097          	auipc	ra,0x0
     b52:	e96080e7          	jalr	-362(ra) # 9e4 <parsecmd>
     b56:	fffff097          	auipc	ra,0xfffff
     b5a:	552080e7          	jalr	1362(ra) # a8 <runcmd>
  exit(0);
     b5e:	4501                	li	a0,0
     b60:	00000097          	auipc	ra,0x0
     b64:	28a080e7          	jalr	650(ra) # dea <exit>

0000000000000b68 <strcpy>:



char*
strcpy(char *s, const char *t)
{
     b68:	1141                	addi	sp,sp,-16
     b6a:	e422                	sd	s0,8(sp)
     b6c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b6e:	87aa                	mv	a5,a0
     b70:	0585                	addi	a1,a1,1
     b72:	0785                	addi	a5,a5,1
     b74:	fff5c703          	lbu	a4,-1(a1)
     b78:	fee78fa3          	sb	a4,-1(a5)
     b7c:	fb75                	bnez	a4,b70 <strcpy+0x8>
    ;
  return os;
}
     b7e:	6422                	ld	s0,8(sp)
     b80:	0141                	addi	sp,sp,16
     b82:	8082                	ret

0000000000000b84 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b84:	1141                	addi	sp,sp,-16
     b86:	e422                	sd	s0,8(sp)
     b88:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     b8a:	00054783          	lbu	a5,0(a0)
     b8e:	cb91                	beqz	a5,ba2 <strcmp+0x1e>
     b90:	0005c703          	lbu	a4,0(a1)
     b94:	00f71763          	bne	a4,a5,ba2 <strcmp+0x1e>
    p++, q++;
     b98:	0505                	addi	a0,a0,1
     b9a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     b9c:	00054783          	lbu	a5,0(a0)
     ba0:	fbe5                	bnez	a5,b90 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     ba2:	0005c503          	lbu	a0,0(a1)
}
     ba6:	40a7853b          	subw	a0,a5,a0
     baa:	6422                	ld	s0,8(sp)
     bac:	0141                	addi	sp,sp,16
     bae:	8082                	ret

0000000000000bb0 <strlen>:

uint
strlen(const char *s)
{
     bb0:	1141                	addi	sp,sp,-16
     bb2:	e422                	sd	s0,8(sp)
     bb4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     bb6:	00054783          	lbu	a5,0(a0)
     bba:	cf91                	beqz	a5,bd6 <strlen+0x26>
     bbc:	0505                	addi	a0,a0,1
     bbe:	87aa                	mv	a5,a0
     bc0:	86be                	mv	a3,a5
     bc2:	0785                	addi	a5,a5,1
     bc4:	fff7c703          	lbu	a4,-1(a5)
     bc8:	ff65                	bnez	a4,bc0 <strlen+0x10>
     bca:	40a6853b          	subw	a0,a3,a0
     bce:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     bd0:	6422                	ld	s0,8(sp)
     bd2:	0141                	addi	sp,sp,16
     bd4:	8082                	ret
  for(n = 0; s[n]; n++)
     bd6:	4501                	li	a0,0
     bd8:	bfe5                	j	bd0 <strlen+0x20>

0000000000000bda <memset>:

void*
memset(void *dst, int c, uint n)
{
     bda:	1141                	addi	sp,sp,-16
     bdc:	e422                	sd	s0,8(sp)
     bde:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     be0:	ca19                	beqz	a2,bf6 <memset+0x1c>
     be2:	87aa                	mv	a5,a0
     be4:	1602                	slli	a2,a2,0x20
     be6:	9201                	srli	a2,a2,0x20
     be8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     bec:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     bf0:	0785                	addi	a5,a5,1
     bf2:	fee79de3          	bne	a5,a4,bec <memset+0x12>
  }
  return dst;
}
     bf6:	6422                	ld	s0,8(sp)
     bf8:	0141                	addi	sp,sp,16
     bfa:	8082                	ret

0000000000000bfc <strchr>:

char*
strchr(const char *s, char c)
{
     bfc:	1141                	addi	sp,sp,-16
     bfe:	e422                	sd	s0,8(sp)
     c00:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c02:	00054783          	lbu	a5,0(a0)
     c06:	cb99                	beqz	a5,c1c <strchr+0x20>
    if(*s == c)
     c08:	00f58763          	beq	a1,a5,c16 <strchr+0x1a>
  for(; *s; s++)
     c0c:	0505                	addi	a0,a0,1
     c0e:	00054783          	lbu	a5,0(a0)
     c12:	fbfd                	bnez	a5,c08 <strchr+0xc>
      return (char*)s;
  return 0;
     c14:	4501                	li	a0,0
}
     c16:	6422                	ld	s0,8(sp)
     c18:	0141                	addi	sp,sp,16
     c1a:	8082                	ret
  return 0;
     c1c:	4501                	li	a0,0
     c1e:	bfe5                	j	c16 <strchr+0x1a>

0000000000000c20 <gets>:

char*
gets(char *buf, int max)
{
     c20:	711d                	addi	sp,sp,-96
     c22:	ec86                	sd	ra,88(sp)
     c24:	e8a2                	sd	s0,80(sp)
     c26:	e4a6                	sd	s1,72(sp)
     c28:	e0ca                	sd	s2,64(sp)
     c2a:	fc4e                	sd	s3,56(sp)
     c2c:	f852                	sd	s4,48(sp)
     c2e:	f456                	sd	s5,40(sp)
     c30:	f05a                	sd	s6,32(sp)
     c32:	ec5e                	sd	s7,24(sp)
     c34:	1080                	addi	s0,sp,96
     c36:	8baa                	mv	s7,a0
     c38:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c3a:	892a                	mv	s2,a0
     c3c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c3e:	4aa9                	li	s5,10
     c40:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c42:	89a6                	mv	s3,s1
     c44:	2485                	addiw	s1,s1,1
     c46:	0344d863          	bge	s1,s4,c76 <gets+0x56>
    cc = read(0, &c, 1);
     c4a:	4605                	li	a2,1
     c4c:	faf40593          	addi	a1,s0,-81
     c50:	4501                	li	a0,0
     c52:	00000097          	auipc	ra,0x0
     c56:	1b0080e7          	jalr	432(ra) # e02 <read>
    if(cc < 1)
     c5a:	00a05e63          	blez	a0,c76 <gets+0x56>
    buf[i++] = c;
     c5e:	faf44783          	lbu	a5,-81(s0)
     c62:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c66:	01578763          	beq	a5,s5,c74 <gets+0x54>
     c6a:	0905                	addi	s2,s2,1
     c6c:	fd679be3          	bne	a5,s6,c42 <gets+0x22>
    buf[i++] = c;
     c70:	89a6                	mv	s3,s1
     c72:	a011                	j	c76 <gets+0x56>
     c74:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c76:	99de                	add	s3,s3,s7
     c78:	00098023          	sb	zero,0(s3)
  return buf;
}
     c7c:	855e                	mv	a0,s7
     c7e:	60e6                	ld	ra,88(sp)
     c80:	6446                	ld	s0,80(sp)
     c82:	64a6                	ld	s1,72(sp)
     c84:	6906                	ld	s2,64(sp)
     c86:	79e2                	ld	s3,56(sp)
     c88:	7a42                	ld	s4,48(sp)
     c8a:	7aa2                	ld	s5,40(sp)
     c8c:	7b02                	ld	s6,32(sp)
     c8e:	6be2                	ld	s7,24(sp)
     c90:	6125                	addi	sp,sp,96
     c92:	8082                	ret

0000000000000c94 <stat>:

int
stat(const char *n, struct stat *st)
{
     c94:	1101                	addi	sp,sp,-32
     c96:	ec06                	sd	ra,24(sp)
     c98:	e822                	sd	s0,16(sp)
     c9a:	e04a                	sd	s2,0(sp)
     c9c:	1000                	addi	s0,sp,32
     c9e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ca0:	4581                	li	a1,0
     ca2:	00000097          	auipc	ra,0x0
     ca6:	188080e7          	jalr	392(ra) # e2a <open>
  if(fd < 0)
     caa:	02054663          	bltz	a0,cd6 <stat+0x42>
     cae:	e426                	sd	s1,8(sp)
     cb0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     cb2:	85ca                	mv	a1,s2
     cb4:	00000097          	auipc	ra,0x0
     cb8:	18e080e7          	jalr	398(ra) # e42 <fstat>
     cbc:	892a                	mv	s2,a0
  close(fd);
     cbe:	8526                	mv	a0,s1
     cc0:	00000097          	auipc	ra,0x0
     cc4:	152080e7          	jalr	338(ra) # e12 <close>
  return r;
     cc8:	64a2                	ld	s1,8(sp)
}
     cca:	854a                	mv	a0,s2
     ccc:	60e2                	ld	ra,24(sp)
     cce:	6442                	ld	s0,16(sp)
     cd0:	6902                	ld	s2,0(sp)
     cd2:	6105                	addi	sp,sp,32
     cd4:	8082                	ret
    return -1;
     cd6:	597d                	li	s2,-1
     cd8:	bfcd                	j	cca <stat+0x36>

0000000000000cda <atoi>:

int
atoi(const char *s)
{
     cda:	1141                	addi	sp,sp,-16
     cdc:	e422                	sd	s0,8(sp)
     cde:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     ce0:	00054683          	lbu	a3,0(a0)
     ce4:	fd06879b          	addiw	a5,a3,-48
     ce8:	0ff7f793          	zext.b	a5,a5
     cec:	4625                	li	a2,9
     cee:	02f66863          	bltu	a2,a5,d1e <atoi+0x44>
     cf2:	872a                	mv	a4,a0
  n = 0;
     cf4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     cf6:	0705                	addi	a4,a4,1
     cf8:	0025179b          	slliw	a5,a0,0x2
     cfc:	9fa9                	addw	a5,a5,a0
     cfe:	0017979b          	slliw	a5,a5,0x1
     d02:	9fb5                	addw	a5,a5,a3
     d04:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d08:	00074683          	lbu	a3,0(a4)
     d0c:	fd06879b          	addiw	a5,a3,-48
     d10:	0ff7f793          	zext.b	a5,a5
     d14:	fef671e3          	bgeu	a2,a5,cf6 <atoi+0x1c>
  return n;
}
     d18:	6422                	ld	s0,8(sp)
     d1a:	0141                	addi	sp,sp,16
     d1c:	8082                	ret
  n = 0;
     d1e:	4501                	li	a0,0
     d20:	bfe5                	j	d18 <atoi+0x3e>

0000000000000d22 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d22:	1141                	addi	sp,sp,-16
     d24:	e422                	sd	s0,8(sp)
     d26:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d28:	02b57463          	bgeu	a0,a1,d50 <memmove+0x2e>
    while(n-- > 0)
     d2c:	00c05f63          	blez	a2,d4a <memmove+0x28>
     d30:	1602                	slli	a2,a2,0x20
     d32:	9201                	srli	a2,a2,0x20
     d34:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d38:	872a                	mv	a4,a0
      *dst++ = *src++;
     d3a:	0585                	addi	a1,a1,1
     d3c:	0705                	addi	a4,a4,1
     d3e:	fff5c683          	lbu	a3,-1(a1)
     d42:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d46:	fef71ae3          	bne	a4,a5,d3a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d4a:	6422                	ld	s0,8(sp)
     d4c:	0141                	addi	sp,sp,16
     d4e:	8082                	ret
    dst += n;
     d50:	00c50733          	add	a4,a0,a2
    src += n;
     d54:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     d56:	fec05ae3          	blez	a2,d4a <memmove+0x28>
     d5a:	fff6079b          	addiw	a5,a2,-1
     d5e:	1782                	slli	a5,a5,0x20
     d60:	9381                	srli	a5,a5,0x20
     d62:	fff7c793          	not	a5,a5
     d66:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     d68:	15fd                	addi	a1,a1,-1
     d6a:	177d                	addi	a4,a4,-1
     d6c:	0005c683          	lbu	a3,0(a1)
     d70:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     d74:	fee79ae3          	bne	a5,a4,d68 <memmove+0x46>
     d78:	bfc9                	j	d4a <memmove+0x28>

0000000000000d7a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     d7a:	1141                	addi	sp,sp,-16
     d7c:	e422                	sd	s0,8(sp)
     d7e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     d80:	ca05                	beqz	a2,db0 <memcmp+0x36>
     d82:	fff6069b          	addiw	a3,a2,-1
     d86:	1682                	slli	a3,a3,0x20
     d88:	9281                	srli	a3,a3,0x20
     d8a:	0685                	addi	a3,a3,1
     d8c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     d8e:	00054783          	lbu	a5,0(a0)
     d92:	0005c703          	lbu	a4,0(a1)
     d96:	00e79863          	bne	a5,a4,da6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     d9a:	0505                	addi	a0,a0,1
    p2++;
     d9c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     d9e:	fed518e3          	bne	a0,a3,d8e <memcmp+0x14>
  }
  return 0;
     da2:	4501                	li	a0,0
     da4:	a019                	j	daa <memcmp+0x30>
      return *p1 - *p2;
     da6:	40e7853b          	subw	a0,a5,a4
}
     daa:	6422                	ld	s0,8(sp)
     dac:	0141                	addi	sp,sp,16
     dae:	8082                	ret
  return 0;
     db0:	4501                	li	a0,0
     db2:	bfe5                	j	daa <memcmp+0x30>

0000000000000db4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     db4:	1141                	addi	sp,sp,-16
     db6:	e406                	sd	ra,8(sp)
     db8:	e022                	sd	s0,0(sp)
     dba:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     dbc:	00000097          	auipc	ra,0x0
     dc0:	f66080e7          	jalr	-154(ra) # d22 <memmove>
}
     dc4:	60a2                	ld	ra,8(sp)
     dc6:	6402                	ld	s0,0(sp)
     dc8:	0141                	addi	sp,sp,16
     dca:	8082                	ret

0000000000000dcc <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
     dcc:	1141                	addi	sp,sp,-16
     dce:	e422                	sd	s0,8(sp)
     dd0:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
     dd2:	040007b7          	lui	a5,0x4000
     dd6:	17f5                	addi	a5,a5,-3 # 3fffffd <__global_pointer$+0x3ffdb61>
     dd8:	07b2                	slli	a5,a5,0xc
}
     dda:	4388                	lw	a0,0(a5)
     ddc:	6422                	ld	s0,8(sp)
     dde:	0141                	addi	sp,sp,16
     de0:	8082                	ret

0000000000000de2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     de2:	4885                	li	a7,1
 ecall
     de4:	00000073          	ecall
 ret
     de8:	8082                	ret

0000000000000dea <exit>:
.global exit
exit:
 li a7, SYS_exit
     dea:	4889                	li	a7,2
 ecall
     dec:	00000073          	ecall
 ret
     df0:	8082                	ret

0000000000000df2 <wait>:
.global wait
wait:
 li a7, SYS_wait
     df2:	488d                	li	a7,3
 ecall
     df4:	00000073          	ecall
 ret
     df8:	8082                	ret

0000000000000dfa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     dfa:	4891                	li	a7,4
 ecall
     dfc:	00000073          	ecall
 ret
     e00:	8082                	ret

0000000000000e02 <read>:
.global read
read:
 li a7, SYS_read
     e02:	4895                	li	a7,5
 ecall
     e04:	00000073          	ecall
 ret
     e08:	8082                	ret

0000000000000e0a <write>:
.global write
write:
 li a7, SYS_write
     e0a:	48c1                	li	a7,16
 ecall
     e0c:	00000073          	ecall
 ret
     e10:	8082                	ret

0000000000000e12 <close>:
.global close
close:
 li a7, SYS_close
     e12:	48d5                	li	a7,21
 ecall
     e14:	00000073          	ecall
 ret
     e18:	8082                	ret

0000000000000e1a <kill>:
.global kill
kill:
 li a7, SYS_kill
     e1a:	4899                	li	a7,6
 ecall
     e1c:	00000073          	ecall
 ret
     e20:	8082                	ret

0000000000000e22 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e22:	489d                	li	a7,7
 ecall
     e24:	00000073          	ecall
 ret
     e28:	8082                	ret

0000000000000e2a <open>:
.global open
open:
 li a7, SYS_open
     e2a:	48bd                	li	a7,15
 ecall
     e2c:	00000073          	ecall
 ret
     e30:	8082                	ret

0000000000000e32 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e32:	48c5                	li	a7,17
 ecall
     e34:	00000073          	ecall
 ret
     e38:	8082                	ret

0000000000000e3a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e3a:	48c9                	li	a7,18
 ecall
     e3c:	00000073          	ecall
 ret
     e40:	8082                	ret

0000000000000e42 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e42:	48a1                	li	a7,8
 ecall
     e44:	00000073          	ecall
 ret
     e48:	8082                	ret

0000000000000e4a <link>:
.global link
link:
 li a7, SYS_link
     e4a:	48cd                	li	a7,19
 ecall
     e4c:	00000073          	ecall
 ret
     e50:	8082                	ret

0000000000000e52 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e52:	48d1                	li	a7,20
 ecall
     e54:	00000073          	ecall
 ret
     e58:	8082                	ret

0000000000000e5a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e5a:	48a5                	li	a7,9
 ecall
     e5c:	00000073          	ecall
 ret
     e60:	8082                	ret

0000000000000e62 <dup>:
.global dup
dup:
 li a7, SYS_dup
     e62:	48a9                	li	a7,10
 ecall
     e64:	00000073          	ecall
 ret
     e68:	8082                	ret

0000000000000e6a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e6a:	48ad                	li	a7,11
 ecall
     e6c:	00000073          	ecall
 ret
     e70:	8082                	ret

0000000000000e72 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     e72:	48b1                	li	a7,12
 ecall
     e74:	00000073          	ecall
 ret
     e78:	8082                	ret

0000000000000e7a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     e7a:	48b5                	li	a7,13
 ecall
     e7c:	00000073          	ecall
 ret
     e80:	8082                	ret

0000000000000e82 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     e82:	48b9                	li	a7,14
 ecall
     e84:	00000073          	ecall
 ret
     e88:	8082                	ret

0000000000000e8a <connect>:
.global connect
connect:
 li a7, SYS_connect
     e8a:	48f5                	li	a7,29
 ecall
     e8c:	00000073          	ecall
 ret
     e90:	8082                	ret

0000000000000e92 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
     e92:	48f9                	li	a7,30
 ecall
     e94:	00000073          	ecall
 ret
     e98:	8082                	ret

0000000000000e9a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     e9a:	1101                	addi	sp,sp,-32
     e9c:	ec06                	sd	ra,24(sp)
     e9e:	e822                	sd	s0,16(sp)
     ea0:	1000                	addi	s0,sp,32
     ea2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ea6:	4605                	li	a2,1
     ea8:	fef40593          	addi	a1,s0,-17
     eac:	00000097          	auipc	ra,0x0
     eb0:	f5e080e7          	jalr	-162(ra) # e0a <write>
}
     eb4:	60e2                	ld	ra,24(sp)
     eb6:	6442                	ld	s0,16(sp)
     eb8:	6105                	addi	sp,sp,32
     eba:	8082                	ret

0000000000000ebc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ebc:	7139                	addi	sp,sp,-64
     ebe:	fc06                	sd	ra,56(sp)
     ec0:	f822                	sd	s0,48(sp)
     ec2:	f426                	sd	s1,40(sp)
     ec4:	0080                	addi	s0,sp,64
     ec6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     ec8:	c299                	beqz	a3,ece <printint+0x12>
     eca:	0805cb63          	bltz	a1,f60 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     ece:	2581                	sext.w	a1,a1
  neg = 0;
     ed0:	4881                	li	a7,0
     ed2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     ed6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     ed8:	2601                	sext.w	a2,a2
     eda:	00000517          	auipc	a0,0x0
     ede:	5e650513          	addi	a0,a0,1510 # 14c0 <digits>
     ee2:	883a                	mv	a6,a4
     ee4:	2705                	addiw	a4,a4,1
     ee6:	02c5f7bb          	remuw	a5,a1,a2
     eea:	1782                	slli	a5,a5,0x20
     eec:	9381                	srli	a5,a5,0x20
     eee:	97aa                	add	a5,a5,a0
     ef0:	0007c783          	lbu	a5,0(a5)
     ef4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     ef8:	0005879b          	sext.w	a5,a1
     efc:	02c5d5bb          	divuw	a1,a1,a2
     f00:	0685                	addi	a3,a3,1
     f02:	fec7f0e3          	bgeu	a5,a2,ee2 <printint+0x26>
  if(neg)
     f06:	00088c63          	beqz	a7,f1e <printint+0x62>
    buf[i++] = '-';
     f0a:	fd070793          	addi	a5,a4,-48
     f0e:	00878733          	add	a4,a5,s0
     f12:	02d00793          	li	a5,45
     f16:	fef70823          	sb	a5,-16(a4)
     f1a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     f1e:	02e05c63          	blez	a4,f56 <printint+0x9a>
     f22:	f04a                	sd	s2,32(sp)
     f24:	ec4e                	sd	s3,24(sp)
     f26:	fc040793          	addi	a5,s0,-64
     f2a:	00e78933          	add	s2,a5,a4
     f2e:	fff78993          	addi	s3,a5,-1
     f32:	99ba                	add	s3,s3,a4
     f34:	377d                	addiw	a4,a4,-1
     f36:	1702                	slli	a4,a4,0x20
     f38:	9301                	srli	a4,a4,0x20
     f3a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f3e:	fff94583          	lbu	a1,-1(s2)
     f42:	8526                	mv	a0,s1
     f44:	00000097          	auipc	ra,0x0
     f48:	f56080e7          	jalr	-170(ra) # e9a <putc>
  while(--i >= 0)
     f4c:	197d                	addi	s2,s2,-1
     f4e:	ff3918e3          	bne	s2,s3,f3e <printint+0x82>
     f52:	7902                	ld	s2,32(sp)
     f54:	69e2                	ld	s3,24(sp)
}
     f56:	70e2                	ld	ra,56(sp)
     f58:	7442                	ld	s0,48(sp)
     f5a:	74a2                	ld	s1,40(sp)
     f5c:	6121                	addi	sp,sp,64
     f5e:	8082                	ret
    x = -xx;
     f60:	40b005bb          	negw	a1,a1
    neg = 1;
     f64:	4885                	li	a7,1
    x = -xx;
     f66:	b7b5                	j	ed2 <printint+0x16>

0000000000000f68 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f68:	715d                	addi	sp,sp,-80
     f6a:	e486                	sd	ra,72(sp)
     f6c:	e0a2                	sd	s0,64(sp)
     f6e:	f84a                	sd	s2,48(sp)
     f70:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f72:	0005c903          	lbu	s2,0(a1)
     f76:	1a090a63          	beqz	s2,112a <vprintf+0x1c2>
     f7a:	fc26                	sd	s1,56(sp)
     f7c:	f44e                	sd	s3,40(sp)
     f7e:	f052                	sd	s4,32(sp)
     f80:	ec56                	sd	s5,24(sp)
     f82:	e85a                	sd	s6,16(sp)
     f84:	e45e                	sd	s7,8(sp)
     f86:	8aaa                	mv	s5,a0
     f88:	8bb2                	mv	s7,a2
     f8a:	00158493          	addi	s1,a1,1
  state = 0;
     f8e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     f90:	02500a13          	li	s4,37
     f94:	4b55                	li	s6,21
     f96:	a839                	j	fb4 <vprintf+0x4c>
        putc(fd, c);
     f98:	85ca                	mv	a1,s2
     f9a:	8556                	mv	a0,s5
     f9c:	00000097          	auipc	ra,0x0
     fa0:	efe080e7          	jalr	-258(ra) # e9a <putc>
     fa4:	a019                	j	faa <vprintf+0x42>
    } else if(state == '%'){
     fa6:	01498d63          	beq	s3,s4,fc0 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     faa:	0485                	addi	s1,s1,1
     fac:	fff4c903          	lbu	s2,-1(s1)
     fb0:	16090763          	beqz	s2,111e <vprintf+0x1b6>
    if(state == 0){
     fb4:	fe0999e3          	bnez	s3,fa6 <vprintf+0x3e>
      if(c == '%'){
     fb8:	ff4910e3          	bne	s2,s4,f98 <vprintf+0x30>
        state = '%';
     fbc:	89d2                	mv	s3,s4
     fbe:	b7f5                	j	faa <vprintf+0x42>
      if(c == 'd'){
     fc0:	13490463          	beq	s2,s4,10e8 <vprintf+0x180>
     fc4:	f9d9079b          	addiw	a5,s2,-99
     fc8:	0ff7f793          	zext.b	a5,a5
     fcc:	12fb6763          	bltu	s6,a5,10fa <vprintf+0x192>
     fd0:	f9d9079b          	addiw	a5,s2,-99
     fd4:	0ff7f713          	zext.b	a4,a5
     fd8:	12eb6163          	bltu	s6,a4,10fa <vprintf+0x192>
     fdc:	00271793          	slli	a5,a4,0x2
     fe0:	00000717          	auipc	a4,0x0
     fe4:	48870713          	addi	a4,a4,1160 # 1468 <malloc+0x24e>
     fe8:	97ba                	add	a5,a5,a4
     fea:	439c                	lw	a5,0(a5)
     fec:	97ba                	add	a5,a5,a4
     fee:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     ff0:	008b8913          	addi	s2,s7,8
     ff4:	4685                	li	a3,1
     ff6:	4629                	li	a2,10
     ff8:	000ba583          	lw	a1,0(s7)
     ffc:	8556                	mv	a0,s5
     ffe:	00000097          	auipc	ra,0x0
    1002:	ebe080e7          	jalr	-322(ra) # ebc <printint>
    1006:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1008:	4981                	li	s3,0
    100a:	b745                	j	faa <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    100c:	008b8913          	addi	s2,s7,8
    1010:	4681                	li	a3,0
    1012:	4629                	li	a2,10
    1014:	000ba583          	lw	a1,0(s7)
    1018:	8556                	mv	a0,s5
    101a:	00000097          	auipc	ra,0x0
    101e:	ea2080e7          	jalr	-350(ra) # ebc <printint>
    1022:	8bca                	mv	s7,s2
      state = 0;
    1024:	4981                	li	s3,0
    1026:	b751                	j	faa <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    1028:	008b8913          	addi	s2,s7,8
    102c:	4681                	li	a3,0
    102e:	4641                	li	a2,16
    1030:	000ba583          	lw	a1,0(s7)
    1034:	8556                	mv	a0,s5
    1036:	00000097          	auipc	ra,0x0
    103a:	e86080e7          	jalr	-378(ra) # ebc <printint>
    103e:	8bca                	mv	s7,s2
      state = 0;
    1040:	4981                	li	s3,0
    1042:	b7a5                	j	faa <vprintf+0x42>
    1044:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1046:	008b8c13          	addi	s8,s7,8
    104a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    104e:	03000593          	li	a1,48
    1052:	8556                	mv	a0,s5
    1054:	00000097          	auipc	ra,0x0
    1058:	e46080e7          	jalr	-442(ra) # e9a <putc>
  putc(fd, 'x');
    105c:	07800593          	li	a1,120
    1060:	8556                	mv	a0,s5
    1062:	00000097          	auipc	ra,0x0
    1066:	e38080e7          	jalr	-456(ra) # e9a <putc>
    106a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    106c:	00000b97          	auipc	s7,0x0
    1070:	454b8b93          	addi	s7,s7,1108 # 14c0 <digits>
    1074:	03c9d793          	srli	a5,s3,0x3c
    1078:	97de                	add	a5,a5,s7
    107a:	0007c583          	lbu	a1,0(a5)
    107e:	8556                	mv	a0,s5
    1080:	00000097          	auipc	ra,0x0
    1084:	e1a080e7          	jalr	-486(ra) # e9a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1088:	0992                	slli	s3,s3,0x4
    108a:	397d                	addiw	s2,s2,-1
    108c:	fe0914e3          	bnez	s2,1074 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    1090:	8be2                	mv	s7,s8
      state = 0;
    1092:	4981                	li	s3,0
    1094:	6c02                	ld	s8,0(sp)
    1096:	bf11                	j	faa <vprintf+0x42>
        s = va_arg(ap, char*);
    1098:	008b8993          	addi	s3,s7,8
    109c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    10a0:	02090163          	beqz	s2,10c2 <vprintf+0x15a>
        while(*s != 0){
    10a4:	00094583          	lbu	a1,0(s2)
    10a8:	c9a5                	beqz	a1,1118 <vprintf+0x1b0>
          putc(fd, *s);
    10aa:	8556                	mv	a0,s5
    10ac:	00000097          	auipc	ra,0x0
    10b0:	dee080e7          	jalr	-530(ra) # e9a <putc>
          s++;
    10b4:	0905                	addi	s2,s2,1
        while(*s != 0){
    10b6:	00094583          	lbu	a1,0(s2)
    10ba:	f9e5                	bnez	a1,10aa <vprintf+0x142>
        s = va_arg(ap, char*);
    10bc:	8bce                	mv	s7,s3
      state = 0;
    10be:	4981                	li	s3,0
    10c0:	b5ed                	j	faa <vprintf+0x42>
          s = "(null)";
    10c2:	00000917          	auipc	s2,0x0
    10c6:	36e90913          	addi	s2,s2,878 # 1430 <malloc+0x216>
        while(*s != 0){
    10ca:	02800593          	li	a1,40
    10ce:	bff1                	j	10aa <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    10d0:	008b8913          	addi	s2,s7,8
    10d4:	000bc583          	lbu	a1,0(s7)
    10d8:	8556                	mv	a0,s5
    10da:	00000097          	auipc	ra,0x0
    10de:	dc0080e7          	jalr	-576(ra) # e9a <putc>
    10e2:	8bca                	mv	s7,s2
      state = 0;
    10e4:	4981                	li	s3,0
    10e6:	b5d1                	j	faa <vprintf+0x42>
        putc(fd, c);
    10e8:	02500593          	li	a1,37
    10ec:	8556                	mv	a0,s5
    10ee:	00000097          	auipc	ra,0x0
    10f2:	dac080e7          	jalr	-596(ra) # e9a <putc>
      state = 0;
    10f6:	4981                	li	s3,0
    10f8:	bd4d                	j	faa <vprintf+0x42>
        putc(fd, '%');
    10fa:	02500593          	li	a1,37
    10fe:	8556                	mv	a0,s5
    1100:	00000097          	auipc	ra,0x0
    1104:	d9a080e7          	jalr	-614(ra) # e9a <putc>
        putc(fd, c);
    1108:	85ca                	mv	a1,s2
    110a:	8556                	mv	a0,s5
    110c:	00000097          	auipc	ra,0x0
    1110:	d8e080e7          	jalr	-626(ra) # e9a <putc>
      state = 0;
    1114:	4981                	li	s3,0
    1116:	bd51                	j	faa <vprintf+0x42>
        s = va_arg(ap, char*);
    1118:	8bce                	mv	s7,s3
      state = 0;
    111a:	4981                	li	s3,0
    111c:	b579                	j	faa <vprintf+0x42>
    111e:	74e2                	ld	s1,56(sp)
    1120:	79a2                	ld	s3,40(sp)
    1122:	7a02                	ld	s4,32(sp)
    1124:	6ae2                	ld	s5,24(sp)
    1126:	6b42                	ld	s6,16(sp)
    1128:	6ba2                	ld	s7,8(sp)
    }
  }
}
    112a:	60a6                	ld	ra,72(sp)
    112c:	6406                	ld	s0,64(sp)
    112e:	7942                	ld	s2,48(sp)
    1130:	6161                	addi	sp,sp,80
    1132:	8082                	ret

0000000000001134 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1134:	715d                	addi	sp,sp,-80
    1136:	ec06                	sd	ra,24(sp)
    1138:	e822                	sd	s0,16(sp)
    113a:	1000                	addi	s0,sp,32
    113c:	e010                	sd	a2,0(s0)
    113e:	e414                	sd	a3,8(s0)
    1140:	e818                	sd	a4,16(s0)
    1142:	ec1c                	sd	a5,24(s0)
    1144:	03043023          	sd	a6,32(s0)
    1148:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    114c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1150:	8622                	mv	a2,s0
    1152:	00000097          	auipc	ra,0x0
    1156:	e16080e7          	jalr	-490(ra) # f68 <vprintf>
}
    115a:	60e2                	ld	ra,24(sp)
    115c:	6442                	ld	s0,16(sp)
    115e:	6161                	addi	sp,sp,80
    1160:	8082                	ret

0000000000001162 <printf>:

void
printf(const char *fmt, ...)
{
    1162:	711d                	addi	sp,sp,-96
    1164:	ec06                	sd	ra,24(sp)
    1166:	e822                	sd	s0,16(sp)
    1168:	1000                	addi	s0,sp,32
    116a:	e40c                	sd	a1,8(s0)
    116c:	e810                	sd	a2,16(s0)
    116e:	ec14                	sd	a3,24(s0)
    1170:	f018                	sd	a4,32(s0)
    1172:	f41c                	sd	a5,40(s0)
    1174:	03043823          	sd	a6,48(s0)
    1178:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    117c:	00840613          	addi	a2,s0,8
    1180:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1184:	85aa                	mv	a1,a0
    1186:	4505                	li	a0,1
    1188:	00000097          	auipc	ra,0x0
    118c:	de0080e7          	jalr	-544(ra) # f68 <vprintf>
}
    1190:	60e2                	ld	ra,24(sp)
    1192:	6442                	ld	s0,16(sp)
    1194:	6125                	addi	sp,sp,96
    1196:	8082                	ret

0000000000001198 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1198:	1141                	addi	sp,sp,-16
    119a:	e422                	sd	s0,8(sp)
    119c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    119e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11a2:	00001797          	auipc	a5,0x1
    11a6:	b0e7b783          	ld	a5,-1266(a5) # 1cb0 <freep>
    11aa:	a02d                	j	11d4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    11ac:	4618                	lw	a4,8(a2)
    11ae:	9f2d                	addw	a4,a4,a1
    11b0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    11b4:	6398                	ld	a4,0(a5)
    11b6:	6310                	ld	a2,0(a4)
    11b8:	a83d                	j	11f6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    11ba:	ff852703          	lw	a4,-8(a0)
    11be:	9f31                	addw	a4,a4,a2
    11c0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    11c2:	ff053683          	ld	a3,-16(a0)
    11c6:	a091                	j	120a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11c8:	6398                	ld	a4,0(a5)
    11ca:	00e7e463          	bltu	a5,a4,11d2 <free+0x3a>
    11ce:	00e6ea63          	bltu	a3,a4,11e2 <free+0x4a>
{
    11d2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11d4:	fed7fae3          	bgeu	a5,a3,11c8 <free+0x30>
    11d8:	6398                	ld	a4,0(a5)
    11da:	00e6e463          	bltu	a3,a4,11e2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11de:	fee7eae3          	bltu	a5,a4,11d2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    11e2:	ff852583          	lw	a1,-8(a0)
    11e6:	6390                	ld	a2,0(a5)
    11e8:	02059813          	slli	a6,a1,0x20
    11ec:	01c85713          	srli	a4,a6,0x1c
    11f0:	9736                	add	a4,a4,a3
    11f2:	fae60de3          	beq	a2,a4,11ac <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    11f6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    11fa:	4790                	lw	a2,8(a5)
    11fc:	02061593          	slli	a1,a2,0x20
    1200:	01c5d713          	srli	a4,a1,0x1c
    1204:	973e                	add	a4,a4,a5
    1206:	fae68ae3          	beq	a3,a4,11ba <free+0x22>
    p->s.ptr = bp->s.ptr;
    120a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    120c:	00001717          	auipc	a4,0x1
    1210:	aaf73223          	sd	a5,-1372(a4) # 1cb0 <freep>
}
    1214:	6422                	ld	s0,8(sp)
    1216:	0141                	addi	sp,sp,16
    1218:	8082                	ret

000000000000121a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    121a:	7139                	addi	sp,sp,-64
    121c:	fc06                	sd	ra,56(sp)
    121e:	f822                	sd	s0,48(sp)
    1220:	f426                	sd	s1,40(sp)
    1222:	ec4e                	sd	s3,24(sp)
    1224:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1226:	02051493          	slli	s1,a0,0x20
    122a:	9081                	srli	s1,s1,0x20
    122c:	04bd                	addi	s1,s1,15
    122e:	8091                	srli	s1,s1,0x4
    1230:	0014899b          	addiw	s3,s1,1
    1234:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1236:	00001517          	auipc	a0,0x1
    123a:	a7a53503          	ld	a0,-1414(a0) # 1cb0 <freep>
    123e:	c915                	beqz	a0,1272 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1240:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1242:	4798                	lw	a4,8(a5)
    1244:	08977e63          	bgeu	a4,s1,12e0 <malloc+0xc6>
    1248:	f04a                	sd	s2,32(sp)
    124a:	e852                	sd	s4,16(sp)
    124c:	e456                	sd	s5,8(sp)
    124e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1250:	8a4e                	mv	s4,s3
    1252:	0009871b          	sext.w	a4,s3
    1256:	6685                	lui	a3,0x1
    1258:	00d77363          	bgeu	a4,a3,125e <malloc+0x44>
    125c:	6a05                	lui	s4,0x1
    125e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1262:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1266:	00001917          	auipc	s2,0x1
    126a:	a4a90913          	addi	s2,s2,-1462 # 1cb0 <freep>
  if(p == (char*)-1)
    126e:	5afd                	li	s5,-1
    1270:	a091                	j	12b4 <malloc+0x9a>
    1272:	f04a                	sd	s2,32(sp)
    1274:	e852                	sd	s4,16(sp)
    1276:	e456                	sd	s5,8(sp)
    1278:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    127a:	00001797          	auipc	a5,0x1
    127e:	aa678793          	addi	a5,a5,-1370 # 1d20 <base>
    1282:	00001717          	auipc	a4,0x1
    1286:	a2f73723          	sd	a5,-1490(a4) # 1cb0 <freep>
    128a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    128c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1290:	b7c1                	j	1250 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    1292:	6398                	ld	a4,0(a5)
    1294:	e118                	sd	a4,0(a0)
    1296:	a08d                	j	12f8 <malloc+0xde>
  hp->s.size = nu;
    1298:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    129c:	0541                	addi	a0,a0,16
    129e:	00000097          	auipc	ra,0x0
    12a2:	efa080e7          	jalr	-262(ra) # 1198 <free>
  return freep;
    12a6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    12aa:	c13d                	beqz	a0,1310 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12ae:	4798                	lw	a4,8(a5)
    12b0:	02977463          	bgeu	a4,s1,12d8 <malloc+0xbe>
    if(p == freep)
    12b4:	00093703          	ld	a4,0(s2)
    12b8:	853e                	mv	a0,a5
    12ba:	fef719e3          	bne	a4,a5,12ac <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    12be:	8552                	mv	a0,s4
    12c0:	00000097          	auipc	ra,0x0
    12c4:	bb2080e7          	jalr	-1102(ra) # e72 <sbrk>
  if(p == (char*)-1)
    12c8:	fd5518e3          	bne	a0,s5,1298 <malloc+0x7e>
        return 0;
    12cc:	4501                	li	a0,0
    12ce:	7902                	ld	s2,32(sp)
    12d0:	6a42                	ld	s4,16(sp)
    12d2:	6aa2                	ld	s5,8(sp)
    12d4:	6b02                	ld	s6,0(sp)
    12d6:	a03d                	j	1304 <malloc+0xea>
    12d8:	7902                	ld	s2,32(sp)
    12da:	6a42                	ld	s4,16(sp)
    12dc:	6aa2                	ld	s5,8(sp)
    12de:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    12e0:	fae489e3          	beq	s1,a4,1292 <malloc+0x78>
        p->s.size -= nunits;
    12e4:	4137073b          	subw	a4,a4,s3
    12e8:	c798                	sw	a4,8(a5)
        p += p->s.size;
    12ea:	02071693          	slli	a3,a4,0x20
    12ee:	01c6d713          	srli	a4,a3,0x1c
    12f2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    12f4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    12f8:	00001717          	auipc	a4,0x1
    12fc:	9aa73c23          	sd	a0,-1608(a4) # 1cb0 <freep>
      return (void*)(p + 1);
    1300:	01078513          	addi	a0,a5,16
  }
}
    1304:	70e2                	ld	ra,56(sp)
    1306:	7442                	ld	s0,48(sp)
    1308:	74a2                	ld	s1,40(sp)
    130a:	69e2                	ld	s3,24(sp)
    130c:	6121                	addi	sp,sp,64
    130e:	8082                	ret
    1310:	7902                	ld	s2,32(sp)
    1312:	6a42                	ld	s4,16(sp)
    1314:	6aa2                	ld	s5,8(sp)
    1316:	6b02                	ld	s6,0(sp)
    1318:	b7f5                	j	1304 <malloc+0xea>
