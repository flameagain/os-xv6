
user/_find：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find>:
#include "kernel/stat.h"
#include "kernel/fs.h"

void
find(char *dir, char *file)
{   
   0:	d9010113          	addi	sp,sp,-624
   4:	26113423          	sd	ra,616(sp)
   8:	26813023          	sd	s0,608(sp)
   c:	25213823          	sd	s2,592(sp)
  10:	25313423          	sd	s3,584(sp)
  14:	1c80                	addi	s0,sp,624
  16:	892a                	mv	s2,a0
  18:	89ae                	mv	s3,a1
    // 声明与文件相关的结构体
    struct dirent de;
    struct stat st;

    // open() 函数打开路径，返回一个文件描述符，如果错误返回 -1
    if ((fd = open(dir, 0)) < 0)
  1a:	4581                	li	a1,0
  1c:	00000097          	auipc	ra,0x0
  20:	4da080e7          	jalr	1242(ra) # 4f6 <open>
  24:	04054e63          	bltz	a0,80 <find+0x80>
  28:	24913c23          	sd	s1,600(sp)
  2c:	84aa                	mv	s1,a0
    // 系统调用 fstat 与 stat 类似，但它以文件描述符作为参数
    // int stat(char *, struct stat *);
    // stat 系统调用，可以获得一个已存在文件的模式，并将此模式赋值给它的副本
    // stat 以文件名作为参数，返回文件的 i 结点中的所有信息
    // 如果出错，则返回 -1
    if (fstat(fd, &st) < 0)
  2e:	d9840593          	addi	a1,s0,-616
  32:	00000097          	auipc	ra,0x0
  36:	4dc080e7          	jalr	1244(ra) # 50e <fstat>
  3a:	04054e63          	bltz	a0,96 <find+0x96>
        close(fd);
        return;
    }

    // 如果不是目录类型
    if (st.type != T_DIR)
  3e:	da041703          	lh	a4,-608(s0)
  42:	4785                	li	a5,1
  44:	06f70b63          	beq	a4,a5,ba <find+0xba>
    {
        // 报类型不是目录错误
        fprintf(2, "find: %s is not a directory\n", dir);
  48:	864a                	mv	a2,s2
  4a:	00001597          	auipc	a1,0x1
  4e:	9c658593          	addi	a1,a1,-1594 # a10 <malloc+0x13a>
  52:	4509                	li	a0,2
  54:	00000097          	auipc	ra,0x0
  58:	79c080e7          	jalr	1948(ra) # 7f0 <fprintf>
        // 关闭文件描述符 fd
        close(fd);
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	480080e7          	jalr	1152(ra) # 4de <close>
        return;
  66:	25813483          	ld	s1,600(sp)
        {
            // 打印缓冲区存放的路径
            printf("%s\n", buf);
        } 
    }
}
  6a:	26813083          	ld	ra,616(sp)
  6e:	26013403          	ld	s0,608(sp)
  72:	25013903          	ld	s2,592(sp)
  76:	24813983          	ld	s3,584(sp)
  7a:	27010113          	addi	sp,sp,624
  7e:	8082                	ret
        fprintf(2, "find: cannot open %s\n", dir);
  80:	864a                	mv	a2,s2
  82:	00001597          	auipc	a1,0x1
  86:	95658593          	addi	a1,a1,-1706 # 9d8 <malloc+0x102>
  8a:	4509                	li	a0,2
  8c:	00000097          	auipc	ra,0x0
  90:	764080e7          	jalr	1892(ra) # 7f0 <fprintf>
        return;
  94:	bfd9                	j	6a <find+0x6a>
        fprintf(2, "find: cannot stat %s\n", dir);
  96:	864a                	mv	a2,s2
  98:	00001597          	auipc	a1,0x1
  9c:	96058593          	addi	a1,a1,-1696 # 9f8 <malloc+0x122>
  a0:	4509                	li	a0,2
  a2:	00000097          	auipc	ra,0x0
  a6:	74e080e7          	jalr	1870(ra) # 7f0 <fprintf>
        close(fd);
  aa:	8526                	mv	a0,s1
  ac:	00000097          	auipc	ra,0x0
  b0:	432080e7          	jalr	1074(ra) # 4de <close>
        return;
  b4:	25813483          	ld	s1,600(sp)
  b8:	bf4d                	j	6a <find+0x6a>
    if(strlen(dir) + 1 + DIRSIZ + 1 > sizeof buf)
  ba:	854a                	mv	a0,s2
  bc:	00000097          	auipc	ra,0x0
  c0:	1d6080e7          	jalr	470(ra) # 292 <strlen>
  c4:	2541                	addiw	a0,a0,16
  c6:	20000793          	li	a5,512
  ca:	0ea7e363          	bltu	a5,a0,1b0 <find+0x1b0>
  ce:	25413023          	sd	s4,576(sp)
  d2:	23513c23          	sd	s5,568(sp)
    strcpy(buf, dir);
  d6:	85ca                	mv	a1,s2
  d8:	dc040513          	addi	a0,s0,-576
  dc:	00000097          	auipc	ra,0x0
  e0:	16e080e7          	jalr	366(ra) # 24a <strcpy>
    p = buf + strlen(buf);
  e4:	dc040513          	addi	a0,s0,-576
  e8:	00000097          	auipc	ra,0x0
  ec:	1aa080e7          	jalr	426(ra) # 292 <strlen>
  f0:	1502                	slli	a0,a0,0x20
  f2:	9101                	srli	a0,a0,0x20
  f4:	dc040793          	addi	a5,s0,-576
  f8:	00a78933          	add	s2,a5,a0
    *p++ = '/';
  fc:	00190a93          	addi	s5,s2,1
 100:	02f00793          	li	a5,47
 104:	00f90023          	sb	a5,0(s2)
        if (!strcmp(de.name, ".") || !strcmp(de.name, ".."))
 108:	00001a17          	auipc	s4,0x1
 10c:	948a0a13          	addi	s4,s4,-1720 # a50 <malloc+0x17a>
    while (read(fd, &de, sizeof(de)) == sizeof(de))
 110:	4641                	li	a2,16
 112:	db040593          	addi	a1,s0,-592
 116:	8526                	mv	a0,s1
 118:	00000097          	auipc	ra,0x0
 11c:	3b6080e7          	jalr	950(ra) # 4ce <read>
 120:	47c1                	li	a5,16
 122:	0cf51c63          	bne	a0,a5,1fa <find+0x1fa>
        if(de.inum == 0)
 126:	db045783          	lhu	a5,-592(s0)
 12a:	d3fd                	beqz	a5,110 <find+0x110>
        if (!strcmp(de.name, ".") || !strcmp(de.name, ".."))
 12c:	85d2                	mv	a1,s4
 12e:	db240513          	addi	a0,s0,-590
 132:	00000097          	auipc	ra,0x0
 136:	134080e7          	jalr	308(ra) # 266 <strcmp>
 13a:	d979                	beqz	a0,110 <find+0x110>
 13c:	00001597          	auipc	a1,0x1
 140:	91c58593          	addi	a1,a1,-1764 # a58 <malloc+0x182>
 144:	db240513          	addi	a0,s0,-590
 148:	00000097          	auipc	ra,0x0
 14c:	11e080e7          	jalr	286(ra) # 266 <strcmp>
 150:	d161                	beqz	a0,110 <find+0x110>
        memmove(p, de.name, DIRSIZ);
 152:	4639                	li	a2,14
 154:	db240593          	addi	a1,s0,-590
 158:	8556                	mv	a0,s5
 15a:	00000097          	auipc	ra,0x0
 15e:	2aa080e7          	jalr	682(ra) # 404 <memmove>
        p[DIRSIZ] = 0;
 162:	000907a3          	sb	zero,15(s2)
        if(stat(buf, &st) < 0)
 166:	d9840593          	addi	a1,s0,-616
 16a:	dc040513          	addi	a0,s0,-576
 16e:	00000097          	auipc	ra,0x0
 172:	208080e7          	jalr	520(ra) # 376 <stat>
 176:	04054e63          	bltz	a0,1d2 <find+0x1d2>
        if (st.type == T_DIR)
 17a:	da041783          	lh	a5,-608(s0)
 17e:	4705                	li	a4,1
 180:	06e78563          	beq	a5,a4,1ea <find+0x1ea>
        else if (st.type == T_FILE && !strcmp(de.name, file))
 184:	4709                	li	a4,2
 186:	f8e795e3          	bne	a5,a4,110 <find+0x110>
 18a:	85ce                	mv	a1,s3
 18c:	db240513          	addi	a0,s0,-590
 190:	00000097          	auipc	ra,0x0
 194:	0d6080e7          	jalr	214(ra) # 266 <strcmp>
 198:	fd25                	bnez	a0,110 <find+0x110>
            printf("%s\n", buf);
 19a:	dc040593          	addi	a1,s0,-576
 19e:	00001517          	auipc	a0,0x1
 1a2:	8c250513          	addi	a0,a0,-1854 # a60 <malloc+0x18a>
 1a6:	00000097          	auipc	ra,0x0
 1aa:	678080e7          	jalr	1656(ra) # 81e <printf>
 1ae:	b78d                	j	110 <find+0x110>
        fprintf(2, "find: directory too long\n");
 1b0:	00001597          	auipc	a1,0x1
 1b4:	88058593          	addi	a1,a1,-1920 # a30 <malloc+0x15a>
 1b8:	4509                	li	a0,2
 1ba:	00000097          	auipc	ra,0x0
 1be:	636080e7          	jalr	1590(ra) # 7f0 <fprintf>
        close(fd);
 1c2:	8526                	mv	a0,s1
 1c4:	00000097          	auipc	ra,0x0
 1c8:	31a080e7          	jalr	794(ra) # 4de <close>
        return;
 1cc:	25813483          	ld	s1,600(sp)
 1d0:	bd69                	j	6a <find+0x6a>
            fprintf(2, "find: cannot stat %s\n", buf);
 1d2:	dc040613          	addi	a2,s0,-576
 1d6:	00001597          	auipc	a1,0x1
 1da:	82258593          	addi	a1,a1,-2014 # 9f8 <malloc+0x122>
 1de:	4509                	li	a0,2
 1e0:	00000097          	auipc	ra,0x0
 1e4:	610080e7          	jalr	1552(ra) # 7f0 <fprintf>
            continue;
 1e8:	b725                	j	110 <find+0x110>
            find(buf, file);
 1ea:	85ce                	mv	a1,s3
 1ec:	dc040513          	addi	a0,s0,-576
 1f0:	00000097          	auipc	ra,0x0
 1f4:	e10080e7          	jalr	-496(ra) # 0 <find>
 1f8:	bf21                	j	110 <find+0x110>
 1fa:	25813483          	ld	s1,600(sp)
 1fe:	24013a03          	ld	s4,576(sp)
 202:	23813a83          	ld	s5,568(sp)
 206:	b595                	j	6a <find+0x6a>

