
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	02013103          	ld	sp,32(sp) # 8000b020 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	738050ef          	jal	8000574e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00029797          	auipc	a5,0x29
    80000034:	21078793          	addi	a5,a5,528 # 80029240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	0000c917          	auipc	s2,0xc
    80000054:	fe090913          	addi	s2,s2,-32 # 8000c030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	13c080e7          	jalr	316(ra) # 80006196 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	1dc080e7          	jalr	476(ra) # 8000624a <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f7e50513          	addi	a0,a0,-130 # 80008000 <etext>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	b92080e7          	jalr	-1134(ra) # 80005c1c <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000009c:	6785                	lui	a5,0x1
    8000009e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a2:	00e504b3          	add	s1,a0,a4
    800000a6:	777d                	lui	a4,0xfffff
    800000a8:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	94be                	add	s1,s1,a5
    800000ac:	0295e463          	bltu	a1,s1,800000d4 <freerange+0x42>
    800000b0:	e84a                	sd	s2,16(sp)
    800000b2:	e44e                	sd	s3,8(sp)
    800000b4:	e052                	sd	s4,0(sp)
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
    800000ce:	6942                	ld	s2,16(sp)
    800000d0:	69a2                	ld	s3,8(sp)
    800000d2:	6a02                	ld	s4,0(sp)
}
    800000d4:	70a2                	ld	ra,40(sp)
    800000d6:	7402                	ld	s0,32(sp)
    800000d8:	64e2                	ld	s1,24(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f2a58593          	addi	a1,a1,-214 # 80008010 <etext+0x10>
    800000ee:	0000c517          	auipc	a0,0xc
    800000f2:	f4250513          	addi	a0,a0,-190 # 8000c030 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	010080e7          	jalr	16(ra) # 80006106 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00029517          	auipc	a0,0x29
    80000106:	13e50513          	addi	a0,a0,318 # 80029240 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	0000c497          	auipc	s1,0xc
    80000128:	f0c48493          	addi	s1,s1,-244 # 8000c030 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	068080e7          	jalr	104(ra) # 80006196 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	0000c517          	auipc	a0,0xc
    80000140:	ef450513          	addi	a0,a0,-268 # 8000c030 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	104080e7          	jalr	260(ra) # 8000624a <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	0000c517          	auipc	a0,0xc
    8000016c:	ec850513          	addi	a0,a0,-312 # 8000c030 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	0da080e7          	jalr	218(ra) # 8000624a <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd5dc1>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	feb79ae3          	bne	a5,a1,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fef71ae3          	bne	a4,a5,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a801                	j	8000027a <strncmp+0x30>
    8000026c:	4501                	li	a0,0
    8000026e:	a031                	j	8000027a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000270:	00054503          	lbu	a0,0(a0)
    80000274:	0005c783          	lbu	a5,0(a1)
    80000278:	9d1d                	subw	a0,a0,a5
}
    8000027a:	6422                	ld	s0,8(sp)
    8000027c:	0141                	addi	sp,sp,16
    8000027e:	8082                	ret

0000000080000280 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000280:	1141                	addi	sp,sp,-16
    80000282:	e422                	sd	s0,8(sp)
    80000284:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000286:	87aa                	mv	a5,a0
    80000288:	86b2                	mv	a3,a2
    8000028a:	367d                	addiw	a2,a2,-1
    8000028c:	02d05563          	blez	a3,800002b6 <strncpy+0x36>
    80000290:	0785                	addi	a5,a5,1
    80000292:	0005c703          	lbu	a4,0(a1)
    80000296:	fee78fa3          	sb	a4,-1(a5)
    8000029a:	0585                	addi	a1,a1,1
    8000029c:	f775                	bnez	a4,80000288 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000029e:	873e                	mv	a4,a5
    800002a0:	9fb5                	addw	a5,a5,a3
    800002a2:	37fd                	addiw	a5,a5,-1
    800002a4:	00c05963          	blez	a2,800002b6 <strncpy+0x36>
    *s++ = 0;
    800002a8:	0705                	addi	a4,a4,1
    800002aa:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002ae:	40e786bb          	subw	a3,a5,a4
    800002b2:	fed04be3          	bgtz	a3,800002a8 <strncpy+0x28>
  return os;
}
    800002b6:	6422                	ld	s0,8(sp)
    800002b8:	0141                	addi	sp,sp,16
    800002ba:	8082                	ret

00000000800002bc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002bc:	1141                	addi	sp,sp,-16
    800002be:	e422                	sd	s0,8(sp)
    800002c0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002c2:	02c05363          	blez	a2,800002e8 <safestrcpy+0x2c>
    800002c6:	fff6069b          	addiw	a3,a2,-1
    800002ca:	1682                	slli	a3,a3,0x20
    800002cc:	9281                	srli	a3,a3,0x20
    800002ce:	96ae                	add	a3,a3,a1
    800002d0:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002d2:	00d58963          	beq	a1,a3,800002e4 <safestrcpy+0x28>
    800002d6:	0585                	addi	a1,a1,1
    800002d8:	0785                	addi	a5,a5,1
    800002da:	fff5c703          	lbu	a4,-1(a1)
    800002de:	fee78fa3          	sb	a4,-1(a5)
    800002e2:	fb65                	bnez	a4,800002d2 <safestrcpy+0x16>
    ;
  *s = 0;
    800002e4:	00078023          	sb	zero,0(a5)
  return os;
}
    800002e8:	6422                	ld	s0,8(sp)
    800002ea:	0141                	addi	sp,sp,16
    800002ec:	8082                	ret

00000000800002ee <strlen>:

int
strlen(const char *s)
{
    800002ee:	1141                	addi	sp,sp,-16
    800002f0:	e422                	sd	s0,8(sp)
    800002f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002f4:	00054783          	lbu	a5,0(a0)
    800002f8:	cf91                	beqz	a5,80000314 <strlen+0x26>
    800002fa:	0505                	addi	a0,a0,1
    800002fc:	87aa                	mv	a5,a0
    800002fe:	86be                	mv	a3,a5
    80000300:	0785                	addi	a5,a5,1
    80000302:	fff7c703          	lbu	a4,-1(a5)
    80000306:	ff65                	bnez	a4,800002fe <strlen+0x10>
    80000308:	40a6853b          	subw	a0,a3,a0
    8000030c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    8000030e:	6422                	ld	s0,8(sp)
    80000310:	0141                	addi	sp,sp,16
    80000312:	8082                	ret
  for(n = 0; s[n]; n++)
    80000314:	4501                	li	a0,0
    80000316:	bfe5                	j	8000030e <strlen+0x20>

0000000080000318 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000318:	1141                	addi	sp,sp,-16
    8000031a:	e406                	sd	ra,8(sp)
    8000031c:	e022                	sd	s0,0(sp)
    8000031e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000320:	00001097          	auipc	ra,0x1
    80000324:	b30080e7          	jalr	-1232(ra) # 80000e50 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000328:	0000c717          	auipc	a4,0xc
    8000032c:	cd870713          	addi	a4,a4,-808 # 8000c000 <started>
  if(cpuid() == 0){
    80000330:	c139                	beqz	a0,80000376 <main+0x5e>
    while(started == 0)
    80000332:	431c                	lw	a5,0(a4)
    80000334:	2781                	sext.w	a5,a5
    80000336:	dff5                	beqz	a5,80000332 <main+0x1a>
      ;
    __sync_synchronize();
    80000338:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    8000033c:	00001097          	auipc	ra,0x1
    80000340:	b14080e7          	jalr	-1260(ra) # 80000e50 <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	addi	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	918080e7          	jalr	-1768(ra) # 80005c66 <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00001097          	auipc	ra,0x1
    80000362:	776080e7          	jalr	1910(ra) # 80001ad4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	d9e080e7          	jalr	-610(ra) # 80005104 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	022080e7          	jalr	34(ra) # 80001390 <scheduler>
    consoleinit();
    80000376:	00005097          	auipc	ra,0x5
    8000037a:	7b6080e7          	jalr	1974(ra) # 80005b2c <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	af0080e7          	jalr	-1296(ra) # 80005e6e <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	8d8080e7          	jalr	-1832(ra) # 80005c66 <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	8c8080e7          	jalr	-1848(ra) # 80005c66 <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	addi	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	8b8080e7          	jalr	-1864(ra) # 80005c66 <printf>
    kinit();         // physical page allocator
    800003b6:	00000097          	auipc	ra,0x0
    800003ba:	d28080e7          	jalr	-728(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	322080e7          	jalr	802(ra) # 800006e0 <kvminit>
    kvminithart();   // turn on paging
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	068080e7          	jalr	104(ra) # 8000042e <kvminithart>
    procinit();      // process table
    800003ce:	00001097          	auipc	ra,0x1
    800003d2:	9c4080e7          	jalr	-1596(ra) # 80000d92 <procinit>
    trapinit();      // trap vectors
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	6d6080e7          	jalr	1750(ra) # 80001aac <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	6f6080e7          	jalr	1782(ra) # 80001ad4 <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	d04080e7          	jalr	-764(ra) # 800050ea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	d16080e7          	jalr	-746(ra) # 80005104 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	e30080e7          	jalr	-464(ra) # 80002226 <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	4bc080e7          	jalr	1212(ra) # 800028ba <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	460080e7          	jalr	1120(ra) # 80003866 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	e16080e7          	jalr	-490(ra) # 80005224 <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	d3e080e7          	jalr	-706(ra) # 80001154 <userinit>
    __sync_synchronize();
    8000041e:	0330000f          	fence	rw,rw
    started = 1;
    80000422:	4785                	li	a5,1
    80000424:	0000c717          	auipc	a4,0xc
    80000428:	bcf72e23          	sw	a5,-1060(a4) # 8000c000 <started>
    8000042c:	b789                	j	8000036e <main+0x56>

000000008000042e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000042e:	1141                	addi	sp,sp,-16
    80000430:	e422                	sd	s0,8(sp)
    80000432:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000434:	0000c797          	auipc	a5,0xc
    80000438:	bd47b783          	ld	a5,-1068(a5) # 8000c008 <kernel_pagetable>
    8000043c:	83b1                	srli	a5,a5,0xc
    8000043e:	577d                	li	a4,-1
    80000440:	177e                	slli	a4,a4,0x3f
    80000442:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000444:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000448:	12000073          	sfence.vma
  sfence_vma();
}
    8000044c:	6422                	ld	s0,8(sp)
    8000044e:	0141                	addi	sp,sp,16
    80000450:	8082                	ret

0000000080000452 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000452:	7139                	addi	sp,sp,-64
    80000454:	fc06                	sd	ra,56(sp)
    80000456:	f822                	sd	s0,48(sp)
    80000458:	f426                	sd	s1,40(sp)
    8000045a:	f04a                	sd	s2,32(sp)
    8000045c:	ec4e                	sd	s3,24(sp)
    8000045e:	e852                	sd	s4,16(sp)
    80000460:	e456                	sd	s5,8(sp)
    80000462:	e05a                	sd	s6,0(sp)
    80000464:	0080                	addi	s0,sp,64
    80000466:	84aa                	mv	s1,a0
    80000468:	89ae                	mv	s3,a1
    8000046a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000046c:	57fd                	li	a5,-1
    8000046e:	83e9                	srli	a5,a5,0x1a
    80000470:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000472:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000474:	04b7f263          	bgeu	a5,a1,800004b8 <walk+0x66>
    panic("walk");
    80000478:	00008517          	auipc	a0,0x8
    8000047c:	bd850513          	addi	a0,a0,-1064 # 80008050 <etext+0x50>
    80000480:	00005097          	auipc	ra,0x5
    80000484:	79c080e7          	jalr	1948(ra) # 80005c1c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000488:	060a8663          	beqz	s5,800004f4 <walk+0xa2>
    8000048c:	00000097          	auipc	ra,0x0
    80000490:	c8e080e7          	jalr	-882(ra) # 8000011a <kalloc>
    80000494:	84aa                	mv	s1,a0
    80000496:	c529                	beqz	a0,800004e0 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000498:	6605                	lui	a2,0x1
    8000049a:	4581                	li	a1,0
    8000049c:	00000097          	auipc	ra,0x0
    800004a0:	cde080e7          	jalr	-802(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004a4:	00c4d793          	srli	a5,s1,0xc
    800004a8:	07aa                	slli	a5,a5,0xa
    800004aa:	0017e793          	ori	a5,a5,1
    800004ae:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004b2:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd5db7>
    800004b4:	036a0063          	beq	s4,s6,800004d4 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004b8:	0149d933          	srl	s2,s3,s4
    800004bc:	1ff97913          	andi	s2,s2,511
    800004c0:	090e                	slli	s2,s2,0x3
    800004c2:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004c4:	00093483          	ld	s1,0(s2)
    800004c8:	0014f793          	andi	a5,s1,1
    800004cc:	dfd5                	beqz	a5,80000488 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004ce:	80a9                	srli	s1,s1,0xa
    800004d0:	04b2                	slli	s1,s1,0xc
    800004d2:	b7c5                	j	800004b2 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004d4:	00c9d513          	srli	a0,s3,0xc
    800004d8:	1ff57513          	andi	a0,a0,511
    800004dc:	050e                	slli	a0,a0,0x3
    800004de:	9526                	add	a0,a0,s1
}
    800004e0:	70e2                	ld	ra,56(sp)
    800004e2:	7442                	ld	s0,48(sp)
    800004e4:	74a2                	ld	s1,40(sp)
    800004e6:	7902                	ld	s2,32(sp)
    800004e8:	69e2                	ld	s3,24(sp)
    800004ea:	6a42                	ld	s4,16(sp)
    800004ec:	6aa2                	ld	s5,8(sp)
    800004ee:	6b02                	ld	s6,0(sp)
    800004f0:	6121                	addi	sp,sp,64
    800004f2:	8082                	ret
        return 0;
    800004f4:	4501                	li	a0,0
    800004f6:	b7ed                	j	800004e0 <walk+0x8e>

00000000800004f8 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800004f8:	57fd                	li	a5,-1
    800004fa:	83e9                	srli	a5,a5,0x1a
    800004fc:	00b7f463          	bgeu	a5,a1,80000504 <walkaddr+0xc>
    return 0;
    80000500:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000502:	8082                	ret
{
    80000504:	1141                	addi	sp,sp,-16
    80000506:	e406                	sd	ra,8(sp)
    80000508:	e022                	sd	s0,0(sp)
    8000050a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000050c:	4601                	li	a2,0
    8000050e:	00000097          	auipc	ra,0x0
    80000512:	f44080e7          	jalr	-188(ra) # 80000452 <walk>
  if(pte == 0)
    80000516:	c105                	beqz	a0,80000536 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000518:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000051a:	0117f693          	andi	a3,a5,17
    8000051e:	4745                	li	a4,17
    return 0;
    80000520:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000522:	00e68663          	beq	a3,a4,8000052e <walkaddr+0x36>
}
    80000526:	60a2                	ld	ra,8(sp)
    80000528:	6402                	ld	s0,0(sp)
    8000052a:	0141                	addi	sp,sp,16
    8000052c:	8082                	ret
  pa = PTE2PA(*pte);
    8000052e:	83a9                	srli	a5,a5,0xa
    80000530:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000534:	bfcd                	j	80000526 <walkaddr+0x2e>
    return 0;
    80000536:	4501                	li	a0,0
    80000538:	b7fd                	j	80000526 <walkaddr+0x2e>

000000008000053a <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000053a:	715d                	addi	sp,sp,-80
    8000053c:	e486                	sd	ra,72(sp)
    8000053e:	e0a2                	sd	s0,64(sp)
    80000540:	fc26                	sd	s1,56(sp)
    80000542:	f84a                	sd	s2,48(sp)
    80000544:	f44e                	sd	s3,40(sp)
    80000546:	f052                	sd	s4,32(sp)
    80000548:	ec56                	sd	s5,24(sp)
    8000054a:	e85a                	sd	s6,16(sp)
    8000054c:	e45e                	sd	s7,8(sp)
    8000054e:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000550:	c639                	beqz	a2,8000059e <mappages+0x64>
    80000552:	8aaa                	mv	s5,a0
    80000554:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000556:	777d                	lui	a4,0xfffff
    80000558:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000055c:	fff58993          	addi	s3,a1,-1
    80000560:	99b2                	add	s3,s3,a2
    80000562:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000566:	893e                	mv	s2,a5
    80000568:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000056c:	6b85                	lui	s7,0x1
    8000056e:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80000572:	4605                	li	a2,1
    80000574:	85ca                	mv	a1,s2
    80000576:	8556                	mv	a0,s5
    80000578:	00000097          	auipc	ra,0x0
    8000057c:	eda080e7          	jalr	-294(ra) # 80000452 <walk>
    80000580:	cd1d                	beqz	a0,800005be <mappages+0x84>
    if(*pte & PTE_V)
    80000582:	611c                	ld	a5,0(a0)
    80000584:	8b85                	andi	a5,a5,1
    80000586:	e785                	bnez	a5,800005ae <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000588:	80b1                	srli	s1,s1,0xc
    8000058a:	04aa                	slli	s1,s1,0xa
    8000058c:	0164e4b3          	or	s1,s1,s6
    80000590:	0014e493          	ori	s1,s1,1
    80000594:	e104                	sd	s1,0(a0)
    if(a == last)
    80000596:	05390063          	beq	s2,s3,800005d6 <mappages+0x9c>
    a += PGSIZE;
    8000059a:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000059c:	bfc9                	j	8000056e <mappages+0x34>
    panic("mappages: size");
    8000059e:	00008517          	auipc	a0,0x8
    800005a2:	aba50513          	addi	a0,a0,-1350 # 80008058 <etext+0x58>
    800005a6:	00005097          	auipc	ra,0x5
    800005aa:	676080e7          	jalr	1654(ra) # 80005c1c <panic>
      panic("mappages: remap");
    800005ae:	00008517          	auipc	a0,0x8
    800005b2:	aba50513          	addi	a0,a0,-1350 # 80008068 <etext+0x68>
    800005b6:	00005097          	auipc	ra,0x5
    800005ba:	666080e7          	jalr	1638(ra) # 80005c1c <panic>
      return -1;
    800005be:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005c0:	60a6                	ld	ra,72(sp)
    800005c2:	6406                	ld	s0,64(sp)
    800005c4:	74e2                	ld	s1,56(sp)
    800005c6:	7942                	ld	s2,48(sp)
    800005c8:	79a2                	ld	s3,40(sp)
    800005ca:	7a02                	ld	s4,32(sp)
    800005cc:	6ae2                	ld	s5,24(sp)
    800005ce:	6b42                	ld	s6,16(sp)
    800005d0:	6ba2                	ld	s7,8(sp)
    800005d2:	6161                	addi	sp,sp,80
    800005d4:	8082                	ret
  return 0;
    800005d6:	4501                	li	a0,0
    800005d8:	b7e5                	j	800005c0 <mappages+0x86>

00000000800005da <kvmmap>:
{
    800005da:	1141                	addi	sp,sp,-16
    800005dc:	e406                	sd	ra,8(sp)
    800005de:	e022                	sd	s0,0(sp)
    800005e0:	0800                	addi	s0,sp,16
    800005e2:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005e4:	86b2                	mv	a3,a2
    800005e6:	863e                	mv	a2,a5
    800005e8:	00000097          	auipc	ra,0x0
    800005ec:	f52080e7          	jalr	-174(ra) # 8000053a <mappages>
    800005f0:	e509                	bnez	a0,800005fa <kvmmap+0x20>
}
    800005f2:	60a2                	ld	ra,8(sp)
    800005f4:	6402                	ld	s0,0(sp)
    800005f6:	0141                	addi	sp,sp,16
    800005f8:	8082                	ret
    panic("kvmmap");
    800005fa:	00008517          	auipc	a0,0x8
    800005fe:	a7e50513          	addi	a0,a0,-1410 # 80008078 <etext+0x78>
    80000602:	00005097          	auipc	ra,0x5
    80000606:	61a080e7          	jalr	1562(ra) # 80005c1c <panic>

000000008000060a <kvmmake>:
{
    8000060a:	1101                	addi	sp,sp,-32
    8000060c:	ec06                	sd	ra,24(sp)
    8000060e:	e822                	sd	s0,16(sp)
    80000610:	e426                	sd	s1,8(sp)
    80000612:	e04a                	sd	s2,0(sp)
    80000614:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000616:	00000097          	auipc	ra,0x0
    8000061a:	b04080e7          	jalr	-1276(ra) # 8000011a <kalloc>
    8000061e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000620:	6605                	lui	a2,0x1
    80000622:	4581                	li	a1,0
    80000624:	00000097          	auipc	ra,0x0
    80000628:	b56080e7          	jalr	-1194(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000062c:	4719                	li	a4,6
    8000062e:	6685                	lui	a3,0x1
    80000630:	10000637          	lui	a2,0x10000
    80000634:	100005b7          	lui	a1,0x10000
    80000638:	8526                	mv	a0,s1
    8000063a:	00000097          	auipc	ra,0x0
    8000063e:	fa0080e7          	jalr	-96(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000642:	4719                	li	a4,6
    80000644:	6685                	lui	a3,0x1
    80000646:	10001637          	lui	a2,0x10001
    8000064a:	100015b7          	lui	a1,0x10001
    8000064e:	8526                	mv	a0,s1
    80000650:	00000097          	auipc	ra,0x0
    80000654:	f8a080e7          	jalr	-118(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000658:	4719                	li	a4,6
    8000065a:	004006b7          	lui	a3,0x400
    8000065e:	0c000637          	lui	a2,0xc000
    80000662:	0c0005b7          	lui	a1,0xc000
    80000666:	8526                	mv	a0,s1
    80000668:	00000097          	auipc	ra,0x0
    8000066c:	f72080e7          	jalr	-142(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000670:	00008917          	auipc	s2,0x8
    80000674:	99090913          	addi	s2,s2,-1648 # 80008000 <etext>
    80000678:	4729                	li	a4,10
    8000067a:	80008697          	auipc	a3,0x80008
    8000067e:	98668693          	addi	a3,a3,-1658 # 8000 <_entry-0x7fff8000>
    80000682:	4605                	li	a2,1
    80000684:	067e                	slli	a2,a2,0x1f
    80000686:	85b2                	mv	a1,a2
    80000688:	8526                	mv	a0,s1
    8000068a:	00000097          	auipc	ra,0x0
    8000068e:	f50080e7          	jalr	-176(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000692:	46c5                	li	a3,17
    80000694:	06ee                	slli	a3,a3,0x1b
    80000696:	4719                	li	a4,6
    80000698:	412686b3          	sub	a3,a3,s2
    8000069c:	864a                	mv	a2,s2
    8000069e:	85ca                	mv	a1,s2
    800006a0:	8526                	mv	a0,s1
    800006a2:	00000097          	auipc	ra,0x0
    800006a6:	f38080e7          	jalr	-200(ra) # 800005da <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006aa:	4729                	li	a4,10
    800006ac:	6685                	lui	a3,0x1
    800006ae:	00007617          	auipc	a2,0x7
    800006b2:	95260613          	addi	a2,a2,-1710 # 80007000 <_trampoline>
    800006b6:	040005b7          	lui	a1,0x4000
    800006ba:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006bc:	05b2                	slli	a1,a1,0xc
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f1a080e7          	jalr	-230(ra) # 800005da <kvmmap>
  proc_mapstacks(kpgtbl);
    800006c8:	8526                	mv	a0,s1
    800006ca:	00000097          	auipc	ra,0x0
    800006ce:	624080e7          	jalr	1572(ra) # 80000cee <proc_mapstacks>
}
    800006d2:	8526                	mv	a0,s1
    800006d4:	60e2                	ld	ra,24(sp)
    800006d6:	6442                	ld	s0,16(sp)
    800006d8:	64a2                	ld	s1,8(sp)
    800006da:	6902                	ld	s2,0(sp)
    800006dc:	6105                	addi	sp,sp,32
    800006de:	8082                	ret

00000000800006e0 <kvminit>:
{
    800006e0:	1141                	addi	sp,sp,-16
    800006e2:	e406                	sd	ra,8(sp)
    800006e4:	e022                	sd	s0,0(sp)
    800006e6:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006e8:	00000097          	auipc	ra,0x0
    800006ec:	f22080e7          	jalr	-222(ra) # 8000060a <kvmmake>
    800006f0:	0000c797          	auipc	a5,0xc
    800006f4:	90a7bc23          	sd	a0,-1768(a5) # 8000c008 <kernel_pagetable>
}
    800006f8:	60a2                	ld	ra,8(sp)
    800006fa:	6402                	ld	s0,0(sp)
    800006fc:	0141                	addi	sp,sp,16
    800006fe:	8082                	ret

0000000080000700 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000700:	715d                	addi	sp,sp,-80
    80000702:	e486                	sd	ra,72(sp)
    80000704:	e0a2                	sd	s0,64(sp)
    80000706:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000708:	03459793          	slli	a5,a1,0x34
    8000070c:	e39d                	bnez	a5,80000732 <uvmunmap+0x32>
    8000070e:	f84a                	sd	s2,48(sp)
    80000710:	f44e                	sd	s3,40(sp)
    80000712:	f052                	sd	s4,32(sp)
    80000714:	ec56                	sd	s5,24(sp)
    80000716:	e85a                	sd	s6,16(sp)
    80000718:	e45e                	sd	s7,8(sp)
    8000071a:	8a2a                	mv	s4,a0
    8000071c:	892e                	mv	s2,a1
    8000071e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000720:	0632                	slli	a2,a2,0xc
    80000722:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000726:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000728:	6b05                	lui	s6,0x1
    8000072a:	0935fb63          	bgeu	a1,s3,800007c0 <uvmunmap+0xc0>
    8000072e:	fc26                	sd	s1,56(sp)
    80000730:	a8a9                	j	8000078a <uvmunmap+0x8a>
    80000732:	fc26                	sd	s1,56(sp)
    80000734:	f84a                	sd	s2,48(sp)
    80000736:	f44e                	sd	s3,40(sp)
    80000738:	f052                	sd	s4,32(sp)
    8000073a:	ec56                	sd	s5,24(sp)
    8000073c:	e85a                	sd	s6,16(sp)
    8000073e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000740:	00008517          	auipc	a0,0x8
    80000744:	94050513          	addi	a0,a0,-1728 # 80008080 <etext+0x80>
    80000748:	00005097          	auipc	ra,0x5
    8000074c:	4d4080e7          	jalr	1236(ra) # 80005c1c <panic>
      panic("uvmunmap: walk");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	94850513          	addi	a0,a0,-1720 # 80008098 <etext+0x98>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	4c4080e7          	jalr	1220(ra) # 80005c1c <panic>
      panic("uvmunmap: not mapped");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	94850513          	addi	a0,a0,-1720 # 800080a8 <etext+0xa8>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	4b4080e7          	jalr	1204(ra) # 80005c1c <panic>
      panic("uvmunmap: not a leaf");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	95050513          	addi	a0,a0,-1712 # 800080c0 <etext+0xc0>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	4a4080e7          	jalr	1188(ra) # 80005c1c <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80000780:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000784:	995a                	add	s2,s2,s6
    80000786:	03397c63          	bgeu	s2,s3,800007be <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000078a:	4601                	li	a2,0
    8000078c:	85ca                	mv	a1,s2
    8000078e:	8552                	mv	a0,s4
    80000790:	00000097          	auipc	ra,0x0
    80000794:	cc2080e7          	jalr	-830(ra) # 80000452 <walk>
    80000798:	84aa                	mv	s1,a0
    8000079a:	d95d                	beqz	a0,80000750 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    8000079c:	6108                	ld	a0,0(a0)
    8000079e:	00157793          	andi	a5,a0,1
    800007a2:	dfdd                	beqz	a5,80000760 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007a4:	3ff57793          	andi	a5,a0,1023
    800007a8:	fd7784e3          	beq	a5,s7,80000770 <uvmunmap+0x70>
    if(do_free){
    800007ac:	fc0a8ae3          	beqz	s5,80000780 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800007b0:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007b2:	0532                	slli	a0,a0,0xc
    800007b4:	00000097          	auipc	ra,0x0
    800007b8:	868080e7          	jalr	-1944(ra) # 8000001c <kfree>
    800007bc:	b7d1                	j	80000780 <uvmunmap+0x80>
    800007be:	74e2                	ld	s1,56(sp)
    800007c0:	7942                	ld	s2,48(sp)
    800007c2:	79a2                	ld	s3,40(sp)
    800007c4:	7a02                	ld	s4,32(sp)
    800007c6:	6ae2                	ld	s5,24(sp)
    800007c8:	6b42                	ld	s6,16(sp)
    800007ca:	6ba2                	ld	s7,8(sp)
  }
}
    800007cc:	60a6                	ld	ra,72(sp)
    800007ce:	6406                	ld	s0,64(sp)
    800007d0:	6161                	addi	sp,sp,80
    800007d2:	8082                	ret

00000000800007d4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d4:	1101                	addi	sp,sp,-32
    800007d6:	ec06                	sd	ra,24(sp)
    800007d8:	e822                	sd	s0,16(sp)
    800007da:	e426                	sd	s1,8(sp)
    800007dc:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007de:	00000097          	auipc	ra,0x0
    800007e2:	93c080e7          	jalr	-1732(ra) # 8000011a <kalloc>
    800007e6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e8:	c519                	beqz	a0,800007f6 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007ea:	6605                	lui	a2,0x1
    800007ec:	4581                	li	a1,0
    800007ee:	00000097          	auipc	ra,0x0
    800007f2:	98c080e7          	jalr	-1652(ra) # 8000017a <memset>
  return pagetable;
}
    800007f6:	8526                	mv	a0,s1
    800007f8:	60e2                	ld	ra,24(sp)
    800007fa:	6442                	ld	s0,16(sp)
    800007fc:	64a2                	ld	s1,8(sp)
    800007fe:	6105                	addi	sp,sp,32
    80000800:	8082                	ret

0000000080000802 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000802:	7179                	addi	sp,sp,-48
    80000804:	f406                	sd	ra,40(sp)
    80000806:	f022                	sd	s0,32(sp)
    80000808:	ec26                	sd	s1,24(sp)
    8000080a:	e84a                	sd	s2,16(sp)
    8000080c:	e44e                	sd	s3,8(sp)
    8000080e:	e052                	sd	s4,0(sp)
    80000810:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000812:	6785                	lui	a5,0x1
    80000814:	04f67863          	bgeu	a2,a5,80000864 <uvminit+0x62>
    80000818:	8a2a                	mv	s4,a0
    8000081a:	89ae                	mv	s3,a1
    8000081c:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000081e:	00000097          	auipc	ra,0x0
    80000822:	8fc080e7          	jalr	-1796(ra) # 8000011a <kalloc>
    80000826:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000828:	6605                	lui	a2,0x1
    8000082a:	4581                	li	a1,0
    8000082c:	00000097          	auipc	ra,0x0
    80000830:	94e080e7          	jalr	-1714(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000834:	4779                	li	a4,30
    80000836:	86ca                	mv	a3,s2
    80000838:	6605                	lui	a2,0x1
    8000083a:	4581                	li	a1,0
    8000083c:	8552                	mv	a0,s4
    8000083e:	00000097          	auipc	ra,0x0
    80000842:	cfc080e7          	jalr	-772(ra) # 8000053a <mappages>
  memmove(mem, src, sz);
    80000846:	8626                	mv	a2,s1
    80000848:	85ce                	mv	a1,s3
    8000084a:	854a                	mv	a0,s2
    8000084c:	00000097          	auipc	ra,0x0
    80000850:	98a080e7          	jalr	-1654(ra) # 800001d6 <memmove>
}
    80000854:	70a2                	ld	ra,40(sp)
    80000856:	7402                	ld	s0,32(sp)
    80000858:	64e2                	ld	s1,24(sp)
    8000085a:	6942                	ld	s2,16(sp)
    8000085c:	69a2                	ld	s3,8(sp)
    8000085e:	6a02                	ld	s4,0(sp)
    80000860:	6145                	addi	sp,sp,48
    80000862:	8082                	ret
    panic("inituvm: more than a page");
    80000864:	00008517          	auipc	a0,0x8
    80000868:	87450513          	addi	a0,a0,-1932 # 800080d8 <etext+0xd8>
    8000086c:	00005097          	auipc	ra,0x5
    80000870:	3b0080e7          	jalr	944(ra) # 80005c1c <panic>

0000000080000874 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000874:	1101                	addi	sp,sp,-32
    80000876:	ec06                	sd	ra,24(sp)
    80000878:	e822                	sd	s0,16(sp)
    8000087a:	e426                	sd	s1,8(sp)
    8000087c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000880:	00b67d63          	bgeu	a2,a1,8000089a <uvmdealloc+0x26>
    80000884:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000886:	6785                	lui	a5,0x1
    80000888:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000088a:	00f60733          	add	a4,a2,a5
    8000088e:	76fd                	lui	a3,0xfffff
    80000890:	8f75                	and	a4,a4,a3
    80000892:	97ae                	add	a5,a5,a1
    80000894:	8ff5                	and	a5,a5,a3
    80000896:	00f76863          	bltu	a4,a5,800008a6 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000089a:	8526                	mv	a0,s1
    8000089c:	60e2                	ld	ra,24(sp)
    8000089e:	6442                	ld	s0,16(sp)
    800008a0:	64a2                	ld	s1,8(sp)
    800008a2:	6105                	addi	sp,sp,32
    800008a4:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a6:	8f99                	sub	a5,a5,a4
    800008a8:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008aa:	4685                	li	a3,1
    800008ac:	0007861b          	sext.w	a2,a5
    800008b0:	85ba                	mv	a1,a4
    800008b2:	00000097          	auipc	ra,0x0
    800008b6:	e4e080e7          	jalr	-434(ra) # 80000700 <uvmunmap>
    800008ba:	b7c5                	j	8000089a <uvmdealloc+0x26>

00000000800008bc <uvmalloc>:
  if(newsz < oldsz)
    800008bc:	0ab66563          	bltu	a2,a1,80000966 <uvmalloc+0xaa>
{
    800008c0:	7139                	addi	sp,sp,-64
    800008c2:	fc06                	sd	ra,56(sp)
    800008c4:	f822                	sd	s0,48(sp)
    800008c6:	ec4e                	sd	s3,24(sp)
    800008c8:	e852                	sd	s4,16(sp)
    800008ca:	e456                	sd	s5,8(sp)
    800008cc:	0080                	addi	s0,sp,64
    800008ce:	8aaa                	mv	s5,a0
    800008d0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d2:	6785                	lui	a5,0x1
    800008d4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d6:	95be                	add	a1,a1,a5
    800008d8:	77fd                	lui	a5,0xfffff
    800008da:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008de:	08c9f663          	bgeu	s3,a2,8000096a <uvmalloc+0xae>
    800008e2:	f426                	sd	s1,40(sp)
    800008e4:	f04a                	sd	s2,32(sp)
    800008e6:	894e                	mv	s2,s3
    mem = kalloc();
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	832080e7          	jalr	-1998(ra) # 8000011a <kalloc>
    800008f0:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f2:	c90d                	beqz	a0,80000924 <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800008f4:	6605                	lui	a2,0x1
    800008f6:	4581                	li	a1,0
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	882080e7          	jalr	-1918(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000900:	4779                	li	a4,30
    80000902:	86a6                	mv	a3,s1
    80000904:	6605                	lui	a2,0x1
    80000906:	85ca                	mv	a1,s2
    80000908:	8556                	mv	a0,s5
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	c30080e7          	jalr	-976(ra) # 8000053a <mappages>
    80000912:	e915                	bnez	a0,80000946 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000914:	6785                	lui	a5,0x1
    80000916:	993e                	add	s2,s2,a5
    80000918:	fd4968e3          	bltu	s2,s4,800008e8 <uvmalloc+0x2c>
  return newsz;
    8000091c:	8552                	mv	a0,s4
    8000091e:	74a2                	ld	s1,40(sp)
    80000920:	7902                	ld	s2,32(sp)
    80000922:	a819                	j	80000938 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    80000924:	864e                	mv	a2,s3
    80000926:	85ca                	mv	a1,s2
    80000928:	8556                	mv	a0,s5
    8000092a:	00000097          	auipc	ra,0x0
    8000092e:	f4a080e7          	jalr	-182(ra) # 80000874 <uvmdealloc>
      return 0;
    80000932:	4501                	li	a0,0
    80000934:	74a2                	ld	s1,40(sp)
    80000936:	7902                	ld	s2,32(sp)
}
    80000938:	70e2                	ld	ra,56(sp)
    8000093a:	7442                	ld	s0,48(sp)
    8000093c:	69e2                	ld	s3,24(sp)
    8000093e:	6a42                	ld	s4,16(sp)
    80000940:	6aa2                	ld	s5,8(sp)
    80000942:	6121                	addi	sp,sp,64
    80000944:	8082                	ret
      kfree(mem);
    80000946:	8526                	mv	a0,s1
    80000948:	fffff097          	auipc	ra,0xfffff
    8000094c:	6d4080e7          	jalr	1748(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000950:	864e                	mv	a2,s3
    80000952:	85ca                	mv	a1,s2
    80000954:	8556                	mv	a0,s5
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	f1e080e7          	jalr	-226(ra) # 80000874 <uvmdealloc>
      return 0;
    8000095e:	4501                	li	a0,0
    80000960:	74a2                	ld	s1,40(sp)
    80000962:	7902                	ld	s2,32(sp)
    80000964:	bfd1                	j	80000938 <uvmalloc+0x7c>
    return oldsz;
    80000966:	852e                	mv	a0,a1
}
    80000968:	8082                	ret
  return newsz;
    8000096a:	8532                	mv	a0,a2
    8000096c:	b7f1                	j	80000938 <uvmalloc+0x7c>

000000008000096e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000096e:	7179                	addi	sp,sp,-48
    80000970:	f406                	sd	ra,40(sp)
    80000972:	f022                	sd	s0,32(sp)
    80000974:	ec26                	sd	s1,24(sp)
    80000976:	e84a                	sd	s2,16(sp)
    80000978:	e44e                	sd	s3,8(sp)
    8000097a:	e052                	sd	s4,0(sp)
    8000097c:	1800                	addi	s0,sp,48
    8000097e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000980:	84aa                	mv	s1,a0
    80000982:	6905                	lui	s2,0x1
    80000984:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000986:	4985                	li	s3,1
    80000988:	a829                	j	800009a2 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000098a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000098c:	00c79513          	slli	a0,a5,0xc
    80000990:	00000097          	auipc	ra,0x0
    80000994:	fde080e7          	jalr	-34(ra) # 8000096e <freewalk>
      pagetable[i] = 0;
    80000998:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000099c:	04a1                	addi	s1,s1,8
    8000099e:	03248163          	beq	s1,s2,800009c0 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009a2:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a4:	00f7f713          	andi	a4,a5,15
    800009a8:	ff3701e3          	beq	a4,s3,8000098a <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ac:	8b85                	andi	a5,a5,1
    800009ae:	d7fd                	beqz	a5,8000099c <freewalk+0x2e>
      panic("freewalk: leaf");
    800009b0:	00007517          	auipc	a0,0x7
    800009b4:	74850513          	addi	a0,a0,1864 # 800080f8 <etext+0xf8>
    800009b8:	00005097          	auipc	ra,0x5
    800009bc:	264080e7          	jalr	612(ra) # 80005c1c <panic>
    }
  }
  kfree((void*)pagetable);
    800009c0:	8552                	mv	a0,s4
    800009c2:	fffff097          	auipc	ra,0xfffff
    800009c6:	65a080e7          	jalr	1626(ra) # 8000001c <kfree>
}
    800009ca:	70a2                	ld	ra,40(sp)
    800009cc:	7402                	ld	s0,32(sp)
    800009ce:	64e2                	ld	s1,24(sp)
    800009d0:	6942                	ld	s2,16(sp)
    800009d2:	69a2                	ld	s3,8(sp)
    800009d4:	6a02                	ld	s4,0(sp)
    800009d6:	6145                	addi	sp,sp,48
    800009d8:	8082                	ret

00000000800009da <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009da:	1101                	addi	sp,sp,-32
    800009dc:	ec06                	sd	ra,24(sp)
    800009de:	e822                	sd	s0,16(sp)
    800009e0:	e426                	sd	s1,8(sp)
    800009e2:	1000                	addi	s0,sp,32
    800009e4:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e6:	e999                	bnez	a1,800009fc <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e8:	8526                	mv	a0,s1
    800009ea:	00000097          	auipc	ra,0x0
    800009ee:	f84080e7          	jalr	-124(ra) # 8000096e <freewalk>
}
    800009f2:	60e2                	ld	ra,24(sp)
    800009f4:	6442                	ld	s0,16(sp)
    800009f6:	64a2                	ld	s1,8(sp)
    800009f8:	6105                	addi	sp,sp,32
    800009fa:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009fc:	6785                	lui	a5,0x1
    800009fe:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a00:	95be                	add	a1,a1,a5
    80000a02:	4685                	li	a3,1
    80000a04:	00c5d613          	srli	a2,a1,0xc
    80000a08:	4581                	li	a1,0
    80000a0a:	00000097          	auipc	ra,0x0
    80000a0e:	cf6080e7          	jalr	-778(ra) # 80000700 <uvmunmap>
    80000a12:	bfd9                	j	800009e8 <uvmfree+0xe>

0000000080000a14 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a14:	c679                	beqz	a2,80000ae2 <uvmcopy+0xce>
{
    80000a16:	715d                	addi	sp,sp,-80
    80000a18:	e486                	sd	ra,72(sp)
    80000a1a:	e0a2                	sd	s0,64(sp)
    80000a1c:	fc26                	sd	s1,56(sp)
    80000a1e:	f84a                	sd	s2,48(sp)
    80000a20:	f44e                	sd	s3,40(sp)
    80000a22:	f052                	sd	s4,32(sp)
    80000a24:	ec56                	sd	s5,24(sp)
    80000a26:	e85a                	sd	s6,16(sp)
    80000a28:	e45e                	sd	s7,8(sp)
    80000a2a:	0880                	addi	s0,sp,80
    80000a2c:	8b2a                	mv	s6,a0
    80000a2e:	8aae                	mv	s5,a1
    80000a30:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a32:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a34:	4601                	li	a2,0
    80000a36:	85ce                	mv	a1,s3
    80000a38:	855a                	mv	a0,s6
    80000a3a:	00000097          	auipc	ra,0x0
    80000a3e:	a18080e7          	jalr	-1512(ra) # 80000452 <walk>
    80000a42:	c531                	beqz	a0,80000a8e <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a44:	6118                	ld	a4,0(a0)
    80000a46:	00177793          	andi	a5,a4,1
    80000a4a:	cbb1                	beqz	a5,80000a9e <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a4c:	00a75593          	srli	a1,a4,0xa
    80000a50:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a54:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a58:	fffff097          	auipc	ra,0xfffff
    80000a5c:	6c2080e7          	jalr	1730(ra) # 8000011a <kalloc>
    80000a60:	892a                	mv	s2,a0
    80000a62:	c939                	beqz	a0,80000ab8 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a64:	6605                	lui	a2,0x1
    80000a66:	85de                	mv	a1,s7
    80000a68:	fffff097          	auipc	ra,0xfffff
    80000a6c:	76e080e7          	jalr	1902(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a70:	8726                	mv	a4,s1
    80000a72:	86ca                	mv	a3,s2
    80000a74:	6605                	lui	a2,0x1
    80000a76:	85ce                	mv	a1,s3
    80000a78:	8556                	mv	a0,s5
    80000a7a:	00000097          	auipc	ra,0x0
    80000a7e:	ac0080e7          	jalr	-1344(ra) # 8000053a <mappages>
    80000a82:	e515                	bnez	a0,80000aae <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a84:	6785                	lui	a5,0x1
    80000a86:	99be                	add	s3,s3,a5
    80000a88:	fb49e6e3          	bltu	s3,s4,80000a34 <uvmcopy+0x20>
    80000a8c:	a081                	j	80000acc <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a8e:	00007517          	auipc	a0,0x7
    80000a92:	67a50513          	addi	a0,a0,1658 # 80008108 <etext+0x108>
    80000a96:	00005097          	auipc	ra,0x5
    80000a9a:	186080e7          	jalr	390(ra) # 80005c1c <panic>
      panic("uvmcopy: page not present");
    80000a9e:	00007517          	auipc	a0,0x7
    80000aa2:	68a50513          	addi	a0,a0,1674 # 80008128 <etext+0x128>
    80000aa6:	00005097          	auipc	ra,0x5
    80000aaa:	176080e7          	jalr	374(ra) # 80005c1c <panic>
      kfree(mem);
    80000aae:	854a                	mv	a0,s2
    80000ab0:	fffff097          	auipc	ra,0xfffff
    80000ab4:	56c080e7          	jalr	1388(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab8:	4685                	li	a3,1
    80000aba:	00c9d613          	srli	a2,s3,0xc
    80000abe:	4581                	li	a1,0
    80000ac0:	8556                	mv	a0,s5
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	c3e080e7          	jalr	-962(ra) # 80000700 <uvmunmap>
  return -1;
    80000aca:	557d                	li	a0,-1
}
    80000acc:	60a6                	ld	ra,72(sp)
    80000ace:	6406                	ld	s0,64(sp)
    80000ad0:	74e2                	ld	s1,56(sp)
    80000ad2:	7942                	ld	s2,48(sp)
    80000ad4:	79a2                	ld	s3,40(sp)
    80000ad6:	7a02                	ld	s4,32(sp)
    80000ad8:	6ae2                	ld	s5,24(sp)
    80000ada:	6b42                	ld	s6,16(sp)
    80000adc:	6ba2                	ld	s7,8(sp)
    80000ade:	6161                	addi	sp,sp,80
    80000ae0:	8082                	ret
  return 0;
    80000ae2:	4501                	li	a0,0
}
    80000ae4:	8082                	ret

0000000080000ae6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ae6:	1141                	addi	sp,sp,-16
    80000ae8:	e406                	sd	ra,8(sp)
    80000aea:	e022                	sd	s0,0(sp)
    80000aec:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000aee:	4601                	li	a2,0
    80000af0:	00000097          	auipc	ra,0x0
    80000af4:	962080e7          	jalr	-1694(ra) # 80000452 <walk>
  if(pte == 0)
    80000af8:	c901                	beqz	a0,80000b08 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000afa:	611c                	ld	a5,0(a0)
    80000afc:	9bbd                	andi	a5,a5,-17
    80000afe:	e11c                	sd	a5,0(a0)
}
    80000b00:	60a2                	ld	ra,8(sp)
    80000b02:	6402                	ld	s0,0(sp)
    80000b04:	0141                	addi	sp,sp,16
    80000b06:	8082                	ret
    panic("uvmclear");
    80000b08:	00007517          	auipc	a0,0x7
    80000b0c:	64050513          	addi	a0,a0,1600 # 80008148 <etext+0x148>
    80000b10:	00005097          	auipc	ra,0x5
    80000b14:	10c080e7          	jalr	268(ra) # 80005c1c <panic>

0000000080000b18 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b18:	c6bd                	beqz	a3,80000b86 <copyout+0x6e>
{
    80000b1a:	715d                	addi	sp,sp,-80
    80000b1c:	e486                	sd	ra,72(sp)
    80000b1e:	e0a2                	sd	s0,64(sp)
    80000b20:	fc26                	sd	s1,56(sp)
    80000b22:	f84a                	sd	s2,48(sp)
    80000b24:	f44e                	sd	s3,40(sp)
    80000b26:	f052                	sd	s4,32(sp)
    80000b28:	ec56                	sd	s5,24(sp)
    80000b2a:	e85a                	sd	s6,16(sp)
    80000b2c:	e45e                	sd	s7,8(sp)
    80000b2e:	e062                	sd	s8,0(sp)
    80000b30:	0880                	addi	s0,sp,80
    80000b32:	8b2a                	mv	s6,a0
    80000b34:	8c2e                	mv	s8,a1
    80000b36:	8a32                	mv	s4,a2
    80000b38:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b3a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b3c:	6a85                	lui	s5,0x1
    80000b3e:	a015                	j	80000b62 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b40:	9562                	add	a0,a0,s8
    80000b42:	0004861b          	sext.w	a2,s1
    80000b46:	85d2                	mv	a1,s4
    80000b48:	41250533          	sub	a0,a0,s2
    80000b4c:	fffff097          	auipc	ra,0xfffff
    80000b50:	68a080e7          	jalr	1674(ra) # 800001d6 <memmove>

    len -= n;
    80000b54:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b58:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b5a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b5e:	02098263          	beqz	s3,80000b82 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b62:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b66:	85ca                	mv	a1,s2
    80000b68:	855a                	mv	a0,s6
    80000b6a:	00000097          	auipc	ra,0x0
    80000b6e:	98e080e7          	jalr	-1650(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000b72:	cd01                	beqz	a0,80000b8a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b74:	418904b3          	sub	s1,s2,s8
    80000b78:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b7a:	fc99f3e3          	bgeu	s3,s1,80000b40 <copyout+0x28>
    80000b7e:	84ce                	mv	s1,s3
    80000b80:	b7c1                	j	80000b40 <copyout+0x28>
  }
  return 0;
    80000b82:	4501                	li	a0,0
    80000b84:	a021                	j	80000b8c <copyout+0x74>
    80000b86:	4501                	li	a0,0
}
    80000b88:	8082                	ret
      return -1;
    80000b8a:	557d                	li	a0,-1
}
    80000b8c:	60a6                	ld	ra,72(sp)
    80000b8e:	6406                	ld	s0,64(sp)
    80000b90:	74e2                	ld	s1,56(sp)
    80000b92:	7942                	ld	s2,48(sp)
    80000b94:	79a2                	ld	s3,40(sp)
    80000b96:	7a02                	ld	s4,32(sp)
    80000b98:	6ae2                	ld	s5,24(sp)
    80000b9a:	6b42                	ld	s6,16(sp)
    80000b9c:	6ba2                	ld	s7,8(sp)
    80000b9e:	6c02                	ld	s8,0(sp)
    80000ba0:	6161                	addi	sp,sp,80
    80000ba2:	8082                	ret

0000000080000ba4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ba4:	caa5                	beqz	a3,80000c14 <copyin+0x70>
{
    80000ba6:	715d                	addi	sp,sp,-80
    80000ba8:	e486                	sd	ra,72(sp)
    80000baa:	e0a2                	sd	s0,64(sp)
    80000bac:	fc26                	sd	s1,56(sp)
    80000bae:	f84a                	sd	s2,48(sp)
    80000bb0:	f44e                	sd	s3,40(sp)
    80000bb2:	f052                	sd	s4,32(sp)
    80000bb4:	ec56                	sd	s5,24(sp)
    80000bb6:	e85a                	sd	s6,16(sp)
    80000bb8:	e45e                	sd	s7,8(sp)
    80000bba:	e062                	sd	s8,0(sp)
    80000bbc:	0880                	addi	s0,sp,80
    80000bbe:	8b2a                	mv	s6,a0
    80000bc0:	8a2e                	mv	s4,a1
    80000bc2:	8c32                	mv	s8,a2
    80000bc4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bc8:	6a85                	lui	s5,0x1
    80000bca:	a01d                	j	80000bf0 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bcc:	018505b3          	add	a1,a0,s8
    80000bd0:	0004861b          	sext.w	a2,s1
    80000bd4:	412585b3          	sub	a1,a1,s2
    80000bd8:	8552                	mv	a0,s4
    80000bda:	fffff097          	auipc	ra,0xfffff
    80000bde:	5fc080e7          	jalr	1532(ra) # 800001d6 <memmove>

    len -= n;
    80000be2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bec:	02098263          	beqz	s3,80000c10 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bf0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bf4:	85ca                	mv	a1,s2
    80000bf6:	855a                	mv	a0,s6
    80000bf8:	00000097          	auipc	ra,0x0
    80000bfc:	900080e7          	jalr	-1792(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000c00:	cd01                	beqz	a0,80000c18 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c02:	418904b3          	sub	s1,s2,s8
    80000c06:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c08:	fc99f2e3          	bgeu	s3,s1,80000bcc <copyin+0x28>
    80000c0c:	84ce                	mv	s1,s3
    80000c0e:	bf7d                	j	80000bcc <copyin+0x28>
  }
  return 0;
    80000c10:	4501                	li	a0,0
    80000c12:	a021                	j	80000c1a <copyin+0x76>
    80000c14:	4501                	li	a0,0
}
    80000c16:	8082                	ret
      return -1;
    80000c18:	557d                	li	a0,-1
}
    80000c1a:	60a6                	ld	ra,72(sp)
    80000c1c:	6406                	ld	s0,64(sp)
    80000c1e:	74e2                	ld	s1,56(sp)
    80000c20:	7942                	ld	s2,48(sp)
    80000c22:	79a2                	ld	s3,40(sp)
    80000c24:	7a02                	ld	s4,32(sp)
    80000c26:	6ae2                	ld	s5,24(sp)
    80000c28:	6b42                	ld	s6,16(sp)
    80000c2a:	6ba2                	ld	s7,8(sp)
    80000c2c:	6c02                	ld	s8,0(sp)
    80000c2e:	6161                	addi	sp,sp,80
    80000c30:	8082                	ret

0000000080000c32 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c32:	cacd                	beqz	a3,80000ce4 <copyinstr+0xb2>
{
    80000c34:	715d                	addi	sp,sp,-80
    80000c36:	e486                	sd	ra,72(sp)
    80000c38:	e0a2                	sd	s0,64(sp)
    80000c3a:	fc26                	sd	s1,56(sp)
    80000c3c:	f84a                	sd	s2,48(sp)
    80000c3e:	f44e                	sd	s3,40(sp)
    80000c40:	f052                	sd	s4,32(sp)
    80000c42:	ec56                	sd	s5,24(sp)
    80000c44:	e85a                	sd	s6,16(sp)
    80000c46:	e45e                	sd	s7,8(sp)
    80000c48:	0880                	addi	s0,sp,80
    80000c4a:	8a2a                	mv	s4,a0
    80000c4c:	8b2e                	mv	s6,a1
    80000c4e:	8bb2                	mv	s7,a2
    80000c50:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000c52:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c54:	6985                	lui	s3,0x1
    80000c56:	a825                	j	80000c8e <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c58:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c5c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c5e:	37fd                	addiw	a5,a5,-1
    80000c60:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c64:	60a6                	ld	ra,72(sp)
    80000c66:	6406                	ld	s0,64(sp)
    80000c68:	74e2                	ld	s1,56(sp)
    80000c6a:	7942                	ld	s2,48(sp)
    80000c6c:	79a2                	ld	s3,40(sp)
    80000c6e:	7a02                	ld	s4,32(sp)
    80000c70:	6ae2                	ld	s5,24(sp)
    80000c72:	6b42                	ld	s6,16(sp)
    80000c74:	6ba2                	ld	s7,8(sp)
    80000c76:	6161                	addi	sp,sp,80
    80000c78:	8082                	ret
    80000c7a:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000c7e:	9742                	add	a4,a4,a6
      --max;
    80000c80:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000c84:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000c88:	04e58663          	beq	a1,a4,80000cd4 <copyinstr+0xa2>
{
    80000c8c:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000c8e:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c92:	85a6                	mv	a1,s1
    80000c94:	8552                	mv	a0,s4
    80000c96:	00000097          	auipc	ra,0x0
    80000c9a:	862080e7          	jalr	-1950(ra) # 800004f8 <walkaddr>
    if(pa0 == 0)
    80000c9e:	cd0d                	beqz	a0,80000cd8 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000ca0:	417486b3          	sub	a3,s1,s7
    80000ca4:	96ce                	add	a3,a3,s3
    if(n > max)
    80000ca6:	00d97363          	bgeu	s2,a3,80000cac <copyinstr+0x7a>
    80000caa:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000cac:	955e                	add	a0,a0,s7
    80000cae:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000cb0:	c695                	beqz	a3,80000cdc <copyinstr+0xaa>
    80000cb2:	87da                	mv	a5,s6
    80000cb4:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000cb6:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000cba:	96da                	add	a3,a3,s6
    80000cbc:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000cbe:	00f60733          	add	a4,a2,a5
    80000cc2:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd5dc0>
    80000cc6:	db49                	beqz	a4,80000c58 <copyinstr+0x26>
        *dst = *p;
    80000cc8:	00e78023          	sb	a4,0(a5)
      dst++;
    80000ccc:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cce:	fed797e3          	bne	a5,a3,80000cbc <copyinstr+0x8a>
    80000cd2:	b765                	j	80000c7a <copyinstr+0x48>
    80000cd4:	4781                	li	a5,0
    80000cd6:	b761                	j	80000c5e <copyinstr+0x2c>
      return -1;
    80000cd8:	557d                	li	a0,-1
    80000cda:	b769                	j	80000c64 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000cdc:	6b85                	lui	s7,0x1
    80000cde:	9ba6                	add	s7,s7,s1
    80000ce0:	87da                	mv	a5,s6
    80000ce2:	b76d                	j	80000c8c <copyinstr+0x5a>
  int got_null = 0;
    80000ce4:	4781                	li	a5,0
  if(got_null){
    80000ce6:	37fd                	addiw	a5,a5,-1
    80000ce8:	0007851b          	sext.w	a0,a5
}
    80000cec:	8082                	ret

0000000080000cee <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cee:	7139                	addi	sp,sp,-64
    80000cf0:	fc06                	sd	ra,56(sp)
    80000cf2:	f822                	sd	s0,48(sp)
    80000cf4:	f426                	sd	s1,40(sp)
    80000cf6:	f04a                	sd	s2,32(sp)
    80000cf8:	ec4e                	sd	s3,24(sp)
    80000cfa:	e852                	sd	s4,16(sp)
    80000cfc:	e456                	sd	s5,8(sp)
    80000cfe:	e05a                	sd	s6,0(sp)
    80000d00:	0080                	addi	s0,sp,64
    80000d02:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d04:	0000b497          	auipc	s1,0xb
    80000d08:	77c48493          	addi	s1,s1,1916 # 8000c480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d0c:	8b26                	mv	s6,s1
    80000d0e:	04fa5937          	lui	s2,0x4fa5
    80000d12:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000d16:	0932                	slli	s2,s2,0xc
    80000d18:	fa590913          	addi	s2,s2,-91
    80000d1c:	0932                	slli	s2,s2,0xc
    80000d1e:	fa590913          	addi	s2,s2,-91
    80000d22:	0932                	slli	s2,s2,0xc
    80000d24:	fa590913          	addi	s2,s2,-91
    80000d28:	040009b7          	lui	s3,0x4000
    80000d2c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d2e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d30:	00011a97          	auipc	s5,0x11
    80000d34:	150a8a93          	addi	s5,s5,336 # 80011e80 <tickslock>
    char *pa = kalloc();
    80000d38:	fffff097          	auipc	ra,0xfffff
    80000d3c:	3e2080e7          	jalr	994(ra) # 8000011a <kalloc>
    80000d40:	862a                	mv	a2,a0
    if(pa == 0)
    80000d42:	c121                	beqz	a0,80000d82 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000d44:	416485b3          	sub	a1,s1,s6
    80000d48:	858d                	srai	a1,a1,0x3
    80000d4a:	032585b3          	mul	a1,a1,s2
    80000d4e:	2585                	addiw	a1,a1,1
    80000d50:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d54:	4719                	li	a4,6
    80000d56:	6685                	lui	a3,0x1
    80000d58:	40b985b3          	sub	a1,s3,a1
    80000d5c:	8552                	mv	a0,s4
    80000d5e:	00000097          	auipc	ra,0x0
    80000d62:	87c080e7          	jalr	-1924(ra) # 800005da <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d66:	16848493          	addi	s1,s1,360
    80000d6a:	fd5497e3          	bne	s1,s5,80000d38 <proc_mapstacks+0x4a>
  }
}
    80000d6e:	70e2                	ld	ra,56(sp)
    80000d70:	7442                	ld	s0,48(sp)
    80000d72:	74a2                	ld	s1,40(sp)
    80000d74:	7902                	ld	s2,32(sp)
    80000d76:	69e2                	ld	s3,24(sp)
    80000d78:	6a42                	ld	s4,16(sp)
    80000d7a:	6aa2                	ld	s5,8(sp)
    80000d7c:	6b02                	ld	s6,0(sp)
    80000d7e:	6121                	addi	sp,sp,64
    80000d80:	8082                	ret
      panic("kalloc");
    80000d82:	00007517          	auipc	a0,0x7
    80000d86:	3d650513          	addi	a0,a0,982 # 80008158 <etext+0x158>
    80000d8a:	00005097          	auipc	ra,0x5
    80000d8e:	e92080e7          	jalr	-366(ra) # 80005c1c <panic>

0000000080000d92 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d92:	7139                	addi	sp,sp,-64
    80000d94:	fc06                	sd	ra,56(sp)
    80000d96:	f822                	sd	s0,48(sp)
    80000d98:	f426                	sd	s1,40(sp)
    80000d9a:	f04a                	sd	s2,32(sp)
    80000d9c:	ec4e                	sd	s3,24(sp)
    80000d9e:	e852                	sd	s4,16(sp)
    80000da0:	e456                	sd	s5,8(sp)
    80000da2:	e05a                	sd	s6,0(sp)
    80000da4:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000da6:	00007597          	auipc	a1,0x7
    80000daa:	3ba58593          	addi	a1,a1,954 # 80008160 <etext+0x160>
    80000dae:	0000b517          	auipc	a0,0xb
    80000db2:	2a250513          	addi	a0,a0,674 # 8000c050 <pid_lock>
    80000db6:	00005097          	auipc	ra,0x5
    80000dba:	350080e7          	jalr	848(ra) # 80006106 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dbe:	00007597          	auipc	a1,0x7
    80000dc2:	3aa58593          	addi	a1,a1,938 # 80008168 <etext+0x168>
    80000dc6:	0000b517          	auipc	a0,0xb
    80000dca:	2a250513          	addi	a0,a0,674 # 8000c068 <wait_lock>
    80000dce:	00005097          	auipc	ra,0x5
    80000dd2:	338080e7          	jalr	824(ra) # 80006106 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd6:	0000b497          	auipc	s1,0xb
    80000dda:	6aa48493          	addi	s1,s1,1706 # 8000c480 <proc>
      initlock(&p->lock, "proc");
    80000dde:	00007b17          	auipc	s6,0x7
    80000de2:	39ab0b13          	addi	s6,s6,922 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	8aa6                	mv	s5,s1
    80000de8:	04fa5937          	lui	s2,0x4fa5
    80000dec:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000df0:	0932                	slli	s2,s2,0xc
    80000df2:	fa590913          	addi	s2,s2,-91
    80000df6:	0932                	slli	s2,s2,0xc
    80000df8:	fa590913          	addi	s2,s2,-91
    80000dfc:	0932                	slli	s2,s2,0xc
    80000dfe:	fa590913          	addi	s2,s2,-91
    80000e02:	040009b7          	lui	s3,0x4000
    80000e06:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e08:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0a:	00011a17          	auipc	s4,0x11
    80000e0e:	076a0a13          	addi	s4,s4,118 # 80011e80 <tickslock>
      initlock(&p->lock, "proc");
    80000e12:	85da                	mv	a1,s6
    80000e14:	8526                	mv	a0,s1
    80000e16:	00005097          	auipc	ra,0x5
    80000e1a:	2f0080e7          	jalr	752(ra) # 80006106 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e1e:	415487b3          	sub	a5,s1,s5
    80000e22:	878d                	srai	a5,a5,0x3
    80000e24:	032787b3          	mul	a5,a5,s2
    80000e28:	2785                	addiw	a5,a5,1
    80000e2a:	00d7979b          	slliw	a5,a5,0xd
    80000e2e:	40f987b3          	sub	a5,s3,a5
    80000e32:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e34:	16848493          	addi	s1,s1,360
    80000e38:	fd449de3          	bne	s1,s4,80000e12 <procinit+0x80>
  }
}
    80000e3c:	70e2                	ld	ra,56(sp)
    80000e3e:	7442                	ld	s0,48(sp)
    80000e40:	74a2                	ld	s1,40(sp)
    80000e42:	7902                	ld	s2,32(sp)
    80000e44:	69e2                	ld	s3,24(sp)
    80000e46:	6a42                	ld	s4,16(sp)
    80000e48:	6aa2                	ld	s5,8(sp)
    80000e4a:	6b02                	ld	s6,0(sp)
    80000e4c:	6121                	addi	sp,sp,64
    80000e4e:	8082                	ret

0000000080000e50 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e50:	1141                	addi	sp,sp,-16
    80000e52:	e422                	sd	s0,8(sp)
    80000e54:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e56:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e58:	2501                	sext.w	a0,a0
    80000e5a:	6422                	ld	s0,8(sp)
    80000e5c:	0141                	addi	sp,sp,16
    80000e5e:	8082                	ret

0000000080000e60 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e60:	1141                	addi	sp,sp,-16
    80000e62:	e422                	sd	s0,8(sp)
    80000e64:	0800                	addi	s0,sp,16
    80000e66:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e68:	2781                	sext.w	a5,a5
    80000e6a:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e6c:	0000b517          	auipc	a0,0xb
    80000e70:	21450513          	addi	a0,a0,532 # 8000c080 <cpus>
    80000e74:	953e                	add	a0,a0,a5
    80000e76:	6422                	ld	s0,8(sp)
    80000e78:	0141                	addi	sp,sp,16
    80000e7a:	8082                	ret

0000000080000e7c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e7c:	1101                	addi	sp,sp,-32
    80000e7e:	ec06                	sd	ra,24(sp)
    80000e80:	e822                	sd	s0,16(sp)
    80000e82:	e426                	sd	s1,8(sp)
    80000e84:	1000                	addi	s0,sp,32
  push_off();
    80000e86:	00005097          	auipc	ra,0x5
    80000e8a:	2c4080e7          	jalr	708(ra) # 8000614a <push_off>
    80000e8e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e90:	2781                	sext.w	a5,a5
    80000e92:	079e                	slli	a5,a5,0x7
    80000e94:	0000b717          	auipc	a4,0xb
    80000e98:	1bc70713          	addi	a4,a4,444 # 8000c050 <pid_lock>
    80000e9c:	97ba                	add	a5,a5,a4
    80000e9e:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ea0:	00005097          	auipc	ra,0x5
    80000ea4:	34a080e7          	jalr	842(ra) # 800061ea <pop_off>
  return p;
}
    80000ea8:	8526                	mv	a0,s1
    80000eaa:	60e2                	ld	ra,24(sp)
    80000eac:	6442                	ld	s0,16(sp)
    80000eae:	64a2                	ld	s1,8(sp)
    80000eb0:	6105                	addi	sp,sp,32
    80000eb2:	8082                	ret

0000000080000eb4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000eb4:	1141                	addi	sp,sp,-16
    80000eb6:	e406                	sd	ra,8(sp)
    80000eb8:	e022                	sd	s0,0(sp)
    80000eba:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ebc:	00000097          	auipc	ra,0x0
    80000ec0:	fc0080e7          	jalr	-64(ra) # 80000e7c <myproc>
    80000ec4:	00005097          	auipc	ra,0x5
    80000ec8:	386080e7          	jalr	902(ra) # 8000624a <release>

  if (first) {
    80000ecc:	0000a797          	auipc	a5,0xa
    80000ed0:	1047a783          	lw	a5,260(a5) # 8000afd0 <first.1>
    80000ed4:	eb89                	bnez	a5,80000ee6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ed6:	00001097          	auipc	ra,0x1
    80000eda:	c16080e7          	jalr	-1002(ra) # 80001aec <usertrapret>
}
    80000ede:	60a2                	ld	ra,8(sp)
    80000ee0:	6402                	ld	s0,0(sp)
    80000ee2:	0141                	addi	sp,sp,16
    80000ee4:	8082                	ret
    first = 0;
    80000ee6:	0000a797          	auipc	a5,0xa
    80000eea:	0e07a523          	sw	zero,234(a5) # 8000afd0 <first.1>
    fsinit(ROOTDEV);
    80000eee:	4505                	li	a0,1
    80000ef0:	00002097          	auipc	ra,0x2
    80000ef4:	94a080e7          	jalr	-1718(ra) # 8000283a <fsinit>
    80000ef8:	bff9                	j	80000ed6 <forkret+0x22>

0000000080000efa <allocpid>:
allocpid() {
    80000efa:	1101                	addi	sp,sp,-32
    80000efc:	ec06                	sd	ra,24(sp)
    80000efe:	e822                	sd	s0,16(sp)
    80000f00:	e426                	sd	s1,8(sp)
    80000f02:	e04a                	sd	s2,0(sp)
    80000f04:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f06:	0000b917          	auipc	s2,0xb
    80000f0a:	14a90913          	addi	s2,s2,330 # 8000c050 <pid_lock>
    80000f0e:	854a                	mv	a0,s2
    80000f10:	00005097          	auipc	ra,0x5
    80000f14:	286080e7          	jalr	646(ra) # 80006196 <acquire>
  pid = nextpid;
    80000f18:	0000a797          	auipc	a5,0xa
    80000f1c:	0bc78793          	addi	a5,a5,188 # 8000afd4 <nextpid>
    80000f20:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f22:	0014871b          	addiw	a4,s1,1
    80000f26:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f28:	854a                	mv	a0,s2
    80000f2a:	00005097          	auipc	ra,0x5
    80000f2e:	320080e7          	jalr	800(ra) # 8000624a <release>
}
    80000f32:	8526                	mv	a0,s1
    80000f34:	60e2                	ld	ra,24(sp)
    80000f36:	6442                	ld	s0,16(sp)
    80000f38:	64a2                	ld	s1,8(sp)
    80000f3a:	6902                	ld	s2,0(sp)
    80000f3c:	6105                	addi	sp,sp,32
    80000f3e:	8082                	ret

0000000080000f40 <proc_pagetable>:
{
    80000f40:	1101                	addi	sp,sp,-32
    80000f42:	ec06                	sd	ra,24(sp)
    80000f44:	e822                	sd	s0,16(sp)
    80000f46:	e426                	sd	s1,8(sp)
    80000f48:	e04a                	sd	s2,0(sp)
    80000f4a:	1000                	addi	s0,sp,32
    80000f4c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f4e:	00000097          	auipc	ra,0x0
    80000f52:	886080e7          	jalr	-1914(ra) # 800007d4 <uvmcreate>
    80000f56:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f58:	c121                	beqz	a0,80000f98 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f5a:	4729                	li	a4,10
    80000f5c:	00006697          	auipc	a3,0x6
    80000f60:	0a468693          	addi	a3,a3,164 # 80007000 <_trampoline>
    80000f64:	6605                	lui	a2,0x1
    80000f66:	040005b7          	lui	a1,0x4000
    80000f6a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f6c:	05b2                	slli	a1,a1,0xc
    80000f6e:	fffff097          	auipc	ra,0xfffff
    80000f72:	5cc080e7          	jalr	1484(ra) # 8000053a <mappages>
    80000f76:	02054863          	bltz	a0,80000fa6 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f7a:	4719                	li	a4,6
    80000f7c:	05893683          	ld	a3,88(s2)
    80000f80:	6605                	lui	a2,0x1
    80000f82:	020005b7          	lui	a1,0x2000
    80000f86:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f88:	05b6                	slli	a1,a1,0xd
    80000f8a:	8526                	mv	a0,s1
    80000f8c:	fffff097          	auipc	ra,0xfffff
    80000f90:	5ae080e7          	jalr	1454(ra) # 8000053a <mappages>
    80000f94:	02054163          	bltz	a0,80000fb6 <proc_pagetable+0x76>
}
    80000f98:	8526                	mv	a0,s1
    80000f9a:	60e2                	ld	ra,24(sp)
    80000f9c:	6442                	ld	s0,16(sp)
    80000f9e:	64a2                	ld	s1,8(sp)
    80000fa0:	6902                	ld	s2,0(sp)
    80000fa2:	6105                	addi	sp,sp,32
    80000fa4:	8082                	ret
    uvmfree(pagetable, 0);
    80000fa6:	4581                	li	a1,0
    80000fa8:	8526                	mv	a0,s1
    80000faa:	00000097          	auipc	ra,0x0
    80000fae:	a30080e7          	jalr	-1488(ra) # 800009da <uvmfree>
    return 0;
    80000fb2:	4481                	li	s1,0
    80000fb4:	b7d5                	j	80000f98 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb6:	4681                	li	a3,0
    80000fb8:	4605                	li	a2,1
    80000fba:	040005b7          	lui	a1,0x4000
    80000fbe:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fc0:	05b2                	slli	a1,a1,0xc
    80000fc2:	8526                	mv	a0,s1
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	73c080e7          	jalr	1852(ra) # 80000700 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fcc:	4581                	li	a1,0
    80000fce:	8526                	mv	a0,s1
    80000fd0:	00000097          	auipc	ra,0x0
    80000fd4:	a0a080e7          	jalr	-1526(ra) # 800009da <uvmfree>
    return 0;
    80000fd8:	4481                	li	s1,0
    80000fda:	bf7d                	j	80000f98 <proc_pagetable+0x58>

0000000080000fdc <proc_freepagetable>:
{
    80000fdc:	1101                	addi	sp,sp,-32
    80000fde:	ec06                	sd	ra,24(sp)
    80000fe0:	e822                	sd	s0,16(sp)
    80000fe2:	e426                	sd	s1,8(sp)
    80000fe4:	e04a                	sd	s2,0(sp)
    80000fe6:	1000                	addi	s0,sp,32
    80000fe8:	84aa                	mv	s1,a0
    80000fea:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fec:	4681                	li	a3,0
    80000fee:	4605                	li	a2,1
    80000ff0:	040005b7          	lui	a1,0x4000
    80000ff4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ff6:	05b2                	slli	a1,a1,0xc
    80000ff8:	fffff097          	auipc	ra,0xfffff
    80000ffc:	708080e7          	jalr	1800(ra) # 80000700 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001000:	4681                	li	a3,0
    80001002:	4605                	li	a2,1
    80001004:	020005b7          	lui	a1,0x2000
    80001008:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000100a:	05b6                	slli	a1,a1,0xd
    8000100c:	8526                	mv	a0,s1
    8000100e:	fffff097          	auipc	ra,0xfffff
    80001012:	6f2080e7          	jalr	1778(ra) # 80000700 <uvmunmap>
  uvmfree(pagetable, sz);
    80001016:	85ca                	mv	a1,s2
    80001018:	8526                	mv	a0,s1
    8000101a:	00000097          	auipc	ra,0x0
    8000101e:	9c0080e7          	jalr	-1600(ra) # 800009da <uvmfree>
}
    80001022:	60e2                	ld	ra,24(sp)
    80001024:	6442                	ld	s0,16(sp)
    80001026:	64a2                	ld	s1,8(sp)
    80001028:	6902                	ld	s2,0(sp)
    8000102a:	6105                	addi	sp,sp,32
    8000102c:	8082                	ret

000000008000102e <freeproc>:
{
    8000102e:	1101                	addi	sp,sp,-32
    80001030:	ec06                	sd	ra,24(sp)
    80001032:	e822                	sd	s0,16(sp)
    80001034:	e426                	sd	s1,8(sp)
    80001036:	1000                	addi	s0,sp,32
    80001038:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000103a:	6d28                	ld	a0,88(a0)
    8000103c:	c509                	beqz	a0,80001046 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000103e:	fffff097          	auipc	ra,0xfffff
    80001042:	fde080e7          	jalr	-34(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001046:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000104a:	68a8                	ld	a0,80(s1)
    8000104c:	c511                	beqz	a0,80001058 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000104e:	64ac                	ld	a1,72(s1)
    80001050:	00000097          	auipc	ra,0x0
    80001054:	f8c080e7          	jalr	-116(ra) # 80000fdc <proc_freepagetable>
  p->pagetable = 0;
    80001058:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000105c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001060:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001064:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001068:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000106c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001070:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001074:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001078:	0004ac23          	sw	zero,24(s1)
}
    8000107c:	60e2                	ld	ra,24(sp)
    8000107e:	6442                	ld	s0,16(sp)
    80001080:	64a2                	ld	s1,8(sp)
    80001082:	6105                	addi	sp,sp,32
    80001084:	8082                	ret

0000000080001086 <allocproc>:
{
    80001086:	1101                	addi	sp,sp,-32
    80001088:	ec06                	sd	ra,24(sp)
    8000108a:	e822                	sd	s0,16(sp)
    8000108c:	e426                	sd	s1,8(sp)
    8000108e:	e04a                	sd	s2,0(sp)
    80001090:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001092:	0000b497          	auipc	s1,0xb
    80001096:	3ee48493          	addi	s1,s1,1006 # 8000c480 <proc>
    8000109a:	00011917          	auipc	s2,0x11
    8000109e:	de690913          	addi	s2,s2,-538 # 80011e80 <tickslock>
    acquire(&p->lock);
    800010a2:	8526                	mv	a0,s1
    800010a4:	00005097          	auipc	ra,0x5
    800010a8:	0f2080e7          	jalr	242(ra) # 80006196 <acquire>
    if(p->state == UNUSED) {
    800010ac:	4c9c                	lw	a5,24(s1)
    800010ae:	cf81                	beqz	a5,800010c6 <allocproc+0x40>
      release(&p->lock);
    800010b0:	8526                	mv	a0,s1
    800010b2:	00005097          	auipc	ra,0x5
    800010b6:	198080e7          	jalr	408(ra) # 8000624a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ba:	16848493          	addi	s1,s1,360
    800010be:	ff2492e3          	bne	s1,s2,800010a2 <allocproc+0x1c>
  return 0;
    800010c2:	4481                	li	s1,0
    800010c4:	a889                	j	80001116 <allocproc+0x90>
  p->pid = allocpid();
    800010c6:	00000097          	auipc	ra,0x0
    800010ca:	e34080e7          	jalr	-460(ra) # 80000efa <allocpid>
    800010ce:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010d0:	4785                	li	a5,1
    800010d2:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010d4:	fffff097          	auipc	ra,0xfffff
    800010d8:	046080e7          	jalr	70(ra) # 8000011a <kalloc>
    800010dc:	892a                	mv	s2,a0
    800010de:	eca8                	sd	a0,88(s1)
    800010e0:	c131                	beqz	a0,80001124 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010e2:	8526                	mv	a0,s1
    800010e4:	00000097          	auipc	ra,0x0
    800010e8:	e5c080e7          	jalr	-420(ra) # 80000f40 <proc_pagetable>
    800010ec:	892a                	mv	s2,a0
    800010ee:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010f0:	c531                	beqz	a0,8000113c <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010f2:	07000613          	li	a2,112
    800010f6:	4581                	li	a1,0
    800010f8:	06048513          	addi	a0,s1,96
    800010fc:	fffff097          	auipc	ra,0xfffff
    80001100:	07e080e7          	jalr	126(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    80001104:	00000797          	auipc	a5,0x0
    80001108:	db078793          	addi	a5,a5,-592 # 80000eb4 <forkret>
    8000110c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000110e:	60bc                	ld	a5,64(s1)
    80001110:	6705                	lui	a4,0x1
    80001112:	97ba                	add	a5,a5,a4
    80001114:	f4bc                	sd	a5,104(s1)
}
    80001116:	8526                	mv	a0,s1
    80001118:	60e2                	ld	ra,24(sp)
    8000111a:	6442                	ld	s0,16(sp)
    8000111c:	64a2                	ld	s1,8(sp)
    8000111e:	6902                	ld	s2,0(sp)
    80001120:	6105                	addi	sp,sp,32
    80001122:	8082                	ret
    freeproc(p);
    80001124:	8526                	mv	a0,s1
    80001126:	00000097          	auipc	ra,0x0
    8000112a:	f08080e7          	jalr	-248(ra) # 8000102e <freeproc>
    release(&p->lock);
    8000112e:	8526                	mv	a0,s1
    80001130:	00005097          	auipc	ra,0x5
    80001134:	11a080e7          	jalr	282(ra) # 8000624a <release>
    return 0;
    80001138:	84ca                	mv	s1,s2
    8000113a:	bff1                	j	80001116 <allocproc+0x90>
    freeproc(p);
    8000113c:	8526                	mv	a0,s1
    8000113e:	00000097          	auipc	ra,0x0
    80001142:	ef0080e7          	jalr	-272(ra) # 8000102e <freeproc>
    release(&p->lock);
    80001146:	8526                	mv	a0,s1
    80001148:	00005097          	auipc	ra,0x5
    8000114c:	102080e7          	jalr	258(ra) # 8000624a <release>
    return 0;
    80001150:	84ca                	mv	s1,s2
    80001152:	b7d1                	j	80001116 <allocproc+0x90>

0000000080001154 <userinit>:
{
    80001154:	1101                	addi	sp,sp,-32
    80001156:	ec06                	sd	ra,24(sp)
    80001158:	e822                	sd	s0,16(sp)
    8000115a:	e426                	sd	s1,8(sp)
    8000115c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000115e:	00000097          	auipc	ra,0x0
    80001162:	f28080e7          	jalr	-216(ra) # 80001086 <allocproc>
    80001166:	84aa                	mv	s1,a0
  initproc = p;
    80001168:	0000b797          	auipc	a5,0xb
    8000116c:	eaa7b423          	sd	a0,-344(a5) # 8000c010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001170:	03400613          	li	a2,52
    80001174:	0000a597          	auipc	a1,0xa
    80001178:	e6c58593          	addi	a1,a1,-404 # 8000afe0 <initcode>
    8000117c:	6928                	ld	a0,80(a0)
    8000117e:	fffff097          	auipc	ra,0xfffff
    80001182:	684080e7          	jalr	1668(ra) # 80000802 <uvminit>
  p->sz = PGSIZE;
    80001186:	6785                	lui	a5,0x1
    80001188:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000118a:	6cb8                	ld	a4,88(s1)
    8000118c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001190:	6cb8                	ld	a4,88(s1)
    80001192:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001194:	4641                	li	a2,16
    80001196:	00007597          	auipc	a1,0x7
    8000119a:	fea58593          	addi	a1,a1,-22 # 80008180 <etext+0x180>
    8000119e:	15848513          	addi	a0,s1,344
    800011a2:	fffff097          	auipc	ra,0xfffff
    800011a6:	11a080e7          	jalr	282(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    800011aa:	00007517          	auipc	a0,0x7
    800011ae:	fe650513          	addi	a0,a0,-26 # 80008190 <etext+0x190>
    800011b2:	00002097          	auipc	ra,0x2
    800011b6:	0ce080e7          	jalr	206(ra) # 80003280 <namei>
    800011ba:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011be:	478d                	li	a5,3
    800011c0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011c2:	8526                	mv	a0,s1
    800011c4:	00005097          	auipc	ra,0x5
    800011c8:	086080e7          	jalr	134(ra) # 8000624a <release>
}
    800011cc:	60e2                	ld	ra,24(sp)
    800011ce:	6442                	ld	s0,16(sp)
    800011d0:	64a2                	ld	s1,8(sp)
    800011d2:	6105                	addi	sp,sp,32
    800011d4:	8082                	ret

00000000800011d6 <growproc>:
{
    800011d6:	1101                	addi	sp,sp,-32
    800011d8:	ec06                	sd	ra,24(sp)
    800011da:	e822                	sd	s0,16(sp)
    800011dc:	e426                	sd	s1,8(sp)
    800011de:	e04a                	sd	s2,0(sp)
    800011e0:	1000                	addi	s0,sp,32
    800011e2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011e4:	00000097          	auipc	ra,0x0
    800011e8:	c98080e7          	jalr	-872(ra) # 80000e7c <myproc>
    800011ec:	892a                	mv	s2,a0
  sz = p->sz;
    800011ee:	652c                	ld	a1,72(a0)
    800011f0:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800011f4:	00904f63          	bgtz	s1,80001212 <growproc+0x3c>
  } else if(n < 0){
    800011f8:	0204cd63          	bltz	s1,80001232 <growproc+0x5c>
  p->sz = sz;
    800011fc:	1782                	slli	a5,a5,0x20
    800011fe:	9381                	srli	a5,a5,0x20
    80001200:	04f93423          	sd	a5,72(s2)
  return 0;
    80001204:	4501                	li	a0,0
}
    80001206:	60e2                	ld	ra,24(sp)
    80001208:	6442                	ld	s0,16(sp)
    8000120a:	64a2                	ld	s1,8(sp)
    8000120c:	6902                	ld	s2,0(sp)
    8000120e:	6105                	addi	sp,sp,32
    80001210:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001212:	00f4863b          	addw	a2,s1,a5
    80001216:	1602                	slli	a2,a2,0x20
    80001218:	9201                	srli	a2,a2,0x20
    8000121a:	1582                	slli	a1,a1,0x20
    8000121c:	9181                	srli	a1,a1,0x20
    8000121e:	6928                	ld	a0,80(a0)
    80001220:	fffff097          	auipc	ra,0xfffff
    80001224:	69c080e7          	jalr	1692(ra) # 800008bc <uvmalloc>
    80001228:	0005079b          	sext.w	a5,a0
    8000122c:	fbe1                	bnez	a5,800011fc <growproc+0x26>
      return -1;
    8000122e:	557d                	li	a0,-1
    80001230:	bfd9                	j	80001206 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001232:	00f4863b          	addw	a2,s1,a5
    80001236:	1602                	slli	a2,a2,0x20
    80001238:	9201                	srli	a2,a2,0x20
    8000123a:	1582                	slli	a1,a1,0x20
    8000123c:	9181                	srli	a1,a1,0x20
    8000123e:	6928                	ld	a0,80(a0)
    80001240:	fffff097          	auipc	ra,0xfffff
    80001244:	634080e7          	jalr	1588(ra) # 80000874 <uvmdealloc>
    80001248:	0005079b          	sext.w	a5,a0
    8000124c:	bf45                	j	800011fc <growproc+0x26>

000000008000124e <fork>:
{
    8000124e:	7139                	addi	sp,sp,-64
    80001250:	fc06                	sd	ra,56(sp)
    80001252:	f822                	sd	s0,48(sp)
    80001254:	f04a                	sd	s2,32(sp)
    80001256:	e456                	sd	s5,8(sp)
    80001258:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000125a:	00000097          	auipc	ra,0x0
    8000125e:	c22080e7          	jalr	-990(ra) # 80000e7c <myproc>
    80001262:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001264:	00000097          	auipc	ra,0x0
    80001268:	e22080e7          	jalr	-478(ra) # 80001086 <allocproc>
    8000126c:	12050063          	beqz	a0,8000138c <fork+0x13e>
    80001270:	e852                	sd	s4,16(sp)
    80001272:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001274:	048ab603          	ld	a2,72(s5)
    80001278:	692c                	ld	a1,80(a0)
    8000127a:	050ab503          	ld	a0,80(s5)
    8000127e:	fffff097          	auipc	ra,0xfffff
    80001282:	796080e7          	jalr	1942(ra) # 80000a14 <uvmcopy>
    80001286:	04054a63          	bltz	a0,800012da <fork+0x8c>
    8000128a:	f426                	sd	s1,40(sp)
    8000128c:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000128e:	048ab783          	ld	a5,72(s5)
    80001292:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001296:	058ab683          	ld	a3,88(s5)
    8000129a:	87b6                	mv	a5,a3
    8000129c:	058a3703          	ld	a4,88(s4)
    800012a0:	12068693          	addi	a3,a3,288
    800012a4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012a8:	6788                	ld	a0,8(a5)
    800012aa:	6b8c                	ld	a1,16(a5)
    800012ac:	6f90                	ld	a2,24(a5)
    800012ae:	01073023          	sd	a6,0(a4)
    800012b2:	e708                	sd	a0,8(a4)
    800012b4:	eb0c                	sd	a1,16(a4)
    800012b6:	ef10                	sd	a2,24(a4)
    800012b8:	02078793          	addi	a5,a5,32
    800012bc:	02070713          	addi	a4,a4,32
    800012c0:	fed792e3          	bne	a5,a3,800012a4 <fork+0x56>
  np->trapframe->a0 = 0;
    800012c4:	058a3783          	ld	a5,88(s4)
    800012c8:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012cc:	0d0a8493          	addi	s1,s5,208
    800012d0:	0d0a0913          	addi	s2,s4,208
    800012d4:	150a8993          	addi	s3,s5,336
    800012d8:	a015                	j	800012fc <fork+0xae>
    freeproc(np);
    800012da:	8552                	mv	a0,s4
    800012dc:	00000097          	auipc	ra,0x0
    800012e0:	d52080e7          	jalr	-686(ra) # 8000102e <freeproc>
    release(&np->lock);
    800012e4:	8552                	mv	a0,s4
    800012e6:	00005097          	auipc	ra,0x5
    800012ea:	f64080e7          	jalr	-156(ra) # 8000624a <release>
    return -1;
    800012ee:	597d                	li	s2,-1
    800012f0:	6a42                	ld	s4,16(sp)
    800012f2:	a071                	j	8000137e <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    800012f4:	04a1                	addi	s1,s1,8
    800012f6:	0921                	addi	s2,s2,8
    800012f8:	01348b63          	beq	s1,s3,8000130e <fork+0xc0>
    if(p->ofile[i])
    800012fc:	6088                	ld	a0,0(s1)
    800012fe:	d97d                	beqz	a0,800012f4 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001300:	00002097          	auipc	ra,0x2
    80001304:	5f8080e7          	jalr	1528(ra) # 800038f8 <filedup>
    80001308:	00a93023          	sd	a0,0(s2)
    8000130c:	b7e5                	j	800012f4 <fork+0xa6>
  np->cwd = idup(p->cwd);
    8000130e:	150ab503          	ld	a0,336(s5)
    80001312:	00001097          	auipc	ra,0x1
    80001316:	75e080e7          	jalr	1886(ra) # 80002a70 <idup>
    8000131a:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000131e:	4641                	li	a2,16
    80001320:	158a8593          	addi	a1,s5,344
    80001324:	158a0513          	addi	a0,s4,344
    80001328:	fffff097          	auipc	ra,0xfffff
    8000132c:	f94080e7          	jalr	-108(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    80001330:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001334:	8552                	mv	a0,s4
    80001336:	00005097          	auipc	ra,0x5
    8000133a:	f14080e7          	jalr	-236(ra) # 8000624a <release>
  acquire(&wait_lock);
    8000133e:	0000b497          	auipc	s1,0xb
    80001342:	d2a48493          	addi	s1,s1,-726 # 8000c068 <wait_lock>
    80001346:	8526                	mv	a0,s1
    80001348:	00005097          	auipc	ra,0x5
    8000134c:	e4e080e7          	jalr	-434(ra) # 80006196 <acquire>
  np->parent = p;
    80001350:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001354:	8526                	mv	a0,s1
    80001356:	00005097          	auipc	ra,0x5
    8000135a:	ef4080e7          	jalr	-268(ra) # 8000624a <release>
  acquire(&np->lock);
    8000135e:	8552                	mv	a0,s4
    80001360:	00005097          	auipc	ra,0x5
    80001364:	e36080e7          	jalr	-458(ra) # 80006196 <acquire>
  np->state = RUNNABLE;
    80001368:	478d                	li	a5,3
    8000136a:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000136e:	8552                	mv	a0,s4
    80001370:	00005097          	auipc	ra,0x5
    80001374:	eda080e7          	jalr	-294(ra) # 8000624a <release>
  return pid;
    80001378:	74a2                	ld	s1,40(sp)
    8000137a:	69e2                	ld	s3,24(sp)
    8000137c:	6a42                	ld	s4,16(sp)
}
    8000137e:	854a                	mv	a0,s2
    80001380:	70e2                	ld	ra,56(sp)
    80001382:	7442                	ld	s0,48(sp)
    80001384:	7902                	ld	s2,32(sp)
    80001386:	6aa2                	ld	s5,8(sp)
    80001388:	6121                	addi	sp,sp,64
    8000138a:	8082                	ret
    return -1;
    8000138c:	597d                	li	s2,-1
    8000138e:	bfc5                	j	8000137e <fork+0x130>

0000000080001390 <scheduler>:
{
    80001390:	7139                	addi	sp,sp,-64
    80001392:	fc06                	sd	ra,56(sp)
    80001394:	f822                	sd	s0,48(sp)
    80001396:	f426                	sd	s1,40(sp)
    80001398:	f04a                	sd	s2,32(sp)
    8000139a:	ec4e                	sd	s3,24(sp)
    8000139c:	e852                	sd	s4,16(sp)
    8000139e:	e456                	sd	s5,8(sp)
    800013a0:	e05a                	sd	s6,0(sp)
    800013a2:	0080                	addi	s0,sp,64
    800013a4:	8792                	mv	a5,tp
  int id = r_tp();
    800013a6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013a8:	00779a93          	slli	s5,a5,0x7
    800013ac:	0000b717          	auipc	a4,0xb
    800013b0:	ca470713          	addi	a4,a4,-860 # 8000c050 <pid_lock>
    800013b4:	9756                	add	a4,a4,s5
    800013b6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013ba:	0000b717          	auipc	a4,0xb
    800013be:	cce70713          	addi	a4,a4,-818 # 8000c088 <cpus+0x8>
    800013c2:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013c4:	498d                	li	s3,3
        p->state = RUNNING;
    800013c6:	4b11                	li	s6,4
        c->proc = p;
    800013c8:	079e                	slli	a5,a5,0x7
    800013ca:	0000ba17          	auipc	s4,0xb
    800013ce:	c86a0a13          	addi	s4,s4,-890 # 8000c050 <pid_lock>
    800013d2:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013d4:	00011917          	auipc	s2,0x11
    800013d8:	aac90913          	addi	s2,s2,-1364 # 80011e80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013dc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013e0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013e4:	10079073          	csrw	sstatus,a5
    800013e8:	0000b497          	auipc	s1,0xb
    800013ec:	09848493          	addi	s1,s1,152 # 8000c480 <proc>
    800013f0:	a811                	j	80001404 <scheduler+0x74>
      release(&p->lock);
    800013f2:	8526                	mv	a0,s1
    800013f4:	00005097          	auipc	ra,0x5
    800013f8:	e56080e7          	jalr	-426(ra) # 8000624a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013fc:	16848493          	addi	s1,s1,360
    80001400:	fd248ee3          	beq	s1,s2,800013dc <scheduler+0x4c>
      acquire(&p->lock);
    80001404:	8526                	mv	a0,s1
    80001406:	00005097          	auipc	ra,0x5
    8000140a:	d90080e7          	jalr	-624(ra) # 80006196 <acquire>
      if(p->state == RUNNABLE) {
    8000140e:	4c9c                	lw	a5,24(s1)
    80001410:	ff3791e3          	bne	a5,s3,800013f2 <scheduler+0x62>
        p->state = RUNNING;
    80001414:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001418:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000141c:	06048593          	addi	a1,s1,96
    80001420:	8556                	mv	a0,s5
    80001422:	00000097          	auipc	ra,0x0
    80001426:	620080e7          	jalr	1568(ra) # 80001a42 <swtch>
        c->proc = 0;
    8000142a:	020a3823          	sd	zero,48(s4)
    8000142e:	b7d1                	j	800013f2 <scheduler+0x62>

0000000080001430 <sched>:
{
    80001430:	7179                	addi	sp,sp,-48
    80001432:	f406                	sd	ra,40(sp)
    80001434:	f022                	sd	s0,32(sp)
    80001436:	ec26                	sd	s1,24(sp)
    80001438:	e84a                	sd	s2,16(sp)
    8000143a:	e44e                	sd	s3,8(sp)
    8000143c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000143e:	00000097          	auipc	ra,0x0
    80001442:	a3e080e7          	jalr	-1474(ra) # 80000e7c <myproc>
    80001446:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001448:	00005097          	auipc	ra,0x5
    8000144c:	cd4080e7          	jalr	-812(ra) # 8000611c <holding>
    80001450:	c93d                	beqz	a0,800014c6 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001452:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001454:	2781                	sext.w	a5,a5
    80001456:	079e                	slli	a5,a5,0x7
    80001458:	0000b717          	auipc	a4,0xb
    8000145c:	bf870713          	addi	a4,a4,-1032 # 8000c050 <pid_lock>
    80001460:	97ba                	add	a5,a5,a4
    80001462:	0a87a703          	lw	a4,168(a5)
    80001466:	4785                	li	a5,1
    80001468:	06f71763          	bne	a4,a5,800014d6 <sched+0xa6>
  if(p->state == RUNNING)
    8000146c:	4c98                	lw	a4,24(s1)
    8000146e:	4791                	li	a5,4
    80001470:	06f70b63          	beq	a4,a5,800014e6 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001474:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001478:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000147a:	efb5                	bnez	a5,800014f6 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000147c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000147e:	0000b917          	auipc	s2,0xb
    80001482:	bd290913          	addi	s2,s2,-1070 # 8000c050 <pid_lock>
    80001486:	2781                	sext.w	a5,a5
    80001488:	079e                	slli	a5,a5,0x7
    8000148a:	97ca                	add	a5,a5,s2
    8000148c:	0ac7a983          	lw	s3,172(a5)
    80001490:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001492:	2781                	sext.w	a5,a5
    80001494:	079e                	slli	a5,a5,0x7
    80001496:	0000b597          	auipc	a1,0xb
    8000149a:	bf258593          	addi	a1,a1,-1038 # 8000c088 <cpus+0x8>
    8000149e:	95be                	add	a1,a1,a5
    800014a0:	06048513          	addi	a0,s1,96
    800014a4:	00000097          	auipc	ra,0x0
    800014a8:	59e080e7          	jalr	1438(ra) # 80001a42 <swtch>
    800014ac:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014ae:	2781                	sext.w	a5,a5
    800014b0:	079e                	slli	a5,a5,0x7
    800014b2:	993e                	add	s2,s2,a5
    800014b4:	0b392623          	sw	s3,172(s2)
}
    800014b8:	70a2                	ld	ra,40(sp)
    800014ba:	7402                	ld	s0,32(sp)
    800014bc:	64e2                	ld	s1,24(sp)
    800014be:	6942                	ld	s2,16(sp)
    800014c0:	69a2                	ld	s3,8(sp)
    800014c2:	6145                	addi	sp,sp,48
    800014c4:	8082                	ret
    panic("sched p->lock");
    800014c6:	00007517          	auipc	a0,0x7
    800014ca:	cd250513          	addi	a0,a0,-814 # 80008198 <etext+0x198>
    800014ce:	00004097          	auipc	ra,0x4
    800014d2:	74e080e7          	jalr	1870(ra) # 80005c1c <panic>
    panic("sched locks");
    800014d6:	00007517          	auipc	a0,0x7
    800014da:	cd250513          	addi	a0,a0,-814 # 800081a8 <etext+0x1a8>
    800014de:	00004097          	auipc	ra,0x4
    800014e2:	73e080e7          	jalr	1854(ra) # 80005c1c <panic>
    panic("sched running");
    800014e6:	00007517          	auipc	a0,0x7
    800014ea:	cd250513          	addi	a0,a0,-814 # 800081b8 <etext+0x1b8>
    800014ee:	00004097          	auipc	ra,0x4
    800014f2:	72e080e7          	jalr	1838(ra) # 80005c1c <panic>
    panic("sched interruptible");
    800014f6:	00007517          	auipc	a0,0x7
    800014fa:	cd250513          	addi	a0,a0,-814 # 800081c8 <etext+0x1c8>
    800014fe:	00004097          	auipc	ra,0x4
    80001502:	71e080e7          	jalr	1822(ra) # 80005c1c <panic>

0000000080001506 <yield>:
{
    80001506:	1101                	addi	sp,sp,-32
    80001508:	ec06                	sd	ra,24(sp)
    8000150a:	e822                	sd	s0,16(sp)
    8000150c:	e426                	sd	s1,8(sp)
    8000150e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001510:	00000097          	auipc	ra,0x0
    80001514:	96c080e7          	jalr	-1684(ra) # 80000e7c <myproc>
    80001518:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000151a:	00005097          	auipc	ra,0x5
    8000151e:	c7c080e7          	jalr	-900(ra) # 80006196 <acquire>
  p->state = RUNNABLE;
    80001522:	478d                	li	a5,3
    80001524:	cc9c                	sw	a5,24(s1)
  sched();
    80001526:	00000097          	auipc	ra,0x0
    8000152a:	f0a080e7          	jalr	-246(ra) # 80001430 <sched>
  release(&p->lock);
    8000152e:	8526                	mv	a0,s1
    80001530:	00005097          	auipc	ra,0x5
    80001534:	d1a080e7          	jalr	-742(ra) # 8000624a <release>
}
    80001538:	60e2                	ld	ra,24(sp)
    8000153a:	6442                	ld	s0,16(sp)
    8000153c:	64a2                	ld	s1,8(sp)
    8000153e:	6105                	addi	sp,sp,32
    80001540:	8082                	ret

0000000080001542 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001542:	7179                	addi	sp,sp,-48
    80001544:	f406                	sd	ra,40(sp)
    80001546:	f022                	sd	s0,32(sp)
    80001548:	ec26                	sd	s1,24(sp)
    8000154a:	e84a                	sd	s2,16(sp)
    8000154c:	e44e                	sd	s3,8(sp)
    8000154e:	1800                	addi	s0,sp,48
    80001550:	89aa                	mv	s3,a0
    80001552:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001554:	00000097          	auipc	ra,0x0
    80001558:	928080e7          	jalr	-1752(ra) # 80000e7c <myproc>
    8000155c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000155e:	00005097          	auipc	ra,0x5
    80001562:	c38080e7          	jalr	-968(ra) # 80006196 <acquire>
  release(lk);
    80001566:	854a                	mv	a0,s2
    80001568:	00005097          	auipc	ra,0x5
    8000156c:	ce2080e7          	jalr	-798(ra) # 8000624a <release>

  // Go to sleep.
  p->chan = chan;
    80001570:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001574:	4789                	li	a5,2
    80001576:	cc9c                	sw	a5,24(s1)

  sched();
    80001578:	00000097          	auipc	ra,0x0
    8000157c:	eb8080e7          	jalr	-328(ra) # 80001430 <sched>

  // Tidy up.
  p->chan = 0;
    80001580:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001584:	8526                	mv	a0,s1
    80001586:	00005097          	auipc	ra,0x5
    8000158a:	cc4080e7          	jalr	-828(ra) # 8000624a <release>
  acquire(lk);
    8000158e:	854a                	mv	a0,s2
    80001590:	00005097          	auipc	ra,0x5
    80001594:	c06080e7          	jalr	-1018(ra) # 80006196 <acquire>
}
    80001598:	70a2                	ld	ra,40(sp)
    8000159a:	7402                	ld	s0,32(sp)
    8000159c:	64e2                	ld	s1,24(sp)
    8000159e:	6942                	ld	s2,16(sp)
    800015a0:	69a2                	ld	s3,8(sp)
    800015a2:	6145                	addi	sp,sp,48
    800015a4:	8082                	ret

00000000800015a6 <wait>:
{
    800015a6:	715d                	addi	sp,sp,-80
    800015a8:	e486                	sd	ra,72(sp)
    800015aa:	e0a2                	sd	s0,64(sp)
    800015ac:	fc26                	sd	s1,56(sp)
    800015ae:	f84a                	sd	s2,48(sp)
    800015b0:	f44e                	sd	s3,40(sp)
    800015b2:	f052                	sd	s4,32(sp)
    800015b4:	ec56                	sd	s5,24(sp)
    800015b6:	e85a                	sd	s6,16(sp)
    800015b8:	e45e                	sd	s7,8(sp)
    800015ba:	e062                	sd	s8,0(sp)
    800015bc:	0880                	addi	s0,sp,80
    800015be:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015c0:	00000097          	auipc	ra,0x0
    800015c4:	8bc080e7          	jalr	-1860(ra) # 80000e7c <myproc>
    800015c8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015ca:	0000b517          	auipc	a0,0xb
    800015ce:	a9e50513          	addi	a0,a0,-1378 # 8000c068 <wait_lock>
    800015d2:	00005097          	auipc	ra,0x5
    800015d6:	bc4080e7          	jalr	-1084(ra) # 80006196 <acquire>
    havekids = 0;
    800015da:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015dc:	4a15                	li	s4,5
        havekids = 1;
    800015de:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015e0:	00011997          	auipc	s3,0x11
    800015e4:	8a098993          	addi	s3,s3,-1888 # 80011e80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015e8:	0000bc17          	auipc	s8,0xb
    800015ec:	a80c0c13          	addi	s8,s8,-1408 # 8000c068 <wait_lock>
    800015f0:	a87d                	j	800016ae <wait+0x108>
          pid = np->pid;
    800015f2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015f6:	000b0e63          	beqz	s6,80001612 <wait+0x6c>
    800015fa:	4691                	li	a3,4
    800015fc:	02c48613          	addi	a2,s1,44
    80001600:	85da                	mv	a1,s6
    80001602:	05093503          	ld	a0,80(s2)
    80001606:	fffff097          	auipc	ra,0xfffff
    8000160a:	512080e7          	jalr	1298(ra) # 80000b18 <copyout>
    8000160e:	04054163          	bltz	a0,80001650 <wait+0xaa>
          freeproc(np);
    80001612:	8526                	mv	a0,s1
    80001614:	00000097          	auipc	ra,0x0
    80001618:	a1a080e7          	jalr	-1510(ra) # 8000102e <freeproc>
          release(&np->lock);
    8000161c:	8526                	mv	a0,s1
    8000161e:	00005097          	auipc	ra,0x5
    80001622:	c2c080e7          	jalr	-980(ra) # 8000624a <release>
          release(&wait_lock);
    80001626:	0000b517          	auipc	a0,0xb
    8000162a:	a4250513          	addi	a0,a0,-1470 # 8000c068 <wait_lock>
    8000162e:	00005097          	auipc	ra,0x5
    80001632:	c1c080e7          	jalr	-996(ra) # 8000624a <release>
}
    80001636:	854e                	mv	a0,s3
    80001638:	60a6                	ld	ra,72(sp)
    8000163a:	6406                	ld	s0,64(sp)
    8000163c:	74e2                	ld	s1,56(sp)
    8000163e:	7942                	ld	s2,48(sp)
    80001640:	79a2                	ld	s3,40(sp)
    80001642:	7a02                	ld	s4,32(sp)
    80001644:	6ae2                	ld	s5,24(sp)
    80001646:	6b42                	ld	s6,16(sp)
    80001648:	6ba2                	ld	s7,8(sp)
    8000164a:	6c02                	ld	s8,0(sp)
    8000164c:	6161                	addi	sp,sp,80
    8000164e:	8082                	ret
            release(&np->lock);
    80001650:	8526                	mv	a0,s1
    80001652:	00005097          	auipc	ra,0x5
    80001656:	bf8080e7          	jalr	-1032(ra) # 8000624a <release>
            release(&wait_lock);
    8000165a:	0000b517          	auipc	a0,0xb
    8000165e:	a0e50513          	addi	a0,a0,-1522 # 8000c068 <wait_lock>
    80001662:	00005097          	auipc	ra,0x5
    80001666:	be8080e7          	jalr	-1048(ra) # 8000624a <release>
            return -1;
    8000166a:	59fd                	li	s3,-1
    8000166c:	b7e9                	j	80001636 <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    8000166e:	16848493          	addi	s1,s1,360
    80001672:	03348463          	beq	s1,s3,8000169a <wait+0xf4>
      if(np->parent == p){
    80001676:	7c9c                	ld	a5,56(s1)
    80001678:	ff279be3          	bne	a5,s2,8000166e <wait+0xc8>
        acquire(&np->lock);
    8000167c:	8526                	mv	a0,s1
    8000167e:	00005097          	auipc	ra,0x5
    80001682:	b18080e7          	jalr	-1256(ra) # 80006196 <acquire>
        if(np->state == ZOMBIE){
    80001686:	4c9c                	lw	a5,24(s1)
    80001688:	f74785e3          	beq	a5,s4,800015f2 <wait+0x4c>
        release(&np->lock);
    8000168c:	8526                	mv	a0,s1
    8000168e:	00005097          	auipc	ra,0x5
    80001692:	bbc080e7          	jalr	-1092(ra) # 8000624a <release>
        havekids = 1;
    80001696:	8756                	mv	a4,s5
    80001698:	bfd9                	j	8000166e <wait+0xc8>
    if(!havekids || p->killed){
    8000169a:	c305                	beqz	a4,800016ba <wait+0x114>
    8000169c:	02892783          	lw	a5,40(s2)
    800016a0:	ef89                	bnez	a5,800016ba <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016a2:	85e2                	mv	a1,s8
    800016a4:	854a                	mv	a0,s2
    800016a6:	00000097          	auipc	ra,0x0
    800016aa:	e9c080e7          	jalr	-356(ra) # 80001542 <sleep>
    havekids = 0;
    800016ae:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800016b0:	0000b497          	auipc	s1,0xb
    800016b4:	dd048493          	addi	s1,s1,-560 # 8000c480 <proc>
    800016b8:	bf7d                	j	80001676 <wait+0xd0>
      release(&wait_lock);
    800016ba:	0000b517          	auipc	a0,0xb
    800016be:	9ae50513          	addi	a0,a0,-1618 # 8000c068 <wait_lock>
    800016c2:	00005097          	auipc	ra,0x5
    800016c6:	b88080e7          	jalr	-1144(ra) # 8000624a <release>
      return -1;
    800016ca:	59fd                	li	s3,-1
    800016cc:	b7ad                	j	80001636 <wait+0x90>

00000000800016ce <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016ce:	7139                	addi	sp,sp,-64
    800016d0:	fc06                	sd	ra,56(sp)
    800016d2:	f822                	sd	s0,48(sp)
    800016d4:	f426                	sd	s1,40(sp)
    800016d6:	f04a                	sd	s2,32(sp)
    800016d8:	ec4e                	sd	s3,24(sp)
    800016da:	e852                	sd	s4,16(sp)
    800016dc:	e456                	sd	s5,8(sp)
    800016de:	0080                	addi	s0,sp,64
    800016e0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016e2:	0000b497          	auipc	s1,0xb
    800016e6:	d9e48493          	addi	s1,s1,-610 # 8000c480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016ea:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016ec:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016ee:	00010917          	auipc	s2,0x10
    800016f2:	79290913          	addi	s2,s2,1938 # 80011e80 <tickslock>
    800016f6:	a811                	j	8000170a <wakeup+0x3c>
      }
      release(&p->lock);
    800016f8:	8526                	mv	a0,s1
    800016fa:	00005097          	auipc	ra,0x5
    800016fe:	b50080e7          	jalr	-1200(ra) # 8000624a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001702:	16848493          	addi	s1,s1,360
    80001706:	03248663          	beq	s1,s2,80001732 <wakeup+0x64>
    if(p != myproc()){
    8000170a:	fffff097          	auipc	ra,0xfffff
    8000170e:	772080e7          	jalr	1906(ra) # 80000e7c <myproc>
    80001712:	fea488e3          	beq	s1,a0,80001702 <wakeup+0x34>
      acquire(&p->lock);
    80001716:	8526                	mv	a0,s1
    80001718:	00005097          	auipc	ra,0x5
    8000171c:	a7e080e7          	jalr	-1410(ra) # 80006196 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001720:	4c9c                	lw	a5,24(s1)
    80001722:	fd379be3          	bne	a5,s3,800016f8 <wakeup+0x2a>
    80001726:	709c                	ld	a5,32(s1)
    80001728:	fd4798e3          	bne	a5,s4,800016f8 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000172c:	0154ac23          	sw	s5,24(s1)
    80001730:	b7e1                	j	800016f8 <wakeup+0x2a>
    }
  }
}
    80001732:	70e2                	ld	ra,56(sp)
    80001734:	7442                	ld	s0,48(sp)
    80001736:	74a2                	ld	s1,40(sp)
    80001738:	7902                	ld	s2,32(sp)
    8000173a:	69e2                	ld	s3,24(sp)
    8000173c:	6a42                	ld	s4,16(sp)
    8000173e:	6aa2                	ld	s5,8(sp)
    80001740:	6121                	addi	sp,sp,64
    80001742:	8082                	ret

0000000080001744 <reparent>:
{
    80001744:	7179                	addi	sp,sp,-48
    80001746:	f406                	sd	ra,40(sp)
    80001748:	f022                	sd	s0,32(sp)
    8000174a:	ec26                	sd	s1,24(sp)
    8000174c:	e84a                	sd	s2,16(sp)
    8000174e:	e44e                	sd	s3,8(sp)
    80001750:	e052                	sd	s4,0(sp)
    80001752:	1800                	addi	s0,sp,48
    80001754:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001756:	0000b497          	auipc	s1,0xb
    8000175a:	d2a48493          	addi	s1,s1,-726 # 8000c480 <proc>
      pp->parent = initproc;
    8000175e:	0000ba17          	auipc	s4,0xb
    80001762:	8b2a0a13          	addi	s4,s4,-1870 # 8000c010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001766:	00010997          	auipc	s3,0x10
    8000176a:	71a98993          	addi	s3,s3,1818 # 80011e80 <tickslock>
    8000176e:	a029                	j	80001778 <reparent+0x34>
    80001770:	16848493          	addi	s1,s1,360
    80001774:	01348d63          	beq	s1,s3,8000178e <reparent+0x4a>
    if(pp->parent == p){
    80001778:	7c9c                	ld	a5,56(s1)
    8000177a:	ff279be3          	bne	a5,s2,80001770 <reparent+0x2c>
      pp->parent = initproc;
    8000177e:	000a3503          	ld	a0,0(s4)
    80001782:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001784:	00000097          	auipc	ra,0x0
    80001788:	f4a080e7          	jalr	-182(ra) # 800016ce <wakeup>
    8000178c:	b7d5                	j	80001770 <reparent+0x2c>
}
    8000178e:	70a2                	ld	ra,40(sp)
    80001790:	7402                	ld	s0,32(sp)
    80001792:	64e2                	ld	s1,24(sp)
    80001794:	6942                	ld	s2,16(sp)
    80001796:	69a2                	ld	s3,8(sp)
    80001798:	6a02                	ld	s4,0(sp)
    8000179a:	6145                	addi	sp,sp,48
    8000179c:	8082                	ret

000000008000179e <exit>:
{
    8000179e:	7179                	addi	sp,sp,-48
    800017a0:	f406                	sd	ra,40(sp)
    800017a2:	f022                	sd	s0,32(sp)
    800017a4:	ec26                	sd	s1,24(sp)
    800017a6:	e84a                	sd	s2,16(sp)
    800017a8:	e44e                	sd	s3,8(sp)
    800017aa:	e052                	sd	s4,0(sp)
    800017ac:	1800                	addi	s0,sp,48
    800017ae:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017b0:	fffff097          	auipc	ra,0xfffff
    800017b4:	6cc080e7          	jalr	1740(ra) # 80000e7c <myproc>
    800017b8:	89aa                	mv	s3,a0
  if(p == initproc)
    800017ba:	0000b797          	auipc	a5,0xb
    800017be:	8567b783          	ld	a5,-1962(a5) # 8000c010 <initproc>
    800017c2:	0d050493          	addi	s1,a0,208
    800017c6:	15050913          	addi	s2,a0,336
    800017ca:	02a79363          	bne	a5,a0,800017f0 <exit+0x52>
    panic("init exiting");
    800017ce:	00007517          	auipc	a0,0x7
    800017d2:	a1250513          	addi	a0,a0,-1518 # 800081e0 <etext+0x1e0>
    800017d6:	00004097          	auipc	ra,0x4
    800017da:	446080e7          	jalr	1094(ra) # 80005c1c <panic>
      fileclose(f);
    800017de:	00002097          	auipc	ra,0x2
    800017e2:	16c080e7          	jalr	364(ra) # 8000394a <fileclose>
      p->ofile[fd] = 0;
    800017e6:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017ea:	04a1                	addi	s1,s1,8
    800017ec:	01248563          	beq	s1,s2,800017f6 <exit+0x58>
    if(p->ofile[fd]){
    800017f0:	6088                	ld	a0,0(s1)
    800017f2:	f575                	bnez	a0,800017de <exit+0x40>
    800017f4:	bfdd                	j	800017ea <exit+0x4c>
  begin_op();
    800017f6:	00002097          	auipc	ra,0x2
    800017fa:	c8a080e7          	jalr	-886(ra) # 80003480 <begin_op>
  iput(p->cwd);
    800017fe:	1509b503          	ld	a0,336(s3)
    80001802:	00001097          	auipc	ra,0x1
    80001806:	46a080e7          	jalr	1130(ra) # 80002c6c <iput>
  end_op();
    8000180a:	00002097          	auipc	ra,0x2
    8000180e:	cf0080e7          	jalr	-784(ra) # 800034fa <end_op>
  p->cwd = 0;
    80001812:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001816:	0000b497          	auipc	s1,0xb
    8000181a:	85248493          	addi	s1,s1,-1966 # 8000c068 <wait_lock>
    8000181e:	8526                	mv	a0,s1
    80001820:	00005097          	auipc	ra,0x5
    80001824:	976080e7          	jalr	-1674(ra) # 80006196 <acquire>
  reparent(p);
    80001828:	854e                	mv	a0,s3
    8000182a:	00000097          	auipc	ra,0x0
    8000182e:	f1a080e7          	jalr	-230(ra) # 80001744 <reparent>
  wakeup(p->parent);
    80001832:	0389b503          	ld	a0,56(s3)
    80001836:	00000097          	auipc	ra,0x0
    8000183a:	e98080e7          	jalr	-360(ra) # 800016ce <wakeup>
  acquire(&p->lock);
    8000183e:	854e                	mv	a0,s3
    80001840:	00005097          	auipc	ra,0x5
    80001844:	956080e7          	jalr	-1706(ra) # 80006196 <acquire>
  p->xstate = status;
    80001848:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000184c:	4795                	li	a5,5
    8000184e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001852:	8526                	mv	a0,s1
    80001854:	00005097          	auipc	ra,0x5
    80001858:	9f6080e7          	jalr	-1546(ra) # 8000624a <release>
  sched();
    8000185c:	00000097          	auipc	ra,0x0
    80001860:	bd4080e7          	jalr	-1068(ra) # 80001430 <sched>
  panic("zombie exit");
    80001864:	00007517          	auipc	a0,0x7
    80001868:	98c50513          	addi	a0,a0,-1652 # 800081f0 <etext+0x1f0>
    8000186c:	00004097          	auipc	ra,0x4
    80001870:	3b0080e7          	jalr	944(ra) # 80005c1c <panic>

0000000080001874 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001874:	7179                	addi	sp,sp,-48
    80001876:	f406                	sd	ra,40(sp)
    80001878:	f022                	sd	s0,32(sp)
    8000187a:	ec26                	sd	s1,24(sp)
    8000187c:	e84a                	sd	s2,16(sp)
    8000187e:	e44e                	sd	s3,8(sp)
    80001880:	1800                	addi	s0,sp,48
    80001882:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001884:	0000b497          	auipc	s1,0xb
    80001888:	bfc48493          	addi	s1,s1,-1028 # 8000c480 <proc>
    8000188c:	00010997          	auipc	s3,0x10
    80001890:	5f498993          	addi	s3,s3,1524 # 80011e80 <tickslock>
    acquire(&p->lock);
    80001894:	8526                	mv	a0,s1
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	900080e7          	jalr	-1792(ra) # 80006196 <acquire>
    if(p->pid == pid){
    8000189e:	589c                	lw	a5,48(s1)
    800018a0:	01278d63          	beq	a5,s2,800018ba <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018a4:	8526                	mv	a0,s1
    800018a6:	00005097          	auipc	ra,0x5
    800018aa:	9a4080e7          	jalr	-1628(ra) # 8000624a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018ae:	16848493          	addi	s1,s1,360
    800018b2:	ff3491e3          	bne	s1,s3,80001894 <kill+0x20>
  }
  return -1;
    800018b6:	557d                	li	a0,-1
    800018b8:	a829                	j	800018d2 <kill+0x5e>
      p->killed = 1;
    800018ba:	4785                	li	a5,1
    800018bc:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018be:	4c98                	lw	a4,24(s1)
    800018c0:	4789                	li	a5,2
    800018c2:	00f70f63          	beq	a4,a5,800018e0 <kill+0x6c>
      release(&p->lock);
    800018c6:	8526                	mv	a0,s1
    800018c8:	00005097          	auipc	ra,0x5
    800018cc:	982080e7          	jalr	-1662(ra) # 8000624a <release>
      return 0;
    800018d0:	4501                	li	a0,0
}
    800018d2:	70a2                	ld	ra,40(sp)
    800018d4:	7402                	ld	s0,32(sp)
    800018d6:	64e2                	ld	s1,24(sp)
    800018d8:	6942                	ld	s2,16(sp)
    800018da:	69a2                	ld	s3,8(sp)
    800018dc:	6145                	addi	sp,sp,48
    800018de:	8082                	ret
        p->state = RUNNABLE;
    800018e0:	478d                	li	a5,3
    800018e2:	cc9c                	sw	a5,24(s1)
    800018e4:	b7cd                	j	800018c6 <kill+0x52>

00000000800018e6 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018e6:	7179                	addi	sp,sp,-48
    800018e8:	f406                	sd	ra,40(sp)
    800018ea:	f022                	sd	s0,32(sp)
    800018ec:	ec26                	sd	s1,24(sp)
    800018ee:	e84a                	sd	s2,16(sp)
    800018f0:	e44e                	sd	s3,8(sp)
    800018f2:	e052                	sd	s4,0(sp)
    800018f4:	1800                	addi	s0,sp,48
    800018f6:	84aa                	mv	s1,a0
    800018f8:	892e                	mv	s2,a1
    800018fa:	89b2                	mv	s3,a2
    800018fc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018fe:	fffff097          	auipc	ra,0xfffff
    80001902:	57e080e7          	jalr	1406(ra) # 80000e7c <myproc>
  if(user_dst){
    80001906:	c08d                	beqz	s1,80001928 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001908:	86d2                	mv	a3,s4
    8000190a:	864e                	mv	a2,s3
    8000190c:	85ca                	mv	a1,s2
    8000190e:	6928                	ld	a0,80(a0)
    80001910:	fffff097          	auipc	ra,0xfffff
    80001914:	208080e7          	jalr	520(ra) # 80000b18 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001918:	70a2                	ld	ra,40(sp)
    8000191a:	7402                	ld	s0,32(sp)
    8000191c:	64e2                	ld	s1,24(sp)
    8000191e:	6942                	ld	s2,16(sp)
    80001920:	69a2                	ld	s3,8(sp)
    80001922:	6a02                	ld	s4,0(sp)
    80001924:	6145                	addi	sp,sp,48
    80001926:	8082                	ret
    memmove((char *)dst, src, len);
    80001928:	000a061b          	sext.w	a2,s4
    8000192c:	85ce                	mv	a1,s3
    8000192e:	854a                	mv	a0,s2
    80001930:	fffff097          	auipc	ra,0xfffff
    80001934:	8a6080e7          	jalr	-1882(ra) # 800001d6 <memmove>
    return 0;
    80001938:	8526                	mv	a0,s1
    8000193a:	bff9                	j	80001918 <either_copyout+0x32>

000000008000193c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000193c:	7179                	addi	sp,sp,-48
    8000193e:	f406                	sd	ra,40(sp)
    80001940:	f022                	sd	s0,32(sp)
    80001942:	ec26                	sd	s1,24(sp)
    80001944:	e84a                	sd	s2,16(sp)
    80001946:	e44e                	sd	s3,8(sp)
    80001948:	e052                	sd	s4,0(sp)
    8000194a:	1800                	addi	s0,sp,48
    8000194c:	892a                	mv	s2,a0
    8000194e:	84ae                	mv	s1,a1
    80001950:	89b2                	mv	s3,a2
    80001952:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001954:	fffff097          	auipc	ra,0xfffff
    80001958:	528080e7          	jalr	1320(ra) # 80000e7c <myproc>
  if(user_src){
    8000195c:	c08d                	beqz	s1,8000197e <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000195e:	86d2                	mv	a3,s4
    80001960:	864e                	mv	a2,s3
    80001962:	85ca                	mv	a1,s2
    80001964:	6928                	ld	a0,80(a0)
    80001966:	fffff097          	auipc	ra,0xfffff
    8000196a:	23e080e7          	jalr	574(ra) # 80000ba4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000196e:	70a2                	ld	ra,40(sp)
    80001970:	7402                	ld	s0,32(sp)
    80001972:	64e2                	ld	s1,24(sp)
    80001974:	6942                	ld	s2,16(sp)
    80001976:	69a2                	ld	s3,8(sp)
    80001978:	6a02                	ld	s4,0(sp)
    8000197a:	6145                	addi	sp,sp,48
    8000197c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000197e:	000a061b          	sext.w	a2,s4
    80001982:	85ce                	mv	a1,s3
    80001984:	854a                	mv	a0,s2
    80001986:	fffff097          	auipc	ra,0xfffff
    8000198a:	850080e7          	jalr	-1968(ra) # 800001d6 <memmove>
    return 0;
    8000198e:	8526                	mv	a0,s1
    80001990:	bff9                	j	8000196e <either_copyin+0x32>

0000000080001992 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001992:	715d                	addi	sp,sp,-80
    80001994:	e486                	sd	ra,72(sp)
    80001996:	e0a2                	sd	s0,64(sp)
    80001998:	fc26                	sd	s1,56(sp)
    8000199a:	f84a                	sd	s2,48(sp)
    8000199c:	f44e                	sd	s3,40(sp)
    8000199e:	f052                	sd	s4,32(sp)
    800019a0:	ec56                	sd	s5,24(sp)
    800019a2:	e85a                	sd	s6,16(sp)
    800019a4:	e45e                	sd	s7,8(sp)
    800019a6:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019a8:	00006517          	auipc	a0,0x6
    800019ac:	67050513          	addi	a0,a0,1648 # 80008018 <etext+0x18>
    800019b0:	00004097          	auipc	ra,0x4
    800019b4:	2b6080e7          	jalr	694(ra) # 80005c66 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019b8:	0000b497          	auipc	s1,0xb
    800019bc:	c2048493          	addi	s1,s1,-992 # 8000c5d8 <proc+0x158>
    800019c0:	00010917          	auipc	s2,0x10
    800019c4:	61890913          	addi	s2,s2,1560 # 80011fd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019c8:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019ca:	00007997          	auipc	s3,0x7
    800019ce:	83698993          	addi	s3,s3,-1994 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019d2:	00007a97          	auipc	s5,0x7
    800019d6:	836a8a93          	addi	s5,s5,-1994 # 80008208 <etext+0x208>
    printf("\n");
    800019da:	00006a17          	auipc	s4,0x6
    800019de:	63ea0a13          	addi	s4,s4,1598 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e2:	00007b97          	auipc	s7,0x7
    800019e6:	d1eb8b93          	addi	s7,s7,-738 # 80008700 <states.0>
    800019ea:	a00d                	j	80001a0c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019ec:	ed86a583          	lw	a1,-296(a3)
    800019f0:	8556                	mv	a0,s5
    800019f2:	00004097          	auipc	ra,0x4
    800019f6:	274080e7          	jalr	628(ra) # 80005c66 <printf>
    printf("\n");
    800019fa:	8552                	mv	a0,s4
    800019fc:	00004097          	auipc	ra,0x4
    80001a00:	26a080e7          	jalr	618(ra) # 80005c66 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a04:	16848493          	addi	s1,s1,360
    80001a08:	03248263          	beq	s1,s2,80001a2c <procdump+0x9a>
    if(p->state == UNUSED)
    80001a0c:	86a6                	mv	a3,s1
    80001a0e:	ec04a783          	lw	a5,-320(s1)
    80001a12:	dbed                	beqz	a5,80001a04 <procdump+0x72>
      state = "???";
    80001a14:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a16:	fcfb6be3          	bltu	s6,a5,800019ec <procdump+0x5a>
    80001a1a:	02079713          	slli	a4,a5,0x20
    80001a1e:	01d75793          	srli	a5,a4,0x1d
    80001a22:	97de                	add	a5,a5,s7
    80001a24:	6390                	ld	a2,0(a5)
    80001a26:	f279                	bnez	a2,800019ec <procdump+0x5a>
      state = "???";
    80001a28:	864e                	mv	a2,s3
    80001a2a:	b7c9                	j	800019ec <procdump+0x5a>
  }
}
    80001a2c:	60a6                	ld	ra,72(sp)
    80001a2e:	6406                	ld	s0,64(sp)
    80001a30:	74e2                	ld	s1,56(sp)
    80001a32:	7942                	ld	s2,48(sp)
    80001a34:	79a2                	ld	s3,40(sp)
    80001a36:	7a02                	ld	s4,32(sp)
    80001a38:	6ae2                	ld	s5,24(sp)
    80001a3a:	6b42                	ld	s6,16(sp)
    80001a3c:	6ba2                	ld	s7,8(sp)
    80001a3e:	6161                	addi	sp,sp,80
    80001a40:	8082                	ret

0000000080001a42 <swtch>:
    80001a42:	00153023          	sd	ra,0(a0)
    80001a46:	00253423          	sd	sp,8(a0)
    80001a4a:	e900                	sd	s0,16(a0)
    80001a4c:	ed04                	sd	s1,24(a0)
    80001a4e:	03253023          	sd	s2,32(a0)
    80001a52:	03353423          	sd	s3,40(a0)
    80001a56:	03453823          	sd	s4,48(a0)
    80001a5a:	03553c23          	sd	s5,56(a0)
    80001a5e:	05653023          	sd	s6,64(a0)
    80001a62:	05753423          	sd	s7,72(a0)
    80001a66:	05853823          	sd	s8,80(a0)
    80001a6a:	05953c23          	sd	s9,88(a0)
    80001a6e:	07a53023          	sd	s10,96(a0)
    80001a72:	07b53423          	sd	s11,104(a0)
    80001a76:	0005b083          	ld	ra,0(a1)
    80001a7a:	0085b103          	ld	sp,8(a1)
    80001a7e:	6980                	ld	s0,16(a1)
    80001a80:	6d84                	ld	s1,24(a1)
    80001a82:	0205b903          	ld	s2,32(a1)
    80001a86:	0285b983          	ld	s3,40(a1)
    80001a8a:	0305ba03          	ld	s4,48(a1)
    80001a8e:	0385ba83          	ld	s5,56(a1)
    80001a92:	0405bb03          	ld	s6,64(a1)
    80001a96:	0485bb83          	ld	s7,72(a1)
    80001a9a:	0505bc03          	ld	s8,80(a1)
    80001a9e:	0585bc83          	ld	s9,88(a1)
    80001aa2:	0605bd03          	ld	s10,96(a1)
    80001aa6:	0685bd83          	ld	s11,104(a1)
    80001aaa:	8082                	ret

0000000080001aac <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001aac:	1141                	addi	sp,sp,-16
    80001aae:	e406                	sd	ra,8(sp)
    80001ab0:	e022                	sd	s0,0(sp)
    80001ab2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ab4:	00006597          	auipc	a1,0x6
    80001ab8:	78c58593          	addi	a1,a1,1932 # 80008240 <etext+0x240>
    80001abc:	00010517          	auipc	a0,0x10
    80001ac0:	3c450513          	addi	a0,a0,964 # 80011e80 <tickslock>
    80001ac4:	00004097          	auipc	ra,0x4
    80001ac8:	642080e7          	jalr	1602(ra) # 80006106 <initlock>
}
    80001acc:	60a2                	ld	ra,8(sp)
    80001ace:	6402                	ld	s0,0(sp)
    80001ad0:	0141                	addi	sp,sp,16
    80001ad2:	8082                	ret

0000000080001ad4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ad4:	1141                	addi	sp,sp,-16
    80001ad6:	e422                	sd	s0,8(sp)
    80001ad8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ada:	00003797          	auipc	a5,0x3
    80001ade:	55678793          	addi	a5,a5,1366 # 80005030 <kernelvec>
    80001ae2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ae6:	6422                	ld	s0,8(sp)
    80001ae8:	0141                	addi	sp,sp,16
    80001aea:	8082                	ret

0000000080001aec <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001aec:	1141                	addi	sp,sp,-16
    80001aee:	e406                	sd	ra,8(sp)
    80001af0:	e022                	sd	s0,0(sp)
    80001af2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001af4:	fffff097          	auipc	ra,0xfffff
    80001af8:	388080e7          	jalr	904(ra) # 80000e7c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001afc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b00:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b02:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b06:	00005697          	auipc	a3,0x5
    80001b0a:	4fa68693          	addi	a3,a3,1274 # 80007000 <_trampoline>
    80001b0e:	00005717          	auipc	a4,0x5
    80001b12:	4f270713          	addi	a4,a4,1266 # 80007000 <_trampoline>
    80001b16:	8f15                	sub	a4,a4,a3
    80001b18:	040007b7          	lui	a5,0x4000
    80001b1c:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b1e:	07b2                	slli	a5,a5,0xc
    80001b20:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b22:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b26:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b28:	18002673          	csrr	a2,satp
    80001b2c:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b2e:	6d30                	ld	a2,88(a0)
    80001b30:	6138                	ld	a4,64(a0)
    80001b32:	6585                	lui	a1,0x1
    80001b34:	972e                	add	a4,a4,a1
    80001b36:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b38:	6d38                	ld	a4,88(a0)
    80001b3a:	00000617          	auipc	a2,0x0
    80001b3e:	14060613          	addi	a2,a2,320 # 80001c7a <usertrap>
    80001b42:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b44:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b46:	8612                	mv	a2,tp
    80001b48:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b4a:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b4e:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b52:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b56:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b5a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b5c:	6f18                	ld	a4,24(a4)
    80001b5e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b62:	692c                	ld	a1,80(a0)
    80001b64:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b66:	00005717          	auipc	a4,0x5
    80001b6a:	52a70713          	addi	a4,a4,1322 # 80007090 <userret>
    80001b6e:	8f15                	sub	a4,a4,a3
    80001b70:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b72:	577d                	li	a4,-1
    80001b74:	177e                	slli	a4,a4,0x3f
    80001b76:	8dd9                	or	a1,a1,a4
    80001b78:	02000537          	lui	a0,0x2000
    80001b7c:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001b7e:	0536                	slli	a0,a0,0xd
    80001b80:	9782                	jalr	a5
}
    80001b82:	60a2                	ld	ra,8(sp)
    80001b84:	6402                	ld	s0,0(sp)
    80001b86:	0141                	addi	sp,sp,16
    80001b88:	8082                	ret

0000000080001b8a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b8a:	1101                	addi	sp,sp,-32
    80001b8c:	ec06                	sd	ra,24(sp)
    80001b8e:	e822                	sd	s0,16(sp)
    80001b90:	e426                	sd	s1,8(sp)
    80001b92:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b94:	00010497          	auipc	s1,0x10
    80001b98:	2ec48493          	addi	s1,s1,748 # 80011e80 <tickslock>
    80001b9c:	8526                	mv	a0,s1
    80001b9e:	00004097          	auipc	ra,0x4
    80001ba2:	5f8080e7          	jalr	1528(ra) # 80006196 <acquire>
  ticks++;
    80001ba6:	0000a517          	auipc	a0,0xa
    80001baa:	47250513          	addi	a0,a0,1138 # 8000c018 <ticks>
    80001bae:	411c                	lw	a5,0(a0)
    80001bb0:	2785                	addiw	a5,a5,1
    80001bb2:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bb4:	00000097          	auipc	ra,0x0
    80001bb8:	b1a080e7          	jalr	-1254(ra) # 800016ce <wakeup>
  release(&tickslock);
    80001bbc:	8526                	mv	a0,s1
    80001bbe:	00004097          	auipc	ra,0x4
    80001bc2:	68c080e7          	jalr	1676(ra) # 8000624a <release>
}
    80001bc6:	60e2                	ld	ra,24(sp)
    80001bc8:	6442                	ld	s0,16(sp)
    80001bca:	64a2                	ld	s1,8(sp)
    80001bcc:	6105                	addi	sp,sp,32
    80001bce:	8082                	ret

0000000080001bd0 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bd0:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bd4:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001bd6:	0a07d163          	bgez	a5,80001c78 <devintr+0xa8>
{
    80001bda:	1101                	addi	sp,sp,-32
    80001bdc:	ec06                	sd	ra,24(sp)
    80001bde:	e822                	sd	s0,16(sp)
    80001be0:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001be2:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001be6:	46a5                	li	a3,9
    80001be8:	00d70c63          	beq	a4,a3,80001c00 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001bec:	577d                	li	a4,-1
    80001bee:	177e                	slli	a4,a4,0x3f
    80001bf0:	0705                	addi	a4,a4,1
    return 0;
    80001bf2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bf4:	06e78163          	beq	a5,a4,80001c56 <devintr+0x86>
  }
}
    80001bf8:	60e2                	ld	ra,24(sp)
    80001bfa:	6442                	ld	s0,16(sp)
    80001bfc:	6105                	addi	sp,sp,32
    80001bfe:	8082                	ret
    80001c00:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001c02:	00003097          	auipc	ra,0x3
    80001c06:	53a080e7          	jalr	1338(ra) # 8000513c <plic_claim>
    80001c0a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c0c:	47a9                	li	a5,10
    80001c0e:	00f50963          	beq	a0,a5,80001c20 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001c12:	4785                	li	a5,1
    80001c14:	00f50b63          	beq	a0,a5,80001c2a <devintr+0x5a>
    return 1;
    80001c18:	4505                	li	a0,1
    } else if(irq){
    80001c1a:	ec89                	bnez	s1,80001c34 <devintr+0x64>
    80001c1c:	64a2                	ld	s1,8(sp)
    80001c1e:	bfe9                	j	80001bf8 <devintr+0x28>
      uartintr();
    80001c20:	00004097          	auipc	ra,0x4
    80001c24:	496080e7          	jalr	1174(ra) # 800060b6 <uartintr>
    if(irq)
    80001c28:	a839                	j	80001c46 <devintr+0x76>
      virtio_disk_intr();
    80001c2a:	00004097          	auipc	ra,0x4
    80001c2e:	9e6080e7          	jalr	-1562(ra) # 80005610 <virtio_disk_intr>
    if(irq)
    80001c32:	a811                	j	80001c46 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c34:	85a6                	mv	a1,s1
    80001c36:	00006517          	auipc	a0,0x6
    80001c3a:	61250513          	addi	a0,a0,1554 # 80008248 <etext+0x248>
    80001c3e:	00004097          	auipc	ra,0x4
    80001c42:	028080e7          	jalr	40(ra) # 80005c66 <printf>
      plic_complete(irq);
    80001c46:	8526                	mv	a0,s1
    80001c48:	00003097          	auipc	ra,0x3
    80001c4c:	518080e7          	jalr	1304(ra) # 80005160 <plic_complete>
    return 1;
    80001c50:	4505                	li	a0,1
    80001c52:	64a2                	ld	s1,8(sp)
    80001c54:	b755                	j	80001bf8 <devintr+0x28>
    if(cpuid() == 0){
    80001c56:	fffff097          	auipc	ra,0xfffff
    80001c5a:	1fa080e7          	jalr	506(ra) # 80000e50 <cpuid>
    80001c5e:	c901                	beqz	a0,80001c6e <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c60:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c64:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c66:	14479073          	csrw	sip,a5
    return 2;
    80001c6a:	4509                	li	a0,2
    80001c6c:	b771                	j	80001bf8 <devintr+0x28>
      clockintr();
    80001c6e:	00000097          	auipc	ra,0x0
    80001c72:	f1c080e7          	jalr	-228(ra) # 80001b8a <clockintr>
    80001c76:	b7ed                	j	80001c60 <devintr+0x90>
}
    80001c78:	8082                	ret

0000000080001c7a <usertrap>:
{
    80001c7a:	1101                	addi	sp,sp,-32
    80001c7c:	ec06                	sd	ra,24(sp)
    80001c7e:	e822                	sd	s0,16(sp)
    80001c80:	e426                	sd	s1,8(sp)
    80001c82:	e04a                	sd	s2,0(sp)
    80001c84:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c86:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c8a:	1007f793          	andi	a5,a5,256
    80001c8e:	e3ad                	bnez	a5,80001cf0 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c90:	00003797          	auipc	a5,0x3
    80001c94:	3a078793          	addi	a5,a5,928 # 80005030 <kernelvec>
    80001c98:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c9c:	fffff097          	auipc	ra,0xfffff
    80001ca0:	1e0080e7          	jalr	480(ra) # 80000e7c <myproc>
    80001ca4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ca6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ca8:	14102773          	csrr	a4,sepc
    80001cac:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cae:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cb2:	47a1                	li	a5,8
    80001cb4:	04f71c63          	bne	a4,a5,80001d0c <usertrap+0x92>
    if(p->killed)
    80001cb8:	551c                	lw	a5,40(a0)
    80001cba:	e3b9                	bnez	a5,80001d00 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001cbc:	6cb8                	ld	a4,88(s1)
    80001cbe:	6f1c                	ld	a5,24(a4)
    80001cc0:	0791                	addi	a5,a5,4
    80001cc2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cc4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cc8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ccc:	10079073          	csrw	sstatus,a5
    syscall();
    80001cd0:	00000097          	auipc	ra,0x0
    80001cd4:	2e0080e7          	jalr	736(ra) # 80001fb0 <syscall>
  if(p->killed)
    80001cd8:	549c                	lw	a5,40(s1)
    80001cda:	ebc1                	bnez	a5,80001d6a <usertrap+0xf0>
  usertrapret();
    80001cdc:	00000097          	auipc	ra,0x0
    80001ce0:	e10080e7          	jalr	-496(ra) # 80001aec <usertrapret>
}
    80001ce4:	60e2                	ld	ra,24(sp)
    80001ce6:	6442                	ld	s0,16(sp)
    80001ce8:	64a2                	ld	s1,8(sp)
    80001cea:	6902                	ld	s2,0(sp)
    80001cec:	6105                	addi	sp,sp,32
    80001cee:	8082                	ret
    panic("usertrap: not from user mode");
    80001cf0:	00006517          	auipc	a0,0x6
    80001cf4:	57850513          	addi	a0,a0,1400 # 80008268 <etext+0x268>
    80001cf8:	00004097          	auipc	ra,0x4
    80001cfc:	f24080e7          	jalr	-220(ra) # 80005c1c <panic>
      exit(-1);
    80001d00:	557d                	li	a0,-1
    80001d02:	00000097          	auipc	ra,0x0
    80001d06:	a9c080e7          	jalr	-1380(ra) # 8000179e <exit>
    80001d0a:	bf4d                	j	80001cbc <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d0c:	00000097          	auipc	ra,0x0
    80001d10:	ec4080e7          	jalr	-316(ra) # 80001bd0 <devintr>
    80001d14:	892a                	mv	s2,a0
    80001d16:	c501                	beqz	a0,80001d1e <usertrap+0xa4>
  if(p->killed)
    80001d18:	549c                	lw	a5,40(s1)
    80001d1a:	c3a1                	beqz	a5,80001d5a <usertrap+0xe0>
    80001d1c:	a815                	j	80001d50 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d1e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d22:	5890                	lw	a2,48(s1)
    80001d24:	00006517          	auipc	a0,0x6
    80001d28:	56450513          	addi	a0,a0,1380 # 80008288 <etext+0x288>
    80001d2c:	00004097          	auipc	ra,0x4
    80001d30:	f3a080e7          	jalr	-198(ra) # 80005c66 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d34:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d38:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d3c:	00006517          	auipc	a0,0x6
    80001d40:	57c50513          	addi	a0,a0,1404 # 800082b8 <etext+0x2b8>
    80001d44:	00004097          	auipc	ra,0x4
    80001d48:	f22080e7          	jalr	-222(ra) # 80005c66 <printf>
    p->killed = 1;
    80001d4c:	4785                	li	a5,1
    80001d4e:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d50:	557d                	li	a0,-1
    80001d52:	00000097          	auipc	ra,0x0
    80001d56:	a4c080e7          	jalr	-1460(ra) # 8000179e <exit>
  if(which_dev == 2)
    80001d5a:	4789                	li	a5,2
    80001d5c:	f8f910e3          	bne	s2,a5,80001cdc <usertrap+0x62>
    yield();
    80001d60:	fffff097          	auipc	ra,0xfffff
    80001d64:	7a6080e7          	jalr	1958(ra) # 80001506 <yield>
    80001d68:	bf95                	j	80001cdc <usertrap+0x62>
  int which_dev = 0;
    80001d6a:	4901                	li	s2,0
    80001d6c:	b7d5                	j	80001d50 <usertrap+0xd6>

0000000080001d6e <kerneltrap>:
{
    80001d6e:	7179                	addi	sp,sp,-48
    80001d70:	f406                	sd	ra,40(sp)
    80001d72:	f022                	sd	s0,32(sp)
    80001d74:	ec26                	sd	s1,24(sp)
    80001d76:	e84a                	sd	s2,16(sp)
    80001d78:	e44e                	sd	s3,8(sp)
    80001d7a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d7c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d80:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d84:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d88:	1004f793          	andi	a5,s1,256
    80001d8c:	cb85                	beqz	a5,80001dbc <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d8e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d92:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d94:	ef85                	bnez	a5,80001dcc <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001d96:	00000097          	auipc	ra,0x0
    80001d9a:	e3a080e7          	jalr	-454(ra) # 80001bd0 <devintr>
    80001d9e:	cd1d                	beqz	a0,80001ddc <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001da0:	4789                	li	a5,2
    80001da2:	06f50a63          	beq	a0,a5,80001e16 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001da6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001daa:	10049073          	csrw	sstatus,s1
}
    80001dae:	70a2                	ld	ra,40(sp)
    80001db0:	7402                	ld	s0,32(sp)
    80001db2:	64e2                	ld	s1,24(sp)
    80001db4:	6942                	ld	s2,16(sp)
    80001db6:	69a2                	ld	s3,8(sp)
    80001db8:	6145                	addi	sp,sp,48
    80001dba:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001dbc:	00006517          	auipc	a0,0x6
    80001dc0:	51c50513          	addi	a0,a0,1308 # 800082d8 <etext+0x2d8>
    80001dc4:	00004097          	auipc	ra,0x4
    80001dc8:	e58080e7          	jalr	-424(ra) # 80005c1c <panic>
    panic("kerneltrap: interrupts enabled");
    80001dcc:	00006517          	auipc	a0,0x6
    80001dd0:	53450513          	addi	a0,a0,1332 # 80008300 <etext+0x300>
    80001dd4:	00004097          	auipc	ra,0x4
    80001dd8:	e48080e7          	jalr	-440(ra) # 80005c1c <panic>
    printf("scause %p\n", scause);
    80001ddc:	85ce                	mv	a1,s3
    80001dde:	00006517          	auipc	a0,0x6
    80001de2:	54250513          	addi	a0,a0,1346 # 80008320 <etext+0x320>
    80001de6:	00004097          	auipc	ra,0x4
    80001dea:	e80080e7          	jalr	-384(ra) # 80005c66 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dee:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001df2:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001df6:	00006517          	auipc	a0,0x6
    80001dfa:	53a50513          	addi	a0,a0,1338 # 80008330 <etext+0x330>
    80001dfe:	00004097          	auipc	ra,0x4
    80001e02:	e68080e7          	jalr	-408(ra) # 80005c66 <printf>
    panic("kerneltrap");
    80001e06:	00006517          	auipc	a0,0x6
    80001e0a:	54250513          	addi	a0,a0,1346 # 80008348 <etext+0x348>
    80001e0e:	00004097          	auipc	ra,0x4
    80001e12:	e0e080e7          	jalr	-498(ra) # 80005c1c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e16:	fffff097          	auipc	ra,0xfffff
    80001e1a:	066080e7          	jalr	102(ra) # 80000e7c <myproc>
    80001e1e:	d541                	beqz	a0,80001da6 <kerneltrap+0x38>
    80001e20:	fffff097          	auipc	ra,0xfffff
    80001e24:	05c080e7          	jalr	92(ra) # 80000e7c <myproc>
    80001e28:	4d18                	lw	a4,24(a0)
    80001e2a:	4791                	li	a5,4
    80001e2c:	f6f71de3          	bne	a4,a5,80001da6 <kerneltrap+0x38>
    yield();
    80001e30:	fffff097          	auipc	ra,0xfffff
    80001e34:	6d6080e7          	jalr	1750(ra) # 80001506 <yield>
    80001e38:	b7bd                	j	80001da6 <kerneltrap+0x38>

0000000080001e3a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e3a:	1101                	addi	sp,sp,-32
    80001e3c:	ec06                	sd	ra,24(sp)
    80001e3e:	e822                	sd	s0,16(sp)
    80001e40:	e426                	sd	s1,8(sp)
    80001e42:	1000                	addi	s0,sp,32
    80001e44:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e46:	fffff097          	auipc	ra,0xfffff
    80001e4a:	036080e7          	jalr	54(ra) # 80000e7c <myproc>
  switch (n) {
    80001e4e:	4795                	li	a5,5
    80001e50:	0497e163          	bltu	a5,s1,80001e92 <argraw+0x58>
    80001e54:	048a                	slli	s1,s1,0x2
    80001e56:	00007717          	auipc	a4,0x7
    80001e5a:	8da70713          	addi	a4,a4,-1830 # 80008730 <states.0+0x30>
    80001e5e:	94ba                	add	s1,s1,a4
    80001e60:	409c                	lw	a5,0(s1)
    80001e62:	97ba                	add	a5,a5,a4
    80001e64:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e66:	6d3c                	ld	a5,88(a0)
    80001e68:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e6a:	60e2                	ld	ra,24(sp)
    80001e6c:	6442                	ld	s0,16(sp)
    80001e6e:	64a2                	ld	s1,8(sp)
    80001e70:	6105                	addi	sp,sp,32
    80001e72:	8082                	ret
    return p->trapframe->a1;
    80001e74:	6d3c                	ld	a5,88(a0)
    80001e76:	7fa8                	ld	a0,120(a5)
    80001e78:	bfcd                	j	80001e6a <argraw+0x30>
    return p->trapframe->a2;
    80001e7a:	6d3c                	ld	a5,88(a0)
    80001e7c:	63c8                	ld	a0,128(a5)
    80001e7e:	b7f5                	j	80001e6a <argraw+0x30>
    return p->trapframe->a3;
    80001e80:	6d3c                	ld	a5,88(a0)
    80001e82:	67c8                	ld	a0,136(a5)
    80001e84:	b7dd                	j	80001e6a <argraw+0x30>
    return p->trapframe->a4;
    80001e86:	6d3c                	ld	a5,88(a0)
    80001e88:	6bc8                	ld	a0,144(a5)
    80001e8a:	b7c5                	j	80001e6a <argraw+0x30>
    return p->trapframe->a5;
    80001e8c:	6d3c                	ld	a5,88(a0)
    80001e8e:	6fc8                	ld	a0,152(a5)
    80001e90:	bfe9                	j	80001e6a <argraw+0x30>
  panic("argraw");
    80001e92:	00006517          	auipc	a0,0x6
    80001e96:	4c650513          	addi	a0,a0,1222 # 80008358 <etext+0x358>
    80001e9a:	00004097          	auipc	ra,0x4
    80001e9e:	d82080e7          	jalr	-638(ra) # 80005c1c <panic>

0000000080001ea2 <fetchaddr>:
{
    80001ea2:	1101                	addi	sp,sp,-32
    80001ea4:	ec06                	sd	ra,24(sp)
    80001ea6:	e822                	sd	s0,16(sp)
    80001ea8:	e426                	sd	s1,8(sp)
    80001eaa:	e04a                	sd	s2,0(sp)
    80001eac:	1000                	addi	s0,sp,32
    80001eae:	84aa                	mv	s1,a0
    80001eb0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001eb2:	fffff097          	auipc	ra,0xfffff
    80001eb6:	fca080e7          	jalr	-54(ra) # 80000e7c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001eba:	653c                	ld	a5,72(a0)
    80001ebc:	02f4f863          	bgeu	s1,a5,80001eec <fetchaddr+0x4a>
    80001ec0:	00848713          	addi	a4,s1,8
    80001ec4:	02e7e663          	bltu	a5,a4,80001ef0 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ec8:	46a1                	li	a3,8
    80001eca:	8626                	mv	a2,s1
    80001ecc:	85ca                	mv	a1,s2
    80001ece:	6928                	ld	a0,80(a0)
    80001ed0:	fffff097          	auipc	ra,0xfffff
    80001ed4:	cd4080e7          	jalr	-812(ra) # 80000ba4 <copyin>
    80001ed8:	00a03533          	snez	a0,a0
    80001edc:	40a00533          	neg	a0,a0
}
    80001ee0:	60e2                	ld	ra,24(sp)
    80001ee2:	6442                	ld	s0,16(sp)
    80001ee4:	64a2                	ld	s1,8(sp)
    80001ee6:	6902                	ld	s2,0(sp)
    80001ee8:	6105                	addi	sp,sp,32
    80001eea:	8082                	ret
    return -1;
    80001eec:	557d                	li	a0,-1
    80001eee:	bfcd                	j	80001ee0 <fetchaddr+0x3e>
    80001ef0:	557d                	li	a0,-1
    80001ef2:	b7fd                	j	80001ee0 <fetchaddr+0x3e>

0000000080001ef4 <fetchstr>:
{
    80001ef4:	7179                	addi	sp,sp,-48
    80001ef6:	f406                	sd	ra,40(sp)
    80001ef8:	f022                	sd	s0,32(sp)
    80001efa:	ec26                	sd	s1,24(sp)
    80001efc:	e84a                	sd	s2,16(sp)
    80001efe:	e44e                	sd	s3,8(sp)
    80001f00:	1800                	addi	s0,sp,48
    80001f02:	892a                	mv	s2,a0
    80001f04:	84ae                	mv	s1,a1
    80001f06:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f08:	fffff097          	auipc	ra,0xfffff
    80001f0c:	f74080e7          	jalr	-140(ra) # 80000e7c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f10:	86ce                	mv	a3,s3
    80001f12:	864a                	mv	a2,s2
    80001f14:	85a6                	mv	a1,s1
    80001f16:	6928                	ld	a0,80(a0)
    80001f18:	fffff097          	auipc	ra,0xfffff
    80001f1c:	d1a080e7          	jalr	-742(ra) # 80000c32 <copyinstr>
  if(err < 0)
    80001f20:	00054763          	bltz	a0,80001f2e <fetchstr+0x3a>
  return strlen(buf);
    80001f24:	8526                	mv	a0,s1
    80001f26:	ffffe097          	auipc	ra,0xffffe
    80001f2a:	3c8080e7          	jalr	968(ra) # 800002ee <strlen>
}
    80001f2e:	70a2                	ld	ra,40(sp)
    80001f30:	7402                	ld	s0,32(sp)
    80001f32:	64e2                	ld	s1,24(sp)
    80001f34:	6942                	ld	s2,16(sp)
    80001f36:	69a2                	ld	s3,8(sp)
    80001f38:	6145                	addi	sp,sp,48
    80001f3a:	8082                	ret

0000000080001f3c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f3c:	1101                	addi	sp,sp,-32
    80001f3e:	ec06                	sd	ra,24(sp)
    80001f40:	e822                	sd	s0,16(sp)
    80001f42:	e426                	sd	s1,8(sp)
    80001f44:	1000                	addi	s0,sp,32
    80001f46:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f48:	00000097          	auipc	ra,0x0
    80001f4c:	ef2080e7          	jalr	-270(ra) # 80001e3a <argraw>
    80001f50:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f52:	4501                	li	a0,0
    80001f54:	60e2                	ld	ra,24(sp)
    80001f56:	6442                	ld	s0,16(sp)
    80001f58:	64a2                	ld	s1,8(sp)
    80001f5a:	6105                	addi	sp,sp,32
    80001f5c:	8082                	ret

0000000080001f5e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f5e:	1101                	addi	sp,sp,-32
    80001f60:	ec06                	sd	ra,24(sp)
    80001f62:	e822                	sd	s0,16(sp)
    80001f64:	e426                	sd	s1,8(sp)
    80001f66:	1000                	addi	s0,sp,32
    80001f68:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f6a:	00000097          	auipc	ra,0x0
    80001f6e:	ed0080e7          	jalr	-304(ra) # 80001e3a <argraw>
    80001f72:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f74:	4501                	li	a0,0
    80001f76:	60e2                	ld	ra,24(sp)
    80001f78:	6442                	ld	s0,16(sp)
    80001f7a:	64a2                	ld	s1,8(sp)
    80001f7c:	6105                	addi	sp,sp,32
    80001f7e:	8082                	ret

0000000080001f80 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f80:	1101                	addi	sp,sp,-32
    80001f82:	ec06                	sd	ra,24(sp)
    80001f84:	e822                	sd	s0,16(sp)
    80001f86:	e426                	sd	s1,8(sp)
    80001f88:	e04a                	sd	s2,0(sp)
    80001f8a:	1000                	addi	s0,sp,32
    80001f8c:	84ae                	mv	s1,a1
    80001f8e:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001f90:	00000097          	auipc	ra,0x0
    80001f94:	eaa080e7          	jalr	-342(ra) # 80001e3a <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001f98:	864a                	mv	a2,s2
    80001f9a:	85a6                	mv	a1,s1
    80001f9c:	00000097          	auipc	ra,0x0
    80001fa0:	f58080e7          	jalr	-168(ra) # 80001ef4 <fetchstr>
}
    80001fa4:	60e2                	ld	ra,24(sp)
    80001fa6:	6442                	ld	s0,16(sp)
    80001fa8:	64a2                	ld	s1,8(sp)
    80001faa:	6902                	ld	s2,0(sp)
    80001fac:	6105                	addi	sp,sp,32
    80001fae:	8082                	ret

0000000080001fb0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001fb0:	1101                	addi	sp,sp,-32
    80001fb2:	ec06                	sd	ra,24(sp)
    80001fb4:	e822                	sd	s0,16(sp)
    80001fb6:	e426                	sd	s1,8(sp)
    80001fb8:	e04a                	sd	s2,0(sp)
    80001fba:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001fbc:	fffff097          	auipc	ra,0xfffff
    80001fc0:	ec0080e7          	jalr	-320(ra) # 80000e7c <myproc>
    80001fc4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001fc6:	05853903          	ld	s2,88(a0)
    80001fca:	0a893783          	ld	a5,168(s2)
    80001fce:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001fd2:	37fd                	addiw	a5,a5,-1
    80001fd4:	4751                	li	a4,20
    80001fd6:	00f76f63          	bltu	a4,a5,80001ff4 <syscall+0x44>
    80001fda:	00369713          	slli	a4,a3,0x3
    80001fde:	00006797          	auipc	a5,0x6
    80001fe2:	76a78793          	addi	a5,a5,1898 # 80008748 <syscalls>
    80001fe6:	97ba                	add	a5,a5,a4
    80001fe8:	639c                	ld	a5,0(a5)
    80001fea:	c789                	beqz	a5,80001ff4 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80001fec:	9782                	jalr	a5
    80001fee:	06a93823          	sd	a0,112(s2)
    80001ff2:	a839                	j	80002010 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001ff4:	15848613          	addi	a2,s1,344
    80001ff8:	588c                	lw	a1,48(s1)
    80001ffa:	00006517          	auipc	a0,0x6
    80001ffe:	36650513          	addi	a0,a0,870 # 80008360 <etext+0x360>
    80002002:	00004097          	auipc	ra,0x4
    80002006:	c64080e7          	jalr	-924(ra) # 80005c66 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000200a:	6cbc                	ld	a5,88(s1)
    8000200c:	577d                	li	a4,-1
    8000200e:	fbb8                	sd	a4,112(a5)
  }
}
    80002010:	60e2                	ld	ra,24(sp)
    80002012:	6442                	ld	s0,16(sp)
    80002014:	64a2                	ld	s1,8(sp)
    80002016:	6902                	ld	s2,0(sp)
    80002018:	6105                	addi	sp,sp,32
    8000201a:	8082                	ret

000000008000201c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000201c:	1101                	addi	sp,sp,-32
    8000201e:	ec06                	sd	ra,24(sp)
    80002020:	e822                	sd	s0,16(sp)
    80002022:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002024:	fec40593          	addi	a1,s0,-20
    80002028:	4501                	li	a0,0
    8000202a:	00000097          	auipc	ra,0x0
    8000202e:	f12080e7          	jalr	-238(ra) # 80001f3c <argint>
    return -1;
    80002032:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002034:	00054963          	bltz	a0,80002046 <sys_exit+0x2a>
  exit(n);
    80002038:	fec42503          	lw	a0,-20(s0)
    8000203c:	fffff097          	auipc	ra,0xfffff
    80002040:	762080e7          	jalr	1890(ra) # 8000179e <exit>
  return 0;  // not reached
    80002044:	4781                	li	a5,0
}
    80002046:	853e                	mv	a0,a5
    80002048:	60e2                	ld	ra,24(sp)
    8000204a:	6442                	ld	s0,16(sp)
    8000204c:	6105                	addi	sp,sp,32
    8000204e:	8082                	ret

0000000080002050 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002050:	1141                	addi	sp,sp,-16
    80002052:	e406                	sd	ra,8(sp)
    80002054:	e022                	sd	s0,0(sp)
    80002056:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002058:	fffff097          	auipc	ra,0xfffff
    8000205c:	e24080e7          	jalr	-476(ra) # 80000e7c <myproc>
}
    80002060:	5908                	lw	a0,48(a0)
    80002062:	60a2                	ld	ra,8(sp)
    80002064:	6402                	ld	s0,0(sp)
    80002066:	0141                	addi	sp,sp,16
    80002068:	8082                	ret

000000008000206a <sys_fork>:

uint64
sys_fork(void)
{
    8000206a:	1141                	addi	sp,sp,-16
    8000206c:	e406                	sd	ra,8(sp)
    8000206e:	e022                	sd	s0,0(sp)
    80002070:	0800                	addi	s0,sp,16
  return fork();
    80002072:	fffff097          	auipc	ra,0xfffff
    80002076:	1dc080e7          	jalr	476(ra) # 8000124e <fork>
}
    8000207a:	60a2                	ld	ra,8(sp)
    8000207c:	6402                	ld	s0,0(sp)
    8000207e:	0141                	addi	sp,sp,16
    80002080:	8082                	ret

0000000080002082 <sys_wait>:

uint64
sys_wait(void)
{
    80002082:	1101                	addi	sp,sp,-32
    80002084:	ec06                	sd	ra,24(sp)
    80002086:	e822                	sd	s0,16(sp)
    80002088:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000208a:	fe840593          	addi	a1,s0,-24
    8000208e:	4501                	li	a0,0
    80002090:	00000097          	auipc	ra,0x0
    80002094:	ece080e7          	jalr	-306(ra) # 80001f5e <argaddr>
    80002098:	87aa                	mv	a5,a0
    return -1;
    8000209a:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000209c:	0007c863          	bltz	a5,800020ac <sys_wait+0x2a>
  return wait(p);
    800020a0:	fe843503          	ld	a0,-24(s0)
    800020a4:	fffff097          	auipc	ra,0xfffff
    800020a8:	502080e7          	jalr	1282(ra) # 800015a6 <wait>
}
    800020ac:	60e2                	ld	ra,24(sp)
    800020ae:	6442                	ld	s0,16(sp)
    800020b0:	6105                	addi	sp,sp,32
    800020b2:	8082                	ret

00000000800020b4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020b4:	7179                	addi	sp,sp,-48
    800020b6:	f406                	sd	ra,40(sp)
    800020b8:	f022                	sd	s0,32(sp)
    800020ba:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800020bc:	fdc40593          	addi	a1,s0,-36
    800020c0:	4501                	li	a0,0
    800020c2:	00000097          	auipc	ra,0x0
    800020c6:	e7a080e7          	jalr	-390(ra) # 80001f3c <argint>
    800020ca:	87aa                	mv	a5,a0
    return -1;
    800020cc:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800020ce:	0207c263          	bltz	a5,800020f2 <sys_sbrk+0x3e>
    800020d2:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    800020d4:	fffff097          	auipc	ra,0xfffff
    800020d8:	da8080e7          	jalr	-600(ra) # 80000e7c <myproc>
    800020dc:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800020de:	fdc42503          	lw	a0,-36(s0)
    800020e2:	fffff097          	auipc	ra,0xfffff
    800020e6:	0f4080e7          	jalr	244(ra) # 800011d6 <growproc>
    800020ea:	00054863          	bltz	a0,800020fa <sys_sbrk+0x46>
    return -1;
  return addr;
    800020ee:	8526                	mv	a0,s1
    800020f0:	64e2                	ld	s1,24(sp)
}
    800020f2:	70a2                	ld	ra,40(sp)
    800020f4:	7402                	ld	s0,32(sp)
    800020f6:	6145                	addi	sp,sp,48
    800020f8:	8082                	ret
    return -1;
    800020fa:	557d                	li	a0,-1
    800020fc:	64e2                	ld	s1,24(sp)
    800020fe:	bfd5                	j	800020f2 <sys_sbrk+0x3e>

0000000080002100 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002100:	7139                	addi	sp,sp,-64
    80002102:	fc06                	sd	ra,56(sp)
    80002104:	f822                	sd	s0,48(sp)
    80002106:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002108:	fcc40593          	addi	a1,s0,-52
    8000210c:	4501                	li	a0,0
    8000210e:	00000097          	auipc	ra,0x0
    80002112:	e2e080e7          	jalr	-466(ra) # 80001f3c <argint>
    return -1;
    80002116:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002118:	06054b63          	bltz	a0,8000218e <sys_sleep+0x8e>
    8000211c:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    8000211e:	00010517          	auipc	a0,0x10
    80002122:	d6250513          	addi	a0,a0,-670 # 80011e80 <tickslock>
    80002126:	00004097          	auipc	ra,0x4
    8000212a:	070080e7          	jalr	112(ra) # 80006196 <acquire>
  ticks0 = ticks;
    8000212e:	0000a917          	auipc	s2,0xa
    80002132:	eea92903          	lw	s2,-278(s2) # 8000c018 <ticks>
  while(ticks - ticks0 < n){
    80002136:	fcc42783          	lw	a5,-52(s0)
    8000213a:	c3a1                	beqz	a5,8000217a <sys_sleep+0x7a>
    8000213c:	f426                	sd	s1,40(sp)
    8000213e:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002140:	00010997          	auipc	s3,0x10
    80002144:	d4098993          	addi	s3,s3,-704 # 80011e80 <tickslock>
    80002148:	0000a497          	auipc	s1,0xa
    8000214c:	ed048493          	addi	s1,s1,-304 # 8000c018 <ticks>
    if(myproc()->killed){
    80002150:	fffff097          	auipc	ra,0xfffff
    80002154:	d2c080e7          	jalr	-724(ra) # 80000e7c <myproc>
    80002158:	551c                	lw	a5,40(a0)
    8000215a:	ef9d                	bnez	a5,80002198 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000215c:	85ce                	mv	a1,s3
    8000215e:	8526                	mv	a0,s1
    80002160:	fffff097          	auipc	ra,0xfffff
    80002164:	3e2080e7          	jalr	994(ra) # 80001542 <sleep>
  while(ticks - ticks0 < n){
    80002168:	409c                	lw	a5,0(s1)
    8000216a:	412787bb          	subw	a5,a5,s2
    8000216e:	fcc42703          	lw	a4,-52(s0)
    80002172:	fce7efe3          	bltu	a5,a4,80002150 <sys_sleep+0x50>
    80002176:	74a2                	ld	s1,40(sp)
    80002178:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000217a:	00010517          	auipc	a0,0x10
    8000217e:	d0650513          	addi	a0,a0,-762 # 80011e80 <tickslock>
    80002182:	00004097          	auipc	ra,0x4
    80002186:	0c8080e7          	jalr	200(ra) # 8000624a <release>
  return 0;
    8000218a:	4781                	li	a5,0
    8000218c:	7902                	ld	s2,32(sp)
}
    8000218e:	853e                	mv	a0,a5
    80002190:	70e2                	ld	ra,56(sp)
    80002192:	7442                	ld	s0,48(sp)
    80002194:	6121                	addi	sp,sp,64
    80002196:	8082                	ret
      release(&tickslock);
    80002198:	00010517          	auipc	a0,0x10
    8000219c:	ce850513          	addi	a0,a0,-792 # 80011e80 <tickslock>
    800021a0:	00004097          	auipc	ra,0x4
    800021a4:	0aa080e7          	jalr	170(ra) # 8000624a <release>
      return -1;
    800021a8:	57fd                	li	a5,-1
    800021aa:	74a2                	ld	s1,40(sp)
    800021ac:	7902                	ld	s2,32(sp)
    800021ae:	69e2                	ld	s3,24(sp)
    800021b0:	bff9                	j	8000218e <sys_sleep+0x8e>

00000000800021b2 <sys_kill>:

uint64
sys_kill(void)
{
    800021b2:	1101                	addi	sp,sp,-32
    800021b4:	ec06                	sd	ra,24(sp)
    800021b6:	e822                	sd	s0,16(sp)
    800021b8:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800021ba:	fec40593          	addi	a1,s0,-20
    800021be:	4501                	li	a0,0
    800021c0:	00000097          	auipc	ra,0x0
    800021c4:	d7c080e7          	jalr	-644(ra) # 80001f3c <argint>
    800021c8:	87aa                	mv	a5,a0
    return -1;
    800021ca:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800021cc:	0007c863          	bltz	a5,800021dc <sys_kill+0x2a>
  return kill(pid);
    800021d0:	fec42503          	lw	a0,-20(s0)
    800021d4:	fffff097          	auipc	ra,0xfffff
    800021d8:	6a0080e7          	jalr	1696(ra) # 80001874 <kill>
}
    800021dc:	60e2                	ld	ra,24(sp)
    800021de:	6442                	ld	s0,16(sp)
    800021e0:	6105                	addi	sp,sp,32
    800021e2:	8082                	ret

00000000800021e4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021e4:	1101                	addi	sp,sp,-32
    800021e6:	ec06                	sd	ra,24(sp)
    800021e8:	e822                	sd	s0,16(sp)
    800021ea:	e426                	sd	s1,8(sp)
    800021ec:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021ee:	00010517          	auipc	a0,0x10
    800021f2:	c9250513          	addi	a0,a0,-878 # 80011e80 <tickslock>
    800021f6:	00004097          	auipc	ra,0x4
    800021fa:	fa0080e7          	jalr	-96(ra) # 80006196 <acquire>
  xticks = ticks;
    800021fe:	0000a497          	auipc	s1,0xa
    80002202:	e1a4a483          	lw	s1,-486(s1) # 8000c018 <ticks>
  release(&tickslock);
    80002206:	00010517          	auipc	a0,0x10
    8000220a:	c7a50513          	addi	a0,a0,-902 # 80011e80 <tickslock>
    8000220e:	00004097          	auipc	ra,0x4
    80002212:	03c080e7          	jalr	60(ra) # 8000624a <release>
  return xticks;
}
    80002216:	02049513          	slli	a0,s1,0x20
    8000221a:	9101                	srli	a0,a0,0x20
    8000221c:	60e2                	ld	ra,24(sp)
    8000221e:	6442                	ld	s0,16(sp)
    80002220:	64a2                	ld	s1,8(sp)
    80002222:	6105                	addi	sp,sp,32
    80002224:	8082                	ret

0000000080002226 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002226:	7179                	addi	sp,sp,-48
    80002228:	f406                	sd	ra,40(sp)
    8000222a:	f022                	sd	s0,32(sp)
    8000222c:	ec26                	sd	s1,24(sp)
    8000222e:	e84a                	sd	s2,16(sp)
    80002230:	e44e                	sd	s3,8(sp)
    80002232:	e052                	sd	s4,0(sp)
    80002234:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002236:	00006597          	auipc	a1,0x6
    8000223a:	14a58593          	addi	a1,a1,330 # 80008380 <etext+0x380>
    8000223e:	00010517          	auipc	a0,0x10
    80002242:	c5a50513          	addi	a0,a0,-934 # 80011e98 <bcache>
    80002246:	00004097          	auipc	ra,0x4
    8000224a:	ec0080e7          	jalr	-320(ra) # 80006106 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000224e:	00018797          	auipc	a5,0x18
    80002252:	c4a78793          	addi	a5,a5,-950 # 80019e98 <bcache+0x8000>
    80002256:	00018717          	auipc	a4,0x18
    8000225a:	eaa70713          	addi	a4,a4,-342 # 8001a100 <bcache+0x8268>
    8000225e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002262:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002266:	00010497          	auipc	s1,0x10
    8000226a:	c4a48493          	addi	s1,s1,-950 # 80011eb0 <bcache+0x18>
    b->next = bcache.head.next;
    8000226e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002270:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002272:	00006a17          	auipc	s4,0x6
    80002276:	116a0a13          	addi	s4,s4,278 # 80008388 <etext+0x388>
    b->next = bcache.head.next;
    8000227a:	2b893783          	ld	a5,696(s2)
    8000227e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002280:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002284:	85d2                	mv	a1,s4
    80002286:	01048513          	addi	a0,s1,16
    8000228a:	00001097          	auipc	ra,0x1
    8000228e:	4b2080e7          	jalr	1202(ra) # 8000373c <initsleeplock>
    bcache.head.next->prev = b;
    80002292:	2b893783          	ld	a5,696(s2)
    80002296:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002298:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000229c:	45848493          	addi	s1,s1,1112
    800022a0:	fd349de3          	bne	s1,s3,8000227a <binit+0x54>
  }
}
    800022a4:	70a2                	ld	ra,40(sp)
    800022a6:	7402                	ld	s0,32(sp)
    800022a8:	64e2                	ld	s1,24(sp)
    800022aa:	6942                	ld	s2,16(sp)
    800022ac:	69a2                	ld	s3,8(sp)
    800022ae:	6a02                	ld	s4,0(sp)
    800022b0:	6145                	addi	sp,sp,48
    800022b2:	8082                	ret

00000000800022b4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800022b4:	7179                	addi	sp,sp,-48
    800022b6:	f406                	sd	ra,40(sp)
    800022b8:	f022                	sd	s0,32(sp)
    800022ba:	ec26                	sd	s1,24(sp)
    800022bc:	e84a                	sd	s2,16(sp)
    800022be:	e44e                	sd	s3,8(sp)
    800022c0:	1800                	addi	s0,sp,48
    800022c2:	892a                	mv	s2,a0
    800022c4:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800022c6:	00010517          	auipc	a0,0x10
    800022ca:	bd250513          	addi	a0,a0,-1070 # 80011e98 <bcache>
    800022ce:	00004097          	auipc	ra,0x4
    800022d2:	ec8080e7          	jalr	-312(ra) # 80006196 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800022d6:	00018497          	auipc	s1,0x18
    800022da:	e7a4b483          	ld	s1,-390(s1) # 8001a150 <bcache+0x82b8>
    800022de:	00018797          	auipc	a5,0x18
    800022e2:	e2278793          	addi	a5,a5,-478 # 8001a100 <bcache+0x8268>
    800022e6:	02f48f63          	beq	s1,a5,80002324 <bread+0x70>
    800022ea:	873e                	mv	a4,a5
    800022ec:	a021                	j	800022f4 <bread+0x40>
    800022ee:	68a4                	ld	s1,80(s1)
    800022f0:	02e48a63          	beq	s1,a4,80002324 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800022f4:	449c                	lw	a5,8(s1)
    800022f6:	ff279ce3          	bne	a5,s2,800022ee <bread+0x3a>
    800022fa:	44dc                	lw	a5,12(s1)
    800022fc:	ff3799e3          	bne	a5,s3,800022ee <bread+0x3a>
      b->refcnt++;
    80002300:	40bc                	lw	a5,64(s1)
    80002302:	2785                	addiw	a5,a5,1
    80002304:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002306:	00010517          	auipc	a0,0x10
    8000230a:	b9250513          	addi	a0,a0,-1134 # 80011e98 <bcache>
    8000230e:	00004097          	auipc	ra,0x4
    80002312:	f3c080e7          	jalr	-196(ra) # 8000624a <release>
      acquiresleep(&b->lock);
    80002316:	01048513          	addi	a0,s1,16
    8000231a:	00001097          	auipc	ra,0x1
    8000231e:	45c080e7          	jalr	1116(ra) # 80003776 <acquiresleep>
      return b;
    80002322:	a8b9                	j	80002380 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002324:	00018497          	auipc	s1,0x18
    80002328:	e244b483          	ld	s1,-476(s1) # 8001a148 <bcache+0x82b0>
    8000232c:	00018797          	auipc	a5,0x18
    80002330:	dd478793          	addi	a5,a5,-556 # 8001a100 <bcache+0x8268>
    80002334:	00f48863          	beq	s1,a5,80002344 <bread+0x90>
    80002338:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000233a:	40bc                	lw	a5,64(s1)
    8000233c:	cf81                	beqz	a5,80002354 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000233e:	64a4                	ld	s1,72(s1)
    80002340:	fee49de3          	bne	s1,a4,8000233a <bread+0x86>
  panic("bget: no buffers");
    80002344:	00006517          	auipc	a0,0x6
    80002348:	04c50513          	addi	a0,a0,76 # 80008390 <etext+0x390>
    8000234c:	00004097          	auipc	ra,0x4
    80002350:	8d0080e7          	jalr	-1840(ra) # 80005c1c <panic>
      b->dev = dev;
    80002354:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002358:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000235c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002360:	4785                	li	a5,1
    80002362:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002364:	00010517          	auipc	a0,0x10
    80002368:	b3450513          	addi	a0,a0,-1228 # 80011e98 <bcache>
    8000236c:	00004097          	auipc	ra,0x4
    80002370:	ede080e7          	jalr	-290(ra) # 8000624a <release>
      acquiresleep(&b->lock);
    80002374:	01048513          	addi	a0,s1,16
    80002378:	00001097          	auipc	ra,0x1
    8000237c:	3fe080e7          	jalr	1022(ra) # 80003776 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002380:	409c                	lw	a5,0(s1)
    80002382:	cb89                	beqz	a5,80002394 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002384:	8526                	mv	a0,s1
    80002386:	70a2                	ld	ra,40(sp)
    80002388:	7402                	ld	s0,32(sp)
    8000238a:	64e2                	ld	s1,24(sp)
    8000238c:	6942                	ld	s2,16(sp)
    8000238e:	69a2                	ld	s3,8(sp)
    80002390:	6145                	addi	sp,sp,48
    80002392:	8082                	ret
    virtio_disk_rw(b, 0);
    80002394:	4581                	li	a1,0
    80002396:	8526                	mv	a0,s1
    80002398:	00003097          	auipc	ra,0x3
    8000239c:	fea080e7          	jalr	-22(ra) # 80005382 <virtio_disk_rw>
    b->valid = 1;
    800023a0:	4785                	li	a5,1
    800023a2:	c09c                	sw	a5,0(s1)
  return b;
    800023a4:	b7c5                	j	80002384 <bread+0xd0>

00000000800023a6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800023a6:	1101                	addi	sp,sp,-32
    800023a8:	ec06                	sd	ra,24(sp)
    800023aa:	e822                	sd	s0,16(sp)
    800023ac:	e426                	sd	s1,8(sp)
    800023ae:	1000                	addi	s0,sp,32
    800023b0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023b2:	0541                	addi	a0,a0,16
    800023b4:	00001097          	auipc	ra,0x1
    800023b8:	45c080e7          	jalr	1116(ra) # 80003810 <holdingsleep>
    800023bc:	cd01                	beqz	a0,800023d4 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800023be:	4585                	li	a1,1
    800023c0:	8526                	mv	a0,s1
    800023c2:	00003097          	auipc	ra,0x3
    800023c6:	fc0080e7          	jalr	-64(ra) # 80005382 <virtio_disk_rw>
}
    800023ca:	60e2                	ld	ra,24(sp)
    800023cc:	6442                	ld	s0,16(sp)
    800023ce:	64a2                	ld	s1,8(sp)
    800023d0:	6105                	addi	sp,sp,32
    800023d2:	8082                	ret
    panic("bwrite");
    800023d4:	00006517          	auipc	a0,0x6
    800023d8:	fd450513          	addi	a0,a0,-44 # 800083a8 <etext+0x3a8>
    800023dc:	00004097          	auipc	ra,0x4
    800023e0:	840080e7          	jalr	-1984(ra) # 80005c1c <panic>

00000000800023e4 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800023e4:	1101                	addi	sp,sp,-32
    800023e6:	ec06                	sd	ra,24(sp)
    800023e8:	e822                	sd	s0,16(sp)
    800023ea:	e426                	sd	s1,8(sp)
    800023ec:	e04a                	sd	s2,0(sp)
    800023ee:	1000                	addi	s0,sp,32
    800023f0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023f2:	01050913          	addi	s2,a0,16
    800023f6:	854a                	mv	a0,s2
    800023f8:	00001097          	auipc	ra,0x1
    800023fc:	418080e7          	jalr	1048(ra) # 80003810 <holdingsleep>
    80002400:	c925                	beqz	a0,80002470 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002402:	854a                	mv	a0,s2
    80002404:	00001097          	auipc	ra,0x1
    80002408:	3c8080e7          	jalr	968(ra) # 800037cc <releasesleep>

  acquire(&bcache.lock);
    8000240c:	00010517          	auipc	a0,0x10
    80002410:	a8c50513          	addi	a0,a0,-1396 # 80011e98 <bcache>
    80002414:	00004097          	auipc	ra,0x4
    80002418:	d82080e7          	jalr	-638(ra) # 80006196 <acquire>
  b->refcnt--;
    8000241c:	40bc                	lw	a5,64(s1)
    8000241e:	37fd                	addiw	a5,a5,-1
    80002420:	0007871b          	sext.w	a4,a5
    80002424:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002426:	e71d                	bnez	a4,80002454 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002428:	68b8                	ld	a4,80(s1)
    8000242a:	64bc                	ld	a5,72(s1)
    8000242c:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000242e:	68b8                	ld	a4,80(s1)
    80002430:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002432:	00018797          	auipc	a5,0x18
    80002436:	a6678793          	addi	a5,a5,-1434 # 80019e98 <bcache+0x8000>
    8000243a:	2b87b703          	ld	a4,696(a5)
    8000243e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002440:	00018717          	auipc	a4,0x18
    80002444:	cc070713          	addi	a4,a4,-832 # 8001a100 <bcache+0x8268>
    80002448:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000244a:	2b87b703          	ld	a4,696(a5)
    8000244e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002450:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002454:	00010517          	auipc	a0,0x10
    80002458:	a4450513          	addi	a0,a0,-1468 # 80011e98 <bcache>
    8000245c:	00004097          	auipc	ra,0x4
    80002460:	dee080e7          	jalr	-530(ra) # 8000624a <release>
}
    80002464:	60e2                	ld	ra,24(sp)
    80002466:	6442                	ld	s0,16(sp)
    80002468:	64a2                	ld	s1,8(sp)
    8000246a:	6902                	ld	s2,0(sp)
    8000246c:	6105                	addi	sp,sp,32
    8000246e:	8082                	ret
    panic("brelse");
    80002470:	00006517          	auipc	a0,0x6
    80002474:	f4050513          	addi	a0,a0,-192 # 800083b0 <etext+0x3b0>
    80002478:	00003097          	auipc	ra,0x3
    8000247c:	7a4080e7          	jalr	1956(ra) # 80005c1c <panic>

0000000080002480 <bpin>:

void
bpin(struct buf *b) {
    80002480:	1101                	addi	sp,sp,-32
    80002482:	ec06                	sd	ra,24(sp)
    80002484:	e822                	sd	s0,16(sp)
    80002486:	e426                	sd	s1,8(sp)
    80002488:	1000                	addi	s0,sp,32
    8000248a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000248c:	00010517          	auipc	a0,0x10
    80002490:	a0c50513          	addi	a0,a0,-1524 # 80011e98 <bcache>
    80002494:	00004097          	auipc	ra,0x4
    80002498:	d02080e7          	jalr	-766(ra) # 80006196 <acquire>
  b->refcnt++;
    8000249c:	40bc                	lw	a5,64(s1)
    8000249e:	2785                	addiw	a5,a5,1
    800024a0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024a2:	00010517          	auipc	a0,0x10
    800024a6:	9f650513          	addi	a0,a0,-1546 # 80011e98 <bcache>
    800024aa:	00004097          	auipc	ra,0x4
    800024ae:	da0080e7          	jalr	-608(ra) # 8000624a <release>
}
    800024b2:	60e2                	ld	ra,24(sp)
    800024b4:	6442                	ld	s0,16(sp)
    800024b6:	64a2                	ld	s1,8(sp)
    800024b8:	6105                	addi	sp,sp,32
    800024ba:	8082                	ret

00000000800024bc <bunpin>:

void
bunpin(struct buf *b) {
    800024bc:	1101                	addi	sp,sp,-32
    800024be:	ec06                	sd	ra,24(sp)
    800024c0:	e822                	sd	s0,16(sp)
    800024c2:	e426                	sd	s1,8(sp)
    800024c4:	1000                	addi	s0,sp,32
    800024c6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024c8:	00010517          	auipc	a0,0x10
    800024cc:	9d050513          	addi	a0,a0,-1584 # 80011e98 <bcache>
    800024d0:	00004097          	auipc	ra,0x4
    800024d4:	cc6080e7          	jalr	-826(ra) # 80006196 <acquire>
  b->refcnt--;
    800024d8:	40bc                	lw	a5,64(s1)
    800024da:	37fd                	addiw	a5,a5,-1
    800024dc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800024de:	00010517          	auipc	a0,0x10
    800024e2:	9ba50513          	addi	a0,a0,-1606 # 80011e98 <bcache>
    800024e6:	00004097          	auipc	ra,0x4
    800024ea:	d64080e7          	jalr	-668(ra) # 8000624a <release>
}
    800024ee:	60e2                	ld	ra,24(sp)
    800024f0:	6442                	ld	s0,16(sp)
    800024f2:	64a2                	ld	s1,8(sp)
    800024f4:	6105                	addi	sp,sp,32
    800024f6:	8082                	ret

00000000800024f8 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800024f8:	1101                	addi	sp,sp,-32
    800024fa:	ec06                	sd	ra,24(sp)
    800024fc:	e822                	sd	s0,16(sp)
    800024fe:	e426                	sd	s1,8(sp)
    80002500:	e04a                	sd	s2,0(sp)
    80002502:	1000                	addi	s0,sp,32
    80002504:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002506:	00d5d59b          	srliw	a1,a1,0xd
    8000250a:	00018797          	auipc	a5,0x18
    8000250e:	06a7a783          	lw	a5,106(a5) # 8001a574 <sb+0x1c>
    80002512:	9dbd                	addw	a1,a1,a5
    80002514:	00000097          	auipc	ra,0x0
    80002518:	da0080e7          	jalr	-608(ra) # 800022b4 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000251c:	0074f713          	andi	a4,s1,7
    80002520:	4785                	li	a5,1
    80002522:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002526:	14ce                	slli	s1,s1,0x33
    80002528:	90d9                	srli	s1,s1,0x36
    8000252a:	00950733          	add	a4,a0,s1
    8000252e:	05874703          	lbu	a4,88(a4)
    80002532:	00e7f6b3          	and	a3,a5,a4
    80002536:	c69d                	beqz	a3,80002564 <bfree+0x6c>
    80002538:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000253a:	94aa                	add	s1,s1,a0
    8000253c:	fff7c793          	not	a5,a5
    80002540:	8f7d                	and	a4,a4,a5
    80002542:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002546:	00001097          	auipc	ra,0x1
    8000254a:	112080e7          	jalr	274(ra) # 80003658 <log_write>
  brelse(bp);
    8000254e:	854a                	mv	a0,s2
    80002550:	00000097          	auipc	ra,0x0
    80002554:	e94080e7          	jalr	-364(ra) # 800023e4 <brelse>
}
    80002558:	60e2                	ld	ra,24(sp)
    8000255a:	6442                	ld	s0,16(sp)
    8000255c:	64a2                	ld	s1,8(sp)
    8000255e:	6902                	ld	s2,0(sp)
    80002560:	6105                	addi	sp,sp,32
    80002562:	8082                	ret
    panic("freeing free block");
    80002564:	00006517          	auipc	a0,0x6
    80002568:	e5450513          	addi	a0,a0,-428 # 800083b8 <etext+0x3b8>
    8000256c:	00003097          	auipc	ra,0x3
    80002570:	6b0080e7          	jalr	1712(ra) # 80005c1c <panic>

0000000080002574 <balloc>:
{
    80002574:	711d                	addi	sp,sp,-96
    80002576:	ec86                	sd	ra,88(sp)
    80002578:	e8a2                	sd	s0,80(sp)
    8000257a:	e4a6                	sd	s1,72(sp)
    8000257c:	e0ca                	sd	s2,64(sp)
    8000257e:	fc4e                	sd	s3,56(sp)
    80002580:	f852                	sd	s4,48(sp)
    80002582:	f456                	sd	s5,40(sp)
    80002584:	f05a                	sd	s6,32(sp)
    80002586:	ec5e                	sd	s7,24(sp)
    80002588:	e862                	sd	s8,16(sp)
    8000258a:	e466                	sd	s9,8(sp)
    8000258c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000258e:	00018797          	auipc	a5,0x18
    80002592:	fce7a783          	lw	a5,-50(a5) # 8001a55c <sb+0x4>
    80002596:	cbc1                	beqz	a5,80002626 <balloc+0xb2>
    80002598:	8baa                	mv	s7,a0
    8000259a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000259c:	00018b17          	auipc	s6,0x18
    800025a0:	fbcb0b13          	addi	s6,s6,-68 # 8001a558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025a4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800025a6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025a8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800025aa:	6c89                	lui	s9,0x2
    800025ac:	a831                	j	800025c8 <balloc+0x54>
    brelse(bp);
    800025ae:	854a                	mv	a0,s2
    800025b0:	00000097          	auipc	ra,0x0
    800025b4:	e34080e7          	jalr	-460(ra) # 800023e4 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800025b8:	015c87bb          	addw	a5,s9,s5
    800025bc:	00078a9b          	sext.w	s5,a5
    800025c0:	004b2703          	lw	a4,4(s6)
    800025c4:	06eaf163          	bgeu	s5,a4,80002626 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800025c8:	41fad79b          	sraiw	a5,s5,0x1f
    800025cc:	0137d79b          	srliw	a5,a5,0x13
    800025d0:	015787bb          	addw	a5,a5,s5
    800025d4:	40d7d79b          	sraiw	a5,a5,0xd
    800025d8:	01cb2583          	lw	a1,28(s6)
    800025dc:	9dbd                	addw	a1,a1,a5
    800025de:	855e                	mv	a0,s7
    800025e0:	00000097          	auipc	ra,0x0
    800025e4:	cd4080e7          	jalr	-812(ra) # 800022b4 <bread>
    800025e8:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025ea:	004b2503          	lw	a0,4(s6)
    800025ee:	000a849b          	sext.w	s1,s5
    800025f2:	8762                	mv	a4,s8
    800025f4:	faa4fde3          	bgeu	s1,a0,800025ae <balloc+0x3a>
      m = 1 << (bi % 8);
    800025f8:	00777693          	andi	a3,a4,7
    800025fc:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002600:	41f7579b          	sraiw	a5,a4,0x1f
    80002604:	01d7d79b          	srliw	a5,a5,0x1d
    80002608:	9fb9                	addw	a5,a5,a4
    8000260a:	4037d79b          	sraiw	a5,a5,0x3
    8000260e:	00f90633          	add	a2,s2,a5
    80002612:	05864603          	lbu	a2,88(a2)
    80002616:	00c6f5b3          	and	a1,a3,a2
    8000261a:	cd91                	beqz	a1,80002636 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000261c:	2705                	addiw	a4,a4,1
    8000261e:	2485                	addiw	s1,s1,1
    80002620:	fd471ae3          	bne	a4,s4,800025f4 <balloc+0x80>
    80002624:	b769                	j	800025ae <balloc+0x3a>
  panic("balloc: out of blocks");
    80002626:	00006517          	auipc	a0,0x6
    8000262a:	daa50513          	addi	a0,a0,-598 # 800083d0 <etext+0x3d0>
    8000262e:	00003097          	auipc	ra,0x3
    80002632:	5ee080e7          	jalr	1518(ra) # 80005c1c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002636:	97ca                	add	a5,a5,s2
    80002638:	8e55                	or	a2,a2,a3
    8000263a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000263e:	854a                	mv	a0,s2
    80002640:	00001097          	auipc	ra,0x1
    80002644:	018080e7          	jalr	24(ra) # 80003658 <log_write>
        brelse(bp);
    80002648:	854a                	mv	a0,s2
    8000264a:	00000097          	auipc	ra,0x0
    8000264e:	d9a080e7          	jalr	-614(ra) # 800023e4 <brelse>
  bp = bread(dev, bno);
    80002652:	85a6                	mv	a1,s1
    80002654:	855e                	mv	a0,s7
    80002656:	00000097          	auipc	ra,0x0
    8000265a:	c5e080e7          	jalr	-930(ra) # 800022b4 <bread>
    8000265e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002660:	40000613          	li	a2,1024
    80002664:	4581                	li	a1,0
    80002666:	05850513          	addi	a0,a0,88
    8000266a:	ffffe097          	auipc	ra,0xffffe
    8000266e:	b10080e7          	jalr	-1264(ra) # 8000017a <memset>
  log_write(bp);
    80002672:	854a                	mv	a0,s2
    80002674:	00001097          	auipc	ra,0x1
    80002678:	fe4080e7          	jalr	-28(ra) # 80003658 <log_write>
  brelse(bp);
    8000267c:	854a                	mv	a0,s2
    8000267e:	00000097          	auipc	ra,0x0
    80002682:	d66080e7          	jalr	-666(ra) # 800023e4 <brelse>
}
    80002686:	8526                	mv	a0,s1
    80002688:	60e6                	ld	ra,88(sp)
    8000268a:	6446                	ld	s0,80(sp)
    8000268c:	64a6                	ld	s1,72(sp)
    8000268e:	6906                	ld	s2,64(sp)
    80002690:	79e2                	ld	s3,56(sp)
    80002692:	7a42                	ld	s4,48(sp)
    80002694:	7aa2                	ld	s5,40(sp)
    80002696:	7b02                	ld	s6,32(sp)
    80002698:	6be2                	ld	s7,24(sp)
    8000269a:	6c42                	ld	s8,16(sp)
    8000269c:	6ca2                	ld	s9,8(sp)
    8000269e:	6125                	addi	sp,sp,96
    800026a0:	8082                	ret

00000000800026a2 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800026a2:	7179                	addi	sp,sp,-48
    800026a4:	f406                	sd	ra,40(sp)
    800026a6:	f022                	sd	s0,32(sp)
    800026a8:	ec26                	sd	s1,24(sp)
    800026aa:	e84a                	sd	s2,16(sp)
    800026ac:	e44e                	sd	s3,8(sp)
    800026ae:	1800                	addi	s0,sp,48
    800026b0:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800026b2:	47ad                	li	a5,11
    800026b4:	04b7ff63          	bgeu	a5,a1,80002712 <bmap+0x70>
    800026b8:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800026ba:	ff45849b          	addiw	s1,a1,-12
    800026be:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800026c2:	0ff00793          	li	a5,255
    800026c6:	0ae7e463          	bltu	a5,a4,8000276e <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800026ca:	08052583          	lw	a1,128(a0)
    800026ce:	c5b5                	beqz	a1,8000273a <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800026d0:	00092503          	lw	a0,0(s2)
    800026d4:	00000097          	auipc	ra,0x0
    800026d8:	be0080e7          	jalr	-1056(ra) # 800022b4 <bread>
    800026dc:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800026de:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800026e2:	02049713          	slli	a4,s1,0x20
    800026e6:	01e75593          	srli	a1,a4,0x1e
    800026ea:	00b784b3          	add	s1,a5,a1
    800026ee:	0004a983          	lw	s3,0(s1)
    800026f2:	04098e63          	beqz	s3,8000274e <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800026f6:	8552                	mv	a0,s4
    800026f8:	00000097          	auipc	ra,0x0
    800026fc:	cec080e7          	jalr	-788(ra) # 800023e4 <brelse>
    return addr;
    80002700:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002702:	854e                	mv	a0,s3
    80002704:	70a2                	ld	ra,40(sp)
    80002706:	7402                	ld	s0,32(sp)
    80002708:	64e2                	ld	s1,24(sp)
    8000270a:	6942                	ld	s2,16(sp)
    8000270c:	69a2                	ld	s3,8(sp)
    8000270e:	6145                	addi	sp,sp,48
    80002710:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002712:	02059793          	slli	a5,a1,0x20
    80002716:	01e7d593          	srli	a1,a5,0x1e
    8000271a:	00b504b3          	add	s1,a0,a1
    8000271e:	0504a983          	lw	s3,80(s1)
    80002722:	fe0990e3          	bnez	s3,80002702 <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002726:	4108                	lw	a0,0(a0)
    80002728:	00000097          	auipc	ra,0x0
    8000272c:	e4c080e7          	jalr	-436(ra) # 80002574 <balloc>
    80002730:	0005099b          	sext.w	s3,a0
    80002734:	0534a823          	sw	s3,80(s1)
    80002738:	b7e9                	j	80002702 <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000273a:	4108                	lw	a0,0(a0)
    8000273c:	00000097          	auipc	ra,0x0
    80002740:	e38080e7          	jalr	-456(ra) # 80002574 <balloc>
    80002744:	0005059b          	sext.w	a1,a0
    80002748:	08b92023          	sw	a1,128(s2)
    8000274c:	b751                	j	800026d0 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000274e:	00092503          	lw	a0,0(s2)
    80002752:	00000097          	auipc	ra,0x0
    80002756:	e22080e7          	jalr	-478(ra) # 80002574 <balloc>
    8000275a:	0005099b          	sext.w	s3,a0
    8000275e:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002762:	8552                	mv	a0,s4
    80002764:	00001097          	auipc	ra,0x1
    80002768:	ef4080e7          	jalr	-268(ra) # 80003658 <log_write>
    8000276c:	b769                	j	800026f6 <bmap+0x54>
  panic("bmap: out of range");
    8000276e:	00006517          	auipc	a0,0x6
    80002772:	c7a50513          	addi	a0,a0,-902 # 800083e8 <etext+0x3e8>
    80002776:	00003097          	auipc	ra,0x3
    8000277a:	4a6080e7          	jalr	1190(ra) # 80005c1c <panic>

000000008000277e <iget>:
{
    8000277e:	7179                	addi	sp,sp,-48
    80002780:	f406                	sd	ra,40(sp)
    80002782:	f022                	sd	s0,32(sp)
    80002784:	ec26                	sd	s1,24(sp)
    80002786:	e84a                	sd	s2,16(sp)
    80002788:	e44e                	sd	s3,8(sp)
    8000278a:	e052                	sd	s4,0(sp)
    8000278c:	1800                	addi	s0,sp,48
    8000278e:	89aa                	mv	s3,a0
    80002790:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002792:	00018517          	auipc	a0,0x18
    80002796:	de650513          	addi	a0,a0,-538 # 8001a578 <itable>
    8000279a:	00004097          	auipc	ra,0x4
    8000279e:	9fc080e7          	jalr	-1540(ra) # 80006196 <acquire>
  empty = 0;
    800027a2:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027a4:	00018497          	auipc	s1,0x18
    800027a8:	dec48493          	addi	s1,s1,-532 # 8001a590 <itable+0x18>
    800027ac:	0001a697          	auipc	a3,0x1a
    800027b0:	87468693          	addi	a3,a3,-1932 # 8001c020 <log>
    800027b4:	a039                	j	800027c2 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027b6:	02090b63          	beqz	s2,800027ec <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800027ba:	08848493          	addi	s1,s1,136
    800027be:	02d48a63          	beq	s1,a3,800027f2 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800027c2:	449c                	lw	a5,8(s1)
    800027c4:	fef059e3          	blez	a5,800027b6 <iget+0x38>
    800027c8:	4098                	lw	a4,0(s1)
    800027ca:	ff3716e3          	bne	a4,s3,800027b6 <iget+0x38>
    800027ce:	40d8                	lw	a4,4(s1)
    800027d0:	ff4713e3          	bne	a4,s4,800027b6 <iget+0x38>
      ip->ref++;
    800027d4:	2785                	addiw	a5,a5,1
    800027d6:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800027d8:	00018517          	auipc	a0,0x18
    800027dc:	da050513          	addi	a0,a0,-608 # 8001a578 <itable>
    800027e0:	00004097          	auipc	ra,0x4
    800027e4:	a6a080e7          	jalr	-1430(ra) # 8000624a <release>
      return ip;
    800027e8:	8926                	mv	s2,s1
    800027ea:	a03d                	j	80002818 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800027ec:	f7f9                	bnez	a5,800027ba <iget+0x3c>
      empty = ip;
    800027ee:	8926                	mv	s2,s1
    800027f0:	b7e9                	j	800027ba <iget+0x3c>
  if(empty == 0)
    800027f2:	02090c63          	beqz	s2,8000282a <iget+0xac>
  ip->dev = dev;
    800027f6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800027fa:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800027fe:	4785                	li	a5,1
    80002800:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002804:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002808:	00018517          	auipc	a0,0x18
    8000280c:	d7050513          	addi	a0,a0,-656 # 8001a578 <itable>
    80002810:	00004097          	auipc	ra,0x4
    80002814:	a3a080e7          	jalr	-1478(ra) # 8000624a <release>
}
    80002818:	854a                	mv	a0,s2
    8000281a:	70a2                	ld	ra,40(sp)
    8000281c:	7402                	ld	s0,32(sp)
    8000281e:	64e2                	ld	s1,24(sp)
    80002820:	6942                	ld	s2,16(sp)
    80002822:	69a2                	ld	s3,8(sp)
    80002824:	6a02                	ld	s4,0(sp)
    80002826:	6145                	addi	sp,sp,48
    80002828:	8082                	ret
    panic("iget: no inodes");
    8000282a:	00006517          	auipc	a0,0x6
    8000282e:	bd650513          	addi	a0,a0,-1066 # 80008400 <etext+0x400>
    80002832:	00003097          	auipc	ra,0x3
    80002836:	3ea080e7          	jalr	1002(ra) # 80005c1c <panic>

000000008000283a <fsinit>:
fsinit(int dev) {
    8000283a:	7179                	addi	sp,sp,-48
    8000283c:	f406                	sd	ra,40(sp)
    8000283e:	f022                	sd	s0,32(sp)
    80002840:	ec26                	sd	s1,24(sp)
    80002842:	e84a                	sd	s2,16(sp)
    80002844:	e44e                	sd	s3,8(sp)
    80002846:	1800                	addi	s0,sp,48
    80002848:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000284a:	4585                	li	a1,1
    8000284c:	00000097          	auipc	ra,0x0
    80002850:	a68080e7          	jalr	-1432(ra) # 800022b4 <bread>
    80002854:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002856:	00018997          	auipc	s3,0x18
    8000285a:	d0298993          	addi	s3,s3,-766 # 8001a558 <sb>
    8000285e:	02000613          	li	a2,32
    80002862:	05850593          	addi	a1,a0,88
    80002866:	854e                	mv	a0,s3
    80002868:	ffffe097          	auipc	ra,0xffffe
    8000286c:	96e080e7          	jalr	-1682(ra) # 800001d6 <memmove>
  brelse(bp);
    80002870:	8526                	mv	a0,s1
    80002872:	00000097          	auipc	ra,0x0
    80002876:	b72080e7          	jalr	-1166(ra) # 800023e4 <brelse>
  if(sb.magic != FSMAGIC)
    8000287a:	0009a703          	lw	a4,0(s3)
    8000287e:	102037b7          	lui	a5,0x10203
    80002882:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002886:	02f71263          	bne	a4,a5,800028aa <fsinit+0x70>
  initlog(dev, &sb);
    8000288a:	00018597          	auipc	a1,0x18
    8000288e:	cce58593          	addi	a1,a1,-818 # 8001a558 <sb>
    80002892:	854a                	mv	a0,s2
    80002894:	00001097          	auipc	ra,0x1
    80002898:	b54080e7          	jalr	-1196(ra) # 800033e8 <initlog>
}
    8000289c:	70a2                	ld	ra,40(sp)
    8000289e:	7402                	ld	s0,32(sp)
    800028a0:	64e2                	ld	s1,24(sp)
    800028a2:	6942                	ld	s2,16(sp)
    800028a4:	69a2                	ld	s3,8(sp)
    800028a6:	6145                	addi	sp,sp,48
    800028a8:	8082                	ret
    panic("invalid file system");
    800028aa:	00006517          	auipc	a0,0x6
    800028ae:	b6650513          	addi	a0,a0,-1178 # 80008410 <etext+0x410>
    800028b2:	00003097          	auipc	ra,0x3
    800028b6:	36a080e7          	jalr	874(ra) # 80005c1c <panic>

00000000800028ba <iinit>:
{
    800028ba:	7179                	addi	sp,sp,-48
    800028bc:	f406                	sd	ra,40(sp)
    800028be:	f022                	sd	s0,32(sp)
    800028c0:	ec26                	sd	s1,24(sp)
    800028c2:	e84a                	sd	s2,16(sp)
    800028c4:	e44e                	sd	s3,8(sp)
    800028c6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800028c8:	00006597          	auipc	a1,0x6
    800028cc:	b6058593          	addi	a1,a1,-1184 # 80008428 <etext+0x428>
    800028d0:	00018517          	auipc	a0,0x18
    800028d4:	ca850513          	addi	a0,a0,-856 # 8001a578 <itable>
    800028d8:	00004097          	auipc	ra,0x4
    800028dc:	82e080e7          	jalr	-2002(ra) # 80006106 <initlock>
  for(i = 0; i < NINODE; i++) {
    800028e0:	00018497          	auipc	s1,0x18
    800028e4:	cc048493          	addi	s1,s1,-832 # 8001a5a0 <itable+0x28>
    800028e8:	00019997          	auipc	s3,0x19
    800028ec:	74898993          	addi	s3,s3,1864 # 8001c030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800028f0:	00006917          	auipc	s2,0x6
    800028f4:	b4090913          	addi	s2,s2,-1216 # 80008430 <etext+0x430>
    800028f8:	85ca                	mv	a1,s2
    800028fa:	8526                	mv	a0,s1
    800028fc:	00001097          	auipc	ra,0x1
    80002900:	e40080e7          	jalr	-448(ra) # 8000373c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002904:	08848493          	addi	s1,s1,136
    80002908:	ff3498e3          	bne	s1,s3,800028f8 <iinit+0x3e>
}
    8000290c:	70a2                	ld	ra,40(sp)
    8000290e:	7402                	ld	s0,32(sp)
    80002910:	64e2                	ld	s1,24(sp)
    80002912:	6942                	ld	s2,16(sp)
    80002914:	69a2                	ld	s3,8(sp)
    80002916:	6145                	addi	sp,sp,48
    80002918:	8082                	ret

000000008000291a <ialloc>:
{
    8000291a:	7139                	addi	sp,sp,-64
    8000291c:	fc06                	sd	ra,56(sp)
    8000291e:	f822                	sd	s0,48(sp)
    80002920:	f426                	sd	s1,40(sp)
    80002922:	f04a                	sd	s2,32(sp)
    80002924:	ec4e                	sd	s3,24(sp)
    80002926:	e852                	sd	s4,16(sp)
    80002928:	e456                	sd	s5,8(sp)
    8000292a:	e05a                	sd	s6,0(sp)
    8000292c:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000292e:	00018717          	auipc	a4,0x18
    80002932:	c3672703          	lw	a4,-970(a4) # 8001a564 <sb+0xc>
    80002936:	4785                	li	a5,1
    80002938:	04e7f863          	bgeu	a5,a4,80002988 <ialloc+0x6e>
    8000293c:	8aaa                	mv	s5,a0
    8000293e:	8b2e                	mv	s6,a1
    80002940:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002942:	00018a17          	auipc	s4,0x18
    80002946:	c16a0a13          	addi	s4,s4,-1002 # 8001a558 <sb>
    8000294a:	00495593          	srli	a1,s2,0x4
    8000294e:	018a2783          	lw	a5,24(s4)
    80002952:	9dbd                	addw	a1,a1,a5
    80002954:	8556                	mv	a0,s5
    80002956:	00000097          	auipc	ra,0x0
    8000295a:	95e080e7          	jalr	-1698(ra) # 800022b4 <bread>
    8000295e:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002960:	05850993          	addi	s3,a0,88
    80002964:	00f97793          	andi	a5,s2,15
    80002968:	079a                	slli	a5,a5,0x6
    8000296a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000296c:	00099783          	lh	a5,0(s3)
    80002970:	c785                	beqz	a5,80002998 <ialloc+0x7e>
    brelse(bp);
    80002972:	00000097          	auipc	ra,0x0
    80002976:	a72080e7          	jalr	-1422(ra) # 800023e4 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000297a:	0905                	addi	s2,s2,1
    8000297c:	00ca2703          	lw	a4,12(s4)
    80002980:	0009079b          	sext.w	a5,s2
    80002984:	fce7e3e3          	bltu	a5,a4,8000294a <ialloc+0x30>
  panic("ialloc: no inodes");
    80002988:	00006517          	auipc	a0,0x6
    8000298c:	ab050513          	addi	a0,a0,-1360 # 80008438 <etext+0x438>
    80002990:	00003097          	auipc	ra,0x3
    80002994:	28c080e7          	jalr	652(ra) # 80005c1c <panic>
      memset(dip, 0, sizeof(*dip));
    80002998:	04000613          	li	a2,64
    8000299c:	4581                	li	a1,0
    8000299e:	854e                	mv	a0,s3
    800029a0:	ffffd097          	auipc	ra,0xffffd
    800029a4:	7da080e7          	jalr	2010(ra) # 8000017a <memset>
      dip->type = type;
    800029a8:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800029ac:	8526                	mv	a0,s1
    800029ae:	00001097          	auipc	ra,0x1
    800029b2:	caa080e7          	jalr	-854(ra) # 80003658 <log_write>
      brelse(bp);
    800029b6:	8526                	mv	a0,s1
    800029b8:	00000097          	auipc	ra,0x0
    800029bc:	a2c080e7          	jalr	-1492(ra) # 800023e4 <brelse>
      return iget(dev, inum);
    800029c0:	0009059b          	sext.w	a1,s2
    800029c4:	8556                	mv	a0,s5
    800029c6:	00000097          	auipc	ra,0x0
    800029ca:	db8080e7          	jalr	-584(ra) # 8000277e <iget>
}
    800029ce:	70e2                	ld	ra,56(sp)
    800029d0:	7442                	ld	s0,48(sp)
    800029d2:	74a2                	ld	s1,40(sp)
    800029d4:	7902                	ld	s2,32(sp)
    800029d6:	69e2                	ld	s3,24(sp)
    800029d8:	6a42                	ld	s4,16(sp)
    800029da:	6aa2                	ld	s5,8(sp)
    800029dc:	6b02                	ld	s6,0(sp)
    800029de:	6121                	addi	sp,sp,64
    800029e0:	8082                	ret

00000000800029e2 <iupdate>:
{
    800029e2:	1101                	addi	sp,sp,-32
    800029e4:	ec06                	sd	ra,24(sp)
    800029e6:	e822                	sd	s0,16(sp)
    800029e8:	e426                	sd	s1,8(sp)
    800029ea:	e04a                	sd	s2,0(sp)
    800029ec:	1000                	addi	s0,sp,32
    800029ee:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800029f0:	415c                	lw	a5,4(a0)
    800029f2:	0047d79b          	srliw	a5,a5,0x4
    800029f6:	00018597          	auipc	a1,0x18
    800029fa:	b7a5a583          	lw	a1,-1158(a1) # 8001a570 <sb+0x18>
    800029fe:	9dbd                	addw	a1,a1,a5
    80002a00:	4108                	lw	a0,0(a0)
    80002a02:	00000097          	auipc	ra,0x0
    80002a06:	8b2080e7          	jalr	-1870(ra) # 800022b4 <bread>
    80002a0a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a0c:	05850793          	addi	a5,a0,88
    80002a10:	40d8                	lw	a4,4(s1)
    80002a12:	8b3d                	andi	a4,a4,15
    80002a14:	071a                	slli	a4,a4,0x6
    80002a16:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002a18:	04449703          	lh	a4,68(s1)
    80002a1c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002a20:	04649703          	lh	a4,70(s1)
    80002a24:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002a28:	04849703          	lh	a4,72(s1)
    80002a2c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002a30:	04a49703          	lh	a4,74(s1)
    80002a34:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002a38:	44f8                	lw	a4,76(s1)
    80002a3a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002a3c:	03400613          	li	a2,52
    80002a40:	05048593          	addi	a1,s1,80
    80002a44:	00c78513          	addi	a0,a5,12
    80002a48:	ffffd097          	auipc	ra,0xffffd
    80002a4c:	78e080e7          	jalr	1934(ra) # 800001d6 <memmove>
  log_write(bp);
    80002a50:	854a                	mv	a0,s2
    80002a52:	00001097          	auipc	ra,0x1
    80002a56:	c06080e7          	jalr	-1018(ra) # 80003658 <log_write>
  brelse(bp);
    80002a5a:	854a                	mv	a0,s2
    80002a5c:	00000097          	auipc	ra,0x0
    80002a60:	988080e7          	jalr	-1656(ra) # 800023e4 <brelse>
}
    80002a64:	60e2                	ld	ra,24(sp)
    80002a66:	6442                	ld	s0,16(sp)
    80002a68:	64a2                	ld	s1,8(sp)
    80002a6a:	6902                	ld	s2,0(sp)
    80002a6c:	6105                	addi	sp,sp,32
    80002a6e:	8082                	ret

0000000080002a70 <idup>:
{
    80002a70:	1101                	addi	sp,sp,-32
    80002a72:	ec06                	sd	ra,24(sp)
    80002a74:	e822                	sd	s0,16(sp)
    80002a76:	e426                	sd	s1,8(sp)
    80002a78:	1000                	addi	s0,sp,32
    80002a7a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002a7c:	00018517          	auipc	a0,0x18
    80002a80:	afc50513          	addi	a0,a0,-1284 # 8001a578 <itable>
    80002a84:	00003097          	auipc	ra,0x3
    80002a88:	712080e7          	jalr	1810(ra) # 80006196 <acquire>
  ip->ref++;
    80002a8c:	449c                	lw	a5,8(s1)
    80002a8e:	2785                	addiw	a5,a5,1
    80002a90:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002a92:	00018517          	auipc	a0,0x18
    80002a96:	ae650513          	addi	a0,a0,-1306 # 8001a578 <itable>
    80002a9a:	00003097          	auipc	ra,0x3
    80002a9e:	7b0080e7          	jalr	1968(ra) # 8000624a <release>
}
    80002aa2:	8526                	mv	a0,s1
    80002aa4:	60e2                	ld	ra,24(sp)
    80002aa6:	6442                	ld	s0,16(sp)
    80002aa8:	64a2                	ld	s1,8(sp)
    80002aaa:	6105                	addi	sp,sp,32
    80002aac:	8082                	ret

0000000080002aae <ilock>:
{
    80002aae:	1101                	addi	sp,sp,-32
    80002ab0:	ec06                	sd	ra,24(sp)
    80002ab2:	e822                	sd	s0,16(sp)
    80002ab4:	e426                	sd	s1,8(sp)
    80002ab6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002ab8:	c10d                	beqz	a0,80002ada <ilock+0x2c>
    80002aba:	84aa                	mv	s1,a0
    80002abc:	451c                	lw	a5,8(a0)
    80002abe:	00f05e63          	blez	a5,80002ada <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002ac2:	0541                	addi	a0,a0,16
    80002ac4:	00001097          	auipc	ra,0x1
    80002ac8:	cb2080e7          	jalr	-846(ra) # 80003776 <acquiresleep>
  if(ip->valid == 0){
    80002acc:	40bc                	lw	a5,64(s1)
    80002ace:	cf99                	beqz	a5,80002aec <ilock+0x3e>
}
    80002ad0:	60e2                	ld	ra,24(sp)
    80002ad2:	6442                	ld	s0,16(sp)
    80002ad4:	64a2                	ld	s1,8(sp)
    80002ad6:	6105                	addi	sp,sp,32
    80002ad8:	8082                	ret
    80002ada:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002adc:	00006517          	auipc	a0,0x6
    80002ae0:	97450513          	addi	a0,a0,-1676 # 80008450 <etext+0x450>
    80002ae4:	00003097          	auipc	ra,0x3
    80002ae8:	138080e7          	jalr	312(ra) # 80005c1c <panic>
    80002aec:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002aee:	40dc                	lw	a5,4(s1)
    80002af0:	0047d79b          	srliw	a5,a5,0x4
    80002af4:	00018597          	auipc	a1,0x18
    80002af8:	a7c5a583          	lw	a1,-1412(a1) # 8001a570 <sb+0x18>
    80002afc:	9dbd                	addw	a1,a1,a5
    80002afe:	4088                	lw	a0,0(s1)
    80002b00:	fffff097          	auipc	ra,0xfffff
    80002b04:	7b4080e7          	jalr	1972(ra) # 800022b4 <bread>
    80002b08:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b0a:	05850593          	addi	a1,a0,88
    80002b0e:	40dc                	lw	a5,4(s1)
    80002b10:	8bbd                	andi	a5,a5,15
    80002b12:	079a                	slli	a5,a5,0x6
    80002b14:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b16:	00059783          	lh	a5,0(a1)
    80002b1a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b1e:	00259783          	lh	a5,2(a1)
    80002b22:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b26:	00459783          	lh	a5,4(a1)
    80002b2a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b2e:	00659783          	lh	a5,6(a1)
    80002b32:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b36:	459c                	lw	a5,8(a1)
    80002b38:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b3a:	03400613          	li	a2,52
    80002b3e:	05b1                	addi	a1,a1,12
    80002b40:	05048513          	addi	a0,s1,80
    80002b44:	ffffd097          	auipc	ra,0xffffd
    80002b48:	692080e7          	jalr	1682(ra) # 800001d6 <memmove>
    brelse(bp);
    80002b4c:	854a                	mv	a0,s2
    80002b4e:	00000097          	auipc	ra,0x0
    80002b52:	896080e7          	jalr	-1898(ra) # 800023e4 <brelse>
    ip->valid = 1;
    80002b56:	4785                	li	a5,1
    80002b58:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002b5a:	04449783          	lh	a5,68(s1)
    80002b5e:	c399                	beqz	a5,80002b64 <ilock+0xb6>
    80002b60:	6902                	ld	s2,0(sp)
    80002b62:	b7bd                	j	80002ad0 <ilock+0x22>
      panic("ilock: no type");
    80002b64:	00006517          	auipc	a0,0x6
    80002b68:	8f450513          	addi	a0,a0,-1804 # 80008458 <etext+0x458>
    80002b6c:	00003097          	auipc	ra,0x3
    80002b70:	0b0080e7          	jalr	176(ra) # 80005c1c <panic>

0000000080002b74 <iunlock>:
{
    80002b74:	1101                	addi	sp,sp,-32
    80002b76:	ec06                	sd	ra,24(sp)
    80002b78:	e822                	sd	s0,16(sp)
    80002b7a:	e426                	sd	s1,8(sp)
    80002b7c:	e04a                	sd	s2,0(sp)
    80002b7e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002b80:	c905                	beqz	a0,80002bb0 <iunlock+0x3c>
    80002b82:	84aa                	mv	s1,a0
    80002b84:	01050913          	addi	s2,a0,16
    80002b88:	854a                	mv	a0,s2
    80002b8a:	00001097          	auipc	ra,0x1
    80002b8e:	c86080e7          	jalr	-890(ra) # 80003810 <holdingsleep>
    80002b92:	cd19                	beqz	a0,80002bb0 <iunlock+0x3c>
    80002b94:	449c                	lw	a5,8(s1)
    80002b96:	00f05d63          	blez	a5,80002bb0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002b9a:	854a                	mv	a0,s2
    80002b9c:	00001097          	auipc	ra,0x1
    80002ba0:	c30080e7          	jalr	-976(ra) # 800037cc <releasesleep>
}
    80002ba4:	60e2                	ld	ra,24(sp)
    80002ba6:	6442                	ld	s0,16(sp)
    80002ba8:	64a2                	ld	s1,8(sp)
    80002baa:	6902                	ld	s2,0(sp)
    80002bac:	6105                	addi	sp,sp,32
    80002bae:	8082                	ret
    panic("iunlock");
    80002bb0:	00006517          	auipc	a0,0x6
    80002bb4:	8b850513          	addi	a0,a0,-1864 # 80008468 <etext+0x468>
    80002bb8:	00003097          	auipc	ra,0x3
    80002bbc:	064080e7          	jalr	100(ra) # 80005c1c <panic>

0000000080002bc0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002bc0:	7179                	addi	sp,sp,-48
    80002bc2:	f406                	sd	ra,40(sp)
    80002bc4:	f022                	sd	s0,32(sp)
    80002bc6:	ec26                	sd	s1,24(sp)
    80002bc8:	e84a                	sd	s2,16(sp)
    80002bca:	e44e                	sd	s3,8(sp)
    80002bcc:	1800                	addi	s0,sp,48
    80002bce:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002bd0:	05050493          	addi	s1,a0,80
    80002bd4:	08050913          	addi	s2,a0,128
    80002bd8:	a021                	j	80002be0 <itrunc+0x20>
    80002bda:	0491                	addi	s1,s1,4
    80002bdc:	01248d63          	beq	s1,s2,80002bf6 <itrunc+0x36>
    if(ip->addrs[i]){
    80002be0:	408c                	lw	a1,0(s1)
    80002be2:	dde5                	beqz	a1,80002bda <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002be4:	0009a503          	lw	a0,0(s3)
    80002be8:	00000097          	auipc	ra,0x0
    80002bec:	910080e7          	jalr	-1776(ra) # 800024f8 <bfree>
      ip->addrs[i] = 0;
    80002bf0:	0004a023          	sw	zero,0(s1)
    80002bf4:	b7dd                	j	80002bda <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002bf6:	0809a583          	lw	a1,128(s3)
    80002bfa:	ed99                	bnez	a1,80002c18 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002bfc:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c00:	854e                	mv	a0,s3
    80002c02:	00000097          	auipc	ra,0x0
    80002c06:	de0080e7          	jalr	-544(ra) # 800029e2 <iupdate>
}
    80002c0a:	70a2                	ld	ra,40(sp)
    80002c0c:	7402                	ld	s0,32(sp)
    80002c0e:	64e2                	ld	s1,24(sp)
    80002c10:	6942                	ld	s2,16(sp)
    80002c12:	69a2                	ld	s3,8(sp)
    80002c14:	6145                	addi	sp,sp,48
    80002c16:	8082                	ret
    80002c18:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c1a:	0009a503          	lw	a0,0(s3)
    80002c1e:	fffff097          	auipc	ra,0xfffff
    80002c22:	696080e7          	jalr	1686(ra) # 800022b4 <bread>
    80002c26:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c28:	05850493          	addi	s1,a0,88
    80002c2c:	45850913          	addi	s2,a0,1112
    80002c30:	a021                	j	80002c38 <itrunc+0x78>
    80002c32:	0491                	addi	s1,s1,4
    80002c34:	01248b63          	beq	s1,s2,80002c4a <itrunc+0x8a>
      if(a[j])
    80002c38:	408c                	lw	a1,0(s1)
    80002c3a:	dde5                	beqz	a1,80002c32 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002c3c:	0009a503          	lw	a0,0(s3)
    80002c40:	00000097          	auipc	ra,0x0
    80002c44:	8b8080e7          	jalr	-1864(ra) # 800024f8 <bfree>
    80002c48:	b7ed                	j	80002c32 <itrunc+0x72>
    brelse(bp);
    80002c4a:	8552                	mv	a0,s4
    80002c4c:	fffff097          	auipc	ra,0xfffff
    80002c50:	798080e7          	jalr	1944(ra) # 800023e4 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002c54:	0809a583          	lw	a1,128(s3)
    80002c58:	0009a503          	lw	a0,0(s3)
    80002c5c:	00000097          	auipc	ra,0x0
    80002c60:	89c080e7          	jalr	-1892(ra) # 800024f8 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002c64:	0809a023          	sw	zero,128(s3)
    80002c68:	6a02                	ld	s4,0(sp)
    80002c6a:	bf49                	j	80002bfc <itrunc+0x3c>

0000000080002c6c <iput>:
{
    80002c6c:	1101                	addi	sp,sp,-32
    80002c6e:	ec06                	sd	ra,24(sp)
    80002c70:	e822                	sd	s0,16(sp)
    80002c72:	e426                	sd	s1,8(sp)
    80002c74:	1000                	addi	s0,sp,32
    80002c76:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c78:	00018517          	auipc	a0,0x18
    80002c7c:	90050513          	addi	a0,a0,-1792 # 8001a578 <itable>
    80002c80:	00003097          	auipc	ra,0x3
    80002c84:	516080e7          	jalr	1302(ra) # 80006196 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002c88:	4498                	lw	a4,8(s1)
    80002c8a:	4785                	li	a5,1
    80002c8c:	02f70263          	beq	a4,a5,80002cb0 <iput+0x44>
  ip->ref--;
    80002c90:	449c                	lw	a5,8(s1)
    80002c92:	37fd                	addiw	a5,a5,-1
    80002c94:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c96:	00018517          	auipc	a0,0x18
    80002c9a:	8e250513          	addi	a0,a0,-1822 # 8001a578 <itable>
    80002c9e:	00003097          	auipc	ra,0x3
    80002ca2:	5ac080e7          	jalr	1452(ra) # 8000624a <release>
}
    80002ca6:	60e2                	ld	ra,24(sp)
    80002ca8:	6442                	ld	s0,16(sp)
    80002caa:	64a2                	ld	s1,8(sp)
    80002cac:	6105                	addi	sp,sp,32
    80002cae:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cb0:	40bc                	lw	a5,64(s1)
    80002cb2:	dff9                	beqz	a5,80002c90 <iput+0x24>
    80002cb4:	04a49783          	lh	a5,74(s1)
    80002cb8:	ffe1                	bnez	a5,80002c90 <iput+0x24>
    80002cba:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002cbc:	01048913          	addi	s2,s1,16
    80002cc0:	854a                	mv	a0,s2
    80002cc2:	00001097          	auipc	ra,0x1
    80002cc6:	ab4080e7          	jalr	-1356(ra) # 80003776 <acquiresleep>
    release(&itable.lock);
    80002cca:	00018517          	auipc	a0,0x18
    80002cce:	8ae50513          	addi	a0,a0,-1874 # 8001a578 <itable>
    80002cd2:	00003097          	auipc	ra,0x3
    80002cd6:	578080e7          	jalr	1400(ra) # 8000624a <release>
    itrunc(ip);
    80002cda:	8526                	mv	a0,s1
    80002cdc:	00000097          	auipc	ra,0x0
    80002ce0:	ee4080e7          	jalr	-284(ra) # 80002bc0 <itrunc>
    ip->type = 0;
    80002ce4:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ce8:	8526                	mv	a0,s1
    80002cea:	00000097          	auipc	ra,0x0
    80002cee:	cf8080e7          	jalr	-776(ra) # 800029e2 <iupdate>
    ip->valid = 0;
    80002cf2:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002cf6:	854a                	mv	a0,s2
    80002cf8:	00001097          	auipc	ra,0x1
    80002cfc:	ad4080e7          	jalr	-1324(ra) # 800037cc <releasesleep>
    acquire(&itable.lock);
    80002d00:	00018517          	auipc	a0,0x18
    80002d04:	87850513          	addi	a0,a0,-1928 # 8001a578 <itable>
    80002d08:	00003097          	auipc	ra,0x3
    80002d0c:	48e080e7          	jalr	1166(ra) # 80006196 <acquire>
    80002d10:	6902                	ld	s2,0(sp)
    80002d12:	bfbd                	j	80002c90 <iput+0x24>

0000000080002d14 <iunlockput>:
{
    80002d14:	1101                	addi	sp,sp,-32
    80002d16:	ec06                	sd	ra,24(sp)
    80002d18:	e822                	sd	s0,16(sp)
    80002d1a:	e426                	sd	s1,8(sp)
    80002d1c:	1000                	addi	s0,sp,32
    80002d1e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d20:	00000097          	auipc	ra,0x0
    80002d24:	e54080e7          	jalr	-428(ra) # 80002b74 <iunlock>
  iput(ip);
    80002d28:	8526                	mv	a0,s1
    80002d2a:	00000097          	auipc	ra,0x0
    80002d2e:	f42080e7          	jalr	-190(ra) # 80002c6c <iput>
}
    80002d32:	60e2                	ld	ra,24(sp)
    80002d34:	6442                	ld	s0,16(sp)
    80002d36:	64a2                	ld	s1,8(sp)
    80002d38:	6105                	addi	sp,sp,32
    80002d3a:	8082                	ret

0000000080002d3c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002d3c:	1141                	addi	sp,sp,-16
    80002d3e:	e422                	sd	s0,8(sp)
    80002d40:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002d42:	411c                	lw	a5,0(a0)
    80002d44:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002d46:	415c                	lw	a5,4(a0)
    80002d48:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002d4a:	04451783          	lh	a5,68(a0)
    80002d4e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002d52:	04a51783          	lh	a5,74(a0)
    80002d56:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002d5a:	04c56783          	lwu	a5,76(a0)
    80002d5e:	e99c                	sd	a5,16(a1)
}
    80002d60:	6422                	ld	s0,8(sp)
    80002d62:	0141                	addi	sp,sp,16
    80002d64:	8082                	ret

0000000080002d66 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d66:	457c                	lw	a5,76(a0)
    80002d68:	0ed7ef63          	bltu	a5,a3,80002e66 <readi+0x100>
{
    80002d6c:	7159                	addi	sp,sp,-112
    80002d6e:	f486                	sd	ra,104(sp)
    80002d70:	f0a2                	sd	s0,96(sp)
    80002d72:	eca6                	sd	s1,88(sp)
    80002d74:	fc56                	sd	s5,56(sp)
    80002d76:	f85a                	sd	s6,48(sp)
    80002d78:	f45e                	sd	s7,40(sp)
    80002d7a:	f062                	sd	s8,32(sp)
    80002d7c:	1880                	addi	s0,sp,112
    80002d7e:	8baa                	mv	s7,a0
    80002d80:	8c2e                	mv	s8,a1
    80002d82:	8ab2                	mv	s5,a2
    80002d84:	84b6                	mv	s1,a3
    80002d86:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002d88:	9f35                	addw	a4,a4,a3
    return 0;
    80002d8a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002d8c:	0ad76c63          	bltu	a4,a3,80002e44 <readi+0xde>
    80002d90:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002d92:	00e7f463          	bgeu	a5,a4,80002d9a <readi+0x34>
    n = ip->size - off;
    80002d96:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002d9a:	0c0b0463          	beqz	s6,80002e62 <readi+0xfc>
    80002d9e:	e8ca                	sd	s2,80(sp)
    80002da0:	e0d2                	sd	s4,64(sp)
    80002da2:	ec66                	sd	s9,24(sp)
    80002da4:	e86a                	sd	s10,16(sp)
    80002da6:	e46e                	sd	s11,8(sp)
    80002da8:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002daa:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002dae:	5cfd                	li	s9,-1
    80002db0:	a82d                	j	80002dea <readi+0x84>
    80002db2:	020a1d93          	slli	s11,s4,0x20
    80002db6:	020ddd93          	srli	s11,s11,0x20
    80002dba:	05890613          	addi	a2,s2,88
    80002dbe:	86ee                	mv	a3,s11
    80002dc0:	963a                	add	a2,a2,a4
    80002dc2:	85d6                	mv	a1,s5
    80002dc4:	8562                	mv	a0,s8
    80002dc6:	fffff097          	auipc	ra,0xfffff
    80002dca:	b20080e7          	jalr	-1248(ra) # 800018e6 <either_copyout>
    80002dce:	05950d63          	beq	a0,s9,80002e28 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002dd2:	854a                	mv	a0,s2
    80002dd4:	fffff097          	auipc	ra,0xfffff
    80002dd8:	610080e7          	jalr	1552(ra) # 800023e4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ddc:	013a09bb          	addw	s3,s4,s3
    80002de0:	009a04bb          	addw	s1,s4,s1
    80002de4:	9aee                	add	s5,s5,s11
    80002de6:	0769f863          	bgeu	s3,s6,80002e56 <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002dea:	000ba903          	lw	s2,0(s7)
    80002dee:	00a4d59b          	srliw	a1,s1,0xa
    80002df2:	855e                	mv	a0,s7
    80002df4:	00000097          	auipc	ra,0x0
    80002df8:	8ae080e7          	jalr	-1874(ra) # 800026a2 <bmap>
    80002dfc:	0005059b          	sext.w	a1,a0
    80002e00:	854a                	mv	a0,s2
    80002e02:	fffff097          	auipc	ra,0xfffff
    80002e06:	4b2080e7          	jalr	1202(ra) # 800022b4 <bread>
    80002e0a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e0c:	3ff4f713          	andi	a4,s1,1023
    80002e10:	40ed07bb          	subw	a5,s10,a4
    80002e14:	413b06bb          	subw	a3,s6,s3
    80002e18:	8a3e                	mv	s4,a5
    80002e1a:	2781                	sext.w	a5,a5
    80002e1c:	0006861b          	sext.w	a2,a3
    80002e20:	f8f679e3          	bgeu	a2,a5,80002db2 <readi+0x4c>
    80002e24:	8a36                	mv	s4,a3
    80002e26:	b771                	j	80002db2 <readi+0x4c>
      brelse(bp);
    80002e28:	854a                	mv	a0,s2
    80002e2a:	fffff097          	auipc	ra,0xfffff
    80002e2e:	5ba080e7          	jalr	1466(ra) # 800023e4 <brelse>
      tot = -1;
    80002e32:	59fd                	li	s3,-1
      break;
    80002e34:	6946                	ld	s2,80(sp)
    80002e36:	6a06                	ld	s4,64(sp)
    80002e38:	6ce2                	ld	s9,24(sp)
    80002e3a:	6d42                	ld	s10,16(sp)
    80002e3c:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002e3e:	0009851b          	sext.w	a0,s3
    80002e42:	69a6                	ld	s3,72(sp)
}
    80002e44:	70a6                	ld	ra,104(sp)
    80002e46:	7406                	ld	s0,96(sp)
    80002e48:	64e6                	ld	s1,88(sp)
    80002e4a:	7ae2                	ld	s5,56(sp)
    80002e4c:	7b42                	ld	s6,48(sp)
    80002e4e:	7ba2                	ld	s7,40(sp)
    80002e50:	7c02                	ld	s8,32(sp)
    80002e52:	6165                	addi	sp,sp,112
    80002e54:	8082                	ret
    80002e56:	6946                	ld	s2,80(sp)
    80002e58:	6a06                	ld	s4,64(sp)
    80002e5a:	6ce2                	ld	s9,24(sp)
    80002e5c:	6d42                	ld	s10,16(sp)
    80002e5e:	6da2                	ld	s11,8(sp)
    80002e60:	bff9                	j	80002e3e <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e62:	89da                	mv	s3,s6
    80002e64:	bfe9                	j	80002e3e <readi+0xd8>
    return 0;
    80002e66:	4501                	li	a0,0
}
    80002e68:	8082                	ret

0000000080002e6a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e6a:	457c                	lw	a5,76(a0)
    80002e6c:	10d7ee63          	bltu	a5,a3,80002f88 <writei+0x11e>
{
    80002e70:	7159                	addi	sp,sp,-112
    80002e72:	f486                	sd	ra,104(sp)
    80002e74:	f0a2                	sd	s0,96(sp)
    80002e76:	e8ca                	sd	s2,80(sp)
    80002e78:	fc56                	sd	s5,56(sp)
    80002e7a:	f85a                	sd	s6,48(sp)
    80002e7c:	f45e                	sd	s7,40(sp)
    80002e7e:	f062                	sd	s8,32(sp)
    80002e80:	1880                	addi	s0,sp,112
    80002e82:	8b2a                	mv	s6,a0
    80002e84:	8c2e                	mv	s8,a1
    80002e86:	8ab2                	mv	s5,a2
    80002e88:	8936                	mv	s2,a3
    80002e8a:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002e8c:	00e687bb          	addw	a5,a3,a4
    80002e90:	0ed7ee63          	bltu	a5,a3,80002f8c <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002e94:	00043737          	lui	a4,0x43
    80002e98:	0ef76c63          	bltu	a4,a5,80002f90 <writei+0x126>
    80002e9c:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e9e:	0c0b8d63          	beqz	s7,80002f78 <writei+0x10e>
    80002ea2:	eca6                	sd	s1,88(sp)
    80002ea4:	e4ce                	sd	s3,72(sp)
    80002ea6:	ec66                	sd	s9,24(sp)
    80002ea8:	e86a                	sd	s10,16(sp)
    80002eaa:	e46e                	sd	s11,8(sp)
    80002eac:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002eae:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002eb2:	5cfd                	li	s9,-1
    80002eb4:	a091                	j	80002ef8 <writei+0x8e>
    80002eb6:	02099d93          	slli	s11,s3,0x20
    80002eba:	020ddd93          	srli	s11,s11,0x20
    80002ebe:	05848513          	addi	a0,s1,88
    80002ec2:	86ee                	mv	a3,s11
    80002ec4:	8656                	mv	a2,s5
    80002ec6:	85e2                	mv	a1,s8
    80002ec8:	953a                	add	a0,a0,a4
    80002eca:	fffff097          	auipc	ra,0xfffff
    80002ece:	a72080e7          	jalr	-1422(ra) # 8000193c <either_copyin>
    80002ed2:	07950263          	beq	a0,s9,80002f36 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ed6:	8526                	mv	a0,s1
    80002ed8:	00000097          	auipc	ra,0x0
    80002edc:	780080e7          	jalr	1920(ra) # 80003658 <log_write>
    brelse(bp);
    80002ee0:	8526                	mv	a0,s1
    80002ee2:	fffff097          	auipc	ra,0xfffff
    80002ee6:	502080e7          	jalr	1282(ra) # 800023e4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002eea:	01498a3b          	addw	s4,s3,s4
    80002eee:	0129893b          	addw	s2,s3,s2
    80002ef2:	9aee                	add	s5,s5,s11
    80002ef4:	057a7663          	bgeu	s4,s7,80002f40 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002ef8:	000b2483          	lw	s1,0(s6)
    80002efc:	00a9559b          	srliw	a1,s2,0xa
    80002f00:	855a                	mv	a0,s6
    80002f02:	fffff097          	auipc	ra,0xfffff
    80002f06:	7a0080e7          	jalr	1952(ra) # 800026a2 <bmap>
    80002f0a:	0005059b          	sext.w	a1,a0
    80002f0e:	8526                	mv	a0,s1
    80002f10:	fffff097          	auipc	ra,0xfffff
    80002f14:	3a4080e7          	jalr	932(ra) # 800022b4 <bread>
    80002f18:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f1a:	3ff97713          	andi	a4,s2,1023
    80002f1e:	40ed07bb          	subw	a5,s10,a4
    80002f22:	414b86bb          	subw	a3,s7,s4
    80002f26:	89be                	mv	s3,a5
    80002f28:	2781                	sext.w	a5,a5
    80002f2a:	0006861b          	sext.w	a2,a3
    80002f2e:	f8f674e3          	bgeu	a2,a5,80002eb6 <writei+0x4c>
    80002f32:	89b6                	mv	s3,a3
    80002f34:	b749                	j	80002eb6 <writei+0x4c>
      brelse(bp);
    80002f36:	8526                	mv	a0,s1
    80002f38:	fffff097          	auipc	ra,0xfffff
    80002f3c:	4ac080e7          	jalr	1196(ra) # 800023e4 <brelse>
  }

  if(off > ip->size)
    80002f40:	04cb2783          	lw	a5,76(s6)
    80002f44:	0327fc63          	bgeu	a5,s2,80002f7c <writei+0x112>
    ip->size = off;
    80002f48:	052b2623          	sw	s2,76(s6)
    80002f4c:	64e6                	ld	s1,88(sp)
    80002f4e:	69a6                	ld	s3,72(sp)
    80002f50:	6ce2                	ld	s9,24(sp)
    80002f52:	6d42                	ld	s10,16(sp)
    80002f54:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002f56:	855a                	mv	a0,s6
    80002f58:	00000097          	auipc	ra,0x0
    80002f5c:	a8a080e7          	jalr	-1398(ra) # 800029e2 <iupdate>

  return tot;
    80002f60:	000a051b          	sext.w	a0,s4
    80002f64:	6a06                	ld	s4,64(sp)
}
    80002f66:	70a6                	ld	ra,104(sp)
    80002f68:	7406                	ld	s0,96(sp)
    80002f6a:	6946                	ld	s2,80(sp)
    80002f6c:	7ae2                	ld	s5,56(sp)
    80002f6e:	7b42                	ld	s6,48(sp)
    80002f70:	7ba2                	ld	s7,40(sp)
    80002f72:	7c02                	ld	s8,32(sp)
    80002f74:	6165                	addi	sp,sp,112
    80002f76:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f78:	8a5e                	mv	s4,s7
    80002f7a:	bff1                	j	80002f56 <writei+0xec>
    80002f7c:	64e6                	ld	s1,88(sp)
    80002f7e:	69a6                	ld	s3,72(sp)
    80002f80:	6ce2                	ld	s9,24(sp)
    80002f82:	6d42                	ld	s10,16(sp)
    80002f84:	6da2                	ld	s11,8(sp)
    80002f86:	bfc1                	j	80002f56 <writei+0xec>
    return -1;
    80002f88:	557d                	li	a0,-1
}
    80002f8a:	8082                	ret
    return -1;
    80002f8c:	557d                	li	a0,-1
    80002f8e:	bfe1                	j	80002f66 <writei+0xfc>
    return -1;
    80002f90:	557d                	li	a0,-1
    80002f92:	bfd1                	j	80002f66 <writei+0xfc>

0000000080002f94 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002f94:	1141                	addi	sp,sp,-16
    80002f96:	e406                	sd	ra,8(sp)
    80002f98:	e022                	sd	s0,0(sp)
    80002f9a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002f9c:	4639                	li	a2,14
    80002f9e:	ffffd097          	auipc	ra,0xffffd
    80002fa2:	2ac080e7          	jalr	684(ra) # 8000024a <strncmp>
}
    80002fa6:	60a2                	ld	ra,8(sp)
    80002fa8:	6402                	ld	s0,0(sp)
    80002faa:	0141                	addi	sp,sp,16
    80002fac:	8082                	ret

0000000080002fae <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002fae:	7139                	addi	sp,sp,-64
    80002fb0:	fc06                	sd	ra,56(sp)
    80002fb2:	f822                	sd	s0,48(sp)
    80002fb4:	f426                	sd	s1,40(sp)
    80002fb6:	f04a                	sd	s2,32(sp)
    80002fb8:	ec4e                	sd	s3,24(sp)
    80002fba:	e852                	sd	s4,16(sp)
    80002fbc:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002fbe:	04451703          	lh	a4,68(a0)
    80002fc2:	4785                	li	a5,1
    80002fc4:	00f71a63          	bne	a4,a5,80002fd8 <dirlookup+0x2a>
    80002fc8:	892a                	mv	s2,a0
    80002fca:	89ae                	mv	s3,a1
    80002fcc:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fce:	457c                	lw	a5,76(a0)
    80002fd0:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002fd2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002fd4:	e79d                	bnez	a5,80003002 <dirlookup+0x54>
    80002fd6:	a8a5                	j	8000304e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80002fd8:	00005517          	auipc	a0,0x5
    80002fdc:	49850513          	addi	a0,a0,1176 # 80008470 <etext+0x470>
    80002fe0:	00003097          	auipc	ra,0x3
    80002fe4:	c3c080e7          	jalr	-964(ra) # 80005c1c <panic>
      panic("dirlookup read");
    80002fe8:	00005517          	auipc	a0,0x5
    80002fec:	4a050513          	addi	a0,a0,1184 # 80008488 <etext+0x488>
    80002ff0:	00003097          	auipc	ra,0x3
    80002ff4:	c2c080e7          	jalr	-980(ra) # 80005c1c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ff8:	24c1                	addiw	s1,s1,16
    80002ffa:	04c92783          	lw	a5,76(s2)
    80002ffe:	04f4f763          	bgeu	s1,a5,8000304c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003002:	4741                	li	a4,16
    80003004:	86a6                	mv	a3,s1
    80003006:	fc040613          	addi	a2,s0,-64
    8000300a:	4581                	li	a1,0
    8000300c:	854a                	mv	a0,s2
    8000300e:	00000097          	auipc	ra,0x0
    80003012:	d58080e7          	jalr	-680(ra) # 80002d66 <readi>
    80003016:	47c1                	li	a5,16
    80003018:	fcf518e3          	bne	a0,a5,80002fe8 <dirlookup+0x3a>
    if(de.inum == 0)
    8000301c:	fc045783          	lhu	a5,-64(s0)
    80003020:	dfe1                	beqz	a5,80002ff8 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003022:	fc240593          	addi	a1,s0,-62
    80003026:	854e                	mv	a0,s3
    80003028:	00000097          	auipc	ra,0x0
    8000302c:	f6c080e7          	jalr	-148(ra) # 80002f94 <namecmp>
    80003030:	f561                	bnez	a0,80002ff8 <dirlookup+0x4a>
      if(poff)
    80003032:	000a0463          	beqz	s4,8000303a <dirlookup+0x8c>
        *poff = off;
    80003036:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000303a:	fc045583          	lhu	a1,-64(s0)
    8000303e:	00092503          	lw	a0,0(s2)
    80003042:	fffff097          	auipc	ra,0xfffff
    80003046:	73c080e7          	jalr	1852(ra) # 8000277e <iget>
    8000304a:	a011                	j	8000304e <dirlookup+0xa0>
  return 0;
    8000304c:	4501                	li	a0,0
}
    8000304e:	70e2                	ld	ra,56(sp)
    80003050:	7442                	ld	s0,48(sp)
    80003052:	74a2                	ld	s1,40(sp)
    80003054:	7902                	ld	s2,32(sp)
    80003056:	69e2                	ld	s3,24(sp)
    80003058:	6a42                	ld	s4,16(sp)
    8000305a:	6121                	addi	sp,sp,64
    8000305c:	8082                	ret

000000008000305e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000305e:	711d                	addi	sp,sp,-96
    80003060:	ec86                	sd	ra,88(sp)
    80003062:	e8a2                	sd	s0,80(sp)
    80003064:	e4a6                	sd	s1,72(sp)
    80003066:	e0ca                	sd	s2,64(sp)
    80003068:	fc4e                	sd	s3,56(sp)
    8000306a:	f852                	sd	s4,48(sp)
    8000306c:	f456                	sd	s5,40(sp)
    8000306e:	f05a                	sd	s6,32(sp)
    80003070:	ec5e                	sd	s7,24(sp)
    80003072:	e862                	sd	s8,16(sp)
    80003074:	e466                	sd	s9,8(sp)
    80003076:	1080                	addi	s0,sp,96
    80003078:	84aa                	mv	s1,a0
    8000307a:	8b2e                	mv	s6,a1
    8000307c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000307e:	00054703          	lbu	a4,0(a0)
    80003082:	02f00793          	li	a5,47
    80003086:	02f70263          	beq	a4,a5,800030aa <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000308a:	ffffe097          	auipc	ra,0xffffe
    8000308e:	df2080e7          	jalr	-526(ra) # 80000e7c <myproc>
    80003092:	15053503          	ld	a0,336(a0)
    80003096:	00000097          	auipc	ra,0x0
    8000309a:	9da080e7          	jalr	-1574(ra) # 80002a70 <idup>
    8000309e:	8a2a                	mv	s4,a0
  while(*path == '/')
    800030a0:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800030a4:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800030a6:	4b85                	li	s7,1
    800030a8:	a875                	j	80003164 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800030aa:	4585                	li	a1,1
    800030ac:	4505                	li	a0,1
    800030ae:	fffff097          	auipc	ra,0xfffff
    800030b2:	6d0080e7          	jalr	1744(ra) # 8000277e <iget>
    800030b6:	8a2a                	mv	s4,a0
    800030b8:	b7e5                	j	800030a0 <namex+0x42>
      iunlockput(ip);
    800030ba:	8552                	mv	a0,s4
    800030bc:	00000097          	auipc	ra,0x0
    800030c0:	c58080e7          	jalr	-936(ra) # 80002d14 <iunlockput>
      return 0;
    800030c4:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800030c6:	8552                	mv	a0,s4
    800030c8:	60e6                	ld	ra,88(sp)
    800030ca:	6446                	ld	s0,80(sp)
    800030cc:	64a6                	ld	s1,72(sp)
    800030ce:	6906                	ld	s2,64(sp)
    800030d0:	79e2                	ld	s3,56(sp)
    800030d2:	7a42                	ld	s4,48(sp)
    800030d4:	7aa2                	ld	s5,40(sp)
    800030d6:	7b02                	ld	s6,32(sp)
    800030d8:	6be2                	ld	s7,24(sp)
    800030da:	6c42                	ld	s8,16(sp)
    800030dc:	6ca2                	ld	s9,8(sp)
    800030de:	6125                	addi	sp,sp,96
    800030e0:	8082                	ret
      iunlock(ip);
    800030e2:	8552                	mv	a0,s4
    800030e4:	00000097          	auipc	ra,0x0
    800030e8:	a90080e7          	jalr	-1392(ra) # 80002b74 <iunlock>
      return ip;
    800030ec:	bfe9                	j	800030c6 <namex+0x68>
      iunlockput(ip);
    800030ee:	8552                	mv	a0,s4
    800030f0:	00000097          	auipc	ra,0x0
    800030f4:	c24080e7          	jalr	-988(ra) # 80002d14 <iunlockput>
      return 0;
    800030f8:	8a4e                	mv	s4,s3
    800030fa:	b7f1                	j	800030c6 <namex+0x68>
  len = path - s;
    800030fc:	40998633          	sub	a2,s3,s1
    80003100:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003104:	099c5863          	bge	s8,s9,80003194 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003108:	4639                	li	a2,14
    8000310a:	85a6                	mv	a1,s1
    8000310c:	8556                	mv	a0,s5
    8000310e:	ffffd097          	auipc	ra,0xffffd
    80003112:	0c8080e7          	jalr	200(ra) # 800001d6 <memmove>
    80003116:	84ce                	mv	s1,s3
  while(*path == '/')
    80003118:	0004c783          	lbu	a5,0(s1)
    8000311c:	01279763          	bne	a5,s2,8000312a <namex+0xcc>
    path++;
    80003120:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003122:	0004c783          	lbu	a5,0(s1)
    80003126:	ff278de3          	beq	a5,s2,80003120 <namex+0xc2>
    ilock(ip);
    8000312a:	8552                	mv	a0,s4
    8000312c:	00000097          	auipc	ra,0x0
    80003130:	982080e7          	jalr	-1662(ra) # 80002aae <ilock>
    if(ip->type != T_DIR){
    80003134:	044a1783          	lh	a5,68(s4)
    80003138:	f97791e3          	bne	a5,s7,800030ba <namex+0x5c>
    if(nameiparent && *path == '\0'){
    8000313c:	000b0563          	beqz	s6,80003146 <namex+0xe8>
    80003140:	0004c783          	lbu	a5,0(s1)
    80003144:	dfd9                	beqz	a5,800030e2 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003146:	4601                	li	a2,0
    80003148:	85d6                	mv	a1,s5
    8000314a:	8552                	mv	a0,s4
    8000314c:	00000097          	auipc	ra,0x0
    80003150:	e62080e7          	jalr	-414(ra) # 80002fae <dirlookup>
    80003154:	89aa                	mv	s3,a0
    80003156:	dd41                	beqz	a0,800030ee <namex+0x90>
    iunlockput(ip);
    80003158:	8552                	mv	a0,s4
    8000315a:	00000097          	auipc	ra,0x0
    8000315e:	bba080e7          	jalr	-1094(ra) # 80002d14 <iunlockput>
    ip = next;
    80003162:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003164:	0004c783          	lbu	a5,0(s1)
    80003168:	01279763          	bne	a5,s2,80003176 <namex+0x118>
    path++;
    8000316c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000316e:	0004c783          	lbu	a5,0(s1)
    80003172:	ff278de3          	beq	a5,s2,8000316c <namex+0x10e>
  if(*path == 0)
    80003176:	cb9d                	beqz	a5,800031ac <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003178:	0004c783          	lbu	a5,0(s1)
    8000317c:	89a6                	mv	s3,s1
  len = path - s;
    8000317e:	4c81                	li	s9,0
    80003180:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003182:	01278963          	beq	a5,s2,80003194 <namex+0x136>
    80003186:	dbbd                	beqz	a5,800030fc <namex+0x9e>
    path++;
    80003188:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000318a:	0009c783          	lbu	a5,0(s3)
    8000318e:	ff279ce3          	bne	a5,s2,80003186 <namex+0x128>
    80003192:	b7ad                	j	800030fc <namex+0x9e>
    memmove(name, s, len);
    80003194:	2601                	sext.w	a2,a2
    80003196:	85a6                	mv	a1,s1
    80003198:	8556                	mv	a0,s5
    8000319a:	ffffd097          	auipc	ra,0xffffd
    8000319e:	03c080e7          	jalr	60(ra) # 800001d6 <memmove>
    name[len] = 0;
    800031a2:	9cd6                	add	s9,s9,s5
    800031a4:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800031a8:	84ce                	mv	s1,s3
    800031aa:	b7bd                	j	80003118 <namex+0xba>
  if(nameiparent){
    800031ac:	f00b0de3          	beqz	s6,800030c6 <namex+0x68>
    iput(ip);
    800031b0:	8552                	mv	a0,s4
    800031b2:	00000097          	auipc	ra,0x0
    800031b6:	aba080e7          	jalr	-1350(ra) # 80002c6c <iput>
    return 0;
    800031ba:	4a01                	li	s4,0
    800031bc:	b729                	j	800030c6 <namex+0x68>

00000000800031be <dirlink>:
{
    800031be:	7139                	addi	sp,sp,-64
    800031c0:	fc06                	sd	ra,56(sp)
    800031c2:	f822                	sd	s0,48(sp)
    800031c4:	f04a                	sd	s2,32(sp)
    800031c6:	ec4e                	sd	s3,24(sp)
    800031c8:	e852                	sd	s4,16(sp)
    800031ca:	0080                	addi	s0,sp,64
    800031cc:	892a                	mv	s2,a0
    800031ce:	8a2e                	mv	s4,a1
    800031d0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800031d2:	4601                	li	a2,0
    800031d4:	00000097          	auipc	ra,0x0
    800031d8:	dda080e7          	jalr	-550(ra) # 80002fae <dirlookup>
    800031dc:	ed25                	bnez	a0,80003254 <dirlink+0x96>
    800031de:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031e0:	04c92483          	lw	s1,76(s2)
    800031e4:	c49d                	beqz	s1,80003212 <dirlink+0x54>
    800031e6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031e8:	4741                	li	a4,16
    800031ea:	86a6                	mv	a3,s1
    800031ec:	fc040613          	addi	a2,s0,-64
    800031f0:	4581                	li	a1,0
    800031f2:	854a                	mv	a0,s2
    800031f4:	00000097          	auipc	ra,0x0
    800031f8:	b72080e7          	jalr	-1166(ra) # 80002d66 <readi>
    800031fc:	47c1                	li	a5,16
    800031fe:	06f51163          	bne	a0,a5,80003260 <dirlink+0xa2>
    if(de.inum == 0)
    80003202:	fc045783          	lhu	a5,-64(s0)
    80003206:	c791                	beqz	a5,80003212 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003208:	24c1                	addiw	s1,s1,16
    8000320a:	04c92783          	lw	a5,76(s2)
    8000320e:	fcf4ede3          	bltu	s1,a5,800031e8 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003212:	4639                	li	a2,14
    80003214:	85d2                	mv	a1,s4
    80003216:	fc240513          	addi	a0,s0,-62
    8000321a:	ffffd097          	auipc	ra,0xffffd
    8000321e:	066080e7          	jalr	102(ra) # 80000280 <strncpy>
  de.inum = inum;
    80003222:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003226:	4741                	li	a4,16
    80003228:	86a6                	mv	a3,s1
    8000322a:	fc040613          	addi	a2,s0,-64
    8000322e:	4581                	li	a1,0
    80003230:	854a                	mv	a0,s2
    80003232:	00000097          	auipc	ra,0x0
    80003236:	c38080e7          	jalr	-968(ra) # 80002e6a <writei>
    8000323a:	872a                	mv	a4,a0
    8000323c:	47c1                	li	a5,16
  return 0;
    8000323e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003240:	02f71863          	bne	a4,a5,80003270 <dirlink+0xb2>
    80003244:	74a2                	ld	s1,40(sp)
}
    80003246:	70e2                	ld	ra,56(sp)
    80003248:	7442                	ld	s0,48(sp)
    8000324a:	7902                	ld	s2,32(sp)
    8000324c:	69e2                	ld	s3,24(sp)
    8000324e:	6a42                	ld	s4,16(sp)
    80003250:	6121                	addi	sp,sp,64
    80003252:	8082                	ret
    iput(ip);
    80003254:	00000097          	auipc	ra,0x0
    80003258:	a18080e7          	jalr	-1512(ra) # 80002c6c <iput>
    return -1;
    8000325c:	557d                	li	a0,-1
    8000325e:	b7e5                	j	80003246 <dirlink+0x88>
      panic("dirlink read");
    80003260:	00005517          	auipc	a0,0x5
    80003264:	23850513          	addi	a0,a0,568 # 80008498 <etext+0x498>
    80003268:	00003097          	auipc	ra,0x3
    8000326c:	9b4080e7          	jalr	-1612(ra) # 80005c1c <panic>
    panic("dirlink");
    80003270:	00005517          	auipc	a0,0x5
    80003274:	33850513          	addi	a0,a0,824 # 800085a8 <etext+0x5a8>
    80003278:	00003097          	auipc	ra,0x3
    8000327c:	9a4080e7          	jalr	-1628(ra) # 80005c1c <panic>

0000000080003280 <namei>:

struct inode*
namei(char *path)
{
    80003280:	1101                	addi	sp,sp,-32
    80003282:	ec06                	sd	ra,24(sp)
    80003284:	e822                	sd	s0,16(sp)
    80003286:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003288:	fe040613          	addi	a2,s0,-32
    8000328c:	4581                	li	a1,0
    8000328e:	00000097          	auipc	ra,0x0
    80003292:	dd0080e7          	jalr	-560(ra) # 8000305e <namex>
}
    80003296:	60e2                	ld	ra,24(sp)
    80003298:	6442                	ld	s0,16(sp)
    8000329a:	6105                	addi	sp,sp,32
    8000329c:	8082                	ret

000000008000329e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000329e:	1141                	addi	sp,sp,-16
    800032a0:	e406                	sd	ra,8(sp)
    800032a2:	e022                	sd	s0,0(sp)
    800032a4:	0800                	addi	s0,sp,16
    800032a6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800032a8:	4585                	li	a1,1
    800032aa:	00000097          	auipc	ra,0x0
    800032ae:	db4080e7          	jalr	-588(ra) # 8000305e <namex>
}
    800032b2:	60a2                	ld	ra,8(sp)
    800032b4:	6402                	ld	s0,0(sp)
    800032b6:	0141                	addi	sp,sp,16
    800032b8:	8082                	ret

00000000800032ba <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800032ba:	1101                	addi	sp,sp,-32
    800032bc:	ec06                	sd	ra,24(sp)
    800032be:	e822                	sd	s0,16(sp)
    800032c0:	e426                	sd	s1,8(sp)
    800032c2:	e04a                	sd	s2,0(sp)
    800032c4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800032c6:	00019917          	auipc	s2,0x19
    800032ca:	d5a90913          	addi	s2,s2,-678 # 8001c020 <log>
    800032ce:	01892583          	lw	a1,24(s2)
    800032d2:	02892503          	lw	a0,40(s2)
    800032d6:	fffff097          	auipc	ra,0xfffff
    800032da:	fde080e7          	jalr	-34(ra) # 800022b4 <bread>
    800032de:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800032e0:	02c92603          	lw	a2,44(s2)
    800032e4:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800032e6:	00c05f63          	blez	a2,80003304 <write_head+0x4a>
    800032ea:	00019717          	auipc	a4,0x19
    800032ee:	d6670713          	addi	a4,a4,-666 # 8001c050 <log+0x30>
    800032f2:	87aa                	mv	a5,a0
    800032f4:	060a                	slli	a2,a2,0x2
    800032f6:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800032f8:	4314                	lw	a3,0(a4)
    800032fa:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800032fc:	0711                	addi	a4,a4,4
    800032fe:	0791                	addi	a5,a5,4
    80003300:	fec79ce3          	bne	a5,a2,800032f8 <write_head+0x3e>
  }
  bwrite(buf);
    80003304:	8526                	mv	a0,s1
    80003306:	fffff097          	auipc	ra,0xfffff
    8000330a:	0a0080e7          	jalr	160(ra) # 800023a6 <bwrite>
  brelse(buf);
    8000330e:	8526                	mv	a0,s1
    80003310:	fffff097          	auipc	ra,0xfffff
    80003314:	0d4080e7          	jalr	212(ra) # 800023e4 <brelse>
}
    80003318:	60e2                	ld	ra,24(sp)
    8000331a:	6442                	ld	s0,16(sp)
    8000331c:	64a2                	ld	s1,8(sp)
    8000331e:	6902                	ld	s2,0(sp)
    80003320:	6105                	addi	sp,sp,32
    80003322:	8082                	ret

0000000080003324 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003324:	00019797          	auipc	a5,0x19
    80003328:	d287a783          	lw	a5,-728(a5) # 8001c04c <log+0x2c>
    8000332c:	0af05d63          	blez	a5,800033e6 <install_trans+0xc2>
{
    80003330:	7139                	addi	sp,sp,-64
    80003332:	fc06                	sd	ra,56(sp)
    80003334:	f822                	sd	s0,48(sp)
    80003336:	f426                	sd	s1,40(sp)
    80003338:	f04a                	sd	s2,32(sp)
    8000333a:	ec4e                	sd	s3,24(sp)
    8000333c:	e852                	sd	s4,16(sp)
    8000333e:	e456                	sd	s5,8(sp)
    80003340:	e05a                	sd	s6,0(sp)
    80003342:	0080                	addi	s0,sp,64
    80003344:	8b2a                	mv	s6,a0
    80003346:	00019a97          	auipc	s5,0x19
    8000334a:	d0aa8a93          	addi	s5,s5,-758 # 8001c050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000334e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003350:	00019997          	auipc	s3,0x19
    80003354:	cd098993          	addi	s3,s3,-816 # 8001c020 <log>
    80003358:	a00d                	j	8000337a <install_trans+0x56>
    brelse(lbuf);
    8000335a:	854a                	mv	a0,s2
    8000335c:	fffff097          	auipc	ra,0xfffff
    80003360:	088080e7          	jalr	136(ra) # 800023e4 <brelse>
    brelse(dbuf);
    80003364:	8526                	mv	a0,s1
    80003366:	fffff097          	auipc	ra,0xfffff
    8000336a:	07e080e7          	jalr	126(ra) # 800023e4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000336e:	2a05                	addiw	s4,s4,1
    80003370:	0a91                	addi	s5,s5,4
    80003372:	02c9a783          	lw	a5,44(s3)
    80003376:	04fa5e63          	bge	s4,a5,800033d2 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000337a:	0189a583          	lw	a1,24(s3)
    8000337e:	014585bb          	addw	a1,a1,s4
    80003382:	2585                	addiw	a1,a1,1
    80003384:	0289a503          	lw	a0,40(s3)
    80003388:	fffff097          	auipc	ra,0xfffff
    8000338c:	f2c080e7          	jalr	-212(ra) # 800022b4 <bread>
    80003390:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003392:	000aa583          	lw	a1,0(s5)
    80003396:	0289a503          	lw	a0,40(s3)
    8000339a:	fffff097          	auipc	ra,0xfffff
    8000339e:	f1a080e7          	jalr	-230(ra) # 800022b4 <bread>
    800033a2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800033a4:	40000613          	li	a2,1024
    800033a8:	05890593          	addi	a1,s2,88
    800033ac:	05850513          	addi	a0,a0,88
    800033b0:	ffffd097          	auipc	ra,0xffffd
    800033b4:	e26080e7          	jalr	-474(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800033b8:	8526                	mv	a0,s1
    800033ba:	fffff097          	auipc	ra,0xfffff
    800033be:	fec080e7          	jalr	-20(ra) # 800023a6 <bwrite>
    if(recovering == 0)
    800033c2:	f80b1ce3          	bnez	s6,8000335a <install_trans+0x36>
      bunpin(dbuf);
    800033c6:	8526                	mv	a0,s1
    800033c8:	fffff097          	auipc	ra,0xfffff
    800033cc:	0f4080e7          	jalr	244(ra) # 800024bc <bunpin>
    800033d0:	b769                	j	8000335a <install_trans+0x36>
}
    800033d2:	70e2                	ld	ra,56(sp)
    800033d4:	7442                	ld	s0,48(sp)
    800033d6:	74a2                	ld	s1,40(sp)
    800033d8:	7902                	ld	s2,32(sp)
    800033da:	69e2                	ld	s3,24(sp)
    800033dc:	6a42                	ld	s4,16(sp)
    800033de:	6aa2                	ld	s5,8(sp)
    800033e0:	6b02                	ld	s6,0(sp)
    800033e2:	6121                	addi	sp,sp,64
    800033e4:	8082                	ret
    800033e6:	8082                	ret

00000000800033e8 <initlog>:
{
    800033e8:	7179                	addi	sp,sp,-48
    800033ea:	f406                	sd	ra,40(sp)
    800033ec:	f022                	sd	s0,32(sp)
    800033ee:	ec26                	sd	s1,24(sp)
    800033f0:	e84a                	sd	s2,16(sp)
    800033f2:	e44e                	sd	s3,8(sp)
    800033f4:	1800                	addi	s0,sp,48
    800033f6:	892a                	mv	s2,a0
    800033f8:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800033fa:	00019497          	auipc	s1,0x19
    800033fe:	c2648493          	addi	s1,s1,-986 # 8001c020 <log>
    80003402:	00005597          	auipc	a1,0x5
    80003406:	0a658593          	addi	a1,a1,166 # 800084a8 <etext+0x4a8>
    8000340a:	8526                	mv	a0,s1
    8000340c:	00003097          	auipc	ra,0x3
    80003410:	cfa080e7          	jalr	-774(ra) # 80006106 <initlock>
  log.start = sb->logstart;
    80003414:	0149a583          	lw	a1,20(s3)
    80003418:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000341a:	0109a783          	lw	a5,16(s3)
    8000341e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003420:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003424:	854a                	mv	a0,s2
    80003426:	fffff097          	auipc	ra,0xfffff
    8000342a:	e8e080e7          	jalr	-370(ra) # 800022b4 <bread>
  log.lh.n = lh->n;
    8000342e:	4d30                	lw	a2,88(a0)
    80003430:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003432:	00c05f63          	blez	a2,80003450 <initlog+0x68>
    80003436:	87aa                	mv	a5,a0
    80003438:	00019717          	auipc	a4,0x19
    8000343c:	c1870713          	addi	a4,a4,-1000 # 8001c050 <log+0x30>
    80003440:	060a                	slli	a2,a2,0x2
    80003442:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003444:	4ff4                	lw	a3,92(a5)
    80003446:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003448:	0791                	addi	a5,a5,4
    8000344a:	0711                	addi	a4,a4,4
    8000344c:	fec79ce3          	bne	a5,a2,80003444 <initlog+0x5c>
  brelse(buf);
    80003450:	fffff097          	auipc	ra,0xfffff
    80003454:	f94080e7          	jalr	-108(ra) # 800023e4 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003458:	4505                	li	a0,1
    8000345a:	00000097          	auipc	ra,0x0
    8000345e:	eca080e7          	jalr	-310(ra) # 80003324 <install_trans>
  log.lh.n = 0;
    80003462:	00019797          	auipc	a5,0x19
    80003466:	be07a523          	sw	zero,-1046(a5) # 8001c04c <log+0x2c>
  write_head(); // clear the log
    8000346a:	00000097          	auipc	ra,0x0
    8000346e:	e50080e7          	jalr	-432(ra) # 800032ba <write_head>
}
    80003472:	70a2                	ld	ra,40(sp)
    80003474:	7402                	ld	s0,32(sp)
    80003476:	64e2                	ld	s1,24(sp)
    80003478:	6942                	ld	s2,16(sp)
    8000347a:	69a2                	ld	s3,8(sp)
    8000347c:	6145                	addi	sp,sp,48
    8000347e:	8082                	ret

0000000080003480 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003480:	1101                	addi	sp,sp,-32
    80003482:	ec06                	sd	ra,24(sp)
    80003484:	e822                	sd	s0,16(sp)
    80003486:	e426                	sd	s1,8(sp)
    80003488:	e04a                	sd	s2,0(sp)
    8000348a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000348c:	00019517          	auipc	a0,0x19
    80003490:	b9450513          	addi	a0,a0,-1132 # 8001c020 <log>
    80003494:	00003097          	auipc	ra,0x3
    80003498:	d02080e7          	jalr	-766(ra) # 80006196 <acquire>
  while(1){
    if(log.committing){
    8000349c:	00019497          	auipc	s1,0x19
    800034a0:	b8448493          	addi	s1,s1,-1148 # 8001c020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034a4:	4979                	li	s2,30
    800034a6:	a039                	j	800034b4 <begin_op+0x34>
      sleep(&log, &log.lock);
    800034a8:	85a6                	mv	a1,s1
    800034aa:	8526                	mv	a0,s1
    800034ac:	ffffe097          	auipc	ra,0xffffe
    800034b0:	096080e7          	jalr	150(ra) # 80001542 <sleep>
    if(log.committing){
    800034b4:	50dc                	lw	a5,36(s1)
    800034b6:	fbed                	bnez	a5,800034a8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800034b8:	5098                	lw	a4,32(s1)
    800034ba:	2705                	addiw	a4,a4,1
    800034bc:	0027179b          	slliw	a5,a4,0x2
    800034c0:	9fb9                	addw	a5,a5,a4
    800034c2:	0017979b          	slliw	a5,a5,0x1
    800034c6:	54d4                	lw	a3,44(s1)
    800034c8:	9fb5                	addw	a5,a5,a3
    800034ca:	00f95963          	bge	s2,a5,800034dc <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800034ce:	85a6                	mv	a1,s1
    800034d0:	8526                	mv	a0,s1
    800034d2:	ffffe097          	auipc	ra,0xffffe
    800034d6:	070080e7          	jalr	112(ra) # 80001542 <sleep>
    800034da:	bfe9                	j	800034b4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800034dc:	00019517          	auipc	a0,0x19
    800034e0:	b4450513          	addi	a0,a0,-1212 # 8001c020 <log>
    800034e4:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800034e6:	00003097          	auipc	ra,0x3
    800034ea:	d64080e7          	jalr	-668(ra) # 8000624a <release>
      break;
    }
  }
}
    800034ee:	60e2                	ld	ra,24(sp)
    800034f0:	6442                	ld	s0,16(sp)
    800034f2:	64a2                	ld	s1,8(sp)
    800034f4:	6902                	ld	s2,0(sp)
    800034f6:	6105                	addi	sp,sp,32
    800034f8:	8082                	ret

00000000800034fa <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800034fa:	7139                	addi	sp,sp,-64
    800034fc:	fc06                	sd	ra,56(sp)
    800034fe:	f822                	sd	s0,48(sp)
    80003500:	f426                	sd	s1,40(sp)
    80003502:	f04a                	sd	s2,32(sp)
    80003504:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003506:	00019497          	auipc	s1,0x19
    8000350a:	b1a48493          	addi	s1,s1,-1254 # 8001c020 <log>
    8000350e:	8526                	mv	a0,s1
    80003510:	00003097          	auipc	ra,0x3
    80003514:	c86080e7          	jalr	-890(ra) # 80006196 <acquire>
  log.outstanding -= 1;
    80003518:	509c                	lw	a5,32(s1)
    8000351a:	37fd                	addiw	a5,a5,-1
    8000351c:	0007891b          	sext.w	s2,a5
    80003520:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003522:	50dc                	lw	a5,36(s1)
    80003524:	e7b9                	bnez	a5,80003572 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    80003526:	06091163          	bnez	s2,80003588 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000352a:	00019497          	auipc	s1,0x19
    8000352e:	af648493          	addi	s1,s1,-1290 # 8001c020 <log>
    80003532:	4785                	li	a5,1
    80003534:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003536:	8526                	mv	a0,s1
    80003538:	00003097          	auipc	ra,0x3
    8000353c:	d12080e7          	jalr	-750(ra) # 8000624a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003540:	54dc                	lw	a5,44(s1)
    80003542:	06f04763          	bgtz	a5,800035b0 <end_op+0xb6>
    acquire(&log.lock);
    80003546:	00019497          	auipc	s1,0x19
    8000354a:	ada48493          	addi	s1,s1,-1318 # 8001c020 <log>
    8000354e:	8526                	mv	a0,s1
    80003550:	00003097          	auipc	ra,0x3
    80003554:	c46080e7          	jalr	-954(ra) # 80006196 <acquire>
    log.committing = 0;
    80003558:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000355c:	8526                	mv	a0,s1
    8000355e:	ffffe097          	auipc	ra,0xffffe
    80003562:	170080e7          	jalr	368(ra) # 800016ce <wakeup>
    release(&log.lock);
    80003566:	8526                	mv	a0,s1
    80003568:	00003097          	auipc	ra,0x3
    8000356c:	ce2080e7          	jalr	-798(ra) # 8000624a <release>
}
    80003570:	a815                	j	800035a4 <end_op+0xaa>
    80003572:	ec4e                	sd	s3,24(sp)
    80003574:	e852                	sd	s4,16(sp)
    80003576:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003578:	00005517          	auipc	a0,0x5
    8000357c:	f3850513          	addi	a0,a0,-200 # 800084b0 <etext+0x4b0>
    80003580:	00002097          	auipc	ra,0x2
    80003584:	69c080e7          	jalr	1692(ra) # 80005c1c <panic>
    wakeup(&log);
    80003588:	00019497          	auipc	s1,0x19
    8000358c:	a9848493          	addi	s1,s1,-1384 # 8001c020 <log>
    80003590:	8526                	mv	a0,s1
    80003592:	ffffe097          	auipc	ra,0xffffe
    80003596:	13c080e7          	jalr	316(ra) # 800016ce <wakeup>
  release(&log.lock);
    8000359a:	8526                	mv	a0,s1
    8000359c:	00003097          	auipc	ra,0x3
    800035a0:	cae080e7          	jalr	-850(ra) # 8000624a <release>
}
    800035a4:	70e2                	ld	ra,56(sp)
    800035a6:	7442                	ld	s0,48(sp)
    800035a8:	74a2                	ld	s1,40(sp)
    800035aa:	7902                	ld	s2,32(sp)
    800035ac:	6121                	addi	sp,sp,64
    800035ae:	8082                	ret
    800035b0:	ec4e                	sd	s3,24(sp)
    800035b2:	e852                	sd	s4,16(sp)
    800035b4:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800035b6:	00019a97          	auipc	s5,0x19
    800035ba:	a9aa8a93          	addi	s5,s5,-1382 # 8001c050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800035be:	00019a17          	auipc	s4,0x19
    800035c2:	a62a0a13          	addi	s4,s4,-1438 # 8001c020 <log>
    800035c6:	018a2583          	lw	a1,24(s4)
    800035ca:	012585bb          	addw	a1,a1,s2
    800035ce:	2585                	addiw	a1,a1,1
    800035d0:	028a2503          	lw	a0,40(s4)
    800035d4:	fffff097          	auipc	ra,0xfffff
    800035d8:	ce0080e7          	jalr	-800(ra) # 800022b4 <bread>
    800035dc:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800035de:	000aa583          	lw	a1,0(s5)
    800035e2:	028a2503          	lw	a0,40(s4)
    800035e6:	fffff097          	auipc	ra,0xfffff
    800035ea:	cce080e7          	jalr	-818(ra) # 800022b4 <bread>
    800035ee:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800035f0:	40000613          	li	a2,1024
    800035f4:	05850593          	addi	a1,a0,88
    800035f8:	05848513          	addi	a0,s1,88
    800035fc:	ffffd097          	auipc	ra,0xffffd
    80003600:	bda080e7          	jalr	-1062(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003604:	8526                	mv	a0,s1
    80003606:	fffff097          	auipc	ra,0xfffff
    8000360a:	da0080e7          	jalr	-608(ra) # 800023a6 <bwrite>
    brelse(from);
    8000360e:	854e                	mv	a0,s3
    80003610:	fffff097          	auipc	ra,0xfffff
    80003614:	dd4080e7          	jalr	-556(ra) # 800023e4 <brelse>
    brelse(to);
    80003618:	8526                	mv	a0,s1
    8000361a:	fffff097          	auipc	ra,0xfffff
    8000361e:	dca080e7          	jalr	-566(ra) # 800023e4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003622:	2905                	addiw	s2,s2,1
    80003624:	0a91                	addi	s5,s5,4
    80003626:	02ca2783          	lw	a5,44(s4)
    8000362a:	f8f94ee3          	blt	s2,a5,800035c6 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000362e:	00000097          	auipc	ra,0x0
    80003632:	c8c080e7          	jalr	-884(ra) # 800032ba <write_head>
    install_trans(0); // Now install writes to home locations
    80003636:	4501                	li	a0,0
    80003638:	00000097          	auipc	ra,0x0
    8000363c:	cec080e7          	jalr	-788(ra) # 80003324 <install_trans>
    log.lh.n = 0;
    80003640:	00019797          	auipc	a5,0x19
    80003644:	a007a623          	sw	zero,-1524(a5) # 8001c04c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003648:	00000097          	auipc	ra,0x0
    8000364c:	c72080e7          	jalr	-910(ra) # 800032ba <write_head>
    80003650:	69e2                	ld	s3,24(sp)
    80003652:	6a42                	ld	s4,16(sp)
    80003654:	6aa2                	ld	s5,8(sp)
    80003656:	bdc5                	j	80003546 <end_op+0x4c>

0000000080003658 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003658:	1101                	addi	sp,sp,-32
    8000365a:	ec06                	sd	ra,24(sp)
    8000365c:	e822                	sd	s0,16(sp)
    8000365e:	e426                	sd	s1,8(sp)
    80003660:	e04a                	sd	s2,0(sp)
    80003662:	1000                	addi	s0,sp,32
    80003664:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003666:	00019917          	auipc	s2,0x19
    8000366a:	9ba90913          	addi	s2,s2,-1606 # 8001c020 <log>
    8000366e:	854a                	mv	a0,s2
    80003670:	00003097          	auipc	ra,0x3
    80003674:	b26080e7          	jalr	-1242(ra) # 80006196 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003678:	02c92603          	lw	a2,44(s2)
    8000367c:	47f5                	li	a5,29
    8000367e:	06c7c563          	blt	a5,a2,800036e8 <log_write+0x90>
    80003682:	00019797          	auipc	a5,0x19
    80003686:	9ba7a783          	lw	a5,-1606(a5) # 8001c03c <log+0x1c>
    8000368a:	37fd                	addiw	a5,a5,-1
    8000368c:	04f65e63          	bge	a2,a5,800036e8 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003690:	00019797          	auipc	a5,0x19
    80003694:	9b07a783          	lw	a5,-1616(a5) # 8001c040 <log+0x20>
    80003698:	06f05063          	blez	a5,800036f8 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000369c:	4781                	li	a5,0
    8000369e:	06c05563          	blez	a2,80003708 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036a2:	44cc                	lw	a1,12(s1)
    800036a4:	00019717          	auipc	a4,0x19
    800036a8:	9ac70713          	addi	a4,a4,-1620 # 8001c050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800036ac:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800036ae:	4314                	lw	a3,0(a4)
    800036b0:	04b68c63          	beq	a3,a1,80003708 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800036b4:	2785                	addiw	a5,a5,1
    800036b6:	0711                	addi	a4,a4,4
    800036b8:	fef61be3          	bne	a2,a5,800036ae <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800036bc:	0621                	addi	a2,a2,8
    800036be:	060a                	slli	a2,a2,0x2
    800036c0:	00019797          	auipc	a5,0x19
    800036c4:	96078793          	addi	a5,a5,-1696 # 8001c020 <log>
    800036c8:	97b2                	add	a5,a5,a2
    800036ca:	44d8                	lw	a4,12(s1)
    800036cc:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800036ce:	8526                	mv	a0,s1
    800036d0:	fffff097          	auipc	ra,0xfffff
    800036d4:	db0080e7          	jalr	-592(ra) # 80002480 <bpin>
    log.lh.n++;
    800036d8:	00019717          	auipc	a4,0x19
    800036dc:	94870713          	addi	a4,a4,-1720 # 8001c020 <log>
    800036e0:	575c                	lw	a5,44(a4)
    800036e2:	2785                	addiw	a5,a5,1
    800036e4:	d75c                	sw	a5,44(a4)
    800036e6:	a82d                	j	80003720 <log_write+0xc8>
    panic("too big a transaction");
    800036e8:	00005517          	auipc	a0,0x5
    800036ec:	dd850513          	addi	a0,a0,-552 # 800084c0 <etext+0x4c0>
    800036f0:	00002097          	auipc	ra,0x2
    800036f4:	52c080e7          	jalr	1324(ra) # 80005c1c <panic>
    panic("log_write outside of trans");
    800036f8:	00005517          	auipc	a0,0x5
    800036fc:	de050513          	addi	a0,a0,-544 # 800084d8 <etext+0x4d8>
    80003700:	00002097          	auipc	ra,0x2
    80003704:	51c080e7          	jalr	1308(ra) # 80005c1c <panic>
  log.lh.block[i] = b->blockno;
    80003708:	00878693          	addi	a3,a5,8
    8000370c:	068a                	slli	a3,a3,0x2
    8000370e:	00019717          	auipc	a4,0x19
    80003712:	91270713          	addi	a4,a4,-1774 # 8001c020 <log>
    80003716:	9736                	add	a4,a4,a3
    80003718:	44d4                	lw	a3,12(s1)
    8000371a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000371c:	faf609e3          	beq	a2,a5,800036ce <log_write+0x76>
  }
  release(&log.lock);
    80003720:	00019517          	auipc	a0,0x19
    80003724:	90050513          	addi	a0,a0,-1792 # 8001c020 <log>
    80003728:	00003097          	auipc	ra,0x3
    8000372c:	b22080e7          	jalr	-1246(ra) # 8000624a <release>
}
    80003730:	60e2                	ld	ra,24(sp)
    80003732:	6442                	ld	s0,16(sp)
    80003734:	64a2                	ld	s1,8(sp)
    80003736:	6902                	ld	s2,0(sp)
    80003738:	6105                	addi	sp,sp,32
    8000373a:	8082                	ret

000000008000373c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000373c:	1101                	addi	sp,sp,-32
    8000373e:	ec06                	sd	ra,24(sp)
    80003740:	e822                	sd	s0,16(sp)
    80003742:	e426                	sd	s1,8(sp)
    80003744:	e04a                	sd	s2,0(sp)
    80003746:	1000                	addi	s0,sp,32
    80003748:	84aa                	mv	s1,a0
    8000374a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000374c:	00005597          	auipc	a1,0x5
    80003750:	dac58593          	addi	a1,a1,-596 # 800084f8 <etext+0x4f8>
    80003754:	0521                	addi	a0,a0,8
    80003756:	00003097          	auipc	ra,0x3
    8000375a:	9b0080e7          	jalr	-1616(ra) # 80006106 <initlock>
  lk->name = name;
    8000375e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003762:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003766:	0204a423          	sw	zero,40(s1)
}
    8000376a:	60e2                	ld	ra,24(sp)
    8000376c:	6442                	ld	s0,16(sp)
    8000376e:	64a2                	ld	s1,8(sp)
    80003770:	6902                	ld	s2,0(sp)
    80003772:	6105                	addi	sp,sp,32
    80003774:	8082                	ret

0000000080003776 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003776:	1101                	addi	sp,sp,-32
    80003778:	ec06                	sd	ra,24(sp)
    8000377a:	e822                	sd	s0,16(sp)
    8000377c:	e426                	sd	s1,8(sp)
    8000377e:	e04a                	sd	s2,0(sp)
    80003780:	1000                	addi	s0,sp,32
    80003782:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003784:	00850913          	addi	s2,a0,8
    80003788:	854a                	mv	a0,s2
    8000378a:	00003097          	auipc	ra,0x3
    8000378e:	a0c080e7          	jalr	-1524(ra) # 80006196 <acquire>
  while (lk->locked) {
    80003792:	409c                	lw	a5,0(s1)
    80003794:	cb89                	beqz	a5,800037a6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003796:	85ca                	mv	a1,s2
    80003798:	8526                	mv	a0,s1
    8000379a:	ffffe097          	auipc	ra,0xffffe
    8000379e:	da8080e7          	jalr	-600(ra) # 80001542 <sleep>
  while (lk->locked) {
    800037a2:	409c                	lw	a5,0(s1)
    800037a4:	fbed                	bnez	a5,80003796 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800037a6:	4785                	li	a5,1
    800037a8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800037aa:	ffffd097          	auipc	ra,0xffffd
    800037ae:	6d2080e7          	jalr	1746(ra) # 80000e7c <myproc>
    800037b2:	591c                	lw	a5,48(a0)
    800037b4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800037b6:	854a                	mv	a0,s2
    800037b8:	00003097          	auipc	ra,0x3
    800037bc:	a92080e7          	jalr	-1390(ra) # 8000624a <release>
}
    800037c0:	60e2                	ld	ra,24(sp)
    800037c2:	6442                	ld	s0,16(sp)
    800037c4:	64a2                	ld	s1,8(sp)
    800037c6:	6902                	ld	s2,0(sp)
    800037c8:	6105                	addi	sp,sp,32
    800037ca:	8082                	ret

00000000800037cc <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800037cc:	1101                	addi	sp,sp,-32
    800037ce:	ec06                	sd	ra,24(sp)
    800037d0:	e822                	sd	s0,16(sp)
    800037d2:	e426                	sd	s1,8(sp)
    800037d4:	e04a                	sd	s2,0(sp)
    800037d6:	1000                	addi	s0,sp,32
    800037d8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037da:	00850913          	addi	s2,a0,8
    800037de:	854a                	mv	a0,s2
    800037e0:	00003097          	auipc	ra,0x3
    800037e4:	9b6080e7          	jalr	-1610(ra) # 80006196 <acquire>
  lk->locked = 0;
    800037e8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037ec:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800037f0:	8526                	mv	a0,s1
    800037f2:	ffffe097          	auipc	ra,0xffffe
    800037f6:	edc080e7          	jalr	-292(ra) # 800016ce <wakeup>
  release(&lk->lk);
    800037fa:	854a                	mv	a0,s2
    800037fc:	00003097          	auipc	ra,0x3
    80003800:	a4e080e7          	jalr	-1458(ra) # 8000624a <release>
}
    80003804:	60e2                	ld	ra,24(sp)
    80003806:	6442                	ld	s0,16(sp)
    80003808:	64a2                	ld	s1,8(sp)
    8000380a:	6902                	ld	s2,0(sp)
    8000380c:	6105                	addi	sp,sp,32
    8000380e:	8082                	ret

0000000080003810 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003810:	7179                	addi	sp,sp,-48
    80003812:	f406                	sd	ra,40(sp)
    80003814:	f022                	sd	s0,32(sp)
    80003816:	ec26                	sd	s1,24(sp)
    80003818:	e84a                	sd	s2,16(sp)
    8000381a:	1800                	addi	s0,sp,48
    8000381c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000381e:	00850913          	addi	s2,a0,8
    80003822:	854a                	mv	a0,s2
    80003824:	00003097          	auipc	ra,0x3
    80003828:	972080e7          	jalr	-1678(ra) # 80006196 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000382c:	409c                	lw	a5,0(s1)
    8000382e:	ef91                	bnez	a5,8000384a <holdingsleep+0x3a>
    80003830:	4481                	li	s1,0
  release(&lk->lk);
    80003832:	854a                	mv	a0,s2
    80003834:	00003097          	auipc	ra,0x3
    80003838:	a16080e7          	jalr	-1514(ra) # 8000624a <release>
  return r;
}
    8000383c:	8526                	mv	a0,s1
    8000383e:	70a2                	ld	ra,40(sp)
    80003840:	7402                	ld	s0,32(sp)
    80003842:	64e2                	ld	s1,24(sp)
    80003844:	6942                	ld	s2,16(sp)
    80003846:	6145                	addi	sp,sp,48
    80003848:	8082                	ret
    8000384a:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000384c:	0284a983          	lw	s3,40(s1)
    80003850:	ffffd097          	auipc	ra,0xffffd
    80003854:	62c080e7          	jalr	1580(ra) # 80000e7c <myproc>
    80003858:	5904                	lw	s1,48(a0)
    8000385a:	413484b3          	sub	s1,s1,s3
    8000385e:	0014b493          	seqz	s1,s1
    80003862:	69a2                	ld	s3,8(sp)
    80003864:	b7f9                	j	80003832 <holdingsleep+0x22>

0000000080003866 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003866:	1141                	addi	sp,sp,-16
    80003868:	e406                	sd	ra,8(sp)
    8000386a:	e022                	sd	s0,0(sp)
    8000386c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000386e:	00005597          	auipc	a1,0x5
    80003872:	c9a58593          	addi	a1,a1,-870 # 80008508 <etext+0x508>
    80003876:	00019517          	auipc	a0,0x19
    8000387a:	8f250513          	addi	a0,a0,-1806 # 8001c168 <ftable>
    8000387e:	00003097          	auipc	ra,0x3
    80003882:	888080e7          	jalr	-1912(ra) # 80006106 <initlock>
}
    80003886:	60a2                	ld	ra,8(sp)
    80003888:	6402                	ld	s0,0(sp)
    8000388a:	0141                	addi	sp,sp,16
    8000388c:	8082                	ret

000000008000388e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000388e:	1101                	addi	sp,sp,-32
    80003890:	ec06                	sd	ra,24(sp)
    80003892:	e822                	sd	s0,16(sp)
    80003894:	e426                	sd	s1,8(sp)
    80003896:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003898:	00019517          	auipc	a0,0x19
    8000389c:	8d050513          	addi	a0,a0,-1840 # 8001c168 <ftable>
    800038a0:	00003097          	auipc	ra,0x3
    800038a4:	8f6080e7          	jalr	-1802(ra) # 80006196 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038a8:	00019497          	auipc	s1,0x19
    800038ac:	8d848493          	addi	s1,s1,-1832 # 8001c180 <ftable+0x18>
    800038b0:	0001a717          	auipc	a4,0x1a
    800038b4:	87070713          	addi	a4,a4,-1936 # 8001d120 <ftable+0xfb8>
    if(f->ref == 0){
    800038b8:	40dc                	lw	a5,4(s1)
    800038ba:	cf99                	beqz	a5,800038d8 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800038bc:	02848493          	addi	s1,s1,40
    800038c0:	fee49ce3          	bne	s1,a4,800038b8 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800038c4:	00019517          	auipc	a0,0x19
    800038c8:	8a450513          	addi	a0,a0,-1884 # 8001c168 <ftable>
    800038cc:	00003097          	auipc	ra,0x3
    800038d0:	97e080e7          	jalr	-1666(ra) # 8000624a <release>
  return 0;
    800038d4:	4481                	li	s1,0
    800038d6:	a819                	j	800038ec <filealloc+0x5e>
      f->ref = 1;
    800038d8:	4785                	li	a5,1
    800038da:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800038dc:	00019517          	auipc	a0,0x19
    800038e0:	88c50513          	addi	a0,a0,-1908 # 8001c168 <ftable>
    800038e4:	00003097          	auipc	ra,0x3
    800038e8:	966080e7          	jalr	-1690(ra) # 8000624a <release>
}
    800038ec:	8526                	mv	a0,s1
    800038ee:	60e2                	ld	ra,24(sp)
    800038f0:	6442                	ld	s0,16(sp)
    800038f2:	64a2                	ld	s1,8(sp)
    800038f4:	6105                	addi	sp,sp,32
    800038f6:	8082                	ret

00000000800038f8 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800038f8:	1101                	addi	sp,sp,-32
    800038fa:	ec06                	sd	ra,24(sp)
    800038fc:	e822                	sd	s0,16(sp)
    800038fe:	e426                	sd	s1,8(sp)
    80003900:	1000                	addi	s0,sp,32
    80003902:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003904:	00019517          	auipc	a0,0x19
    80003908:	86450513          	addi	a0,a0,-1948 # 8001c168 <ftable>
    8000390c:	00003097          	auipc	ra,0x3
    80003910:	88a080e7          	jalr	-1910(ra) # 80006196 <acquire>
  if(f->ref < 1)
    80003914:	40dc                	lw	a5,4(s1)
    80003916:	02f05263          	blez	a5,8000393a <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000391a:	2785                	addiw	a5,a5,1
    8000391c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000391e:	00019517          	auipc	a0,0x19
    80003922:	84a50513          	addi	a0,a0,-1974 # 8001c168 <ftable>
    80003926:	00003097          	auipc	ra,0x3
    8000392a:	924080e7          	jalr	-1756(ra) # 8000624a <release>
  return f;
}
    8000392e:	8526                	mv	a0,s1
    80003930:	60e2                	ld	ra,24(sp)
    80003932:	6442                	ld	s0,16(sp)
    80003934:	64a2                	ld	s1,8(sp)
    80003936:	6105                	addi	sp,sp,32
    80003938:	8082                	ret
    panic("filedup");
    8000393a:	00005517          	auipc	a0,0x5
    8000393e:	bd650513          	addi	a0,a0,-1066 # 80008510 <etext+0x510>
    80003942:	00002097          	auipc	ra,0x2
    80003946:	2da080e7          	jalr	730(ra) # 80005c1c <panic>

000000008000394a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000394a:	7139                	addi	sp,sp,-64
    8000394c:	fc06                	sd	ra,56(sp)
    8000394e:	f822                	sd	s0,48(sp)
    80003950:	f426                	sd	s1,40(sp)
    80003952:	0080                	addi	s0,sp,64
    80003954:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003956:	00019517          	auipc	a0,0x19
    8000395a:	81250513          	addi	a0,a0,-2030 # 8001c168 <ftable>
    8000395e:	00003097          	auipc	ra,0x3
    80003962:	838080e7          	jalr	-1992(ra) # 80006196 <acquire>
  if(f->ref < 1)
    80003966:	40dc                	lw	a5,4(s1)
    80003968:	04f05c63          	blez	a5,800039c0 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    8000396c:	37fd                	addiw	a5,a5,-1
    8000396e:	0007871b          	sext.w	a4,a5
    80003972:	c0dc                	sw	a5,4(s1)
    80003974:	06e04263          	bgtz	a4,800039d8 <fileclose+0x8e>
    80003978:	f04a                	sd	s2,32(sp)
    8000397a:	ec4e                	sd	s3,24(sp)
    8000397c:	e852                	sd	s4,16(sp)
    8000397e:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003980:	0004a903          	lw	s2,0(s1)
    80003984:	0094ca83          	lbu	s5,9(s1)
    80003988:	0104ba03          	ld	s4,16(s1)
    8000398c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003990:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003994:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003998:	00018517          	auipc	a0,0x18
    8000399c:	7d050513          	addi	a0,a0,2000 # 8001c168 <ftable>
    800039a0:	00003097          	auipc	ra,0x3
    800039a4:	8aa080e7          	jalr	-1878(ra) # 8000624a <release>

  if(ff.type == FD_PIPE){
    800039a8:	4785                	li	a5,1
    800039aa:	04f90463          	beq	s2,a5,800039f2 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800039ae:	3979                	addiw	s2,s2,-2
    800039b0:	4785                	li	a5,1
    800039b2:	0527fb63          	bgeu	a5,s2,80003a08 <fileclose+0xbe>
    800039b6:	7902                	ld	s2,32(sp)
    800039b8:	69e2                	ld	s3,24(sp)
    800039ba:	6a42                	ld	s4,16(sp)
    800039bc:	6aa2                	ld	s5,8(sp)
    800039be:	a02d                	j	800039e8 <fileclose+0x9e>
    800039c0:	f04a                	sd	s2,32(sp)
    800039c2:	ec4e                	sd	s3,24(sp)
    800039c4:	e852                	sd	s4,16(sp)
    800039c6:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800039c8:	00005517          	auipc	a0,0x5
    800039cc:	b5050513          	addi	a0,a0,-1200 # 80008518 <etext+0x518>
    800039d0:	00002097          	auipc	ra,0x2
    800039d4:	24c080e7          	jalr	588(ra) # 80005c1c <panic>
    release(&ftable.lock);
    800039d8:	00018517          	auipc	a0,0x18
    800039dc:	79050513          	addi	a0,a0,1936 # 8001c168 <ftable>
    800039e0:	00003097          	auipc	ra,0x3
    800039e4:	86a080e7          	jalr	-1942(ra) # 8000624a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800039e8:	70e2                	ld	ra,56(sp)
    800039ea:	7442                	ld	s0,48(sp)
    800039ec:	74a2                	ld	s1,40(sp)
    800039ee:	6121                	addi	sp,sp,64
    800039f0:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800039f2:	85d6                	mv	a1,s5
    800039f4:	8552                	mv	a0,s4
    800039f6:	00000097          	auipc	ra,0x0
    800039fa:	3a2080e7          	jalr	930(ra) # 80003d98 <pipeclose>
    800039fe:	7902                	ld	s2,32(sp)
    80003a00:	69e2                	ld	s3,24(sp)
    80003a02:	6a42                	ld	s4,16(sp)
    80003a04:	6aa2                	ld	s5,8(sp)
    80003a06:	b7cd                	j	800039e8 <fileclose+0x9e>
    begin_op();
    80003a08:	00000097          	auipc	ra,0x0
    80003a0c:	a78080e7          	jalr	-1416(ra) # 80003480 <begin_op>
    iput(ff.ip);
    80003a10:	854e                	mv	a0,s3
    80003a12:	fffff097          	auipc	ra,0xfffff
    80003a16:	25a080e7          	jalr	602(ra) # 80002c6c <iput>
    end_op();
    80003a1a:	00000097          	auipc	ra,0x0
    80003a1e:	ae0080e7          	jalr	-1312(ra) # 800034fa <end_op>
    80003a22:	7902                	ld	s2,32(sp)
    80003a24:	69e2                	ld	s3,24(sp)
    80003a26:	6a42                	ld	s4,16(sp)
    80003a28:	6aa2                	ld	s5,8(sp)
    80003a2a:	bf7d                	j	800039e8 <fileclose+0x9e>

0000000080003a2c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a2c:	715d                	addi	sp,sp,-80
    80003a2e:	e486                	sd	ra,72(sp)
    80003a30:	e0a2                	sd	s0,64(sp)
    80003a32:	fc26                	sd	s1,56(sp)
    80003a34:	f44e                	sd	s3,40(sp)
    80003a36:	0880                	addi	s0,sp,80
    80003a38:	84aa                	mv	s1,a0
    80003a3a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003a3c:	ffffd097          	auipc	ra,0xffffd
    80003a40:	440080e7          	jalr	1088(ra) # 80000e7c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003a44:	409c                	lw	a5,0(s1)
    80003a46:	37f9                	addiw	a5,a5,-2
    80003a48:	4705                	li	a4,1
    80003a4a:	04f76863          	bltu	a4,a5,80003a9a <filestat+0x6e>
    80003a4e:	f84a                	sd	s2,48(sp)
    80003a50:	892a                	mv	s2,a0
    ilock(f->ip);
    80003a52:	6c88                	ld	a0,24(s1)
    80003a54:	fffff097          	auipc	ra,0xfffff
    80003a58:	05a080e7          	jalr	90(ra) # 80002aae <ilock>
    stati(f->ip, &st);
    80003a5c:	fb840593          	addi	a1,s0,-72
    80003a60:	6c88                	ld	a0,24(s1)
    80003a62:	fffff097          	auipc	ra,0xfffff
    80003a66:	2da080e7          	jalr	730(ra) # 80002d3c <stati>
    iunlock(f->ip);
    80003a6a:	6c88                	ld	a0,24(s1)
    80003a6c:	fffff097          	auipc	ra,0xfffff
    80003a70:	108080e7          	jalr	264(ra) # 80002b74 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003a74:	46e1                	li	a3,24
    80003a76:	fb840613          	addi	a2,s0,-72
    80003a7a:	85ce                	mv	a1,s3
    80003a7c:	05093503          	ld	a0,80(s2)
    80003a80:	ffffd097          	auipc	ra,0xffffd
    80003a84:	098080e7          	jalr	152(ra) # 80000b18 <copyout>
    80003a88:	41f5551b          	sraiw	a0,a0,0x1f
    80003a8c:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003a8e:	60a6                	ld	ra,72(sp)
    80003a90:	6406                	ld	s0,64(sp)
    80003a92:	74e2                	ld	s1,56(sp)
    80003a94:	79a2                	ld	s3,40(sp)
    80003a96:	6161                	addi	sp,sp,80
    80003a98:	8082                	ret
  return -1;
    80003a9a:	557d                	li	a0,-1
    80003a9c:	bfcd                	j	80003a8e <filestat+0x62>

0000000080003a9e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003a9e:	7179                	addi	sp,sp,-48
    80003aa0:	f406                	sd	ra,40(sp)
    80003aa2:	f022                	sd	s0,32(sp)
    80003aa4:	e84a                	sd	s2,16(sp)
    80003aa6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003aa8:	00854783          	lbu	a5,8(a0)
    80003aac:	cbc5                	beqz	a5,80003b5c <fileread+0xbe>
    80003aae:	ec26                	sd	s1,24(sp)
    80003ab0:	e44e                	sd	s3,8(sp)
    80003ab2:	84aa                	mv	s1,a0
    80003ab4:	89ae                	mv	s3,a1
    80003ab6:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ab8:	411c                	lw	a5,0(a0)
    80003aba:	4705                	li	a4,1
    80003abc:	04e78963          	beq	a5,a4,80003b0e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ac0:	470d                	li	a4,3
    80003ac2:	04e78f63          	beq	a5,a4,80003b20 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ac6:	4709                	li	a4,2
    80003ac8:	08e79263          	bne	a5,a4,80003b4c <fileread+0xae>
    ilock(f->ip);
    80003acc:	6d08                	ld	a0,24(a0)
    80003ace:	fffff097          	auipc	ra,0xfffff
    80003ad2:	fe0080e7          	jalr	-32(ra) # 80002aae <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ad6:	874a                	mv	a4,s2
    80003ad8:	5094                	lw	a3,32(s1)
    80003ada:	864e                	mv	a2,s3
    80003adc:	4585                	li	a1,1
    80003ade:	6c88                	ld	a0,24(s1)
    80003ae0:	fffff097          	auipc	ra,0xfffff
    80003ae4:	286080e7          	jalr	646(ra) # 80002d66 <readi>
    80003ae8:	892a                	mv	s2,a0
    80003aea:	00a05563          	blez	a0,80003af4 <fileread+0x56>
      f->off += r;
    80003aee:	509c                	lw	a5,32(s1)
    80003af0:	9fa9                	addw	a5,a5,a0
    80003af2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003af4:	6c88                	ld	a0,24(s1)
    80003af6:	fffff097          	auipc	ra,0xfffff
    80003afa:	07e080e7          	jalr	126(ra) # 80002b74 <iunlock>
    80003afe:	64e2                	ld	s1,24(sp)
    80003b00:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003b02:	854a                	mv	a0,s2
    80003b04:	70a2                	ld	ra,40(sp)
    80003b06:	7402                	ld	s0,32(sp)
    80003b08:	6942                	ld	s2,16(sp)
    80003b0a:	6145                	addi	sp,sp,48
    80003b0c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b0e:	6908                	ld	a0,16(a0)
    80003b10:	00000097          	auipc	ra,0x0
    80003b14:	3fa080e7          	jalr	1018(ra) # 80003f0a <piperead>
    80003b18:	892a                	mv	s2,a0
    80003b1a:	64e2                	ld	s1,24(sp)
    80003b1c:	69a2                	ld	s3,8(sp)
    80003b1e:	b7d5                	j	80003b02 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b20:	02451783          	lh	a5,36(a0)
    80003b24:	03079693          	slli	a3,a5,0x30
    80003b28:	92c1                	srli	a3,a3,0x30
    80003b2a:	4725                	li	a4,9
    80003b2c:	02d76a63          	bltu	a4,a3,80003b60 <fileread+0xc2>
    80003b30:	0792                	slli	a5,a5,0x4
    80003b32:	00018717          	auipc	a4,0x18
    80003b36:	59670713          	addi	a4,a4,1430 # 8001c0c8 <devsw>
    80003b3a:	97ba                	add	a5,a5,a4
    80003b3c:	639c                	ld	a5,0(a5)
    80003b3e:	c78d                	beqz	a5,80003b68 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003b40:	4505                	li	a0,1
    80003b42:	9782                	jalr	a5
    80003b44:	892a                	mv	s2,a0
    80003b46:	64e2                	ld	s1,24(sp)
    80003b48:	69a2                	ld	s3,8(sp)
    80003b4a:	bf65                	j	80003b02 <fileread+0x64>
    panic("fileread");
    80003b4c:	00005517          	auipc	a0,0x5
    80003b50:	9dc50513          	addi	a0,a0,-1572 # 80008528 <etext+0x528>
    80003b54:	00002097          	auipc	ra,0x2
    80003b58:	0c8080e7          	jalr	200(ra) # 80005c1c <panic>
    return -1;
    80003b5c:	597d                	li	s2,-1
    80003b5e:	b755                	j	80003b02 <fileread+0x64>
      return -1;
    80003b60:	597d                	li	s2,-1
    80003b62:	64e2                	ld	s1,24(sp)
    80003b64:	69a2                	ld	s3,8(sp)
    80003b66:	bf71                	j	80003b02 <fileread+0x64>
    80003b68:	597d                	li	s2,-1
    80003b6a:	64e2                	ld	s1,24(sp)
    80003b6c:	69a2                	ld	s3,8(sp)
    80003b6e:	bf51                	j	80003b02 <fileread+0x64>

0000000080003b70 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003b70:	00954783          	lbu	a5,9(a0)
    80003b74:	12078963          	beqz	a5,80003ca6 <filewrite+0x136>
{
    80003b78:	715d                	addi	sp,sp,-80
    80003b7a:	e486                	sd	ra,72(sp)
    80003b7c:	e0a2                	sd	s0,64(sp)
    80003b7e:	f84a                	sd	s2,48(sp)
    80003b80:	f052                	sd	s4,32(sp)
    80003b82:	e85a                	sd	s6,16(sp)
    80003b84:	0880                	addi	s0,sp,80
    80003b86:	892a                	mv	s2,a0
    80003b88:	8b2e                	mv	s6,a1
    80003b8a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b8c:	411c                	lw	a5,0(a0)
    80003b8e:	4705                	li	a4,1
    80003b90:	02e78763          	beq	a5,a4,80003bbe <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b94:	470d                	li	a4,3
    80003b96:	02e78a63          	beq	a5,a4,80003bca <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b9a:	4709                	li	a4,2
    80003b9c:	0ee79863          	bne	a5,a4,80003c8c <filewrite+0x11c>
    80003ba0:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ba2:	0cc05463          	blez	a2,80003c6a <filewrite+0xfa>
    80003ba6:	fc26                	sd	s1,56(sp)
    80003ba8:	ec56                	sd	s5,24(sp)
    80003baa:	e45e                	sd	s7,8(sp)
    80003bac:	e062                	sd	s8,0(sp)
    int i = 0;
    80003bae:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003bb0:	6b85                	lui	s7,0x1
    80003bb2:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003bb6:	6c05                	lui	s8,0x1
    80003bb8:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003bbc:	a851                	j	80003c50 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003bbe:	6908                	ld	a0,16(a0)
    80003bc0:	00000097          	auipc	ra,0x0
    80003bc4:	248080e7          	jalr	584(ra) # 80003e08 <pipewrite>
    80003bc8:	a85d                	j	80003c7e <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003bca:	02451783          	lh	a5,36(a0)
    80003bce:	03079693          	slli	a3,a5,0x30
    80003bd2:	92c1                	srli	a3,a3,0x30
    80003bd4:	4725                	li	a4,9
    80003bd6:	0cd76a63          	bltu	a4,a3,80003caa <filewrite+0x13a>
    80003bda:	0792                	slli	a5,a5,0x4
    80003bdc:	00018717          	auipc	a4,0x18
    80003be0:	4ec70713          	addi	a4,a4,1260 # 8001c0c8 <devsw>
    80003be4:	97ba                	add	a5,a5,a4
    80003be6:	679c                	ld	a5,8(a5)
    80003be8:	c3f9                	beqz	a5,80003cae <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003bea:	4505                	li	a0,1
    80003bec:	9782                	jalr	a5
    80003bee:	a841                	j	80003c7e <filewrite+0x10e>
      if(n1 > max)
    80003bf0:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003bf4:	00000097          	auipc	ra,0x0
    80003bf8:	88c080e7          	jalr	-1908(ra) # 80003480 <begin_op>
      ilock(f->ip);
    80003bfc:	01893503          	ld	a0,24(s2)
    80003c00:	fffff097          	auipc	ra,0xfffff
    80003c04:	eae080e7          	jalr	-338(ra) # 80002aae <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c08:	8756                	mv	a4,s5
    80003c0a:	02092683          	lw	a3,32(s2)
    80003c0e:	01698633          	add	a2,s3,s6
    80003c12:	4585                	li	a1,1
    80003c14:	01893503          	ld	a0,24(s2)
    80003c18:	fffff097          	auipc	ra,0xfffff
    80003c1c:	252080e7          	jalr	594(ra) # 80002e6a <writei>
    80003c20:	84aa                	mv	s1,a0
    80003c22:	00a05763          	blez	a0,80003c30 <filewrite+0xc0>
        f->off += r;
    80003c26:	02092783          	lw	a5,32(s2)
    80003c2a:	9fa9                	addw	a5,a5,a0
    80003c2c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c30:	01893503          	ld	a0,24(s2)
    80003c34:	fffff097          	auipc	ra,0xfffff
    80003c38:	f40080e7          	jalr	-192(ra) # 80002b74 <iunlock>
      end_op();
    80003c3c:	00000097          	auipc	ra,0x0
    80003c40:	8be080e7          	jalr	-1858(ra) # 800034fa <end_op>

      if(r != n1){
    80003c44:	029a9563          	bne	s5,s1,80003c6e <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003c48:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003c4c:	0149da63          	bge	s3,s4,80003c60 <filewrite+0xf0>
      int n1 = n - i;
    80003c50:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003c54:	0004879b          	sext.w	a5,s1
    80003c58:	f8fbdce3          	bge	s7,a5,80003bf0 <filewrite+0x80>
    80003c5c:	84e2                	mv	s1,s8
    80003c5e:	bf49                	j	80003bf0 <filewrite+0x80>
    80003c60:	74e2                	ld	s1,56(sp)
    80003c62:	6ae2                	ld	s5,24(sp)
    80003c64:	6ba2                	ld	s7,8(sp)
    80003c66:	6c02                	ld	s8,0(sp)
    80003c68:	a039                	j	80003c76 <filewrite+0x106>
    int i = 0;
    80003c6a:	4981                	li	s3,0
    80003c6c:	a029                	j	80003c76 <filewrite+0x106>
    80003c6e:	74e2                	ld	s1,56(sp)
    80003c70:	6ae2                	ld	s5,24(sp)
    80003c72:	6ba2                	ld	s7,8(sp)
    80003c74:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003c76:	033a1e63          	bne	s4,s3,80003cb2 <filewrite+0x142>
    80003c7a:	8552                	mv	a0,s4
    80003c7c:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003c7e:	60a6                	ld	ra,72(sp)
    80003c80:	6406                	ld	s0,64(sp)
    80003c82:	7942                	ld	s2,48(sp)
    80003c84:	7a02                	ld	s4,32(sp)
    80003c86:	6b42                	ld	s6,16(sp)
    80003c88:	6161                	addi	sp,sp,80
    80003c8a:	8082                	ret
    80003c8c:	fc26                	sd	s1,56(sp)
    80003c8e:	f44e                	sd	s3,40(sp)
    80003c90:	ec56                	sd	s5,24(sp)
    80003c92:	e45e                	sd	s7,8(sp)
    80003c94:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003c96:	00005517          	auipc	a0,0x5
    80003c9a:	8a250513          	addi	a0,a0,-1886 # 80008538 <etext+0x538>
    80003c9e:	00002097          	auipc	ra,0x2
    80003ca2:	f7e080e7          	jalr	-130(ra) # 80005c1c <panic>
    return -1;
    80003ca6:	557d                	li	a0,-1
}
    80003ca8:	8082                	ret
      return -1;
    80003caa:	557d                	li	a0,-1
    80003cac:	bfc9                	j	80003c7e <filewrite+0x10e>
    80003cae:	557d                	li	a0,-1
    80003cb0:	b7f9                	j	80003c7e <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003cb2:	557d                	li	a0,-1
    80003cb4:	79a2                	ld	s3,40(sp)
    80003cb6:	b7e1                	j	80003c7e <filewrite+0x10e>

0000000080003cb8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003cb8:	7179                	addi	sp,sp,-48
    80003cba:	f406                	sd	ra,40(sp)
    80003cbc:	f022                	sd	s0,32(sp)
    80003cbe:	ec26                	sd	s1,24(sp)
    80003cc0:	e052                	sd	s4,0(sp)
    80003cc2:	1800                	addi	s0,sp,48
    80003cc4:	84aa                	mv	s1,a0
    80003cc6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003cc8:	0005b023          	sd	zero,0(a1)
    80003ccc:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003cd0:	00000097          	auipc	ra,0x0
    80003cd4:	bbe080e7          	jalr	-1090(ra) # 8000388e <filealloc>
    80003cd8:	e088                	sd	a0,0(s1)
    80003cda:	cd49                	beqz	a0,80003d74 <pipealloc+0xbc>
    80003cdc:	00000097          	auipc	ra,0x0
    80003ce0:	bb2080e7          	jalr	-1102(ra) # 8000388e <filealloc>
    80003ce4:	00aa3023          	sd	a0,0(s4)
    80003ce8:	c141                	beqz	a0,80003d68 <pipealloc+0xb0>
    80003cea:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003cec:	ffffc097          	auipc	ra,0xffffc
    80003cf0:	42e080e7          	jalr	1070(ra) # 8000011a <kalloc>
    80003cf4:	892a                	mv	s2,a0
    80003cf6:	c13d                	beqz	a0,80003d5c <pipealloc+0xa4>
    80003cf8:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003cfa:	4985                	li	s3,1
    80003cfc:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d00:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d04:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d08:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d0c:	00005597          	auipc	a1,0x5
    80003d10:	83c58593          	addi	a1,a1,-1988 # 80008548 <etext+0x548>
    80003d14:	00002097          	auipc	ra,0x2
    80003d18:	3f2080e7          	jalr	1010(ra) # 80006106 <initlock>
  (*f0)->type = FD_PIPE;
    80003d1c:	609c                	ld	a5,0(s1)
    80003d1e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d22:	609c                	ld	a5,0(s1)
    80003d24:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d28:	609c                	ld	a5,0(s1)
    80003d2a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d2e:	609c                	ld	a5,0(s1)
    80003d30:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d34:	000a3783          	ld	a5,0(s4)
    80003d38:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003d3c:	000a3783          	ld	a5,0(s4)
    80003d40:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003d44:	000a3783          	ld	a5,0(s4)
    80003d48:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003d4c:	000a3783          	ld	a5,0(s4)
    80003d50:	0127b823          	sd	s2,16(a5)
  return 0;
    80003d54:	4501                	li	a0,0
    80003d56:	6942                	ld	s2,16(sp)
    80003d58:	69a2                	ld	s3,8(sp)
    80003d5a:	a03d                	j	80003d88 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003d5c:	6088                	ld	a0,0(s1)
    80003d5e:	c119                	beqz	a0,80003d64 <pipealloc+0xac>
    80003d60:	6942                	ld	s2,16(sp)
    80003d62:	a029                	j	80003d6c <pipealloc+0xb4>
    80003d64:	6942                	ld	s2,16(sp)
    80003d66:	a039                	j	80003d74 <pipealloc+0xbc>
    80003d68:	6088                	ld	a0,0(s1)
    80003d6a:	c50d                	beqz	a0,80003d94 <pipealloc+0xdc>
    fileclose(*f0);
    80003d6c:	00000097          	auipc	ra,0x0
    80003d70:	bde080e7          	jalr	-1058(ra) # 8000394a <fileclose>
  if(*f1)
    80003d74:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003d78:	557d                	li	a0,-1
  if(*f1)
    80003d7a:	c799                	beqz	a5,80003d88 <pipealloc+0xd0>
    fileclose(*f1);
    80003d7c:	853e                	mv	a0,a5
    80003d7e:	00000097          	auipc	ra,0x0
    80003d82:	bcc080e7          	jalr	-1076(ra) # 8000394a <fileclose>
  return -1;
    80003d86:	557d                	li	a0,-1
}
    80003d88:	70a2                	ld	ra,40(sp)
    80003d8a:	7402                	ld	s0,32(sp)
    80003d8c:	64e2                	ld	s1,24(sp)
    80003d8e:	6a02                	ld	s4,0(sp)
    80003d90:	6145                	addi	sp,sp,48
    80003d92:	8082                	ret
  return -1;
    80003d94:	557d                	li	a0,-1
    80003d96:	bfcd                	j	80003d88 <pipealloc+0xd0>

0000000080003d98 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003d98:	1101                	addi	sp,sp,-32
    80003d9a:	ec06                	sd	ra,24(sp)
    80003d9c:	e822                	sd	s0,16(sp)
    80003d9e:	e426                	sd	s1,8(sp)
    80003da0:	e04a                	sd	s2,0(sp)
    80003da2:	1000                	addi	s0,sp,32
    80003da4:	84aa                	mv	s1,a0
    80003da6:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003da8:	00002097          	auipc	ra,0x2
    80003dac:	3ee080e7          	jalr	1006(ra) # 80006196 <acquire>
  if(writable){
    80003db0:	02090d63          	beqz	s2,80003dea <pipeclose+0x52>
    pi->writeopen = 0;
    80003db4:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003db8:	21848513          	addi	a0,s1,536
    80003dbc:	ffffe097          	auipc	ra,0xffffe
    80003dc0:	912080e7          	jalr	-1774(ra) # 800016ce <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003dc4:	2204b783          	ld	a5,544(s1)
    80003dc8:	eb95                	bnez	a5,80003dfc <pipeclose+0x64>
    release(&pi->lock);
    80003dca:	8526                	mv	a0,s1
    80003dcc:	00002097          	auipc	ra,0x2
    80003dd0:	47e080e7          	jalr	1150(ra) # 8000624a <release>
    kfree((char*)pi);
    80003dd4:	8526                	mv	a0,s1
    80003dd6:	ffffc097          	auipc	ra,0xffffc
    80003dda:	246080e7          	jalr	582(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003dde:	60e2                	ld	ra,24(sp)
    80003de0:	6442                	ld	s0,16(sp)
    80003de2:	64a2                	ld	s1,8(sp)
    80003de4:	6902                	ld	s2,0(sp)
    80003de6:	6105                	addi	sp,sp,32
    80003de8:	8082                	ret
    pi->readopen = 0;
    80003dea:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003dee:	21c48513          	addi	a0,s1,540
    80003df2:	ffffe097          	auipc	ra,0xffffe
    80003df6:	8dc080e7          	jalr	-1828(ra) # 800016ce <wakeup>
    80003dfa:	b7e9                	j	80003dc4 <pipeclose+0x2c>
    release(&pi->lock);
    80003dfc:	8526                	mv	a0,s1
    80003dfe:	00002097          	auipc	ra,0x2
    80003e02:	44c080e7          	jalr	1100(ra) # 8000624a <release>
}
    80003e06:	bfe1                	j	80003dde <pipeclose+0x46>

0000000080003e08 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e08:	711d                	addi	sp,sp,-96
    80003e0a:	ec86                	sd	ra,88(sp)
    80003e0c:	e8a2                	sd	s0,80(sp)
    80003e0e:	e4a6                	sd	s1,72(sp)
    80003e10:	e0ca                	sd	s2,64(sp)
    80003e12:	fc4e                	sd	s3,56(sp)
    80003e14:	f852                	sd	s4,48(sp)
    80003e16:	f456                	sd	s5,40(sp)
    80003e18:	1080                	addi	s0,sp,96
    80003e1a:	84aa                	mv	s1,a0
    80003e1c:	8aae                	mv	s5,a1
    80003e1e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e20:	ffffd097          	auipc	ra,0xffffd
    80003e24:	05c080e7          	jalr	92(ra) # 80000e7c <myproc>
    80003e28:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e2a:	8526                	mv	a0,s1
    80003e2c:	00002097          	auipc	ra,0x2
    80003e30:	36a080e7          	jalr	874(ra) # 80006196 <acquire>
  while(i < n){
    80003e34:	0d405563          	blez	s4,80003efe <pipewrite+0xf6>
    80003e38:	f05a                	sd	s6,32(sp)
    80003e3a:	ec5e                	sd	s7,24(sp)
    80003e3c:	e862                	sd	s8,16(sp)
  int i = 0;
    80003e3e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003e40:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003e42:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003e46:	21c48b93          	addi	s7,s1,540
    80003e4a:	a089                	j	80003e8c <pipewrite+0x84>
      release(&pi->lock);
    80003e4c:	8526                	mv	a0,s1
    80003e4e:	00002097          	auipc	ra,0x2
    80003e52:	3fc080e7          	jalr	1020(ra) # 8000624a <release>
      return -1;
    80003e56:	597d                	li	s2,-1
    80003e58:	7b02                	ld	s6,32(sp)
    80003e5a:	6be2                	ld	s7,24(sp)
    80003e5c:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003e5e:	854a                	mv	a0,s2
    80003e60:	60e6                	ld	ra,88(sp)
    80003e62:	6446                	ld	s0,80(sp)
    80003e64:	64a6                	ld	s1,72(sp)
    80003e66:	6906                	ld	s2,64(sp)
    80003e68:	79e2                	ld	s3,56(sp)
    80003e6a:	7a42                	ld	s4,48(sp)
    80003e6c:	7aa2                	ld	s5,40(sp)
    80003e6e:	6125                	addi	sp,sp,96
    80003e70:	8082                	ret
      wakeup(&pi->nread);
    80003e72:	8562                	mv	a0,s8
    80003e74:	ffffe097          	auipc	ra,0xffffe
    80003e78:	85a080e7          	jalr	-1958(ra) # 800016ce <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003e7c:	85a6                	mv	a1,s1
    80003e7e:	855e                	mv	a0,s7
    80003e80:	ffffd097          	auipc	ra,0xffffd
    80003e84:	6c2080e7          	jalr	1730(ra) # 80001542 <sleep>
  while(i < n){
    80003e88:	05495c63          	bge	s2,s4,80003ee0 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    80003e8c:	2204a783          	lw	a5,544(s1)
    80003e90:	dfd5                	beqz	a5,80003e4c <pipewrite+0x44>
    80003e92:	0289a783          	lw	a5,40(s3)
    80003e96:	fbdd                	bnez	a5,80003e4c <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003e98:	2184a783          	lw	a5,536(s1)
    80003e9c:	21c4a703          	lw	a4,540(s1)
    80003ea0:	2007879b          	addiw	a5,a5,512
    80003ea4:	fcf707e3          	beq	a4,a5,80003e72 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ea8:	4685                	li	a3,1
    80003eaa:	01590633          	add	a2,s2,s5
    80003eae:	faf40593          	addi	a1,s0,-81
    80003eb2:	0509b503          	ld	a0,80(s3)
    80003eb6:	ffffd097          	auipc	ra,0xffffd
    80003eba:	cee080e7          	jalr	-786(ra) # 80000ba4 <copyin>
    80003ebe:	05650263          	beq	a0,s6,80003f02 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003ec2:	21c4a783          	lw	a5,540(s1)
    80003ec6:	0017871b          	addiw	a4,a5,1
    80003eca:	20e4ae23          	sw	a4,540(s1)
    80003ece:	1ff7f793          	andi	a5,a5,511
    80003ed2:	97a6                	add	a5,a5,s1
    80003ed4:	faf44703          	lbu	a4,-81(s0)
    80003ed8:	00e78c23          	sb	a4,24(a5)
      i++;
    80003edc:	2905                	addiw	s2,s2,1
    80003ede:	b76d                	j	80003e88 <pipewrite+0x80>
    80003ee0:	7b02                	ld	s6,32(sp)
    80003ee2:	6be2                	ld	s7,24(sp)
    80003ee4:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003ee6:	21848513          	addi	a0,s1,536
    80003eea:	ffffd097          	auipc	ra,0xffffd
    80003eee:	7e4080e7          	jalr	2020(ra) # 800016ce <wakeup>
  release(&pi->lock);
    80003ef2:	8526                	mv	a0,s1
    80003ef4:	00002097          	auipc	ra,0x2
    80003ef8:	356080e7          	jalr	854(ra) # 8000624a <release>
  return i;
    80003efc:	b78d                	j	80003e5e <pipewrite+0x56>
  int i = 0;
    80003efe:	4901                	li	s2,0
    80003f00:	b7dd                	j	80003ee6 <pipewrite+0xde>
    80003f02:	7b02                	ld	s6,32(sp)
    80003f04:	6be2                	ld	s7,24(sp)
    80003f06:	6c42                	ld	s8,16(sp)
    80003f08:	bff9                	j	80003ee6 <pipewrite+0xde>

0000000080003f0a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f0a:	715d                	addi	sp,sp,-80
    80003f0c:	e486                	sd	ra,72(sp)
    80003f0e:	e0a2                	sd	s0,64(sp)
    80003f10:	fc26                	sd	s1,56(sp)
    80003f12:	f84a                	sd	s2,48(sp)
    80003f14:	f44e                	sd	s3,40(sp)
    80003f16:	f052                	sd	s4,32(sp)
    80003f18:	ec56                	sd	s5,24(sp)
    80003f1a:	0880                	addi	s0,sp,80
    80003f1c:	84aa                	mv	s1,a0
    80003f1e:	892e                	mv	s2,a1
    80003f20:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f22:	ffffd097          	auipc	ra,0xffffd
    80003f26:	f5a080e7          	jalr	-166(ra) # 80000e7c <myproc>
    80003f2a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f2c:	8526                	mv	a0,s1
    80003f2e:	00002097          	auipc	ra,0x2
    80003f32:	268080e7          	jalr	616(ra) # 80006196 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f36:	2184a703          	lw	a4,536(s1)
    80003f3a:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f3e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f42:	02f71663          	bne	a4,a5,80003f6e <piperead+0x64>
    80003f46:	2244a783          	lw	a5,548(s1)
    80003f4a:	cb9d                	beqz	a5,80003f80 <piperead+0x76>
    if(pr->killed){
    80003f4c:	028a2783          	lw	a5,40(s4)
    80003f50:	e38d                	bnez	a5,80003f72 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003f52:	85a6                	mv	a1,s1
    80003f54:	854e                	mv	a0,s3
    80003f56:	ffffd097          	auipc	ra,0xffffd
    80003f5a:	5ec080e7          	jalr	1516(ra) # 80001542 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f5e:	2184a703          	lw	a4,536(s1)
    80003f62:	21c4a783          	lw	a5,540(s1)
    80003f66:	fef700e3          	beq	a4,a5,80003f46 <piperead+0x3c>
    80003f6a:	e85a                	sd	s6,16(sp)
    80003f6c:	a819                	j	80003f82 <piperead+0x78>
    80003f6e:	e85a                	sd	s6,16(sp)
    80003f70:	a809                	j	80003f82 <piperead+0x78>
      release(&pi->lock);
    80003f72:	8526                	mv	a0,s1
    80003f74:	00002097          	auipc	ra,0x2
    80003f78:	2d6080e7          	jalr	726(ra) # 8000624a <release>
      return -1;
    80003f7c:	59fd                	li	s3,-1
    80003f7e:	a0a5                	j	80003fe6 <piperead+0xdc>
    80003f80:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f82:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003f84:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003f86:	05505463          	blez	s5,80003fce <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    80003f8a:	2184a783          	lw	a5,536(s1)
    80003f8e:	21c4a703          	lw	a4,540(s1)
    80003f92:	02f70e63          	beq	a4,a5,80003fce <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003f96:	0017871b          	addiw	a4,a5,1
    80003f9a:	20e4ac23          	sw	a4,536(s1)
    80003f9e:	1ff7f793          	andi	a5,a5,511
    80003fa2:	97a6                	add	a5,a5,s1
    80003fa4:	0187c783          	lbu	a5,24(a5)
    80003fa8:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fac:	4685                	li	a3,1
    80003fae:	fbf40613          	addi	a2,s0,-65
    80003fb2:	85ca                	mv	a1,s2
    80003fb4:	050a3503          	ld	a0,80(s4)
    80003fb8:	ffffd097          	auipc	ra,0xffffd
    80003fbc:	b60080e7          	jalr	-1184(ra) # 80000b18 <copyout>
    80003fc0:	01650763          	beq	a0,s6,80003fce <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fc4:	2985                	addiw	s3,s3,1
    80003fc6:	0905                	addi	s2,s2,1
    80003fc8:	fd3a91e3          	bne	s5,s3,80003f8a <piperead+0x80>
    80003fcc:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003fce:	21c48513          	addi	a0,s1,540
    80003fd2:	ffffd097          	auipc	ra,0xffffd
    80003fd6:	6fc080e7          	jalr	1788(ra) # 800016ce <wakeup>
  release(&pi->lock);
    80003fda:	8526                	mv	a0,s1
    80003fdc:	00002097          	auipc	ra,0x2
    80003fe0:	26e080e7          	jalr	622(ra) # 8000624a <release>
    80003fe4:	6b42                	ld	s6,16(sp)
  return i;
}
    80003fe6:	854e                	mv	a0,s3
    80003fe8:	60a6                	ld	ra,72(sp)
    80003fea:	6406                	ld	s0,64(sp)
    80003fec:	74e2                	ld	s1,56(sp)
    80003fee:	7942                	ld	s2,48(sp)
    80003ff0:	79a2                	ld	s3,40(sp)
    80003ff2:	7a02                	ld	s4,32(sp)
    80003ff4:	6ae2                	ld	s5,24(sp)
    80003ff6:	6161                	addi	sp,sp,80
    80003ff8:	8082                	ret

0000000080003ffa <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80003ffa:	df010113          	addi	sp,sp,-528
    80003ffe:	20113423          	sd	ra,520(sp)
    80004002:	20813023          	sd	s0,512(sp)
    80004006:	ffa6                	sd	s1,504(sp)
    80004008:	fbca                	sd	s2,496(sp)
    8000400a:	0c00                	addi	s0,sp,528
    8000400c:	892a                	mv	s2,a0
    8000400e:	dea43c23          	sd	a0,-520(s0)
    80004012:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004016:	ffffd097          	auipc	ra,0xffffd
    8000401a:	e66080e7          	jalr	-410(ra) # 80000e7c <myproc>
    8000401e:	84aa                	mv	s1,a0

  begin_op();
    80004020:	fffff097          	auipc	ra,0xfffff
    80004024:	460080e7          	jalr	1120(ra) # 80003480 <begin_op>

  if((ip = namei(path)) == 0){
    80004028:	854a                	mv	a0,s2
    8000402a:	fffff097          	auipc	ra,0xfffff
    8000402e:	256080e7          	jalr	598(ra) # 80003280 <namei>
    80004032:	c135                	beqz	a0,80004096 <exec+0x9c>
    80004034:	f3d2                	sd	s4,480(sp)
    80004036:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004038:	fffff097          	auipc	ra,0xfffff
    8000403c:	a76080e7          	jalr	-1418(ra) # 80002aae <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004040:	04000713          	li	a4,64
    80004044:	4681                	li	a3,0
    80004046:	e5040613          	addi	a2,s0,-432
    8000404a:	4581                	li	a1,0
    8000404c:	8552                	mv	a0,s4
    8000404e:	fffff097          	auipc	ra,0xfffff
    80004052:	d18080e7          	jalr	-744(ra) # 80002d66 <readi>
    80004056:	04000793          	li	a5,64
    8000405a:	00f51a63          	bne	a0,a5,8000406e <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000405e:	e5042703          	lw	a4,-432(s0)
    80004062:	464c47b7          	lui	a5,0x464c4
    80004066:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000406a:	02f70c63          	beq	a4,a5,800040a2 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000406e:	8552                	mv	a0,s4
    80004070:	fffff097          	auipc	ra,0xfffff
    80004074:	ca4080e7          	jalr	-860(ra) # 80002d14 <iunlockput>
    end_op();
    80004078:	fffff097          	auipc	ra,0xfffff
    8000407c:	482080e7          	jalr	1154(ra) # 800034fa <end_op>
  }
  return -1;
    80004080:	557d                	li	a0,-1
    80004082:	7a1e                	ld	s4,480(sp)
}
    80004084:	20813083          	ld	ra,520(sp)
    80004088:	20013403          	ld	s0,512(sp)
    8000408c:	74fe                	ld	s1,504(sp)
    8000408e:	795e                	ld	s2,496(sp)
    80004090:	21010113          	addi	sp,sp,528
    80004094:	8082                	ret
    end_op();
    80004096:	fffff097          	auipc	ra,0xfffff
    8000409a:	464080e7          	jalr	1124(ra) # 800034fa <end_op>
    return -1;
    8000409e:	557d                	li	a0,-1
    800040a0:	b7d5                	j	80004084 <exec+0x8a>
    800040a2:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800040a4:	8526                	mv	a0,s1
    800040a6:	ffffd097          	auipc	ra,0xffffd
    800040aa:	e9a080e7          	jalr	-358(ra) # 80000f40 <proc_pagetable>
    800040ae:	8b2a                	mv	s6,a0
    800040b0:	30050563          	beqz	a0,800043ba <exec+0x3c0>
    800040b4:	f7ce                	sd	s3,488(sp)
    800040b6:	efd6                	sd	s5,472(sp)
    800040b8:	e7de                	sd	s7,456(sp)
    800040ba:	e3e2                	sd	s8,448(sp)
    800040bc:	ff66                	sd	s9,440(sp)
    800040be:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040c0:	e7042d03          	lw	s10,-400(s0)
    800040c4:	e8845783          	lhu	a5,-376(s0)
    800040c8:	14078563          	beqz	a5,80004212 <exec+0x218>
    800040cc:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800040ce:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800040d0:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    800040d2:	6c85                	lui	s9,0x1
    800040d4:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800040d8:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800040dc:	6a85                	lui	s5,0x1
    800040de:	a0b5                	j	8000414a <exec+0x150>
      panic("loadseg: address should exist");
    800040e0:	00004517          	auipc	a0,0x4
    800040e4:	47050513          	addi	a0,a0,1136 # 80008550 <etext+0x550>
    800040e8:	00002097          	auipc	ra,0x2
    800040ec:	b34080e7          	jalr	-1228(ra) # 80005c1c <panic>
    if(sz - i < PGSIZE)
    800040f0:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800040f2:	8726                	mv	a4,s1
    800040f4:	012c06bb          	addw	a3,s8,s2
    800040f8:	4581                	li	a1,0
    800040fa:	8552                	mv	a0,s4
    800040fc:	fffff097          	auipc	ra,0xfffff
    80004100:	c6a080e7          	jalr	-918(ra) # 80002d66 <readi>
    80004104:	2501                	sext.w	a0,a0
    80004106:	26a49e63          	bne	s1,a0,80004382 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    8000410a:	012a893b          	addw	s2,s5,s2
    8000410e:	03397563          	bgeu	s2,s3,80004138 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80004112:	02091593          	slli	a1,s2,0x20
    80004116:	9181                	srli	a1,a1,0x20
    80004118:	95de                	add	a1,a1,s7
    8000411a:	855a                	mv	a0,s6
    8000411c:	ffffc097          	auipc	ra,0xffffc
    80004120:	3dc080e7          	jalr	988(ra) # 800004f8 <walkaddr>
    80004124:	862a                	mv	a2,a0
    if(pa == 0)
    80004126:	dd4d                	beqz	a0,800040e0 <exec+0xe6>
    if(sz - i < PGSIZE)
    80004128:	412984bb          	subw	s1,s3,s2
    8000412c:	0004879b          	sext.w	a5,s1
    80004130:	fcfcf0e3          	bgeu	s9,a5,800040f0 <exec+0xf6>
    80004134:	84d6                	mv	s1,s5
    80004136:	bf6d                	j	800040f0 <exec+0xf6>
    sz = sz1;
    80004138:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000413c:	2d85                	addiw	s11,s11,1
    8000413e:	038d0d1b          	addiw	s10,s10,56
    80004142:	e8845783          	lhu	a5,-376(s0)
    80004146:	06fddf63          	bge	s11,a5,800041c4 <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000414a:	2d01                	sext.w	s10,s10
    8000414c:	03800713          	li	a4,56
    80004150:	86ea                	mv	a3,s10
    80004152:	e1840613          	addi	a2,s0,-488
    80004156:	4581                	li	a1,0
    80004158:	8552                	mv	a0,s4
    8000415a:	fffff097          	auipc	ra,0xfffff
    8000415e:	c0c080e7          	jalr	-1012(ra) # 80002d66 <readi>
    80004162:	03800793          	li	a5,56
    80004166:	1ef51863          	bne	a0,a5,80004356 <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    8000416a:	e1842783          	lw	a5,-488(s0)
    8000416e:	4705                	li	a4,1
    80004170:	fce796e3          	bne	a5,a4,8000413c <exec+0x142>
    if(ph.memsz < ph.filesz)
    80004174:	e4043603          	ld	a2,-448(s0)
    80004178:	e3843783          	ld	a5,-456(s0)
    8000417c:	1ef66163          	bltu	a2,a5,8000435e <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004180:	e2843783          	ld	a5,-472(s0)
    80004184:	963e                	add	a2,a2,a5
    80004186:	1ef66063          	bltu	a2,a5,80004366 <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000418a:	85a6                	mv	a1,s1
    8000418c:	855a                	mv	a0,s6
    8000418e:	ffffc097          	auipc	ra,0xffffc
    80004192:	72e080e7          	jalr	1838(ra) # 800008bc <uvmalloc>
    80004196:	e0a43423          	sd	a0,-504(s0)
    8000419a:	1c050a63          	beqz	a0,8000436e <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    8000419e:	e2843b83          	ld	s7,-472(s0)
    800041a2:	df043783          	ld	a5,-528(s0)
    800041a6:	00fbf7b3          	and	a5,s7,a5
    800041aa:	1c079a63          	bnez	a5,8000437e <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800041ae:	e2042c03          	lw	s8,-480(s0)
    800041b2:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800041b6:	00098463          	beqz	s3,800041be <exec+0x1c4>
    800041ba:	4901                	li	s2,0
    800041bc:	bf99                	j	80004112 <exec+0x118>
    sz = sz1;
    800041be:	e0843483          	ld	s1,-504(s0)
    800041c2:	bfad                	j	8000413c <exec+0x142>
    800041c4:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800041c6:	8552                	mv	a0,s4
    800041c8:	fffff097          	auipc	ra,0xfffff
    800041cc:	b4c080e7          	jalr	-1204(ra) # 80002d14 <iunlockput>
  end_op();
    800041d0:	fffff097          	auipc	ra,0xfffff
    800041d4:	32a080e7          	jalr	810(ra) # 800034fa <end_op>
  p = myproc();
    800041d8:	ffffd097          	auipc	ra,0xffffd
    800041dc:	ca4080e7          	jalr	-860(ra) # 80000e7c <myproc>
    800041e0:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800041e2:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800041e6:	6985                	lui	s3,0x1
    800041e8:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800041ea:	99a6                	add	s3,s3,s1
    800041ec:	77fd                	lui	a5,0xfffff
    800041ee:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800041f2:	6609                	lui	a2,0x2
    800041f4:	964e                	add	a2,a2,s3
    800041f6:	85ce                	mv	a1,s3
    800041f8:	855a                	mv	a0,s6
    800041fa:	ffffc097          	auipc	ra,0xffffc
    800041fe:	6c2080e7          	jalr	1730(ra) # 800008bc <uvmalloc>
    80004202:	892a                	mv	s2,a0
    80004204:	e0a43423          	sd	a0,-504(s0)
    80004208:	e519                	bnez	a0,80004216 <exec+0x21c>
  if(pagetable)
    8000420a:	e1343423          	sd	s3,-504(s0)
    8000420e:	4a01                	li	s4,0
    80004210:	aa95                	j	80004384 <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004212:	4481                	li	s1,0
    80004214:	bf4d                	j	800041c6 <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004216:	75f9                	lui	a1,0xffffe
    80004218:	95aa                	add	a1,a1,a0
    8000421a:	855a                	mv	a0,s6
    8000421c:	ffffd097          	auipc	ra,0xffffd
    80004220:	8ca080e7          	jalr	-1846(ra) # 80000ae6 <uvmclear>
  stackbase = sp - PGSIZE;
    80004224:	7bfd                	lui	s7,0xfffff
    80004226:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004228:	e0043783          	ld	a5,-512(s0)
    8000422c:	6388                	ld	a0,0(a5)
    8000422e:	c52d                	beqz	a0,80004298 <exec+0x29e>
    80004230:	e9040993          	addi	s3,s0,-368
    80004234:	f9040c13          	addi	s8,s0,-112
    80004238:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000423a:	ffffc097          	auipc	ra,0xffffc
    8000423e:	0b4080e7          	jalr	180(ra) # 800002ee <strlen>
    80004242:	0015079b          	addiw	a5,a0,1
    80004246:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000424a:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000424e:	13796463          	bltu	s2,s7,80004376 <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004252:	e0043d03          	ld	s10,-512(s0)
    80004256:	000d3a03          	ld	s4,0(s10)
    8000425a:	8552                	mv	a0,s4
    8000425c:	ffffc097          	auipc	ra,0xffffc
    80004260:	092080e7          	jalr	146(ra) # 800002ee <strlen>
    80004264:	0015069b          	addiw	a3,a0,1
    80004268:	8652                	mv	a2,s4
    8000426a:	85ca                	mv	a1,s2
    8000426c:	855a                	mv	a0,s6
    8000426e:	ffffd097          	auipc	ra,0xffffd
    80004272:	8aa080e7          	jalr	-1878(ra) # 80000b18 <copyout>
    80004276:	10054263          	bltz	a0,8000437a <exec+0x380>
    ustack[argc] = sp;
    8000427a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000427e:	0485                	addi	s1,s1,1
    80004280:	008d0793          	addi	a5,s10,8
    80004284:	e0f43023          	sd	a5,-512(s0)
    80004288:	008d3503          	ld	a0,8(s10)
    8000428c:	c909                	beqz	a0,8000429e <exec+0x2a4>
    if(argc >= MAXARG)
    8000428e:	09a1                	addi	s3,s3,8
    80004290:	fb8995e3          	bne	s3,s8,8000423a <exec+0x240>
  ip = 0;
    80004294:	4a01                	li	s4,0
    80004296:	a0fd                	j	80004384 <exec+0x38a>
  sp = sz;
    80004298:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000429c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000429e:	00349793          	slli	a5,s1,0x3
    800042a2:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd5d50>
    800042a6:	97a2                	add	a5,a5,s0
    800042a8:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800042ac:	00148693          	addi	a3,s1,1
    800042b0:	068e                	slli	a3,a3,0x3
    800042b2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042b6:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800042ba:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800042be:	f57966e3          	bltu	s2,s7,8000420a <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800042c2:	e9040613          	addi	a2,s0,-368
    800042c6:	85ca                	mv	a1,s2
    800042c8:	855a                	mv	a0,s6
    800042ca:	ffffd097          	auipc	ra,0xffffd
    800042ce:	84e080e7          	jalr	-1970(ra) # 80000b18 <copyout>
    800042d2:	0e054663          	bltz	a0,800043be <exec+0x3c4>
  p->trapframe->a1 = sp;
    800042d6:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800042da:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800042de:	df843783          	ld	a5,-520(s0)
    800042e2:	0007c703          	lbu	a4,0(a5)
    800042e6:	cf11                	beqz	a4,80004302 <exec+0x308>
    800042e8:	0785                	addi	a5,a5,1
    if(*s == '/')
    800042ea:	02f00693          	li	a3,47
    800042ee:	a039                	j	800042fc <exec+0x302>
      last = s+1;
    800042f0:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800042f4:	0785                	addi	a5,a5,1
    800042f6:	fff7c703          	lbu	a4,-1(a5)
    800042fa:	c701                	beqz	a4,80004302 <exec+0x308>
    if(*s == '/')
    800042fc:	fed71ce3          	bne	a4,a3,800042f4 <exec+0x2fa>
    80004300:	bfc5                	j	800042f0 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004302:	4641                	li	a2,16
    80004304:	df843583          	ld	a1,-520(s0)
    80004308:	158a8513          	addi	a0,s5,344
    8000430c:	ffffc097          	auipc	ra,0xffffc
    80004310:	fb0080e7          	jalr	-80(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    80004314:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004318:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000431c:	e0843783          	ld	a5,-504(s0)
    80004320:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004324:	058ab783          	ld	a5,88(s5)
    80004328:	e6843703          	ld	a4,-408(s0)
    8000432c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000432e:	058ab783          	ld	a5,88(s5)
    80004332:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004336:	85e6                	mv	a1,s9
    80004338:	ffffd097          	auipc	ra,0xffffd
    8000433c:	ca4080e7          	jalr	-860(ra) # 80000fdc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004340:	0004851b          	sext.w	a0,s1
    80004344:	79be                	ld	s3,488(sp)
    80004346:	7a1e                	ld	s4,480(sp)
    80004348:	6afe                	ld	s5,472(sp)
    8000434a:	6b5e                	ld	s6,464(sp)
    8000434c:	6bbe                	ld	s7,456(sp)
    8000434e:	6c1e                	ld	s8,448(sp)
    80004350:	7cfa                	ld	s9,440(sp)
    80004352:	7d5a                	ld	s10,432(sp)
    80004354:	bb05                	j	80004084 <exec+0x8a>
    80004356:	e0943423          	sd	s1,-504(s0)
    8000435a:	7dba                	ld	s11,424(sp)
    8000435c:	a025                	j	80004384 <exec+0x38a>
    8000435e:	e0943423          	sd	s1,-504(s0)
    80004362:	7dba                	ld	s11,424(sp)
    80004364:	a005                	j	80004384 <exec+0x38a>
    80004366:	e0943423          	sd	s1,-504(s0)
    8000436a:	7dba                	ld	s11,424(sp)
    8000436c:	a821                	j	80004384 <exec+0x38a>
    8000436e:	e0943423          	sd	s1,-504(s0)
    80004372:	7dba                	ld	s11,424(sp)
    80004374:	a801                	j	80004384 <exec+0x38a>
  ip = 0;
    80004376:	4a01                	li	s4,0
    80004378:	a031                	j	80004384 <exec+0x38a>
    8000437a:	4a01                	li	s4,0
  if(pagetable)
    8000437c:	a021                	j	80004384 <exec+0x38a>
    8000437e:	7dba                	ld	s11,424(sp)
    80004380:	a011                	j	80004384 <exec+0x38a>
    80004382:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004384:	e0843583          	ld	a1,-504(s0)
    80004388:	855a                	mv	a0,s6
    8000438a:	ffffd097          	auipc	ra,0xffffd
    8000438e:	c52080e7          	jalr	-942(ra) # 80000fdc <proc_freepagetable>
  return -1;
    80004392:	557d                	li	a0,-1
  if(ip){
    80004394:	000a1b63          	bnez	s4,800043aa <exec+0x3b0>
    80004398:	79be                	ld	s3,488(sp)
    8000439a:	7a1e                	ld	s4,480(sp)
    8000439c:	6afe                	ld	s5,472(sp)
    8000439e:	6b5e                	ld	s6,464(sp)
    800043a0:	6bbe                	ld	s7,456(sp)
    800043a2:	6c1e                	ld	s8,448(sp)
    800043a4:	7cfa                	ld	s9,440(sp)
    800043a6:	7d5a                	ld	s10,432(sp)
    800043a8:	b9f1                	j	80004084 <exec+0x8a>
    800043aa:	79be                	ld	s3,488(sp)
    800043ac:	6afe                	ld	s5,472(sp)
    800043ae:	6b5e                	ld	s6,464(sp)
    800043b0:	6bbe                	ld	s7,456(sp)
    800043b2:	6c1e                	ld	s8,448(sp)
    800043b4:	7cfa                	ld	s9,440(sp)
    800043b6:	7d5a                	ld	s10,432(sp)
    800043b8:	b95d                	j	8000406e <exec+0x74>
    800043ba:	6b5e                	ld	s6,464(sp)
    800043bc:	b94d                	j	8000406e <exec+0x74>
  sz = sz1;
    800043be:	e0843983          	ld	s3,-504(s0)
    800043c2:	b5a1                	j	8000420a <exec+0x210>

00000000800043c4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800043c4:	7179                	addi	sp,sp,-48
    800043c6:	f406                	sd	ra,40(sp)
    800043c8:	f022                	sd	s0,32(sp)
    800043ca:	ec26                	sd	s1,24(sp)
    800043cc:	e84a                	sd	s2,16(sp)
    800043ce:	1800                	addi	s0,sp,48
    800043d0:	892e                	mv	s2,a1
    800043d2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800043d4:	fdc40593          	addi	a1,s0,-36
    800043d8:	ffffe097          	auipc	ra,0xffffe
    800043dc:	b64080e7          	jalr	-1180(ra) # 80001f3c <argint>
    800043e0:	04054063          	bltz	a0,80004420 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800043e4:	fdc42703          	lw	a4,-36(s0)
    800043e8:	47bd                	li	a5,15
    800043ea:	02e7ed63          	bltu	a5,a4,80004424 <argfd+0x60>
    800043ee:	ffffd097          	auipc	ra,0xffffd
    800043f2:	a8e080e7          	jalr	-1394(ra) # 80000e7c <myproc>
    800043f6:	fdc42703          	lw	a4,-36(s0)
    800043fa:	01a70793          	addi	a5,a4,26
    800043fe:	078e                	slli	a5,a5,0x3
    80004400:	953e                	add	a0,a0,a5
    80004402:	611c                	ld	a5,0(a0)
    80004404:	c395                	beqz	a5,80004428 <argfd+0x64>
    return -1;
  if(pfd)
    80004406:	00090463          	beqz	s2,8000440e <argfd+0x4a>
    *pfd = fd;
    8000440a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000440e:	4501                	li	a0,0
  if(pf)
    80004410:	c091                	beqz	s1,80004414 <argfd+0x50>
    *pf = f;
    80004412:	e09c                	sd	a5,0(s1)
}
    80004414:	70a2                	ld	ra,40(sp)
    80004416:	7402                	ld	s0,32(sp)
    80004418:	64e2                	ld	s1,24(sp)
    8000441a:	6942                	ld	s2,16(sp)
    8000441c:	6145                	addi	sp,sp,48
    8000441e:	8082                	ret
    return -1;
    80004420:	557d                	li	a0,-1
    80004422:	bfcd                	j	80004414 <argfd+0x50>
    return -1;
    80004424:	557d                	li	a0,-1
    80004426:	b7fd                	j	80004414 <argfd+0x50>
    80004428:	557d                	li	a0,-1
    8000442a:	b7ed                	j	80004414 <argfd+0x50>

000000008000442c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000442c:	1101                	addi	sp,sp,-32
    8000442e:	ec06                	sd	ra,24(sp)
    80004430:	e822                	sd	s0,16(sp)
    80004432:	e426                	sd	s1,8(sp)
    80004434:	1000                	addi	s0,sp,32
    80004436:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004438:	ffffd097          	auipc	ra,0xffffd
    8000443c:	a44080e7          	jalr	-1468(ra) # 80000e7c <myproc>
    80004440:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004442:	0d050793          	addi	a5,a0,208
    80004446:	4501                	li	a0,0
    80004448:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000444a:	6398                	ld	a4,0(a5)
    8000444c:	cb19                	beqz	a4,80004462 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000444e:	2505                	addiw	a0,a0,1
    80004450:	07a1                	addi	a5,a5,8
    80004452:	fed51ce3          	bne	a0,a3,8000444a <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004456:	557d                	li	a0,-1
}
    80004458:	60e2                	ld	ra,24(sp)
    8000445a:	6442                	ld	s0,16(sp)
    8000445c:	64a2                	ld	s1,8(sp)
    8000445e:	6105                	addi	sp,sp,32
    80004460:	8082                	ret
      p->ofile[fd] = f;
    80004462:	01a50793          	addi	a5,a0,26
    80004466:	078e                	slli	a5,a5,0x3
    80004468:	963e                	add	a2,a2,a5
    8000446a:	e204                	sd	s1,0(a2)
      return fd;
    8000446c:	b7f5                	j	80004458 <fdalloc+0x2c>

000000008000446e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000446e:	715d                	addi	sp,sp,-80
    80004470:	e486                	sd	ra,72(sp)
    80004472:	e0a2                	sd	s0,64(sp)
    80004474:	fc26                	sd	s1,56(sp)
    80004476:	f84a                	sd	s2,48(sp)
    80004478:	f44e                	sd	s3,40(sp)
    8000447a:	f052                	sd	s4,32(sp)
    8000447c:	ec56                	sd	s5,24(sp)
    8000447e:	0880                	addi	s0,sp,80
    80004480:	8aae                	mv	s5,a1
    80004482:	8a32                	mv	s4,a2
    80004484:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004486:	fb040593          	addi	a1,s0,-80
    8000448a:	fffff097          	auipc	ra,0xfffff
    8000448e:	e14080e7          	jalr	-492(ra) # 8000329e <nameiparent>
    80004492:	892a                	mv	s2,a0
    80004494:	12050c63          	beqz	a0,800045cc <create+0x15e>
    return 0;

  ilock(dp);
    80004498:	ffffe097          	auipc	ra,0xffffe
    8000449c:	616080e7          	jalr	1558(ra) # 80002aae <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800044a0:	4601                	li	a2,0
    800044a2:	fb040593          	addi	a1,s0,-80
    800044a6:	854a                	mv	a0,s2
    800044a8:	fffff097          	auipc	ra,0xfffff
    800044ac:	b06080e7          	jalr	-1274(ra) # 80002fae <dirlookup>
    800044b0:	84aa                	mv	s1,a0
    800044b2:	c539                	beqz	a0,80004500 <create+0x92>
    iunlockput(dp);
    800044b4:	854a                	mv	a0,s2
    800044b6:	fffff097          	auipc	ra,0xfffff
    800044ba:	85e080e7          	jalr	-1954(ra) # 80002d14 <iunlockput>
    ilock(ip);
    800044be:	8526                	mv	a0,s1
    800044c0:	ffffe097          	auipc	ra,0xffffe
    800044c4:	5ee080e7          	jalr	1518(ra) # 80002aae <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800044c8:	4789                	li	a5,2
    800044ca:	02fa9463          	bne	s5,a5,800044f2 <create+0x84>
    800044ce:	0444d783          	lhu	a5,68(s1)
    800044d2:	37f9                	addiw	a5,a5,-2
    800044d4:	17c2                	slli	a5,a5,0x30
    800044d6:	93c1                	srli	a5,a5,0x30
    800044d8:	4705                	li	a4,1
    800044da:	00f76c63          	bltu	a4,a5,800044f2 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800044de:	8526                	mv	a0,s1
    800044e0:	60a6                	ld	ra,72(sp)
    800044e2:	6406                	ld	s0,64(sp)
    800044e4:	74e2                	ld	s1,56(sp)
    800044e6:	7942                	ld	s2,48(sp)
    800044e8:	79a2                	ld	s3,40(sp)
    800044ea:	7a02                	ld	s4,32(sp)
    800044ec:	6ae2                	ld	s5,24(sp)
    800044ee:	6161                	addi	sp,sp,80
    800044f0:	8082                	ret
    iunlockput(ip);
    800044f2:	8526                	mv	a0,s1
    800044f4:	fffff097          	auipc	ra,0xfffff
    800044f8:	820080e7          	jalr	-2016(ra) # 80002d14 <iunlockput>
    return 0;
    800044fc:	4481                	li	s1,0
    800044fe:	b7c5                	j	800044de <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004500:	85d6                	mv	a1,s5
    80004502:	00092503          	lw	a0,0(s2)
    80004506:	ffffe097          	auipc	ra,0xffffe
    8000450a:	414080e7          	jalr	1044(ra) # 8000291a <ialloc>
    8000450e:	84aa                	mv	s1,a0
    80004510:	c139                	beqz	a0,80004556 <create+0xe8>
  ilock(ip);
    80004512:	ffffe097          	auipc	ra,0xffffe
    80004516:	59c080e7          	jalr	1436(ra) # 80002aae <ilock>
  ip->major = major;
    8000451a:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    8000451e:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    80004522:	4985                	li	s3,1
    80004524:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    80004528:	8526                	mv	a0,s1
    8000452a:	ffffe097          	auipc	ra,0xffffe
    8000452e:	4b8080e7          	jalr	1208(ra) # 800029e2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004532:	033a8a63          	beq	s5,s3,80004566 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    80004536:	40d0                	lw	a2,4(s1)
    80004538:	fb040593          	addi	a1,s0,-80
    8000453c:	854a                	mv	a0,s2
    8000453e:	fffff097          	auipc	ra,0xfffff
    80004542:	c80080e7          	jalr	-896(ra) # 800031be <dirlink>
    80004546:	06054b63          	bltz	a0,800045bc <create+0x14e>
  iunlockput(dp);
    8000454a:	854a                	mv	a0,s2
    8000454c:	ffffe097          	auipc	ra,0xffffe
    80004550:	7c8080e7          	jalr	1992(ra) # 80002d14 <iunlockput>
  return ip;
    80004554:	b769                	j	800044de <create+0x70>
    panic("create: ialloc");
    80004556:	00004517          	auipc	a0,0x4
    8000455a:	01a50513          	addi	a0,a0,26 # 80008570 <etext+0x570>
    8000455e:	00001097          	auipc	ra,0x1
    80004562:	6be080e7          	jalr	1726(ra) # 80005c1c <panic>
    dp->nlink++;  // for ".."
    80004566:	04a95783          	lhu	a5,74(s2)
    8000456a:	2785                	addiw	a5,a5,1
    8000456c:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004570:	854a                	mv	a0,s2
    80004572:	ffffe097          	auipc	ra,0xffffe
    80004576:	470080e7          	jalr	1136(ra) # 800029e2 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000457a:	40d0                	lw	a2,4(s1)
    8000457c:	00004597          	auipc	a1,0x4
    80004580:	00458593          	addi	a1,a1,4 # 80008580 <etext+0x580>
    80004584:	8526                	mv	a0,s1
    80004586:	fffff097          	auipc	ra,0xfffff
    8000458a:	c38080e7          	jalr	-968(ra) # 800031be <dirlink>
    8000458e:	00054f63          	bltz	a0,800045ac <create+0x13e>
    80004592:	00492603          	lw	a2,4(s2)
    80004596:	00004597          	auipc	a1,0x4
    8000459a:	ff258593          	addi	a1,a1,-14 # 80008588 <etext+0x588>
    8000459e:	8526                	mv	a0,s1
    800045a0:	fffff097          	auipc	ra,0xfffff
    800045a4:	c1e080e7          	jalr	-994(ra) # 800031be <dirlink>
    800045a8:	f80557e3          	bgez	a0,80004536 <create+0xc8>
      panic("create dots");
    800045ac:	00004517          	auipc	a0,0x4
    800045b0:	fe450513          	addi	a0,a0,-28 # 80008590 <etext+0x590>
    800045b4:	00001097          	auipc	ra,0x1
    800045b8:	668080e7          	jalr	1640(ra) # 80005c1c <panic>
    panic("create: dirlink");
    800045bc:	00004517          	auipc	a0,0x4
    800045c0:	fe450513          	addi	a0,a0,-28 # 800085a0 <etext+0x5a0>
    800045c4:	00001097          	auipc	ra,0x1
    800045c8:	658080e7          	jalr	1624(ra) # 80005c1c <panic>
    return 0;
    800045cc:	84aa                	mv	s1,a0
    800045ce:	bf01                	j	800044de <create+0x70>

00000000800045d0 <sys_dup>:
{
    800045d0:	7179                	addi	sp,sp,-48
    800045d2:	f406                	sd	ra,40(sp)
    800045d4:	f022                	sd	s0,32(sp)
    800045d6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800045d8:	fd840613          	addi	a2,s0,-40
    800045dc:	4581                	li	a1,0
    800045de:	4501                	li	a0,0
    800045e0:	00000097          	auipc	ra,0x0
    800045e4:	de4080e7          	jalr	-540(ra) # 800043c4 <argfd>
    return -1;
    800045e8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800045ea:	02054763          	bltz	a0,80004618 <sys_dup+0x48>
    800045ee:	ec26                	sd	s1,24(sp)
    800045f0:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800045f2:	fd843903          	ld	s2,-40(s0)
    800045f6:	854a                	mv	a0,s2
    800045f8:	00000097          	auipc	ra,0x0
    800045fc:	e34080e7          	jalr	-460(ra) # 8000442c <fdalloc>
    80004600:	84aa                	mv	s1,a0
    return -1;
    80004602:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004604:	00054f63          	bltz	a0,80004622 <sys_dup+0x52>
  filedup(f);
    80004608:	854a                	mv	a0,s2
    8000460a:	fffff097          	auipc	ra,0xfffff
    8000460e:	2ee080e7          	jalr	750(ra) # 800038f8 <filedup>
  return fd;
    80004612:	87a6                	mv	a5,s1
    80004614:	64e2                	ld	s1,24(sp)
    80004616:	6942                	ld	s2,16(sp)
}
    80004618:	853e                	mv	a0,a5
    8000461a:	70a2                	ld	ra,40(sp)
    8000461c:	7402                	ld	s0,32(sp)
    8000461e:	6145                	addi	sp,sp,48
    80004620:	8082                	ret
    80004622:	64e2                	ld	s1,24(sp)
    80004624:	6942                	ld	s2,16(sp)
    80004626:	bfcd                	j	80004618 <sys_dup+0x48>

0000000080004628 <sys_read>:
{
    80004628:	7179                	addi	sp,sp,-48
    8000462a:	f406                	sd	ra,40(sp)
    8000462c:	f022                	sd	s0,32(sp)
    8000462e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004630:	fe840613          	addi	a2,s0,-24
    80004634:	4581                	li	a1,0
    80004636:	4501                	li	a0,0
    80004638:	00000097          	auipc	ra,0x0
    8000463c:	d8c080e7          	jalr	-628(ra) # 800043c4 <argfd>
    return -1;
    80004640:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004642:	04054163          	bltz	a0,80004684 <sys_read+0x5c>
    80004646:	fe440593          	addi	a1,s0,-28
    8000464a:	4509                	li	a0,2
    8000464c:	ffffe097          	auipc	ra,0xffffe
    80004650:	8f0080e7          	jalr	-1808(ra) # 80001f3c <argint>
    return -1;
    80004654:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004656:	02054763          	bltz	a0,80004684 <sys_read+0x5c>
    8000465a:	fd840593          	addi	a1,s0,-40
    8000465e:	4505                	li	a0,1
    80004660:	ffffe097          	auipc	ra,0xffffe
    80004664:	8fe080e7          	jalr	-1794(ra) # 80001f5e <argaddr>
    return -1;
    80004668:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000466a:	00054d63          	bltz	a0,80004684 <sys_read+0x5c>
  return fileread(f, p, n);
    8000466e:	fe442603          	lw	a2,-28(s0)
    80004672:	fd843583          	ld	a1,-40(s0)
    80004676:	fe843503          	ld	a0,-24(s0)
    8000467a:	fffff097          	auipc	ra,0xfffff
    8000467e:	424080e7          	jalr	1060(ra) # 80003a9e <fileread>
    80004682:	87aa                	mv	a5,a0
}
    80004684:	853e                	mv	a0,a5
    80004686:	70a2                	ld	ra,40(sp)
    80004688:	7402                	ld	s0,32(sp)
    8000468a:	6145                	addi	sp,sp,48
    8000468c:	8082                	ret

000000008000468e <sys_write>:
{
    8000468e:	7179                	addi	sp,sp,-48
    80004690:	f406                	sd	ra,40(sp)
    80004692:	f022                	sd	s0,32(sp)
    80004694:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004696:	fe840613          	addi	a2,s0,-24
    8000469a:	4581                	li	a1,0
    8000469c:	4501                	li	a0,0
    8000469e:	00000097          	auipc	ra,0x0
    800046a2:	d26080e7          	jalr	-730(ra) # 800043c4 <argfd>
    return -1;
    800046a6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046a8:	04054163          	bltz	a0,800046ea <sys_write+0x5c>
    800046ac:	fe440593          	addi	a1,s0,-28
    800046b0:	4509                	li	a0,2
    800046b2:	ffffe097          	auipc	ra,0xffffe
    800046b6:	88a080e7          	jalr	-1910(ra) # 80001f3c <argint>
    return -1;
    800046ba:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046bc:	02054763          	bltz	a0,800046ea <sys_write+0x5c>
    800046c0:	fd840593          	addi	a1,s0,-40
    800046c4:	4505                	li	a0,1
    800046c6:	ffffe097          	auipc	ra,0xffffe
    800046ca:	898080e7          	jalr	-1896(ra) # 80001f5e <argaddr>
    return -1;
    800046ce:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046d0:	00054d63          	bltz	a0,800046ea <sys_write+0x5c>
  return filewrite(f, p, n);
    800046d4:	fe442603          	lw	a2,-28(s0)
    800046d8:	fd843583          	ld	a1,-40(s0)
    800046dc:	fe843503          	ld	a0,-24(s0)
    800046e0:	fffff097          	auipc	ra,0xfffff
    800046e4:	490080e7          	jalr	1168(ra) # 80003b70 <filewrite>
    800046e8:	87aa                	mv	a5,a0
}
    800046ea:	853e                	mv	a0,a5
    800046ec:	70a2                	ld	ra,40(sp)
    800046ee:	7402                	ld	s0,32(sp)
    800046f0:	6145                	addi	sp,sp,48
    800046f2:	8082                	ret

00000000800046f4 <sys_close>:
{
    800046f4:	1101                	addi	sp,sp,-32
    800046f6:	ec06                	sd	ra,24(sp)
    800046f8:	e822                	sd	s0,16(sp)
    800046fa:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800046fc:	fe040613          	addi	a2,s0,-32
    80004700:	fec40593          	addi	a1,s0,-20
    80004704:	4501                	li	a0,0
    80004706:	00000097          	auipc	ra,0x0
    8000470a:	cbe080e7          	jalr	-834(ra) # 800043c4 <argfd>
    return -1;
    8000470e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004710:	02054463          	bltz	a0,80004738 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004714:	ffffc097          	auipc	ra,0xffffc
    80004718:	768080e7          	jalr	1896(ra) # 80000e7c <myproc>
    8000471c:	fec42783          	lw	a5,-20(s0)
    80004720:	07e9                	addi	a5,a5,26
    80004722:	078e                	slli	a5,a5,0x3
    80004724:	953e                	add	a0,a0,a5
    80004726:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000472a:	fe043503          	ld	a0,-32(s0)
    8000472e:	fffff097          	auipc	ra,0xfffff
    80004732:	21c080e7          	jalr	540(ra) # 8000394a <fileclose>
  return 0;
    80004736:	4781                	li	a5,0
}
    80004738:	853e                	mv	a0,a5
    8000473a:	60e2                	ld	ra,24(sp)
    8000473c:	6442                	ld	s0,16(sp)
    8000473e:	6105                	addi	sp,sp,32
    80004740:	8082                	ret

0000000080004742 <sys_fstat>:
{
    80004742:	1101                	addi	sp,sp,-32
    80004744:	ec06                	sd	ra,24(sp)
    80004746:	e822                	sd	s0,16(sp)
    80004748:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000474a:	fe840613          	addi	a2,s0,-24
    8000474e:	4581                	li	a1,0
    80004750:	4501                	li	a0,0
    80004752:	00000097          	auipc	ra,0x0
    80004756:	c72080e7          	jalr	-910(ra) # 800043c4 <argfd>
    return -1;
    8000475a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000475c:	02054563          	bltz	a0,80004786 <sys_fstat+0x44>
    80004760:	fe040593          	addi	a1,s0,-32
    80004764:	4505                	li	a0,1
    80004766:	ffffd097          	auipc	ra,0xffffd
    8000476a:	7f8080e7          	jalr	2040(ra) # 80001f5e <argaddr>
    return -1;
    8000476e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004770:	00054b63          	bltz	a0,80004786 <sys_fstat+0x44>
  return filestat(f, st);
    80004774:	fe043583          	ld	a1,-32(s0)
    80004778:	fe843503          	ld	a0,-24(s0)
    8000477c:	fffff097          	auipc	ra,0xfffff
    80004780:	2b0080e7          	jalr	688(ra) # 80003a2c <filestat>
    80004784:	87aa                	mv	a5,a0
}
    80004786:	853e                	mv	a0,a5
    80004788:	60e2                	ld	ra,24(sp)
    8000478a:	6442                	ld	s0,16(sp)
    8000478c:	6105                	addi	sp,sp,32
    8000478e:	8082                	ret

0000000080004790 <sys_link>:
{
    80004790:	7169                	addi	sp,sp,-304
    80004792:	f606                	sd	ra,296(sp)
    80004794:	f222                	sd	s0,288(sp)
    80004796:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004798:	08000613          	li	a2,128
    8000479c:	ed040593          	addi	a1,s0,-304
    800047a0:	4501                	li	a0,0
    800047a2:	ffffd097          	auipc	ra,0xffffd
    800047a6:	7de080e7          	jalr	2014(ra) # 80001f80 <argstr>
    return -1;
    800047aa:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047ac:	12054663          	bltz	a0,800048d8 <sys_link+0x148>
    800047b0:	08000613          	li	a2,128
    800047b4:	f5040593          	addi	a1,s0,-176
    800047b8:	4505                	li	a0,1
    800047ba:	ffffd097          	auipc	ra,0xffffd
    800047be:	7c6080e7          	jalr	1990(ra) # 80001f80 <argstr>
    return -1;
    800047c2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047c4:	10054a63          	bltz	a0,800048d8 <sys_link+0x148>
    800047c8:	ee26                	sd	s1,280(sp)
  begin_op();
    800047ca:	fffff097          	auipc	ra,0xfffff
    800047ce:	cb6080e7          	jalr	-842(ra) # 80003480 <begin_op>
  if((ip = namei(old)) == 0){
    800047d2:	ed040513          	addi	a0,s0,-304
    800047d6:	fffff097          	auipc	ra,0xfffff
    800047da:	aaa080e7          	jalr	-1366(ra) # 80003280 <namei>
    800047de:	84aa                	mv	s1,a0
    800047e0:	c949                	beqz	a0,80004872 <sys_link+0xe2>
  ilock(ip);
    800047e2:	ffffe097          	auipc	ra,0xffffe
    800047e6:	2cc080e7          	jalr	716(ra) # 80002aae <ilock>
  if(ip->type == T_DIR){
    800047ea:	04449703          	lh	a4,68(s1)
    800047ee:	4785                	li	a5,1
    800047f0:	08f70863          	beq	a4,a5,80004880 <sys_link+0xf0>
    800047f4:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800047f6:	04a4d783          	lhu	a5,74(s1)
    800047fa:	2785                	addiw	a5,a5,1
    800047fc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004800:	8526                	mv	a0,s1
    80004802:	ffffe097          	auipc	ra,0xffffe
    80004806:	1e0080e7          	jalr	480(ra) # 800029e2 <iupdate>
  iunlock(ip);
    8000480a:	8526                	mv	a0,s1
    8000480c:	ffffe097          	auipc	ra,0xffffe
    80004810:	368080e7          	jalr	872(ra) # 80002b74 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004814:	fd040593          	addi	a1,s0,-48
    80004818:	f5040513          	addi	a0,s0,-176
    8000481c:	fffff097          	auipc	ra,0xfffff
    80004820:	a82080e7          	jalr	-1406(ra) # 8000329e <nameiparent>
    80004824:	892a                	mv	s2,a0
    80004826:	cd35                	beqz	a0,800048a2 <sys_link+0x112>
  ilock(dp);
    80004828:	ffffe097          	auipc	ra,0xffffe
    8000482c:	286080e7          	jalr	646(ra) # 80002aae <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004830:	00092703          	lw	a4,0(s2)
    80004834:	409c                	lw	a5,0(s1)
    80004836:	06f71163          	bne	a4,a5,80004898 <sys_link+0x108>
    8000483a:	40d0                	lw	a2,4(s1)
    8000483c:	fd040593          	addi	a1,s0,-48
    80004840:	854a                	mv	a0,s2
    80004842:	fffff097          	auipc	ra,0xfffff
    80004846:	97c080e7          	jalr	-1668(ra) # 800031be <dirlink>
    8000484a:	04054763          	bltz	a0,80004898 <sys_link+0x108>
  iunlockput(dp);
    8000484e:	854a                	mv	a0,s2
    80004850:	ffffe097          	auipc	ra,0xffffe
    80004854:	4c4080e7          	jalr	1220(ra) # 80002d14 <iunlockput>
  iput(ip);
    80004858:	8526                	mv	a0,s1
    8000485a:	ffffe097          	auipc	ra,0xffffe
    8000485e:	412080e7          	jalr	1042(ra) # 80002c6c <iput>
  end_op();
    80004862:	fffff097          	auipc	ra,0xfffff
    80004866:	c98080e7          	jalr	-872(ra) # 800034fa <end_op>
  return 0;
    8000486a:	4781                	li	a5,0
    8000486c:	64f2                	ld	s1,280(sp)
    8000486e:	6952                	ld	s2,272(sp)
    80004870:	a0a5                	j	800048d8 <sys_link+0x148>
    end_op();
    80004872:	fffff097          	auipc	ra,0xfffff
    80004876:	c88080e7          	jalr	-888(ra) # 800034fa <end_op>
    return -1;
    8000487a:	57fd                	li	a5,-1
    8000487c:	64f2                	ld	s1,280(sp)
    8000487e:	a8a9                	j	800048d8 <sys_link+0x148>
    iunlockput(ip);
    80004880:	8526                	mv	a0,s1
    80004882:	ffffe097          	auipc	ra,0xffffe
    80004886:	492080e7          	jalr	1170(ra) # 80002d14 <iunlockput>
    end_op();
    8000488a:	fffff097          	auipc	ra,0xfffff
    8000488e:	c70080e7          	jalr	-912(ra) # 800034fa <end_op>
    return -1;
    80004892:	57fd                	li	a5,-1
    80004894:	64f2                	ld	s1,280(sp)
    80004896:	a089                	j	800048d8 <sys_link+0x148>
    iunlockput(dp);
    80004898:	854a                	mv	a0,s2
    8000489a:	ffffe097          	auipc	ra,0xffffe
    8000489e:	47a080e7          	jalr	1146(ra) # 80002d14 <iunlockput>
  ilock(ip);
    800048a2:	8526                	mv	a0,s1
    800048a4:	ffffe097          	auipc	ra,0xffffe
    800048a8:	20a080e7          	jalr	522(ra) # 80002aae <ilock>
  ip->nlink--;
    800048ac:	04a4d783          	lhu	a5,74(s1)
    800048b0:	37fd                	addiw	a5,a5,-1
    800048b2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048b6:	8526                	mv	a0,s1
    800048b8:	ffffe097          	auipc	ra,0xffffe
    800048bc:	12a080e7          	jalr	298(ra) # 800029e2 <iupdate>
  iunlockput(ip);
    800048c0:	8526                	mv	a0,s1
    800048c2:	ffffe097          	auipc	ra,0xffffe
    800048c6:	452080e7          	jalr	1106(ra) # 80002d14 <iunlockput>
  end_op();
    800048ca:	fffff097          	auipc	ra,0xfffff
    800048ce:	c30080e7          	jalr	-976(ra) # 800034fa <end_op>
  return -1;
    800048d2:	57fd                	li	a5,-1
    800048d4:	64f2                	ld	s1,280(sp)
    800048d6:	6952                	ld	s2,272(sp)
}
    800048d8:	853e                	mv	a0,a5
    800048da:	70b2                	ld	ra,296(sp)
    800048dc:	7412                	ld	s0,288(sp)
    800048de:	6155                	addi	sp,sp,304
    800048e0:	8082                	ret

00000000800048e2 <sys_unlink>:
{
    800048e2:	7151                	addi	sp,sp,-240
    800048e4:	f586                	sd	ra,232(sp)
    800048e6:	f1a2                	sd	s0,224(sp)
    800048e8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800048ea:	08000613          	li	a2,128
    800048ee:	f3040593          	addi	a1,s0,-208
    800048f2:	4501                	li	a0,0
    800048f4:	ffffd097          	auipc	ra,0xffffd
    800048f8:	68c080e7          	jalr	1676(ra) # 80001f80 <argstr>
    800048fc:	1a054a63          	bltz	a0,80004ab0 <sys_unlink+0x1ce>
    80004900:	eda6                	sd	s1,216(sp)
  begin_op();
    80004902:	fffff097          	auipc	ra,0xfffff
    80004906:	b7e080e7          	jalr	-1154(ra) # 80003480 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000490a:	fb040593          	addi	a1,s0,-80
    8000490e:	f3040513          	addi	a0,s0,-208
    80004912:	fffff097          	auipc	ra,0xfffff
    80004916:	98c080e7          	jalr	-1652(ra) # 8000329e <nameiparent>
    8000491a:	84aa                	mv	s1,a0
    8000491c:	cd71                	beqz	a0,800049f8 <sys_unlink+0x116>
  ilock(dp);
    8000491e:	ffffe097          	auipc	ra,0xffffe
    80004922:	190080e7          	jalr	400(ra) # 80002aae <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004926:	00004597          	auipc	a1,0x4
    8000492a:	c5a58593          	addi	a1,a1,-934 # 80008580 <etext+0x580>
    8000492e:	fb040513          	addi	a0,s0,-80
    80004932:	ffffe097          	auipc	ra,0xffffe
    80004936:	662080e7          	jalr	1634(ra) # 80002f94 <namecmp>
    8000493a:	14050c63          	beqz	a0,80004a92 <sys_unlink+0x1b0>
    8000493e:	00004597          	auipc	a1,0x4
    80004942:	c4a58593          	addi	a1,a1,-950 # 80008588 <etext+0x588>
    80004946:	fb040513          	addi	a0,s0,-80
    8000494a:	ffffe097          	auipc	ra,0xffffe
    8000494e:	64a080e7          	jalr	1610(ra) # 80002f94 <namecmp>
    80004952:	14050063          	beqz	a0,80004a92 <sys_unlink+0x1b0>
    80004956:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004958:	f2c40613          	addi	a2,s0,-212
    8000495c:	fb040593          	addi	a1,s0,-80
    80004960:	8526                	mv	a0,s1
    80004962:	ffffe097          	auipc	ra,0xffffe
    80004966:	64c080e7          	jalr	1612(ra) # 80002fae <dirlookup>
    8000496a:	892a                	mv	s2,a0
    8000496c:	12050263          	beqz	a0,80004a90 <sys_unlink+0x1ae>
  ilock(ip);
    80004970:	ffffe097          	auipc	ra,0xffffe
    80004974:	13e080e7          	jalr	318(ra) # 80002aae <ilock>
  if(ip->nlink < 1)
    80004978:	04a91783          	lh	a5,74(s2)
    8000497c:	08f05563          	blez	a5,80004a06 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004980:	04491703          	lh	a4,68(s2)
    80004984:	4785                	li	a5,1
    80004986:	08f70963          	beq	a4,a5,80004a18 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    8000498a:	4641                	li	a2,16
    8000498c:	4581                	li	a1,0
    8000498e:	fc040513          	addi	a0,s0,-64
    80004992:	ffffb097          	auipc	ra,0xffffb
    80004996:	7e8080e7          	jalr	2024(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000499a:	4741                	li	a4,16
    8000499c:	f2c42683          	lw	a3,-212(s0)
    800049a0:	fc040613          	addi	a2,s0,-64
    800049a4:	4581                	li	a1,0
    800049a6:	8526                	mv	a0,s1
    800049a8:	ffffe097          	auipc	ra,0xffffe
    800049ac:	4c2080e7          	jalr	1218(ra) # 80002e6a <writei>
    800049b0:	47c1                	li	a5,16
    800049b2:	0af51b63          	bne	a0,a5,80004a68 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    800049b6:	04491703          	lh	a4,68(s2)
    800049ba:	4785                	li	a5,1
    800049bc:	0af70f63          	beq	a4,a5,80004a7a <sys_unlink+0x198>
  iunlockput(dp);
    800049c0:	8526                	mv	a0,s1
    800049c2:	ffffe097          	auipc	ra,0xffffe
    800049c6:	352080e7          	jalr	850(ra) # 80002d14 <iunlockput>
  ip->nlink--;
    800049ca:	04a95783          	lhu	a5,74(s2)
    800049ce:	37fd                	addiw	a5,a5,-1
    800049d0:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800049d4:	854a                	mv	a0,s2
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	00c080e7          	jalr	12(ra) # 800029e2 <iupdate>
  iunlockput(ip);
    800049de:	854a                	mv	a0,s2
    800049e0:	ffffe097          	auipc	ra,0xffffe
    800049e4:	334080e7          	jalr	820(ra) # 80002d14 <iunlockput>
  end_op();
    800049e8:	fffff097          	auipc	ra,0xfffff
    800049ec:	b12080e7          	jalr	-1262(ra) # 800034fa <end_op>
  return 0;
    800049f0:	4501                	li	a0,0
    800049f2:	64ee                	ld	s1,216(sp)
    800049f4:	694e                	ld	s2,208(sp)
    800049f6:	a84d                	j	80004aa8 <sys_unlink+0x1c6>
    end_op();
    800049f8:	fffff097          	auipc	ra,0xfffff
    800049fc:	b02080e7          	jalr	-1278(ra) # 800034fa <end_op>
    return -1;
    80004a00:	557d                	li	a0,-1
    80004a02:	64ee                	ld	s1,216(sp)
    80004a04:	a055                	j	80004aa8 <sys_unlink+0x1c6>
    80004a06:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004a08:	00004517          	auipc	a0,0x4
    80004a0c:	ba850513          	addi	a0,a0,-1112 # 800085b0 <etext+0x5b0>
    80004a10:	00001097          	auipc	ra,0x1
    80004a14:	20c080e7          	jalr	524(ra) # 80005c1c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a18:	04c92703          	lw	a4,76(s2)
    80004a1c:	02000793          	li	a5,32
    80004a20:	f6e7f5e3          	bgeu	a5,a4,8000498a <sys_unlink+0xa8>
    80004a24:	e5ce                	sd	s3,200(sp)
    80004a26:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a2a:	4741                	li	a4,16
    80004a2c:	86ce                	mv	a3,s3
    80004a2e:	f1840613          	addi	a2,s0,-232
    80004a32:	4581                	li	a1,0
    80004a34:	854a                	mv	a0,s2
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	330080e7          	jalr	816(ra) # 80002d66 <readi>
    80004a3e:	47c1                	li	a5,16
    80004a40:	00f51c63          	bne	a0,a5,80004a58 <sys_unlink+0x176>
    if(de.inum != 0)
    80004a44:	f1845783          	lhu	a5,-232(s0)
    80004a48:	e7b5                	bnez	a5,80004ab4 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a4a:	29c1                	addiw	s3,s3,16
    80004a4c:	04c92783          	lw	a5,76(s2)
    80004a50:	fcf9ede3          	bltu	s3,a5,80004a2a <sys_unlink+0x148>
    80004a54:	69ae                	ld	s3,200(sp)
    80004a56:	bf15                	j	8000498a <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004a58:	00004517          	auipc	a0,0x4
    80004a5c:	b7050513          	addi	a0,a0,-1168 # 800085c8 <etext+0x5c8>
    80004a60:	00001097          	auipc	ra,0x1
    80004a64:	1bc080e7          	jalr	444(ra) # 80005c1c <panic>
    80004a68:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004a6a:	00004517          	auipc	a0,0x4
    80004a6e:	b7650513          	addi	a0,a0,-1162 # 800085e0 <etext+0x5e0>
    80004a72:	00001097          	auipc	ra,0x1
    80004a76:	1aa080e7          	jalr	426(ra) # 80005c1c <panic>
    dp->nlink--;
    80004a7a:	04a4d783          	lhu	a5,74(s1)
    80004a7e:	37fd                	addiw	a5,a5,-1
    80004a80:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a84:	8526                	mv	a0,s1
    80004a86:	ffffe097          	auipc	ra,0xffffe
    80004a8a:	f5c080e7          	jalr	-164(ra) # 800029e2 <iupdate>
    80004a8e:	bf0d                	j	800049c0 <sys_unlink+0xde>
    80004a90:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004a92:	8526                	mv	a0,s1
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	280080e7          	jalr	640(ra) # 80002d14 <iunlockput>
  end_op();
    80004a9c:	fffff097          	auipc	ra,0xfffff
    80004aa0:	a5e080e7          	jalr	-1442(ra) # 800034fa <end_op>
  return -1;
    80004aa4:	557d                	li	a0,-1
    80004aa6:	64ee                	ld	s1,216(sp)
}
    80004aa8:	70ae                	ld	ra,232(sp)
    80004aaa:	740e                	ld	s0,224(sp)
    80004aac:	616d                	addi	sp,sp,240
    80004aae:	8082                	ret
    return -1;
    80004ab0:	557d                	li	a0,-1
    80004ab2:	bfdd                	j	80004aa8 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004ab4:	854a                	mv	a0,s2
    80004ab6:	ffffe097          	auipc	ra,0xffffe
    80004aba:	25e080e7          	jalr	606(ra) # 80002d14 <iunlockput>
    goto bad;
    80004abe:	694e                	ld	s2,208(sp)
    80004ac0:	69ae                	ld	s3,200(sp)
    80004ac2:	bfc1                	j	80004a92 <sys_unlink+0x1b0>

0000000080004ac4 <sys_open>:

uint64
sys_open(void)
{
    80004ac4:	7131                	addi	sp,sp,-192
    80004ac6:	fd06                	sd	ra,184(sp)
    80004ac8:	f922                	sd	s0,176(sp)
    80004aca:	f526                	sd	s1,168(sp)
    80004acc:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ace:	08000613          	li	a2,128
    80004ad2:	f5040593          	addi	a1,s0,-176
    80004ad6:	4501                	li	a0,0
    80004ad8:	ffffd097          	auipc	ra,0xffffd
    80004adc:	4a8080e7          	jalr	1192(ra) # 80001f80 <argstr>
    return -1;
    80004ae0:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004ae2:	0c054463          	bltz	a0,80004baa <sys_open+0xe6>
    80004ae6:	f4c40593          	addi	a1,s0,-180
    80004aea:	4505                	li	a0,1
    80004aec:	ffffd097          	auipc	ra,0xffffd
    80004af0:	450080e7          	jalr	1104(ra) # 80001f3c <argint>
    80004af4:	0a054b63          	bltz	a0,80004baa <sys_open+0xe6>
    80004af8:	f14a                	sd	s2,160(sp)

  begin_op();
    80004afa:	fffff097          	auipc	ra,0xfffff
    80004afe:	986080e7          	jalr	-1658(ra) # 80003480 <begin_op>

  if(omode & O_CREATE){
    80004b02:	f4c42783          	lw	a5,-180(s0)
    80004b06:	2007f793          	andi	a5,a5,512
    80004b0a:	cfc5                	beqz	a5,80004bc2 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b0c:	4681                	li	a3,0
    80004b0e:	4601                	li	a2,0
    80004b10:	4589                	li	a1,2
    80004b12:	f5040513          	addi	a0,s0,-176
    80004b16:	00000097          	auipc	ra,0x0
    80004b1a:	958080e7          	jalr	-1704(ra) # 8000446e <create>
    80004b1e:	892a                	mv	s2,a0
    if(ip == 0){
    80004b20:	c959                	beqz	a0,80004bb6 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b22:	04491703          	lh	a4,68(s2)
    80004b26:	478d                	li	a5,3
    80004b28:	00f71763          	bne	a4,a5,80004b36 <sys_open+0x72>
    80004b2c:	04695703          	lhu	a4,70(s2)
    80004b30:	47a5                	li	a5,9
    80004b32:	0ce7ef63          	bltu	a5,a4,80004c10 <sys_open+0x14c>
    80004b36:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b38:	fffff097          	auipc	ra,0xfffff
    80004b3c:	d56080e7          	jalr	-682(ra) # 8000388e <filealloc>
    80004b40:	89aa                	mv	s3,a0
    80004b42:	c965                	beqz	a0,80004c32 <sys_open+0x16e>
    80004b44:	00000097          	auipc	ra,0x0
    80004b48:	8e8080e7          	jalr	-1816(ra) # 8000442c <fdalloc>
    80004b4c:	84aa                	mv	s1,a0
    80004b4e:	0c054d63          	bltz	a0,80004c28 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b52:	04491703          	lh	a4,68(s2)
    80004b56:	478d                	li	a5,3
    80004b58:	0ef70a63          	beq	a4,a5,80004c4c <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b5c:	4789                	li	a5,2
    80004b5e:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b62:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b66:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004b6a:	f4c42783          	lw	a5,-180(s0)
    80004b6e:	0017c713          	xori	a4,a5,1
    80004b72:	8b05                	andi	a4,a4,1
    80004b74:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004b78:	0037f713          	andi	a4,a5,3
    80004b7c:	00e03733          	snez	a4,a4
    80004b80:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004b84:	4007f793          	andi	a5,a5,1024
    80004b88:	c791                	beqz	a5,80004b94 <sys_open+0xd0>
    80004b8a:	04491703          	lh	a4,68(s2)
    80004b8e:	4789                	li	a5,2
    80004b90:	0cf70563          	beq	a4,a5,80004c5a <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004b94:	854a                	mv	a0,s2
    80004b96:	ffffe097          	auipc	ra,0xffffe
    80004b9a:	fde080e7          	jalr	-34(ra) # 80002b74 <iunlock>
  end_op();
    80004b9e:	fffff097          	auipc	ra,0xfffff
    80004ba2:	95c080e7          	jalr	-1700(ra) # 800034fa <end_op>
    80004ba6:	790a                	ld	s2,160(sp)
    80004ba8:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004baa:	8526                	mv	a0,s1
    80004bac:	70ea                	ld	ra,184(sp)
    80004bae:	744a                	ld	s0,176(sp)
    80004bb0:	74aa                	ld	s1,168(sp)
    80004bb2:	6129                	addi	sp,sp,192
    80004bb4:	8082                	ret
      end_op();
    80004bb6:	fffff097          	auipc	ra,0xfffff
    80004bba:	944080e7          	jalr	-1724(ra) # 800034fa <end_op>
      return -1;
    80004bbe:	790a                	ld	s2,160(sp)
    80004bc0:	b7ed                	j	80004baa <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004bc2:	f5040513          	addi	a0,s0,-176
    80004bc6:	ffffe097          	auipc	ra,0xffffe
    80004bca:	6ba080e7          	jalr	1722(ra) # 80003280 <namei>
    80004bce:	892a                	mv	s2,a0
    80004bd0:	c90d                	beqz	a0,80004c02 <sys_open+0x13e>
    ilock(ip);
    80004bd2:	ffffe097          	auipc	ra,0xffffe
    80004bd6:	edc080e7          	jalr	-292(ra) # 80002aae <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004bda:	04491703          	lh	a4,68(s2)
    80004bde:	4785                	li	a5,1
    80004be0:	f4f711e3          	bne	a4,a5,80004b22 <sys_open+0x5e>
    80004be4:	f4c42783          	lw	a5,-180(s0)
    80004be8:	d7b9                	beqz	a5,80004b36 <sys_open+0x72>
      iunlockput(ip);
    80004bea:	854a                	mv	a0,s2
    80004bec:	ffffe097          	auipc	ra,0xffffe
    80004bf0:	128080e7          	jalr	296(ra) # 80002d14 <iunlockput>
      end_op();
    80004bf4:	fffff097          	auipc	ra,0xfffff
    80004bf8:	906080e7          	jalr	-1786(ra) # 800034fa <end_op>
      return -1;
    80004bfc:	54fd                	li	s1,-1
    80004bfe:	790a                	ld	s2,160(sp)
    80004c00:	b76d                	j	80004baa <sys_open+0xe6>
      end_op();
    80004c02:	fffff097          	auipc	ra,0xfffff
    80004c06:	8f8080e7          	jalr	-1800(ra) # 800034fa <end_op>
      return -1;
    80004c0a:	54fd                	li	s1,-1
    80004c0c:	790a                	ld	s2,160(sp)
    80004c0e:	bf71                	j	80004baa <sys_open+0xe6>
    iunlockput(ip);
    80004c10:	854a                	mv	a0,s2
    80004c12:	ffffe097          	auipc	ra,0xffffe
    80004c16:	102080e7          	jalr	258(ra) # 80002d14 <iunlockput>
    end_op();
    80004c1a:	fffff097          	auipc	ra,0xfffff
    80004c1e:	8e0080e7          	jalr	-1824(ra) # 800034fa <end_op>
    return -1;
    80004c22:	54fd                	li	s1,-1
    80004c24:	790a                	ld	s2,160(sp)
    80004c26:	b751                	j	80004baa <sys_open+0xe6>
      fileclose(f);
    80004c28:	854e                	mv	a0,s3
    80004c2a:	fffff097          	auipc	ra,0xfffff
    80004c2e:	d20080e7          	jalr	-736(ra) # 8000394a <fileclose>
    iunlockput(ip);
    80004c32:	854a                	mv	a0,s2
    80004c34:	ffffe097          	auipc	ra,0xffffe
    80004c38:	0e0080e7          	jalr	224(ra) # 80002d14 <iunlockput>
    end_op();
    80004c3c:	fffff097          	auipc	ra,0xfffff
    80004c40:	8be080e7          	jalr	-1858(ra) # 800034fa <end_op>
    return -1;
    80004c44:	54fd                	li	s1,-1
    80004c46:	790a                	ld	s2,160(sp)
    80004c48:	69ea                	ld	s3,152(sp)
    80004c4a:	b785                	j	80004baa <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004c4c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c50:	04691783          	lh	a5,70(s2)
    80004c54:	02f99223          	sh	a5,36(s3)
    80004c58:	b739                	j	80004b66 <sys_open+0xa2>
    itrunc(ip);
    80004c5a:	854a                	mv	a0,s2
    80004c5c:	ffffe097          	auipc	ra,0xffffe
    80004c60:	f64080e7          	jalr	-156(ra) # 80002bc0 <itrunc>
    80004c64:	bf05                	j	80004b94 <sys_open+0xd0>

0000000080004c66 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c66:	7175                	addi	sp,sp,-144
    80004c68:	e506                	sd	ra,136(sp)
    80004c6a:	e122                	sd	s0,128(sp)
    80004c6c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c6e:	fffff097          	auipc	ra,0xfffff
    80004c72:	812080e7          	jalr	-2030(ra) # 80003480 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004c76:	08000613          	li	a2,128
    80004c7a:	f7040593          	addi	a1,s0,-144
    80004c7e:	4501                	li	a0,0
    80004c80:	ffffd097          	auipc	ra,0xffffd
    80004c84:	300080e7          	jalr	768(ra) # 80001f80 <argstr>
    80004c88:	02054963          	bltz	a0,80004cba <sys_mkdir+0x54>
    80004c8c:	4681                	li	a3,0
    80004c8e:	4601                	li	a2,0
    80004c90:	4585                	li	a1,1
    80004c92:	f7040513          	addi	a0,s0,-144
    80004c96:	fffff097          	auipc	ra,0xfffff
    80004c9a:	7d8080e7          	jalr	2008(ra) # 8000446e <create>
    80004c9e:	cd11                	beqz	a0,80004cba <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ca0:	ffffe097          	auipc	ra,0xffffe
    80004ca4:	074080e7          	jalr	116(ra) # 80002d14 <iunlockput>
  end_op();
    80004ca8:	fffff097          	auipc	ra,0xfffff
    80004cac:	852080e7          	jalr	-1966(ra) # 800034fa <end_op>
  return 0;
    80004cb0:	4501                	li	a0,0
}
    80004cb2:	60aa                	ld	ra,136(sp)
    80004cb4:	640a                	ld	s0,128(sp)
    80004cb6:	6149                	addi	sp,sp,144
    80004cb8:	8082                	ret
    end_op();
    80004cba:	fffff097          	auipc	ra,0xfffff
    80004cbe:	840080e7          	jalr	-1984(ra) # 800034fa <end_op>
    return -1;
    80004cc2:	557d                	li	a0,-1
    80004cc4:	b7fd                	j	80004cb2 <sys_mkdir+0x4c>

0000000080004cc6 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004cc6:	7135                	addi	sp,sp,-160
    80004cc8:	ed06                	sd	ra,152(sp)
    80004cca:	e922                	sd	s0,144(sp)
    80004ccc:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004cce:	ffffe097          	auipc	ra,0xffffe
    80004cd2:	7b2080e7          	jalr	1970(ra) # 80003480 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cd6:	08000613          	li	a2,128
    80004cda:	f7040593          	addi	a1,s0,-144
    80004cde:	4501                	li	a0,0
    80004ce0:	ffffd097          	auipc	ra,0xffffd
    80004ce4:	2a0080e7          	jalr	672(ra) # 80001f80 <argstr>
    80004ce8:	04054a63          	bltz	a0,80004d3c <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004cec:	f6c40593          	addi	a1,s0,-148
    80004cf0:	4505                	li	a0,1
    80004cf2:	ffffd097          	auipc	ra,0xffffd
    80004cf6:	24a080e7          	jalr	586(ra) # 80001f3c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004cfa:	04054163          	bltz	a0,80004d3c <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004cfe:	f6840593          	addi	a1,s0,-152
    80004d02:	4509                	li	a0,2
    80004d04:	ffffd097          	auipc	ra,0xffffd
    80004d08:	238080e7          	jalr	568(ra) # 80001f3c <argint>
     argint(1, &major) < 0 ||
    80004d0c:	02054863          	bltz	a0,80004d3c <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d10:	f6841683          	lh	a3,-152(s0)
    80004d14:	f6c41603          	lh	a2,-148(s0)
    80004d18:	458d                	li	a1,3
    80004d1a:	f7040513          	addi	a0,s0,-144
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	750080e7          	jalr	1872(ra) # 8000446e <create>
     argint(2, &minor) < 0 ||
    80004d26:	c919                	beqz	a0,80004d3c <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d28:	ffffe097          	auipc	ra,0xffffe
    80004d2c:	fec080e7          	jalr	-20(ra) # 80002d14 <iunlockput>
  end_op();
    80004d30:	ffffe097          	auipc	ra,0xffffe
    80004d34:	7ca080e7          	jalr	1994(ra) # 800034fa <end_op>
  return 0;
    80004d38:	4501                	li	a0,0
    80004d3a:	a031                	j	80004d46 <sys_mknod+0x80>
    end_op();
    80004d3c:	ffffe097          	auipc	ra,0xffffe
    80004d40:	7be080e7          	jalr	1982(ra) # 800034fa <end_op>
    return -1;
    80004d44:	557d                	li	a0,-1
}
    80004d46:	60ea                	ld	ra,152(sp)
    80004d48:	644a                	ld	s0,144(sp)
    80004d4a:	610d                	addi	sp,sp,160
    80004d4c:	8082                	ret

0000000080004d4e <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d4e:	7135                	addi	sp,sp,-160
    80004d50:	ed06                	sd	ra,152(sp)
    80004d52:	e922                	sd	s0,144(sp)
    80004d54:	e14a                	sd	s2,128(sp)
    80004d56:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d58:	ffffc097          	auipc	ra,0xffffc
    80004d5c:	124080e7          	jalr	292(ra) # 80000e7c <myproc>
    80004d60:	892a                	mv	s2,a0
  
  begin_op();
    80004d62:	ffffe097          	auipc	ra,0xffffe
    80004d66:	71e080e7          	jalr	1822(ra) # 80003480 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d6a:	08000613          	li	a2,128
    80004d6e:	f6040593          	addi	a1,s0,-160
    80004d72:	4501                	li	a0,0
    80004d74:	ffffd097          	auipc	ra,0xffffd
    80004d78:	20c080e7          	jalr	524(ra) # 80001f80 <argstr>
    80004d7c:	04054d63          	bltz	a0,80004dd6 <sys_chdir+0x88>
    80004d80:	e526                	sd	s1,136(sp)
    80004d82:	f6040513          	addi	a0,s0,-160
    80004d86:	ffffe097          	auipc	ra,0xffffe
    80004d8a:	4fa080e7          	jalr	1274(ra) # 80003280 <namei>
    80004d8e:	84aa                	mv	s1,a0
    80004d90:	c131                	beqz	a0,80004dd4 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004d92:	ffffe097          	auipc	ra,0xffffe
    80004d96:	d1c080e7          	jalr	-740(ra) # 80002aae <ilock>
  if(ip->type != T_DIR){
    80004d9a:	04449703          	lh	a4,68(s1)
    80004d9e:	4785                	li	a5,1
    80004da0:	04f71163          	bne	a4,a5,80004de2 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004da4:	8526                	mv	a0,s1
    80004da6:	ffffe097          	auipc	ra,0xffffe
    80004daa:	dce080e7          	jalr	-562(ra) # 80002b74 <iunlock>
  iput(p->cwd);
    80004dae:	15093503          	ld	a0,336(s2)
    80004db2:	ffffe097          	auipc	ra,0xffffe
    80004db6:	eba080e7          	jalr	-326(ra) # 80002c6c <iput>
  end_op();
    80004dba:	ffffe097          	auipc	ra,0xffffe
    80004dbe:	740080e7          	jalr	1856(ra) # 800034fa <end_op>
  p->cwd = ip;
    80004dc2:	14993823          	sd	s1,336(s2)
  return 0;
    80004dc6:	4501                	li	a0,0
    80004dc8:	64aa                	ld	s1,136(sp)
}
    80004dca:	60ea                	ld	ra,152(sp)
    80004dcc:	644a                	ld	s0,144(sp)
    80004dce:	690a                	ld	s2,128(sp)
    80004dd0:	610d                	addi	sp,sp,160
    80004dd2:	8082                	ret
    80004dd4:	64aa                	ld	s1,136(sp)
    end_op();
    80004dd6:	ffffe097          	auipc	ra,0xffffe
    80004dda:	724080e7          	jalr	1828(ra) # 800034fa <end_op>
    return -1;
    80004dde:	557d                	li	a0,-1
    80004de0:	b7ed                	j	80004dca <sys_chdir+0x7c>
    iunlockput(ip);
    80004de2:	8526                	mv	a0,s1
    80004de4:	ffffe097          	auipc	ra,0xffffe
    80004de8:	f30080e7          	jalr	-208(ra) # 80002d14 <iunlockput>
    end_op();
    80004dec:	ffffe097          	auipc	ra,0xffffe
    80004df0:	70e080e7          	jalr	1806(ra) # 800034fa <end_op>
    return -1;
    80004df4:	557d                	li	a0,-1
    80004df6:	64aa                	ld	s1,136(sp)
    80004df8:	bfc9                	j	80004dca <sys_chdir+0x7c>

0000000080004dfa <sys_exec>:

uint64
sys_exec(void)
{
    80004dfa:	7121                	addi	sp,sp,-448
    80004dfc:	ff06                	sd	ra,440(sp)
    80004dfe:	fb22                	sd	s0,432(sp)
    80004e00:	f34a                	sd	s2,416(sp)
    80004e02:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e04:	08000613          	li	a2,128
    80004e08:	f5040593          	addi	a1,s0,-176
    80004e0c:	4501                	li	a0,0
    80004e0e:	ffffd097          	auipc	ra,0xffffd
    80004e12:	172080e7          	jalr	370(ra) # 80001f80 <argstr>
    return -1;
    80004e16:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e18:	0e054a63          	bltz	a0,80004f0c <sys_exec+0x112>
    80004e1c:	e4840593          	addi	a1,s0,-440
    80004e20:	4505                	li	a0,1
    80004e22:	ffffd097          	auipc	ra,0xffffd
    80004e26:	13c080e7          	jalr	316(ra) # 80001f5e <argaddr>
    80004e2a:	0e054163          	bltz	a0,80004f0c <sys_exec+0x112>
    80004e2e:	f726                	sd	s1,424(sp)
    80004e30:	ef4e                	sd	s3,408(sp)
    80004e32:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004e34:	10000613          	li	a2,256
    80004e38:	4581                	li	a1,0
    80004e3a:	e5040513          	addi	a0,s0,-432
    80004e3e:	ffffb097          	auipc	ra,0xffffb
    80004e42:	33c080e7          	jalr	828(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e46:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004e4a:	89a6                	mv	s3,s1
    80004e4c:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e4e:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e52:	00391513          	slli	a0,s2,0x3
    80004e56:	e4040593          	addi	a1,s0,-448
    80004e5a:	e4843783          	ld	a5,-440(s0)
    80004e5e:	953e                	add	a0,a0,a5
    80004e60:	ffffd097          	auipc	ra,0xffffd
    80004e64:	042080e7          	jalr	66(ra) # 80001ea2 <fetchaddr>
    80004e68:	02054a63          	bltz	a0,80004e9c <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80004e6c:	e4043783          	ld	a5,-448(s0)
    80004e70:	c7b1                	beqz	a5,80004ebc <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004e72:	ffffb097          	auipc	ra,0xffffb
    80004e76:	2a8080e7          	jalr	680(ra) # 8000011a <kalloc>
    80004e7a:	85aa                	mv	a1,a0
    80004e7c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004e80:	cd11                	beqz	a0,80004e9c <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004e82:	6605                	lui	a2,0x1
    80004e84:	e4043503          	ld	a0,-448(s0)
    80004e88:	ffffd097          	auipc	ra,0xffffd
    80004e8c:	06c080e7          	jalr	108(ra) # 80001ef4 <fetchstr>
    80004e90:	00054663          	bltz	a0,80004e9c <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80004e94:	0905                	addi	s2,s2,1
    80004e96:	09a1                	addi	s3,s3,8
    80004e98:	fb491de3          	bne	s2,s4,80004e52 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004e9c:	f5040913          	addi	s2,s0,-176
    80004ea0:	6088                	ld	a0,0(s1)
    80004ea2:	c12d                	beqz	a0,80004f04 <sys_exec+0x10a>
    kfree(argv[i]);
    80004ea4:	ffffb097          	auipc	ra,0xffffb
    80004ea8:	178080e7          	jalr	376(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eac:	04a1                	addi	s1,s1,8
    80004eae:	ff2499e3          	bne	s1,s2,80004ea0 <sys_exec+0xa6>
  return -1;
    80004eb2:	597d                	li	s2,-1
    80004eb4:	74ba                	ld	s1,424(sp)
    80004eb6:	69fa                	ld	s3,408(sp)
    80004eb8:	6a5a                	ld	s4,400(sp)
    80004eba:	a889                	j	80004f0c <sys_exec+0x112>
      argv[i] = 0;
    80004ebc:	0009079b          	sext.w	a5,s2
    80004ec0:	078e                	slli	a5,a5,0x3
    80004ec2:	fd078793          	addi	a5,a5,-48
    80004ec6:	97a2                	add	a5,a5,s0
    80004ec8:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004ecc:	e5040593          	addi	a1,s0,-432
    80004ed0:	f5040513          	addi	a0,s0,-176
    80004ed4:	fffff097          	auipc	ra,0xfffff
    80004ed8:	126080e7          	jalr	294(ra) # 80003ffa <exec>
    80004edc:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ede:	f5040993          	addi	s3,s0,-176
    80004ee2:	6088                	ld	a0,0(s1)
    80004ee4:	cd01                	beqz	a0,80004efc <sys_exec+0x102>
    kfree(argv[i]);
    80004ee6:	ffffb097          	auipc	ra,0xffffb
    80004eea:	136080e7          	jalr	310(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eee:	04a1                	addi	s1,s1,8
    80004ef0:	ff3499e3          	bne	s1,s3,80004ee2 <sys_exec+0xe8>
    80004ef4:	74ba                	ld	s1,424(sp)
    80004ef6:	69fa                	ld	s3,408(sp)
    80004ef8:	6a5a                	ld	s4,400(sp)
    80004efa:	a809                	j	80004f0c <sys_exec+0x112>
  return ret;
    80004efc:	74ba                	ld	s1,424(sp)
    80004efe:	69fa                	ld	s3,408(sp)
    80004f00:	6a5a                	ld	s4,400(sp)
    80004f02:	a029                	j	80004f0c <sys_exec+0x112>
  return -1;
    80004f04:	597d                	li	s2,-1
    80004f06:	74ba                	ld	s1,424(sp)
    80004f08:	69fa                	ld	s3,408(sp)
    80004f0a:	6a5a                	ld	s4,400(sp)
}
    80004f0c:	854a                	mv	a0,s2
    80004f0e:	70fa                	ld	ra,440(sp)
    80004f10:	745a                	ld	s0,432(sp)
    80004f12:	791a                	ld	s2,416(sp)
    80004f14:	6139                	addi	sp,sp,448
    80004f16:	8082                	ret

0000000080004f18 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f18:	7139                	addi	sp,sp,-64
    80004f1a:	fc06                	sd	ra,56(sp)
    80004f1c:	f822                	sd	s0,48(sp)
    80004f1e:	f426                	sd	s1,40(sp)
    80004f20:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f22:	ffffc097          	auipc	ra,0xffffc
    80004f26:	f5a080e7          	jalr	-166(ra) # 80000e7c <myproc>
    80004f2a:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f2c:	fd840593          	addi	a1,s0,-40
    80004f30:	4501                	li	a0,0
    80004f32:	ffffd097          	auipc	ra,0xffffd
    80004f36:	02c080e7          	jalr	44(ra) # 80001f5e <argaddr>
    return -1;
    80004f3a:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f3c:	0e054063          	bltz	a0,8000501c <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f40:	fc840593          	addi	a1,s0,-56
    80004f44:	fd040513          	addi	a0,s0,-48
    80004f48:	fffff097          	auipc	ra,0xfffff
    80004f4c:	d70080e7          	jalr	-656(ra) # 80003cb8 <pipealloc>
    return -1;
    80004f50:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f52:	0c054563          	bltz	a0,8000501c <sys_pipe+0x104>
  fd0 = -1;
    80004f56:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f5a:	fd043503          	ld	a0,-48(s0)
    80004f5e:	fffff097          	auipc	ra,0xfffff
    80004f62:	4ce080e7          	jalr	1230(ra) # 8000442c <fdalloc>
    80004f66:	fca42223          	sw	a0,-60(s0)
    80004f6a:	08054c63          	bltz	a0,80005002 <sys_pipe+0xea>
    80004f6e:	fc843503          	ld	a0,-56(s0)
    80004f72:	fffff097          	auipc	ra,0xfffff
    80004f76:	4ba080e7          	jalr	1210(ra) # 8000442c <fdalloc>
    80004f7a:	fca42023          	sw	a0,-64(s0)
    80004f7e:	06054963          	bltz	a0,80004ff0 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f82:	4691                	li	a3,4
    80004f84:	fc440613          	addi	a2,s0,-60
    80004f88:	fd843583          	ld	a1,-40(s0)
    80004f8c:	68a8                	ld	a0,80(s1)
    80004f8e:	ffffc097          	auipc	ra,0xffffc
    80004f92:	b8a080e7          	jalr	-1142(ra) # 80000b18 <copyout>
    80004f96:	02054063          	bltz	a0,80004fb6 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004f9a:	4691                	li	a3,4
    80004f9c:	fc040613          	addi	a2,s0,-64
    80004fa0:	fd843583          	ld	a1,-40(s0)
    80004fa4:	0591                	addi	a1,a1,4
    80004fa6:	68a8                	ld	a0,80(s1)
    80004fa8:	ffffc097          	auipc	ra,0xffffc
    80004fac:	b70080e7          	jalr	-1168(ra) # 80000b18 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fb0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fb2:	06055563          	bgez	a0,8000501c <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004fb6:	fc442783          	lw	a5,-60(s0)
    80004fba:	07e9                	addi	a5,a5,26
    80004fbc:	078e                	slli	a5,a5,0x3
    80004fbe:	97a6                	add	a5,a5,s1
    80004fc0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004fc4:	fc042783          	lw	a5,-64(s0)
    80004fc8:	07e9                	addi	a5,a5,26
    80004fca:	078e                	slli	a5,a5,0x3
    80004fcc:	00f48533          	add	a0,s1,a5
    80004fd0:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004fd4:	fd043503          	ld	a0,-48(s0)
    80004fd8:	fffff097          	auipc	ra,0xfffff
    80004fdc:	972080e7          	jalr	-1678(ra) # 8000394a <fileclose>
    fileclose(wf);
    80004fe0:	fc843503          	ld	a0,-56(s0)
    80004fe4:	fffff097          	auipc	ra,0xfffff
    80004fe8:	966080e7          	jalr	-1690(ra) # 8000394a <fileclose>
    return -1;
    80004fec:	57fd                	li	a5,-1
    80004fee:	a03d                	j	8000501c <sys_pipe+0x104>
    if(fd0 >= 0)
    80004ff0:	fc442783          	lw	a5,-60(s0)
    80004ff4:	0007c763          	bltz	a5,80005002 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80004ff8:	07e9                	addi	a5,a5,26
    80004ffa:	078e                	slli	a5,a5,0x3
    80004ffc:	97a6                	add	a5,a5,s1
    80004ffe:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005002:	fd043503          	ld	a0,-48(s0)
    80005006:	fffff097          	auipc	ra,0xfffff
    8000500a:	944080e7          	jalr	-1724(ra) # 8000394a <fileclose>
    fileclose(wf);
    8000500e:	fc843503          	ld	a0,-56(s0)
    80005012:	fffff097          	auipc	ra,0xfffff
    80005016:	938080e7          	jalr	-1736(ra) # 8000394a <fileclose>
    return -1;
    8000501a:	57fd                	li	a5,-1
}
    8000501c:	853e                	mv	a0,a5
    8000501e:	70e2                	ld	ra,56(sp)
    80005020:	7442                	ld	s0,48(sp)
    80005022:	74a2                	ld	s1,40(sp)
    80005024:	6121                	addi	sp,sp,64
    80005026:	8082                	ret
	...

0000000080005030 <kernelvec>:
    80005030:	7111                	addi	sp,sp,-256
    80005032:	e006                	sd	ra,0(sp)
    80005034:	e40a                	sd	sp,8(sp)
    80005036:	e80e                	sd	gp,16(sp)
    80005038:	ec12                	sd	tp,24(sp)
    8000503a:	f016                	sd	t0,32(sp)
    8000503c:	f41a                	sd	t1,40(sp)
    8000503e:	f81e                	sd	t2,48(sp)
    80005040:	fc22                	sd	s0,56(sp)
    80005042:	e0a6                	sd	s1,64(sp)
    80005044:	e4aa                	sd	a0,72(sp)
    80005046:	e8ae                	sd	a1,80(sp)
    80005048:	ecb2                	sd	a2,88(sp)
    8000504a:	f0b6                	sd	a3,96(sp)
    8000504c:	f4ba                	sd	a4,104(sp)
    8000504e:	f8be                	sd	a5,112(sp)
    80005050:	fcc2                	sd	a6,120(sp)
    80005052:	e146                	sd	a7,128(sp)
    80005054:	e54a                	sd	s2,136(sp)
    80005056:	e94e                	sd	s3,144(sp)
    80005058:	ed52                	sd	s4,152(sp)
    8000505a:	f156                	sd	s5,160(sp)
    8000505c:	f55a                	sd	s6,168(sp)
    8000505e:	f95e                	sd	s7,176(sp)
    80005060:	fd62                	sd	s8,184(sp)
    80005062:	e1e6                	sd	s9,192(sp)
    80005064:	e5ea                	sd	s10,200(sp)
    80005066:	e9ee                	sd	s11,208(sp)
    80005068:	edf2                	sd	t3,216(sp)
    8000506a:	f1f6                	sd	t4,224(sp)
    8000506c:	f5fa                	sd	t5,232(sp)
    8000506e:	f9fe                	sd	t6,240(sp)
    80005070:	cfffc0ef          	jal	80001d6e <kerneltrap>
    80005074:	6082                	ld	ra,0(sp)
    80005076:	6122                	ld	sp,8(sp)
    80005078:	61c2                	ld	gp,16(sp)
    8000507a:	7282                	ld	t0,32(sp)
    8000507c:	7322                	ld	t1,40(sp)
    8000507e:	73c2                	ld	t2,48(sp)
    80005080:	7462                	ld	s0,56(sp)
    80005082:	6486                	ld	s1,64(sp)
    80005084:	6526                	ld	a0,72(sp)
    80005086:	65c6                	ld	a1,80(sp)
    80005088:	6666                	ld	a2,88(sp)
    8000508a:	7686                	ld	a3,96(sp)
    8000508c:	7726                	ld	a4,104(sp)
    8000508e:	77c6                	ld	a5,112(sp)
    80005090:	7866                	ld	a6,120(sp)
    80005092:	688a                	ld	a7,128(sp)
    80005094:	692a                	ld	s2,136(sp)
    80005096:	69ca                	ld	s3,144(sp)
    80005098:	6a6a                	ld	s4,152(sp)
    8000509a:	7a8a                	ld	s5,160(sp)
    8000509c:	7b2a                	ld	s6,168(sp)
    8000509e:	7bca                	ld	s7,176(sp)
    800050a0:	7c6a                	ld	s8,184(sp)
    800050a2:	6c8e                	ld	s9,192(sp)
    800050a4:	6d2e                	ld	s10,200(sp)
    800050a6:	6dce                	ld	s11,208(sp)
    800050a8:	6e6e                	ld	t3,216(sp)
    800050aa:	7e8e                	ld	t4,224(sp)
    800050ac:	7f2e                	ld	t5,232(sp)
    800050ae:	7fce                	ld	t6,240(sp)
    800050b0:	6111                	addi	sp,sp,256
    800050b2:	10200073          	sret
    800050b6:	00000013          	nop
    800050ba:	00000013          	nop
    800050be:	0001                	nop

00000000800050c0 <timervec>:
    800050c0:	34051573          	csrrw	a0,mscratch,a0
    800050c4:	e10c                	sd	a1,0(a0)
    800050c6:	e510                	sd	a2,8(a0)
    800050c8:	e914                	sd	a3,16(a0)
    800050ca:	6d0c                	ld	a1,24(a0)
    800050cc:	7110                	ld	a2,32(a0)
    800050ce:	6194                	ld	a3,0(a1)
    800050d0:	96b2                	add	a3,a3,a2
    800050d2:	e194                	sd	a3,0(a1)
    800050d4:	4589                	li	a1,2
    800050d6:	14459073          	csrw	sip,a1
    800050da:	6914                	ld	a3,16(a0)
    800050dc:	6510                	ld	a2,8(a0)
    800050de:	610c                	ld	a1,0(a0)
    800050e0:	34051573          	csrrw	a0,mscratch,a0
    800050e4:	30200073          	mret
	...

00000000800050ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800050ea:	1141                	addi	sp,sp,-16
    800050ec:	e422                	sd	s0,8(sp)
    800050ee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800050f0:	0c0007b7          	lui	a5,0xc000
    800050f4:	4705                	li	a4,1
    800050f6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800050f8:	0c0007b7          	lui	a5,0xc000
    800050fc:	c3d8                	sw	a4,4(a5)
}
    800050fe:	6422                	ld	s0,8(sp)
    80005100:	0141                	addi	sp,sp,16
    80005102:	8082                	ret

0000000080005104 <plicinithart>:

void
plicinithart(void)
{
    80005104:	1141                	addi	sp,sp,-16
    80005106:	e406                	sd	ra,8(sp)
    80005108:	e022                	sd	s0,0(sp)
    8000510a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000510c:	ffffc097          	auipc	ra,0xffffc
    80005110:	d44080e7          	jalr	-700(ra) # 80000e50 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005114:	0085171b          	slliw	a4,a0,0x8
    80005118:	0c0027b7          	lui	a5,0xc002
    8000511c:	97ba                	add	a5,a5,a4
    8000511e:	40200713          	li	a4,1026
    80005122:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005126:	00d5151b          	slliw	a0,a0,0xd
    8000512a:	0c2017b7          	lui	a5,0xc201
    8000512e:	97aa                	add	a5,a5,a0
    80005130:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005134:	60a2                	ld	ra,8(sp)
    80005136:	6402                	ld	s0,0(sp)
    80005138:	0141                	addi	sp,sp,16
    8000513a:	8082                	ret

000000008000513c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000513c:	1141                	addi	sp,sp,-16
    8000513e:	e406                	sd	ra,8(sp)
    80005140:	e022                	sd	s0,0(sp)
    80005142:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005144:	ffffc097          	auipc	ra,0xffffc
    80005148:	d0c080e7          	jalr	-756(ra) # 80000e50 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000514c:	00d5151b          	slliw	a0,a0,0xd
    80005150:	0c2017b7          	lui	a5,0xc201
    80005154:	97aa                	add	a5,a5,a0
  return irq;
}
    80005156:	43c8                	lw	a0,4(a5)
    80005158:	60a2                	ld	ra,8(sp)
    8000515a:	6402                	ld	s0,0(sp)
    8000515c:	0141                	addi	sp,sp,16
    8000515e:	8082                	ret

0000000080005160 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005160:	1101                	addi	sp,sp,-32
    80005162:	ec06                	sd	ra,24(sp)
    80005164:	e822                	sd	s0,16(sp)
    80005166:	e426                	sd	s1,8(sp)
    80005168:	1000                	addi	s0,sp,32
    8000516a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000516c:	ffffc097          	auipc	ra,0xffffc
    80005170:	ce4080e7          	jalr	-796(ra) # 80000e50 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005174:	00d5151b          	slliw	a0,a0,0xd
    80005178:	0c2017b7          	lui	a5,0xc201
    8000517c:	97aa                	add	a5,a5,a0
    8000517e:	c3c4                	sw	s1,4(a5)
}
    80005180:	60e2                	ld	ra,24(sp)
    80005182:	6442                	ld	s0,16(sp)
    80005184:	64a2                	ld	s1,8(sp)
    80005186:	6105                	addi	sp,sp,32
    80005188:	8082                	ret

000000008000518a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000518a:	1141                	addi	sp,sp,-16
    8000518c:	e406                	sd	ra,8(sp)
    8000518e:	e022                	sd	s0,0(sp)
    80005190:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005192:	479d                	li	a5,7
    80005194:	06a7c863          	blt	a5,a0,80005204 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005198:	00019717          	auipc	a4,0x19
    8000519c:	e6870713          	addi	a4,a4,-408 # 8001e000 <disk>
    800051a0:	972a                	add	a4,a4,a0
    800051a2:	6789                	lui	a5,0x2
    800051a4:	97ba                	add	a5,a5,a4
    800051a6:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800051aa:	e7ad                	bnez	a5,80005214 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051ac:	00451793          	slli	a5,a0,0x4
    800051b0:	0001b717          	auipc	a4,0x1b
    800051b4:	e5070713          	addi	a4,a4,-432 # 80020000 <disk+0x2000>
    800051b8:	6314                	ld	a3,0(a4)
    800051ba:	96be                	add	a3,a3,a5
    800051bc:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800051c0:	6314                	ld	a3,0(a4)
    800051c2:	96be                	add	a3,a3,a5
    800051c4:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800051c8:	6314                	ld	a3,0(a4)
    800051ca:	96be                	add	a3,a3,a5
    800051cc:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800051d0:	6318                	ld	a4,0(a4)
    800051d2:	97ba                	add	a5,a5,a4
    800051d4:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800051d8:	00019717          	auipc	a4,0x19
    800051dc:	e2870713          	addi	a4,a4,-472 # 8001e000 <disk>
    800051e0:	972a                	add	a4,a4,a0
    800051e2:	6789                	lui	a5,0x2
    800051e4:	97ba                	add	a5,a5,a4
    800051e6:	4705                	li	a4,1
    800051e8:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800051ec:	0001b517          	auipc	a0,0x1b
    800051f0:	e2c50513          	addi	a0,a0,-468 # 80020018 <disk+0x2018>
    800051f4:	ffffc097          	auipc	ra,0xffffc
    800051f8:	4da080e7          	jalr	1242(ra) # 800016ce <wakeup>
}
    800051fc:	60a2                	ld	ra,8(sp)
    800051fe:	6402                	ld	s0,0(sp)
    80005200:	0141                	addi	sp,sp,16
    80005202:	8082                	ret
    panic("free_desc 1");
    80005204:	00003517          	auipc	a0,0x3
    80005208:	3ec50513          	addi	a0,a0,1004 # 800085f0 <etext+0x5f0>
    8000520c:	00001097          	auipc	ra,0x1
    80005210:	a10080e7          	jalr	-1520(ra) # 80005c1c <panic>
    panic("free_desc 2");
    80005214:	00003517          	auipc	a0,0x3
    80005218:	3ec50513          	addi	a0,a0,1004 # 80008600 <etext+0x600>
    8000521c:	00001097          	auipc	ra,0x1
    80005220:	a00080e7          	jalr	-1536(ra) # 80005c1c <panic>

0000000080005224 <virtio_disk_init>:
{
    80005224:	1141                	addi	sp,sp,-16
    80005226:	e406                	sd	ra,8(sp)
    80005228:	e022                	sd	s0,0(sp)
    8000522a:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000522c:	00003597          	auipc	a1,0x3
    80005230:	3e458593          	addi	a1,a1,996 # 80008610 <etext+0x610>
    80005234:	0001b517          	auipc	a0,0x1b
    80005238:	ef450513          	addi	a0,a0,-268 # 80020128 <disk+0x2128>
    8000523c:	00001097          	auipc	ra,0x1
    80005240:	eca080e7          	jalr	-310(ra) # 80006106 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005244:	100017b7          	lui	a5,0x10001
    80005248:	4398                	lw	a4,0(a5)
    8000524a:	2701                	sext.w	a4,a4
    8000524c:	747277b7          	lui	a5,0x74727
    80005250:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005254:	0ef71f63          	bne	a4,a5,80005352 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005258:	100017b7          	lui	a5,0x10001
    8000525c:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000525e:	439c                	lw	a5,0(a5)
    80005260:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005262:	4705                	li	a4,1
    80005264:	0ee79763          	bne	a5,a4,80005352 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005268:	100017b7          	lui	a5,0x10001
    8000526c:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000526e:	439c                	lw	a5,0(a5)
    80005270:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005272:	4709                	li	a4,2
    80005274:	0ce79f63          	bne	a5,a4,80005352 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005278:	100017b7          	lui	a5,0x10001
    8000527c:	47d8                	lw	a4,12(a5)
    8000527e:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005280:	554d47b7          	lui	a5,0x554d4
    80005284:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005288:	0cf71563          	bne	a4,a5,80005352 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000528c:	100017b7          	lui	a5,0x10001
    80005290:	4705                	li	a4,1
    80005292:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005294:	470d                	li	a4,3
    80005296:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005298:	10001737          	lui	a4,0x10001
    8000529c:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000529e:	c7ffe737          	lui	a4,0xc7ffe
    800052a2:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd551f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052a6:	8ef9                	and	a3,a3,a4
    800052a8:	10001737          	lui	a4,0x10001
    800052ac:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052ae:	472d                	li	a4,11
    800052b0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052b2:	473d                	li	a4,15
    800052b4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800052b6:	100017b7          	lui	a5,0x10001
    800052ba:	6705                	lui	a4,0x1
    800052bc:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052be:	100017b7          	lui	a5,0x10001
    800052c2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052c6:	100017b7          	lui	a5,0x10001
    800052ca:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800052ce:	439c                	lw	a5,0(a5)
    800052d0:	2781                	sext.w	a5,a5
  if(max == 0)
    800052d2:	cbc1                	beqz	a5,80005362 <virtio_disk_init+0x13e>
  if(max < NUM)
    800052d4:	471d                	li	a4,7
    800052d6:	08f77e63          	bgeu	a4,a5,80005372 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052da:	100017b7          	lui	a5,0x10001
    800052de:	4721                	li	a4,8
    800052e0:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    800052e2:	6609                	lui	a2,0x2
    800052e4:	4581                	li	a1,0
    800052e6:	00019517          	auipc	a0,0x19
    800052ea:	d1a50513          	addi	a0,a0,-742 # 8001e000 <disk>
    800052ee:	ffffb097          	auipc	ra,0xffffb
    800052f2:	e8c080e7          	jalr	-372(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800052f6:	00019697          	auipc	a3,0x19
    800052fa:	d0a68693          	addi	a3,a3,-758 # 8001e000 <disk>
    800052fe:	00c6d713          	srli	a4,a3,0xc
    80005302:	2701                	sext.w	a4,a4
    80005304:	100017b7          	lui	a5,0x10001
    80005308:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000530a:	0001b797          	auipc	a5,0x1b
    8000530e:	cf678793          	addi	a5,a5,-778 # 80020000 <disk+0x2000>
    80005312:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005314:	00019717          	auipc	a4,0x19
    80005318:	d6c70713          	addi	a4,a4,-660 # 8001e080 <disk+0x80>
    8000531c:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000531e:	0001a717          	auipc	a4,0x1a
    80005322:	ce270713          	addi	a4,a4,-798 # 8001f000 <disk+0x1000>
    80005326:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005328:	4705                	li	a4,1
    8000532a:	00e78c23          	sb	a4,24(a5)
    8000532e:	00e78ca3          	sb	a4,25(a5)
    80005332:	00e78d23          	sb	a4,26(a5)
    80005336:	00e78da3          	sb	a4,27(a5)
    8000533a:	00e78e23          	sb	a4,28(a5)
    8000533e:	00e78ea3          	sb	a4,29(a5)
    80005342:	00e78f23          	sb	a4,30(a5)
    80005346:	00e78fa3          	sb	a4,31(a5)
}
    8000534a:	60a2                	ld	ra,8(sp)
    8000534c:	6402                	ld	s0,0(sp)
    8000534e:	0141                	addi	sp,sp,16
    80005350:	8082                	ret
    panic("could not find virtio disk");
    80005352:	00003517          	auipc	a0,0x3
    80005356:	2ce50513          	addi	a0,a0,718 # 80008620 <etext+0x620>
    8000535a:	00001097          	auipc	ra,0x1
    8000535e:	8c2080e7          	jalr	-1854(ra) # 80005c1c <panic>
    panic("virtio disk has no queue 0");
    80005362:	00003517          	auipc	a0,0x3
    80005366:	2de50513          	addi	a0,a0,734 # 80008640 <etext+0x640>
    8000536a:	00001097          	auipc	ra,0x1
    8000536e:	8b2080e7          	jalr	-1870(ra) # 80005c1c <panic>
    panic("virtio disk max queue too short");
    80005372:	00003517          	auipc	a0,0x3
    80005376:	2ee50513          	addi	a0,a0,750 # 80008660 <etext+0x660>
    8000537a:	00001097          	auipc	ra,0x1
    8000537e:	8a2080e7          	jalr	-1886(ra) # 80005c1c <panic>

0000000080005382 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005382:	7159                	addi	sp,sp,-112
    80005384:	f486                	sd	ra,104(sp)
    80005386:	f0a2                	sd	s0,96(sp)
    80005388:	eca6                	sd	s1,88(sp)
    8000538a:	e8ca                	sd	s2,80(sp)
    8000538c:	e4ce                	sd	s3,72(sp)
    8000538e:	e0d2                	sd	s4,64(sp)
    80005390:	fc56                	sd	s5,56(sp)
    80005392:	f85a                	sd	s6,48(sp)
    80005394:	f45e                	sd	s7,40(sp)
    80005396:	f062                	sd	s8,32(sp)
    80005398:	ec66                	sd	s9,24(sp)
    8000539a:	1880                	addi	s0,sp,112
    8000539c:	8a2a                	mv	s4,a0
    8000539e:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053a0:	00c52c03          	lw	s8,12(a0)
    800053a4:	001c1c1b          	slliw	s8,s8,0x1
    800053a8:	1c02                	slli	s8,s8,0x20
    800053aa:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    800053ae:	0001b517          	auipc	a0,0x1b
    800053b2:	d7a50513          	addi	a0,a0,-646 # 80020128 <disk+0x2128>
    800053b6:	00001097          	auipc	ra,0x1
    800053ba:	de0080e7          	jalr	-544(ra) # 80006196 <acquire>
  for(int i = 0; i < 3; i++){
    800053be:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053c0:	44a1                	li	s1,8
      disk.free[i] = 0;
    800053c2:	00019b97          	auipc	s7,0x19
    800053c6:	c3eb8b93          	addi	s7,s7,-962 # 8001e000 <disk>
    800053ca:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800053cc:	4a8d                	li	s5,3
    800053ce:	a88d                	j	80005440 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    800053d0:	00fb8733          	add	a4,s7,a5
    800053d4:	975a                	add	a4,a4,s6
    800053d6:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800053da:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800053dc:	0207c563          	bltz	a5,80005406 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    800053e0:	2905                	addiw	s2,s2,1
    800053e2:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800053e4:	1b590163          	beq	s2,s5,80005586 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    800053e8:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800053ea:	0001b717          	auipc	a4,0x1b
    800053ee:	c2e70713          	addi	a4,a4,-978 # 80020018 <disk+0x2018>
    800053f2:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800053f4:	00074683          	lbu	a3,0(a4)
    800053f8:	fee1                	bnez	a3,800053d0 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    800053fa:	2785                	addiw	a5,a5,1
    800053fc:	0705                	addi	a4,a4,1
    800053fe:	fe979be3          	bne	a5,s1,800053f4 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005402:	57fd                	li	a5,-1
    80005404:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005406:	03205163          	blez	s2,80005428 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000540a:	f9042503          	lw	a0,-112(s0)
    8000540e:	00000097          	auipc	ra,0x0
    80005412:	d7c080e7          	jalr	-644(ra) # 8000518a <free_desc>
      for(int j = 0; j < i; j++)
    80005416:	4785                	li	a5,1
    80005418:	0127d863          	bge	a5,s2,80005428 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000541c:	f9442503          	lw	a0,-108(s0)
    80005420:	00000097          	auipc	ra,0x0
    80005424:	d6a080e7          	jalr	-662(ra) # 8000518a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005428:	0001b597          	auipc	a1,0x1b
    8000542c:	d0058593          	addi	a1,a1,-768 # 80020128 <disk+0x2128>
    80005430:	0001b517          	auipc	a0,0x1b
    80005434:	be850513          	addi	a0,a0,-1048 # 80020018 <disk+0x2018>
    80005438:	ffffc097          	auipc	ra,0xffffc
    8000543c:	10a080e7          	jalr	266(ra) # 80001542 <sleep>
  for(int i = 0; i < 3; i++){
    80005440:	f9040613          	addi	a2,s0,-112
    80005444:	894e                	mv	s2,s3
    80005446:	b74d                	j	800053e8 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005448:	0001b717          	auipc	a4,0x1b
    8000544c:	bb873703          	ld	a4,-1096(a4) # 80020000 <disk+0x2000>
    80005450:	973e                	add	a4,a4,a5
    80005452:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005456:	00019897          	auipc	a7,0x19
    8000545a:	baa88893          	addi	a7,a7,-1110 # 8001e000 <disk>
    8000545e:	0001b717          	auipc	a4,0x1b
    80005462:	ba270713          	addi	a4,a4,-1118 # 80020000 <disk+0x2000>
    80005466:	6314                	ld	a3,0(a4)
    80005468:	96be                	add	a3,a3,a5
    8000546a:	00c6d583          	lhu	a1,12(a3)
    8000546e:	0015e593          	ori	a1,a1,1
    80005472:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005476:	f9842683          	lw	a3,-104(s0)
    8000547a:	630c                	ld	a1,0(a4)
    8000547c:	97ae                	add	a5,a5,a1
    8000547e:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005482:	20050593          	addi	a1,a0,512
    80005486:	0592                	slli	a1,a1,0x4
    80005488:	95c6                	add	a1,a1,a7
    8000548a:	57fd                	li	a5,-1
    8000548c:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005490:	00469793          	slli	a5,a3,0x4
    80005494:	00073803          	ld	a6,0(a4)
    80005498:	983e                	add	a6,a6,a5
    8000549a:	6689                	lui	a3,0x2
    8000549c:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    800054a0:	96b2                	add	a3,a3,a2
    800054a2:	96c6                	add	a3,a3,a7
    800054a4:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    800054a8:	6314                	ld	a3,0(a4)
    800054aa:	96be                	add	a3,a3,a5
    800054ac:	4605                	li	a2,1
    800054ae:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800054b0:	6314                	ld	a3,0(a4)
    800054b2:	96be                	add	a3,a3,a5
    800054b4:	4809                	li	a6,2
    800054b6:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    800054ba:	6314                	ld	a3,0(a4)
    800054bc:	97b6                	add	a5,a5,a3
    800054be:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800054c2:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    800054c6:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800054ca:	6714                	ld	a3,8(a4)
    800054cc:	0026d783          	lhu	a5,2(a3)
    800054d0:	8b9d                	andi	a5,a5,7
    800054d2:	0786                	slli	a5,a5,0x1
    800054d4:	96be                	add	a3,a3,a5
    800054d6:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800054da:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800054de:	6718                	ld	a4,8(a4)
    800054e0:	00275783          	lhu	a5,2(a4)
    800054e4:	2785                	addiw	a5,a5,1
    800054e6:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800054ea:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800054ee:	100017b7          	lui	a5,0x10001
    800054f2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800054f6:	004a2783          	lw	a5,4(s4)
    800054fa:	02c79163          	bne	a5,a2,8000551c <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    800054fe:	0001b917          	auipc	s2,0x1b
    80005502:	c2a90913          	addi	s2,s2,-982 # 80020128 <disk+0x2128>
  while(b->disk == 1) {
    80005506:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005508:	85ca                	mv	a1,s2
    8000550a:	8552                	mv	a0,s4
    8000550c:	ffffc097          	auipc	ra,0xffffc
    80005510:	036080e7          	jalr	54(ra) # 80001542 <sleep>
  while(b->disk == 1) {
    80005514:	004a2783          	lw	a5,4(s4)
    80005518:	fe9788e3          	beq	a5,s1,80005508 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    8000551c:	f9042903          	lw	s2,-112(s0)
    80005520:	20090713          	addi	a4,s2,512
    80005524:	0712                	slli	a4,a4,0x4
    80005526:	00019797          	auipc	a5,0x19
    8000552a:	ada78793          	addi	a5,a5,-1318 # 8001e000 <disk>
    8000552e:	97ba                	add	a5,a5,a4
    80005530:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005534:	0001b997          	auipc	s3,0x1b
    80005538:	acc98993          	addi	s3,s3,-1332 # 80020000 <disk+0x2000>
    8000553c:	00491713          	slli	a4,s2,0x4
    80005540:	0009b783          	ld	a5,0(s3)
    80005544:	97ba                	add	a5,a5,a4
    80005546:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000554a:	854a                	mv	a0,s2
    8000554c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005550:	00000097          	auipc	ra,0x0
    80005554:	c3a080e7          	jalr	-966(ra) # 8000518a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005558:	8885                	andi	s1,s1,1
    8000555a:	f0ed                	bnez	s1,8000553c <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000555c:	0001b517          	auipc	a0,0x1b
    80005560:	bcc50513          	addi	a0,a0,-1076 # 80020128 <disk+0x2128>
    80005564:	00001097          	auipc	ra,0x1
    80005568:	ce6080e7          	jalr	-794(ra) # 8000624a <release>
}
    8000556c:	70a6                	ld	ra,104(sp)
    8000556e:	7406                	ld	s0,96(sp)
    80005570:	64e6                	ld	s1,88(sp)
    80005572:	6946                	ld	s2,80(sp)
    80005574:	69a6                	ld	s3,72(sp)
    80005576:	6a06                	ld	s4,64(sp)
    80005578:	7ae2                	ld	s5,56(sp)
    8000557a:	7b42                	ld	s6,48(sp)
    8000557c:	7ba2                	ld	s7,40(sp)
    8000557e:	7c02                	ld	s8,32(sp)
    80005580:	6ce2                	ld	s9,24(sp)
    80005582:	6165                	addi	sp,sp,112
    80005584:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005586:	f9042503          	lw	a0,-112(s0)
    8000558a:	00451613          	slli	a2,a0,0x4
  if(write)
    8000558e:	00019597          	auipc	a1,0x19
    80005592:	a7258593          	addi	a1,a1,-1422 # 8001e000 <disk>
    80005596:	20050793          	addi	a5,a0,512
    8000559a:	0792                	slli	a5,a5,0x4
    8000559c:	97ae                	add	a5,a5,a1
    8000559e:	01903733          	snez	a4,s9
    800055a2:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    800055a6:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    800055aa:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055ae:	0001b717          	auipc	a4,0x1b
    800055b2:	a5270713          	addi	a4,a4,-1454 # 80020000 <disk+0x2000>
    800055b6:	6314                	ld	a3,0(a4)
    800055b8:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055ba:	6789                	lui	a5,0x2
    800055bc:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    800055c0:	97b2                	add	a5,a5,a2
    800055c2:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    800055c4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055c6:	631c                	ld	a5,0(a4)
    800055c8:	97b2                	add	a5,a5,a2
    800055ca:	46c1                	li	a3,16
    800055cc:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055ce:	631c                	ld	a5,0(a4)
    800055d0:	97b2                	add	a5,a5,a2
    800055d2:	4685                	li	a3,1
    800055d4:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    800055d8:	f9442783          	lw	a5,-108(s0)
    800055dc:	6314                	ld	a3,0(a4)
    800055de:	96b2                	add	a3,a3,a2
    800055e0:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    800055e4:	0792                	slli	a5,a5,0x4
    800055e6:	6314                	ld	a3,0(a4)
    800055e8:	96be                	add	a3,a3,a5
    800055ea:	058a0593          	addi	a1,s4,88
    800055ee:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    800055f0:	6318                	ld	a4,0(a4)
    800055f2:	973e                	add	a4,a4,a5
    800055f4:	40000693          	li	a3,1024
    800055f8:	c714                	sw	a3,8(a4)
  if(write)
    800055fa:	e40c97e3          	bnez	s9,80005448 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800055fe:	0001b717          	auipc	a4,0x1b
    80005602:	a0273703          	ld	a4,-1534(a4) # 80020000 <disk+0x2000>
    80005606:	973e                	add	a4,a4,a5
    80005608:	4689                	li	a3,2
    8000560a:	00d71623          	sh	a3,12(a4)
    8000560e:	b5a1                	j	80005456 <virtio_disk_rw+0xd4>

0000000080005610 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005610:	1101                	addi	sp,sp,-32
    80005612:	ec06                	sd	ra,24(sp)
    80005614:	e822                	sd	s0,16(sp)
    80005616:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005618:	0001b517          	auipc	a0,0x1b
    8000561c:	b1050513          	addi	a0,a0,-1264 # 80020128 <disk+0x2128>
    80005620:	00001097          	auipc	ra,0x1
    80005624:	b76080e7          	jalr	-1162(ra) # 80006196 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005628:	100017b7          	lui	a5,0x10001
    8000562c:	53b8                	lw	a4,96(a5)
    8000562e:	8b0d                	andi	a4,a4,3
    80005630:	100017b7          	lui	a5,0x10001
    80005634:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005636:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000563a:	0001b797          	auipc	a5,0x1b
    8000563e:	9c678793          	addi	a5,a5,-1594 # 80020000 <disk+0x2000>
    80005642:	6b94                	ld	a3,16(a5)
    80005644:	0207d703          	lhu	a4,32(a5)
    80005648:	0026d783          	lhu	a5,2(a3)
    8000564c:	06f70563          	beq	a4,a5,800056b6 <virtio_disk_intr+0xa6>
    80005650:	e426                	sd	s1,8(sp)
    80005652:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005654:	00019917          	auipc	s2,0x19
    80005658:	9ac90913          	addi	s2,s2,-1620 # 8001e000 <disk>
    8000565c:	0001b497          	auipc	s1,0x1b
    80005660:	9a448493          	addi	s1,s1,-1628 # 80020000 <disk+0x2000>
    __sync_synchronize();
    80005664:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005668:	6898                	ld	a4,16(s1)
    8000566a:	0204d783          	lhu	a5,32(s1)
    8000566e:	8b9d                	andi	a5,a5,7
    80005670:	078e                	slli	a5,a5,0x3
    80005672:	97ba                	add	a5,a5,a4
    80005674:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005676:	20078713          	addi	a4,a5,512
    8000567a:	0712                	slli	a4,a4,0x4
    8000567c:	974a                	add	a4,a4,s2
    8000567e:	03074703          	lbu	a4,48(a4)
    80005682:	e731                	bnez	a4,800056ce <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005684:	20078793          	addi	a5,a5,512
    80005688:	0792                	slli	a5,a5,0x4
    8000568a:	97ca                	add	a5,a5,s2
    8000568c:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    8000568e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005692:	ffffc097          	auipc	ra,0xffffc
    80005696:	03c080e7          	jalr	60(ra) # 800016ce <wakeup>

    disk.used_idx += 1;
    8000569a:	0204d783          	lhu	a5,32(s1)
    8000569e:	2785                	addiw	a5,a5,1
    800056a0:	17c2                	slli	a5,a5,0x30
    800056a2:	93c1                	srli	a5,a5,0x30
    800056a4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056a8:	6898                	ld	a4,16(s1)
    800056aa:	00275703          	lhu	a4,2(a4)
    800056ae:	faf71be3          	bne	a4,a5,80005664 <virtio_disk_intr+0x54>
    800056b2:	64a2                	ld	s1,8(sp)
    800056b4:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    800056b6:	0001b517          	auipc	a0,0x1b
    800056ba:	a7250513          	addi	a0,a0,-1422 # 80020128 <disk+0x2128>
    800056be:	00001097          	auipc	ra,0x1
    800056c2:	b8c080e7          	jalr	-1140(ra) # 8000624a <release>
}
    800056c6:	60e2                	ld	ra,24(sp)
    800056c8:	6442                	ld	s0,16(sp)
    800056ca:	6105                	addi	sp,sp,32
    800056cc:	8082                	ret
      panic("virtio_disk_intr status");
    800056ce:	00003517          	auipc	a0,0x3
    800056d2:	fb250513          	addi	a0,a0,-78 # 80008680 <etext+0x680>
    800056d6:	00000097          	auipc	ra,0x0
    800056da:	546080e7          	jalr	1350(ra) # 80005c1c <panic>

00000000800056de <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800056de:	1141                	addi	sp,sp,-16
    800056e0:	e422                	sd	s0,8(sp)
    800056e2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800056e4:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800056e8:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800056ec:	0037979b          	slliw	a5,a5,0x3
    800056f0:	02004737          	lui	a4,0x2004
    800056f4:	97ba                	add	a5,a5,a4
    800056f6:	0200c737          	lui	a4,0x200c
    800056fa:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    800056fc:	6318                	ld	a4,0(a4)
    800056fe:	000f4637          	lui	a2,0xf4
    80005702:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005706:	9732                	add	a4,a4,a2
    80005708:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000570a:	00259693          	slli	a3,a1,0x2
    8000570e:	96ae                	add	a3,a3,a1
    80005710:	068e                	slli	a3,a3,0x3
    80005712:	0001c717          	auipc	a4,0x1c
    80005716:	8ee70713          	addi	a4,a4,-1810 # 80021000 <timer_scratch>
    8000571a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000571c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000571e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005720:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005724:	00000797          	auipc	a5,0x0
    80005728:	99c78793          	addi	a5,a5,-1636 # 800050c0 <timervec>
    8000572c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005730:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005734:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005738:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000573c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005740:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005744:	30479073          	csrw	mie,a5
}
    80005748:	6422                	ld	s0,8(sp)
    8000574a:	0141                	addi	sp,sp,16
    8000574c:	8082                	ret

000000008000574e <start>:
{
    8000574e:	1141                	addi	sp,sp,-16
    80005750:	e406                	sd	ra,8(sp)
    80005752:	e022                	sd	s0,0(sp)
    80005754:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005756:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000575a:	7779                	lui	a4,0xffffe
    8000575c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd55bf>
    80005760:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005762:	6705                	lui	a4,0x1
    80005764:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005768:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000576a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000576e:	ffffb797          	auipc	a5,0xffffb
    80005772:	baa78793          	addi	a5,a5,-1110 # 80000318 <main>
    80005776:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000577a:	4781                	li	a5,0
    8000577c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005780:	67c1                	lui	a5,0x10
    80005782:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005784:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005788:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000578c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005790:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005794:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005798:	57fd                	li	a5,-1
    8000579a:	83a9                	srli	a5,a5,0xa
    8000579c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057a0:	47bd                	li	a5,15
    800057a2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800057a6:	00000097          	auipc	ra,0x0
    800057aa:	f38080e7          	jalr	-200(ra) # 800056de <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057ae:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800057b2:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800057b4:	823e                	mv	tp,a5
  asm volatile("mret");
    800057b6:	30200073          	mret
}
    800057ba:	60a2                	ld	ra,8(sp)
    800057bc:	6402                	ld	s0,0(sp)
    800057be:	0141                	addi	sp,sp,16
    800057c0:	8082                	ret

00000000800057c2 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800057c2:	715d                	addi	sp,sp,-80
    800057c4:	e486                	sd	ra,72(sp)
    800057c6:	e0a2                	sd	s0,64(sp)
    800057c8:	f84a                	sd	s2,48(sp)
    800057ca:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800057cc:	04c05663          	blez	a2,80005818 <consolewrite+0x56>
    800057d0:	fc26                	sd	s1,56(sp)
    800057d2:	f44e                	sd	s3,40(sp)
    800057d4:	f052                	sd	s4,32(sp)
    800057d6:	ec56                	sd	s5,24(sp)
    800057d8:	8a2a                	mv	s4,a0
    800057da:	84ae                	mv	s1,a1
    800057dc:	89b2                	mv	s3,a2
    800057de:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800057e0:	5afd                	li	s5,-1
    800057e2:	4685                	li	a3,1
    800057e4:	8626                	mv	a2,s1
    800057e6:	85d2                	mv	a1,s4
    800057e8:	fbf40513          	addi	a0,s0,-65
    800057ec:	ffffc097          	auipc	ra,0xffffc
    800057f0:	150080e7          	jalr	336(ra) # 8000193c <either_copyin>
    800057f4:	03550463          	beq	a0,s5,8000581c <consolewrite+0x5a>
      break;
    uartputc(c);
    800057f8:	fbf44503          	lbu	a0,-65(s0)
    800057fc:	00000097          	auipc	ra,0x0
    80005800:	7de080e7          	jalr	2014(ra) # 80005fda <uartputc>
  for(i = 0; i < n; i++){
    80005804:	2905                	addiw	s2,s2,1
    80005806:	0485                	addi	s1,s1,1
    80005808:	fd299de3          	bne	s3,s2,800057e2 <consolewrite+0x20>
    8000580c:	894e                	mv	s2,s3
    8000580e:	74e2                	ld	s1,56(sp)
    80005810:	79a2                	ld	s3,40(sp)
    80005812:	7a02                	ld	s4,32(sp)
    80005814:	6ae2                	ld	s5,24(sp)
    80005816:	a039                	j	80005824 <consolewrite+0x62>
    80005818:	4901                	li	s2,0
    8000581a:	a029                	j	80005824 <consolewrite+0x62>
    8000581c:	74e2                	ld	s1,56(sp)
    8000581e:	79a2                	ld	s3,40(sp)
    80005820:	7a02                	ld	s4,32(sp)
    80005822:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005824:	854a                	mv	a0,s2
    80005826:	60a6                	ld	ra,72(sp)
    80005828:	6406                	ld	s0,64(sp)
    8000582a:	7942                	ld	s2,48(sp)
    8000582c:	6161                	addi	sp,sp,80
    8000582e:	8082                	ret

0000000080005830 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005830:	711d                	addi	sp,sp,-96
    80005832:	ec86                	sd	ra,88(sp)
    80005834:	e8a2                	sd	s0,80(sp)
    80005836:	e4a6                	sd	s1,72(sp)
    80005838:	e0ca                	sd	s2,64(sp)
    8000583a:	fc4e                	sd	s3,56(sp)
    8000583c:	f852                	sd	s4,48(sp)
    8000583e:	f456                	sd	s5,40(sp)
    80005840:	f05a                	sd	s6,32(sp)
    80005842:	1080                	addi	s0,sp,96
    80005844:	8aaa                	mv	s5,a0
    80005846:	8a2e                	mv	s4,a1
    80005848:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000584a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000584e:	00024517          	auipc	a0,0x24
    80005852:	8f250513          	addi	a0,a0,-1806 # 80029140 <cons>
    80005856:	00001097          	auipc	ra,0x1
    8000585a:	940080e7          	jalr	-1728(ra) # 80006196 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000585e:	00024497          	auipc	s1,0x24
    80005862:	8e248493          	addi	s1,s1,-1822 # 80029140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005866:	00024917          	auipc	s2,0x24
    8000586a:	97290913          	addi	s2,s2,-1678 # 800291d8 <cons+0x98>
  while(n > 0){
    8000586e:	0d305463          	blez	s3,80005936 <consoleread+0x106>
    while(cons.r == cons.w){
    80005872:	0984a783          	lw	a5,152(s1)
    80005876:	09c4a703          	lw	a4,156(s1)
    8000587a:	0af71963          	bne	a4,a5,8000592c <consoleread+0xfc>
      if(myproc()->killed){
    8000587e:	ffffb097          	auipc	ra,0xffffb
    80005882:	5fe080e7          	jalr	1534(ra) # 80000e7c <myproc>
    80005886:	551c                	lw	a5,40(a0)
    80005888:	e7ad                	bnez	a5,800058f2 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    8000588a:	85a6                	mv	a1,s1
    8000588c:	854a                	mv	a0,s2
    8000588e:	ffffc097          	auipc	ra,0xffffc
    80005892:	cb4080e7          	jalr	-844(ra) # 80001542 <sleep>
    while(cons.r == cons.w){
    80005896:	0984a783          	lw	a5,152(s1)
    8000589a:	09c4a703          	lw	a4,156(s1)
    8000589e:	fef700e3          	beq	a4,a5,8000587e <consoleread+0x4e>
    800058a2:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    800058a4:	00024717          	auipc	a4,0x24
    800058a8:	89c70713          	addi	a4,a4,-1892 # 80029140 <cons>
    800058ac:	0017869b          	addiw	a3,a5,1
    800058b0:	08d72c23          	sw	a3,152(a4)
    800058b4:	07f7f693          	andi	a3,a5,127
    800058b8:	9736                	add	a4,a4,a3
    800058ba:	01874703          	lbu	a4,24(a4)
    800058be:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800058c2:	4691                	li	a3,4
    800058c4:	04db8a63          	beq	s7,a3,80005918 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800058c8:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058cc:	4685                	li	a3,1
    800058ce:	faf40613          	addi	a2,s0,-81
    800058d2:	85d2                	mv	a1,s4
    800058d4:	8556                	mv	a0,s5
    800058d6:	ffffc097          	auipc	ra,0xffffc
    800058da:	010080e7          	jalr	16(ra) # 800018e6 <either_copyout>
    800058de:	57fd                	li	a5,-1
    800058e0:	04f50a63          	beq	a0,a5,80005934 <consoleread+0x104>
      break;

    dst++;
    800058e4:	0a05                	addi	s4,s4,1
    --n;
    800058e6:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800058e8:	47a9                	li	a5,10
    800058ea:	06fb8163          	beq	s7,a5,8000594c <consoleread+0x11c>
    800058ee:	6be2                	ld	s7,24(sp)
    800058f0:	bfbd                	j	8000586e <consoleread+0x3e>
        release(&cons.lock);
    800058f2:	00024517          	auipc	a0,0x24
    800058f6:	84e50513          	addi	a0,a0,-1970 # 80029140 <cons>
    800058fa:	00001097          	auipc	ra,0x1
    800058fe:	950080e7          	jalr	-1712(ra) # 8000624a <release>
        return -1;
    80005902:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005904:	60e6                	ld	ra,88(sp)
    80005906:	6446                	ld	s0,80(sp)
    80005908:	64a6                	ld	s1,72(sp)
    8000590a:	6906                	ld	s2,64(sp)
    8000590c:	79e2                	ld	s3,56(sp)
    8000590e:	7a42                	ld	s4,48(sp)
    80005910:	7aa2                	ld	s5,40(sp)
    80005912:	7b02                	ld	s6,32(sp)
    80005914:	6125                	addi	sp,sp,96
    80005916:	8082                	ret
      if(n < target){
    80005918:	0009871b          	sext.w	a4,s3
    8000591c:	01677a63          	bgeu	a4,s6,80005930 <consoleread+0x100>
        cons.r--;
    80005920:	00024717          	auipc	a4,0x24
    80005924:	8af72c23          	sw	a5,-1864(a4) # 800291d8 <cons+0x98>
    80005928:	6be2                	ld	s7,24(sp)
    8000592a:	a031                	j	80005936 <consoleread+0x106>
    8000592c:	ec5e                	sd	s7,24(sp)
    8000592e:	bf9d                	j	800058a4 <consoleread+0x74>
    80005930:	6be2                	ld	s7,24(sp)
    80005932:	a011                	j	80005936 <consoleread+0x106>
    80005934:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005936:	00024517          	auipc	a0,0x24
    8000593a:	80a50513          	addi	a0,a0,-2038 # 80029140 <cons>
    8000593e:	00001097          	auipc	ra,0x1
    80005942:	90c080e7          	jalr	-1780(ra) # 8000624a <release>
  return target - n;
    80005946:	413b053b          	subw	a0,s6,s3
    8000594a:	bf6d                	j	80005904 <consoleread+0xd4>
    8000594c:	6be2                	ld	s7,24(sp)
    8000594e:	b7e5                	j	80005936 <consoleread+0x106>

0000000080005950 <consputc>:
{
    80005950:	1141                	addi	sp,sp,-16
    80005952:	e406                	sd	ra,8(sp)
    80005954:	e022                	sd	s0,0(sp)
    80005956:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005958:	10000793          	li	a5,256
    8000595c:	00f50a63          	beq	a0,a5,80005970 <consputc+0x20>
    uartputc_sync(c);
    80005960:	00000097          	auipc	ra,0x0
    80005964:	59c080e7          	jalr	1436(ra) # 80005efc <uartputc_sync>
}
    80005968:	60a2                	ld	ra,8(sp)
    8000596a:	6402                	ld	s0,0(sp)
    8000596c:	0141                	addi	sp,sp,16
    8000596e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005970:	4521                	li	a0,8
    80005972:	00000097          	auipc	ra,0x0
    80005976:	58a080e7          	jalr	1418(ra) # 80005efc <uartputc_sync>
    8000597a:	02000513          	li	a0,32
    8000597e:	00000097          	auipc	ra,0x0
    80005982:	57e080e7          	jalr	1406(ra) # 80005efc <uartputc_sync>
    80005986:	4521                	li	a0,8
    80005988:	00000097          	auipc	ra,0x0
    8000598c:	574080e7          	jalr	1396(ra) # 80005efc <uartputc_sync>
    80005990:	bfe1                	j	80005968 <consputc+0x18>

0000000080005992 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005992:	1101                	addi	sp,sp,-32
    80005994:	ec06                	sd	ra,24(sp)
    80005996:	e822                	sd	s0,16(sp)
    80005998:	e426                	sd	s1,8(sp)
    8000599a:	1000                	addi	s0,sp,32
    8000599c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000599e:	00023517          	auipc	a0,0x23
    800059a2:	7a250513          	addi	a0,a0,1954 # 80029140 <cons>
    800059a6:	00000097          	auipc	ra,0x0
    800059aa:	7f0080e7          	jalr	2032(ra) # 80006196 <acquire>

  switch(c){
    800059ae:	47d5                	li	a5,21
    800059b0:	0af48563          	beq	s1,a5,80005a5a <consoleintr+0xc8>
    800059b4:	0297c963          	blt	a5,s1,800059e6 <consoleintr+0x54>
    800059b8:	47a1                	li	a5,8
    800059ba:	0ef48c63          	beq	s1,a5,80005ab2 <consoleintr+0x120>
    800059be:	47c1                	li	a5,16
    800059c0:	10f49f63          	bne	s1,a5,80005ade <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    800059c4:	ffffc097          	auipc	ra,0xffffc
    800059c8:	fce080e7          	jalr	-50(ra) # 80001992 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800059cc:	00023517          	auipc	a0,0x23
    800059d0:	77450513          	addi	a0,a0,1908 # 80029140 <cons>
    800059d4:	00001097          	auipc	ra,0x1
    800059d8:	876080e7          	jalr	-1930(ra) # 8000624a <release>
}
    800059dc:	60e2                	ld	ra,24(sp)
    800059de:	6442                	ld	s0,16(sp)
    800059e0:	64a2                	ld	s1,8(sp)
    800059e2:	6105                	addi	sp,sp,32
    800059e4:	8082                	ret
  switch(c){
    800059e6:	07f00793          	li	a5,127
    800059ea:	0cf48463          	beq	s1,a5,80005ab2 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800059ee:	00023717          	auipc	a4,0x23
    800059f2:	75270713          	addi	a4,a4,1874 # 80029140 <cons>
    800059f6:	0a072783          	lw	a5,160(a4)
    800059fa:	09872703          	lw	a4,152(a4)
    800059fe:	9f99                	subw	a5,a5,a4
    80005a00:	07f00713          	li	a4,127
    80005a04:	fcf764e3          	bltu	a4,a5,800059cc <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005a08:	47b5                	li	a5,13
    80005a0a:	0cf48d63          	beq	s1,a5,80005ae4 <consoleintr+0x152>
      consputc(c);
    80005a0e:	8526                	mv	a0,s1
    80005a10:	00000097          	auipc	ra,0x0
    80005a14:	f40080e7          	jalr	-192(ra) # 80005950 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a18:	00023797          	auipc	a5,0x23
    80005a1c:	72878793          	addi	a5,a5,1832 # 80029140 <cons>
    80005a20:	0a07a703          	lw	a4,160(a5)
    80005a24:	0017069b          	addiw	a3,a4,1
    80005a28:	0006861b          	sext.w	a2,a3
    80005a2c:	0ad7a023          	sw	a3,160(a5)
    80005a30:	07f77713          	andi	a4,a4,127
    80005a34:	97ba                	add	a5,a5,a4
    80005a36:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a3a:	47a9                	li	a5,10
    80005a3c:	0cf48b63          	beq	s1,a5,80005b12 <consoleintr+0x180>
    80005a40:	4791                	li	a5,4
    80005a42:	0cf48863          	beq	s1,a5,80005b12 <consoleintr+0x180>
    80005a46:	00023797          	auipc	a5,0x23
    80005a4a:	7927a783          	lw	a5,1938(a5) # 800291d8 <cons+0x98>
    80005a4e:	0807879b          	addiw	a5,a5,128
    80005a52:	f6f61de3          	bne	a2,a5,800059cc <consoleintr+0x3a>
    80005a56:	863e                	mv	a2,a5
    80005a58:	a86d                	j	80005b12 <consoleintr+0x180>
    80005a5a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005a5c:	00023717          	auipc	a4,0x23
    80005a60:	6e470713          	addi	a4,a4,1764 # 80029140 <cons>
    80005a64:	0a072783          	lw	a5,160(a4)
    80005a68:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a6c:	00023497          	auipc	s1,0x23
    80005a70:	6d448493          	addi	s1,s1,1748 # 80029140 <cons>
    while(cons.e != cons.w &&
    80005a74:	4929                	li	s2,10
    80005a76:	02f70a63          	beq	a4,a5,80005aaa <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a7a:	37fd                	addiw	a5,a5,-1
    80005a7c:	07f7f713          	andi	a4,a5,127
    80005a80:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005a82:	01874703          	lbu	a4,24(a4)
    80005a86:	03270463          	beq	a4,s2,80005aae <consoleintr+0x11c>
      cons.e--;
    80005a8a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005a8e:	10000513          	li	a0,256
    80005a92:	00000097          	auipc	ra,0x0
    80005a96:	ebe080e7          	jalr	-322(ra) # 80005950 <consputc>
    while(cons.e != cons.w &&
    80005a9a:	0a04a783          	lw	a5,160(s1)
    80005a9e:	09c4a703          	lw	a4,156(s1)
    80005aa2:	fcf71ce3          	bne	a4,a5,80005a7a <consoleintr+0xe8>
    80005aa6:	6902                	ld	s2,0(sp)
    80005aa8:	b715                	j	800059cc <consoleintr+0x3a>
    80005aaa:	6902                	ld	s2,0(sp)
    80005aac:	b705                	j	800059cc <consoleintr+0x3a>
    80005aae:	6902                	ld	s2,0(sp)
    80005ab0:	bf31                	j	800059cc <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005ab2:	00023717          	auipc	a4,0x23
    80005ab6:	68e70713          	addi	a4,a4,1678 # 80029140 <cons>
    80005aba:	0a072783          	lw	a5,160(a4)
    80005abe:	09c72703          	lw	a4,156(a4)
    80005ac2:	f0f705e3          	beq	a4,a5,800059cc <consoleintr+0x3a>
      cons.e--;
    80005ac6:	37fd                	addiw	a5,a5,-1
    80005ac8:	00023717          	auipc	a4,0x23
    80005acc:	70f72c23          	sw	a5,1816(a4) # 800291e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005ad0:	10000513          	li	a0,256
    80005ad4:	00000097          	auipc	ra,0x0
    80005ad8:	e7c080e7          	jalr	-388(ra) # 80005950 <consputc>
    80005adc:	bdc5                	j	800059cc <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005ade:	ee0487e3          	beqz	s1,800059cc <consoleintr+0x3a>
    80005ae2:	b731                	j	800059ee <consoleintr+0x5c>
      consputc(c);
    80005ae4:	4529                	li	a0,10
    80005ae6:	00000097          	auipc	ra,0x0
    80005aea:	e6a080e7          	jalr	-406(ra) # 80005950 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005aee:	00023797          	auipc	a5,0x23
    80005af2:	65278793          	addi	a5,a5,1618 # 80029140 <cons>
    80005af6:	0a07a703          	lw	a4,160(a5)
    80005afa:	0017069b          	addiw	a3,a4,1
    80005afe:	0006861b          	sext.w	a2,a3
    80005b02:	0ad7a023          	sw	a3,160(a5)
    80005b06:	07f77713          	andi	a4,a4,127
    80005b0a:	97ba                	add	a5,a5,a4
    80005b0c:	4729                	li	a4,10
    80005b0e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b12:	00023797          	auipc	a5,0x23
    80005b16:	6cc7a523          	sw	a2,1738(a5) # 800291dc <cons+0x9c>
        wakeup(&cons.r);
    80005b1a:	00023517          	auipc	a0,0x23
    80005b1e:	6be50513          	addi	a0,a0,1726 # 800291d8 <cons+0x98>
    80005b22:	ffffc097          	auipc	ra,0xffffc
    80005b26:	bac080e7          	jalr	-1108(ra) # 800016ce <wakeup>
    80005b2a:	b54d                	j	800059cc <consoleintr+0x3a>

0000000080005b2c <consoleinit>:

void
consoleinit(void)
{
    80005b2c:	1141                	addi	sp,sp,-16
    80005b2e:	e406                	sd	ra,8(sp)
    80005b30:	e022                	sd	s0,0(sp)
    80005b32:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b34:	00003597          	auipc	a1,0x3
    80005b38:	b6458593          	addi	a1,a1,-1180 # 80008698 <etext+0x698>
    80005b3c:	00023517          	auipc	a0,0x23
    80005b40:	60450513          	addi	a0,a0,1540 # 80029140 <cons>
    80005b44:	00000097          	auipc	ra,0x0
    80005b48:	5c2080e7          	jalr	1474(ra) # 80006106 <initlock>

  uartinit();
    80005b4c:	00000097          	auipc	ra,0x0
    80005b50:	354080e7          	jalr	852(ra) # 80005ea0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b54:	00016797          	auipc	a5,0x16
    80005b58:	57478793          	addi	a5,a5,1396 # 8001c0c8 <devsw>
    80005b5c:	00000717          	auipc	a4,0x0
    80005b60:	cd470713          	addi	a4,a4,-812 # 80005830 <consoleread>
    80005b64:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b66:	00000717          	auipc	a4,0x0
    80005b6a:	c5c70713          	addi	a4,a4,-932 # 800057c2 <consolewrite>
    80005b6e:	ef98                	sd	a4,24(a5)
}
    80005b70:	60a2                	ld	ra,8(sp)
    80005b72:	6402                	ld	s0,0(sp)
    80005b74:	0141                	addi	sp,sp,16
    80005b76:	8082                	ret

0000000080005b78 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005b78:	7179                	addi	sp,sp,-48
    80005b7a:	f406                	sd	ra,40(sp)
    80005b7c:	f022                	sd	s0,32(sp)
    80005b7e:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005b80:	c219                	beqz	a2,80005b86 <printint+0xe>
    80005b82:	08054963          	bltz	a0,80005c14 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005b86:	2501                	sext.w	a0,a0
    80005b88:	4881                	li	a7,0
    80005b8a:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005b8e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005b90:	2581                	sext.w	a1,a1
    80005b92:	00003617          	auipc	a2,0x3
    80005b96:	c6660613          	addi	a2,a2,-922 # 800087f8 <digits>
    80005b9a:	883a                	mv	a6,a4
    80005b9c:	2705                	addiw	a4,a4,1
    80005b9e:	02b577bb          	remuw	a5,a0,a1
    80005ba2:	1782                	slli	a5,a5,0x20
    80005ba4:	9381                	srli	a5,a5,0x20
    80005ba6:	97b2                	add	a5,a5,a2
    80005ba8:	0007c783          	lbu	a5,0(a5)
    80005bac:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005bb0:	0005079b          	sext.w	a5,a0
    80005bb4:	02b5553b          	divuw	a0,a0,a1
    80005bb8:	0685                	addi	a3,a3,1
    80005bba:	feb7f0e3          	bgeu	a5,a1,80005b9a <printint+0x22>

  if(sign)
    80005bbe:	00088c63          	beqz	a7,80005bd6 <printint+0x5e>
    buf[i++] = '-';
    80005bc2:	fe070793          	addi	a5,a4,-32
    80005bc6:	00878733          	add	a4,a5,s0
    80005bca:	02d00793          	li	a5,45
    80005bce:	fef70823          	sb	a5,-16(a4)
    80005bd2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005bd6:	02e05b63          	blez	a4,80005c0c <printint+0x94>
    80005bda:	ec26                	sd	s1,24(sp)
    80005bdc:	e84a                	sd	s2,16(sp)
    80005bde:	fd040793          	addi	a5,s0,-48
    80005be2:	00e784b3          	add	s1,a5,a4
    80005be6:	fff78913          	addi	s2,a5,-1
    80005bea:	993a                	add	s2,s2,a4
    80005bec:	377d                	addiw	a4,a4,-1
    80005bee:	1702                	slli	a4,a4,0x20
    80005bf0:	9301                	srli	a4,a4,0x20
    80005bf2:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005bf6:	fff4c503          	lbu	a0,-1(s1)
    80005bfa:	00000097          	auipc	ra,0x0
    80005bfe:	d56080e7          	jalr	-682(ra) # 80005950 <consputc>
  while(--i >= 0)
    80005c02:	14fd                	addi	s1,s1,-1
    80005c04:	ff2499e3          	bne	s1,s2,80005bf6 <printint+0x7e>
    80005c08:	64e2                	ld	s1,24(sp)
    80005c0a:	6942                	ld	s2,16(sp)
}
    80005c0c:	70a2                	ld	ra,40(sp)
    80005c0e:	7402                	ld	s0,32(sp)
    80005c10:	6145                	addi	sp,sp,48
    80005c12:	8082                	ret
    x = -xx;
    80005c14:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c18:	4885                	li	a7,1
    x = -xx;
    80005c1a:	bf85                	j	80005b8a <printint+0x12>

0000000080005c1c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c1c:	1101                	addi	sp,sp,-32
    80005c1e:	ec06                	sd	ra,24(sp)
    80005c20:	e822                	sd	s0,16(sp)
    80005c22:	e426                	sd	s1,8(sp)
    80005c24:	1000                	addi	s0,sp,32
    80005c26:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c28:	00023797          	auipc	a5,0x23
    80005c2c:	5c07ac23          	sw	zero,1496(a5) # 80029200 <pr+0x18>
  printf("panic: ");
    80005c30:	00003517          	auipc	a0,0x3
    80005c34:	a7050513          	addi	a0,a0,-1424 # 800086a0 <etext+0x6a0>
    80005c38:	00000097          	auipc	ra,0x0
    80005c3c:	02e080e7          	jalr	46(ra) # 80005c66 <printf>
  printf(s);
    80005c40:	8526                	mv	a0,s1
    80005c42:	00000097          	auipc	ra,0x0
    80005c46:	024080e7          	jalr	36(ra) # 80005c66 <printf>
  printf("\n");
    80005c4a:	00002517          	auipc	a0,0x2
    80005c4e:	3ce50513          	addi	a0,a0,974 # 80008018 <etext+0x18>
    80005c52:	00000097          	auipc	ra,0x0
    80005c56:	014080e7          	jalr	20(ra) # 80005c66 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c5a:	4785                	li	a5,1
    80005c5c:	00006717          	auipc	a4,0x6
    80005c60:	3cf72023          	sw	a5,960(a4) # 8000c01c <panicked>
  for(;;)
    80005c64:	a001                	j	80005c64 <panic+0x48>

0000000080005c66 <printf>:
{
    80005c66:	7131                	addi	sp,sp,-192
    80005c68:	fc86                	sd	ra,120(sp)
    80005c6a:	f8a2                	sd	s0,112(sp)
    80005c6c:	e8d2                	sd	s4,80(sp)
    80005c6e:	f06a                	sd	s10,32(sp)
    80005c70:	0100                	addi	s0,sp,128
    80005c72:	8a2a                	mv	s4,a0
    80005c74:	e40c                	sd	a1,8(s0)
    80005c76:	e810                	sd	a2,16(s0)
    80005c78:	ec14                	sd	a3,24(s0)
    80005c7a:	f018                	sd	a4,32(s0)
    80005c7c:	f41c                	sd	a5,40(s0)
    80005c7e:	03043823          	sd	a6,48(s0)
    80005c82:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005c86:	00023d17          	auipc	s10,0x23
    80005c8a:	57ad2d03          	lw	s10,1402(s10) # 80029200 <pr+0x18>
  if(locking)
    80005c8e:	040d1463          	bnez	s10,80005cd6 <printf+0x70>
  if (fmt == 0)
    80005c92:	040a0b63          	beqz	s4,80005ce8 <printf+0x82>
  va_start(ap, fmt);
    80005c96:	00840793          	addi	a5,s0,8
    80005c9a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005c9e:	000a4503          	lbu	a0,0(s4)
    80005ca2:	18050b63          	beqz	a0,80005e38 <printf+0x1d2>
    80005ca6:	f4a6                	sd	s1,104(sp)
    80005ca8:	f0ca                	sd	s2,96(sp)
    80005caa:	ecce                	sd	s3,88(sp)
    80005cac:	e4d6                	sd	s5,72(sp)
    80005cae:	e0da                	sd	s6,64(sp)
    80005cb0:	fc5e                	sd	s7,56(sp)
    80005cb2:	f862                	sd	s8,48(sp)
    80005cb4:	f466                	sd	s9,40(sp)
    80005cb6:	ec6e                	sd	s11,24(sp)
    80005cb8:	4981                	li	s3,0
    if(c != '%'){
    80005cba:	02500b13          	li	s6,37
    switch(c){
    80005cbe:	07000b93          	li	s7,112
  consputc('x');
    80005cc2:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005cc4:	00003a97          	auipc	s5,0x3
    80005cc8:	b34a8a93          	addi	s5,s5,-1228 # 800087f8 <digits>
    switch(c){
    80005ccc:	07300c13          	li	s8,115
    80005cd0:	06400d93          	li	s11,100
    80005cd4:	a0b1                	j	80005d20 <printf+0xba>
    acquire(&pr.lock);
    80005cd6:	00023517          	auipc	a0,0x23
    80005cda:	51250513          	addi	a0,a0,1298 # 800291e8 <pr>
    80005cde:	00000097          	auipc	ra,0x0
    80005ce2:	4b8080e7          	jalr	1208(ra) # 80006196 <acquire>
    80005ce6:	b775                	j	80005c92 <printf+0x2c>
    80005ce8:	f4a6                	sd	s1,104(sp)
    80005cea:	f0ca                	sd	s2,96(sp)
    80005cec:	ecce                	sd	s3,88(sp)
    80005cee:	e4d6                	sd	s5,72(sp)
    80005cf0:	e0da                	sd	s6,64(sp)
    80005cf2:	fc5e                	sd	s7,56(sp)
    80005cf4:	f862                	sd	s8,48(sp)
    80005cf6:	f466                	sd	s9,40(sp)
    80005cf8:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005cfa:	00003517          	auipc	a0,0x3
    80005cfe:	9b650513          	addi	a0,a0,-1610 # 800086b0 <etext+0x6b0>
    80005d02:	00000097          	auipc	ra,0x0
    80005d06:	f1a080e7          	jalr	-230(ra) # 80005c1c <panic>
      consputc(c);
    80005d0a:	00000097          	auipc	ra,0x0
    80005d0e:	c46080e7          	jalr	-954(ra) # 80005950 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d12:	2985                	addiw	s3,s3,1
    80005d14:	013a07b3          	add	a5,s4,s3
    80005d18:	0007c503          	lbu	a0,0(a5)
    80005d1c:	10050563          	beqz	a0,80005e26 <printf+0x1c0>
    if(c != '%'){
    80005d20:	ff6515e3          	bne	a0,s6,80005d0a <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005d24:	2985                	addiw	s3,s3,1
    80005d26:	013a07b3          	add	a5,s4,s3
    80005d2a:	0007c783          	lbu	a5,0(a5)
    80005d2e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d32:	10078b63          	beqz	a5,80005e48 <printf+0x1e2>
    switch(c){
    80005d36:	05778a63          	beq	a5,s7,80005d8a <printf+0x124>
    80005d3a:	02fbf663          	bgeu	s7,a5,80005d66 <printf+0x100>
    80005d3e:	09878863          	beq	a5,s8,80005dce <printf+0x168>
    80005d42:	07800713          	li	a4,120
    80005d46:	0ce79563          	bne	a5,a4,80005e10 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80005d4a:	f8843783          	ld	a5,-120(s0)
    80005d4e:	00878713          	addi	a4,a5,8
    80005d52:	f8e43423          	sd	a4,-120(s0)
    80005d56:	4605                	li	a2,1
    80005d58:	85e6                	mv	a1,s9
    80005d5a:	4388                	lw	a0,0(a5)
    80005d5c:	00000097          	auipc	ra,0x0
    80005d60:	e1c080e7          	jalr	-484(ra) # 80005b78 <printint>
      break;
    80005d64:	b77d                	j	80005d12 <printf+0xac>
    switch(c){
    80005d66:	09678f63          	beq	a5,s6,80005e04 <printf+0x19e>
    80005d6a:	0bb79363          	bne	a5,s11,80005e10 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80005d6e:	f8843783          	ld	a5,-120(s0)
    80005d72:	00878713          	addi	a4,a5,8
    80005d76:	f8e43423          	sd	a4,-120(s0)
    80005d7a:	4605                	li	a2,1
    80005d7c:	45a9                	li	a1,10
    80005d7e:	4388                	lw	a0,0(a5)
    80005d80:	00000097          	auipc	ra,0x0
    80005d84:	df8080e7          	jalr	-520(ra) # 80005b78 <printint>
      break;
    80005d88:	b769                	j	80005d12 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005d8a:	f8843783          	ld	a5,-120(s0)
    80005d8e:	00878713          	addi	a4,a5,8
    80005d92:	f8e43423          	sd	a4,-120(s0)
    80005d96:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005d9a:	03000513          	li	a0,48
    80005d9e:	00000097          	auipc	ra,0x0
    80005da2:	bb2080e7          	jalr	-1102(ra) # 80005950 <consputc>
  consputc('x');
    80005da6:	07800513          	li	a0,120
    80005daa:	00000097          	auipc	ra,0x0
    80005dae:	ba6080e7          	jalr	-1114(ra) # 80005950 <consputc>
    80005db2:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005db4:	03c95793          	srli	a5,s2,0x3c
    80005db8:	97d6                	add	a5,a5,s5
    80005dba:	0007c503          	lbu	a0,0(a5)
    80005dbe:	00000097          	auipc	ra,0x0
    80005dc2:	b92080e7          	jalr	-1134(ra) # 80005950 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005dc6:	0912                	slli	s2,s2,0x4
    80005dc8:	34fd                	addiw	s1,s1,-1
    80005dca:	f4ed                	bnez	s1,80005db4 <printf+0x14e>
    80005dcc:	b799                	j	80005d12 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80005dce:	f8843783          	ld	a5,-120(s0)
    80005dd2:	00878713          	addi	a4,a5,8
    80005dd6:	f8e43423          	sd	a4,-120(s0)
    80005dda:	6384                	ld	s1,0(a5)
    80005ddc:	cc89                	beqz	s1,80005df6 <printf+0x190>
      for(; *s; s++)
    80005dde:	0004c503          	lbu	a0,0(s1)
    80005de2:	d905                	beqz	a0,80005d12 <printf+0xac>
        consputc(*s);
    80005de4:	00000097          	auipc	ra,0x0
    80005de8:	b6c080e7          	jalr	-1172(ra) # 80005950 <consputc>
      for(; *s; s++)
    80005dec:	0485                	addi	s1,s1,1
    80005dee:	0004c503          	lbu	a0,0(s1)
    80005df2:	f96d                	bnez	a0,80005de4 <printf+0x17e>
    80005df4:	bf39                	j	80005d12 <printf+0xac>
        s = "(null)";
    80005df6:	00003497          	auipc	s1,0x3
    80005dfa:	8b248493          	addi	s1,s1,-1870 # 800086a8 <etext+0x6a8>
      for(; *s; s++)
    80005dfe:	02800513          	li	a0,40
    80005e02:	b7cd                	j	80005de4 <printf+0x17e>
      consputc('%');
    80005e04:	855a                	mv	a0,s6
    80005e06:	00000097          	auipc	ra,0x0
    80005e0a:	b4a080e7          	jalr	-1206(ra) # 80005950 <consputc>
      break;
    80005e0e:	b711                	j	80005d12 <printf+0xac>
      consputc('%');
    80005e10:	855a                	mv	a0,s6
    80005e12:	00000097          	auipc	ra,0x0
    80005e16:	b3e080e7          	jalr	-1218(ra) # 80005950 <consputc>
      consputc(c);
    80005e1a:	8526                	mv	a0,s1
    80005e1c:	00000097          	auipc	ra,0x0
    80005e20:	b34080e7          	jalr	-1228(ra) # 80005950 <consputc>
      break;
    80005e24:	b5fd                	j	80005d12 <printf+0xac>
    80005e26:	74a6                	ld	s1,104(sp)
    80005e28:	7906                	ld	s2,96(sp)
    80005e2a:	69e6                	ld	s3,88(sp)
    80005e2c:	6aa6                	ld	s5,72(sp)
    80005e2e:	6b06                	ld	s6,64(sp)
    80005e30:	7be2                	ld	s7,56(sp)
    80005e32:	7c42                	ld	s8,48(sp)
    80005e34:	7ca2                	ld	s9,40(sp)
    80005e36:	6de2                	ld	s11,24(sp)
  if(locking)
    80005e38:	020d1263          	bnez	s10,80005e5c <printf+0x1f6>
}
    80005e3c:	70e6                	ld	ra,120(sp)
    80005e3e:	7446                	ld	s0,112(sp)
    80005e40:	6a46                	ld	s4,80(sp)
    80005e42:	7d02                	ld	s10,32(sp)
    80005e44:	6129                	addi	sp,sp,192
    80005e46:	8082                	ret
    80005e48:	74a6                	ld	s1,104(sp)
    80005e4a:	7906                	ld	s2,96(sp)
    80005e4c:	69e6                	ld	s3,88(sp)
    80005e4e:	6aa6                	ld	s5,72(sp)
    80005e50:	6b06                	ld	s6,64(sp)
    80005e52:	7be2                	ld	s7,56(sp)
    80005e54:	7c42                	ld	s8,48(sp)
    80005e56:	7ca2                	ld	s9,40(sp)
    80005e58:	6de2                	ld	s11,24(sp)
    80005e5a:	bff9                	j	80005e38 <printf+0x1d2>
    release(&pr.lock);
    80005e5c:	00023517          	auipc	a0,0x23
    80005e60:	38c50513          	addi	a0,a0,908 # 800291e8 <pr>
    80005e64:	00000097          	auipc	ra,0x0
    80005e68:	3e6080e7          	jalr	998(ra) # 8000624a <release>
}
    80005e6c:	bfc1                	j	80005e3c <printf+0x1d6>

0000000080005e6e <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e6e:	1101                	addi	sp,sp,-32
    80005e70:	ec06                	sd	ra,24(sp)
    80005e72:	e822                	sd	s0,16(sp)
    80005e74:	e426                	sd	s1,8(sp)
    80005e76:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e78:	00023497          	auipc	s1,0x23
    80005e7c:	37048493          	addi	s1,s1,880 # 800291e8 <pr>
    80005e80:	00003597          	auipc	a1,0x3
    80005e84:	84058593          	addi	a1,a1,-1984 # 800086c0 <etext+0x6c0>
    80005e88:	8526                	mv	a0,s1
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	27c080e7          	jalr	636(ra) # 80006106 <initlock>
  pr.locking = 1;
    80005e92:	4785                	li	a5,1
    80005e94:	cc9c                	sw	a5,24(s1)
}
    80005e96:	60e2                	ld	ra,24(sp)
    80005e98:	6442                	ld	s0,16(sp)
    80005e9a:	64a2                	ld	s1,8(sp)
    80005e9c:	6105                	addi	sp,sp,32
    80005e9e:	8082                	ret

0000000080005ea0 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ea0:	1141                	addi	sp,sp,-16
    80005ea2:	e406                	sd	ra,8(sp)
    80005ea4:	e022                	sd	s0,0(sp)
    80005ea6:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ea8:	100007b7          	lui	a5,0x10000
    80005eac:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005eb0:	10000737          	lui	a4,0x10000
    80005eb4:	f8000693          	li	a3,-128
    80005eb8:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005ebc:	468d                	li	a3,3
    80005ebe:	10000637          	lui	a2,0x10000
    80005ec2:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005ec6:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005eca:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005ece:	10000737          	lui	a4,0x10000
    80005ed2:	461d                	li	a2,7
    80005ed4:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ed8:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005edc:	00002597          	auipc	a1,0x2
    80005ee0:	7ec58593          	addi	a1,a1,2028 # 800086c8 <etext+0x6c8>
    80005ee4:	00023517          	auipc	a0,0x23
    80005ee8:	32450513          	addi	a0,a0,804 # 80029208 <uart_tx_lock>
    80005eec:	00000097          	auipc	ra,0x0
    80005ef0:	21a080e7          	jalr	538(ra) # 80006106 <initlock>
}
    80005ef4:	60a2                	ld	ra,8(sp)
    80005ef6:	6402                	ld	s0,0(sp)
    80005ef8:	0141                	addi	sp,sp,16
    80005efa:	8082                	ret

0000000080005efc <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005efc:	1101                	addi	sp,sp,-32
    80005efe:	ec06                	sd	ra,24(sp)
    80005f00:	e822                	sd	s0,16(sp)
    80005f02:	e426                	sd	s1,8(sp)
    80005f04:	1000                	addi	s0,sp,32
    80005f06:	84aa                	mv	s1,a0
  push_off();
    80005f08:	00000097          	auipc	ra,0x0
    80005f0c:	242080e7          	jalr	578(ra) # 8000614a <push_off>

  if(panicked){
    80005f10:	00006797          	auipc	a5,0x6
    80005f14:	10c7a783          	lw	a5,268(a5) # 8000c01c <panicked>
    80005f18:	eb85                	bnez	a5,80005f48 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f1a:	10000737          	lui	a4,0x10000
    80005f1e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005f20:	00074783          	lbu	a5,0(a4)
    80005f24:	0207f793          	andi	a5,a5,32
    80005f28:	dfe5                	beqz	a5,80005f20 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f2a:	0ff4f513          	zext.b	a0,s1
    80005f2e:	100007b7          	lui	a5,0x10000
    80005f32:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f36:	00000097          	auipc	ra,0x0
    80005f3a:	2b4080e7          	jalr	692(ra) # 800061ea <pop_off>
}
    80005f3e:	60e2                	ld	ra,24(sp)
    80005f40:	6442                	ld	s0,16(sp)
    80005f42:	64a2                	ld	s1,8(sp)
    80005f44:	6105                	addi	sp,sp,32
    80005f46:	8082                	ret
    for(;;)
    80005f48:	a001                	j	80005f48 <uartputc_sync+0x4c>

0000000080005f4a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f4a:	00006797          	auipc	a5,0x6
    80005f4e:	0d67b783          	ld	a5,214(a5) # 8000c020 <uart_tx_r>
    80005f52:	00006717          	auipc	a4,0x6
    80005f56:	0d673703          	ld	a4,214(a4) # 8000c028 <uart_tx_w>
    80005f5a:	06f70f63          	beq	a4,a5,80005fd8 <uartstart+0x8e>
{
    80005f5e:	7139                	addi	sp,sp,-64
    80005f60:	fc06                	sd	ra,56(sp)
    80005f62:	f822                	sd	s0,48(sp)
    80005f64:	f426                	sd	s1,40(sp)
    80005f66:	f04a                	sd	s2,32(sp)
    80005f68:	ec4e                	sd	s3,24(sp)
    80005f6a:	e852                	sd	s4,16(sp)
    80005f6c:	e456                	sd	s5,8(sp)
    80005f6e:	e05a                	sd	s6,0(sp)
    80005f70:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f72:	10000937          	lui	s2,0x10000
    80005f76:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f78:	00023a97          	auipc	s5,0x23
    80005f7c:	290a8a93          	addi	s5,s5,656 # 80029208 <uart_tx_lock>
    uart_tx_r += 1;
    80005f80:	00006497          	auipc	s1,0x6
    80005f84:	0a048493          	addi	s1,s1,160 # 8000c020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005f88:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80005f8c:	00006997          	auipc	s3,0x6
    80005f90:	09c98993          	addi	s3,s3,156 # 8000c028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f94:	00094703          	lbu	a4,0(s2)
    80005f98:	02077713          	andi	a4,a4,32
    80005f9c:	c705                	beqz	a4,80005fc4 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f9e:	01f7f713          	andi	a4,a5,31
    80005fa2:	9756                	add	a4,a4,s5
    80005fa4:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005fa8:	0785                	addi	a5,a5,1
    80005faa:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80005fac:	8526                	mv	a0,s1
    80005fae:	ffffb097          	auipc	ra,0xffffb
    80005fb2:	720080e7          	jalr	1824(ra) # 800016ce <wakeup>
    WriteReg(THR, c);
    80005fb6:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005fba:	609c                	ld	a5,0(s1)
    80005fbc:	0009b703          	ld	a4,0(s3)
    80005fc0:	fcf71ae3          	bne	a4,a5,80005f94 <uartstart+0x4a>
  }
}
    80005fc4:	70e2                	ld	ra,56(sp)
    80005fc6:	7442                	ld	s0,48(sp)
    80005fc8:	74a2                	ld	s1,40(sp)
    80005fca:	7902                	ld	s2,32(sp)
    80005fcc:	69e2                	ld	s3,24(sp)
    80005fce:	6a42                	ld	s4,16(sp)
    80005fd0:	6aa2                	ld	s5,8(sp)
    80005fd2:	6b02                	ld	s6,0(sp)
    80005fd4:	6121                	addi	sp,sp,64
    80005fd6:	8082                	ret
    80005fd8:	8082                	ret

0000000080005fda <uartputc>:
{
    80005fda:	7179                	addi	sp,sp,-48
    80005fdc:	f406                	sd	ra,40(sp)
    80005fde:	f022                	sd	s0,32(sp)
    80005fe0:	e052                	sd	s4,0(sp)
    80005fe2:	1800                	addi	s0,sp,48
    80005fe4:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005fe6:	00023517          	auipc	a0,0x23
    80005fea:	22250513          	addi	a0,a0,546 # 80029208 <uart_tx_lock>
    80005fee:	00000097          	auipc	ra,0x0
    80005ff2:	1a8080e7          	jalr	424(ra) # 80006196 <acquire>
  if(panicked){
    80005ff6:	00006797          	auipc	a5,0x6
    80005ffa:	0267a783          	lw	a5,38(a5) # 8000c01c <panicked>
    80005ffe:	c391                	beqz	a5,80006002 <uartputc+0x28>
    for(;;)
    80006000:	a001                	j	80006000 <uartputc+0x26>
    80006002:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006004:	00006717          	auipc	a4,0x6
    80006008:	02473703          	ld	a4,36(a4) # 8000c028 <uart_tx_w>
    8000600c:	00006797          	auipc	a5,0x6
    80006010:	0147b783          	ld	a5,20(a5) # 8000c020 <uart_tx_r>
    80006014:	02078793          	addi	a5,a5,32
    80006018:	02e79f63          	bne	a5,a4,80006056 <uartputc+0x7c>
    8000601c:	e84a                	sd	s2,16(sp)
    8000601e:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    80006020:	00023997          	auipc	s3,0x23
    80006024:	1e898993          	addi	s3,s3,488 # 80029208 <uart_tx_lock>
    80006028:	00006497          	auipc	s1,0x6
    8000602c:	ff848493          	addi	s1,s1,-8 # 8000c020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006030:	00006917          	auipc	s2,0x6
    80006034:	ff890913          	addi	s2,s2,-8 # 8000c028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006038:	85ce                	mv	a1,s3
    8000603a:	8526                	mv	a0,s1
    8000603c:	ffffb097          	auipc	ra,0xffffb
    80006040:	506080e7          	jalr	1286(ra) # 80001542 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006044:	00093703          	ld	a4,0(s2)
    80006048:	609c                	ld	a5,0(s1)
    8000604a:	02078793          	addi	a5,a5,32
    8000604e:	fee785e3          	beq	a5,a4,80006038 <uartputc+0x5e>
    80006052:	6942                	ld	s2,16(sp)
    80006054:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006056:	00023497          	auipc	s1,0x23
    8000605a:	1b248493          	addi	s1,s1,434 # 80029208 <uart_tx_lock>
    8000605e:	01f77793          	andi	a5,a4,31
    80006062:	97a6                	add	a5,a5,s1
    80006064:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006068:	0705                	addi	a4,a4,1
    8000606a:	00006797          	auipc	a5,0x6
    8000606e:	fae7bf23          	sd	a4,-66(a5) # 8000c028 <uart_tx_w>
      uartstart();
    80006072:	00000097          	auipc	ra,0x0
    80006076:	ed8080e7          	jalr	-296(ra) # 80005f4a <uartstart>
      release(&uart_tx_lock);
    8000607a:	8526                	mv	a0,s1
    8000607c:	00000097          	auipc	ra,0x0
    80006080:	1ce080e7          	jalr	462(ra) # 8000624a <release>
    80006084:	64e2                	ld	s1,24(sp)
}
    80006086:	70a2                	ld	ra,40(sp)
    80006088:	7402                	ld	s0,32(sp)
    8000608a:	6a02                	ld	s4,0(sp)
    8000608c:	6145                	addi	sp,sp,48
    8000608e:	8082                	ret

0000000080006090 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006090:	1141                	addi	sp,sp,-16
    80006092:	e422                	sd	s0,8(sp)
    80006094:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006096:	100007b7          	lui	a5,0x10000
    8000609a:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000609c:	0007c783          	lbu	a5,0(a5)
    800060a0:	8b85                	andi	a5,a5,1
    800060a2:	cb81                	beqz	a5,800060b2 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800060a4:	100007b7          	lui	a5,0x10000
    800060a8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800060ac:	6422                	ld	s0,8(sp)
    800060ae:	0141                	addi	sp,sp,16
    800060b0:	8082                	ret
    return -1;
    800060b2:	557d                	li	a0,-1
    800060b4:	bfe5                	j	800060ac <uartgetc+0x1c>

00000000800060b6 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800060b6:	1101                	addi	sp,sp,-32
    800060b8:	ec06                	sd	ra,24(sp)
    800060ba:	e822                	sd	s0,16(sp)
    800060bc:	e426                	sd	s1,8(sp)
    800060be:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060c0:	54fd                	li	s1,-1
    800060c2:	a029                	j	800060cc <uartintr+0x16>
      break;
    consoleintr(c);
    800060c4:	00000097          	auipc	ra,0x0
    800060c8:	8ce080e7          	jalr	-1842(ra) # 80005992 <consoleintr>
    int c = uartgetc();
    800060cc:	00000097          	auipc	ra,0x0
    800060d0:	fc4080e7          	jalr	-60(ra) # 80006090 <uartgetc>
    if(c == -1)
    800060d4:	fe9518e3          	bne	a0,s1,800060c4 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800060d8:	00023497          	auipc	s1,0x23
    800060dc:	13048493          	addi	s1,s1,304 # 80029208 <uart_tx_lock>
    800060e0:	8526                	mv	a0,s1
    800060e2:	00000097          	auipc	ra,0x0
    800060e6:	0b4080e7          	jalr	180(ra) # 80006196 <acquire>
  uartstart();
    800060ea:	00000097          	auipc	ra,0x0
    800060ee:	e60080e7          	jalr	-416(ra) # 80005f4a <uartstart>
  release(&uart_tx_lock);
    800060f2:	8526                	mv	a0,s1
    800060f4:	00000097          	auipc	ra,0x0
    800060f8:	156080e7          	jalr	342(ra) # 8000624a <release>
}
    800060fc:	60e2                	ld	ra,24(sp)
    800060fe:	6442                	ld	s0,16(sp)
    80006100:	64a2                	ld	s1,8(sp)
    80006102:	6105                	addi	sp,sp,32
    80006104:	8082                	ret

0000000080006106 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006106:	1141                	addi	sp,sp,-16
    80006108:	e422                	sd	s0,8(sp)
    8000610a:	0800                	addi	s0,sp,16
  lk->name = name;
    8000610c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000610e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006112:	00053823          	sd	zero,16(a0)
}
    80006116:	6422                	ld	s0,8(sp)
    80006118:	0141                	addi	sp,sp,16
    8000611a:	8082                	ret

000000008000611c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000611c:	411c                	lw	a5,0(a0)
    8000611e:	e399                	bnez	a5,80006124 <holding+0x8>
    80006120:	4501                	li	a0,0
  return r;
}
    80006122:	8082                	ret
{
    80006124:	1101                	addi	sp,sp,-32
    80006126:	ec06                	sd	ra,24(sp)
    80006128:	e822                	sd	s0,16(sp)
    8000612a:	e426                	sd	s1,8(sp)
    8000612c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000612e:	6904                	ld	s1,16(a0)
    80006130:	ffffb097          	auipc	ra,0xffffb
    80006134:	d30080e7          	jalr	-720(ra) # 80000e60 <mycpu>
    80006138:	40a48533          	sub	a0,s1,a0
    8000613c:	00153513          	seqz	a0,a0
}
    80006140:	60e2                	ld	ra,24(sp)
    80006142:	6442                	ld	s0,16(sp)
    80006144:	64a2                	ld	s1,8(sp)
    80006146:	6105                	addi	sp,sp,32
    80006148:	8082                	ret

000000008000614a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000614a:	1101                	addi	sp,sp,-32
    8000614c:	ec06                	sd	ra,24(sp)
    8000614e:	e822                	sd	s0,16(sp)
    80006150:	e426                	sd	s1,8(sp)
    80006152:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006154:	100024f3          	csrr	s1,sstatus
    80006158:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000615c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000615e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006162:	ffffb097          	auipc	ra,0xffffb
    80006166:	cfe080e7          	jalr	-770(ra) # 80000e60 <mycpu>
    8000616a:	5d3c                	lw	a5,120(a0)
    8000616c:	cf89                	beqz	a5,80006186 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000616e:	ffffb097          	auipc	ra,0xffffb
    80006172:	cf2080e7          	jalr	-782(ra) # 80000e60 <mycpu>
    80006176:	5d3c                	lw	a5,120(a0)
    80006178:	2785                	addiw	a5,a5,1
    8000617a:	dd3c                	sw	a5,120(a0)
}
    8000617c:	60e2                	ld	ra,24(sp)
    8000617e:	6442                	ld	s0,16(sp)
    80006180:	64a2                	ld	s1,8(sp)
    80006182:	6105                	addi	sp,sp,32
    80006184:	8082                	ret
    mycpu()->intena = old;
    80006186:	ffffb097          	auipc	ra,0xffffb
    8000618a:	cda080e7          	jalr	-806(ra) # 80000e60 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000618e:	8085                	srli	s1,s1,0x1
    80006190:	8885                	andi	s1,s1,1
    80006192:	dd64                	sw	s1,124(a0)
    80006194:	bfe9                	j	8000616e <push_off+0x24>

0000000080006196 <acquire>:
{
    80006196:	1101                	addi	sp,sp,-32
    80006198:	ec06                	sd	ra,24(sp)
    8000619a:	e822                	sd	s0,16(sp)
    8000619c:	e426                	sd	s1,8(sp)
    8000619e:	1000                	addi	s0,sp,32
    800061a0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061a2:	00000097          	auipc	ra,0x0
    800061a6:	fa8080e7          	jalr	-88(ra) # 8000614a <push_off>
  if(holding(lk))
    800061aa:	8526                	mv	a0,s1
    800061ac:	00000097          	auipc	ra,0x0
    800061b0:	f70080e7          	jalr	-144(ra) # 8000611c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061b4:	4705                	li	a4,1
  if(holding(lk))
    800061b6:	e115                	bnez	a0,800061da <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061b8:	87ba                	mv	a5,a4
    800061ba:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061be:	2781                	sext.w	a5,a5
    800061c0:	ffe5                	bnez	a5,800061b8 <acquire+0x22>
  __sync_synchronize();
    800061c2:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800061c6:	ffffb097          	auipc	ra,0xffffb
    800061ca:	c9a080e7          	jalr	-870(ra) # 80000e60 <mycpu>
    800061ce:	e888                	sd	a0,16(s1)
}
    800061d0:	60e2                	ld	ra,24(sp)
    800061d2:	6442                	ld	s0,16(sp)
    800061d4:	64a2                	ld	s1,8(sp)
    800061d6:	6105                	addi	sp,sp,32
    800061d8:	8082                	ret
    panic("acquire");
    800061da:	00002517          	auipc	a0,0x2
    800061de:	4f650513          	addi	a0,a0,1270 # 800086d0 <etext+0x6d0>
    800061e2:	00000097          	auipc	ra,0x0
    800061e6:	a3a080e7          	jalr	-1478(ra) # 80005c1c <panic>

00000000800061ea <pop_off>:

void
pop_off(void)
{
    800061ea:	1141                	addi	sp,sp,-16
    800061ec:	e406                	sd	ra,8(sp)
    800061ee:	e022                	sd	s0,0(sp)
    800061f0:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800061f2:	ffffb097          	auipc	ra,0xffffb
    800061f6:	c6e080e7          	jalr	-914(ra) # 80000e60 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061fa:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800061fe:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006200:	e78d                	bnez	a5,8000622a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006202:	5d3c                	lw	a5,120(a0)
    80006204:	02f05b63          	blez	a5,8000623a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006208:	37fd                	addiw	a5,a5,-1
    8000620a:	0007871b          	sext.w	a4,a5
    8000620e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006210:	eb09                	bnez	a4,80006222 <pop_off+0x38>
    80006212:	5d7c                	lw	a5,124(a0)
    80006214:	c799                	beqz	a5,80006222 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006216:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000621a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000621e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006222:	60a2                	ld	ra,8(sp)
    80006224:	6402                	ld	s0,0(sp)
    80006226:	0141                	addi	sp,sp,16
    80006228:	8082                	ret
    panic("pop_off - interruptible");
    8000622a:	00002517          	auipc	a0,0x2
    8000622e:	4ae50513          	addi	a0,a0,1198 # 800086d8 <etext+0x6d8>
    80006232:	00000097          	auipc	ra,0x0
    80006236:	9ea080e7          	jalr	-1558(ra) # 80005c1c <panic>
    panic("pop_off");
    8000623a:	00002517          	auipc	a0,0x2
    8000623e:	4b650513          	addi	a0,a0,1206 # 800086f0 <etext+0x6f0>
    80006242:	00000097          	auipc	ra,0x0
    80006246:	9da080e7          	jalr	-1574(ra) # 80005c1c <panic>

000000008000624a <release>:
{
    8000624a:	1101                	addi	sp,sp,-32
    8000624c:	ec06                	sd	ra,24(sp)
    8000624e:	e822                	sd	s0,16(sp)
    80006250:	e426                	sd	s1,8(sp)
    80006252:	1000                	addi	s0,sp,32
    80006254:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006256:	00000097          	auipc	ra,0x0
    8000625a:	ec6080e7          	jalr	-314(ra) # 8000611c <holding>
    8000625e:	c115                	beqz	a0,80006282 <release+0x38>
  lk->cpu = 0;
    80006260:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006264:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80006268:	0310000f          	fence	rw,w
    8000626c:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006270:	00000097          	auipc	ra,0x0
    80006274:	f7a080e7          	jalr	-134(ra) # 800061ea <pop_off>
}
    80006278:	60e2                	ld	ra,24(sp)
    8000627a:	6442                	ld	s0,16(sp)
    8000627c:	64a2                	ld	s1,8(sp)
    8000627e:	6105                	addi	sp,sp,32
    80006280:	8082                	ret
    panic("release");
    80006282:	00002517          	auipc	a0,0x2
    80006286:	47650513          	addi	a0,a0,1142 # 800086f8 <etext+0x6f8>
    8000628a:	00000097          	auipc	ra,0x0
    8000628e:	992080e7          	jalr	-1646(ra) # 80005c1c <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
