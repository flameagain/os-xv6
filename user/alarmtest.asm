
user/_alarmtest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <periodic>:

volatile static int count;

void
periodic()
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  count = count + 1;
   8:	00001797          	auipc	a5,0x1
   c:	2707a783          	lw	a5,624(a5) # 1278 <count>
  10:	2785                	addiw	a5,a5,1
  12:	00001717          	auipc	a4,0x1
  16:	26f72323          	sw	a5,614(a4) # 1278 <count>
  printf("alarm!\n");
  1a:	00001517          	auipc	a0,0x1
  1e:	b4650513          	addi	a0,a0,-1210 # b60 <malloc+0x104>
  22:	00001097          	auipc	ra,0x1
  26:	982080e7          	jalr	-1662(ra) # 9a4 <printf>
  sigreturn();
  2a:	00000097          	auipc	ra,0x0
  2e:	6aa080e7          	jalr	1706(ra) # 6d4 <sigreturn>
}
  32:	60a2                	ld	ra,8(sp)
  34:	6402                	ld	s0,0(sp)
  36:	0141                	addi	sp,sp,16
  38:	8082                	ret

000000000000003a <slow_handler>:
  }
}

void
slow_handler()
{
  3a:	1101                	addi	sp,sp,-32
  3c:	ec06                	sd	ra,24(sp)
  3e:	e822                	sd	s0,16(sp)
  40:	e426                	sd	s1,8(sp)
  42:	1000                	addi	s0,sp,32
  count++;
  44:	00001497          	auipc	s1,0x1
  48:	23448493          	addi	s1,s1,564 # 1278 <count>
  4c:	00001797          	auipc	a5,0x1
  50:	22c7a783          	lw	a5,556(a5) # 1278 <count>
  54:	2785                	addiw	a5,a5,1
  56:	c09c                	sw	a5,0(s1)
  printf("alarm!\n");
  58:	00001517          	auipc	a0,0x1
  5c:	b0850513          	addi	a0,a0,-1272 # b60 <malloc+0x104>
  60:	00001097          	auipc	ra,0x1
  64:	944080e7          	jalr	-1724(ra) # 9a4 <printf>
  if (count > 1) {
  68:	4098                	lw	a4,0(s1)
  6a:	2701                	sext.w	a4,a4
  6c:	4685                	li	a3,1
  6e:	1dcd67b7          	lui	a5,0x1dcd6
  72:	50078793          	addi	a5,a5,1280 # 1dcd6500 <__global_pointer$+0x1dcd4a8c>
  76:	02e6c463          	blt	a3,a4,9e <slow_handler+0x64>
    printf("test2 failed: alarm handler called more than once\n");
    exit(1);
  }
  for (int i = 0; i < 1000*500000; i++) {
    asm volatile("nop"); // avoid compiler optimizing away loop
  7a:	0001                	nop
  for (int i = 0; i < 1000*500000; i++) {
  7c:	37fd                	addiw	a5,a5,-1
  7e:	fff5                	bnez	a5,7a <slow_handler+0x40>
  }
  sigalarm(0, 0);
  80:	4581                	li	a1,0
  82:	4501                	li	a0,0
  84:	00000097          	auipc	ra,0x0
  88:	648080e7          	jalr	1608(ra) # 6cc <sigalarm>
  sigreturn();
  8c:	00000097          	auipc	ra,0x0
  90:	648080e7          	jalr	1608(ra) # 6d4 <sigreturn>
}
  94:	60e2                	ld	ra,24(sp)
  96:	6442                	ld	s0,16(sp)
  98:	64a2                	ld	s1,8(sp)
  9a:	6105                	addi	sp,sp,32
  9c:	8082                	ret
    printf("test2 failed: alarm handler called more than once\n");
  9e:	00001517          	auipc	a0,0x1
  a2:	aca50513          	addi	a0,a0,-1334 # b68 <malloc+0x10c>
  a6:	00001097          	auipc	ra,0x1
  aa:	8fe080e7          	jalr	-1794(ra) # 9a4 <printf>
    exit(1);
  ae:	4505                	li	a0,1
  b0:	00000097          	auipc	ra,0x0
  b4:	57c080e7          	jalr	1404(ra) # 62c <exit>

00000000000000b8 <test0>:
{
  b8:	7139                	addi	sp,sp,-64
  ba:	fc06                	sd	ra,56(sp)
  bc:	f822                	sd	s0,48(sp)
  be:	f426                	sd	s1,40(sp)
  c0:	f04a                	sd	s2,32(sp)
  c2:	ec4e                	sd	s3,24(sp)
  c4:	e852                	sd	s4,16(sp)
  c6:	e456                	sd	s5,8(sp)
  c8:	0080                	addi	s0,sp,64
  printf("test0 start\n");
  ca:	00001517          	auipc	a0,0x1
  ce:	ad650513          	addi	a0,a0,-1322 # ba0 <malloc+0x144>
  d2:	00001097          	auipc	ra,0x1
  d6:	8d2080e7          	jalr	-1838(ra) # 9a4 <printf>
  count = 0;
  da:	00001797          	auipc	a5,0x1
  de:	1807af23          	sw	zero,414(a5) # 1278 <count>
  sigalarm(2, periodic);
  e2:	00000597          	auipc	a1,0x0
  e6:	f1e58593          	addi	a1,a1,-226 # 0 <periodic>
  ea:	4509                	li	a0,2
  ec:	00000097          	auipc	ra,0x0
  f0:	5e0080e7          	jalr	1504(ra) # 6cc <sigalarm>
  for(i = 0; i < 1000*500000; i++){
  f4:	4481                	li	s1,0
    if((i % 1000000) == 0)
  f6:	000f4937          	lui	s2,0xf4
  fa:	2409091b          	addiw	s2,s2,576 # f4240 <__global_pointer$+0xf27cc>
      write(2, ".", 1);
  fe:	00001a97          	auipc	s5,0x1
 102:	ab2a8a93          	addi	s5,s5,-1358 # bb0 <malloc+0x154>
    if(count > 0)
 106:	00001a17          	auipc	s4,0x1
 10a:	172a0a13          	addi	s4,s4,370 # 1278 <count>
  for(i = 0; i < 1000*500000; i++){
 10e:	1dcd69b7          	lui	s3,0x1dcd6
 112:	50098993          	addi	s3,s3,1280 # 1dcd6500 <__global_pointer$+0x1dcd4a8c>
 116:	a809                	j	128 <test0+0x70>
    if(count > 0)
 118:	000a2783          	lw	a5,0(s4)
 11c:	2781                	sext.w	a5,a5
 11e:	02f04063          	bgtz	a5,13e <test0+0x86>
  for(i = 0; i < 1000*500000; i++){
 122:	2485                	addiw	s1,s1,1
 124:	01348d63          	beq	s1,s3,13e <test0+0x86>
    if((i % 1000000) == 0)
 128:	0324e7bb          	remw	a5,s1,s2
 12c:	f7f5                	bnez	a5,118 <test0+0x60>
      write(2, ".", 1);
 12e:	4605                	li	a2,1
 130:	85d6                	mv	a1,s5
 132:	4509                	li	a0,2
 134:	00000097          	auipc	ra,0x0
 138:	518080e7          	jalr	1304(ra) # 64c <write>
 13c:	bff1                	j	118 <test0+0x60>
  sigalarm(0, 0);
 13e:	4581                	li	a1,0
 140:	4501                	li	a0,0
 142:	00000097          	auipc	ra,0x0
 146:	58a080e7          	jalr	1418(ra) # 6cc <sigalarm>
  if(count > 0){
 14a:	00001797          	auipc	a5,0x1
 14e:	12e7a783          	lw	a5,302(a5) # 1278 <count>
 152:	02f05363          	blez	a5,178 <test0+0xc0>
    printf("test0 passed\n");
 156:	00001517          	auipc	a0,0x1
 15a:	a6250513          	addi	a0,a0,-1438 # bb8 <malloc+0x15c>
 15e:	00001097          	auipc	ra,0x1
 162:	846080e7          	jalr	-1978(ra) # 9a4 <printf>
}
 166:	70e2                	ld	ra,56(sp)
 168:	7442                	ld	s0,48(sp)
 16a:	74a2                	ld	s1,40(sp)
 16c:	7902                	ld	s2,32(sp)
 16e:	69e2                	ld	s3,24(sp)
 170:	6a42                	ld	s4,16(sp)
 172:	6aa2                	ld	s5,8(sp)
 174:	6121                	addi	sp,sp,64
 176:	8082                	ret
    printf("\ntest0 failed: the kernel never called the alarm handler\n");
 178:	00001517          	auipc	a0,0x1
 17c:	a5050513          	addi	a0,a0,-1456 # bc8 <malloc+0x16c>
 180:	00001097          	auipc	ra,0x1
 184:	824080e7          	jalr	-2012(ra) # 9a4 <printf>
}
 188:	bff9                	j	166 <test0+0xae>

000000000000018a <foo>:
void __attribute__ ((noinline)) foo(int i, int *j) {
 18a:	1101                	addi	sp,sp,-32
 18c:	ec06                	sd	ra,24(sp)
 18e:	e822                	sd	s0,16(sp)
 190:	e426                	sd	s1,8(sp)
 192:	1000                	addi	s0,sp,32
 194:	84ae                	mv	s1,a1
  if((i % 2500000) == 0) {
 196:	002627b7          	lui	a5,0x262
 19a:	5a07879b          	addiw	a5,a5,1440 # 2625a0 <__global_pointer$+0x260b2c>
 19e:	02f5653b          	remw	a0,a0,a5
 1a2:	c909                	beqz	a0,1b4 <foo+0x2a>
  *j += 1;
 1a4:	409c                	lw	a5,0(s1)
 1a6:	2785                	addiw	a5,a5,1
 1a8:	c09c                	sw	a5,0(s1)
}
 1aa:	60e2                	ld	ra,24(sp)
 1ac:	6442                	ld	s0,16(sp)
 1ae:	64a2                	ld	s1,8(sp)
 1b0:	6105                	addi	sp,sp,32
 1b2:	8082                	ret
    write(2, ".", 1);
 1b4:	4605                	li	a2,1
 1b6:	00001597          	auipc	a1,0x1
 1ba:	9fa58593          	addi	a1,a1,-1542 # bb0 <malloc+0x154>
 1be:	4509                	li	a0,2
 1c0:	00000097          	auipc	ra,0x0
 1c4:	48c080e7          	jalr	1164(ra) # 64c <write>
 1c8:	bff1                	j	1a4 <foo+0x1a>

00000000000001ca <test1>:
{
 1ca:	7139                	addi	sp,sp,-64
 1cc:	fc06                	sd	ra,56(sp)
 1ce:	f822                	sd	s0,48(sp)
 1d0:	f426                	sd	s1,40(sp)
 1d2:	f04a                	sd	s2,32(sp)
 1d4:	ec4e                	sd	s3,24(sp)
 1d6:	e852                	sd	s4,16(sp)
 1d8:	0080                	addi	s0,sp,64
  printf("test1 start\n");
 1da:	00001517          	auipc	a0,0x1
 1de:	a2e50513          	addi	a0,a0,-1490 # c08 <malloc+0x1ac>
 1e2:	00000097          	auipc	ra,0x0
 1e6:	7c2080e7          	jalr	1986(ra) # 9a4 <printf>
  count = 0;
 1ea:	00001797          	auipc	a5,0x1
 1ee:	0807a723          	sw	zero,142(a5) # 1278 <count>
  j = 0;
 1f2:	fc042623          	sw	zero,-52(s0)
  sigalarm(2, periodic);
 1f6:	00000597          	auipc	a1,0x0
 1fa:	e0a58593          	addi	a1,a1,-502 # 0 <periodic>
 1fe:	4509                	li	a0,2
 200:	00000097          	auipc	ra,0x0
 204:	4cc080e7          	jalr	1228(ra) # 6cc <sigalarm>
  for(i = 0; i < 500000000; i++){
 208:	4481                	li	s1,0
    if(count >= 10)
 20a:	00001a17          	auipc	s4,0x1
 20e:	06ea0a13          	addi	s4,s4,110 # 1278 <count>
 212:	49a5                	li	s3,9
  for(i = 0; i < 500000000; i++){
 214:	1dcd6937          	lui	s2,0x1dcd6
 218:	50090913          	addi	s2,s2,1280 # 1dcd6500 <__global_pointer$+0x1dcd4a8c>
    if(count >= 10)
 21c:	000a2783          	lw	a5,0(s4)
 220:	2781                	sext.w	a5,a5
 222:	00f9cc63          	blt	s3,a5,23a <test1+0x70>
    foo(i, &j);
 226:	fcc40593          	addi	a1,s0,-52
 22a:	8526                	mv	a0,s1
 22c:	00000097          	auipc	ra,0x0
 230:	f5e080e7          	jalr	-162(ra) # 18a <foo>
  for(i = 0; i < 500000000; i++){
 234:	2485                	addiw	s1,s1,1
 236:	ff2493e3          	bne	s1,s2,21c <test1+0x52>
  if(count < 10){
 23a:	00001717          	auipc	a4,0x1
 23e:	03e72703          	lw	a4,62(a4) # 1278 <count>
 242:	47a5                	li	a5,9
 244:	02e7d663          	bge	a5,a4,270 <test1+0xa6>
  } else if(i != j){
 248:	fcc42783          	lw	a5,-52(s0)
 24c:	02978b63          	beq	a5,s1,282 <test1+0xb8>
    printf("\ntest1 failed: foo() executed fewer times than it was called\n");
 250:	00001517          	auipc	a0,0x1
 254:	9f850513          	addi	a0,a0,-1544 # c48 <malloc+0x1ec>
 258:	00000097          	auipc	ra,0x0
 25c:	74c080e7          	jalr	1868(ra) # 9a4 <printf>
}
 260:	70e2                	ld	ra,56(sp)
 262:	7442                	ld	s0,48(sp)
 264:	74a2                	ld	s1,40(sp)
 266:	7902                	ld	s2,32(sp)
 268:	69e2                	ld	s3,24(sp)
 26a:	6a42                	ld	s4,16(sp)
 26c:	6121                	addi	sp,sp,64
 26e:	8082                	ret
    printf("\ntest1 failed: too few calls to the handler\n");
 270:	00001517          	auipc	a0,0x1
 274:	9a850513          	addi	a0,a0,-1624 # c18 <malloc+0x1bc>
 278:	00000097          	auipc	ra,0x0
 27c:	72c080e7          	jalr	1836(ra) # 9a4 <printf>
 280:	b7c5                	j	260 <test1+0x96>
    printf("test1 passed\n");
 282:	00001517          	auipc	a0,0x1
 286:	a0650513          	addi	a0,a0,-1530 # c88 <malloc+0x22c>
 28a:	00000097          	auipc	ra,0x0
 28e:	71a080e7          	jalr	1818(ra) # 9a4 <printf>
}
 292:	b7f9                	j	260 <test1+0x96>

0000000000000294 <test2>:
{
 294:	715d                	addi	sp,sp,-80
 296:	e486                	sd	ra,72(sp)
 298:	e0a2                	sd	s0,64(sp)
 29a:	0880                	addi	s0,sp,80
  printf("test2 start\n");
 29c:	00001517          	auipc	a0,0x1
 2a0:	9fc50513          	addi	a0,a0,-1540 # c98 <malloc+0x23c>
 2a4:	00000097          	auipc	ra,0x0
 2a8:	700080e7          	jalr	1792(ra) # 9a4 <printf>
  if ((pid = fork()) < 0) {
 2ac:	00000097          	auipc	ra,0x0
 2b0:	378080e7          	jalr	888(ra) # 624 <fork>
 2b4:	04054763          	bltz	a0,302 <test2+0x6e>
 2b8:	fc26                	sd	s1,56(sp)
 2ba:	84aa                	mv	s1,a0
  if (pid == 0) {
 2bc:	e171                	bnez	a0,380 <test2+0xec>
 2be:	f84a                	sd	s2,48(sp)
 2c0:	f44e                	sd	s3,40(sp)
 2c2:	f052                	sd	s4,32(sp)
 2c4:	ec56                	sd	s5,24(sp)
    count = 0;
 2c6:	00001797          	auipc	a5,0x1
 2ca:	fa07a923          	sw	zero,-78(a5) # 1278 <count>
    sigalarm(2, slow_handler);
 2ce:	00000597          	auipc	a1,0x0
 2d2:	d6c58593          	addi	a1,a1,-660 # 3a <slow_handler>
 2d6:	4509                	li	a0,2
 2d8:	00000097          	auipc	ra,0x0
 2dc:	3f4080e7          	jalr	1012(ra) # 6cc <sigalarm>
      if((i % 1000000) == 0)
 2e0:	000f4937          	lui	s2,0xf4
 2e4:	2409091b          	addiw	s2,s2,576 # f4240 <__global_pointer$+0xf27cc>
        write(2, ".", 1);
 2e8:	00001a97          	auipc	s5,0x1
 2ec:	8c8a8a93          	addi	s5,s5,-1848 # bb0 <malloc+0x154>
      if(count > 0)
 2f0:	00001a17          	auipc	s4,0x1
 2f4:	f88a0a13          	addi	s4,s4,-120 # 1278 <count>
    for(i = 0; i < 1000*500000; i++){
 2f8:	1dcd69b7          	lui	s3,0x1dcd6
 2fc:	50098993          	addi	s3,s3,1280 # 1dcd6500 <__global_pointer$+0x1dcd4a8c>
 300:	a835                	j	33c <test2+0xa8>
    printf("test2: fork failed\n");
 302:	00001517          	auipc	a0,0x1
 306:	9a650513          	addi	a0,a0,-1626 # ca8 <malloc+0x24c>
 30a:	00000097          	auipc	ra,0x0
 30e:	69a080e7          	jalr	1690(ra) # 9a4 <printf>
  wait(&status);
 312:	fbc40513          	addi	a0,s0,-68
 316:	00000097          	auipc	ra,0x0
 31a:	31e080e7          	jalr	798(ra) # 634 <wait>
  if (status == 0) {
 31e:	fbc42783          	lw	a5,-68(s0)
 322:	c3ad                	beqz	a5,384 <test2+0xf0>
}
 324:	60a6                	ld	ra,72(sp)
 326:	6406                	ld	s0,64(sp)
 328:	6161                	addi	sp,sp,80
 32a:	8082                	ret
      if(count > 0)
 32c:	000a2783          	lw	a5,0(s4)
 330:	2781                	sext.w	a5,a5
 332:	02f04063          	bgtz	a5,352 <test2+0xbe>
    for(i = 0; i < 1000*500000; i++){
 336:	2485                	addiw	s1,s1,1
 338:	01348d63          	beq	s1,s3,352 <test2+0xbe>
      if((i % 1000000) == 0)
 33c:	0324e7bb          	remw	a5,s1,s2
 340:	f7f5                	bnez	a5,32c <test2+0x98>
        write(2, ".", 1);
 342:	4605                	li	a2,1
 344:	85d6                	mv	a1,s5
 346:	4509                	li	a0,2
 348:	00000097          	auipc	ra,0x0
 34c:	304080e7          	jalr	772(ra) # 64c <write>
 350:	bff1                	j	32c <test2+0x98>
    if (count == 0) {
 352:	00001797          	auipc	a5,0x1
 356:	f267a783          	lw	a5,-218(a5) # 1278 <count>
 35a:	ef91                	bnez	a5,376 <test2+0xe2>
      printf("\ntest2 failed: alarm not called\n");
 35c:	00001517          	auipc	a0,0x1
 360:	96450513          	addi	a0,a0,-1692 # cc0 <malloc+0x264>
 364:	00000097          	auipc	ra,0x0
 368:	640080e7          	jalr	1600(ra) # 9a4 <printf>
      exit(1);
 36c:	4505                	li	a0,1
 36e:	00000097          	auipc	ra,0x0
 372:	2be080e7          	jalr	702(ra) # 62c <exit>
    exit(0);
 376:	4501                	li	a0,0
 378:	00000097          	auipc	ra,0x0
 37c:	2b4080e7          	jalr	692(ra) # 62c <exit>
 380:	74e2                	ld	s1,56(sp)
 382:	bf41                	j	312 <test2+0x7e>
    printf("test2 passed\n");
 384:	00001517          	auipc	a0,0x1
 388:	96450513          	addi	a0,a0,-1692 # ce8 <malloc+0x28c>
 38c:	00000097          	auipc	ra,0x0
 390:	618080e7          	jalr	1560(ra) # 9a4 <printf>
}
 394:	bf41                	j	324 <test2+0x90>

0000000000000396 <main>:
{
 396:	1141                	addi	sp,sp,-16
 398:	e406                	sd	ra,8(sp)
 39a:	e022                	sd	s0,0(sp)
 39c:	0800                	addi	s0,sp,16
  test0();
 39e:	00000097          	auipc	ra,0x0
 3a2:	d1a080e7          	jalr	-742(ra) # b8 <test0>
  test1();
 3a6:	00000097          	auipc	ra,0x0
 3aa:	e24080e7          	jalr	-476(ra) # 1ca <test1>
  test2();
 3ae:	00000097          	auipc	ra,0x0
 3b2:	ee6080e7          	jalr	-282(ra) # 294 <test2>
  exit(0);
 3b6:	4501                	li	a0,0
 3b8:	00000097          	auipc	ra,0x0
 3bc:	274080e7          	jalr	628(ra) # 62c <exit>

00000000000003c0 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 3c0:	1141                	addi	sp,sp,-16
 3c2:	e422                	sd	s0,8(sp)
 3c4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3c6:	87aa                	mv	a5,a0
 3c8:	0585                	addi	a1,a1,1
 3ca:	0785                	addi	a5,a5,1
 3cc:	fff5c703          	lbu	a4,-1(a1)
 3d0:	fee78fa3          	sb	a4,-1(a5)
 3d4:	fb75                	bnez	a4,3c8 <strcpy+0x8>
    ;
  return os;
}
 3d6:	6422                	ld	s0,8(sp)
 3d8:	0141                	addi	sp,sp,16
 3da:	8082                	ret

00000000000003dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3dc:	1141                	addi	sp,sp,-16
 3de:	e422                	sd	s0,8(sp)
 3e0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3e2:	00054783          	lbu	a5,0(a0)
 3e6:	cb91                	beqz	a5,3fa <strcmp+0x1e>
 3e8:	0005c703          	lbu	a4,0(a1)
 3ec:	00f71763          	bne	a4,a5,3fa <strcmp+0x1e>
    p++, q++;
 3f0:	0505                	addi	a0,a0,1
 3f2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 3f4:	00054783          	lbu	a5,0(a0)
 3f8:	fbe5                	bnez	a5,3e8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 3fa:	0005c503          	lbu	a0,0(a1)
}
 3fe:	40a7853b          	subw	a0,a5,a0
 402:	6422                	ld	s0,8(sp)
 404:	0141                	addi	sp,sp,16
 406:	8082                	ret

0000000000000408 <strlen>:

uint
strlen(const char *s)
{
 408:	1141                	addi	sp,sp,-16
 40a:	e422                	sd	s0,8(sp)
 40c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 40e:	00054783          	lbu	a5,0(a0)
 412:	cf91                	beqz	a5,42e <strlen+0x26>
 414:	0505                	addi	a0,a0,1
 416:	87aa                	mv	a5,a0
 418:	86be                	mv	a3,a5
 41a:	0785                	addi	a5,a5,1
 41c:	fff7c703          	lbu	a4,-1(a5)
 420:	ff65                	bnez	a4,418 <strlen+0x10>
 422:	40a6853b          	subw	a0,a3,a0
 426:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 428:	6422                	ld	s0,8(sp)
 42a:	0141                	addi	sp,sp,16
 42c:	8082                	ret
  for(n = 0; s[n]; n++)
 42e:	4501                	li	a0,0
 430:	bfe5                	j	428 <strlen+0x20>

0000000000000432 <memset>:

void*
memset(void *dst, int c, uint n)
{
 432:	1141                	addi	sp,sp,-16
 434:	e422                	sd	s0,8(sp)
 436:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 438:	ca19                	beqz	a2,44e <memset+0x1c>
 43a:	87aa                	mv	a5,a0
 43c:	1602                	slli	a2,a2,0x20
 43e:	9201                	srli	a2,a2,0x20
 440:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 444:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 448:	0785                	addi	a5,a5,1
 44a:	fee79de3          	bne	a5,a4,444 <memset+0x12>
  }
  return dst;
}
 44e:	6422                	ld	s0,8(sp)
 450:	0141                	addi	sp,sp,16
 452:	8082                	ret

0000000000000454 <strchr>:

char*
strchr(const char *s, char c)
{
 454:	1141                	addi	sp,sp,-16
 456:	e422                	sd	s0,8(sp)
 458:	0800                	addi	s0,sp,16
  for(; *s; s++)
 45a:	00054783          	lbu	a5,0(a0)
 45e:	cb99                	beqz	a5,474 <strchr+0x20>
    if(*s == c)
 460:	00f58763          	beq	a1,a5,46e <strchr+0x1a>
  for(; *s; s++)
 464:	0505                	addi	a0,a0,1
 466:	00054783          	lbu	a5,0(a0)
 46a:	fbfd                	bnez	a5,460 <strchr+0xc>
      return (char*)s;
  return 0;
 46c:	4501                	li	a0,0
}
 46e:	6422                	ld	s0,8(sp)
 470:	0141                	addi	sp,sp,16
 472:	8082                	ret
  return 0;
 474:	4501                	li	a0,0
 476:	bfe5                	j	46e <strchr+0x1a>

0000000000000478 <gets>:

char*
gets(char *buf, int max)
{
 478:	711d                	addi	sp,sp,-96
 47a:	ec86                	sd	ra,88(sp)
 47c:	e8a2                	sd	s0,80(sp)
 47e:	e4a6                	sd	s1,72(sp)
 480:	e0ca                	sd	s2,64(sp)
 482:	fc4e                	sd	s3,56(sp)
 484:	f852                	sd	s4,48(sp)
 486:	f456                	sd	s5,40(sp)
 488:	f05a                	sd	s6,32(sp)
 48a:	ec5e                	sd	s7,24(sp)
 48c:	1080                	addi	s0,sp,96
 48e:	8baa                	mv	s7,a0
 490:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 492:	892a                	mv	s2,a0
 494:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 496:	4aa9                	li	s5,10
 498:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 49a:	89a6                	mv	s3,s1
 49c:	2485                	addiw	s1,s1,1
 49e:	0344d863          	bge	s1,s4,4ce <gets+0x56>
    cc = read(0, &c, 1);
 4a2:	4605                	li	a2,1
 4a4:	faf40593          	addi	a1,s0,-81
 4a8:	4501                	li	a0,0
 4aa:	00000097          	auipc	ra,0x0
 4ae:	19a080e7          	jalr	410(ra) # 644 <read>
    if(cc < 1)
 4b2:	00a05e63          	blez	a0,4ce <gets+0x56>
    buf[i++] = c;
 4b6:	faf44783          	lbu	a5,-81(s0)
 4ba:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4be:	01578763          	beq	a5,s5,4cc <gets+0x54>
 4c2:	0905                	addi	s2,s2,1
 4c4:	fd679be3          	bne	a5,s6,49a <gets+0x22>
    buf[i++] = c;
 4c8:	89a6                	mv	s3,s1
 4ca:	a011                	j	4ce <gets+0x56>
 4cc:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4ce:	99de                	add	s3,s3,s7
 4d0:	00098023          	sb	zero,0(s3)
  return buf;
}
 4d4:	855e                	mv	a0,s7
 4d6:	60e6                	ld	ra,88(sp)
 4d8:	6446                	ld	s0,80(sp)
 4da:	64a6                	ld	s1,72(sp)
 4dc:	6906                	ld	s2,64(sp)
 4de:	79e2                	ld	s3,56(sp)
 4e0:	7a42                	ld	s4,48(sp)
 4e2:	7aa2                	ld	s5,40(sp)
 4e4:	7b02                	ld	s6,32(sp)
 4e6:	6be2                	ld	s7,24(sp)
 4e8:	6125                	addi	sp,sp,96
 4ea:	8082                	ret

00000000000004ec <stat>:

int
stat(const char *n, struct stat *st)
{
 4ec:	1101                	addi	sp,sp,-32
 4ee:	ec06                	sd	ra,24(sp)
 4f0:	e822                	sd	s0,16(sp)
 4f2:	e04a                	sd	s2,0(sp)
 4f4:	1000                	addi	s0,sp,32
 4f6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4f8:	4581                	li	a1,0
 4fa:	00000097          	auipc	ra,0x0
 4fe:	172080e7          	jalr	370(ra) # 66c <open>
  if(fd < 0)
 502:	02054663          	bltz	a0,52e <stat+0x42>
 506:	e426                	sd	s1,8(sp)
 508:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 50a:	85ca                	mv	a1,s2
 50c:	00000097          	auipc	ra,0x0
 510:	178080e7          	jalr	376(ra) # 684 <fstat>
 514:	892a                	mv	s2,a0
  close(fd);
 516:	8526                	mv	a0,s1
 518:	00000097          	auipc	ra,0x0
 51c:	13c080e7          	jalr	316(ra) # 654 <close>
  return r;
 520:	64a2                	ld	s1,8(sp)
}
 522:	854a                	mv	a0,s2
 524:	60e2                	ld	ra,24(sp)
 526:	6442                	ld	s0,16(sp)
 528:	6902                	ld	s2,0(sp)
 52a:	6105                	addi	sp,sp,32
 52c:	8082                	ret
    return -1;
 52e:	597d                	li	s2,-1
 530:	bfcd                	j	522 <stat+0x36>

0000000000000532 <atoi>:

int
atoi(const char *s)
{
 532:	1141                	addi	sp,sp,-16
 534:	e422                	sd	s0,8(sp)
 536:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 538:	00054683          	lbu	a3,0(a0)
 53c:	fd06879b          	addiw	a5,a3,-48
 540:	0ff7f793          	zext.b	a5,a5
 544:	4625                	li	a2,9
 546:	02f66863          	bltu	a2,a5,576 <atoi+0x44>
 54a:	872a                	mv	a4,a0
  n = 0;
 54c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 54e:	0705                	addi	a4,a4,1
 550:	0025179b          	slliw	a5,a0,0x2
 554:	9fa9                	addw	a5,a5,a0
 556:	0017979b          	slliw	a5,a5,0x1
 55a:	9fb5                	addw	a5,a5,a3
 55c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 560:	00074683          	lbu	a3,0(a4)
 564:	fd06879b          	addiw	a5,a3,-48
 568:	0ff7f793          	zext.b	a5,a5
 56c:	fef671e3          	bgeu	a2,a5,54e <atoi+0x1c>
  return n;
}
 570:	6422                	ld	s0,8(sp)
 572:	0141                	addi	sp,sp,16
 574:	8082                	ret
  n = 0;
 576:	4501                	li	a0,0
 578:	bfe5                	j	570 <atoi+0x3e>

000000000000057a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 57a:	1141                	addi	sp,sp,-16
 57c:	e422                	sd	s0,8(sp)
 57e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 580:	02b57463          	bgeu	a0,a1,5a8 <memmove+0x2e>
    while(n-- > 0)
 584:	00c05f63          	blez	a2,5a2 <memmove+0x28>
 588:	1602                	slli	a2,a2,0x20
 58a:	9201                	srli	a2,a2,0x20
 58c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 590:	872a                	mv	a4,a0
      *dst++ = *src++;
 592:	0585                	addi	a1,a1,1
 594:	0705                	addi	a4,a4,1
 596:	fff5c683          	lbu	a3,-1(a1)
 59a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 59e:	fef71ae3          	bne	a4,a5,592 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5a2:	6422                	ld	s0,8(sp)
 5a4:	0141                	addi	sp,sp,16
 5a6:	8082                	ret
    dst += n;
 5a8:	00c50733          	add	a4,a0,a2
    src += n;
 5ac:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5ae:	fec05ae3          	blez	a2,5a2 <memmove+0x28>
 5b2:	fff6079b          	addiw	a5,a2,-1
 5b6:	1782                	slli	a5,a5,0x20
 5b8:	9381                	srli	a5,a5,0x20
 5ba:	fff7c793          	not	a5,a5
 5be:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5c0:	15fd                	addi	a1,a1,-1
 5c2:	177d                	addi	a4,a4,-1
 5c4:	0005c683          	lbu	a3,0(a1)
 5c8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5cc:	fee79ae3          	bne	a5,a4,5c0 <memmove+0x46>
 5d0:	bfc9                	j	5a2 <memmove+0x28>

00000000000005d2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5d2:	1141                	addi	sp,sp,-16
 5d4:	e422                	sd	s0,8(sp)
 5d6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5d8:	ca05                	beqz	a2,608 <memcmp+0x36>
 5da:	fff6069b          	addiw	a3,a2,-1
 5de:	1682                	slli	a3,a3,0x20
 5e0:	9281                	srli	a3,a3,0x20
 5e2:	0685                	addi	a3,a3,1
 5e4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5e6:	00054783          	lbu	a5,0(a0)
 5ea:	0005c703          	lbu	a4,0(a1)
 5ee:	00e79863          	bne	a5,a4,5fe <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 5f2:	0505                	addi	a0,a0,1
    p2++;
 5f4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 5f6:	fed518e3          	bne	a0,a3,5e6 <memcmp+0x14>
  }
  return 0;
 5fa:	4501                	li	a0,0
 5fc:	a019                	j	602 <memcmp+0x30>
      return *p1 - *p2;
 5fe:	40e7853b          	subw	a0,a5,a4
}
 602:	6422                	ld	s0,8(sp)
 604:	0141                	addi	sp,sp,16
 606:	8082                	ret
  return 0;
 608:	4501                	li	a0,0
 60a:	bfe5                	j	602 <memcmp+0x30>

000000000000060c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 60c:	1141                	addi	sp,sp,-16
 60e:	e406                	sd	ra,8(sp)
 610:	e022                	sd	s0,0(sp)
 612:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 614:	00000097          	auipc	ra,0x0
 618:	f66080e7          	jalr	-154(ra) # 57a <memmove>
}
 61c:	60a2                	ld	ra,8(sp)
 61e:	6402                	ld	s0,0(sp)
 620:	0141                	addi	sp,sp,16
 622:	8082                	ret

0000000000000624 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 624:	4885                	li	a7,1
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <exit>:
.global exit
exit:
 li a7, SYS_exit
 62c:	4889                	li	a7,2
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <wait>:
.global wait
wait:
 li a7, SYS_wait
 634:	488d                	li	a7,3
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 63c:	4891                	li	a7,4
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <read>:
.global read
read:
 li a7, SYS_read
 644:	4895                	li	a7,5
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <write>:
.global write
write:
 li a7, SYS_write
 64c:	48c1                	li	a7,16
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <close>:
.global close
close:
 li a7, SYS_close
 654:	48d5                	li	a7,21
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <kill>:
.global kill
kill:
 li a7, SYS_kill
 65c:	4899                	li	a7,6
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <exec>:
.global exec
exec:
 li a7, SYS_exec
 664:	489d                	li	a7,7
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <open>:
.global open
open:
 li a7, SYS_open
 66c:	48bd                	li	a7,15
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 674:	48c5                	li	a7,17
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 67c:	48c9                	li	a7,18
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 684:	48a1                	li	a7,8
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <link>:
.global link
link:
 li a7, SYS_link
 68c:	48cd                	li	a7,19
 ecall
 68e:	00000073          	ecall
 ret
 692:	8082                	ret

0000000000000694 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 694:	48d1                	li	a7,20
 ecall
 696:	00000073          	ecall
 ret
 69a:	8082                	ret

000000000000069c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 69c:	48a5                	li	a7,9
 ecall
 69e:	00000073          	ecall
 ret
 6a2:	8082                	ret

00000000000006a4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6a4:	48a9                	li	a7,10
 ecall
 6a6:	00000073          	ecall
 ret
 6aa:	8082                	ret

00000000000006ac <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6ac:	48ad                	li	a7,11
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6b4:	48b1                	li	a7,12
 ecall
 6b6:	00000073          	ecall
 ret
 6ba:	8082                	ret

00000000000006bc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6bc:	48b5                	li	a7,13
 ecall
 6be:	00000073          	ecall
 ret
 6c2:	8082                	ret

00000000000006c4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6c4:	48b9                	li	a7,14
 ecall
 6c6:	00000073          	ecall
 ret
 6ca:	8082                	ret

00000000000006cc <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 6cc:	48d9                	li	a7,22
 ecall
 6ce:	00000073          	ecall
 ret
 6d2:	8082                	ret

00000000000006d4 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 6d4:	48dd                	li	a7,23
 ecall
 6d6:	00000073          	ecall
 ret
 6da:	8082                	ret

00000000000006dc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6dc:	1101                	addi	sp,sp,-32
 6de:	ec06                	sd	ra,24(sp)
 6e0:	e822                	sd	s0,16(sp)
 6e2:	1000                	addi	s0,sp,32
 6e4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6e8:	4605                	li	a2,1
 6ea:	fef40593          	addi	a1,s0,-17
 6ee:	00000097          	auipc	ra,0x0
 6f2:	f5e080e7          	jalr	-162(ra) # 64c <write>
}
 6f6:	60e2                	ld	ra,24(sp)
 6f8:	6442                	ld	s0,16(sp)
 6fa:	6105                	addi	sp,sp,32
 6fc:	8082                	ret

00000000000006fe <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6fe:	7139                	addi	sp,sp,-64
 700:	fc06                	sd	ra,56(sp)
 702:	f822                	sd	s0,48(sp)
 704:	f426                	sd	s1,40(sp)
 706:	0080                	addi	s0,sp,64
 708:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 70a:	c299                	beqz	a3,710 <printint+0x12>
 70c:	0805cb63          	bltz	a1,7a2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 710:	2581                	sext.w	a1,a1
  neg = 0;
 712:	4881                	li	a7,0
 714:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 718:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 71a:	2601                	sext.w	a2,a2
 71c:	00000517          	auipc	a0,0x0
 720:	63c50513          	addi	a0,a0,1596 # d58 <digits>
 724:	883a                	mv	a6,a4
 726:	2705                	addiw	a4,a4,1
 728:	02c5f7bb          	remuw	a5,a1,a2
 72c:	1782                	slli	a5,a5,0x20
 72e:	9381                	srli	a5,a5,0x20
 730:	97aa                	add	a5,a5,a0
 732:	0007c783          	lbu	a5,0(a5)
 736:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 73a:	0005879b          	sext.w	a5,a1
 73e:	02c5d5bb          	divuw	a1,a1,a2
 742:	0685                	addi	a3,a3,1
 744:	fec7f0e3          	bgeu	a5,a2,724 <printint+0x26>
  if(neg)
 748:	00088c63          	beqz	a7,760 <printint+0x62>
    buf[i++] = '-';
 74c:	fd070793          	addi	a5,a4,-48
 750:	00878733          	add	a4,a5,s0
 754:	02d00793          	li	a5,45
 758:	fef70823          	sb	a5,-16(a4)
 75c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 760:	02e05c63          	blez	a4,798 <printint+0x9a>
 764:	f04a                	sd	s2,32(sp)
 766:	ec4e                	sd	s3,24(sp)
 768:	fc040793          	addi	a5,s0,-64
 76c:	00e78933          	add	s2,a5,a4
 770:	fff78993          	addi	s3,a5,-1
 774:	99ba                	add	s3,s3,a4
 776:	377d                	addiw	a4,a4,-1
 778:	1702                	slli	a4,a4,0x20
 77a:	9301                	srli	a4,a4,0x20
 77c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 780:	fff94583          	lbu	a1,-1(s2)
 784:	8526                	mv	a0,s1
 786:	00000097          	auipc	ra,0x0
 78a:	f56080e7          	jalr	-170(ra) # 6dc <putc>
  while(--i >= 0)
 78e:	197d                	addi	s2,s2,-1
 790:	ff3918e3          	bne	s2,s3,780 <printint+0x82>
 794:	7902                	ld	s2,32(sp)
 796:	69e2                	ld	s3,24(sp)
}
 798:	70e2                	ld	ra,56(sp)
 79a:	7442                	ld	s0,48(sp)
 79c:	74a2                	ld	s1,40(sp)
 79e:	6121                	addi	sp,sp,64
 7a0:	8082                	ret
    x = -xx;
 7a2:	40b005bb          	negw	a1,a1
    neg = 1;
 7a6:	4885                	li	a7,1
    x = -xx;
 7a8:	b7b5                	j	714 <printint+0x16>

00000000000007aa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7aa:	715d                	addi	sp,sp,-80
 7ac:	e486                	sd	ra,72(sp)
 7ae:	e0a2                	sd	s0,64(sp)
 7b0:	f84a                	sd	s2,48(sp)
 7b2:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7b4:	0005c903          	lbu	s2,0(a1)
 7b8:	1a090a63          	beqz	s2,96c <vprintf+0x1c2>
 7bc:	fc26                	sd	s1,56(sp)
 7be:	f44e                	sd	s3,40(sp)
 7c0:	f052                	sd	s4,32(sp)
 7c2:	ec56                	sd	s5,24(sp)
 7c4:	e85a                	sd	s6,16(sp)
 7c6:	e45e                	sd	s7,8(sp)
 7c8:	8aaa                	mv	s5,a0
 7ca:	8bb2                	mv	s7,a2
 7cc:	00158493          	addi	s1,a1,1
  state = 0;
 7d0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7d2:	02500a13          	li	s4,37
 7d6:	4b55                	li	s6,21
 7d8:	a839                	j	7f6 <vprintf+0x4c>
        putc(fd, c);
 7da:	85ca                	mv	a1,s2
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	efe080e7          	jalr	-258(ra) # 6dc <putc>
 7e6:	a019                	j	7ec <vprintf+0x42>
    } else if(state == '%'){
 7e8:	01498d63          	beq	s3,s4,802 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 7ec:	0485                	addi	s1,s1,1
 7ee:	fff4c903          	lbu	s2,-1(s1)
 7f2:	16090763          	beqz	s2,960 <vprintf+0x1b6>
    if(state == 0){
 7f6:	fe0999e3          	bnez	s3,7e8 <vprintf+0x3e>
      if(c == '%'){
 7fa:	ff4910e3          	bne	s2,s4,7da <vprintf+0x30>
        state = '%';
 7fe:	89d2                	mv	s3,s4
 800:	b7f5                	j	7ec <vprintf+0x42>
      if(c == 'd'){
 802:	13490463          	beq	s2,s4,92a <vprintf+0x180>
 806:	f9d9079b          	addiw	a5,s2,-99
 80a:	0ff7f793          	zext.b	a5,a5
 80e:	12fb6763          	bltu	s6,a5,93c <vprintf+0x192>
 812:	f9d9079b          	addiw	a5,s2,-99
 816:	0ff7f713          	zext.b	a4,a5
 81a:	12eb6163          	bltu	s6,a4,93c <vprintf+0x192>
 81e:	00271793          	slli	a5,a4,0x2
 822:	00000717          	auipc	a4,0x0
 826:	4de70713          	addi	a4,a4,1246 # d00 <malloc+0x2a4>
 82a:	97ba                	add	a5,a5,a4
 82c:	439c                	lw	a5,0(a5)
 82e:	97ba                	add	a5,a5,a4
 830:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 832:	008b8913          	addi	s2,s7,8
 836:	4685                	li	a3,1
 838:	4629                	li	a2,10
 83a:	000ba583          	lw	a1,0(s7)
 83e:	8556                	mv	a0,s5
 840:	00000097          	auipc	ra,0x0
 844:	ebe080e7          	jalr	-322(ra) # 6fe <printint>
 848:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 84a:	4981                	li	s3,0
 84c:	b745                	j	7ec <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 84e:	008b8913          	addi	s2,s7,8
 852:	4681                	li	a3,0
 854:	4629                	li	a2,10
 856:	000ba583          	lw	a1,0(s7)
 85a:	8556                	mv	a0,s5
 85c:	00000097          	auipc	ra,0x0
 860:	ea2080e7          	jalr	-350(ra) # 6fe <printint>
 864:	8bca                	mv	s7,s2
      state = 0;
 866:	4981                	li	s3,0
 868:	b751                	j	7ec <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 86a:	008b8913          	addi	s2,s7,8
 86e:	4681                	li	a3,0
 870:	4641                	li	a2,16
 872:	000ba583          	lw	a1,0(s7)
 876:	8556                	mv	a0,s5
 878:	00000097          	auipc	ra,0x0
 87c:	e86080e7          	jalr	-378(ra) # 6fe <printint>
 880:	8bca                	mv	s7,s2
      state = 0;
 882:	4981                	li	s3,0
 884:	b7a5                	j	7ec <vprintf+0x42>
 886:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 888:	008b8c13          	addi	s8,s7,8
 88c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 890:	03000593          	li	a1,48
 894:	8556                	mv	a0,s5
 896:	00000097          	auipc	ra,0x0
 89a:	e46080e7          	jalr	-442(ra) # 6dc <putc>
  putc(fd, 'x');
 89e:	07800593          	li	a1,120
 8a2:	8556                	mv	a0,s5
 8a4:	00000097          	auipc	ra,0x0
 8a8:	e38080e7          	jalr	-456(ra) # 6dc <putc>
 8ac:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8ae:	00000b97          	auipc	s7,0x0
 8b2:	4aab8b93          	addi	s7,s7,1194 # d58 <digits>
 8b6:	03c9d793          	srli	a5,s3,0x3c
 8ba:	97de                	add	a5,a5,s7
 8bc:	0007c583          	lbu	a1,0(a5)
 8c0:	8556                	mv	a0,s5
 8c2:	00000097          	auipc	ra,0x0
 8c6:	e1a080e7          	jalr	-486(ra) # 6dc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8ca:	0992                	slli	s3,s3,0x4
 8cc:	397d                	addiw	s2,s2,-1
 8ce:	fe0914e3          	bnez	s2,8b6 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 8d2:	8be2                	mv	s7,s8
      state = 0;
 8d4:	4981                	li	s3,0
 8d6:	6c02                	ld	s8,0(sp)
 8d8:	bf11                	j	7ec <vprintf+0x42>
        s = va_arg(ap, char*);
 8da:	008b8993          	addi	s3,s7,8
 8de:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 8e2:	02090163          	beqz	s2,904 <vprintf+0x15a>
        while(*s != 0){
 8e6:	00094583          	lbu	a1,0(s2)
 8ea:	c9a5                	beqz	a1,95a <vprintf+0x1b0>
          putc(fd, *s);
 8ec:	8556                	mv	a0,s5
 8ee:	00000097          	auipc	ra,0x0
 8f2:	dee080e7          	jalr	-530(ra) # 6dc <putc>
          s++;
 8f6:	0905                	addi	s2,s2,1
        while(*s != 0){
 8f8:	00094583          	lbu	a1,0(s2)
 8fc:	f9e5                	bnez	a1,8ec <vprintf+0x142>
        s = va_arg(ap, char*);
 8fe:	8bce                	mv	s7,s3
      state = 0;
 900:	4981                	li	s3,0
 902:	b5ed                	j	7ec <vprintf+0x42>
          s = "(null)";
 904:	00000917          	auipc	s2,0x0
 908:	3f490913          	addi	s2,s2,1012 # cf8 <malloc+0x29c>
        while(*s != 0){
 90c:	02800593          	li	a1,40
 910:	bff1                	j	8ec <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 912:	008b8913          	addi	s2,s7,8
 916:	000bc583          	lbu	a1,0(s7)
 91a:	8556                	mv	a0,s5
 91c:	00000097          	auipc	ra,0x0
 920:	dc0080e7          	jalr	-576(ra) # 6dc <putc>
 924:	8bca                	mv	s7,s2
      state = 0;
 926:	4981                	li	s3,0
 928:	b5d1                	j	7ec <vprintf+0x42>
        putc(fd, c);
 92a:	02500593          	li	a1,37
 92e:	8556                	mv	a0,s5
 930:	00000097          	auipc	ra,0x0
 934:	dac080e7          	jalr	-596(ra) # 6dc <putc>
      state = 0;
 938:	4981                	li	s3,0
 93a:	bd4d                	j	7ec <vprintf+0x42>
        putc(fd, '%');
 93c:	02500593          	li	a1,37
 940:	8556                	mv	a0,s5
 942:	00000097          	auipc	ra,0x0
 946:	d9a080e7          	jalr	-614(ra) # 6dc <putc>
        putc(fd, c);
 94a:	85ca                	mv	a1,s2
 94c:	8556                	mv	a0,s5
 94e:	00000097          	auipc	ra,0x0
 952:	d8e080e7          	jalr	-626(ra) # 6dc <putc>
      state = 0;
 956:	4981                	li	s3,0
 958:	bd51                	j	7ec <vprintf+0x42>
        s = va_arg(ap, char*);
 95a:	8bce                	mv	s7,s3
      state = 0;
 95c:	4981                	li	s3,0
 95e:	b579                	j	7ec <vprintf+0x42>
 960:	74e2                	ld	s1,56(sp)
 962:	79a2                	ld	s3,40(sp)
 964:	7a02                	ld	s4,32(sp)
 966:	6ae2                	ld	s5,24(sp)
 968:	6b42                	ld	s6,16(sp)
 96a:	6ba2                	ld	s7,8(sp)
    }
  }
}
 96c:	60a6                	ld	ra,72(sp)
 96e:	6406                	ld	s0,64(sp)
 970:	7942                	ld	s2,48(sp)
 972:	6161                	addi	sp,sp,80
 974:	8082                	ret

0000000000000976 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 976:	715d                	addi	sp,sp,-80
 978:	ec06                	sd	ra,24(sp)
 97a:	e822                	sd	s0,16(sp)
 97c:	1000                	addi	s0,sp,32
 97e:	e010                	sd	a2,0(s0)
 980:	e414                	sd	a3,8(s0)
 982:	e818                	sd	a4,16(s0)
 984:	ec1c                	sd	a5,24(s0)
 986:	03043023          	sd	a6,32(s0)
 98a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 98e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 992:	8622                	mv	a2,s0
 994:	00000097          	auipc	ra,0x0
 998:	e16080e7          	jalr	-490(ra) # 7aa <vprintf>
}
 99c:	60e2                	ld	ra,24(sp)
 99e:	6442                	ld	s0,16(sp)
 9a0:	6161                	addi	sp,sp,80
 9a2:	8082                	ret

00000000000009a4 <printf>:

void
printf(const char *fmt, ...)
{
 9a4:	711d                	addi	sp,sp,-96
 9a6:	ec06                	sd	ra,24(sp)
 9a8:	e822                	sd	s0,16(sp)
 9aa:	1000                	addi	s0,sp,32
 9ac:	e40c                	sd	a1,8(s0)
 9ae:	e810                	sd	a2,16(s0)
 9b0:	ec14                	sd	a3,24(s0)
 9b2:	f018                	sd	a4,32(s0)
 9b4:	f41c                	sd	a5,40(s0)
 9b6:	03043823          	sd	a6,48(s0)
 9ba:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9be:	00840613          	addi	a2,s0,8
 9c2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9c6:	85aa                	mv	a1,a0
 9c8:	4505                	li	a0,1
 9ca:	00000097          	auipc	ra,0x0
 9ce:	de0080e7          	jalr	-544(ra) # 7aa <vprintf>
}
 9d2:	60e2                	ld	ra,24(sp)
 9d4:	6442                	ld	s0,16(sp)
 9d6:	6125                	addi	sp,sp,96
 9d8:	8082                	ret

00000000000009da <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9da:	1141                	addi	sp,sp,-16
 9dc:	e422                	sd	s0,8(sp)
 9de:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9e0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9e4:	00001797          	auipc	a5,0x1
 9e8:	89c7b783          	ld	a5,-1892(a5) # 1280 <freep>
 9ec:	a02d                	j	a16 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9ee:	4618                	lw	a4,8(a2)
 9f0:	9f2d                	addw	a4,a4,a1
 9f2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9f6:	6398                	ld	a4,0(a5)
 9f8:	6310                	ld	a2,0(a4)
 9fa:	a83d                	j	a38 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9fc:	ff852703          	lw	a4,-8(a0)
 a00:	9f31                	addw	a4,a4,a2
 a02:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a04:	ff053683          	ld	a3,-16(a0)
 a08:	a091                	j	a4c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a0a:	6398                	ld	a4,0(a5)
 a0c:	00e7e463          	bltu	a5,a4,a14 <free+0x3a>
 a10:	00e6ea63          	bltu	a3,a4,a24 <free+0x4a>
{
 a14:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a16:	fed7fae3          	bgeu	a5,a3,a0a <free+0x30>
 a1a:	6398                	ld	a4,0(a5)
 a1c:	00e6e463          	bltu	a3,a4,a24 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a20:	fee7eae3          	bltu	a5,a4,a14 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 a24:	ff852583          	lw	a1,-8(a0)
 a28:	6390                	ld	a2,0(a5)
 a2a:	02059813          	slli	a6,a1,0x20
 a2e:	01c85713          	srli	a4,a6,0x1c
 a32:	9736                	add	a4,a4,a3
 a34:	fae60de3          	beq	a2,a4,9ee <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 a38:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a3c:	4790                	lw	a2,8(a5)
 a3e:	02061593          	slli	a1,a2,0x20
 a42:	01c5d713          	srli	a4,a1,0x1c
 a46:	973e                	add	a4,a4,a5
 a48:	fae68ae3          	beq	a3,a4,9fc <free+0x22>
    p->s.ptr = bp->s.ptr;
 a4c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a4e:	00001717          	auipc	a4,0x1
 a52:	82f73923          	sd	a5,-1998(a4) # 1280 <freep>
}
 a56:	6422                	ld	s0,8(sp)
 a58:	0141                	addi	sp,sp,16
 a5a:	8082                	ret

0000000000000a5c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a5c:	7139                	addi	sp,sp,-64
 a5e:	fc06                	sd	ra,56(sp)
 a60:	f822                	sd	s0,48(sp)
 a62:	f426                	sd	s1,40(sp)
 a64:	ec4e                	sd	s3,24(sp)
 a66:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a68:	02051493          	slli	s1,a0,0x20
 a6c:	9081                	srli	s1,s1,0x20
 a6e:	04bd                	addi	s1,s1,15
 a70:	8091                	srli	s1,s1,0x4
 a72:	0014899b          	addiw	s3,s1,1
 a76:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a78:	00001517          	auipc	a0,0x1
 a7c:	80853503          	ld	a0,-2040(a0) # 1280 <freep>
 a80:	c915                	beqz	a0,ab4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a82:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a84:	4798                	lw	a4,8(a5)
 a86:	08977e63          	bgeu	a4,s1,b22 <malloc+0xc6>
 a8a:	f04a                	sd	s2,32(sp)
 a8c:	e852                	sd	s4,16(sp)
 a8e:	e456                	sd	s5,8(sp)
 a90:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a92:	8a4e                	mv	s4,s3
 a94:	0009871b          	sext.w	a4,s3
 a98:	6685                	lui	a3,0x1
 a9a:	00d77363          	bgeu	a4,a3,aa0 <malloc+0x44>
 a9e:	6a05                	lui	s4,0x1
 aa0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 aa4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 aa8:	00000917          	auipc	s2,0x0
 aac:	7d890913          	addi	s2,s2,2008 # 1280 <freep>
  if(p == (char*)-1)
 ab0:	5afd                	li	s5,-1
 ab2:	a091                	j	af6 <malloc+0x9a>
 ab4:	f04a                	sd	s2,32(sp)
 ab6:	e852                	sd	s4,16(sp)
 ab8:	e456                	sd	s5,8(sp)
 aba:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 abc:	00000797          	auipc	a5,0x0
 ac0:	7cc78793          	addi	a5,a5,1996 # 1288 <base>
 ac4:	00000717          	auipc	a4,0x0
 ac8:	7af73e23          	sd	a5,1980(a4) # 1280 <freep>
 acc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ace:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ad2:	b7c1                	j	a92 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 ad4:	6398                	ld	a4,0(a5)
 ad6:	e118                	sd	a4,0(a0)
 ad8:	a08d                	j	b3a <malloc+0xde>
  hp->s.size = nu;
 ada:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ade:	0541                	addi	a0,a0,16
 ae0:	00000097          	auipc	ra,0x0
 ae4:	efa080e7          	jalr	-262(ra) # 9da <free>
  return freep;
 ae8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 aec:	c13d                	beqz	a0,b52 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aee:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 af0:	4798                	lw	a4,8(a5)
 af2:	02977463          	bgeu	a4,s1,b1a <malloc+0xbe>
    if(p == freep)
 af6:	00093703          	ld	a4,0(s2)
 afa:	853e                	mv	a0,a5
 afc:	fef719e3          	bne	a4,a5,aee <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 b00:	8552                	mv	a0,s4
 b02:	00000097          	auipc	ra,0x0
 b06:	bb2080e7          	jalr	-1102(ra) # 6b4 <sbrk>
  if(p == (char*)-1)
 b0a:	fd5518e3          	bne	a0,s5,ada <malloc+0x7e>
        return 0;
 b0e:	4501                	li	a0,0
 b10:	7902                	ld	s2,32(sp)
 b12:	6a42                	ld	s4,16(sp)
 b14:	6aa2                	ld	s5,8(sp)
 b16:	6b02                	ld	s6,0(sp)
 b18:	a03d                	j	b46 <malloc+0xea>
 b1a:	7902                	ld	s2,32(sp)
 b1c:	6a42                	ld	s4,16(sp)
 b1e:	6aa2                	ld	s5,8(sp)
 b20:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b22:	fae489e3          	beq	s1,a4,ad4 <malloc+0x78>
        p->s.size -= nunits;
 b26:	4137073b          	subw	a4,a4,s3
 b2a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b2c:	02071693          	slli	a3,a4,0x20
 b30:	01c6d713          	srli	a4,a3,0x1c
 b34:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b36:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b3a:	00000717          	auipc	a4,0x0
 b3e:	74a73323          	sd	a0,1862(a4) # 1280 <freep>
      return (void*)(p + 1);
 b42:	01078513          	addi	a0,a5,16
  }
}
 b46:	70e2                	ld	ra,56(sp)
 b48:	7442                	ld	s0,48(sp)
 b4a:	74a2                	ld	s1,40(sp)
 b4c:	69e2                	ld	s3,24(sp)
 b4e:	6121                	addi	sp,sp,64
 b50:	8082                	ret
 b52:	7902                	ld	s2,32(sp)
 b54:	6a42                	ld	s4,16(sp)
 b56:	6aa2                	ld	s5,8(sp)
 b58:	6b02                	ld	s6,0(sp)
 b5a:	b7f5                	j	b46 <malloc+0xea>