0000000000000208 <main>:

int
main(int argc, char *argv[])
{
 208:	1141                	addi	sp,sp,-16
 20a:	e406                	sd	ra,8(sp)
 20c:	e022                	sd	s0,0(sp)
 20e:	0800                	addi	s0,sp,16
    // 如果参数个数不为 3 则报错
    if (argc != 3)
 210:	470d                	li	a4,3
 212:	02e50063          	beq	a0,a4,232 <main+0x2a>
    {
        // 输出提示
        fprintf(2, "usage: find dirName fileName\n");
 216:	00001597          	auipc	a1,0x1
 21a:	85258593          	addi	a1,a1,-1966 # a68 <malloc+0x192>
 21e:	4509                	li	a0,2
 220:	00000097          	auipc	ra,0x0
 224:	5d0080e7          	jalr	1488(ra) # 7f0 <fprintf>
        // 异常退出
        exit(1);
 228:	4505                	li	a0,1
 22a:	00000097          	auipc	ra,0x0
 22e:	28c080e7          	jalr	652(ra) # 4b6 <exit>
 232:	87ae                	mv	a5,a1
    }
    // 调用 find 函数查找指定目录下的文件
    find(argv[1], argv[2]);
 234:	698c                	ld	a1,16(a1)
 236:	6788                	ld	a0,8(a5)
 238:	00000097          	auipc	ra,0x0
 23c:	dc8080e7          	jalr	-568(ra) # 0 <find>
    // 正常退出
    exit(0);
 240:	4501                	li	a0,0
 242:	00000097          	auipc	ra,0x0
 246:	274080e7          	jalr	628(ra) # 4b6 <exit>

000000000000024a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e422                	sd	s0,8(sp)
 24e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 250:	87aa                	mv	a5,a0
 252:	0585                	addi	a1,a1,1
 254:	0785                	addi	a5,a5,1
 256:	fff5c703          	lbu	a4,-1(a1)
 25a:	fee78fa3          	sb	a4,-1(a5)
 25e:	fb75                	bnez	a4,252 <strcpy+0x8>
    ;
  return os;
}
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret

