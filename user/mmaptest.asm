
user/_mmaptest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:

char *testname = "???";

void
err(char *why)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
  printf("mmaptest: %s failed: %s, pid=%d\n", testname, why, getpid());
       e:	00002917          	auipc	s2,0x2
      12:	a8a93903          	ld	s2,-1398(s2) # 1a98 <testname>
      16:	00001097          	auipc	ra,0x1
      1a:	bfe080e7          	jalr	-1026(ra) # c14 <getpid>
      1e:	86aa                	mv	a3,a0
      20:	8626                	mv	a2,s1
      22:	85ca                	mv	a1,s2
      24:	00001517          	auipc	a0,0x1
      28:	0a450513          	addi	a0,a0,164 # 10c8 <malloc+0x104>
      2c:	00001097          	auipc	ra,0x1
      30:	ee0080e7          	jalr	-288(ra) # f0c <printf>
  exit(1);
      34:	4505                	li	a0,1
      36:	00001097          	auipc	ra,0x1
      3a:	b5e080e7          	jalr	-1186(ra) # b94 <exit>

000000000000003e <_v1>:
//
// check the content of the two mapped pages.
//
void
_v1(char *p)
{
      3e:	1141                	addi	sp,sp,-16
      40:	e406                	sd	ra,8(sp)
      42:	e022                	sd	s0,0(sp)
      44:	0800                	addi	s0,sp,16
  int i;
  for (i = 0; i < PGSIZE*2; i++) {
      46:	4581                	li	a1,0
    if (i < PGSIZE + (PGSIZE/2)) {
      48:	6785                	lui	a5,0x1
      4a:	7ff78793          	addi	a5,a5,2047 # 17ff <digits+0x227>
  for (i = 0; i < PGSIZE*2; i++) {
      4e:	6689                	lui	a3,0x2
      if (p[i] != 'A') {
      50:	04100713          	li	a4,65
      54:	a805                	j	84 <_v1+0x46>
        printf("mismatch at %d, wanted 'A', got 0x%x\n", i, p[i]);
      56:	00001517          	auipc	a0,0x1
      5a:	09a50513          	addi	a0,a0,154 # 10f0 <malloc+0x12c>
      5e:	00001097          	auipc	ra,0x1
      62:	eae080e7          	jalr	-338(ra) # f0c <printf>
        err("v1 mismatch (1)");
      66:	00001517          	auipc	a0,0x1
      6a:	0b250513          	addi	a0,a0,178 # 1118 <malloc+0x154>
      6e:	00000097          	auipc	ra,0x0
      72:	f92080e7          	jalr	-110(ra) # 0 <err>
      }
    } else {
      if (p[i] != 0) {
      76:	00054603          	lbu	a2,0(a0)
      7a:	ee11                	bnez	a2,96 <_v1+0x58>
  for (i = 0; i < PGSIZE*2; i++) {
      7c:	2585                	addiw	a1,a1,1
      7e:	0505                	addi	a0,a0,1
      80:	02d58b63          	beq	a1,a3,b6 <_v1+0x78>
    if (i < PGSIZE + (PGSIZE/2)) {
      84:	feb7c9e3          	blt	a5,a1,76 <_v1+0x38>
      if (p[i] != 'A') {
      88:	00054603          	lbu	a2,0(a0)
      8c:	fce615e3          	bne	a2,a4,56 <_v1+0x18>
  for (i = 0; i < PGSIZE*2; i++) {
      90:	2585                	addiw	a1,a1,1
      92:	0505                	addi	a0,a0,1
      94:	bfc5                	j	84 <_v1+0x46>
        printf("mismatch at %d, wanted zero, got 0x%x\n", i, p[i]);
      96:	00001517          	auipc	a0,0x1
      9a:	09250513          	addi	a0,a0,146 # 1128 <malloc+0x164>
      9e:	00001097          	auipc	ra,0x1
      a2:	e6e080e7          	jalr	-402(ra) # f0c <printf>
        err("v1 mismatch (2)");
      a6:	00001517          	auipc	a0,0x1
      aa:	0aa50513          	addi	a0,a0,170 # 1150 <malloc+0x18c>
      ae:	00000097          	auipc	ra,0x0
      b2:	f52080e7          	jalr	-174(ra) # 0 <err>
      }
    }
  }
}
      b6:	60a2                	ld	ra,8(sp)
      b8:	6402                	ld	s0,0(sp)
      ba:	0141                	addi	sp,sp,16
      bc:	8082                	ret

00000000000000be <makefile>:
// create a file to be mapped, containing
// 1.5 pages of 'A' and half a page of zeros.
//
void
makefile(const char *f)
{
      be:	7179                	addi	sp,sp,-48
      c0:	f406                	sd	ra,40(sp)
      c2:	f022                	sd	s0,32(sp)
      c4:	ec26                	sd	s1,24(sp)
      c6:	e84a                	sd	s2,16(sp)
      c8:	e44e                	sd	s3,8(sp)
      ca:	1800                	addi	s0,sp,48
      cc:	84aa                	mv	s1,a0
  int i;
  int n = PGSIZE/BSIZE;

  unlink(f);
      ce:	00001097          	auipc	ra,0x1
      d2:	b16080e7          	jalr	-1258(ra) # be4 <unlink>
  int fd = open(f, O_WRONLY | O_CREATE);
      d6:	20100593          	li	a1,513
      da:	8526                	mv	a0,s1
      dc:	00001097          	auipc	ra,0x1
      e0:	af8080e7          	jalr	-1288(ra) # bd4 <open>
  if (fd == -1)
      e4:	57fd                	li	a5,-1
      e6:	06f50163          	beq	a0,a5,148 <makefile+0x8a>
      ea:	892a                	mv	s2,a0
    err("open");
  memset(buf, 'A', BSIZE);
      ec:	40000613          	li	a2,1024
      f0:	04100593          	li	a1,65
      f4:	00002517          	auipc	a0,0x2
      f8:	9b450513          	addi	a0,a0,-1612 # 1aa8 <buf>
      fc:	00001097          	auipc	ra,0x1
     100:	89e080e7          	jalr	-1890(ra) # 99a <memset>
     104:	4499                	li	s1,6
  // write 1.5 page
  for (i = 0; i < n + n/2; i++) {
    if (write(fd, buf, BSIZE) != BSIZE)
     106:	00002997          	auipc	s3,0x2
     10a:	9a298993          	addi	s3,s3,-1630 # 1aa8 <buf>
     10e:	40000613          	li	a2,1024
     112:	85ce                	mv	a1,s3
     114:	854a                	mv	a0,s2
     116:	00001097          	auipc	ra,0x1
     11a:	a9e080e7          	jalr	-1378(ra) # bb4 <write>
     11e:	40000793          	li	a5,1024
     122:	02f51b63          	bne	a0,a5,158 <makefile+0x9a>
  for (i = 0; i < n + n/2; i++) {
     126:	34fd                	addiw	s1,s1,-1
     128:	f0fd                	bnez	s1,10e <makefile+0x50>
      err("write 0 makefile");
  }
  if (close(fd) == -1)
     12a:	854a                	mv	a0,s2
     12c:	00001097          	auipc	ra,0x1
     130:	a90080e7          	jalr	-1392(ra) # bbc <close>
     134:	57fd                	li	a5,-1
     136:	02f50963          	beq	a0,a5,168 <makefile+0xaa>
    err("close");
}
     13a:	70a2                	ld	ra,40(sp)
     13c:	7402                	ld	s0,32(sp)
     13e:	64e2                	ld	s1,24(sp)
     140:	6942                	ld	s2,16(sp)
     142:	69a2                	ld	s3,8(sp)
     144:	6145                	addi	sp,sp,48
     146:	8082                	ret
    err("open");
     148:	00001517          	auipc	a0,0x1
     14c:	01850513          	addi	a0,a0,24 # 1160 <malloc+0x19c>
     150:	00000097          	auipc	ra,0x0
     154:	eb0080e7          	jalr	-336(ra) # 0 <err>
      err("write 0 makefile");
     158:	00001517          	auipc	a0,0x1
     15c:	01050513          	addi	a0,a0,16 # 1168 <malloc+0x1a4>
     160:	00000097          	auipc	ra,0x0
     164:	ea0080e7          	jalr	-352(ra) # 0 <err>
    err("close");
     168:	00001517          	auipc	a0,0x1
     16c:	01850513          	addi	a0,a0,24 # 1180 <malloc+0x1bc>
     170:	00000097          	auipc	ra,0x0
     174:	e90080e7          	jalr	-368(ra) # 0 <err>

0000000000000178 <mmap_test>:

void
mmap_test(void)
{
     178:	7139                	addi	sp,sp,-64
     17a:	fc06                	sd	ra,56(sp)
     17c:	f822                	sd	s0,48(sp)
     17e:	f426                	sd	s1,40(sp)
     180:	f04a                	sd	s2,32(sp)
     182:	ec4e                	sd	s3,24(sp)
     184:	e852                	sd	s4,16(sp)
     186:	0080                	addi	s0,sp,64
  int fd;
  int i;
  const char * const f = "mmap.dur";
  printf("mmap_test starting\n");
     188:	00001517          	auipc	a0,0x1
     18c:	00050513          	mv	a0,a0
     190:	00001097          	auipc	ra,0x1
     194:	d7c080e7          	jalr	-644(ra) # f0c <printf>
  testname = "mmap_test";
     198:	00001797          	auipc	a5,0x1
     19c:	00878793          	addi	a5,a5,8 # 11a0 <malloc+0x1dc>
     1a0:	00002717          	auipc	a4,0x2
     1a4:	8ef73c23          	sd	a5,-1800(a4) # 1a98 <testname>
  //
  // create a file with known content, map it into memory, check that
  // the mapped memory has the same bytes as originally written to the
  // file.
  //
  makefile(f);
     1a8:	00001517          	auipc	a0,0x1
     1ac:	00850513          	addi	a0,a0,8 # 11b0 <malloc+0x1ec>
     1b0:	00000097          	auipc	ra,0x0
     1b4:	f0e080e7          	jalr	-242(ra) # be <makefile>
  if ((fd = open(f, O_RDONLY)) == -1)
     1b8:	4581                	li	a1,0
     1ba:	00001517          	auipc	a0,0x1
     1be:	ff650513          	addi	a0,a0,-10 # 11b0 <malloc+0x1ec>
     1c2:	00001097          	auipc	ra,0x1
     1c6:	a12080e7          	jalr	-1518(ra) # bd4 <open>
     1ca:	57fd                	li	a5,-1
     1cc:	3ef50663          	beq	a0,a5,5b8 <mmap_test+0x440>
     1d0:	892a                	mv	s2,a0
    err("open");

  printf("test mmap f\n");
     1d2:	00001517          	auipc	a0,0x1
     1d6:	fee50513          	addi	a0,a0,-18 # 11c0 <malloc+0x1fc>
     1da:	00001097          	auipc	ra,0x1
     1de:	d32080e7          	jalr	-718(ra) # f0c <printf>
  // same file (of course in this case updates are prohibited
  // due to PROT_READ). the fifth argument is the file descriptor
  // of the file to be mapped. the last argument is the starting
  // offset in the file.
  //
  char *p = mmap(0, PGSIZE*2, PROT_READ, MAP_PRIVATE, fd, 0);
     1e2:	4781                	li	a5,0
     1e4:	874a                	mv	a4,s2
     1e6:	4689                	li	a3,2
     1e8:	4605                	li	a2,1
     1ea:	6589                	lui	a1,0x2
     1ec:	4501                	li	a0,0
     1ee:	00001097          	auipc	ra,0x1
     1f2:	a46080e7          	jalr	-1466(ra) # c34 <mmap>
     1f6:	84aa                	mv	s1,a0
  if (p == MAP_FAILED)
     1f8:	57fd                	li	a5,-1
     1fa:	3cf50763          	beq	a0,a5,5c8 <mmap_test+0x450>
    err("mmap (1)");
  _v1(p);
     1fe:	00000097          	auipc	ra,0x0
     202:	e40080e7          	jalr	-448(ra) # 3e <_v1>
  if (munmap(p, PGSIZE*2) == -1)
     206:	6589                	lui	a1,0x2
     208:	8526                	mv	a0,s1
     20a:	00001097          	auipc	ra,0x1
     20e:	a32080e7          	jalr	-1486(ra) # c3c <munmap>
     212:	57fd                	li	a5,-1
     214:	3cf50263          	beq	a0,a5,5d8 <mmap_test+0x460>
    err("munmap (1)");

  printf("test mmap f: OK\n");
     218:	00001517          	auipc	a0,0x1
     21c:	fd850513          	addi	a0,a0,-40 # 11f0 <malloc+0x22c>
     220:	00001097          	auipc	ra,0x1
     224:	cec080e7          	jalr	-788(ra) # f0c <printf>
    
  printf("test mmap private\n");
     228:	00001517          	auipc	a0,0x1
     22c:	fe050513          	addi	a0,a0,-32 # 1208 <malloc+0x244>
     230:	00001097          	auipc	ra,0x1
     234:	cdc080e7          	jalr	-804(ra) # f0c <printf>
  // should be able to map file opened read-only with private writable
  // mapping
  p = mmap(0, PGSIZE*2, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
     238:	4781                	li	a5,0
     23a:	874a                	mv	a4,s2
     23c:	4689                	li	a3,2
     23e:	460d                	li	a2,3
     240:	6589                	lui	a1,0x2
     242:	4501                	li	a0,0
     244:	00001097          	auipc	ra,0x1
     248:	9f0080e7          	jalr	-1552(ra) # c34 <mmap>
     24c:	84aa                	mv	s1,a0
  if (p == MAP_FAILED)
     24e:	57fd                	li	a5,-1
     250:	38f50c63          	beq	a0,a5,5e8 <mmap_test+0x470>
    err("mmap (2)");
  if (close(fd) == -1)
     254:	854a                	mv	a0,s2
     256:	00001097          	auipc	ra,0x1
     25a:	966080e7          	jalr	-1690(ra) # bbc <close>
     25e:	57fd                	li	a5,-1
     260:	38f50c63          	beq	a0,a5,5f8 <mmap_test+0x480>
    err("close");
  _v1(p);
     264:	8526                	mv	a0,s1
     266:	00000097          	auipc	ra,0x0
     26a:	dd8080e7          	jalr	-552(ra) # 3e <_v1>
  for (i = 0; i < PGSIZE*2; i++)
     26e:	87a6                	mv	a5,s1
     270:	6709                	lui	a4,0x2
     272:	9726                	add	a4,a4,s1
    p[i] = 'Z';
     274:	05a00693          	li	a3,90
     278:	00d78023          	sb	a3,0(a5)
  for (i = 0; i < PGSIZE*2; i++)
     27c:	0785                	addi	a5,a5,1
     27e:	fef71de3          	bne	a4,a5,278 <mmap_test+0x100>
  if (munmap(p, PGSIZE*2) == -1)
     282:	6589                	lui	a1,0x2
     284:	8526                	mv	a0,s1
     286:	00001097          	auipc	ra,0x1
     28a:	9b6080e7          	jalr	-1610(ra) # c3c <munmap>
     28e:	57fd                	li	a5,-1
     290:	36f50c63          	beq	a0,a5,608 <mmap_test+0x490>
    err("munmap (2)");

  printf("test mmap private: OK\n");
     294:	00001517          	auipc	a0,0x1
     298:	fac50513          	addi	a0,a0,-84 # 1240 <malloc+0x27c>
     29c:	00001097          	auipc	ra,0x1
     2a0:	c70080e7          	jalr	-912(ra) # f0c <printf>
    
  printf("test mmap read-only\n");
     2a4:	00001517          	auipc	a0,0x1
     2a8:	fb450513          	addi	a0,a0,-76 # 1258 <malloc+0x294>
     2ac:	00001097          	auipc	ra,0x1
     2b0:	c60080e7          	jalr	-928(ra) # f0c <printf>
    
  // check that mmap doesn't allow read/write mapping of a
  // file opened read-only.
  if ((fd = open(f, O_RDONLY)) == -1)
     2b4:	4581                	li	a1,0
     2b6:	00001517          	auipc	a0,0x1
     2ba:	efa50513          	addi	a0,a0,-262 # 11b0 <malloc+0x1ec>
     2be:	00001097          	auipc	ra,0x1
     2c2:	916080e7          	jalr	-1770(ra) # bd4 <open>
     2c6:	84aa                	mv	s1,a0
     2c8:	57fd                	li	a5,-1
     2ca:	34f50763          	beq	a0,a5,618 <mmap_test+0x4a0>
    err("open");
  p = mmap(0, PGSIZE*3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     2ce:	4781                	li	a5,0
     2d0:	872a                	mv	a4,a0
     2d2:	4685                	li	a3,1
     2d4:	460d                	li	a2,3
     2d6:	658d                	lui	a1,0x3
     2d8:	4501                	li	a0,0
     2da:	00001097          	auipc	ra,0x1
     2de:	95a080e7          	jalr	-1702(ra) # c34 <mmap>
  if (p != MAP_FAILED)
     2e2:	57fd                	li	a5,-1
     2e4:	34f51263          	bne	a0,a5,628 <mmap_test+0x4b0>
    err("mmap call should have failed");
  if (close(fd) == -1)
     2e8:	8526                	mv	a0,s1
     2ea:	00001097          	auipc	ra,0x1
     2ee:	8d2080e7          	jalr	-1838(ra) # bbc <close>
     2f2:	57fd                	li	a5,-1
     2f4:	34f50263          	beq	a0,a5,638 <mmap_test+0x4c0>
    err("close");

  printf("test mmap read-only: OK\n");
     2f8:	00001517          	auipc	a0,0x1
     2fc:	f9850513          	addi	a0,a0,-104 # 1290 <malloc+0x2cc>
     300:	00001097          	auipc	ra,0x1
     304:	c0c080e7          	jalr	-1012(ra) # f0c <printf>
    
  printf("test mmap read/write\n");
     308:	00001517          	auipc	a0,0x1
     30c:	fa850513          	addi	a0,a0,-88 # 12b0 <malloc+0x2ec>
     310:	00001097          	auipc	ra,0x1
     314:	bfc080e7          	jalr	-1028(ra) # f0c <printf>
  
  // check that mmap does allow read/write mapping of a
  // file opened read/write.
  if ((fd = open(f, O_RDWR)) == -1)
     318:	4589                	li	a1,2
     31a:	00001517          	auipc	a0,0x1
     31e:	e9650513          	addi	a0,a0,-362 # 11b0 <malloc+0x1ec>
     322:	00001097          	auipc	ra,0x1
     326:	8b2080e7          	jalr	-1870(ra) # bd4 <open>
     32a:	84aa                	mv	s1,a0
     32c:	57fd                	li	a5,-1
     32e:	30f50d63          	beq	a0,a5,648 <mmap_test+0x4d0>
    err("open");
  p = mmap(0, PGSIZE*3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     332:	4781                	li	a5,0
     334:	872a                	mv	a4,a0
     336:	4685                	li	a3,1
     338:	460d                	li	a2,3
     33a:	658d                	lui	a1,0x3
     33c:	4501                	li	a0,0
     33e:	00001097          	auipc	ra,0x1
     342:	8f6080e7          	jalr	-1802(ra) # c34 <mmap>
     346:	89aa                	mv	s3,a0
  if (p == MAP_FAILED)
     348:	57fd                	li	a5,-1
     34a:	30f50763          	beq	a0,a5,658 <mmap_test+0x4e0>
    err("mmap (3)");
  if (close(fd) == -1)
     34e:	8526                	mv	a0,s1
     350:	00001097          	auipc	ra,0x1
     354:	86c080e7          	jalr	-1940(ra) # bbc <close>
     358:	57fd                	li	a5,-1
     35a:	30f50763          	beq	a0,a5,668 <mmap_test+0x4f0>
    err("close");

  // check that the mapping still works after close(fd).
  _v1(p);
     35e:	854e                	mv	a0,s3
     360:	00000097          	auipc	ra,0x0
     364:	cde080e7          	jalr	-802(ra) # 3e <_v1>

  // write the mapped memory.
  for (i = 0; i < PGSIZE*2; i++)
     368:	87ce                	mv	a5,s3
     36a:	6709                	lui	a4,0x2
     36c:	974e                	add	a4,a4,s3
    p[i] = 'Z';
     36e:	05a00693          	li	a3,90
     372:	00d78023          	sb	a3,0(a5)
  for (i = 0; i < PGSIZE*2; i++)
     376:	0785                	addi	a5,a5,1
     378:	fef71de3          	bne	a4,a5,372 <mmap_test+0x1fa>

  // unmap just the first two of three pages of mapped memory.
  if (munmap(p, PGSIZE*2) == -1)
     37c:	6589                	lui	a1,0x2
     37e:	854e                	mv	a0,s3
     380:	00001097          	auipc	ra,0x1
     384:	8bc080e7          	jalr	-1860(ra) # c3c <munmap>
     388:	57fd                	li	a5,-1
     38a:	2ef50763          	beq	a0,a5,678 <mmap_test+0x500>
    err("munmap (3)");
  
  printf("test mmap read/write: OK\n");
     38e:	00001517          	auipc	a0,0x1
     392:	f5a50513          	addi	a0,a0,-166 # 12e8 <malloc+0x324>
     396:	00001097          	auipc	ra,0x1
     39a:	b76080e7          	jalr	-1162(ra) # f0c <printf>
  
  printf("test mmap dirty\n");
     39e:	00001517          	auipc	a0,0x1
     3a2:	f6a50513          	addi	a0,a0,-150 # 1308 <malloc+0x344>
     3a6:	00001097          	auipc	ra,0x1
     3aa:	b66080e7          	jalr	-1178(ra) # f0c <printf>
  
  // check that the writes to the mapped memory were
  // written to the file.
  if ((fd = open(f, O_RDWR)) == -1)
     3ae:	4589                	li	a1,2
     3b0:	00001517          	auipc	a0,0x1
     3b4:	e0050513          	addi	a0,a0,-512 # 11b0 <malloc+0x1ec>
     3b8:	00001097          	auipc	ra,0x1
     3bc:	81c080e7          	jalr	-2020(ra) # bd4 <open>
     3c0:	892a                	mv	s2,a0
     3c2:	57fd                	li	a5,-1
     3c4:	6489                	lui	s1,0x2
     3c6:	80048493          	addi	s1,s1,-2048 # 1800 <digits+0x228>
    err("open");
  for (i = 0; i < PGSIZE + (PGSIZE/2); i++){
    char b;
    if (read(fd, &b, 1) != 1)
      err("read (1)");
    if (b != 'Z')
     3ca:	05a00a13          	li	s4,90
  if ((fd = open(f, O_RDWR)) == -1)
     3ce:	2af50d63          	beq	a0,a5,688 <mmap_test+0x510>
    if (read(fd, &b, 1) != 1)
     3d2:	4605                	li	a2,1
     3d4:	fcf40593          	addi	a1,s0,-49
     3d8:	854a                	mv	a0,s2
     3da:	00000097          	auipc	ra,0x0
     3de:	7d2080e7          	jalr	2002(ra) # bac <read>
     3e2:	4785                	li	a5,1
     3e4:	2af51a63          	bne	a0,a5,698 <mmap_test+0x520>
    if (b != 'Z')
     3e8:	fcf44783          	lbu	a5,-49(s0)
     3ec:	2b479e63          	bne	a5,s4,6a8 <mmap_test+0x530>
  for (i = 0; i < PGSIZE + (PGSIZE/2); i++){
     3f0:	34fd                	addiw	s1,s1,-1
     3f2:	f0e5                	bnez	s1,3d2 <mmap_test+0x25a>
      err("file does not contain modifications");
  }
  if (close(fd) == -1)
     3f4:	854a                	mv	a0,s2
     3f6:	00000097          	auipc	ra,0x0
     3fa:	7c6080e7          	jalr	1990(ra) # bbc <close>
     3fe:	57fd                	li	a5,-1
     400:	2af50c63          	beq	a0,a5,6b8 <mmap_test+0x540>
    err("close");

  printf("test mmap dirty: OK\n");
     404:	00001517          	auipc	a0,0x1
     408:	f5450513          	addi	a0,a0,-172 # 1358 <malloc+0x394>
     40c:	00001097          	auipc	ra,0x1
     410:	b00080e7          	jalr	-1280(ra) # f0c <printf>

  printf("test not-mapped unmap\n");
     414:	00001517          	auipc	a0,0x1
     418:	f5c50513          	addi	a0,a0,-164 # 1370 <malloc+0x3ac>
     41c:	00001097          	auipc	ra,0x1
     420:	af0080e7          	jalr	-1296(ra) # f0c <printf>
  
  // unmap the rest of the mapped memory.
  if (munmap(p+PGSIZE*2, PGSIZE) == -1)
     424:	6585                	lui	a1,0x1
     426:	6509                	lui	a0,0x2
     428:	954e                	add	a0,a0,s3
     42a:	00001097          	auipc	ra,0x1
     42e:	812080e7          	jalr	-2030(ra) # c3c <munmap>
     432:	57fd                	li	a5,-1
     434:	28f50a63          	beq	a0,a5,6c8 <mmap_test+0x550>
    err("munmap (4)");

  printf("test not-mapped unmap: OK\n");
     438:	00001517          	auipc	a0,0x1
     43c:	f6050513          	addi	a0,a0,-160 # 1398 <malloc+0x3d4>
     440:	00001097          	auipc	ra,0x1
     444:	acc080e7          	jalr	-1332(ra) # f0c <printf>
    
  printf("test mmap two files\n");
     448:	00001517          	auipc	a0,0x1
     44c:	f7050513          	addi	a0,a0,-144 # 13b8 <malloc+0x3f4>
     450:	00001097          	auipc	ra,0x1
     454:	abc080e7          	jalr	-1348(ra) # f0c <printf>
  
  //
  // mmap two files at the same time.
  //
  int fd1;
  if((fd1 = open("mmap1", O_RDWR|O_CREATE)) < 0)
     458:	20200593          	li	a1,514
     45c:	00001517          	auipc	a0,0x1
     460:	f7450513          	addi	a0,a0,-140 # 13d0 <malloc+0x40c>
     464:	00000097          	auipc	ra,0x0
     468:	770080e7          	jalr	1904(ra) # bd4 <open>
     46c:	84aa                	mv	s1,a0
     46e:	26054563          	bltz	a0,6d8 <mmap_test+0x560>
    err("open mmap1");
  if(write(fd1, "12345", 5) != 5)
     472:	4615                	li	a2,5
     474:	00001597          	auipc	a1,0x1
     478:	f7458593          	addi	a1,a1,-140 # 13e8 <malloc+0x424>
     47c:	00000097          	auipc	ra,0x0
     480:	738080e7          	jalr	1848(ra) # bb4 <write>
     484:	4795                	li	a5,5
     486:	26f51163          	bne	a0,a5,6e8 <mmap_test+0x570>
    err("write mmap1");
  char *p1 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd1, 0);
     48a:	4781                	li	a5,0
     48c:	8726                	mv	a4,s1
     48e:	4689                	li	a3,2
     490:	4605                	li	a2,1
     492:	6585                	lui	a1,0x1
     494:	4501                	li	a0,0
     496:	00000097          	auipc	ra,0x0
     49a:	79e080e7          	jalr	1950(ra) # c34 <mmap>
     49e:	89aa                	mv	s3,a0
  if(p1 == MAP_FAILED)
     4a0:	57fd                	li	a5,-1
     4a2:	24f50b63          	beq	a0,a5,6f8 <mmap_test+0x580>
    err("mmap mmap1");
  close(fd1);
     4a6:	8526                	mv	a0,s1
     4a8:	00000097          	auipc	ra,0x0
     4ac:	714080e7          	jalr	1812(ra) # bbc <close>
  unlink("mmap1");
     4b0:	00001517          	auipc	a0,0x1
     4b4:	f2050513          	addi	a0,a0,-224 # 13d0 <malloc+0x40c>
     4b8:	00000097          	auipc	ra,0x0
     4bc:	72c080e7          	jalr	1836(ra) # be4 <unlink>

  int fd2;
  if((fd2 = open("mmap2", O_RDWR|O_CREATE)) < 0)
     4c0:	20200593          	li	a1,514
     4c4:	00001517          	auipc	a0,0x1
     4c8:	f4c50513          	addi	a0,a0,-180 # 1410 <malloc+0x44c>
     4cc:	00000097          	auipc	ra,0x0
     4d0:	708080e7          	jalr	1800(ra) # bd4 <open>
     4d4:	892a                	mv	s2,a0
     4d6:	22054963          	bltz	a0,708 <mmap_test+0x590>
    err("open mmap2");
  if(write(fd2, "67890", 5) != 5)
     4da:	4615                	li	a2,5
     4dc:	00001597          	auipc	a1,0x1
     4e0:	f4c58593          	addi	a1,a1,-180 # 1428 <malloc+0x464>
     4e4:	00000097          	auipc	ra,0x0
     4e8:	6d0080e7          	jalr	1744(ra) # bb4 <write>
     4ec:	4795                	li	a5,5
     4ee:	22f51563          	bne	a0,a5,718 <mmap_test+0x5a0>
    err("write mmap2");
  char *p2 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd2, 0);
     4f2:	4781                	li	a5,0
     4f4:	874a                	mv	a4,s2
     4f6:	4689                	li	a3,2
     4f8:	4605                	li	a2,1
     4fa:	6585                	lui	a1,0x1
     4fc:	4501                	li	a0,0
     4fe:	00000097          	auipc	ra,0x0
     502:	736080e7          	jalr	1846(ra) # c34 <mmap>
     506:	84aa                	mv	s1,a0
  if(p2 == MAP_FAILED)
     508:	57fd                	li	a5,-1
     50a:	20f50f63          	beq	a0,a5,728 <mmap_test+0x5b0>
    err("mmap mmap2");
  close(fd2);
     50e:	854a                	mv	a0,s2
     510:	00000097          	auipc	ra,0x0
     514:	6ac080e7          	jalr	1708(ra) # bbc <close>
  unlink("mmap2");
     518:	00001517          	auipc	a0,0x1
     51c:	ef850513          	addi	a0,a0,-264 # 1410 <malloc+0x44c>
     520:	00000097          	auipc	ra,0x0
     524:	6c4080e7          	jalr	1732(ra) # be4 <unlink>

  if(memcmp(p1, "12345", 5) != 0)
     528:	4615                	li	a2,5
     52a:	00001597          	auipc	a1,0x1
     52e:	ebe58593          	addi	a1,a1,-322 # 13e8 <malloc+0x424>
     532:	854e                	mv	a0,s3
     534:	00000097          	auipc	ra,0x0
     538:	606080e7          	jalr	1542(ra) # b3a <memcmp>
     53c:	1e051e63          	bnez	a0,738 <mmap_test+0x5c0>
    err("mmap1 mismatch");
  if(memcmp(p2, "67890", 5) != 0)
     540:	4615                	li	a2,5
     542:	00001597          	auipc	a1,0x1
     546:	ee658593          	addi	a1,a1,-282 # 1428 <malloc+0x464>
     54a:	8526                	mv	a0,s1
     54c:	00000097          	auipc	ra,0x0
     550:	5ee080e7          	jalr	1518(ra) # b3a <memcmp>
     554:	1e051a63          	bnez	a0,748 <mmap_test+0x5d0>
    err("mmap2 mismatch");

  munmap(p1, PGSIZE);
     558:	6585                	lui	a1,0x1
     55a:	854e                	mv	a0,s3
     55c:	00000097          	auipc	ra,0x0
     560:	6e0080e7          	jalr	1760(ra) # c3c <munmap>
  if(memcmp(p2, "67890", 5) != 0)
     564:	4615                	li	a2,5
     566:	00001597          	auipc	a1,0x1
     56a:	ec258593          	addi	a1,a1,-318 # 1428 <malloc+0x464>
     56e:	8526                	mv	a0,s1
     570:	00000097          	auipc	ra,0x0
     574:	5ca080e7          	jalr	1482(ra) # b3a <memcmp>
     578:	1e051063          	bnez	a0,758 <mmap_test+0x5e0>
    err("mmap2 mismatch (2)");
  munmap(p2, PGSIZE);
     57c:	6585                	lui	a1,0x1
     57e:	8526                	mv	a0,s1
     580:	00000097          	auipc	ra,0x0
     584:	6bc080e7          	jalr	1724(ra) # c3c <munmap>
  
  printf("test mmap two files: OK\n");
     588:	00001517          	auipc	a0,0x1
     58c:	f0050513          	addi	a0,a0,-256 # 1488 <malloc+0x4c4>
     590:	00001097          	auipc	ra,0x1
     594:	97c080e7          	jalr	-1668(ra) # f0c <printf>
  
  printf("mmap_test: ALL OK\n");
     598:	00001517          	auipc	a0,0x1
     59c:	f1050513          	addi	a0,a0,-240 # 14a8 <malloc+0x4e4>
     5a0:	00001097          	auipc	ra,0x1
     5a4:	96c080e7          	jalr	-1684(ra) # f0c <printf>
}
     5a8:	70e2                	ld	ra,56(sp)
     5aa:	7442                	ld	s0,48(sp)
     5ac:	74a2                	ld	s1,40(sp)
     5ae:	7902                	ld	s2,32(sp)
     5b0:	69e2                	ld	s3,24(sp)
     5b2:	6a42                	ld	s4,16(sp)
     5b4:	6121                	addi	sp,sp,64
     5b6:	8082                	ret
    err("open");
     5b8:	00001517          	auipc	a0,0x1
     5bc:	ba850513          	addi	a0,a0,-1112 # 1160 <malloc+0x19c>
     5c0:	00000097          	auipc	ra,0x0
     5c4:	a40080e7          	jalr	-1472(ra) # 0 <err>
    err("mmap (1)");
     5c8:	00001517          	auipc	a0,0x1
     5cc:	c0850513          	addi	a0,a0,-1016 # 11d0 <malloc+0x20c>
     5d0:	00000097          	auipc	ra,0x0
     5d4:	a30080e7          	jalr	-1488(ra) # 0 <err>
    err("munmap (1)");
     5d8:	00001517          	auipc	a0,0x1
     5dc:	c0850513          	addi	a0,a0,-1016 # 11e0 <malloc+0x21c>
     5e0:	00000097          	auipc	ra,0x0
     5e4:	a20080e7          	jalr	-1504(ra) # 0 <err>
    err("mmap (2)");
     5e8:	00001517          	auipc	a0,0x1
     5ec:	c3850513          	addi	a0,a0,-968 # 1220 <malloc+0x25c>
     5f0:	00000097          	auipc	ra,0x0
     5f4:	a10080e7          	jalr	-1520(ra) # 0 <err>
    err("close");
     5f8:	00001517          	auipc	a0,0x1
     5fc:	b8850513          	addi	a0,a0,-1144 # 1180 <malloc+0x1bc>
     600:	00000097          	auipc	ra,0x0
     604:	a00080e7          	jalr	-1536(ra) # 0 <err>
    err("munmap (2)");
     608:	00001517          	auipc	a0,0x1
     60c:	c2850513          	addi	a0,a0,-984 # 1230 <malloc+0x26c>
     610:	00000097          	auipc	ra,0x0
     614:	9f0080e7          	jalr	-1552(ra) # 0 <err>
    err("open");
     618:	00001517          	auipc	a0,0x1
     61c:	b4850513          	addi	a0,a0,-1208 # 1160 <malloc+0x19c>
     620:	00000097          	auipc	ra,0x0
     624:	9e0080e7          	jalr	-1568(ra) # 0 <err>
    err("mmap call should have failed");
     628:	00001517          	auipc	a0,0x1
     62c:	c4850513          	addi	a0,a0,-952 # 1270 <malloc+0x2ac>
     630:	00000097          	auipc	ra,0x0
     634:	9d0080e7          	jalr	-1584(ra) # 0 <err>
    err("close");
     638:	00001517          	auipc	a0,0x1
     63c:	b4850513          	addi	a0,a0,-1208 # 1180 <malloc+0x1bc>
     640:	00000097          	auipc	ra,0x0
     644:	9c0080e7          	jalr	-1600(ra) # 0 <err>
    err("open");
     648:	00001517          	auipc	a0,0x1
     64c:	b1850513          	addi	a0,a0,-1256 # 1160 <malloc+0x19c>
     650:	00000097          	auipc	ra,0x0
     654:	9b0080e7          	jalr	-1616(ra) # 0 <err>
    err("mmap (3)");
     658:	00001517          	auipc	a0,0x1
     65c:	c7050513          	addi	a0,a0,-912 # 12c8 <malloc+0x304>
     660:	00000097          	auipc	ra,0x0
     664:	9a0080e7          	jalr	-1632(ra) # 0 <err>
    err("close");
     668:	00001517          	auipc	a0,0x1
     66c:	b1850513          	addi	a0,a0,-1256 # 1180 <malloc+0x1bc>
     670:	00000097          	auipc	ra,0x0
     674:	990080e7          	jalr	-1648(ra) # 0 <err>
    err("munmap (3)");
     678:	00001517          	auipc	a0,0x1
     67c:	c6050513          	addi	a0,a0,-928 # 12d8 <malloc+0x314>
     680:	00000097          	auipc	ra,0x0
     684:	980080e7          	jalr	-1664(ra) # 0 <err>
    err("open");
     688:	00001517          	auipc	a0,0x1
     68c:	ad850513          	addi	a0,a0,-1320 # 1160 <malloc+0x19c>
     690:	00000097          	auipc	ra,0x0
     694:	970080e7          	jalr	-1680(ra) # 0 <err>
      err("read (1)");
     698:	00001517          	auipc	a0,0x1
     69c:	c8850513          	addi	a0,a0,-888 # 1320 <malloc+0x35c>
     6a0:	00000097          	auipc	ra,0x0
     6a4:	960080e7          	jalr	-1696(ra) # 0 <err>
      err("file does not contain modifications");
     6a8:	00001517          	auipc	a0,0x1
     6ac:	c8850513          	addi	a0,a0,-888 # 1330 <malloc+0x36c>
     6b0:	00000097          	auipc	ra,0x0
     6b4:	950080e7          	jalr	-1712(ra) # 0 <err>
    err("close");
     6b8:	00001517          	auipc	a0,0x1
     6bc:	ac850513          	addi	a0,a0,-1336 # 1180 <malloc+0x1bc>
     6c0:	00000097          	auipc	ra,0x0
     6c4:	940080e7          	jalr	-1728(ra) # 0 <err>
    err("munmap (4)");
     6c8:	00001517          	auipc	a0,0x1
     6cc:	cc050513          	addi	a0,a0,-832 # 1388 <malloc+0x3c4>
     6d0:	00000097          	auipc	ra,0x0
     6d4:	930080e7          	jalr	-1744(ra) # 0 <err>
    err("open mmap1");
     6d8:	00001517          	auipc	a0,0x1
     6dc:	d0050513          	addi	a0,a0,-768 # 13d8 <malloc+0x414>
     6e0:	00000097          	auipc	ra,0x0
     6e4:	920080e7          	jalr	-1760(ra) # 0 <err>
    err("write mmap1");
     6e8:	00001517          	auipc	a0,0x1
     6ec:	d0850513          	addi	a0,a0,-760 # 13f0 <malloc+0x42c>
     6f0:	00000097          	auipc	ra,0x0
     6f4:	910080e7          	jalr	-1776(ra) # 0 <err>
    err("mmap mmap1");
     6f8:	00001517          	auipc	a0,0x1
     6fc:	d0850513          	addi	a0,a0,-760 # 1400 <malloc+0x43c>
     700:	00000097          	auipc	ra,0x0
     704:	900080e7          	jalr	-1792(ra) # 0 <err>
    err("open mmap2");
     708:	00001517          	auipc	a0,0x1
     70c:	d1050513          	addi	a0,a0,-752 # 1418 <malloc+0x454>
     710:	00000097          	auipc	ra,0x0
     714:	8f0080e7          	jalr	-1808(ra) # 0 <err>
    err("write mmap2");
     718:	00001517          	auipc	a0,0x1
     71c:	d1850513          	addi	a0,a0,-744 # 1430 <malloc+0x46c>
     720:	00000097          	auipc	ra,0x0
     724:	8e0080e7          	jalr	-1824(ra) # 0 <err>
    err("mmap mmap2");
     728:	00001517          	auipc	a0,0x1
     72c:	d1850513          	addi	a0,a0,-744 # 1440 <malloc+0x47c>
     730:	00000097          	auipc	ra,0x0
     734:	8d0080e7          	jalr	-1840(ra) # 0 <err>
    err("mmap1 mismatch");
     738:	00001517          	auipc	a0,0x1
     73c:	d1850513          	addi	a0,a0,-744 # 1450 <malloc+0x48c>
     740:	00000097          	auipc	ra,0x0
     744:	8c0080e7          	jalr	-1856(ra) # 0 <err>
    err("mmap2 mismatch");
     748:	00001517          	auipc	a0,0x1
     74c:	d1850513          	addi	a0,a0,-744 # 1460 <malloc+0x49c>
     750:	00000097          	auipc	ra,0x0
     754:	8b0080e7          	jalr	-1872(ra) # 0 <err>
    err("mmap2 mismatch (2)");
     758:	00001517          	auipc	a0,0x1
     75c:	d1850513          	addi	a0,a0,-744 # 1470 <malloc+0x4ac>
     760:	00000097          	auipc	ra,0x0
     764:	8a0080e7          	jalr	-1888(ra) # 0 <err>

0000000000000768 <fork_test>:
// mmap a file, then fork.
// check that the child sees the mapped file.
//
void
fork_test(void)
{
     768:	7179                	addi	sp,sp,-48
     76a:	f406                	sd	ra,40(sp)
     76c:	f022                	sd	s0,32(sp)
     76e:	ec26                	sd	s1,24(sp)
     770:	e84a                	sd	s2,16(sp)
     772:	1800                	addi	s0,sp,48
  int fd;
  int pid;
  const char * const f = "mmap.dur";
  
  printf("fork_test starting\n");
     774:	00001517          	auipc	a0,0x1
     778:	d4c50513          	addi	a0,a0,-692 # 14c0 <malloc+0x4fc>
     77c:	00000097          	auipc	ra,0x0
     780:	790080e7          	jalr	1936(ra) # f0c <printf>
  testname = "fork_test";
     784:	00001797          	auipc	a5,0x1
     788:	d5478793          	addi	a5,a5,-684 # 14d8 <malloc+0x514>
     78c:	00001717          	auipc	a4,0x1
     790:	30f73623          	sd	a5,780(a4) # 1a98 <testname>
  
  // mmap the file twice.
  makefile(f);
     794:	00001517          	auipc	a0,0x1
     798:	a1c50513          	addi	a0,a0,-1508 # 11b0 <malloc+0x1ec>
     79c:	00000097          	auipc	ra,0x0
     7a0:	922080e7          	jalr	-1758(ra) # be <makefile>
  if ((fd = open(f, O_RDONLY)) == -1)
     7a4:	4581                	li	a1,0
     7a6:	00001517          	auipc	a0,0x1
     7aa:	a0a50513          	addi	a0,a0,-1526 # 11b0 <malloc+0x1ec>
     7ae:	00000097          	auipc	ra,0x0
     7b2:	426080e7          	jalr	1062(ra) # bd4 <open>
     7b6:	57fd                	li	a5,-1
     7b8:	0af50a63          	beq	a0,a5,86c <fork_test+0x104>
     7bc:	84aa                	mv	s1,a0
    err("open");
  unlink(f);
     7be:	00001517          	auipc	a0,0x1
     7c2:	9f250513          	addi	a0,a0,-1550 # 11b0 <malloc+0x1ec>
     7c6:	00000097          	auipc	ra,0x0
     7ca:	41e080e7          	jalr	1054(ra) # be4 <unlink>
  char *p1 = mmap(0, PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
     7ce:	4781                	li	a5,0
     7d0:	8726                	mv	a4,s1
     7d2:	4685                	li	a3,1
     7d4:	4605                	li	a2,1
     7d6:	6589                	lui	a1,0x2
     7d8:	4501                	li	a0,0
     7da:	00000097          	auipc	ra,0x0
     7de:	45a080e7          	jalr	1114(ra) # c34 <mmap>
     7e2:	892a                	mv	s2,a0
  if (p1 == MAP_FAILED)
     7e4:	57fd                	li	a5,-1
     7e6:	08f50b63          	beq	a0,a5,87c <fork_test+0x114>
    err("mmap (4)");
  char *p2 = mmap(0, PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
     7ea:	4781                	li	a5,0
     7ec:	8726                	mv	a4,s1
     7ee:	4685                	li	a3,1
     7f0:	4605                	li	a2,1
     7f2:	6589                	lui	a1,0x2
     7f4:	4501                	li	a0,0
     7f6:	00000097          	auipc	ra,0x0
     7fa:	43e080e7          	jalr	1086(ra) # c34 <mmap>
     7fe:	84aa                	mv	s1,a0
  if (p2 == MAP_FAILED)
     800:	57fd                	li	a5,-1
     802:	08f50563          	beq	a0,a5,88c <fork_test+0x124>
    err("mmap (5)");

  // read just 2nd page.
  if(*(p1+PGSIZE) != 'A')
     806:	6785                	lui	a5,0x1
     808:	97ca                	add	a5,a5,s2
     80a:	0007c703          	lbu	a4,0(a5) # 1000 <malloc+0x3c>
     80e:	04100793          	li	a5,65
     812:	08f71563          	bne	a4,a5,89c <fork_test+0x134>
    err("fork mismatch (1)");

  if((pid = fork()) < 0)
     816:	00000097          	auipc	ra,0x0
     81a:	376080e7          	jalr	886(ra) # b8c <fork>
     81e:	08054763          	bltz	a0,8ac <fork_test+0x144>
    err("fork");
  if (pid == 0) {
     822:	cd49                	beqz	a0,8bc <fork_test+0x154>
    _v1(p1);
    munmap(p1, PGSIZE); // just the first page
    exit(0); // tell the parent that the mapping looks OK.
  }

  int status = -1;
     824:	57fd                	li	a5,-1
     826:	fcf42e23          	sw	a5,-36(s0)
  wait(&status);
     82a:	fdc40513          	addi	a0,s0,-36
     82e:	00000097          	auipc	ra,0x0
     832:	36e080e7          	jalr	878(ra) # b9c <wait>

  if(status != 0){
     836:	fdc42783          	lw	a5,-36(s0)
     83a:	e3cd                	bnez	a5,8dc <fork_test+0x174>
    printf("fork_test failed\n");
    exit(1);
  }

  // check that the parent's mappings are still there.
  _v1(p1);
     83c:	854a                	mv	a0,s2
     83e:	00000097          	auipc	ra,0x0
     842:	800080e7          	jalr	-2048(ra) # 3e <_v1>
  _v1(p2);
     846:	8526                	mv	a0,s1
     848:	fffff097          	auipc	ra,0xfffff
     84c:	7f6080e7          	jalr	2038(ra) # 3e <_v1>

  printf("fork_test OK\n");
     850:	00001517          	auipc	a0,0x1
     854:	cf050513          	addi	a0,a0,-784 # 1540 <malloc+0x57c>
     858:	00000097          	auipc	ra,0x0
     85c:	6b4080e7          	jalr	1716(ra) # f0c <printf>
}
     860:	70a2                	ld	ra,40(sp)
     862:	7402                	ld	s0,32(sp)
     864:	64e2                	ld	s1,24(sp)
     866:	6942                	ld	s2,16(sp)
     868:	6145                	addi	sp,sp,48
     86a:	8082                	ret
    err("open");
     86c:	00001517          	auipc	a0,0x1
     870:	8f450513          	addi	a0,a0,-1804 # 1160 <malloc+0x19c>
     874:	fffff097          	auipc	ra,0xfffff
     878:	78c080e7          	jalr	1932(ra) # 0 <err>
    err("mmap (4)");
     87c:	00001517          	auipc	a0,0x1
     880:	c6c50513          	addi	a0,a0,-916 # 14e8 <malloc+0x524>
     884:	fffff097          	auipc	ra,0xfffff
     888:	77c080e7          	jalr	1916(ra) # 0 <err>
    err("mmap (5)");
     88c:	00001517          	auipc	a0,0x1
     890:	c6c50513          	addi	a0,a0,-916 # 14f8 <malloc+0x534>
     894:	fffff097          	auipc	ra,0xfffff
     898:	76c080e7          	jalr	1900(ra) # 0 <err>
    err("fork mismatch (1)");
     89c:	00001517          	auipc	a0,0x1
     8a0:	c6c50513          	addi	a0,a0,-916 # 1508 <malloc+0x544>
     8a4:	fffff097          	auipc	ra,0xfffff
     8a8:	75c080e7          	jalr	1884(ra) # 0 <err>
    err("fork");
     8ac:	00001517          	auipc	a0,0x1
     8b0:	c7450513          	addi	a0,a0,-908 # 1520 <malloc+0x55c>
     8b4:	fffff097          	auipc	ra,0xfffff
     8b8:	74c080e7          	jalr	1868(ra) # 0 <err>
    _v1(p1);
     8bc:	854a                	mv	a0,s2
     8be:	fffff097          	auipc	ra,0xfffff
     8c2:	780080e7          	jalr	1920(ra) # 3e <_v1>
    munmap(p1, PGSIZE); // just the first page
     8c6:	6585                	lui	a1,0x1
     8c8:	854a                	mv	a0,s2
     8ca:	00000097          	auipc	ra,0x0
     8ce:	372080e7          	jalr	882(ra) # c3c <munmap>
    exit(0); // tell the parent that the mapping looks OK.
     8d2:	4501                	li	a0,0
     8d4:	00000097          	auipc	ra,0x0
     8d8:	2c0080e7          	jalr	704(ra) # b94 <exit>
    printf("fork_test failed\n");
     8dc:	00001517          	auipc	a0,0x1
     8e0:	c4c50513          	addi	a0,a0,-948 # 1528 <malloc+0x564>
     8e4:	00000097          	auipc	ra,0x0
     8e8:	628080e7          	jalr	1576(ra) # f0c <printf>
    exit(1);
     8ec:	4505                	li	a0,1
     8ee:	00000097          	auipc	ra,0x0
     8f2:	2a6080e7          	jalr	678(ra) # b94 <exit>

00000000000008f6 <main>:
{
     8f6:	1141                	addi	sp,sp,-16
     8f8:	e406                	sd	ra,8(sp)
     8fa:	e022                	sd	s0,0(sp)
     8fc:	0800                	addi	s0,sp,16
  mmap_test();
     8fe:	00000097          	auipc	ra,0x0
     902:	87a080e7          	jalr	-1926(ra) # 178 <mmap_test>
  fork_test();
     906:	00000097          	auipc	ra,0x0
     90a:	e62080e7          	jalr	-414(ra) # 768 <fork_test>
  printf("mmaptest: all tests succeeded\n");
     90e:	00001517          	auipc	a0,0x1
     912:	c4250513          	addi	a0,a0,-958 # 1550 <malloc+0x58c>
     916:	00000097          	auipc	ra,0x0
     91a:	5f6080e7          	jalr	1526(ra) # f0c <printf>
  exit(0);
     91e:	4501                	li	a0,0
     920:	00000097          	auipc	ra,0x0
     924:	274080e7          	jalr	628(ra) # b94 <exit>

0000000000000928 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     928:	1141                	addi	sp,sp,-16
     92a:	e422                	sd	s0,8(sp)
     92c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     92e:	87aa                	mv	a5,a0
     930:	0585                	addi	a1,a1,1 # 1001 <malloc+0x3d>
     932:	0785                	addi	a5,a5,1
     934:	fff5c703          	lbu	a4,-1(a1)
     938:	fee78fa3          	sb	a4,-1(a5)
     93c:	fb75                	bnez	a4,930 <strcpy+0x8>
    ;
  return os;
}
     93e:	6422                	ld	s0,8(sp)
     940:	0141                	addi	sp,sp,16
     942:	8082                	ret

0000000000000944 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     944:	1141                	addi	sp,sp,-16
     946:	e422                	sd	s0,8(sp)
     948:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     94a:	00054783          	lbu	a5,0(a0)
     94e:	cb91                	beqz	a5,962 <strcmp+0x1e>
     950:	0005c703          	lbu	a4,0(a1)
     954:	00f71763          	bne	a4,a5,962 <strcmp+0x1e>
    p++, q++;
     958:	0505                	addi	a0,a0,1
     95a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     95c:	00054783          	lbu	a5,0(a0)
     960:	fbe5                	bnez	a5,950 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     962:	0005c503          	lbu	a0,0(a1)
}
     966:	40a7853b          	subw	a0,a5,a0
     96a:	6422                	ld	s0,8(sp)
     96c:	0141                	addi	sp,sp,16
     96e:	8082                	ret

0000000000000970 <strlen>:

uint
strlen(const char *s)
{
     970:	1141                	addi	sp,sp,-16
     972:	e422                	sd	s0,8(sp)
     974:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     976:	00054783          	lbu	a5,0(a0)
     97a:	cf91                	beqz	a5,996 <strlen+0x26>
     97c:	0505                	addi	a0,a0,1
     97e:	87aa                	mv	a5,a0
     980:	86be                	mv	a3,a5
     982:	0785                	addi	a5,a5,1
     984:	fff7c703          	lbu	a4,-1(a5)
     988:	ff65                	bnez	a4,980 <strlen+0x10>
     98a:	40a6853b          	subw	a0,a3,a0
     98e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     990:	6422                	ld	s0,8(sp)
     992:	0141                	addi	sp,sp,16
     994:	8082                	ret
  for(n = 0; s[n]; n++)
     996:	4501                	li	a0,0
     998:	bfe5                	j	990 <strlen+0x20>

000000000000099a <memset>:

void*
memset(void *dst, int c, uint n)
{
     99a:	1141                	addi	sp,sp,-16
     99c:	e422                	sd	s0,8(sp)
     99e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     9a0:	ca19                	beqz	a2,9b6 <memset+0x1c>
     9a2:	87aa                	mv	a5,a0
     9a4:	1602                	slli	a2,a2,0x20
     9a6:	9201                	srli	a2,a2,0x20
     9a8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     9ac:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     9b0:	0785                	addi	a5,a5,1
     9b2:	fee79de3          	bne	a5,a4,9ac <memset+0x12>
  }
  return dst;
}
     9b6:	6422                	ld	s0,8(sp)
     9b8:	0141                	addi	sp,sp,16
     9ba:	8082                	ret

00000000000009bc <strchr>:

char*
strchr(const char *s, char c)
{
     9bc:	1141                	addi	sp,sp,-16
     9be:	e422                	sd	s0,8(sp)
     9c0:	0800                	addi	s0,sp,16
  for(; *s; s++)
     9c2:	00054783          	lbu	a5,0(a0)
     9c6:	cb99                	beqz	a5,9dc <strchr+0x20>
    if(*s == c)
     9c8:	00f58763          	beq	a1,a5,9d6 <strchr+0x1a>
  for(; *s; s++)
     9cc:	0505                	addi	a0,a0,1
     9ce:	00054783          	lbu	a5,0(a0)
     9d2:	fbfd                	bnez	a5,9c8 <strchr+0xc>
      return (char*)s;
  return 0;
     9d4:	4501                	li	a0,0
}
     9d6:	6422                	ld	s0,8(sp)
     9d8:	0141                	addi	sp,sp,16
     9da:	8082                	ret
  return 0;
     9dc:	4501                	li	a0,0
     9de:	bfe5                	j	9d6 <strchr+0x1a>

00000000000009e0 <gets>:

char*
gets(char *buf, int max)
{
     9e0:	711d                	addi	sp,sp,-96
     9e2:	ec86                	sd	ra,88(sp)
     9e4:	e8a2                	sd	s0,80(sp)
     9e6:	e4a6                	sd	s1,72(sp)
     9e8:	e0ca                	sd	s2,64(sp)
     9ea:	fc4e                	sd	s3,56(sp)
     9ec:	f852                	sd	s4,48(sp)
     9ee:	f456                	sd	s5,40(sp)
     9f0:	f05a                	sd	s6,32(sp)
     9f2:	ec5e                	sd	s7,24(sp)
     9f4:	1080                	addi	s0,sp,96
     9f6:	8baa                	mv	s7,a0
     9f8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     9fa:	892a                	mv	s2,a0
     9fc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     9fe:	4aa9                	li	s5,10
     a00:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     a02:	89a6                	mv	s3,s1
     a04:	2485                	addiw	s1,s1,1
     a06:	0344d863          	bge	s1,s4,a36 <gets+0x56>
    cc = read(0, &c, 1);
     a0a:	4605                	li	a2,1
     a0c:	faf40593          	addi	a1,s0,-81
     a10:	4501                	li	a0,0
     a12:	00000097          	auipc	ra,0x0
     a16:	19a080e7          	jalr	410(ra) # bac <read>
    if(cc < 1)
     a1a:	00a05e63          	blez	a0,a36 <gets+0x56>
    buf[i++] = c;
     a1e:	faf44783          	lbu	a5,-81(s0)
     a22:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     a26:	01578763          	beq	a5,s5,a34 <gets+0x54>
     a2a:	0905                	addi	s2,s2,1
     a2c:	fd679be3          	bne	a5,s6,a02 <gets+0x22>
    buf[i++] = c;
     a30:	89a6                	mv	s3,s1
     a32:	a011                	j	a36 <gets+0x56>
     a34:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     a36:	99de                	add	s3,s3,s7
     a38:	00098023          	sb	zero,0(s3)
  return buf;
}
     a3c:	855e                	mv	a0,s7
     a3e:	60e6                	ld	ra,88(sp)
     a40:	6446                	ld	s0,80(sp)
     a42:	64a6                	ld	s1,72(sp)
     a44:	6906                	ld	s2,64(sp)
     a46:	79e2                	ld	s3,56(sp)
     a48:	7a42                	ld	s4,48(sp)
     a4a:	7aa2                	ld	s5,40(sp)
     a4c:	7b02                	ld	s6,32(sp)
     a4e:	6be2                	ld	s7,24(sp)
     a50:	6125                	addi	sp,sp,96
     a52:	8082                	ret

0000000000000a54 <stat>:

int
stat(const char *n, struct stat *st)
{
     a54:	1101                	addi	sp,sp,-32
     a56:	ec06                	sd	ra,24(sp)
     a58:	e822                	sd	s0,16(sp)
     a5a:	e04a                	sd	s2,0(sp)
     a5c:	1000                	addi	s0,sp,32
     a5e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a60:	4581                	li	a1,0
     a62:	00000097          	auipc	ra,0x0
     a66:	172080e7          	jalr	370(ra) # bd4 <open>
  if(fd < 0)
     a6a:	02054663          	bltz	a0,a96 <stat+0x42>
     a6e:	e426                	sd	s1,8(sp)
     a70:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a72:	85ca                	mv	a1,s2
     a74:	00000097          	auipc	ra,0x0
     a78:	178080e7          	jalr	376(ra) # bec <fstat>
     a7c:	892a                	mv	s2,a0
  close(fd);
     a7e:	8526                	mv	a0,s1
     a80:	00000097          	auipc	ra,0x0
     a84:	13c080e7          	jalr	316(ra) # bbc <close>
  return r;
     a88:	64a2                	ld	s1,8(sp)
}
     a8a:	854a                	mv	a0,s2
     a8c:	60e2                	ld	ra,24(sp)
     a8e:	6442                	ld	s0,16(sp)
     a90:	6902                	ld	s2,0(sp)
     a92:	6105                	addi	sp,sp,32
     a94:	8082                	ret
    return -1;
     a96:	597d                	li	s2,-1
     a98:	bfcd                	j	a8a <stat+0x36>

0000000000000a9a <atoi>:

int
atoi(const char *s)
{
     a9a:	1141                	addi	sp,sp,-16
     a9c:	e422                	sd	s0,8(sp)
     a9e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     aa0:	00054683          	lbu	a3,0(a0)
     aa4:	fd06879b          	addiw	a5,a3,-48 # 1fd0 <__BSS_END__+0x118>
     aa8:	0ff7f793          	zext.b	a5,a5
     aac:	4625                	li	a2,9
     aae:	02f66863          	bltu	a2,a5,ade <atoi+0x44>
     ab2:	872a                	mv	a4,a0
  n = 0;
     ab4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     ab6:	0705                	addi	a4,a4,1
     ab8:	0025179b          	slliw	a5,a0,0x2
     abc:	9fa9                	addw	a5,a5,a0
     abe:	0017979b          	slliw	a5,a5,0x1
     ac2:	9fb5                	addw	a5,a5,a3
     ac4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     ac8:	00074683          	lbu	a3,0(a4)
     acc:	fd06879b          	addiw	a5,a3,-48
     ad0:	0ff7f793          	zext.b	a5,a5
     ad4:	fef671e3          	bgeu	a2,a5,ab6 <atoi+0x1c>
  return n;
}
     ad8:	6422                	ld	s0,8(sp)
     ada:	0141                	addi	sp,sp,16
     adc:	8082                	ret
  n = 0;
     ade:	4501                	li	a0,0
     ae0:	bfe5                	j	ad8 <atoi+0x3e>

0000000000000ae2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     ae2:	1141                	addi	sp,sp,-16
     ae4:	e422                	sd	s0,8(sp)
     ae6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     ae8:	02b57463          	bgeu	a0,a1,b10 <memmove+0x2e>
    while(n-- > 0)
     aec:	00c05f63          	blez	a2,b0a <memmove+0x28>
     af0:	1602                	slli	a2,a2,0x20
     af2:	9201                	srli	a2,a2,0x20
     af4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     af8:	872a                	mv	a4,a0
      *dst++ = *src++;
     afa:	0585                	addi	a1,a1,1
     afc:	0705                	addi	a4,a4,1
     afe:	fff5c683          	lbu	a3,-1(a1)
     b02:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b06:	fef71ae3          	bne	a4,a5,afa <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b0a:	6422                	ld	s0,8(sp)
     b0c:	0141                	addi	sp,sp,16
     b0e:	8082                	ret
    dst += n;
     b10:	00c50733          	add	a4,a0,a2
    src += n;
     b14:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     b16:	fec05ae3          	blez	a2,b0a <memmove+0x28>
     b1a:	fff6079b          	addiw	a5,a2,-1
     b1e:	1782                	slli	a5,a5,0x20
     b20:	9381                	srli	a5,a5,0x20
     b22:	fff7c793          	not	a5,a5
     b26:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b28:	15fd                	addi	a1,a1,-1
     b2a:	177d                	addi	a4,a4,-1
     b2c:	0005c683          	lbu	a3,0(a1)
     b30:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     b34:	fee79ae3          	bne	a5,a4,b28 <memmove+0x46>
     b38:	bfc9                	j	b0a <memmove+0x28>

0000000000000b3a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     b3a:	1141                	addi	sp,sp,-16
     b3c:	e422                	sd	s0,8(sp)
     b3e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     b40:	ca05                	beqz	a2,b70 <memcmp+0x36>
     b42:	fff6069b          	addiw	a3,a2,-1
     b46:	1682                	slli	a3,a3,0x20
     b48:	9281                	srli	a3,a3,0x20
     b4a:	0685                	addi	a3,a3,1
     b4c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     b4e:	00054783          	lbu	a5,0(a0)
     b52:	0005c703          	lbu	a4,0(a1)
     b56:	00e79863          	bne	a5,a4,b66 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     b5a:	0505                	addi	a0,a0,1
    p2++;
     b5c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b5e:	fed518e3          	bne	a0,a3,b4e <memcmp+0x14>
  }
  return 0;
     b62:	4501                	li	a0,0
     b64:	a019                	j	b6a <memcmp+0x30>
      return *p1 - *p2;
     b66:	40e7853b          	subw	a0,a5,a4
}
     b6a:	6422                	ld	s0,8(sp)
     b6c:	0141                	addi	sp,sp,16
     b6e:	8082                	ret
  return 0;
     b70:	4501                	li	a0,0
     b72:	bfe5                	j	b6a <memcmp+0x30>

0000000000000b74 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b74:	1141                	addi	sp,sp,-16
     b76:	e406                	sd	ra,8(sp)
     b78:	e022                	sd	s0,0(sp)
     b7a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b7c:	00000097          	auipc	ra,0x0
     b80:	f66080e7          	jalr	-154(ra) # ae2 <memmove>
}
     b84:	60a2                	ld	ra,8(sp)
     b86:	6402                	ld	s0,0(sp)
     b88:	0141                	addi	sp,sp,16
     b8a:	8082                	ret

0000000000000b8c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b8c:	4885                	li	a7,1
 ecall
     b8e:	00000073          	ecall
 ret
     b92:	8082                	ret

0000000000000b94 <exit>:
.global exit
exit:
 li a7, SYS_exit
     b94:	4889                	li	a7,2
 ecall
     b96:	00000073          	ecall
 ret
     b9a:	8082                	ret

0000000000000b9c <wait>:
.global wait
wait:
 li a7, SYS_wait
     b9c:	488d                	li	a7,3
 ecall
     b9e:	00000073          	ecall
 ret
     ba2:	8082                	ret

0000000000000ba4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     ba4:	4891                	li	a7,4
 ecall
     ba6:	00000073          	ecall
 ret
     baa:	8082                	ret

0000000000000bac <read>:
.global read
read:
 li a7, SYS_read
     bac:	4895                	li	a7,5
 ecall
     bae:	00000073          	ecall
 ret
     bb2:	8082                	ret

0000000000000bb4 <write>:
.global write
write:
 li a7, SYS_write
     bb4:	48c1                	li	a7,16
 ecall
     bb6:	00000073          	ecall
 ret
     bba:	8082                	ret

0000000000000bbc <close>:
.global close
close:
 li a7, SYS_close
     bbc:	48d5                	li	a7,21
 ecall
     bbe:	00000073          	ecall
 ret
     bc2:	8082                	ret

0000000000000bc4 <kill>:
.global kill
kill:
 li a7, SYS_kill
     bc4:	4899                	li	a7,6
 ecall
     bc6:	00000073          	ecall
 ret
     bca:	8082                	ret

0000000000000bcc <exec>:
.global exec
exec:
 li a7, SYS_exec
     bcc:	489d                	li	a7,7
 ecall
     bce:	00000073          	ecall
 ret
     bd2:	8082                	ret

0000000000000bd4 <open>:
.global open
open:
 li a7, SYS_open
     bd4:	48bd                	li	a7,15
 ecall
     bd6:	00000073          	ecall
 ret
     bda:	8082                	ret

0000000000000bdc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     bdc:	48c5                	li	a7,17
 ecall
     bde:	00000073          	ecall
 ret
     be2:	8082                	ret

0000000000000be4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     be4:	48c9                	li	a7,18
 ecall
     be6:	00000073          	ecall
 ret
     bea:	8082                	ret

0000000000000bec <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     bec:	48a1                	li	a7,8
 ecall
     bee:	00000073          	ecall
 ret
     bf2:	8082                	ret

0000000000000bf4 <link>:
.global link
link:
 li a7, SYS_link
     bf4:	48cd                	li	a7,19
 ecall
     bf6:	00000073          	ecall
 ret
     bfa:	8082                	ret

0000000000000bfc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     bfc:	48d1                	li	a7,20
 ecall
     bfe:	00000073          	ecall
 ret
     c02:	8082                	ret

0000000000000c04 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c04:	48a5                	li	a7,9
 ecall
     c06:	00000073          	ecall
 ret
     c0a:	8082                	ret

0000000000000c0c <dup>:
.global dup
dup:
 li a7, SYS_dup
     c0c:	48a9                	li	a7,10
 ecall
     c0e:	00000073          	ecall
 ret
     c12:	8082                	ret

0000000000000c14 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c14:	48ad                	li	a7,11
 ecall
     c16:	00000073          	ecall
 ret
     c1a:	8082                	ret

0000000000000c1c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     c1c:	48b1                	li	a7,12
 ecall
     c1e:	00000073          	ecall
 ret
     c22:	8082                	ret

0000000000000c24 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     c24:	48b5                	li	a7,13
 ecall
     c26:	00000073          	ecall
 ret
     c2a:	8082                	ret

0000000000000c2c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c2c:	48b9                	li	a7,14
 ecall
     c2e:	00000073          	ecall
 ret
     c32:	8082                	ret

0000000000000c34 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
     c34:	48d9                	li	a7,22
 ecall
     c36:	00000073          	ecall
 ret
     c3a:	8082                	ret

0000000000000c3c <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
     c3c:	48dd                	li	a7,23
 ecall
     c3e:	00000073          	ecall
 ret
     c42:	8082                	ret

0000000000000c44 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c44:	1101                	addi	sp,sp,-32
     c46:	ec06                	sd	ra,24(sp)
     c48:	e822                	sd	s0,16(sp)
     c4a:	1000                	addi	s0,sp,32
     c4c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c50:	4605                	li	a2,1
     c52:	fef40593          	addi	a1,s0,-17
     c56:	00000097          	auipc	ra,0x0
     c5a:	f5e080e7          	jalr	-162(ra) # bb4 <write>
}
     c5e:	60e2                	ld	ra,24(sp)
     c60:	6442                	ld	s0,16(sp)
     c62:	6105                	addi	sp,sp,32
     c64:	8082                	ret

0000000000000c66 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c66:	7139                	addi	sp,sp,-64
     c68:	fc06                	sd	ra,56(sp)
     c6a:	f822                	sd	s0,48(sp)
     c6c:	f426                	sd	s1,40(sp)
     c6e:	0080                	addi	s0,sp,64
     c70:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c72:	c299                	beqz	a3,c78 <printint+0x12>
     c74:	0805cb63          	bltz	a1,d0a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     c78:	2581                	sext.w	a1,a1
  neg = 0;
     c7a:	4881                	li	a7,0
     c7c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     c80:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c82:	2601                	sext.w	a2,a2
     c84:	00001517          	auipc	a0,0x1
     c88:	95450513          	addi	a0,a0,-1708 # 15d8 <digits>
     c8c:	883a                	mv	a6,a4
     c8e:	2705                	addiw	a4,a4,1
     c90:	02c5f7bb          	remuw	a5,a1,a2
     c94:	1782                	slli	a5,a5,0x20
     c96:	9381                	srli	a5,a5,0x20
     c98:	97aa                	add	a5,a5,a0
     c9a:	0007c783          	lbu	a5,0(a5)
     c9e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     ca2:	0005879b          	sext.w	a5,a1
     ca6:	02c5d5bb          	divuw	a1,a1,a2
     caa:	0685                	addi	a3,a3,1
     cac:	fec7f0e3          	bgeu	a5,a2,c8c <printint+0x26>
  if(neg)
     cb0:	00088c63          	beqz	a7,cc8 <printint+0x62>
    buf[i++] = '-';
     cb4:	fd070793          	addi	a5,a4,-48
     cb8:	00878733          	add	a4,a5,s0
     cbc:	02d00793          	li	a5,45
     cc0:	fef70823          	sb	a5,-16(a4)
     cc4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     cc8:	02e05c63          	blez	a4,d00 <printint+0x9a>
     ccc:	f04a                	sd	s2,32(sp)
     cce:	ec4e                	sd	s3,24(sp)
     cd0:	fc040793          	addi	a5,s0,-64
     cd4:	00e78933          	add	s2,a5,a4
     cd8:	fff78993          	addi	s3,a5,-1
     cdc:	99ba                	add	s3,s3,a4
     cde:	377d                	addiw	a4,a4,-1
     ce0:	1702                	slli	a4,a4,0x20
     ce2:	9301                	srli	a4,a4,0x20
     ce4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     ce8:	fff94583          	lbu	a1,-1(s2)
     cec:	8526                	mv	a0,s1
     cee:	00000097          	auipc	ra,0x0
     cf2:	f56080e7          	jalr	-170(ra) # c44 <putc>
  while(--i >= 0)
     cf6:	197d                	addi	s2,s2,-1
     cf8:	ff3918e3          	bne	s2,s3,ce8 <printint+0x82>
     cfc:	7902                	ld	s2,32(sp)
     cfe:	69e2                	ld	s3,24(sp)
}
     d00:	70e2                	ld	ra,56(sp)
     d02:	7442                	ld	s0,48(sp)
     d04:	74a2                	ld	s1,40(sp)
     d06:	6121                	addi	sp,sp,64
     d08:	8082                	ret
    x = -xx;
     d0a:	40b005bb          	negw	a1,a1
    neg = 1;
     d0e:	4885                	li	a7,1
    x = -xx;
     d10:	b7b5                	j	c7c <printint+0x16>

0000000000000d12 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d12:	715d                	addi	sp,sp,-80
     d14:	e486                	sd	ra,72(sp)
     d16:	e0a2                	sd	s0,64(sp)
     d18:	f84a                	sd	s2,48(sp)
     d1a:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d1c:	0005c903          	lbu	s2,0(a1)
     d20:	1a090a63          	beqz	s2,ed4 <vprintf+0x1c2>
     d24:	fc26                	sd	s1,56(sp)
     d26:	f44e                	sd	s3,40(sp)
     d28:	f052                	sd	s4,32(sp)
     d2a:	ec56                	sd	s5,24(sp)
     d2c:	e85a                	sd	s6,16(sp)
     d2e:	e45e                	sd	s7,8(sp)
     d30:	8aaa                	mv	s5,a0
     d32:	8bb2                	mv	s7,a2
     d34:	00158493          	addi	s1,a1,1
  state = 0;
     d38:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     d3a:	02500a13          	li	s4,37
     d3e:	4b55                	li	s6,21
     d40:	a839                	j	d5e <vprintf+0x4c>
        putc(fd, c);
     d42:	85ca                	mv	a1,s2
     d44:	8556                	mv	a0,s5
     d46:	00000097          	auipc	ra,0x0
     d4a:	efe080e7          	jalr	-258(ra) # c44 <putc>
     d4e:	a019                	j	d54 <vprintf+0x42>
    } else if(state == '%'){
     d50:	01498d63          	beq	s3,s4,d6a <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     d54:	0485                	addi	s1,s1,1
     d56:	fff4c903          	lbu	s2,-1(s1)
     d5a:	16090763          	beqz	s2,ec8 <vprintf+0x1b6>
    if(state == 0){
     d5e:	fe0999e3          	bnez	s3,d50 <vprintf+0x3e>
      if(c == '%'){
     d62:	ff4910e3          	bne	s2,s4,d42 <vprintf+0x30>
        state = '%';
     d66:	89d2                	mv	s3,s4
     d68:	b7f5                	j	d54 <vprintf+0x42>
      if(c == 'd'){
     d6a:	13490463          	beq	s2,s4,e92 <vprintf+0x180>
     d6e:	f9d9079b          	addiw	a5,s2,-99
     d72:	0ff7f793          	zext.b	a5,a5
     d76:	12fb6763          	bltu	s6,a5,ea4 <vprintf+0x192>
     d7a:	f9d9079b          	addiw	a5,s2,-99
     d7e:	0ff7f713          	zext.b	a4,a5
     d82:	12eb6163          	bltu	s6,a4,ea4 <vprintf+0x192>
     d86:	00271793          	slli	a5,a4,0x2
     d8a:	00000717          	auipc	a4,0x0
     d8e:	7f670713          	addi	a4,a4,2038 # 1580 <malloc+0x5bc>
     d92:	97ba                	add	a5,a5,a4
     d94:	439c                	lw	a5,0(a5)
     d96:	97ba                	add	a5,a5,a4
     d98:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     d9a:	008b8913          	addi	s2,s7,8
     d9e:	4685                	li	a3,1
     da0:	4629                	li	a2,10
     da2:	000ba583          	lw	a1,0(s7)
     da6:	8556                	mv	a0,s5
     da8:	00000097          	auipc	ra,0x0
     dac:	ebe080e7          	jalr	-322(ra) # c66 <printint>
     db0:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     db2:	4981                	li	s3,0
     db4:	b745                	j	d54 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     db6:	008b8913          	addi	s2,s7,8
     dba:	4681                	li	a3,0
     dbc:	4629                	li	a2,10
     dbe:	000ba583          	lw	a1,0(s7)
     dc2:	8556                	mv	a0,s5
     dc4:	00000097          	auipc	ra,0x0
     dc8:	ea2080e7          	jalr	-350(ra) # c66 <printint>
     dcc:	8bca                	mv	s7,s2
      state = 0;
     dce:	4981                	li	s3,0
     dd0:	b751                	j	d54 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     dd2:	008b8913          	addi	s2,s7,8
     dd6:	4681                	li	a3,0
     dd8:	4641                	li	a2,16
     dda:	000ba583          	lw	a1,0(s7)
     dde:	8556                	mv	a0,s5
     de0:	00000097          	auipc	ra,0x0
     de4:	e86080e7          	jalr	-378(ra) # c66 <printint>
     de8:	8bca                	mv	s7,s2
      state = 0;
     dea:	4981                	li	s3,0
     dec:	b7a5                	j	d54 <vprintf+0x42>
     dee:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     df0:	008b8c13          	addi	s8,s7,8
     df4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     df8:	03000593          	li	a1,48
     dfc:	8556                	mv	a0,s5
     dfe:	00000097          	auipc	ra,0x0
     e02:	e46080e7          	jalr	-442(ra) # c44 <putc>
  putc(fd, 'x');
     e06:	07800593          	li	a1,120
     e0a:	8556                	mv	a0,s5
     e0c:	00000097          	auipc	ra,0x0
     e10:	e38080e7          	jalr	-456(ra) # c44 <putc>
     e14:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e16:	00000b97          	auipc	s7,0x0
     e1a:	7c2b8b93          	addi	s7,s7,1986 # 15d8 <digits>
     e1e:	03c9d793          	srli	a5,s3,0x3c
     e22:	97de                	add	a5,a5,s7
     e24:	0007c583          	lbu	a1,0(a5)
     e28:	8556                	mv	a0,s5
     e2a:	00000097          	auipc	ra,0x0
     e2e:	e1a080e7          	jalr	-486(ra) # c44 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     e32:	0992                	slli	s3,s3,0x4
     e34:	397d                	addiw	s2,s2,-1
     e36:	fe0914e3          	bnez	s2,e1e <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
     e3a:	8be2                	mv	s7,s8
      state = 0;
     e3c:	4981                	li	s3,0
     e3e:	6c02                	ld	s8,0(sp)
     e40:	bf11                	j	d54 <vprintf+0x42>
        s = va_arg(ap, char*);
     e42:	008b8993          	addi	s3,s7,8
     e46:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     e4a:	02090163          	beqz	s2,e6c <vprintf+0x15a>
        while(*s != 0){
     e4e:	00094583          	lbu	a1,0(s2)
     e52:	c9a5                	beqz	a1,ec2 <vprintf+0x1b0>
          putc(fd, *s);
     e54:	8556                	mv	a0,s5
     e56:	00000097          	auipc	ra,0x0
     e5a:	dee080e7          	jalr	-530(ra) # c44 <putc>
          s++;
     e5e:	0905                	addi	s2,s2,1
        while(*s != 0){
     e60:	00094583          	lbu	a1,0(s2)
     e64:	f9e5                	bnez	a1,e54 <vprintf+0x142>
        s = va_arg(ap, char*);
     e66:	8bce                	mv	s7,s3
      state = 0;
     e68:	4981                	li	s3,0
     e6a:	b5ed                	j	d54 <vprintf+0x42>
          s = "(null)";
     e6c:	00000917          	auipc	s2,0x0
     e70:	70c90913          	addi	s2,s2,1804 # 1578 <malloc+0x5b4>
        while(*s != 0){
     e74:	02800593          	li	a1,40
     e78:	bff1                	j	e54 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
     e7a:	008b8913          	addi	s2,s7,8
     e7e:	000bc583          	lbu	a1,0(s7)
     e82:	8556                	mv	a0,s5
     e84:	00000097          	auipc	ra,0x0
     e88:	dc0080e7          	jalr	-576(ra) # c44 <putc>
     e8c:	8bca                	mv	s7,s2
      state = 0;
     e8e:	4981                	li	s3,0
     e90:	b5d1                	j	d54 <vprintf+0x42>
        putc(fd, c);
     e92:	02500593          	li	a1,37
     e96:	8556                	mv	a0,s5
     e98:	00000097          	auipc	ra,0x0
     e9c:	dac080e7          	jalr	-596(ra) # c44 <putc>
      state = 0;
     ea0:	4981                	li	s3,0
     ea2:	bd4d                	j	d54 <vprintf+0x42>
        putc(fd, '%');
     ea4:	02500593          	li	a1,37
     ea8:	8556                	mv	a0,s5
     eaa:	00000097          	auipc	ra,0x0
     eae:	d9a080e7          	jalr	-614(ra) # c44 <putc>
        putc(fd, c);
     eb2:	85ca                	mv	a1,s2
     eb4:	8556                	mv	a0,s5
     eb6:	00000097          	auipc	ra,0x0
     eba:	d8e080e7          	jalr	-626(ra) # c44 <putc>
      state = 0;
     ebe:	4981                	li	s3,0
     ec0:	bd51                	j	d54 <vprintf+0x42>
        s = va_arg(ap, char*);
     ec2:	8bce                	mv	s7,s3
      state = 0;
     ec4:	4981                	li	s3,0
     ec6:	b579                	j	d54 <vprintf+0x42>
     ec8:	74e2                	ld	s1,56(sp)
     eca:	79a2                	ld	s3,40(sp)
     ecc:	7a02                	ld	s4,32(sp)
     ece:	6ae2                	ld	s5,24(sp)
     ed0:	6b42                	ld	s6,16(sp)
     ed2:	6ba2                	ld	s7,8(sp)
    }
  }
}
     ed4:	60a6                	ld	ra,72(sp)
     ed6:	6406                	ld	s0,64(sp)
     ed8:	7942                	ld	s2,48(sp)
     eda:	6161                	addi	sp,sp,80
     edc:	8082                	ret

0000000000000ede <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     ede:	715d                	addi	sp,sp,-80
     ee0:	ec06                	sd	ra,24(sp)
     ee2:	e822                	sd	s0,16(sp)
     ee4:	1000                	addi	s0,sp,32
     ee6:	e010                	sd	a2,0(s0)
     ee8:	e414                	sd	a3,8(s0)
     eea:	e818                	sd	a4,16(s0)
     eec:	ec1c                	sd	a5,24(s0)
     eee:	03043023          	sd	a6,32(s0)
     ef2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     ef6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     efa:	8622                	mv	a2,s0
     efc:	00000097          	auipc	ra,0x0
     f00:	e16080e7          	jalr	-490(ra) # d12 <vprintf>
}
     f04:	60e2                	ld	ra,24(sp)
     f06:	6442                	ld	s0,16(sp)
     f08:	6161                	addi	sp,sp,80
     f0a:	8082                	ret

0000000000000f0c <printf>:

void
printf(const char *fmt, ...)
{
     f0c:	711d                	addi	sp,sp,-96
     f0e:	ec06                	sd	ra,24(sp)
     f10:	e822                	sd	s0,16(sp)
     f12:	1000                	addi	s0,sp,32
     f14:	e40c                	sd	a1,8(s0)
     f16:	e810                	sd	a2,16(s0)
     f18:	ec14                	sd	a3,24(s0)
     f1a:	f018                	sd	a4,32(s0)
     f1c:	f41c                	sd	a5,40(s0)
     f1e:	03043823          	sd	a6,48(s0)
     f22:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     f26:	00840613          	addi	a2,s0,8
     f2a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     f2e:	85aa                	mv	a1,a0
     f30:	4505                	li	a0,1
     f32:	00000097          	auipc	ra,0x0
     f36:	de0080e7          	jalr	-544(ra) # d12 <vprintf>
}
     f3a:	60e2                	ld	ra,24(sp)
     f3c:	6442                	ld	s0,16(sp)
     f3e:	6125                	addi	sp,sp,96
     f40:	8082                	ret

0000000000000f42 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     f42:	1141                	addi	sp,sp,-16
     f44:	e422                	sd	s0,8(sp)
     f46:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     f48:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f4c:	00001797          	auipc	a5,0x1
     f50:	b547b783          	ld	a5,-1196(a5) # 1aa0 <freep>
     f54:	a02d                	j	f7e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     f56:	4618                	lw	a4,8(a2)
     f58:	9f2d                	addw	a4,a4,a1
     f5a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     f5e:	6398                	ld	a4,0(a5)
     f60:	6310                	ld	a2,0(a4)
     f62:	a83d                	j	fa0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     f64:	ff852703          	lw	a4,-8(a0)
     f68:	9f31                	addw	a4,a4,a2
     f6a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     f6c:	ff053683          	ld	a3,-16(a0)
     f70:	a091                	j	fb4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f72:	6398                	ld	a4,0(a5)
     f74:	00e7e463          	bltu	a5,a4,f7c <free+0x3a>
     f78:	00e6ea63          	bltu	a3,a4,f8c <free+0x4a>
{
     f7c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f7e:	fed7fae3          	bgeu	a5,a3,f72 <free+0x30>
     f82:	6398                	ld	a4,0(a5)
     f84:	00e6e463          	bltu	a3,a4,f8c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f88:	fee7eae3          	bltu	a5,a4,f7c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
     f8c:	ff852583          	lw	a1,-8(a0)
     f90:	6390                	ld	a2,0(a5)
     f92:	02059813          	slli	a6,a1,0x20
     f96:	01c85713          	srli	a4,a6,0x1c
     f9a:	9736                	add	a4,a4,a3
     f9c:	fae60de3          	beq	a2,a4,f56 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
     fa0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     fa4:	4790                	lw	a2,8(a5)
     fa6:	02061593          	slli	a1,a2,0x20
     faa:	01c5d713          	srli	a4,a1,0x1c
     fae:	973e                	add	a4,a4,a5
     fb0:	fae68ae3          	beq	a3,a4,f64 <free+0x22>
    p->s.ptr = bp->s.ptr;
     fb4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
     fb6:	00001717          	auipc	a4,0x1
     fba:	aef73523          	sd	a5,-1302(a4) # 1aa0 <freep>
}
     fbe:	6422                	ld	s0,8(sp)
     fc0:	0141                	addi	sp,sp,16
     fc2:	8082                	ret

0000000000000fc4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     fc4:	7139                	addi	sp,sp,-64
     fc6:	fc06                	sd	ra,56(sp)
     fc8:	f822                	sd	s0,48(sp)
     fca:	f426                	sd	s1,40(sp)
     fcc:	ec4e                	sd	s3,24(sp)
     fce:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     fd0:	02051493          	slli	s1,a0,0x20
     fd4:	9081                	srli	s1,s1,0x20
     fd6:	04bd                	addi	s1,s1,15
     fd8:	8091                	srli	s1,s1,0x4
     fda:	0014899b          	addiw	s3,s1,1
     fde:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
     fe0:	00001517          	auipc	a0,0x1
     fe4:	ac053503          	ld	a0,-1344(a0) # 1aa0 <freep>
     fe8:	c915                	beqz	a0,101c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     fec:	4798                	lw	a4,8(a5)
     fee:	08977e63          	bgeu	a4,s1,108a <malloc+0xc6>
     ff2:	f04a                	sd	s2,32(sp)
     ff4:	e852                	sd	s4,16(sp)
     ff6:	e456                	sd	s5,8(sp)
     ff8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
     ffa:	8a4e                	mv	s4,s3
     ffc:	0009871b          	sext.w	a4,s3
    1000:	6685                	lui	a3,0x1
    1002:	00d77363          	bgeu	a4,a3,1008 <malloc+0x44>
    1006:	6a05                	lui	s4,0x1
    1008:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    100c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1010:	00001917          	auipc	s2,0x1
    1014:	a9090913          	addi	s2,s2,-1392 # 1aa0 <freep>
  if(p == (char*)-1)
    1018:	5afd                	li	s5,-1
    101a:	a091                	j	105e <malloc+0x9a>
    101c:	f04a                	sd	s2,32(sp)
    101e:	e852                	sd	s4,16(sp)
    1020:	e456                	sd	s5,8(sp)
    1022:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1024:	00001797          	auipc	a5,0x1
    1028:	e8478793          	addi	a5,a5,-380 # 1ea8 <base>
    102c:	00001717          	auipc	a4,0x1
    1030:	a6f73a23          	sd	a5,-1420(a4) # 1aa0 <freep>
    1034:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1036:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    103a:	b7c1                	j	ffa <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    103c:	6398                	ld	a4,0(a5)
    103e:	e118                	sd	a4,0(a0)
    1040:	a08d                	j	10a2 <malloc+0xde>
  hp->s.size = nu;
    1042:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1046:	0541                	addi	a0,a0,16
    1048:	00000097          	auipc	ra,0x0
    104c:	efa080e7          	jalr	-262(ra) # f42 <free>
  return freep;
    1050:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1054:	c13d                	beqz	a0,10ba <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1056:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1058:	4798                	lw	a4,8(a5)
    105a:	02977463          	bgeu	a4,s1,1082 <malloc+0xbe>
    if(p == freep)
    105e:	00093703          	ld	a4,0(s2)
    1062:	853e                	mv	a0,a5
    1064:	fef719e3          	bne	a4,a5,1056 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    1068:	8552                	mv	a0,s4
    106a:	00000097          	auipc	ra,0x0
    106e:	bb2080e7          	jalr	-1102(ra) # c1c <sbrk>
  if(p == (char*)-1)
    1072:	fd5518e3          	bne	a0,s5,1042 <malloc+0x7e>
        return 0;
    1076:	4501                	li	a0,0
    1078:	7902                	ld	s2,32(sp)
    107a:	6a42                	ld	s4,16(sp)
    107c:	6aa2                	ld	s5,8(sp)
    107e:	6b02                	ld	s6,0(sp)
    1080:	a03d                	j	10ae <malloc+0xea>
    1082:	7902                	ld	s2,32(sp)
    1084:	6a42                	ld	s4,16(sp)
    1086:	6aa2                	ld	s5,8(sp)
    1088:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    108a:	fae489e3          	beq	s1,a4,103c <malloc+0x78>
        p->s.size -= nunits;
    108e:	4137073b          	subw	a4,a4,s3
    1092:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1094:	02071693          	slli	a3,a4,0x20
    1098:	01c6d713          	srli	a4,a3,0x1c
    109c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    109e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    10a2:	00001717          	auipc	a4,0x1
    10a6:	9ea73f23          	sd	a0,-1538(a4) # 1aa0 <freep>
      return (void*)(p + 1);
    10aa:	01078513          	addi	a0,a5,16
  }
}
    10ae:	70e2                	ld	ra,56(sp)
    10b0:	7442                	ld	s0,48(sp)
    10b2:	74a2                	ld	s1,40(sp)
    10b4:	69e2                	ld	s3,24(sp)
    10b6:	6121                	addi	sp,sp,64
    10b8:	8082                	ret
    10ba:	7902                	ld	s2,32(sp)
    10bc:	6a42                	ld	s4,16(sp)
    10be:	6aa2                	ld	s5,8(sp)
    10c0:	6b02                	ld	s6,0(sp)
    10c2:	b7f5                	j	10ae <malloc+0xea>
