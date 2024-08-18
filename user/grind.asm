
user/_grind：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <__global_pointer$+0x1cf61>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <__global_pointer$+0x1deb>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <__global_pointer$+0xffffffffffffd130>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00002517          	auipc	a0,0x2
      64:	b6050513          	addi	a0,a0,-1184 # 1bc0 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	addi	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7159                	addi	sp,sp,-112
      7a:	f486                	sd	ra,104(sp)
      7c:	f0a2                	sd	s0,96(sp)
      7e:	eca6                	sd	s1,88(sp)
      80:	fc56                	sd	s5,56(sp)
      82:	1880                	addi	s0,sp,112
      84:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      86:	4501                	li	a0,0
      88:	00001097          	auipc	ra,0x1
      8c:	e20080e7          	jalr	-480(ra) # ea8 <sbrk>
      90:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      92:	00001517          	auipc	a0,0x1
      96:	2be50513          	addi	a0,a0,702 # 1350 <malloc+0x100>
      9a:	00001097          	auipc	ra,0x1
      9e:	dee080e7          	jalr	-530(ra) # e88 <mkdir>
  if(chdir("grindir") != 0){
      a2:	00001517          	auipc	a0,0x1
      a6:	2ae50513          	addi	a0,a0,686 # 1350 <malloc+0x100>
      aa:	00001097          	auipc	ra,0x1
      ae:	de6080e7          	jalr	-538(ra) # e90 <chdir>
      b2:	c115                	beqz	a0,d6 <go+0x5e>
      b4:	e8ca                	sd	s2,80(sp)
      b6:	e4ce                	sd	s3,72(sp)
      b8:	e0d2                	sd	s4,64(sp)
      ba:	f85a                	sd	s6,48(sp)
    printf("grind: chdir grindir failed\n");
      bc:	00001517          	auipc	a0,0x1
      c0:	29c50513          	addi	a0,a0,668 # 1358 <malloc+0x108>
      c4:	00001097          	auipc	ra,0x1
      c8:	0d4080e7          	jalr	212(ra) # 1198 <printf>
    exit(1);
      cc:	4505                	li	a0,1
      ce:	00001097          	auipc	ra,0x1
      d2:	d52080e7          	jalr	-686(ra) # e20 <exit>
      d6:	e8ca                	sd	s2,80(sp)
      d8:	e4ce                	sd	s3,72(sp)
      da:	e0d2                	sd	s4,64(sp)
      dc:	f85a                	sd	s6,48(sp)
  }
  chdir("/");
      de:	00001517          	auipc	a0,0x1
      e2:	2a250513          	addi	a0,a0,674 # 1380 <malloc+0x130>
      e6:	00001097          	auipc	ra,0x1
      ea:	daa080e7          	jalr	-598(ra) # e90 <chdir>
      ee:	00001997          	auipc	s3,0x1
      f2:	2a298993          	addi	s3,s3,674 # 1390 <malloc+0x140>
      f6:	c489                	beqz	s1,100 <go+0x88>
      f8:	00001997          	auipc	s3,0x1
      fc:	29098993          	addi	s3,s3,656 # 1388 <malloc+0x138>
  uint64 iters = 0;
     100:	4481                	li	s1,0
  int fd = -1;
     102:	5a7d                	li	s4,-1
     104:	00001917          	auipc	s2,0x1
     108:	55c90913          	addi	s2,s2,1372 # 1660 <malloc+0x410>
     10c:	a839                	j	12a <go+0xb2>
    iters++;
    if((iters % 500) == 0)
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
     10e:	20200593          	li	a1,514
     112:	00001517          	auipc	a0,0x1
     116:	28650513          	addi	a0,a0,646 # 1398 <malloc+0x148>
     11a:	00001097          	auipc	ra,0x1
     11e:	d46080e7          	jalr	-698(ra) # e60 <open>
     122:	00001097          	auipc	ra,0x1
     126:	d26080e7          	jalr	-730(ra) # e48 <close>
    iters++;
     12a:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     12c:	1f400793          	li	a5,500
     130:	02f4f7b3          	remu	a5,s1,a5
     134:	eb81                	bnez	a5,144 <go+0xcc>
      write(1, which_child?"B":"A", 1);
     136:	4605                	li	a2,1
     138:	85ce                	mv	a1,s3
     13a:	4505                	li	a0,1
     13c:	00001097          	auipc	ra,0x1
     140:	d04080e7          	jalr	-764(ra) # e40 <write>
    int what = rand() % 23;
     144:	00000097          	auipc	ra,0x0
     148:	f14080e7          	jalr	-236(ra) # 58 <rand>
     14c:	47dd                	li	a5,23
     14e:	02f5653b          	remw	a0,a0,a5
     152:	0005071b          	sext.w	a4,a0
     156:	47d9                	li	a5,22
     158:	fce7e9e3          	bltu	a5,a4,12a <go+0xb2>
     15c:	02051793          	slli	a5,a0,0x20
     160:	01e7d513          	srli	a0,a5,0x1e
     164:	954a                	add	a0,a0,s2
     166:	411c                	lw	a5,0(a0)
     168:	97ca                	add	a5,a5,s2
     16a:	8782                	jr	a5
    } else if(what == 2){
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     16c:	20200593          	li	a1,514
     170:	00001517          	auipc	a0,0x1
     174:	23850513          	addi	a0,a0,568 # 13a8 <malloc+0x158>
     178:	00001097          	auipc	ra,0x1
     17c:	ce8080e7          	jalr	-792(ra) # e60 <open>
     180:	00001097          	auipc	ra,0x1
     184:	cc8080e7          	jalr	-824(ra) # e48 <close>
     188:	b74d                	j	12a <go+0xb2>
    } else if(what == 3){
      unlink("grindir/../a");
     18a:	00001517          	auipc	a0,0x1
     18e:	20e50513          	addi	a0,a0,526 # 1398 <malloc+0x148>
     192:	00001097          	auipc	ra,0x1
     196:	cde080e7          	jalr	-802(ra) # e70 <unlink>
     19a:	bf41                	j	12a <go+0xb2>
    } else if(what == 4){
      if(chdir("grindir") != 0){
     19c:	00001517          	auipc	a0,0x1
     1a0:	1b450513          	addi	a0,a0,436 # 1350 <malloc+0x100>
     1a4:	00001097          	auipc	ra,0x1
     1a8:	cec080e7          	jalr	-788(ra) # e90 <chdir>
     1ac:	e115                	bnez	a0,1d0 <go+0x158>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     1ae:	00001517          	auipc	a0,0x1
     1b2:	21250513          	addi	a0,a0,530 # 13c0 <malloc+0x170>
     1b6:	00001097          	auipc	ra,0x1
     1ba:	cba080e7          	jalr	-838(ra) # e70 <unlink>
      chdir("/");
     1be:	00001517          	auipc	a0,0x1
     1c2:	1c250513          	addi	a0,a0,450 # 1380 <malloc+0x130>
     1c6:	00001097          	auipc	ra,0x1
     1ca:	cca080e7          	jalr	-822(ra) # e90 <chdir>
     1ce:	bfb1                	j	12a <go+0xb2>
        printf("grind: chdir grindir failed\n");
     1d0:	00001517          	auipc	a0,0x1
     1d4:	18850513          	addi	a0,a0,392 # 1358 <malloc+0x108>
     1d8:	00001097          	auipc	ra,0x1
     1dc:	fc0080e7          	jalr	-64(ra) # 1198 <printf>
        exit(1);
     1e0:	4505                	li	a0,1
     1e2:	00001097          	auipc	ra,0x1
     1e6:	c3e080e7          	jalr	-962(ra) # e20 <exit>
    } else if(what == 5){
      close(fd);
     1ea:	8552                	mv	a0,s4
     1ec:	00001097          	auipc	ra,0x1
     1f0:	c5c080e7          	jalr	-932(ra) # e48 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     1f4:	20200593          	li	a1,514
     1f8:	00001517          	auipc	a0,0x1
     1fc:	1d050513          	addi	a0,a0,464 # 13c8 <malloc+0x178>
     200:	00001097          	auipc	ra,0x1
     204:	c60080e7          	jalr	-928(ra) # e60 <open>
     208:	8a2a                	mv	s4,a0
     20a:	b705                	j	12a <go+0xb2>
    } else if(what == 6){
      close(fd);
     20c:	8552                	mv	a0,s4
     20e:	00001097          	auipc	ra,0x1
     212:	c3a080e7          	jalr	-966(ra) # e48 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     216:	20200593          	li	a1,514
     21a:	00001517          	auipc	a0,0x1
     21e:	1be50513          	addi	a0,a0,446 # 13d8 <malloc+0x188>
     222:	00001097          	auipc	ra,0x1
     226:	c3e080e7          	jalr	-962(ra) # e60 <open>
     22a:	8a2a                	mv	s4,a0
     22c:	bdfd                	j	12a <go+0xb2>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
     22e:	3e700613          	li	a2,999
     232:	00002597          	auipc	a1,0x2
     236:	99e58593          	addi	a1,a1,-1634 # 1bd0 <buf.0>
     23a:	8552                	mv	a0,s4
     23c:	00001097          	auipc	ra,0x1
     240:	c04080e7          	jalr	-1020(ra) # e40 <write>
     244:	b5dd                	j	12a <go+0xb2>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     246:	3e700613          	li	a2,999
     24a:	00002597          	auipc	a1,0x2
     24e:	98658593          	addi	a1,a1,-1658 # 1bd0 <buf.0>
     252:	8552                	mv	a0,s4
     254:	00001097          	auipc	ra,0x1
     258:	be4080e7          	jalr	-1052(ra) # e38 <read>
     25c:	b5f9                	j	12a <go+0xb2>
    } else if(what == 9){
      mkdir("grindir/../a");
     25e:	00001517          	auipc	a0,0x1
     262:	13a50513          	addi	a0,a0,314 # 1398 <malloc+0x148>
     266:	00001097          	auipc	ra,0x1
     26a:	c22080e7          	jalr	-990(ra) # e88 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     26e:	20200593          	li	a1,514
     272:	00001517          	auipc	a0,0x1
     276:	17e50513          	addi	a0,a0,382 # 13f0 <malloc+0x1a0>
     27a:	00001097          	auipc	ra,0x1
     27e:	be6080e7          	jalr	-1050(ra) # e60 <open>
     282:	00001097          	auipc	ra,0x1
     286:	bc6080e7          	jalr	-1082(ra) # e48 <close>
      unlink("a/a");
     28a:	00001517          	auipc	a0,0x1
     28e:	17650513          	addi	a0,a0,374 # 1400 <malloc+0x1b0>
     292:	00001097          	auipc	ra,0x1
     296:	bde080e7          	jalr	-1058(ra) # e70 <unlink>
     29a:	bd41                	j	12a <go+0xb2>
    } else if(what == 10){
      mkdir("/../b");
     29c:	00001517          	auipc	a0,0x1
     2a0:	16c50513          	addi	a0,a0,364 # 1408 <malloc+0x1b8>
     2a4:	00001097          	auipc	ra,0x1
     2a8:	be4080e7          	jalr	-1052(ra) # e88 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     2ac:	20200593          	li	a1,514
     2b0:	00001517          	auipc	a0,0x1
     2b4:	16050513          	addi	a0,a0,352 # 1410 <malloc+0x1c0>
     2b8:	00001097          	auipc	ra,0x1
     2bc:	ba8080e7          	jalr	-1112(ra) # e60 <open>
     2c0:	00001097          	auipc	ra,0x1
     2c4:	b88080e7          	jalr	-1144(ra) # e48 <close>
      unlink("b/b");
     2c8:	00001517          	auipc	a0,0x1
     2cc:	15850513          	addi	a0,a0,344 # 1420 <malloc+0x1d0>
     2d0:	00001097          	auipc	ra,0x1
     2d4:	ba0080e7          	jalr	-1120(ra) # e70 <unlink>
     2d8:	bd89                	j	12a <go+0xb2>
    } else if(what == 11){
      unlink("b");
     2da:	00001517          	auipc	a0,0x1
     2de:	14e50513          	addi	a0,a0,334 # 1428 <malloc+0x1d8>
     2e2:	00001097          	auipc	ra,0x1
     2e6:	b8e080e7          	jalr	-1138(ra) # e70 <unlink>
      link("../grindir/./../a", "../b");
     2ea:	00001597          	auipc	a1,0x1
     2ee:	0d658593          	addi	a1,a1,214 # 13c0 <malloc+0x170>
     2f2:	00001517          	auipc	a0,0x1
     2f6:	13e50513          	addi	a0,a0,318 # 1430 <malloc+0x1e0>
     2fa:	00001097          	auipc	ra,0x1
     2fe:	b86080e7          	jalr	-1146(ra) # e80 <link>
     302:	b525                	j	12a <go+0xb2>
    } else if(what == 12){
      unlink("../grindir/../a");
     304:	00001517          	auipc	a0,0x1
     308:	14450513          	addi	a0,a0,324 # 1448 <malloc+0x1f8>
     30c:	00001097          	auipc	ra,0x1
     310:	b64080e7          	jalr	-1180(ra) # e70 <unlink>
      link(".././b", "/grindir/../a");
     314:	00001597          	auipc	a1,0x1
     318:	0b458593          	addi	a1,a1,180 # 13c8 <malloc+0x178>
     31c:	00001517          	auipc	a0,0x1
     320:	13c50513          	addi	a0,a0,316 # 1458 <malloc+0x208>
     324:	00001097          	auipc	ra,0x1
     328:	b5c080e7          	jalr	-1188(ra) # e80 <link>
     32c:	bbfd                	j	12a <go+0xb2>
    } else if(what == 13){
      int pid = fork();
     32e:	00001097          	auipc	ra,0x1
     332:	aea080e7          	jalr	-1302(ra) # e18 <fork>
      if(pid == 0){
     336:	c909                	beqz	a0,348 <go+0x2d0>
        exit(0);
      } else if(pid < 0){
     338:	00054c63          	bltz	a0,350 <go+0x2d8>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     33c:	4501                	li	a0,0
     33e:	00001097          	auipc	ra,0x1
     342:	aea080e7          	jalr	-1302(ra) # e28 <wait>
     346:	b3d5                	j	12a <go+0xb2>
        exit(0);
     348:	00001097          	auipc	ra,0x1
     34c:	ad8080e7          	jalr	-1320(ra) # e20 <exit>
        printf("grind: fork failed\n");
     350:	00001517          	auipc	a0,0x1
     354:	11050513          	addi	a0,a0,272 # 1460 <malloc+0x210>
     358:	00001097          	auipc	ra,0x1
     35c:	e40080e7          	jalr	-448(ra) # 1198 <printf>
        exit(1);
     360:	4505                	li	a0,1
     362:	00001097          	auipc	ra,0x1
     366:	abe080e7          	jalr	-1346(ra) # e20 <exit>
    } else if(what == 14){
      int pid = fork();
     36a:	00001097          	auipc	ra,0x1
     36e:	aae080e7          	jalr	-1362(ra) # e18 <fork>
      if(pid == 0){
     372:	c909                	beqz	a0,384 <go+0x30c>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
     374:	02054563          	bltz	a0,39e <go+0x326>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     378:	4501                	li	a0,0
     37a:	00001097          	auipc	ra,0x1
     37e:	aae080e7          	jalr	-1362(ra) # e28 <wait>
     382:	b365                	j	12a <go+0xb2>
        fork();
     384:	00001097          	auipc	ra,0x1
     388:	a94080e7          	jalr	-1388(ra) # e18 <fork>
        fork();
     38c:	00001097          	auipc	ra,0x1
     390:	a8c080e7          	jalr	-1396(ra) # e18 <fork>
        exit(0);
     394:	4501                	li	a0,0
     396:	00001097          	auipc	ra,0x1
     39a:	a8a080e7          	jalr	-1398(ra) # e20 <exit>
        printf("grind: fork failed\n");
     39e:	00001517          	auipc	a0,0x1
     3a2:	0c250513          	addi	a0,a0,194 # 1460 <malloc+0x210>
     3a6:	00001097          	auipc	ra,0x1
     3aa:	df2080e7          	jalr	-526(ra) # 1198 <printf>
        exit(1);
     3ae:	4505                	li	a0,1
     3b0:	00001097          	auipc	ra,0x1
     3b4:	a70080e7          	jalr	-1424(ra) # e20 <exit>
    } else if(what == 15){
      sbrk(6011);
     3b8:	6505                	lui	a0,0x1
     3ba:	77b50513          	addi	a0,a0,1915 # 177b <digits+0x63>
     3be:	00001097          	auipc	ra,0x1
     3c2:	aea080e7          	jalr	-1302(ra) # ea8 <sbrk>
     3c6:	b395                	j	12a <go+0xb2>
    } else if(what == 16){
      if(sbrk(0) > break0)
     3c8:	4501                	li	a0,0
     3ca:	00001097          	auipc	ra,0x1
     3ce:	ade080e7          	jalr	-1314(ra) # ea8 <sbrk>
     3d2:	d4aafce3          	bgeu	s5,a0,12a <go+0xb2>
        sbrk(-(sbrk(0) - break0));
     3d6:	4501                	li	a0,0
     3d8:	00001097          	auipc	ra,0x1
     3dc:	ad0080e7          	jalr	-1328(ra) # ea8 <sbrk>
     3e0:	40aa853b          	subw	a0,s5,a0
     3e4:	00001097          	auipc	ra,0x1
     3e8:	ac4080e7          	jalr	-1340(ra) # ea8 <sbrk>
     3ec:	bb3d                	j	12a <go+0xb2>
    } else if(what == 17){
      int pid = fork();
     3ee:	00001097          	auipc	ra,0x1
     3f2:	a2a080e7          	jalr	-1494(ra) # e18 <fork>
     3f6:	8b2a                	mv	s6,a0
      if(pid == 0){
     3f8:	c51d                	beqz	a0,426 <go+0x3ae>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     3fa:	04054963          	bltz	a0,44c <go+0x3d4>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     3fe:	00001517          	auipc	a0,0x1
     402:	08250513          	addi	a0,a0,130 # 1480 <malloc+0x230>
     406:	00001097          	auipc	ra,0x1
     40a:	a8a080e7          	jalr	-1398(ra) # e90 <chdir>
     40e:	ed21                	bnez	a0,466 <go+0x3ee>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     410:	855a                	mv	a0,s6
     412:	00001097          	auipc	ra,0x1
     416:	a3e080e7          	jalr	-1474(ra) # e50 <kill>
      wait(0);
     41a:	4501                	li	a0,0
     41c:	00001097          	auipc	ra,0x1
     420:	a0c080e7          	jalr	-1524(ra) # e28 <wait>
     424:	b319                	j	12a <go+0xb2>
        close(open("a", O_CREATE|O_RDWR));
     426:	20200593          	li	a1,514
     42a:	00001517          	auipc	a0,0x1
     42e:	04e50513          	addi	a0,a0,78 # 1478 <malloc+0x228>
     432:	00001097          	auipc	ra,0x1
     436:	a2e080e7          	jalr	-1490(ra) # e60 <open>
     43a:	00001097          	auipc	ra,0x1
     43e:	a0e080e7          	jalr	-1522(ra) # e48 <close>
        exit(0);
     442:	4501                	li	a0,0
     444:	00001097          	auipc	ra,0x1
     448:	9dc080e7          	jalr	-1572(ra) # e20 <exit>
        printf("grind: fork failed\n");
     44c:	00001517          	auipc	a0,0x1
     450:	01450513          	addi	a0,a0,20 # 1460 <malloc+0x210>
     454:	00001097          	auipc	ra,0x1
     458:	d44080e7          	jalr	-700(ra) # 1198 <printf>
        exit(1);
     45c:	4505                	li	a0,1
     45e:	00001097          	auipc	ra,0x1
     462:	9c2080e7          	jalr	-1598(ra) # e20 <exit>
        printf("grind: chdir failed\n");
     466:	00001517          	auipc	a0,0x1
     46a:	02a50513          	addi	a0,a0,42 # 1490 <malloc+0x240>
     46e:	00001097          	auipc	ra,0x1
     472:	d2a080e7          	jalr	-726(ra) # 1198 <printf>
        exit(1);
     476:	4505                	li	a0,1
     478:	00001097          	auipc	ra,0x1
     47c:	9a8080e7          	jalr	-1624(ra) # e20 <exit>
    } else if(what == 18){
      int pid = fork();
     480:	00001097          	auipc	ra,0x1
     484:	998080e7          	jalr	-1640(ra) # e18 <fork>
      if(pid == 0){
     488:	c909                	beqz	a0,49a <go+0x422>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     48a:	02054563          	bltz	a0,4b4 <go+0x43c>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     48e:	4501                	li	a0,0
     490:	00001097          	auipc	ra,0x1
     494:	998080e7          	jalr	-1640(ra) # e28 <wait>
     498:	b949                	j	12a <go+0xb2>
        kill(getpid());
     49a:	00001097          	auipc	ra,0x1
     49e:	a06080e7          	jalr	-1530(ra) # ea0 <getpid>
     4a2:	00001097          	auipc	ra,0x1
     4a6:	9ae080e7          	jalr	-1618(ra) # e50 <kill>
        exit(0);
     4aa:	4501                	li	a0,0
     4ac:	00001097          	auipc	ra,0x1
     4b0:	974080e7          	jalr	-1676(ra) # e20 <exit>
        printf("grind: fork failed\n");
     4b4:	00001517          	auipc	a0,0x1
     4b8:	fac50513          	addi	a0,a0,-84 # 1460 <malloc+0x210>
     4bc:	00001097          	auipc	ra,0x1
     4c0:	cdc080e7          	jalr	-804(ra) # 1198 <printf>
        exit(1);
     4c4:	4505                	li	a0,1
     4c6:	00001097          	auipc	ra,0x1
     4ca:	95a080e7          	jalr	-1702(ra) # e20 <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     4ce:	fa840513          	addi	a0,s0,-88
     4d2:	00001097          	auipc	ra,0x1
     4d6:	95e080e7          	jalr	-1698(ra) # e30 <pipe>
     4da:	02054b63          	bltz	a0,510 <go+0x498>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     4de:	00001097          	auipc	ra,0x1
     4e2:	93a080e7          	jalr	-1734(ra) # e18 <fork>
      if(pid == 0){
     4e6:	c131                	beqz	a0,52a <go+0x4b2>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     4e8:	0a054a63          	bltz	a0,59c <go+0x524>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     4ec:	fa842503          	lw	a0,-88(s0)
     4f0:	00001097          	auipc	ra,0x1
     4f4:	958080e7          	jalr	-1704(ra) # e48 <close>
      close(fds[1]);
     4f8:	fac42503          	lw	a0,-84(s0)
     4fc:	00001097          	auipc	ra,0x1
     500:	94c080e7          	jalr	-1716(ra) # e48 <close>
      wait(0);
     504:	4501                	li	a0,0
     506:	00001097          	auipc	ra,0x1
     50a:	922080e7          	jalr	-1758(ra) # e28 <wait>
     50e:	b931                	j	12a <go+0xb2>
        printf("grind: pipe failed\n");
     510:	00001517          	auipc	a0,0x1
     514:	f9850513          	addi	a0,a0,-104 # 14a8 <malloc+0x258>
     518:	00001097          	auipc	ra,0x1
     51c:	c80080e7          	jalr	-896(ra) # 1198 <printf>
        exit(1);
     520:	4505                	li	a0,1
     522:	00001097          	auipc	ra,0x1
     526:	8fe080e7          	jalr	-1794(ra) # e20 <exit>
        fork();
     52a:	00001097          	auipc	ra,0x1
     52e:	8ee080e7          	jalr	-1810(ra) # e18 <fork>
        fork();
     532:	00001097          	auipc	ra,0x1
     536:	8e6080e7          	jalr	-1818(ra) # e18 <fork>
        if(write(fds[1], "x", 1) != 1)
     53a:	4605                	li	a2,1
     53c:	00001597          	auipc	a1,0x1
     540:	f8458593          	addi	a1,a1,-124 # 14c0 <malloc+0x270>
     544:	fac42503          	lw	a0,-84(s0)
     548:	00001097          	auipc	ra,0x1
     54c:	8f8080e7          	jalr	-1800(ra) # e40 <write>
     550:	4785                	li	a5,1
     552:	02f51363          	bne	a0,a5,578 <go+0x500>
        if(read(fds[0], &c, 1) != 1)
     556:	4605                	li	a2,1
     558:	fa040593          	addi	a1,s0,-96
     55c:	fa842503          	lw	a0,-88(s0)
     560:	00001097          	auipc	ra,0x1
     564:	8d8080e7          	jalr	-1832(ra) # e38 <read>
     568:	4785                	li	a5,1
     56a:	02f51063          	bne	a0,a5,58a <go+0x512>
        exit(0);
     56e:	4501                	li	a0,0
     570:	00001097          	auipc	ra,0x1
     574:	8b0080e7          	jalr	-1872(ra) # e20 <exit>
          printf("grind: pipe write failed\n");
     578:	00001517          	auipc	a0,0x1
     57c:	f5050513          	addi	a0,a0,-176 # 14c8 <malloc+0x278>
     580:	00001097          	auipc	ra,0x1
     584:	c18080e7          	jalr	-1000(ra) # 1198 <printf>
     588:	b7f9                	j	556 <go+0x4de>
          printf("grind: pipe read failed\n");
     58a:	00001517          	auipc	a0,0x1
     58e:	f5e50513          	addi	a0,a0,-162 # 14e8 <malloc+0x298>
     592:	00001097          	auipc	ra,0x1
     596:	c06080e7          	jalr	-1018(ra) # 1198 <printf>
     59a:	bfd1                	j	56e <go+0x4f6>
        printf("grind: fork failed\n");
     59c:	00001517          	auipc	a0,0x1
     5a0:	ec450513          	addi	a0,a0,-316 # 1460 <malloc+0x210>
     5a4:	00001097          	auipc	ra,0x1
     5a8:	bf4080e7          	jalr	-1036(ra) # 1198 <printf>
        exit(1);
     5ac:	4505                	li	a0,1
     5ae:	00001097          	auipc	ra,0x1
     5b2:	872080e7          	jalr	-1934(ra) # e20 <exit>
    } else if(what == 20){
      int pid = fork();
     5b6:	00001097          	auipc	ra,0x1
     5ba:	862080e7          	jalr	-1950(ra) # e18 <fork>
      if(pid == 0){
     5be:	c909                	beqz	a0,5d0 <go+0x558>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     5c0:	06054f63          	bltz	a0,63e <go+0x5c6>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     5c4:	4501                	li	a0,0
     5c6:	00001097          	auipc	ra,0x1
     5ca:	862080e7          	jalr	-1950(ra) # e28 <wait>
     5ce:	beb1                	j	12a <go+0xb2>
        unlink("a");
     5d0:	00001517          	auipc	a0,0x1
     5d4:	ea850513          	addi	a0,a0,-344 # 1478 <malloc+0x228>
     5d8:	00001097          	auipc	ra,0x1
     5dc:	898080e7          	jalr	-1896(ra) # e70 <unlink>
        mkdir("a");
     5e0:	00001517          	auipc	a0,0x1
     5e4:	e9850513          	addi	a0,a0,-360 # 1478 <malloc+0x228>
     5e8:	00001097          	auipc	ra,0x1
     5ec:	8a0080e7          	jalr	-1888(ra) # e88 <mkdir>
        chdir("a");
     5f0:	00001517          	auipc	a0,0x1
     5f4:	e8850513          	addi	a0,a0,-376 # 1478 <malloc+0x228>
     5f8:	00001097          	auipc	ra,0x1
     5fc:	898080e7          	jalr	-1896(ra) # e90 <chdir>
        unlink("../a");
     600:	00001517          	auipc	a0,0x1
     604:	f0850513          	addi	a0,a0,-248 # 1508 <malloc+0x2b8>
     608:	00001097          	auipc	ra,0x1
     60c:	868080e7          	jalr	-1944(ra) # e70 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     610:	20200593          	li	a1,514
     614:	00001517          	auipc	a0,0x1
     618:	eac50513          	addi	a0,a0,-340 # 14c0 <malloc+0x270>
     61c:	00001097          	auipc	ra,0x1
     620:	844080e7          	jalr	-1980(ra) # e60 <open>
        unlink("x");
     624:	00001517          	auipc	a0,0x1
     628:	e9c50513          	addi	a0,a0,-356 # 14c0 <malloc+0x270>
     62c:	00001097          	auipc	ra,0x1
     630:	844080e7          	jalr	-1980(ra) # e70 <unlink>
        exit(0);
     634:	4501                	li	a0,0
     636:	00000097          	auipc	ra,0x0
     63a:	7ea080e7          	jalr	2026(ra) # e20 <exit>
        printf("grind: fork failed\n");
     63e:	00001517          	auipc	a0,0x1
     642:	e2250513          	addi	a0,a0,-478 # 1460 <malloc+0x210>
     646:	00001097          	auipc	ra,0x1
     64a:	b52080e7          	jalr	-1198(ra) # 1198 <printf>
        exit(1);
     64e:	4505                	li	a0,1
     650:	00000097          	auipc	ra,0x0
     654:	7d0080e7          	jalr	2000(ra) # e20 <exit>
    } else if(what == 21){
      unlink("c");
     658:	00001517          	auipc	a0,0x1
     65c:	eb850513          	addi	a0,a0,-328 # 1510 <malloc+0x2c0>
     660:	00001097          	auipc	ra,0x1
     664:	810080e7          	jalr	-2032(ra) # e70 <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     668:	20200593          	li	a1,514
     66c:	00001517          	auipc	a0,0x1
     670:	ea450513          	addi	a0,a0,-348 # 1510 <malloc+0x2c0>
     674:	00000097          	auipc	ra,0x0
     678:	7ec080e7          	jalr	2028(ra) # e60 <open>
     67c:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     67e:	04054f63          	bltz	a0,6dc <go+0x664>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     682:	4605                	li	a2,1
     684:	00001597          	auipc	a1,0x1
     688:	e3c58593          	addi	a1,a1,-452 # 14c0 <malloc+0x270>
     68c:	00000097          	auipc	ra,0x0
     690:	7b4080e7          	jalr	1972(ra) # e40 <write>
     694:	4785                	li	a5,1
     696:	06f51063          	bne	a0,a5,6f6 <go+0x67e>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     69a:	fa840593          	addi	a1,s0,-88
     69e:	855a                	mv	a0,s6
     6a0:	00000097          	auipc	ra,0x0
     6a4:	7d8080e7          	jalr	2008(ra) # e78 <fstat>
     6a8:	e525                	bnez	a0,710 <go+0x698>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     6aa:	fb843583          	ld	a1,-72(s0)
     6ae:	4785                	li	a5,1
     6b0:	06f59d63          	bne	a1,a5,72a <go+0x6b2>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     6b4:	fac42583          	lw	a1,-84(s0)
     6b8:	0c800793          	li	a5,200
     6bc:	08b7e563          	bltu	a5,a1,746 <go+0x6ce>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     6c0:	855a                	mv	a0,s6
     6c2:	00000097          	auipc	ra,0x0
     6c6:	786080e7          	jalr	1926(ra) # e48 <close>
      unlink("c");
     6ca:	00001517          	auipc	a0,0x1
     6ce:	e4650513          	addi	a0,a0,-442 # 1510 <malloc+0x2c0>
     6d2:	00000097          	auipc	ra,0x0
     6d6:	79e080e7          	jalr	1950(ra) # e70 <unlink>
     6da:	bc81                	j	12a <go+0xb2>
        printf("grind: create c failed\n");
     6dc:	00001517          	auipc	a0,0x1
     6e0:	e3c50513          	addi	a0,a0,-452 # 1518 <malloc+0x2c8>
     6e4:	00001097          	auipc	ra,0x1
     6e8:	ab4080e7          	jalr	-1356(ra) # 1198 <printf>
        exit(1);
     6ec:	4505                	li	a0,1
     6ee:	00000097          	auipc	ra,0x0
     6f2:	732080e7          	jalr	1842(ra) # e20 <exit>
        printf("grind: write c failed\n");
     6f6:	00001517          	auipc	a0,0x1
     6fa:	e3a50513          	addi	a0,a0,-454 # 1530 <malloc+0x2e0>
     6fe:	00001097          	auipc	ra,0x1
     702:	a9a080e7          	jalr	-1382(ra) # 1198 <printf>
        exit(1);
     706:	4505                	li	a0,1
     708:	00000097          	auipc	ra,0x0
     70c:	718080e7          	jalr	1816(ra) # e20 <exit>
        printf("grind: fstat failed\n");
     710:	00001517          	auipc	a0,0x1
     714:	e3850513          	addi	a0,a0,-456 # 1548 <malloc+0x2f8>
     718:	00001097          	auipc	ra,0x1
     71c:	a80080e7          	jalr	-1408(ra) # 1198 <printf>
        exit(1);
     720:	4505                	li	a0,1
     722:	00000097          	auipc	ra,0x0
     726:	6fe080e7          	jalr	1790(ra) # e20 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     72a:	2581                	sext.w	a1,a1
     72c:	00001517          	auipc	a0,0x1
     730:	e3450513          	addi	a0,a0,-460 # 1560 <malloc+0x310>
     734:	00001097          	auipc	ra,0x1
     738:	a64080e7          	jalr	-1436(ra) # 1198 <printf>
        exit(1);
     73c:	4505                	li	a0,1
     73e:	00000097          	auipc	ra,0x0
     742:	6e2080e7          	jalr	1762(ra) # e20 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     746:	00001517          	auipc	a0,0x1
     74a:	e4250513          	addi	a0,a0,-446 # 1588 <malloc+0x338>
     74e:	00001097          	auipc	ra,0x1
     752:	a4a080e7          	jalr	-1462(ra) # 1198 <printf>
        exit(1);
     756:	4505                	li	a0,1
     758:	00000097          	auipc	ra,0x0
     75c:	6c8080e7          	jalr	1736(ra) # e20 <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     760:	f9840513          	addi	a0,s0,-104
     764:	00000097          	auipc	ra,0x0
     768:	6cc080e7          	jalr	1740(ra) # e30 <pipe>
     76c:	10054063          	bltz	a0,86c <go+0x7f4>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     770:	fa040513          	addi	a0,s0,-96
     774:	00000097          	auipc	ra,0x0
     778:	6bc080e7          	jalr	1724(ra) # e30 <pipe>
     77c:	10054663          	bltz	a0,888 <go+0x810>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     780:	00000097          	auipc	ra,0x0
     784:	698080e7          	jalr	1688(ra) # e18 <fork>
      if(pid1 == 0){
     788:	10050e63          	beqz	a0,8a4 <go+0x82c>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     78c:	1c054663          	bltz	a0,958 <go+0x8e0>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     790:	00000097          	auipc	ra,0x0
     794:	688080e7          	jalr	1672(ra) # e18 <fork>
      if(pid2 == 0){
     798:	1c050e63          	beqz	a0,974 <go+0x8fc>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     79c:	2a054a63          	bltz	a0,a50 <go+0x9d8>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     7a0:	f9842503          	lw	a0,-104(s0)
     7a4:	00000097          	auipc	ra,0x0
     7a8:	6a4080e7          	jalr	1700(ra) # e48 <close>
      close(aa[1]);
     7ac:	f9c42503          	lw	a0,-100(s0)
     7b0:	00000097          	auipc	ra,0x0
     7b4:	698080e7          	jalr	1688(ra) # e48 <close>
      close(bb[1]);
     7b8:	fa442503          	lw	a0,-92(s0)
     7bc:	00000097          	auipc	ra,0x0
     7c0:	68c080e7          	jalr	1676(ra) # e48 <close>
      char buf[4] = { 0, 0, 0, 0 };
     7c4:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf+0, 1);
     7c8:	4605                	li	a2,1
     7ca:	f9040593          	addi	a1,s0,-112
     7ce:	fa042503          	lw	a0,-96(s0)
     7d2:	00000097          	auipc	ra,0x0
     7d6:	666080e7          	jalr	1638(ra) # e38 <read>
      read(bb[0], buf+1, 1);
     7da:	4605                	li	a2,1
     7dc:	f9140593          	addi	a1,s0,-111
     7e0:	fa042503          	lw	a0,-96(s0)
     7e4:	00000097          	auipc	ra,0x0
     7e8:	654080e7          	jalr	1620(ra) # e38 <read>
      read(bb[0], buf+2, 1);
     7ec:	4605                	li	a2,1
     7ee:	f9240593          	addi	a1,s0,-110
     7f2:	fa042503          	lw	a0,-96(s0)
     7f6:	00000097          	auipc	ra,0x0
     7fa:	642080e7          	jalr	1602(ra) # e38 <read>
      close(bb[0]);
     7fe:	fa042503          	lw	a0,-96(s0)
     802:	00000097          	auipc	ra,0x0
     806:	646080e7          	jalr	1606(ra) # e48 <close>
      int st1, st2;
      wait(&st1);
     80a:	f9440513          	addi	a0,s0,-108
     80e:	00000097          	auipc	ra,0x0
     812:	61a080e7          	jalr	1562(ra) # e28 <wait>
      wait(&st2);
     816:	fa840513          	addi	a0,s0,-88
     81a:	00000097          	auipc	ra,0x0
     81e:	60e080e7          	jalr	1550(ra) # e28 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     822:	f9442783          	lw	a5,-108(s0)
     826:	fa842703          	lw	a4,-88(s0)
     82a:	8fd9                	or	a5,a5,a4
     82c:	ef89                	bnez	a5,846 <go+0x7ce>
     82e:	00001597          	auipc	a1,0x1
     832:	dfa58593          	addi	a1,a1,-518 # 1628 <malloc+0x3d8>
     836:	f9040513          	addi	a0,s0,-112
     83a:	00000097          	auipc	ra,0x0
     83e:	380080e7          	jalr	896(ra) # bba <strcmp>
     842:	8e0504e3          	beqz	a0,12a <go+0xb2>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     846:	f9040693          	addi	a3,s0,-112
     84a:	fa842603          	lw	a2,-88(s0)
     84e:	f9442583          	lw	a1,-108(s0)
     852:	00001517          	auipc	a0,0x1
     856:	dde50513          	addi	a0,a0,-546 # 1630 <malloc+0x3e0>
     85a:	00001097          	auipc	ra,0x1
     85e:	93e080e7          	jalr	-1730(ra) # 1198 <printf>
        exit(1);
     862:	4505                	li	a0,1
     864:	00000097          	auipc	ra,0x0
     868:	5bc080e7          	jalr	1468(ra) # e20 <exit>
        fprintf(2, "grind: pipe failed\n");
     86c:	00001597          	auipc	a1,0x1
     870:	c3c58593          	addi	a1,a1,-964 # 14a8 <malloc+0x258>
     874:	4509                	li	a0,2
     876:	00001097          	auipc	ra,0x1
     87a:	8f4080e7          	jalr	-1804(ra) # 116a <fprintf>
        exit(1);
     87e:	4505                	li	a0,1
     880:	00000097          	auipc	ra,0x0
     884:	5a0080e7          	jalr	1440(ra) # e20 <exit>
        fprintf(2, "grind: pipe failed\n");
     888:	00001597          	auipc	a1,0x1
     88c:	c2058593          	addi	a1,a1,-992 # 14a8 <malloc+0x258>
     890:	4509                	li	a0,2
     892:	00001097          	auipc	ra,0x1
     896:	8d8080e7          	jalr	-1832(ra) # 116a <fprintf>
        exit(1);
     89a:	4505                	li	a0,1
     89c:	00000097          	auipc	ra,0x0
     8a0:	584080e7          	jalr	1412(ra) # e20 <exit>
        close(bb[0]);
     8a4:	fa042503          	lw	a0,-96(s0)
     8a8:	00000097          	auipc	ra,0x0
     8ac:	5a0080e7          	jalr	1440(ra) # e48 <close>
        close(bb[1]);
     8b0:	fa442503          	lw	a0,-92(s0)
     8b4:	00000097          	auipc	ra,0x0
     8b8:	594080e7          	jalr	1428(ra) # e48 <close>
        close(aa[0]);
     8bc:	f9842503          	lw	a0,-104(s0)
     8c0:	00000097          	auipc	ra,0x0
     8c4:	588080e7          	jalr	1416(ra) # e48 <close>
        close(1);
     8c8:	4505                	li	a0,1
     8ca:	00000097          	auipc	ra,0x0
     8ce:	57e080e7          	jalr	1406(ra) # e48 <close>
        if(dup(aa[1]) != 1){
     8d2:	f9c42503          	lw	a0,-100(s0)
     8d6:	00000097          	auipc	ra,0x0
     8da:	5c2080e7          	jalr	1474(ra) # e98 <dup>
     8de:	4785                	li	a5,1
     8e0:	02f50063          	beq	a0,a5,900 <go+0x888>
          fprintf(2, "grind: dup failed\n");
     8e4:	00001597          	auipc	a1,0x1
     8e8:	ccc58593          	addi	a1,a1,-820 # 15b0 <malloc+0x360>
     8ec:	4509                	li	a0,2
     8ee:	00001097          	auipc	ra,0x1
     8f2:	87c080e7          	jalr	-1924(ra) # 116a <fprintf>
          exit(1);
     8f6:	4505                	li	a0,1
     8f8:	00000097          	auipc	ra,0x0
     8fc:	528080e7          	jalr	1320(ra) # e20 <exit>
        close(aa[1]);
     900:	f9c42503          	lw	a0,-100(s0)
     904:	00000097          	auipc	ra,0x0
     908:	544080e7          	jalr	1348(ra) # e48 <close>
        char *args[3] = { "echo", "hi", 0 };
     90c:	00001797          	auipc	a5,0x1
     910:	cbc78793          	addi	a5,a5,-836 # 15c8 <malloc+0x378>
     914:	faf43423          	sd	a5,-88(s0)
     918:	00001797          	auipc	a5,0x1
     91c:	cb878793          	addi	a5,a5,-840 # 15d0 <malloc+0x380>
     920:	faf43823          	sd	a5,-80(s0)
     924:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     928:	fa840593          	addi	a1,s0,-88
     92c:	00001517          	auipc	a0,0x1
     930:	cac50513          	addi	a0,a0,-852 # 15d8 <malloc+0x388>
     934:	00000097          	auipc	ra,0x0
     938:	524080e7          	jalr	1316(ra) # e58 <exec>
        fprintf(2, "grind: echo: not found\n");
     93c:	00001597          	auipc	a1,0x1
     940:	cac58593          	addi	a1,a1,-852 # 15e8 <malloc+0x398>
     944:	4509                	li	a0,2
     946:	00001097          	auipc	ra,0x1
     94a:	824080e7          	jalr	-2012(ra) # 116a <fprintf>
        exit(2);
     94e:	4509                	li	a0,2
     950:	00000097          	auipc	ra,0x0
     954:	4d0080e7          	jalr	1232(ra) # e20 <exit>
        fprintf(2, "grind: fork failed\n");
     958:	00001597          	auipc	a1,0x1
     95c:	b0858593          	addi	a1,a1,-1272 # 1460 <malloc+0x210>
     960:	4509                	li	a0,2
     962:	00001097          	auipc	ra,0x1
     966:	808080e7          	jalr	-2040(ra) # 116a <fprintf>
        exit(3);
     96a:	450d                	li	a0,3
     96c:	00000097          	auipc	ra,0x0
     970:	4b4080e7          	jalr	1204(ra) # e20 <exit>
        close(aa[1]);
     974:	f9c42503          	lw	a0,-100(s0)
     978:	00000097          	auipc	ra,0x0
     97c:	4d0080e7          	jalr	1232(ra) # e48 <close>
        close(bb[0]);
     980:	fa042503          	lw	a0,-96(s0)
     984:	00000097          	auipc	ra,0x0
     988:	4c4080e7          	jalr	1220(ra) # e48 <close>
        close(0);
     98c:	4501                	li	a0,0
     98e:	00000097          	auipc	ra,0x0
     992:	4ba080e7          	jalr	1210(ra) # e48 <close>
        if(dup(aa[0]) != 0){
     996:	f9842503          	lw	a0,-104(s0)
     99a:	00000097          	auipc	ra,0x0
     99e:	4fe080e7          	jalr	1278(ra) # e98 <dup>
     9a2:	cd19                	beqz	a0,9c0 <go+0x948>
          fprintf(2, "grind: dup failed\n");
     9a4:	00001597          	auipc	a1,0x1
     9a8:	c0c58593          	addi	a1,a1,-1012 # 15b0 <malloc+0x360>
     9ac:	4509                	li	a0,2
     9ae:	00000097          	auipc	ra,0x0
     9b2:	7bc080e7          	jalr	1980(ra) # 116a <fprintf>
          exit(4);
     9b6:	4511                	li	a0,4
     9b8:	00000097          	auipc	ra,0x0
     9bc:	468080e7          	jalr	1128(ra) # e20 <exit>
        close(aa[0]);
     9c0:	f9842503          	lw	a0,-104(s0)
     9c4:	00000097          	auipc	ra,0x0
     9c8:	484080e7          	jalr	1156(ra) # e48 <close>
        close(1);
     9cc:	4505                	li	a0,1
     9ce:	00000097          	auipc	ra,0x0
     9d2:	47a080e7          	jalr	1146(ra) # e48 <close>
        if(dup(bb[1]) != 1){
     9d6:	fa442503          	lw	a0,-92(s0)
     9da:	00000097          	auipc	ra,0x0
     9de:	4be080e7          	jalr	1214(ra) # e98 <dup>
     9e2:	4785                	li	a5,1
     9e4:	02f50063          	beq	a0,a5,a04 <go+0x98c>
          fprintf(2, "grind: dup failed\n");
     9e8:	00001597          	auipc	a1,0x1
     9ec:	bc858593          	addi	a1,a1,-1080 # 15b0 <malloc+0x360>
     9f0:	4509                	li	a0,2
     9f2:	00000097          	auipc	ra,0x0
     9f6:	778080e7          	jalr	1912(ra) # 116a <fprintf>
          exit(5);
     9fa:	4515                	li	a0,5
     9fc:	00000097          	auipc	ra,0x0
     a00:	424080e7          	jalr	1060(ra) # e20 <exit>
        close(bb[1]);
     a04:	fa442503          	lw	a0,-92(s0)
     a08:	00000097          	auipc	ra,0x0
     a0c:	440080e7          	jalr	1088(ra) # e48 <close>
        char *args[2] = { "cat", 0 };
     a10:	00001797          	auipc	a5,0x1
     a14:	bf078793          	addi	a5,a5,-1040 # 1600 <malloc+0x3b0>
     a18:	faf43423          	sd	a5,-88(s0)
     a1c:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     a20:	fa840593          	addi	a1,s0,-88
     a24:	00001517          	auipc	a0,0x1
     a28:	be450513          	addi	a0,a0,-1052 # 1608 <malloc+0x3b8>
     a2c:	00000097          	auipc	ra,0x0
     a30:	42c080e7          	jalr	1068(ra) # e58 <exec>
        fprintf(2, "grind: cat: not found\n");
     a34:	00001597          	auipc	a1,0x1
     a38:	bdc58593          	addi	a1,a1,-1060 # 1610 <malloc+0x3c0>
     a3c:	4509                	li	a0,2
     a3e:	00000097          	auipc	ra,0x0
     a42:	72c080e7          	jalr	1836(ra) # 116a <fprintf>
        exit(6);
     a46:	4519                	li	a0,6
     a48:	00000097          	auipc	ra,0x0
     a4c:	3d8080e7          	jalr	984(ra) # e20 <exit>
        fprintf(2, "grind: fork failed\n");
     a50:	00001597          	auipc	a1,0x1
     a54:	a1058593          	addi	a1,a1,-1520 # 1460 <malloc+0x210>
     a58:	4509                	li	a0,2
     a5a:	00000097          	auipc	ra,0x0
     a5e:	710080e7          	jalr	1808(ra) # 116a <fprintf>
        exit(7);
     a62:	451d                	li	a0,7
     a64:	00000097          	auipc	ra,0x0
     a68:	3bc080e7          	jalr	956(ra) # e20 <exit>

0000000000000a6c <iter>:
  }
}

void
iter()
{
     a6c:	7179                	addi	sp,sp,-48
     a6e:	f406                	sd	ra,40(sp)
     a70:	f022                	sd	s0,32(sp)
     a72:	1800                	addi	s0,sp,48
  unlink("a");
     a74:	00001517          	auipc	a0,0x1
     a78:	a0450513          	addi	a0,a0,-1532 # 1478 <malloc+0x228>
     a7c:	00000097          	auipc	ra,0x0
     a80:	3f4080e7          	jalr	1012(ra) # e70 <unlink>
  unlink("b");
     a84:	00001517          	auipc	a0,0x1
     a88:	9a450513          	addi	a0,a0,-1628 # 1428 <malloc+0x1d8>
     a8c:	00000097          	auipc	ra,0x0
     a90:	3e4080e7          	jalr	996(ra) # e70 <unlink>
  
  int pid1 = fork();
     a94:	00000097          	auipc	ra,0x0
     a98:	384080e7          	jalr	900(ra) # e18 <fork>
  if(pid1 < 0){
     a9c:	02054063          	bltz	a0,abc <iter+0x50>
     aa0:	ec26                	sd	s1,24(sp)
     aa2:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     aa4:	e91d                	bnez	a0,ada <iter+0x6e>
     aa6:	e84a                	sd	s2,16(sp)
    rand_next = 31;
     aa8:	47fd                	li	a5,31
     aaa:	00001717          	auipc	a4,0x1
     aae:	10f73b23          	sd	a5,278(a4) # 1bc0 <rand_next>
    go(0);
     ab2:	4501                	li	a0,0
     ab4:	fffff097          	auipc	ra,0xfffff
     ab8:	5c4080e7          	jalr	1476(ra) # 78 <go>
     abc:	ec26                	sd	s1,24(sp)
     abe:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     ac0:	00001517          	auipc	a0,0x1
     ac4:	9a050513          	addi	a0,a0,-1632 # 1460 <malloc+0x210>
     ac8:	00000097          	auipc	ra,0x0
     acc:	6d0080e7          	jalr	1744(ra) # 1198 <printf>
    exit(1);
     ad0:	4505                	li	a0,1
     ad2:	00000097          	auipc	ra,0x0
     ad6:	34e080e7          	jalr	846(ra) # e20 <exit>
     ada:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     adc:	00000097          	auipc	ra,0x0
     ae0:	33c080e7          	jalr	828(ra) # e18 <fork>
     ae4:	892a                	mv	s2,a0
  if(pid2 < 0){
     ae6:	00054f63          	bltz	a0,b04 <iter+0x98>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     aea:	e915                	bnez	a0,b1e <iter+0xb2>
    rand_next = 7177;
     aec:	6789                	lui	a5,0x2
     aee:	c0978793          	addi	a5,a5,-1015 # 1c09 <buf.0+0x39>
     af2:	00001717          	auipc	a4,0x1
     af6:	0cf73723          	sd	a5,206(a4) # 1bc0 <rand_next>
    go(1);
     afa:	4505                	li	a0,1
     afc:	fffff097          	auipc	ra,0xfffff
     b00:	57c080e7          	jalr	1404(ra) # 78 <go>
    printf("grind: fork failed\n");
     b04:	00001517          	auipc	a0,0x1
     b08:	95c50513          	addi	a0,a0,-1700 # 1460 <malloc+0x210>
     b0c:	00000097          	auipc	ra,0x0
     b10:	68c080e7          	jalr	1676(ra) # 1198 <printf>
    exit(1);
     b14:	4505                	li	a0,1
     b16:	00000097          	auipc	ra,0x0
     b1a:	30a080e7          	jalr	778(ra) # e20 <exit>
    exit(0);
  }

  int st1 = -1;
     b1e:	57fd                	li	a5,-1
     b20:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b24:	fdc40513          	addi	a0,s0,-36
     b28:	00000097          	auipc	ra,0x0
     b2c:	300080e7          	jalr	768(ra) # e28 <wait>
  if(st1 != 0){
     b30:	fdc42783          	lw	a5,-36(s0)
     b34:	ef99                	bnez	a5,b52 <iter+0xe6>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     b36:	57fd                	li	a5,-1
     b38:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     b3c:	fd840513          	addi	a0,s0,-40
     b40:	00000097          	auipc	ra,0x0
     b44:	2e8080e7          	jalr	744(ra) # e28 <wait>

  exit(0);
     b48:	4501                	li	a0,0
     b4a:	00000097          	auipc	ra,0x0
     b4e:	2d6080e7          	jalr	726(ra) # e20 <exit>
    kill(pid1);
     b52:	8526                	mv	a0,s1
     b54:	00000097          	auipc	ra,0x0
     b58:	2fc080e7          	jalr	764(ra) # e50 <kill>
    kill(pid2);
     b5c:	854a                	mv	a0,s2
     b5e:	00000097          	auipc	ra,0x0
     b62:	2f2080e7          	jalr	754(ra) # e50 <kill>
     b66:	bfc1                	j	b36 <iter+0xca>

0000000000000b68 <main>:
}

int
main()
{
     b68:	1141                	addi	sp,sp,-16
     b6a:	e406                	sd	ra,8(sp)
     b6c:	e022                	sd	s0,0(sp)
     b6e:	0800                	addi	s0,sp,16
     b70:	a811                	j	b84 <main+0x1c>
  while(1){
    int pid = fork();
    if(pid == 0){
      iter();
     b72:	00000097          	auipc	ra,0x0
     b76:	efa080e7          	jalr	-262(ra) # a6c <iter>
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
     b7a:	4551                	li	a0,20
     b7c:	00000097          	auipc	ra,0x0
     b80:	334080e7          	jalr	820(ra) # eb0 <sleep>
    int pid = fork();
     b84:	00000097          	auipc	ra,0x0
     b88:	294080e7          	jalr	660(ra) # e18 <fork>
    if(pid == 0){
     b8c:	d17d                	beqz	a0,b72 <main+0xa>
    if(pid > 0){
     b8e:	fea056e3          	blez	a0,b7a <main+0x12>
      wait(0);
     b92:	4501                	li	a0,0
     b94:	00000097          	auipc	ra,0x0
     b98:	294080e7          	jalr	660(ra) # e28 <wait>
     b9c:	bff9                	j	b7a <main+0x12>

0000000000000b9e <strcpy>:



char*
strcpy(char *s, const char *t)
{
     b9e:	1141                	addi	sp,sp,-16
     ba0:	e422                	sd	s0,8(sp)
     ba2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     ba4:	87aa                	mv	a5,a0
     ba6:	0585                	addi	a1,a1,1
     ba8:	0785                	addi	a5,a5,1
     baa:	fff5c703          	lbu	a4,-1(a1)
     bae:	fee78fa3          	sb	a4,-1(a5)
     bb2:	fb75                	bnez	a4,ba6 <strcpy+0x8>
    ;
  return os;
}
     bb4:	6422                	ld	s0,8(sp)
     bb6:	0141                	addi	sp,sp,16
     bb8:	8082                	ret

0000000000000bba <strcmp>:

int
strcmp(const char *p, const char *q)
{
     bba:	1141                	addi	sp,sp,-16
     bbc:	e422                	sd	s0,8(sp)
     bbe:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     bc0:	00054783          	lbu	a5,0(a0)
     bc4:	cb91                	beqz	a5,bd8 <strcmp+0x1e>
     bc6:	0005c703          	lbu	a4,0(a1)
     bca:	00f71763          	bne	a4,a5,bd8 <strcmp+0x1e>
    p++, q++;
     bce:	0505                	addi	a0,a0,1
     bd0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     bd2:	00054783          	lbu	a5,0(a0)
     bd6:	fbe5                	bnez	a5,bc6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     bd8:	0005c503          	lbu	a0,0(a1)
}
     bdc:	40a7853b          	subw	a0,a5,a0
     be0:	6422                	ld	s0,8(sp)
     be2:	0141                	addi	sp,sp,16
     be4:	8082                	ret

0000000000000be6 <strlen>:

uint
strlen(const char *s)
{
     be6:	1141                	addi	sp,sp,-16
     be8:	e422                	sd	s0,8(sp)
     bea:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     bec:	00054783          	lbu	a5,0(a0)
     bf0:	cf91                	beqz	a5,c0c <strlen+0x26>
     bf2:	0505                	addi	a0,a0,1
     bf4:	87aa                	mv	a5,a0
     bf6:	86be                	mv	a3,a5
     bf8:	0785                	addi	a5,a5,1
     bfa:	fff7c703          	lbu	a4,-1(a5)
     bfe:	ff65                	bnez	a4,bf6 <strlen+0x10>
     c00:	40a6853b          	subw	a0,a3,a0
     c04:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     c06:	6422                	ld	s0,8(sp)
     c08:	0141                	addi	sp,sp,16
     c0a:	8082                	ret
  for(n = 0; s[n]; n++)
     c0c:	4501                	li	a0,0
     c0e:	bfe5                	j	c06 <strlen+0x20>

0000000000000c10 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c10:	1141                	addi	sp,sp,-16
     c12:	e422                	sd	s0,8(sp)
     c14:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c16:	ca19                	beqz	a2,c2c <memset+0x1c>
     c18:	87aa                	mv	a5,a0
     c1a:	1602                	slli	a2,a2,0x20
     c1c:	9201                	srli	a2,a2,0x20
     c1e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c22:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c26:	0785                	addi	a5,a5,1
     c28:	fee79de3          	bne	a5,a4,c22 <memset+0x12>
  }
  return dst;
}
     c2c:	6422                	ld	s0,8(sp)
     c2e:	0141                	addi	sp,sp,16
     c30:	8082                	ret

0000000000000c32 <strchr>:

char*
strchr(const char *s, char c)
{
     c32:	1141                	addi	sp,sp,-16
     c34:	e422                	sd	s0,8(sp)
     c36:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c38:	00054783          	lbu	a5,0(a0)
     c3c:	cb99                	beqz	a5,c52 <strchr+0x20>
    if(*s == c)
     c3e:	00f58763          	beq	a1,a5,c4c <strchr+0x1a>
  for(; *s; s++)
     c42:	0505                	addi	a0,a0,1
     c44:	00054783          	lbu	a5,0(a0)
     c48:	fbfd                	bnez	a5,c3e <strchr+0xc>
      return (char*)s;
  return 0;
     c4a:	4501                	li	a0,0
}
     c4c:	6422                	ld	s0,8(sp)
     c4e:	0141                	addi	sp,sp,16
     c50:	8082                	ret
  return 0;
     c52:	4501                	li	a0,0
     c54:	bfe5                	j	c4c <strchr+0x1a>

0000000000000c56 <gets>:

char*
gets(char *buf, int max)
{
     c56:	711d                	addi	sp,sp,-96
     c58:	ec86                	sd	ra,88(sp)
     c5a:	e8a2                	sd	s0,80(sp)
     c5c:	e4a6                	sd	s1,72(sp)
     c5e:	e0ca                	sd	s2,64(sp)
     c60:	fc4e                	sd	s3,56(sp)
     c62:	f852                	sd	s4,48(sp)
     c64:	f456                	sd	s5,40(sp)
     c66:	f05a                	sd	s6,32(sp)
     c68:	ec5e                	sd	s7,24(sp)
     c6a:	1080                	addi	s0,sp,96
     c6c:	8baa                	mv	s7,a0
     c6e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c70:	892a                	mv	s2,a0
     c72:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c74:	4aa9                	li	s5,10
     c76:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c78:	89a6                	mv	s3,s1
     c7a:	2485                	addiw	s1,s1,1
     c7c:	0344d863          	bge	s1,s4,cac <gets+0x56>
    cc = read(0, &c, 1);
     c80:	4605                	li	a2,1
     c82:	faf40593          	addi	a1,s0,-81
     c86:	4501                	li	a0,0
     c88:	00000097          	auipc	ra,0x0
     c8c:	1b0080e7          	jalr	432(ra) # e38 <read>
    if(cc < 1)
     c90:	00a05e63          	blez	a0,cac <gets+0x56>
    buf[i++] = c;
     c94:	faf44783          	lbu	a5,-81(s0)
     c98:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c9c:	01578763          	beq	a5,s5,caa <gets+0x54>
     ca0:	0905                	addi	s2,s2,1
     ca2:	fd679be3          	bne	a5,s6,c78 <gets+0x22>
    buf[i++] = c;
     ca6:	89a6                	mv	s3,s1
     ca8:	a011                	j	cac <gets+0x56>
     caa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     cac:	99de                	add	s3,s3,s7
     cae:	00098023          	sb	zero,0(s3)
  return buf;
}
     cb2:	855e                	mv	a0,s7
     cb4:	60e6                	ld	ra,88(sp)
     cb6:	6446                	ld	s0,80(sp)
     cb8:	64a6                	ld	s1,72(sp)
     cba:	6906                	ld	s2,64(sp)
     cbc:	79e2                	ld	s3,56(sp)
     cbe:	7a42                	ld	s4,48(sp)
     cc0:	7aa2                	ld	s5,40(sp)
     cc2:	7b02                	ld	s6,32(sp)
     cc4:	6be2                	ld	s7,24(sp)
     cc6:	6125                	addi	sp,sp,96
     cc8:	8082                	ret

0000000000000cca <stat>:

int
stat(const char *n, struct stat *st)
{
     cca:	1101                	addi	sp,sp,-32
     ccc:	ec06                	sd	ra,24(sp)
     cce:	e822                	sd	s0,16(sp)
     cd0:	e04a                	sd	s2,0(sp)
     cd2:	1000                	addi	s0,sp,32
     cd4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     cd6:	4581                	li	a1,0
     cd8:	00000097          	auipc	ra,0x0
     cdc:	188080e7          	jalr	392(ra) # e60 <open>
  if(fd < 0)
     ce0:	02054663          	bltz	a0,d0c <stat+0x42>
     ce4:	e426                	sd	s1,8(sp)
     ce6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     ce8:	85ca                	mv	a1,s2
     cea:	00000097          	auipc	ra,0x0
     cee:	18e080e7          	jalr	398(ra) # e78 <fstat>
     cf2:	892a                	mv	s2,a0
  close(fd);
     cf4:	8526                	mv	a0,s1
     cf6:	00000097          	auipc	ra,0x0
     cfa:	152080e7          	jalr	338(ra) # e48 <close>
  return r;
     cfe:	64a2                	ld	s1,8(sp)
}
     d00:	854a                	mv	a0,s2
     d02:	60e2                	ld	ra,24(sp)
     d04:	6442                	ld	s0,16(sp)
     d06:	6902                	ld	s2,0(sp)
     d08:	6105                	addi	sp,sp,32
     d0a:	8082                	ret
    return -1;
     d0c:	597d                	li	s2,-1
     d0e:	bfcd                	j	d00 <stat+0x36>

0000000000000d10 <atoi>:

int
atoi(const char *s)
{
     d10:	1141                	addi	sp,sp,-16
     d12:	e422                	sd	s0,8(sp)
     d14:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d16:	00054683          	lbu	a3,0(a0)
     d1a:	fd06879b          	addiw	a5,a3,-48
     d1e:	0ff7f793          	zext.b	a5,a5
     d22:	4625                	li	a2,9
     d24:	02f66863          	bltu	a2,a5,d54 <atoi+0x44>
     d28:	872a                	mv	a4,a0
  n = 0;
     d2a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     d2c:	0705                	addi	a4,a4,1
     d2e:	0025179b          	slliw	a5,a0,0x2
     d32:	9fa9                	addw	a5,a5,a0
     d34:	0017979b          	slliw	a5,a5,0x1
     d38:	9fb5                	addw	a5,a5,a3
     d3a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d3e:	00074683          	lbu	a3,0(a4)
     d42:	fd06879b          	addiw	a5,a3,-48
     d46:	0ff7f793          	zext.b	a5,a5
     d4a:	fef671e3          	bgeu	a2,a5,d2c <atoi+0x1c>
  return n;
}
     d4e:	6422                	ld	s0,8(sp)
     d50:	0141                	addi	sp,sp,16
     d52:	8082                	ret
  n = 0;
     d54:	4501                	li	a0,0
     d56:	bfe5                	j	d4e <atoi+0x3e>

0000000000000d58 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d58:	1141                	addi	sp,sp,-16
     d5a:	e422                	sd	s0,8(sp)
     d5c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d5e:	02b57463          	bgeu	a0,a1,d86 <memmove+0x2e>
    while(n-- > 0)
     d62:	00c05f63          	blez	a2,d80 <memmove+0x28>
     d66:	1602                	slli	a2,a2,0x20
     d68:	9201                	srli	a2,a2,0x20
     d6a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d6e:	872a                	mv	a4,a0
      *dst++ = *src++;
     d70:	0585                	addi	a1,a1,1
     d72:	0705                	addi	a4,a4,1
     d74:	fff5c683          	lbu	a3,-1(a1)
     d78:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d7c:	fef71ae3          	bne	a4,a5,d70 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d80:	6422                	ld	s0,8(sp)
     d82:	0141                	addi	sp,sp,16
     d84:	8082                	ret
    dst += n;
     d86:	00c50733          	add	a4,a0,a2
    src += n;
     d8a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     d8c:	fec05ae3          	blez	a2,d80 <memmove+0x28>
     d90:	fff6079b          	addiw	a5,a2,-1
     d94:	1782                	slli	a5,a5,0x20
     d96:	9381                	srli	a5,a5,0x20
     d98:	fff7c793          	not	a5,a5
     d9c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     d9e:	15fd                	addi	a1,a1,-1
     da0:	177d                	addi	a4,a4,-1
     da2:	0005c683          	lbu	a3,0(a1)
     da6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     daa:	fee79ae3          	bne	a5,a4,d9e <memmove+0x46>
     dae:	bfc9                	j	d80 <memmove+0x28>

0000000000000db0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     db0:	1141                	addi	sp,sp,-16
     db2:	e422                	sd	s0,8(sp)
     db4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     db6:	ca05                	beqz	a2,de6 <memcmp+0x36>
     db8:	fff6069b          	addiw	a3,a2,-1
     dbc:	1682                	slli	a3,a3,0x20
     dbe:	9281                	srli	a3,a3,0x20
     dc0:	0685                	addi	a3,a3,1
     dc2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     dc4:	00054783          	lbu	a5,0(a0)
     dc8:	0005c703          	lbu	a4,0(a1)
     dcc:	00e79863          	bne	a5,a4,ddc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     dd0:	0505                	addi	a0,a0,1
    p2++;
     dd2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     dd4:	fed518e3          	bne	a0,a3,dc4 <memcmp+0x14>
  }
  return 0;
     dd8:	4501                	li	a0,0
     dda:	a019                	j	de0 <memcmp+0x30>
      return *p1 - *p2;
     ddc:	40e7853b          	subw	a0,a5,a4
}
     de0:	6422                	ld	s0,8(sp)
     de2:	0141                	addi	sp,sp,16
     de4:	8082                	ret
  return 0;
     de6:	4501                	li	a0,0
     de8:	bfe5                	j	de0 <memcmp+0x30>

0000000000000dea <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     dea:	1141                	addi	sp,sp,-16
     dec:	e406                	sd	ra,8(sp)
     dee:	e022                	sd	s0,0(sp)
     df0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     df2:	00000097          	auipc	ra,0x0
     df6:	f66080e7          	jalr	-154(ra) # d58 <memmove>
}
     dfa:	60a2                	ld	ra,8(sp)
     dfc:	6402                	ld	s0,0(sp)
     dfe:	0141                	addi	sp,sp,16
     e00:	8082                	ret

0000000000000e02 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
     e02:	1141                	addi	sp,sp,-16
     e04:	e422                	sd	s0,8(sp)
     e06:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
     e08:	040007b7          	lui	a5,0x4000
     e0c:	17f5                	addi	a5,a5,-3 # 3fffffd <__global_pointer$+0x3ffdc41>
     e0e:	07b2                	slli	a5,a5,0xc
}
     e10:	4388                	lw	a0,0(a5)
     e12:	6422                	ld	s0,8(sp)
     e14:	0141                	addi	sp,sp,16
     e16:	8082                	ret

0000000000000e18 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e18:	4885                	li	a7,1
 ecall
     e1a:	00000073          	ecall
 ret
     e1e:	8082                	ret

0000000000000e20 <exit>:
.global exit
exit:
 li a7, SYS_exit
     e20:	4889                	li	a7,2
 ecall
     e22:	00000073          	ecall
 ret
     e26:	8082                	ret

0000000000000e28 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e28:	488d                	li	a7,3
 ecall
     e2a:	00000073          	ecall
 ret
     e2e:	8082                	ret

0000000000000e30 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e30:	4891                	li	a7,4
 ecall
     e32:	00000073          	ecall
 ret
     e36:	8082                	ret

0000000000000e38 <read>:
.global read
read:
 li a7, SYS_read
     e38:	4895                	li	a7,5
 ecall
     e3a:	00000073          	ecall
 ret
     e3e:	8082                	ret

0000000000000e40 <write>:
.global write
write:
 li a7, SYS_write
     e40:	48c1                	li	a7,16
 ecall
     e42:	00000073          	ecall
 ret
     e46:	8082                	ret

0000000000000e48 <close>:
.global close
close:
 li a7, SYS_close
     e48:	48d5                	li	a7,21
 ecall
     e4a:	00000073          	ecall
 ret
     e4e:	8082                	ret

0000000000000e50 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e50:	4899                	li	a7,6
 ecall
     e52:	00000073          	ecall
 ret
     e56:	8082                	ret

0000000000000e58 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e58:	489d                	li	a7,7
 ecall
     e5a:	00000073          	ecall
 ret
     e5e:	8082                	ret

0000000000000e60 <open>:
.global open
open:
 li a7, SYS_open
     e60:	48bd                	li	a7,15
 ecall
     e62:	00000073          	ecall
 ret
     e66:	8082                	ret

0000000000000e68 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e68:	48c5                	li	a7,17
 ecall
     e6a:	00000073          	ecall
 ret
     e6e:	8082                	ret

0000000000000e70 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e70:	48c9                	li	a7,18
 ecall
     e72:	00000073          	ecall
 ret
     e76:	8082                	ret

0000000000000e78 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e78:	48a1                	li	a7,8
 ecall
     e7a:	00000073          	ecall
 ret
     e7e:	8082                	ret

0000000000000e80 <link>:
.global link
link:
 li a7, SYS_link
     e80:	48cd                	li	a7,19
 ecall
     e82:	00000073          	ecall
 ret
     e86:	8082                	ret

0000000000000e88 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e88:	48d1                	li	a7,20
 ecall
     e8a:	00000073          	ecall
 ret
     e8e:	8082                	ret

0000000000000e90 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e90:	48a5                	li	a7,9
 ecall
     e92:	00000073          	ecall
 ret
     e96:	8082                	ret

0000000000000e98 <dup>:
.global dup
dup:
 li a7, SYS_dup
     e98:	48a9                	li	a7,10
 ecall
     e9a:	00000073          	ecall
 ret
     e9e:	8082                	ret

0000000000000ea0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     ea0:	48ad                	li	a7,11
 ecall
     ea2:	00000073          	ecall
 ret
     ea6:	8082                	ret

0000000000000ea8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     ea8:	48b1                	li	a7,12
 ecall
     eaa:	00000073          	ecall
 ret
     eae:	8082                	ret

0000000000000eb0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     eb0:	48b5                	li	a7,13
 ecall
     eb2:	00000073          	ecall
 ret
     eb6:	8082                	ret

0000000000000eb8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     eb8:	48b9                	li	a7,14
 ecall
     eba:	00000073          	ecall
 ret
     ebe:	8082                	ret

0000000000000ec0 <connect>:
.global connect
connect:
 li a7, SYS_connect
     ec0:	48f5                	li	a7,29
 ecall
     ec2:	00000073          	ecall
 ret
     ec6:	8082                	ret

0000000000000ec8 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
     ec8:	48f9                	li	a7,30
 ecall
     eca:	00000073          	ecall
 ret
     ece:	8082                	ret

0000000000000ed0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ed0:	1101                	addi	sp,sp,-32
     ed2:	ec06                	sd	ra,24(sp)
     ed4:	e822                	sd	s0,16(sp)
     ed6:	1000                	addi	s0,sp,32
     ed8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     edc:	4605                	li	a2,1
     ede:	fef40593          	addi	a1,s0,-17
     ee2:	00000097          	auipc	ra,0x0
     ee6:	f5e080e7          	jalr	-162(ra) # e40 <write>
}
     eea:	60e2                	ld	ra,24(sp)
     eec:	6442                	ld	s0,16(sp)
     eee:	6105                	addi	sp,sp,32
     ef0:	8082                	ret

0000000000000ef2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ef2:	7139                	addi	sp,sp,-64
     ef4:	fc06                	sd	ra,56(sp)
     ef6:	f822                	sd	s0,48(sp)
     ef8:	f426                	sd	s1,40(sp)
     efa:	0080                	addi	s0,sp,64
     efc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     efe:	c299                	beqz	a3,f04 <printint+0x12>
     f00:	0805cb63          	bltz	a1,f96 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f04:	2581                	sext.w	a1,a1
  neg = 0;
     f06:	4881                	li	a7,0
     f08:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     f0c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     f0e:	2601                	sext.w	a2,a2
     f10:	00001517          	auipc	a0,0x1
     f14:	80850513          	addi	a0,a0,-2040 # 1718 <digits>
     f18:	883a                	mv	a6,a4
     f1a:	2705                	addiw	a4,a4,1
     f1c:	02c5f7bb          	remuw	a5,a1,a2
     f20:	1782                	slli	a5,a5,0x20
     f22:	9381                	srli	a5,a5,0x20
     f24:	97aa                	add	a5,a5,a0
     f26:	0007c783          	lbu	a5,0(a5)
     f2a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f2e:	0005879b          	sext.w	a5,a1
     f32:	02c5d5bb          	divuw	a1,a1,a2
     f36:	0685                	addi	a3,a3,1
     f38:	fec7f0e3          	bgeu	a5,a2,f18 <printint+0x26>
  if(neg)
     f3c:	00088c63          	beqz	a7,f54 <printint+0x62>
    buf[i++] = '-';
     f40:	fd070793          	addi	a5,a4,-48
     f44:	00878733          	add	a4,a5,s0
     f48:	02d00793          	li	a5,45
     f4c:	fef70823          	sb	a5,-16(a4)
     f50:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     f54:	02e05c63          	blez	a4,f8c <printint+0x9a>
     f58:	f04a                	sd	s2,32(sp)
     f5a:	ec4e                	sd	s3,24(sp)
     f5c:	fc040793          	addi	a5,s0,-64
     f60:	00e78933          	add	s2,a5,a4
     f64:	fff78993          	addi	s3,a5,-1
     f68:	99ba                	add	s3,s3,a4
     f6a:	377d                	addiw	a4,a4,-1
     f6c:	1702                	slli	a4,a4,0x20
     f6e:	9301                	srli	a4,a4,0x20
     f70:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f74:	fff94583          	lbu	a1,-1(s2)
     f78:	8526                	mv	a0,s1
     f7a:	00000097          	auipc	ra,0x0
     f7e:	f56080e7          	jalr	-170(ra) # ed0 <putc>
  while(--i >= 0)
     f82:	197d                	addi	s2,s2,-1
     f84:	ff3918e3          	bne	s2,s3,f74 <printint+0x82>
     f88:	7902                	ld	s2,32(sp)
     f8a:	69e2                	ld	s3,24(sp)
}
     f8c:	70e2                	ld	ra,56(sp)
     f8e:	7442                	ld	s0,48(sp)
     f90:	74a2                	ld	s1,40(sp)
     f92:	6121                	addi	sp,sp,64
     f94:	8082                	ret
    x = -xx;
     f96:	40b005bb          	negw	a1,a1
    neg = 1;
     f9a:	4885                	li	a7,1
    x = -xx;
     f9c:	b7b5                	j	f08 <printint+0x16>

0000000000000f9e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f9e:	715d                	addi	sp,sp,-80
     fa0:	e486                	sd	ra,72(sp)
     fa2:	e0a2                	sd	s0,64(sp)
     fa4:	f84a                	sd	s2,48(sp)
     fa6:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     fa8:	0005c903          	lbu	s2,0(a1)
     fac:	1a090a63          	beqz	s2,1160 <vprintf+0x1c2>
     fb0:	fc26                	sd	s1,56(sp)
     fb2:	f44e                	sd	s3,40(sp)
     fb4:	f052                	sd	s4,32(sp)
     fb6:	ec56                	sd	s5,24(sp)
     fb8:	e85a                	sd	s6,16(sp)
     fba:	e45e                	sd	s7,8(sp)
     fbc:	8aaa                	mv	s5,a0
     fbe:	8bb2                	mv	s7,a2
     fc0:	00158493          	addi	s1,a1,1
  state = 0;
     fc4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     fc6:	02500a13          	li	s4,37
     fca:	4b55                	li	s6,21
     fcc:	a839                	j	fea <vprintf+0x4c>
        putc(fd, c);
     fce:	85ca                	mv	a1,s2
     fd0:	8556                	mv	a0,s5
     fd2:	00000097          	auipc	ra,0x0
     fd6:	efe080e7          	jalr	-258(ra) # ed0 <putc>
     fda:	a019                	j	fe0 <vprintf+0x42>
    } else if(state == '%'){
     fdc:	01498d63          	beq	s3,s4,ff6 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     fe0:	0485                	addi	s1,s1,1
     fe2:	fff4c903          	lbu	s2,-1(s1)
     fe6:	16090763          	beqz	s2,1154 <vprintf+0x1b6>
    if(state == 0){
     fea:	fe0999e3          	bnez	s3,fdc <vprintf+0x3e>
      if(c == '%'){
     fee:	ff4910e3          	bne	s2,s4,fce <vprintf+0x30>
        state = '%';
     ff2:	89d2                	mv	s3,s4
     ff4:	b7f5                	j	fe0 <vprintf+0x42>
      if(c == 'd'){
     ff6:	13490463          	beq	s2,s4,111e <vprintf+0x180>
     ffa:	f9d9079b          	addiw	a5,s2,-99
     ffe:	0ff7f793          	zext.b	a5,a5
    1002:	12fb6763          	bltu	s6,a5,1130 <vprintf+0x192>
    1006:	f9d9079b          	addiw	a5,s2,-99
    100a:	0ff7f713          	zext.b	a4,a5
    100e:	12eb6163          	bltu	s6,a4,1130 <vprintf+0x192>
    1012:	00271793          	slli	a5,a4,0x2
    1016:	00000717          	auipc	a4,0x0
    101a:	6aa70713          	addi	a4,a4,1706 # 16c0 <malloc+0x470>
    101e:	97ba                	add	a5,a5,a4
    1020:	439c                	lw	a5,0(a5)
    1022:	97ba                	add	a5,a5,a4
    1024:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    1026:	008b8913          	addi	s2,s7,8
    102a:	4685                	li	a3,1
    102c:	4629                	li	a2,10
    102e:	000ba583          	lw	a1,0(s7)
    1032:	8556                	mv	a0,s5
    1034:	00000097          	auipc	ra,0x0
    1038:	ebe080e7          	jalr	-322(ra) # ef2 <printint>
    103c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    103e:	4981                	li	s3,0
    1040:	b745                	j	fe0 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1042:	008b8913          	addi	s2,s7,8
    1046:	4681                	li	a3,0
    1048:	4629                	li	a2,10
    104a:	000ba583          	lw	a1,0(s7)
    104e:	8556                	mv	a0,s5
    1050:	00000097          	auipc	ra,0x0
    1054:	ea2080e7          	jalr	-350(ra) # ef2 <printint>
    1058:	8bca                	mv	s7,s2
      state = 0;
    105a:	4981                	li	s3,0
    105c:	b751                	j	fe0 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    105e:	008b8913          	addi	s2,s7,8
    1062:	4681                	li	a3,0
    1064:	4641                	li	a2,16
    1066:	000ba583          	lw	a1,0(s7)
    106a:	8556                	mv	a0,s5
    106c:	00000097          	auipc	ra,0x0
    1070:	e86080e7          	jalr	-378(ra) # ef2 <printint>
    1074:	8bca                	mv	s7,s2
      state = 0;
    1076:	4981                	li	s3,0
    1078:	b7a5                	j	fe0 <vprintf+0x42>
    107a:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    107c:	008b8c13          	addi	s8,s7,8
    1080:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1084:	03000593          	li	a1,48
    1088:	8556                	mv	a0,s5
    108a:	00000097          	auipc	ra,0x0
    108e:	e46080e7          	jalr	-442(ra) # ed0 <putc>
  putc(fd, 'x');
    1092:	07800593          	li	a1,120
    1096:	8556                	mv	a0,s5
    1098:	00000097          	auipc	ra,0x0
    109c:	e38080e7          	jalr	-456(ra) # ed0 <putc>
    10a0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    10a2:	00000b97          	auipc	s7,0x0
    10a6:	676b8b93          	addi	s7,s7,1654 # 1718 <digits>
    10aa:	03c9d793          	srli	a5,s3,0x3c
    10ae:	97de                	add	a5,a5,s7
    10b0:	0007c583          	lbu	a1,0(a5)
    10b4:	8556                	mv	a0,s5
    10b6:	00000097          	auipc	ra,0x0
    10ba:	e1a080e7          	jalr	-486(ra) # ed0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    10be:	0992                	slli	s3,s3,0x4
    10c0:	397d                	addiw	s2,s2,-1
    10c2:	fe0914e3          	bnez	s2,10aa <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    10c6:	8be2                	mv	s7,s8
      state = 0;
    10c8:	4981                	li	s3,0
    10ca:	6c02                	ld	s8,0(sp)
    10cc:	bf11                	j	fe0 <vprintf+0x42>
        s = va_arg(ap, char*);
    10ce:	008b8993          	addi	s3,s7,8
    10d2:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    10d6:	02090163          	beqz	s2,10f8 <vprintf+0x15a>
        while(*s != 0){
    10da:	00094583          	lbu	a1,0(s2)
    10de:	c9a5                	beqz	a1,114e <vprintf+0x1b0>
          putc(fd, *s);
    10e0:	8556                	mv	a0,s5
    10e2:	00000097          	auipc	ra,0x0
    10e6:	dee080e7          	jalr	-530(ra) # ed0 <putc>
          s++;
    10ea:	0905                	addi	s2,s2,1
        while(*s != 0){
    10ec:	00094583          	lbu	a1,0(s2)
    10f0:	f9e5                	bnez	a1,10e0 <vprintf+0x142>
        s = va_arg(ap, char*);
    10f2:	8bce                	mv	s7,s3
      state = 0;
    10f4:	4981                	li	s3,0
    10f6:	b5ed                	j	fe0 <vprintf+0x42>
          s = "(null)";
    10f8:	00000917          	auipc	s2,0x0
    10fc:	56090913          	addi	s2,s2,1376 # 1658 <malloc+0x408>
        while(*s != 0){
    1100:	02800593          	li	a1,40
    1104:	bff1                	j	10e0 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    1106:	008b8913          	addi	s2,s7,8
    110a:	000bc583          	lbu	a1,0(s7)
    110e:	8556                	mv	a0,s5
    1110:	00000097          	auipc	ra,0x0
    1114:	dc0080e7          	jalr	-576(ra) # ed0 <putc>
    1118:	8bca                	mv	s7,s2
      state = 0;
    111a:	4981                	li	s3,0
    111c:	b5d1                	j	fe0 <vprintf+0x42>
        putc(fd, c);
    111e:	02500593          	li	a1,37
    1122:	8556                	mv	a0,s5
    1124:	00000097          	auipc	ra,0x0
    1128:	dac080e7          	jalr	-596(ra) # ed0 <putc>
      state = 0;
    112c:	4981                	li	s3,0
    112e:	bd4d                	j	fe0 <vprintf+0x42>
        putc(fd, '%');
    1130:	02500593          	li	a1,37
    1134:	8556                	mv	a0,s5
    1136:	00000097          	auipc	ra,0x0
    113a:	d9a080e7          	jalr	-614(ra) # ed0 <putc>
        putc(fd, c);
    113e:	85ca                	mv	a1,s2
    1140:	8556                	mv	a0,s5
    1142:	00000097          	auipc	ra,0x0
    1146:	d8e080e7          	jalr	-626(ra) # ed0 <putc>
      state = 0;
    114a:	4981                	li	s3,0
    114c:	bd51                	j	fe0 <vprintf+0x42>
        s = va_arg(ap, char*);
    114e:	8bce                	mv	s7,s3
      state = 0;
    1150:	4981                	li	s3,0
    1152:	b579                	j	fe0 <vprintf+0x42>
    1154:	74e2                	ld	s1,56(sp)
    1156:	79a2                	ld	s3,40(sp)
    1158:	7a02                	ld	s4,32(sp)
    115a:	6ae2                	ld	s5,24(sp)
    115c:	6b42                	ld	s6,16(sp)
    115e:	6ba2                	ld	s7,8(sp)
    }
  }
}
    1160:	60a6                	ld	ra,72(sp)
    1162:	6406                	ld	s0,64(sp)
    1164:	7942                	ld	s2,48(sp)
    1166:	6161                	addi	sp,sp,80
    1168:	8082                	ret

000000000000116a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    116a:	715d                	addi	sp,sp,-80
    116c:	ec06                	sd	ra,24(sp)
    116e:	e822                	sd	s0,16(sp)
    1170:	1000                	addi	s0,sp,32
    1172:	e010                	sd	a2,0(s0)
    1174:	e414                	sd	a3,8(s0)
    1176:	e818                	sd	a4,16(s0)
    1178:	ec1c                	sd	a5,24(s0)
    117a:	03043023          	sd	a6,32(s0)
    117e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1182:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1186:	8622                	mv	a2,s0
    1188:	00000097          	auipc	ra,0x0
    118c:	e16080e7          	jalr	-490(ra) # f9e <vprintf>
}
    1190:	60e2                	ld	ra,24(sp)
    1192:	6442                	ld	s0,16(sp)
    1194:	6161                	addi	sp,sp,80
    1196:	8082                	ret

0000000000001198 <printf>:

void
printf(const char *fmt, ...)
{
    1198:	711d                	addi	sp,sp,-96
    119a:	ec06                	sd	ra,24(sp)
    119c:	e822                	sd	s0,16(sp)
    119e:	1000                	addi	s0,sp,32
    11a0:	e40c                	sd	a1,8(s0)
    11a2:	e810                	sd	a2,16(s0)
    11a4:	ec14                	sd	a3,24(s0)
    11a6:	f018                	sd	a4,32(s0)
    11a8:	f41c                	sd	a5,40(s0)
    11aa:	03043823          	sd	a6,48(s0)
    11ae:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    11b2:	00840613          	addi	a2,s0,8
    11b6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    11ba:	85aa                	mv	a1,a0
    11bc:	4505                	li	a0,1
    11be:	00000097          	auipc	ra,0x0
    11c2:	de0080e7          	jalr	-544(ra) # f9e <vprintf>
}
    11c6:	60e2                	ld	ra,24(sp)
    11c8:	6442                	ld	s0,16(sp)
    11ca:	6125                	addi	sp,sp,96
    11cc:	8082                	ret

00000000000011ce <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11ce:	1141                	addi	sp,sp,-16
    11d0:	e422                	sd	s0,8(sp)
    11d2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11d4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11d8:	00001797          	auipc	a5,0x1
    11dc:	9f07b783          	ld	a5,-1552(a5) # 1bc8 <freep>
    11e0:	a02d                	j	120a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    11e2:	4618                	lw	a4,8(a2)
    11e4:	9f2d                	addw	a4,a4,a1
    11e6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    11ea:	6398                	ld	a4,0(a5)
    11ec:	6310                	ld	a2,0(a4)
    11ee:	a83d                	j	122c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    11f0:	ff852703          	lw	a4,-8(a0)
    11f4:	9f31                	addw	a4,a4,a2
    11f6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    11f8:	ff053683          	ld	a3,-16(a0)
    11fc:	a091                	j	1240 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11fe:	6398                	ld	a4,0(a5)
    1200:	00e7e463          	bltu	a5,a4,1208 <free+0x3a>
    1204:	00e6ea63          	bltu	a3,a4,1218 <free+0x4a>
{
    1208:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    120a:	fed7fae3          	bgeu	a5,a3,11fe <free+0x30>
    120e:	6398                	ld	a4,0(a5)
    1210:	00e6e463          	bltu	a3,a4,1218 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1214:	fee7eae3          	bltu	a5,a4,1208 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1218:	ff852583          	lw	a1,-8(a0)
    121c:	6390                	ld	a2,0(a5)
    121e:	02059813          	slli	a6,a1,0x20
    1222:	01c85713          	srli	a4,a6,0x1c
    1226:	9736                	add	a4,a4,a3
    1228:	fae60de3          	beq	a2,a4,11e2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    122c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1230:	4790                	lw	a2,8(a5)
    1232:	02061593          	slli	a1,a2,0x20
    1236:	01c5d713          	srli	a4,a1,0x1c
    123a:	973e                	add	a4,a4,a5
    123c:	fae68ae3          	beq	a3,a4,11f0 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1240:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1242:	00001717          	auipc	a4,0x1
    1246:	98f73323          	sd	a5,-1658(a4) # 1bc8 <freep>
}
    124a:	6422                	ld	s0,8(sp)
    124c:	0141                	addi	sp,sp,16
    124e:	8082                	ret

0000000000001250 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1250:	7139                	addi	sp,sp,-64
    1252:	fc06                	sd	ra,56(sp)
    1254:	f822                	sd	s0,48(sp)
    1256:	f426                	sd	s1,40(sp)
    1258:	ec4e                	sd	s3,24(sp)
    125a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    125c:	02051493          	slli	s1,a0,0x20
    1260:	9081                	srli	s1,s1,0x20
    1262:	04bd                	addi	s1,s1,15
    1264:	8091                	srli	s1,s1,0x4
    1266:	0014899b          	addiw	s3,s1,1
    126a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    126c:	00001517          	auipc	a0,0x1
    1270:	95c53503          	ld	a0,-1700(a0) # 1bc8 <freep>
    1274:	c915                	beqz	a0,12a8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1276:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1278:	4798                	lw	a4,8(a5)
    127a:	08977e63          	bgeu	a4,s1,1316 <malloc+0xc6>
    127e:	f04a                	sd	s2,32(sp)
    1280:	e852                	sd	s4,16(sp)
    1282:	e456                	sd	s5,8(sp)
    1284:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1286:	8a4e                	mv	s4,s3
    1288:	0009871b          	sext.w	a4,s3
    128c:	6685                	lui	a3,0x1
    128e:	00d77363          	bgeu	a4,a3,1294 <malloc+0x44>
    1292:	6a05                	lui	s4,0x1
    1294:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1298:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    129c:	00001917          	auipc	s2,0x1
    12a0:	92c90913          	addi	s2,s2,-1748 # 1bc8 <freep>
  if(p == (char*)-1)
    12a4:	5afd                	li	s5,-1
    12a6:	a091                	j	12ea <malloc+0x9a>
    12a8:	f04a                	sd	s2,32(sp)
    12aa:	e852                	sd	s4,16(sp)
    12ac:	e456                	sd	s5,8(sp)
    12ae:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    12b0:	00001797          	auipc	a5,0x1
    12b4:	d0878793          	addi	a5,a5,-760 # 1fb8 <base>
    12b8:	00001717          	auipc	a4,0x1
    12bc:	90f73823          	sd	a5,-1776(a4) # 1bc8 <freep>
    12c0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    12c2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    12c6:	b7c1                	j	1286 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    12c8:	6398                	ld	a4,0(a5)
    12ca:	e118                	sd	a4,0(a0)
    12cc:	a08d                	j	132e <malloc+0xde>
  hp->s.size = nu;
    12ce:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    12d2:	0541                	addi	a0,a0,16
    12d4:	00000097          	auipc	ra,0x0
    12d8:	efa080e7          	jalr	-262(ra) # 11ce <free>
  return freep;
    12dc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    12e0:	c13d                	beqz	a0,1346 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12e4:	4798                	lw	a4,8(a5)
    12e6:	02977463          	bgeu	a4,s1,130e <malloc+0xbe>
    if(p == freep)
    12ea:	00093703          	ld	a4,0(s2)
    12ee:	853e                	mv	a0,a5
    12f0:	fef719e3          	bne	a4,a5,12e2 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    12f4:	8552                	mv	a0,s4
    12f6:	00000097          	auipc	ra,0x0
    12fa:	bb2080e7          	jalr	-1102(ra) # ea8 <sbrk>
  if(p == (char*)-1)
    12fe:	fd5518e3          	bne	a0,s5,12ce <malloc+0x7e>
        return 0;
    1302:	4501                	li	a0,0
    1304:	7902                	ld	s2,32(sp)
    1306:	6a42                	ld	s4,16(sp)
    1308:	6aa2                	ld	s5,8(sp)
    130a:	6b02                	ld	s6,0(sp)
    130c:	a03d                	j	133a <malloc+0xea>
    130e:	7902                	ld	s2,32(sp)
    1310:	6a42                	ld	s4,16(sp)
    1312:	6aa2                	ld	s5,8(sp)
    1314:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1316:	fae489e3          	beq	s1,a4,12c8 <malloc+0x78>
        p->s.size -= nunits;
    131a:	4137073b          	subw	a4,a4,s3
    131e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1320:	02071693          	slli	a3,a4,0x20
    1324:	01c6d713          	srli	a4,a3,0x1c
    1328:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    132a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    132e:	00001717          	auipc	a4,0x1
    1332:	88a73d23          	sd	a0,-1894(a4) # 1bc8 <freep>
      return (void*)(p + 1);
    1336:	01078513          	addi	a0,a5,16
  }
}
    133a:	70e2                	ld	ra,56(sp)
    133c:	7442                	ld	s0,48(sp)
    133e:	74a2                	ld	s1,40(sp)
    1340:	69e2                	ld	s3,24(sp)
    1342:	6121                	addi	sp,sp,64
    1344:	8082                	ret
    1346:	7902                	ld	s2,32(sp)
    1348:	6a42                	ld	s4,16(sp)
    134a:	6aa2                	ld	s5,8(sp)
    134c:	6b02                	ld	s6,0(sp)
    134e:	b7f5                	j	133a <malloc+0xea>