0000000000000266 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 266:	1141                	addi	sp,sp,-16
 268:	e422                	sd	s0,8(sp)
 26a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 26c:	00054783          	lbu	a5,0(a0)
 270:	cb91                	beqz	a5,284 <strcmp+0x1e>
 272:	0005c703          	lbu	a4,0(a1)
 276:	00f71763          	bne	a4,a5,284 <strcmp+0x1e>
    p++, q++;
 27a:	0505                	addi	a0,a0,1
 27c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 27e:	00054783          	lbu	a5,0(a0)
 282:	fbe5                	bnez	a5,272 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 284:	0005c503          	lbu	a0,0(a1)
}
 288:	40a7853b          	subw	a0,a5,a0
 28c:	6422                	ld	s0,8(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret

0000000000000292 <strlen>:

uint
strlen(const char *s)
{
 292:	1141                	addi	sp,sp,-16
 294:	e422                	sd	s0,8(sp)
 296:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 298:	00054783          	lbu	a5,0(a0)
 29c:	cf91                	beqz	a5,2b8 <strlen+0x26>
 29e:	0505                	addi	a0,a0,1
 2a0:	87aa                	mv	a5,a0
 2a2:	86be                	mv	a3,a5
 2a4:	0785                	addi	a5,a5,1
 2a6:	fff7c703          	lbu	a4,-1(a5)
 2aa:	ff65                	bnez	a4,2a2 <strlen+0x10>
 2ac:	40a6853b          	subw	a0,a3,a0
 2b0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2b2:	6422                	ld	s0,8(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret
  for(n = 0; s[n]; n++)
 2b8:	4501                	li	a0,0
 2ba:	bfe5                	j	2b2 <strlen+0x20>

00000000000002bc <memset>:

void*
memset(void *dst, int c, uint n)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e422                	sd	s0,8(sp)
 2c0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2c2:	ca19                	beqz	a2,2d8 <memset+0x1c>
 2c4:	87aa                	mv	a5,a0
 2c6:	1602                	slli	a2,a2,0x20
 2c8:	9201                	srli	a2,a2,0x20
 2ca:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2ce:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2d2:	0785                	addi	a5,a5,1
 2d4:	fee79de3          	bne	a5,a4,2ce <memset+0x12>
  }
  return dst;
}
 2d8:	6422                	ld	s0,8(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret

00000000000002de <strchr>:

char*
strchr(const char *s, char c)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e422                	sd	s0,8(sp)
 2e2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2e4:	00054783          	lbu	a5,0(a0)
 2e8:	cb99                	beqz	a5,2fe <strchr+0x20>
    if(*s == c)
 2ea:	00f58763          	beq	a1,a5,2f8 <strchr+0x1a>
  for(; *s; s++)
 2ee:	0505                	addi	a0,a0,1
 2f0:	00054783          	lbu	a5,0(a0)
 2f4:	fbfd                	bnez	a5,2ea <strchr+0xc>
      return (char*)s;
  return 0;
 2f6:	4501                	li	a0,0
}
 2f8:	6422                	ld	s0,8(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret
  return 0;
 2fe:	4501                	li	a0,0
 300:	bfe5                	j	2f8 <strchr+0x1a>

0000000000000302 <gets>:

char*
gets(char *buf, int max)
{
 302:	711d                	addi	sp,sp,-96
 304:	ec86                	sd	ra,88(sp)
 306:	e8a2                	sd	s0,80(sp)
 308:	e4a6                	sd	s1,72(sp)
 30a:	e0ca                	sd	s2,64(sp)
 30c:	fc4e                	sd	s3,56(sp)
 30e:	f852                	sd	s4,48(sp)
 310:	f456                	sd	s5,40(sp)
 312:	f05a                	sd	s6,32(sp)
 314:	ec5e                	sd	s7,24(sp)
 316:	1080                	addi	s0,sp,96
 318:	8baa                	mv	s7,a0
 31a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 31c:	892a                	mv	s2,a0
 31e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 320:	4aa9                	li	s5,10
 322:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 324:	89a6                	mv	s3,s1
 326:	2485                	addiw	s1,s1,1
 328:	0344d863          	bge	s1,s4,358 <gets+0x56>
    cc = read(0, &c, 1);
 32c:	4605                	li	a2,1
 32e:	faf40593          	addi	a1,s0,-81
 332:	4501                	li	a0,0
 334:	00000097          	auipc	ra,0x0
 338:	19a080e7          	jalr	410(ra) # 4ce <read>
    if(cc < 1)
 33c:	00a05e63          	blez	a0,358 <gets+0x56>
    buf[i++] = c;
 340:	faf44783          	lbu	a5,-81(s0)
 344:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 348:	01578763          	beq	a5,s5,356 <gets+0x54>
 34c:	0905                	addi	s2,s2,1
 34e:	fd679be3          	bne	a5,s6,324 <gets+0x22>
    buf[i++] = c;
 352:	89a6                	mv	s3,s1
 354:	a011                	j	358 <gets+0x56>
 356:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 358:	99de                	add	s3,s3,s7
 35a:	00098023          	sb	zero,0(s3)
  return buf;
}
 35e:	855e                	mv	a0,s7
 360:	60e6                	ld	ra,88(sp)
 362:	6446                	ld	s0,80(sp)
 364:	64a6                	ld	s1,72(sp)
 366:	6906                	ld	s2,64(sp)
 368:	79e2                	ld	s3,56(sp)
 36a:	7a42                	ld	s4,48(sp)
 36c:	7aa2                	ld	s5,40(sp)
 36e:	7b02                	ld	s6,32(sp)
 370:	6be2                	ld	s7,24(sp)
 372:	6125                	addi	sp,sp,96
 374:	8082                	ret

0000000000000376 <stat>:

int
stat(const char *n, struct stat *st)
{
 376:	1101                	addi	sp,sp,-32
 378:	ec06                	sd	ra,24(sp)
 37a:	e822                	sd	s0,16(sp)
 37c:	e04a                	sd	s2,0(sp)
 37e:	1000                	addi	s0,sp,32
 380:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 382:	4581                	li	a1,0
 384:	00000097          	auipc	ra,0x0
 388:	172080e7          	jalr	370(ra) # 4f6 <open>
  if(fd < 0)
 38c:	02054663          	bltz	a0,3b8 <stat+0x42>
 390:	e426                	sd	s1,8(sp)
 392:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 394:	85ca                	mv	a1,s2
 396:	00000097          	auipc	ra,0x0
 39a:	178080e7          	jalr	376(ra) # 50e <fstat>
 39e:	892a                	mv	s2,a0
  close(fd);
 3a0:	8526                	mv	a0,s1
 3a2:	00000097          	auipc	ra,0x0
 3a6:	13c080e7          	jalr	316(ra) # 4de <close>
  return r;
 3aa:	64a2                	ld	s1,8(sp)
}
 3ac:	854a                	mv	a0,s2
 3ae:	60e2                	ld	ra,24(sp)
 3b0:	6442                	ld	s0,16(sp)
 3b2:	6902                	ld	s2,0(sp)
 3b4:	6105                	addi	sp,sp,32
 3b6:	8082                	ret
    return -1;
 3b8:	597d                	li	s2,-1
 3ba:	bfcd                	j	3ac <stat+0x36>

00000000000003bc <atoi>:

int
atoi(const char *s)
{
 3bc:	1141                	addi	sp,sp,-16
 3be:	e422                	sd	s0,8(sp)
 3c0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c2:	00054683          	lbu	a3,0(a0)
 3c6:	fd06879b          	addiw	a5,a3,-48
 3ca:	0ff7f793          	zext.b	a5,a5
 3ce:	4625                	li	a2,9
 3d0:	02f66863          	bltu	a2,a5,400 <atoi+0x44>
 3d4:	872a                	mv	a4,a0
  n = 0;
 3d6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3d8:	0705                	addi	a4,a4,1
 3da:	0025179b          	slliw	a5,a0,0x2
 3de:	9fa9                	addw	a5,a5,a0
 3e0:	0017979b          	slliw	a5,a5,0x1
 3e4:	9fb5                	addw	a5,a5,a3
 3e6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3ea:	00074683          	lbu	a3,0(a4)
 3ee:	fd06879b          	addiw	a5,a3,-48
 3f2:	0ff7f793          	zext.b	a5,a5
 3f6:	fef671e3          	bgeu	a2,a5,3d8 <atoi+0x1c>
  return n;
}
 3fa:	6422                	ld	s0,8(sp)
 3fc:	0141                	addi	sp,sp,16
 3fe:	8082                	ret
  n = 0;
 400:	4501                	li	a0,0
 402:	bfe5                	j	3fa <atoi+0x3e>

0000000000000404 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 404:	1141                	addi	sp,sp,-16
 406:	e422                	sd	s0,8(sp)
 408:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 40a:	02b57463          	bgeu	a0,a1,432 <memmove+0x2e>
    while(n-- > 0)
 40e:	00c05f63          	blez	a2,42c <memmove+0x28>
 412:	1602                	slli	a2,a2,0x20
 414:	9201                	srli	a2,a2,0x20
 416:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 41a:	872a                	mv	a4,a0
      *dst++ = *src++;
 41c:	0585                	addi	a1,a1,1
 41e:	0705                	addi	a4,a4,1
 420:	fff5c683          	lbu	a3,-1(a1)
 424:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 428:	fef71ae3          	bne	a4,a5,41c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 42c:	6422                	ld	s0,8(sp)
 42e:	0141                	addi	sp,sp,16
 430:	8082                	ret
    dst += n;
 432:	00c50733          	add	a4,a0,a2
    src += n;
 436:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 438:	fec05ae3          	blez	a2,42c <memmove+0x28>
 43c:	fff6079b          	addiw	a5,a2,-1
 440:	1782                	slli	a5,a5,0x20
 442:	9381                	srli	a5,a5,0x20
 444:	fff7c793          	not	a5,a5
 448:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 44a:	15fd                	addi	a1,a1,-1
 44c:	177d                	addi	a4,a4,-1
 44e:	0005c683          	lbu	a3,0(a1)
 452:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 456:	fee79ae3          	bne	a5,a4,44a <memmove+0x46>
 45a:	bfc9                	j	42c <memmove+0x28>

000000000000045c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 45c:	1141                	addi	sp,sp,-16
 45e:	e422                	sd	s0,8(sp)
 460:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 462:	ca05                	beqz	a2,492 <memcmp+0x36>
 464:	fff6069b          	addiw	a3,a2,-1
 468:	1682                	slli	a3,a3,0x20
 46a:	9281                	srli	a3,a3,0x20
 46c:	0685                	addi	a3,a3,1
 46e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 470:	00054783          	lbu	a5,0(a0)
 474:	0005c703          	lbu	a4,0(a1)
 478:	00e79863          	bne	a5,a4,488 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 47c:	0505                	addi	a0,a0,1
    p2++;
 47e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 480:	fed518e3          	bne	a0,a3,470 <memcmp+0x14>
  }
  return 0;
 484:	4501                	li	a0,0
 486:	a019                	j	48c <memcmp+0x30>
      return *p1 - *p2;
 488:	40e7853b          	subw	a0,a5,a4
}
 48c:	6422                	ld	s0,8(sp)
 48e:	0141                	addi	sp,sp,16
 490:	8082                	ret
  return 0;
 492:	4501                	li	a0,0
 494:	bfe5                	j	48c <memcmp+0x30>

0000000000000496 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 496:	1141                	addi	sp,sp,-16
 498:	e406                	sd	ra,8(sp)
 49a:	e022                	sd	s0,0(sp)
 49c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 49e:	00000097          	auipc	ra,0x0
 4a2:	f66080e7          	jalr	-154(ra) # 404 <memmove>
}
 4a6:	60a2                	ld	ra,8(sp)
 4a8:	6402                	ld	s0,0(sp)
 4aa:	0141                	addi	sp,sp,16
 4ac:	8082                	ret

00000000000004ae <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ae:	4885                	li	a7,1
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4b6:	4889                	li	a7,2
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <wait>:
.global wait
wait:
 li a7, SYS_wait
 4be:	488d                	li	a7,3
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4c6:	4891                	li	a7,4
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <read>:
.global read
read:
 li a7, SYS_read
 4ce:	4895                	li	a7,5
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <write>:
.global write
write:
 li a7, SYS_write
 4d6:	48c1                	li	a7,16
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <close>:
.global close
close:
 li a7, SYS_close
 4de:	48d5                	li	a7,21
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4e6:	4899                	li	a7,6
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <exec>:
.global exec
exec:
 li a7, SYS_exec
 4ee:	489d                	li	a7,7
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <open>:
.global open
open:
 li a7, SYS_open
 4f6:	48bd                	li	a7,15
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4fe:	48c5                	li	a7,17
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 506:	48c9                	li	a7,18
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 50e:	48a1                	li	a7,8
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <link>:
.global link
link:
 li a7, SYS_link
 516:	48cd                	li	a7,19
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 51e:	48d1                	li	a7,20
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 526:	48a5                	li	a7,9
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <dup>:
.global dup
dup:
 li a7, SYS_dup
 52e:	48a9                	li	a7,10
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 536:	48ad                	li	a7,11
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 53e:	48b1                	li	a7,12
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 546:	48b5                	li	a7,13
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 54e:	48b9                	li	a7,14
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 556:	1101                	addi	sp,sp,-32
 558:	ec06                	sd	ra,24(sp)
 55a:	e822                	sd	s0,16(sp)
 55c:	1000                	addi	s0,sp,32
 55e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 562:	4605                	li	a2,1
 564:	fef40593          	addi	a1,s0,-17
 568:	00000097          	auipc	ra,0x0
 56c:	f6e080e7          	jalr	-146(ra) # 4d6 <write>
}
 570:	60e2                	ld	ra,24(sp)
 572:	6442                	ld	s0,16(sp)
 574:	6105                	addi	sp,sp,32
 576:	8082                	ret

0000000000000578 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 578:	7139                	addi	sp,sp,-64
 57a:	fc06                	sd	ra,56(sp)
 57c:	f822                	sd	s0,48(sp)
 57e:	f426                	sd	s1,40(sp)
 580:	0080                	addi	s0,sp,64
 582:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 584:	c299                	beqz	a3,58a <printint+0x12>
 586:	0805cb63          	bltz	a1,61c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 58a:	2581                	sext.w	a1,a1
  neg = 0;
 58c:	4881                	li	a7,0
 58e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 592:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 594:	2601                	sext.w	a2,a2
 596:	00000517          	auipc	a0,0x0
 59a:	55250513          	addi	a0,a0,1362 # ae8 <digits>
 59e:	883a                	mv	a6,a4
 5a0:	2705                	addiw	a4,a4,1
 5a2:	02c5f7bb          	remuw	a5,a1,a2
 5a6:	1782                	slli	a5,a5,0x20
 5a8:	9381                	srli	a5,a5,0x20
 5aa:	97aa                	add	a5,a5,a0
 5ac:	0007c783          	lbu	a5,0(a5)
 5b0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5b4:	0005879b          	sext.w	a5,a1
 5b8:	02c5d5bb          	divuw	a1,a1,a2
 5bc:	0685                	addi	a3,a3,1
 5be:	fec7f0e3          	bgeu	a5,a2,59e <printint+0x26>
  if(neg)
 5c2:	00088c63          	beqz	a7,5da <printint+0x62>
    buf[i++] = '-';
 5c6:	fd070793          	addi	a5,a4,-48
 5ca:	00878733          	add	a4,a5,s0
 5ce:	02d00793          	li	a5,45
 5d2:	fef70823          	sb	a5,-16(a4)
 5d6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5da:	02e05c63          	blez	a4,612 <printint+0x9a>
 5de:	f04a                	sd	s2,32(sp)
 5e0:	ec4e                	sd	s3,24(sp)
 5e2:	fc040793          	addi	a5,s0,-64
 5e6:	00e78933          	add	s2,a5,a4
 5ea:	fff78993          	addi	s3,a5,-1
 5ee:	99ba                	add	s3,s3,a4
 5f0:	377d                	addiw	a4,a4,-1
 5f2:	1702                	slli	a4,a4,0x20
 5f4:	9301                	srli	a4,a4,0x20
 5f6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5fa:	fff94583          	lbu	a1,-1(s2)
 5fe:	8526                	mv	a0,s1
 600:	00000097          	auipc	ra,0x0
 604:	f56080e7          	jalr	-170(ra) # 556 <putc>
  while(--i >= 0)
 608:	197d                	addi	s2,s2,-1
 60a:	ff3918e3          	bne	s2,s3,5fa <printint+0x82>
 60e:	7902                	ld	s2,32(sp)
 610:	69e2                	ld	s3,24(sp)
}
 612:	70e2                	ld	ra,56(sp)
 614:	7442                	ld	s0,48(sp)
 616:	74a2                	ld	s1,40(sp)
 618:	6121                	addi	sp,sp,64
 61a:	8082                	ret
    x = -xx;
 61c:	40b005bb          	negw	a1,a1
    neg = 1;
 620:	4885                	li	a7,1
    x = -xx;
 622:	b7b5                	j	58e <printint+0x16>

0000000000000624 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 624:	715d                	addi	sp,sp,-80
 626:	e486                	sd	ra,72(sp)
 628:	e0a2                	sd	s0,64(sp)
 62a:	f84a                	sd	s2,48(sp)
 62c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 62e:	0005c903          	lbu	s2,0(a1)
 632:	1a090a63          	beqz	s2,7e6 <vprintf+0x1c2>
 636:	fc26                	sd	s1,56(sp)
 638:	f44e                	sd	s3,40(sp)
 63a:	f052                	sd	s4,32(sp)
 63c:	ec56                	sd	s5,24(sp)
 63e:	e85a                	sd	s6,16(sp)
 640:	e45e                	sd	s7,8(sp)
 642:	8aaa                	mv	s5,a0
 644:	8bb2                	mv	s7,a2
 646:	00158493          	addi	s1,a1,1
  state = 0;
 64a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 64c:	02500a13          	li	s4,37
 650:	4b55                	li	s6,21
 652:	a839                	j	670 <vprintf+0x4c>
        putc(fd, c);
 654:	85ca                	mv	a1,s2
 656:	8556                	mv	a0,s5
 658:	00000097          	auipc	ra,0x0
 65c:	efe080e7          	jalr	-258(ra) # 556 <putc>
 660:	a019                	j	666 <vprintf+0x42>
    } else if(state == '%'){
 662:	01498d63          	beq	s3,s4,67c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 666:	0485                	addi	s1,s1,1
 668:	fff4c903          	lbu	s2,-1(s1)
 66c:	16090763          	beqz	s2,7da <vprintf+0x1b6>
    if(state == 0){
 670:	fe0999e3          	bnez	s3,662 <vprintf+0x3e>
      if(c == '%'){
 674:	ff4910e3          	bne	s2,s4,654 <vprintf+0x30>
        state = '%';
 678:	89d2                	mv	s3,s4
 67a:	b7f5                	j	666 <vprintf+0x42>
      if(c == 'd'){
 67c:	13490463          	beq	s2,s4,7a4 <vprintf+0x180>
 680:	f9d9079b          	addiw	a5,s2,-99
 684:	0ff7f793          	zext.b	a5,a5
 688:	12fb6763          	bltu	s6,a5,7b6 <vprintf+0x192>
 68c:	f9d9079b          	addiw	a5,s2,-99
 690:	0ff7f713          	zext.b	a4,a5
 694:	12eb6163          	bltu	s6,a4,7b6 <vprintf+0x192>
 698:	00271793          	slli	a5,a4,0x2
 69c:	00000717          	auipc	a4,0x0
 6a0:	3f470713          	addi	a4,a4,1012 # a90 <malloc+0x1ba>
 6a4:	97ba                	add	a5,a5,a4
 6a6:	439c                	lw	a5,0(a5)
 6a8:	97ba                	add	a5,a5,a4
 6aa:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6ac:	008b8913          	addi	s2,s7,8
 6b0:	4685                	li	a3,1
 6b2:	4629                	li	a2,10
 6b4:	000ba583          	lw	a1,0(s7)
 6b8:	8556                	mv	a0,s5
 6ba:	00000097          	auipc	ra,0x0
 6be:	ebe080e7          	jalr	-322(ra) # 578 <printint>
 6c2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	b745                	j	666 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c8:	008b8913          	addi	s2,s7,8
 6cc:	4681                	li	a3,0
 6ce:	4629                	li	a2,10
 6d0:	000ba583          	lw	a1,0(s7)
 6d4:	8556                	mv	a0,s5
 6d6:	00000097          	auipc	ra,0x0
 6da:	ea2080e7          	jalr	-350(ra) # 578 <printint>
 6de:	8bca                	mv	s7,s2
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	b751                	j	666 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 6e4:	008b8913          	addi	s2,s7,8
 6e8:	4681                	li	a3,0
 6ea:	4641                	li	a2,16
 6ec:	000ba583          	lw	a1,0(s7)
 6f0:	8556                	mv	a0,s5
 6f2:	00000097          	auipc	ra,0x0
 6f6:	e86080e7          	jalr	-378(ra) # 578 <printint>
 6fa:	8bca                	mv	s7,s2
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	b7a5                	j	666 <vprintf+0x42>
 700:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 702:	008b8c13          	addi	s8,s7,8
 706:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 70a:	03000593          	li	a1,48
 70e:	8556                	mv	a0,s5
 710:	00000097          	auipc	ra,0x0
 714:	e46080e7          	jalr	-442(ra) # 556 <putc>
  putc(fd, 'x');
 718:	07800593          	li	a1,120
 71c:	8556                	mv	a0,s5
 71e:	00000097          	auipc	ra,0x0
 722:	e38080e7          	jalr	-456(ra) # 556 <putc>
 726:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 728:	00000b97          	auipc	s7,0x0
 72c:	3c0b8b93          	addi	s7,s7,960 # ae8 <digits>
 730:	03c9d793          	srli	a5,s3,0x3c
 734:	97de                	add	a5,a5,s7
 736:	0007c583          	lbu	a1,0(a5)
 73a:	8556                	mv	a0,s5
 73c:	00000097          	auipc	ra,0x0
 740:	e1a080e7          	jalr	-486(ra) # 556 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 744:	0992                	slli	s3,s3,0x4
 746:	397d                	addiw	s2,s2,-1
 748:	fe0914e3          	bnez	s2,730 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 74c:	8be2                	mv	s7,s8
      state = 0;
 74e:	4981                	li	s3,0
 750:	6c02                	ld	s8,0(sp)
 752:	bf11                	j	666 <vprintf+0x42>
        s = va_arg(ap, char*);
 754:	008b8993          	addi	s3,s7,8
 758:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 75c:	02090163          	beqz	s2,77e <vprintf+0x15a>
        while(*s != 0){
 760:	00094583          	lbu	a1,0(s2)
 764:	c9a5                	beqz	a1,7d4 <vprintf+0x1b0>
          putc(fd, *s);
 766:	8556                	mv	a0,s5
 768:	00000097          	auipc	ra,0x0
 76c:	dee080e7          	jalr	-530(ra) # 556 <putc>
          s++;
 770:	0905                	addi	s2,s2,1
        while(*s != 0){
 772:	00094583          	lbu	a1,0(s2)
 776:	f9e5                	bnez	a1,766 <vprintf+0x142>
        s = va_arg(ap, char*);
 778:	8bce                	mv	s7,s3
      state = 0;
 77a:	4981                	li	s3,0
 77c:	b5ed                	j	666 <vprintf+0x42>
          s = "(null)";
 77e:	00000917          	auipc	s2,0x0
 782:	30a90913          	addi	s2,s2,778 # a88 <malloc+0x1b2>
        while(*s != 0){
 786:	02800593          	li	a1,40
 78a:	bff1                	j	766 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 78c:	008b8913          	addi	s2,s7,8
 790:	000bc583          	lbu	a1,0(s7)
 794:	8556                	mv	a0,s5
 796:	00000097          	auipc	ra,0x0
 79a:	dc0080e7          	jalr	-576(ra) # 556 <putc>
 79e:	8bca                	mv	s7,s2
      state = 0;
 7a0:	4981                	li	s3,0
 7a2:	b5d1                	j	666 <vprintf+0x42>
        putc(fd, c);
 7a4:	02500593          	li	a1,37
 7a8:	8556                	mv	a0,s5
 7aa:	00000097          	auipc	ra,0x0
 7ae:	dac080e7          	jalr	-596(ra) # 556 <putc>
      state = 0;
 7b2:	4981                	li	s3,0
 7b4:	bd4d                	j	666 <vprintf+0x42>
        putc(fd, '%');
 7b6:	02500593          	li	a1,37
 7ba:	8556                	mv	a0,s5
 7bc:	00000097          	auipc	ra,0x0
 7c0:	d9a080e7          	jalr	-614(ra) # 556 <putc>
        putc(fd, c);
 7c4:	85ca                	mv	a1,s2
 7c6:	8556                	mv	a0,s5
 7c8:	00000097          	auipc	ra,0x0
 7cc:	d8e080e7          	jalr	-626(ra) # 556 <putc>
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	bd51                	j	666 <vprintf+0x42>
        s = va_arg(ap, char*);
 7d4:	8bce                	mv	s7,s3
      state = 0;
 7d6:	4981                	li	s3,0
 7d8:	b579                	j	666 <vprintf+0x42>
 7da:	74e2                	ld	s1,56(sp)
 7dc:	79a2                	ld	s3,40(sp)
 7de:	7a02                	ld	s4,32(sp)
 7e0:	6ae2                	ld	s5,24(sp)
 7e2:	6b42                	ld	s6,16(sp)
 7e4:	6ba2                	ld	s7,8(sp)
    }
  }
}
 7e6:	60a6                	ld	ra,72(sp)
 7e8:	6406                	ld	s0,64(sp)
 7ea:	7942                	ld	s2,48(sp)
 7ec:	6161                	addi	sp,sp,80
 7ee:	8082                	ret

00000000000007f0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7f0:	715d                	addi	sp,sp,-80
 7f2:	ec06                	sd	ra,24(sp)
 7f4:	e822                	sd	s0,16(sp)
 7f6:	1000                	addi	s0,sp,32
 7f8:	e010                	sd	a2,0(s0)
 7fa:	e414                	sd	a3,8(s0)
 7fc:	e818                	sd	a4,16(s0)
 7fe:	ec1c                	sd	a5,24(s0)
 800:	03043023          	sd	a6,32(s0)
 804:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 808:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 80c:	8622                	mv	a2,s0
 80e:	00000097          	auipc	ra,0x0
 812:	e16080e7          	jalr	-490(ra) # 624 <vprintf>
}
 816:	60e2                	ld	ra,24(sp)
 818:	6442                	ld	s0,16(sp)
 81a:	6161                	addi	sp,sp,80
 81c:	8082                	ret

000000000000081e <printf>:

void
printf(const char *fmt, ...)
{
 81e:	711d                	addi	sp,sp,-96
 820:	ec06                	sd	ra,24(sp)
 822:	e822                	sd	s0,16(sp)
 824:	1000                	addi	s0,sp,32
 826:	e40c                	sd	a1,8(s0)
 828:	e810                	sd	a2,16(s0)
 82a:	ec14                	sd	a3,24(s0)
 82c:	f018                	sd	a4,32(s0)
 82e:	f41c                	sd	a5,40(s0)
 830:	03043823          	sd	a6,48(s0)
 834:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 838:	00840613          	addi	a2,s0,8
 83c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 840:	85aa                	mv	a1,a0
 842:	4505                	li	a0,1
 844:	00000097          	auipc	ra,0x0
 848:	de0080e7          	jalr	-544(ra) # 624 <vprintf>
}
 84c:	60e2                	ld	ra,24(sp)
 84e:	6442                	ld	s0,16(sp)
 850:	6125                	addi	sp,sp,96
 852:	8082                	ret

0000000000000854 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 854:	1141                	addi	sp,sp,-16
 856:	e422                	sd	s0,8(sp)
 858:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 85a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85e:	00000797          	auipc	a5,0x0
 862:	6b27b783          	ld	a5,1714(a5) # f10 <freep>
 866:	a02d                	j	890 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 868:	4618                	lw	a4,8(a2)
 86a:	9f2d                	addw	a4,a4,a1
 86c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 870:	6398                	ld	a4,0(a5)
 872:	6310                	ld	a2,0(a4)
 874:	a83d                	j	8b2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 876:	ff852703          	lw	a4,-8(a0)
 87a:	9f31                	addw	a4,a4,a2
 87c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 87e:	ff053683          	ld	a3,-16(a0)
 882:	a091                	j	8c6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 884:	6398                	ld	a4,0(a5)
 886:	00e7e463          	bltu	a5,a4,88e <free+0x3a>
 88a:	00e6ea63          	bltu	a3,a4,89e <free+0x4a>
{
 88e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 890:	fed7fae3          	bgeu	a5,a3,884 <free+0x30>
 894:	6398                	ld	a4,0(a5)
 896:	00e6e463          	bltu	a3,a4,89e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89a:	fee7eae3          	bltu	a5,a4,88e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 89e:	ff852583          	lw	a1,-8(a0)
 8a2:	6390                	ld	a2,0(a5)
 8a4:	02059813          	slli	a6,a1,0x20
 8a8:	01c85713          	srli	a4,a6,0x1c
 8ac:	9736                	add	a4,a4,a3
 8ae:	fae60de3          	beq	a2,a4,868 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8b2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8b6:	4790                	lw	a2,8(a5)
 8b8:	02061593          	slli	a1,a2,0x20
 8bc:	01c5d713          	srli	a4,a1,0x1c
 8c0:	973e                	add	a4,a4,a5
 8c2:	fae68ae3          	beq	a3,a4,876 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8c6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8c8:	00000717          	auipc	a4,0x0
 8cc:	64f73423          	sd	a5,1608(a4) # f10 <freep>
}
 8d0:	6422                	ld	s0,8(sp)
 8d2:	0141                	addi	sp,sp,16
 8d4:	8082                	ret

00000000000008d6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8d6:	7139                	addi	sp,sp,-64
 8d8:	fc06                	sd	ra,56(sp)
 8da:	f822                	sd	s0,48(sp)
 8dc:	f426                	sd	s1,40(sp)
 8de:	ec4e                	sd	s3,24(sp)
 8e0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e2:	02051493          	slli	s1,a0,0x20
 8e6:	9081                	srli	s1,s1,0x20
 8e8:	04bd                	addi	s1,s1,15
 8ea:	8091                	srli	s1,s1,0x4
 8ec:	0014899b          	addiw	s3,s1,1
 8f0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8f2:	00000517          	auipc	a0,0x0
 8f6:	61e53503          	ld	a0,1566(a0) # f10 <freep>
 8fa:	c915                	beqz	a0,92e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8fe:	4798                	lw	a4,8(a5)
 900:	08977e63          	bgeu	a4,s1,99c <malloc+0xc6>
 904:	f04a                	sd	s2,32(sp)
 906:	e852                	sd	s4,16(sp)
 908:	e456                	sd	s5,8(sp)
 90a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 90c:	8a4e                	mv	s4,s3
 90e:	0009871b          	sext.w	a4,s3
 912:	6685                	lui	a3,0x1
 914:	00d77363          	bgeu	a4,a3,91a <malloc+0x44>
 918:	6a05                	lui	s4,0x1
 91a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 91e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 922:	00000917          	auipc	s2,0x0
 926:	5ee90913          	addi	s2,s2,1518 # f10 <freep>
  if(p == (char*)-1)
 92a:	5afd                	li	s5,-1
 92c:	a091                	j	970 <malloc+0x9a>
 92e:	f04a                	sd	s2,32(sp)
 930:	e852                	sd	s4,16(sp)
 932:	e456                	sd	s5,8(sp)
 934:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 936:	00000797          	auipc	a5,0x0
 93a:	5e278793          	addi	a5,a5,1506 # f18 <base>
 93e:	00000717          	auipc	a4,0x0
 942:	5cf73923          	sd	a5,1490(a4) # f10 <freep>
 946:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 948:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 94c:	b7c1                	j	90c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 94e:	6398                	ld	a4,0(a5)
 950:	e118                	sd	a4,0(a0)
 952:	a08d                	j	9b4 <malloc+0xde>
  hp->s.size = nu;
 954:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 958:	0541                	addi	a0,a0,16
 95a:	00000097          	auipc	ra,0x0
 95e:	efa080e7          	jalr	-262(ra) # 854 <free>
  return freep;
 962:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 966:	c13d                	beqz	a0,9cc <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 968:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 96a:	4798                	lw	a4,8(a5)
 96c:	02977463          	bgeu	a4,s1,994 <malloc+0xbe>
    if(p == freep)
 970:	00093703          	ld	a4,0(s2)
 974:	853e                	mv	a0,a5
 976:	fef719e3          	bne	a4,a5,968 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 97a:	8552                	mv	a0,s4
 97c:	00000097          	auipc	ra,0x0
 980:	bc2080e7          	jalr	-1086(ra) # 53e <sbrk>
  if(p == (char*)-1)
 984:	fd5518e3          	bne	a0,s5,954 <malloc+0x7e>
        return 0;
 988:	4501                	li	a0,0
 98a:	7902                	ld	s2,32(sp)
 98c:	6a42                	ld	s4,16(sp)
 98e:	6aa2                	ld	s5,8(sp)
 990:	6b02                	ld	s6,0(sp)
 992:	a03d                	j	9c0 <malloc+0xea>
 994:	7902                	ld	s2,32(sp)
 996:	6a42                	ld	s4,16(sp)
 998:	6aa2                	ld	s5,8(sp)
 99a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 99c:	fae489e3          	beq	s1,a4,94e <malloc+0x78>
        p->s.size -= nunits;
 9a0:	4137073b          	subw	a4,a4,s3
 9a4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9a6:	02071693          	slli	a3,a4,0x20
 9aa:	01c6d713          	srli	a4,a3,0x1c
 9ae:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9b0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9b4:	00000717          	auipc	a4,0x0
 9b8:	54a73e23          	sd	a0,1372(a4) # f10 <freep>
      return (void*)(p + 1);
 9bc:	01078513          	addi	a0,a5,16
  }
}
 9c0:	70e2                	ld	ra,56(sp)
 9c2:	7442                	ld	s0,48(sp)
 9c4:	74a2                	ld	s1,40(sp)
 9c6:	69e2                	ld	s3,24(sp)
 9c8:	6121                	addi	sp,sp,64
 9ca:	8082                	ret
 9cc:	7902                	ld	s2,32(sp)
 9ce:	6a42                	ld	s4,16(sp)
 9d0:	6aa2                	ld	s5,8(sp)
 9d2:	6b02                	ld	s6,0(sp)
 9d4:	b7f5                	j	9c0 <malloc+0xea>
