
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	16013103          	ld	sp,352(sp) # 8000b160 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	1a9050ef          	jal	800059be <start>

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
    8000005e:	3ac080e7          	jalr	940(ra) # 80006406 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	44c080e7          	jalr	1100(ra) # 800064ba <release>
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
    8000008e:	e02080e7          	jalr	-510(ra) # 80005e8c <panic>

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
    800000fa:	280080e7          	jalr	640(ra) # 80006376 <initlock>
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
    80000132:	2d8080e7          	jalr	728(ra) # 80006406 <acquire>
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
    8000014a:	374080e7          	jalr	884(ra) # 800064ba <release>

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
    80000174:	34a080e7          	jalr	842(ra) # 800064ba <release>
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
    80000324:	c14080e7          	jalr	-1004(ra) # 80000f34 <cpuid>
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
    80000340:	bf8080e7          	jalr	-1032(ra) # 80000f34 <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	addi	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	b88080e7          	jalr	-1144(ra) # 80005ed6 <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00002097          	auipc	ra,0x2
    80000362:	904080e7          	jalr	-1788(ra) # 80001c62 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	00e080e7          	jalr	14(ra) # 80005374 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	1b0080e7          	jalr	432(ra) # 8000151e <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	a26080e7          	jalr	-1498(ra) # 80005d9c <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	d60080e7          	jalr	-672(ra) # 800060de <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	b48080e7          	jalr	-1208(ra) # 80005ed6 <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	b38080e7          	jalr	-1224(ra) # 80005ed6 <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	addi	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	b28080e7          	jalr	-1240(ra) # 80005ed6 <printf>
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
    800003d2:	aaa080e7          	jalr	-1366(ra) # 80000e78 <procinit>
    trapinit();      // trap vectors
    800003d6:	00002097          	auipc	ra,0x2
    800003da:	864080e7          	jalr	-1948(ra) # 80001c3a <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00002097          	auipc	ra,0x2
    800003e2:	884080e7          	jalr	-1916(ra) # 80001c62 <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	f74080e7          	jalr	-140(ra) # 8000535a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	f86080e7          	jalr	-122(ra) # 80005374 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	088080e7          	jalr	136(ra) # 8000247e <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	714080e7          	jalr	1812(ra) # 80002b12 <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	6b8080e7          	jalr	1720(ra) # 80003abe <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	086080e7          	jalr	134(ra) # 80005494 <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	ecc080e7          	jalr	-308(ra) # 800012e2 <userinit>
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
    80000480:	00006097          	auipc	ra,0x6
    80000484:	a0c080e7          	jalr	-1524(ra) # 80005e8c <panic>
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
    800005a6:	00006097          	auipc	ra,0x6
    800005aa:	8e6080e7          	jalr	-1818(ra) # 80005e8c <panic>
      panic("mappages: remap");
    800005ae:	00008517          	auipc	a0,0x8
    800005b2:	aba50513          	addi	a0,a0,-1350 # 80008068 <etext+0x68>
    800005b6:	00006097          	auipc	ra,0x6
    800005ba:	8d6080e7          	jalr	-1834(ra) # 80005e8c <panic>
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
    80000602:	00006097          	auipc	ra,0x6
    80000606:	88a080e7          	jalr	-1910(ra) # 80005e8c <panic>

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
    800006ce:	70c080e7          	jalr	1804(ra) # 80000dd6 <proc_mapstacks>
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
    8000074c:	744080e7          	jalr	1860(ra) # 80005e8c <panic>
      panic("uvmunmap: walk");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	94850513          	addi	a0,a0,-1720 # 80008098 <etext+0x98>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	734080e7          	jalr	1844(ra) # 80005e8c <panic>
      panic("uvmunmap: not mapped");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	94850513          	addi	a0,a0,-1720 # 800080a8 <etext+0xa8>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	724080e7          	jalr	1828(ra) # 80005e8c <panic>
      panic("uvmunmap: not a leaf");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	95050513          	addi	a0,a0,-1712 # 800080c0 <etext+0xc0>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	714080e7          	jalr	1812(ra) # 80005e8c <panic>
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
    80000870:	620080e7          	jalr	1568(ra) # 80005e8c <panic>

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
    800009bc:	4d4080e7          	jalr	1236(ra) # 80005e8c <panic>
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
    80000a9a:	3f6080e7          	jalr	1014(ra) # 80005e8c <panic>
      panic("uvmcopy: page not present");
    80000a9e:	00007517          	auipc	a0,0x7
    80000aa2:	68a50513          	addi	a0,a0,1674 # 80008128 <etext+0x128>
    80000aa6:	00005097          	auipc	ra,0x5
    80000aaa:	3e6080e7          	jalr	998(ra) # 80005e8c <panic>
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
    80000b14:	37c080e7          	jalr	892(ra) # 80005e8c <panic>

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

0000000080000cee <vmprint>:
  [1] = ".. ..",
  [2] = ".. .. .."
};

void vmprint(pagetable_t pagetable, uint64 depth){
  if(depth > 2)
    80000cee:	4789                	li	a5,2
    80000cf0:	0ab7e163          	bltu	a5,a1,80000d92 <vmprint+0xa4>
void vmprint(pagetable_t pagetable, uint64 depth){
    80000cf4:	715d                	addi	sp,sp,-80
    80000cf6:	e486                	sd	ra,72(sp)
    80000cf8:	e0a2                	sd	s0,64(sp)
    80000cfa:	fc26                	sd	s1,56(sp)
    80000cfc:	f84a                	sd	s2,48(sp)
    80000cfe:	f44e                	sd	s3,40(sp)
    80000d00:	f052                	sd	s4,32(sp)
    80000d02:	ec56                	sd	s5,24(sp)
    80000d04:	e85a                	sd	s6,16(sp)
    80000d06:	e45e                	sd	s7,8(sp)
    80000d08:	0880                	addi	s0,sp,80
    80000d0a:	84aa                	mv	s1,a0
    80000d0c:	8a2e                	mv	s4,a1
    return;
  if(depth == 0)
    80000d0e:	c19d                	beqz	a1,80000d34 <vmprint+0x46>
    printf("page table %p\n", pagetable);
  char *buf = prefix[depth];
    80000d10:	003a1713          	slli	a4,s4,0x3
    80000d14:	00008797          	auipc	a5,0x8
    80000d18:	a2c78793          	addi	a5,a5,-1492 # 80008740 <prefix>
    80000d1c:	97ba                	add	a5,a5,a4
    80000d1e:	0007bb03          	ld	s6,0(a5)
  for(int i = 0; i < 512; i++){
    80000d22:	4901                	li	s2,0
    pte_t pte = pagetable[i];
    if(pte & PTE_V){
      printf("%s%d: pte %p pa %p\n",buf,i,pte,PTE2PA(pte));
    80000d24:	00007b97          	auipc	s7,0x7
    80000d28:	444b8b93          	addi	s7,s7,1092 # 80008168 <etext+0x168>
      uint64 child = PTE2PA(pte);
      vmprint((pagetable_t)child, depth+1);
    80000d2c:	0a05                	addi	s4,s4,1
  for(int i = 0; i < 512; i++){
    80000d2e:	20000993          	li	s3,512
    80000d32:	a839                	j	80000d50 <vmprint+0x62>
    printf("page table %p\n", pagetable);
    80000d34:	85aa                	mv	a1,a0
    80000d36:	00007517          	auipc	a0,0x7
    80000d3a:	42250513          	addi	a0,a0,1058 # 80008158 <etext+0x158>
    80000d3e:	00005097          	auipc	ra,0x5
    80000d42:	198080e7          	jalr	408(ra) # 80005ed6 <printf>
    80000d46:	b7e9                	j	80000d10 <vmprint+0x22>
  for(int i = 0; i < 512; i++){
    80000d48:	2905                	addiw	s2,s2,1
    80000d4a:	04a1                	addi	s1,s1,8
    80000d4c:	03390863          	beq	s2,s3,80000d7c <vmprint+0x8e>
    pte_t pte = pagetable[i];
    80000d50:	6094                	ld	a3,0(s1)
    if(pte & PTE_V){
    80000d52:	0016f793          	andi	a5,a3,1
    80000d56:	dbed                	beqz	a5,80000d48 <vmprint+0x5a>
      printf("%s%d: pte %p pa %p\n",buf,i,pte,PTE2PA(pte));
    80000d58:	00a6da93          	srli	s5,a3,0xa
    80000d5c:	0ab2                	slli	s5,s5,0xc
    80000d5e:	8756                	mv	a4,s5
    80000d60:	864a                	mv	a2,s2
    80000d62:	85da                	mv	a1,s6
    80000d64:	855e                	mv	a0,s7
    80000d66:	00005097          	auipc	ra,0x5
    80000d6a:	170080e7          	jalr	368(ra) # 80005ed6 <printf>
      vmprint((pagetable_t)child, depth+1);
    80000d6e:	85d2                	mv	a1,s4
    80000d70:	8556                	mv	a0,s5
    80000d72:	00000097          	auipc	ra,0x0
    80000d76:	f7c080e7          	jalr	-132(ra) # 80000cee <vmprint>
    80000d7a:	b7f9                	j	80000d48 <vmprint+0x5a>
    } 
  }
}
    80000d7c:	60a6                	ld	ra,72(sp)
    80000d7e:	6406                	ld	s0,64(sp)
    80000d80:	74e2                	ld	s1,56(sp)
    80000d82:	7942                	ld	s2,48(sp)
    80000d84:	79a2                	ld	s3,40(sp)
    80000d86:	7a02                	ld	s4,32(sp)
    80000d88:	6ae2                	ld	s5,24(sp)
    80000d8a:	6b42                	ld	s6,16(sp)
    80000d8c:	6ba2                	ld	s7,8(sp)
    80000d8e:	6161                	addi	sp,sp,80
    80000d90:	8082                	ret
    80000d92:	8082                	ret

0000000080000d94 <vm_pgaccess>:

int vm_pgaccess(pagetable_t pagetable, uint64 va){
  pte_t *pte;
  if(va >= MAXVA)
    80000d94:	57fd                	li	a5,-1
    80000d96:	83e9                	srli	a5,a5,0x1a
    80000d98:	00b7f463          	bgeu	a5,a1,80000da0 <vm_pgaccess+0xc>
    return 0;
    80000d9c:	4501                	li	a0,0
  if((*pte & PTE_A) != 0){
    *pte = *pte & (~PTE_A);
    return 1;
  }
  return 0;
    80000d9e:	8082                	ret
int vm_pgaccess(pagetable_t pagetable, uint64 va){
    80000da0:	1141                	addi	sp,sp,-16
    80000da2:	e406                	sd	ra,8(sp)
    80000da4:	e022                	sd	s0,0(sp)
    80000da6:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000da8:	4601                	li	a2,0
    80000daa:	fffff097          	auipc	ra,0xfffff
    80000dae:	6a8080e7          	jalr	1704(ra) # 80000452 <walk>
    80000db2:	87aa                	mv	a5,a0
  if(pte == 0)
    80000db4:	cd19                	beqz	a0,80000dd2 <vm_pgaccess+0x3e>
  if((*pte & PTE_A) != 0){
    80000db6:	6118                	ld	a4,0(a0)
    80000db8:	04077693          	andi	a3,a4,64
  return 0;
    80000dbc:	4501                	li	a0,0
  if((*pte & PTE_A) != 0){
    80000dbe:	e689                	bnez	a3,80000dc8 <vm_pgaccess+0x34>
    80000dc0:	60a2                	ld	ra,8(sp)
    80000dc2:	6402                	ld	s0,0(sp)
    80000dc4:	0141                	addi	sp,sp,16
    80000dc6:	8082                	ret
    *pte = *pte & (~PTE_A);
    80000dc8:	fbf77713          	andi	a4,a4,-65
    80000dcc:	e398                	sd	a4,0(a5)
    return 1;
    80000dce:	4505                	li	a0,1
    80000dd0:	bfc5                	j	80000dc0 <vm_pgaccess+0x2c>
    return 0;
    80000dd2:	4501                	li	a0,0
    80000dd4:	b7f5                	j	80000dc0 <vm_pgaccess+0x2c>

0000000080000dd6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000dd6:	7139                	addi	sp,sp,-64
    80000dd8:	fc06                	sd	ra,56(sp)
    80000dda:	f822                	sd	s0,48(sp)
    80000ddc:	f426                	sd	s1,40(sp)
    80000dde:	f04a                	sd	s2,32(sp)
    80000de0:	ec4e                	sd	s3,24(sp)
    80000de2:	e852                	sd	s4,16(sp)
    80000de4:	e456                	sd	s5,8(sp)
    80000de6:	e05a                	sd	s6,0(sp)
    80000de8:	0080                	addi	s0,sp,64
    80000dea:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dec:	0000b497          	auipc	s1,0xb
    80000df0:	69448493          	addi	s1,s1,1684 # 8000c480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000df4:	8b26                	mv	s6,s1
    80000df6:	ff4df937          	lui	s2,0xff4df
    80000dfa:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b577d>
    80000dfe:	0936                	slli	s2,s2,0xd
    80000e00:	6f590913          	addi	s2,s2,1781
    80000e04:	0936                	slli	s2,s2,0xd
    80000e06:	bd390913          	addi	s2,s2,-1069
    80000e0a:	0932                	slli	s2,s2,0xc
    80000e0c:	7a790913          	addi	s2,s2,1959
    80000e10:	010009b7          	lui	s3,0x1000
    80000e14:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000e16:	09ba                	slli	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e18:	00011a97          	auipc	s5,0x11
    80000e1c:	268a8a93          	addi	s5,s5,616 # 80012080 <tickslock>
    char *pa = kalloc();
    80000e20:	fffff097          	auipc	ra,0xfffff
    80000e24:	2fa080e7          	jalr	762(ra) # 8000011a <kalloc>
    80000e28:	862a                	mv	a2,a0
    if(pa == 0)
    80000e2a:	cd1d                	beqz	a0,80000e68 <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    80000e2c:	416485b3          	sub	a1,s1,s6
    80000e30:	8591                	srai	a1,a1,0x4
    80000e32:	032585b3          	mul	a1,a1,s2
    80000e36:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e3a:	4719                	li	a4,6
    80000e3c:	6685                	lui	a3,0x1
    80000e3e:	40b985b3          	sub	a1,s3,a1
    80000e42:	8552                	mv	a0,s4
    80000e44:	fffff097          	auipc	ra,0xfffff
    80000e48:	796080e7          	jalr	1942(ra) # 800005da <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e4c:	17048493          	addi	s1,s1,368
    80000e50:	fd5498e3          	bne	s1,s5,80000e20 <proc_mapstacks+0x4a>
  }
}
    80000e54:	70e2                	ld	ra,56(sp)
    80000e56:	7442                	ld	s0,48(sp)
    80000e58:	74a2                	ld	s1,40(sp)
    80000e5a:	7902                	ld	s2,32(sp)
    80000e5c:	69e2                	ld	s3,24(sp)
    80000e5e:	6a42                	ld	s4,16(sp)
    80000e60:	6aa2                	ld	s5,8(sp)
    80000e62:	6b02                	ld	s6,0(sp)
    80000e64:	6121                	addi	sp,sp,64
    80000e66:	8082                	ret
      panic("kalloc");
    80000e68:	00007517          	auipc	a0,0x7
    80000e6c:	33850513          	addi	a0,a0,824 # 800081a0 <etext+0x1a0>
    80000e70:	00005097          	auipc	ra,0x5
    80000e74:	01c080e7          	jalr	28(ra) # 80005e8c <panic>

0000000080000e78 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e78:	7139                	addi	sp,sp,-64
    80000e7a:	fc06                	sd	ra,56(sp)
    80000e7c:	f822                	sd	s0,48(sp)
    80000e7e:	f426                	sd	s1,40(sp)
    80000e80:	f04a                	sd	s2,32(sp)
    80000e82:	ec4e                	sd	s3,24(sp)
    80000e84:	e852                	sd	s4,16(sp)
    80000e86:	e456                	sd	s5,8(sp)
    80000e88:	e05a                	sd	s6,0(sp)
    80000e8a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e8c:	00007597          	auipc	a1,0x7
    80000e90:	31c58593          	addi	a1,a1,796 # 800081a8 <etext+0x1a8>
    80000e94:	0000b517          	auipc	a0,0xb
    80000e98:	1bc50513          	addi	a0,a0,444 # 8000c050 <pid_lock>
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	4da080e7          	jalr	1242(ra) # 80006376 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ea4:	00007597          	auipc	a1,0x7
    80000ea8:	30c58593          	addi	a1,a1,780 # 800081b0 <etext+0x1b0>
    80000eac:	0000b517          	auipc	a0,0xb
    80000eb0:	1bc50513          	addi	a0,a0,444 # 8000c068 <wait_lock>
    80000eb4:	00005097          	auipc	ra,0x5
    80000eb8:	4c2080e7          	jalr	1218(ra) # 80006376 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ebc:	0000b497          	auipc	s1,0xb
    80000ec0:	5c448493          	addi	s1,s1,1476 # 8000c480 <proc>
      initlock(&p->lock, "proc");
    80000ec4:	00007b17          	auipc	s6,0x7
    80000ec8:	2fcb0b13          	addi	s6,s6,764 # 800081c0 <etext+0x1c0>
      p->kstack = KSTACK((int) (p - proc));
    80000ecc:	8aa6                	mv	s5,s1
    80000ece:	ff4df937          	lui	s2,0xff4df
    80000ed2:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b577d>
    80000ed6:	0936                	slli	s2,s2,0xd
    80000ed8:	6f590913          	addi	s2,s2,1781
    80000edc:	0936                	slli	s2,s2,0xd
    80000ede:	bd390913          	addi	s2,s2,-1069
    80000ee2:	0932                	slli	s2,s2,0xc
    80000ee4:	7a790913          	addi	s2,s2,1959
    80000ee8:	010009b7          	lui	s3,0x1000
    80000eec:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000eee:	09ba                	slli	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ef0:	00011a17          	auipc	s4,0x11
    80000ef4:	190a0a13          	addi	s4,s4,400 # 80012080 <tickslock>
      initlock(&p->lock, "proc");
    80000ef8:	85da                	mv	a1,s6
    80000efa:	8526                	mv	a0,s1
    80000efc:	00005097          	auipc	ra,0x5
    80000f00:	47a080e7          	jalr	1146(ra) # 80006376 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f04:	415487b3          	sub	a5,s1,s5
    80000f08:	8791                	srai	a5,a5,0x4
    80000f0a:	032787b3          	mul	a5,a5,s2
    80000f0e:	00d7979b          	slliw	a5,a5,0xd
    80000f12:	40f987b3          	sub	a5,s3,a5
    80000f16:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f18:	17048493          	addi	s1,s1,368
    80000f1c:	fd449ee3          	bne	s1,s4,80000ef8 <procinit+0x80>
  }
}
    80000f20:	70e2                	ld	ra,56(sp)
    80000f22:	7442                	ld	s0,48(sp)
    80000f24:	74a2                	ld	s1,40(sp)
    80000f26:	7902                	ld	s2,32(sp)
    80000f28:	69e2                	ld	s3,24(sp)
    80000f2a:	6a42                	ld	s4,16(sp)
    80000f2c:	6aa2                	ld	s5,8(sp)
    80000f2e:	6b02                	ld	s6,0(sp)
    80000f30:	6121                	addi	sp,sp,64
    80000f32:	8082                	ret

0000000080000f34 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f34:	1141                	addi	sp,sp,-16
    80000f36:	e422                	sd	s0,8(sp)
    80000f38:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f3a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f3c:	2501                	sext.w	a0,a0
    80000f3e:	6422                	ld	s0,8(sp)
    80000f40:	0141                	addi	sp,sp,16
    80000f42:	8082                	ret

0000000080000f44 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f44:	1141                	addi	sp,sp,-16
    80000f46:	e422                	sd	s0,8(sp)
    80000f48:	0800                	addi	s0,sp,16
    80000f4a:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f4c:	2781                	sext.w	a5,a5
    80000f4e:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f50:	0000b517          	auipc	a0,0xb
    80000f54:	13050513          	addi	a0,a0,304 # 8000c080 <cpus>
    80000f58:	953e                	add	a0,a0,a5
    80000f5a:	6422                	ld	s0,8(sp)
    80000f5c:	0141                	addi	sp,sp,16
    80000f5e:	8082                	ret

0000000080000f60 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f60:	1101                	addi	sp,sp,-32
    80000f62:	ec06                	sd	ra,24(sp)
    80000f64:	e822                	sd	s0,16(sp)
    80000f66:	e426                	sd	s1,8(sp)
    80000f68:	1000                	addi	s0,sp,32
  push_off();
    80000f6a:	00005097          	auipc	ra,0x5
    80000f6e:	450080e7          	jalr	1104(ra) # 800063ba <push_off>
    80000f72:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f74:	2781                	sext.w	a5,a5
    80000f76:	079e                	slli	a5,a5,0x7
    80000f78:	0000b717          	auipc	a4,0xb
    80000f7c:	0d870713          	addi	a4,a4,216 # 8000c050 <pid_lock>
    80000f80:	97ba                	add	a5,a5,a4
    80000f82:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f84:	00005097          	auipc	ra,0x5
    80000f88:	4d6080e7          	jalr	1238(ra) # 8000645a <pop_off>
  return p;
}
    80000f8c:	8526                	mv	a0,s1
    80000f8e:	60e2                	ld	ra,24(sp)
    80000f90:	6442                	ld	s0,16(sp)
    80000f92:	64a2                	ld	s1,8(sp)
    80000f94:	6105                	addi	sp,sp,32
    80000f96:	8082                	ret

0000000080000f98 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f98:	1141                	addi	sp,sp,-16
    80000f9a:	e406                	sd	ra,8(sp)
    80000f9c:	e022                	sd	s0,0(sp)
    80000f9e:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fa0:	00000097          	auipc	ra,0x0
    80000fa4:	fc0080e7          	jalr	-64(ra) # 80000f60 <myproc>
    80000fa8:	00005097          	auipc	ra,0x5
    80000fac:	512080e7          	jalr	1298(ra) # 800064ba <release>

  if (first) {
    80000fb0:	0000a797          	auipc	a5,0xa
    80000fb4:	1607a783          	lw	a5,352(a5) # 8000b110 <first.1>
    80000fb8:	eb89                	bnez	a5,80000fca <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fba:	00001097          	auipc	ra,0x1
    80000fbe:	cc0080e7          	jalr	-832(ra) # 80001c7a <usertrapret>
}
    80000fc2:	60a2                	ld	ra,8(sp)
    80000fc4:	6402                	ld	s0,0(sp)
    80000fc6:	0141                	addi	sp,sp,16
    80000fc8:	8082                	ret
    first = 0;
    80000fca:	0000a797          	auipc	a5,0xa
    80000fce:	1407a323          	sw	zero,326(a5) # 8000b110 <first.1>
    fsinit(ROOTDEV);
    80000fd2:	4505                	li	a0,1
    80000fd4:	00002097          	auipc	ra,0x2
    80000fd8:	abe080e7          	jalr	-1346(ra) # 80002a92 <fsinit>
    80000fdc:	bff9                	j	80000fba <forkret+0x22>

0000000080000fde <allocpid>:
allocpid() {
    80000fde:	1101                	addi	sp,sp,-32
    80000fe0:	ec06                	sd	ra,24(sp)
    80000fe2:	e822                	sd	s0,16(sp)
    80000fe4:	e426                	sd	s1,8(sp)
    80000fe6:	e04a                	sd	s2,0(sp)
    80000fe8:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fea:	0000b917          	auipc	s2,0xb
    80000fee:	06690913          	addi	s2,s2,102 # 8000c050 <pid_lock>
    80000ff2:	854a                	mv	a0,s2
    80000ff4:	00005097          	auipc	ra,0x5
    80000ff8:	412080e7          	jalr	1042(ra) # 80006406 <acquire>
  pid = nextpid;
    80000ffc:	0000a797          	auipc	a5,0xa
    80001000:	11878793          	addi	a5,a5,280 # 8000b114 <nextpid>
    80001004:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001006:	0014871b          	addiw	a4,s1,1
    8000100a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000100c:	854a                	mv	a0,s2
    8000100e:	00005097          	auipc	ra,0x5
    80001012:	4ac080e7          	jalr	1196(ra) # 800064ba <release>
}
    80001016:	8526                	mv	a0,s1
    80001018:	60e2                	ld	ra,24(sp)
    8000101a:	6442                	ld	s0,16(sp)
    8000101c:	64a2                	ld	s1,8(sp)
    8000101e:	6902                	ld	s2,0(sp)
    80001020:	6105                	addi	sp,sp,32
    80001022:	8082                	ret

0000000080001024 <proc_pagetable>:
{
    80001024:	1101                	addi	sp,sp,-32
    80001026:	ec06                	sd	ra,24(sp)
    80001028:	e822                	sd	s0,16(sp)
    8000102a:	e426                	sd	s1,8(sp)
    8000102c:	e04a                	sd	s2,0(sp)
    8000102e:	1000                	addi	s0,sp,32
    80001030:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001032:	fffff097          	auipc	ra,0xfffff
    80001036:	7a2080e7          	jalr	1954(ra) # 800007d4 <uvmcreate>
    8000103a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000103c:	cd39                	beqz	a0,8000109a <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000103e:	4729                	li	a4,10
    80001040:	00006697          	auipc	a3,0x6
    80001044:	fc068693          	addi	a3,a3,-64 # 80007000 <_trampoline>
    80001048:	6605                	lui	a2,0x1
    8000104a:	040005b7          	lui	a1,0x4000
    8000104e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001050:	05b2                	slli	a1,a1,0xc
    80001052:	fffff097          	auipc	ra,0xfffff
    80001056:	4e8080e7          	jalr	1256(ra) # 8000053a <mappages>
    8000105a:	04054763          	bltz	a0,800010a8 <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000105e:	4719                	li	a4,6
    80001060:	05893683          	ld	a3,88(s2)
    80001064:	6605                	lui	a2,0x1
    80001066:	020005b7          	lui	a1,0x2000
    8000106a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000106c:	05b6                	slli	a1,a1,0xd
    8000106e:	8526                	mv	a0,s1
    80001070:	fffff097          	auipc	ra,0xfffff
    80001074:	4ca080e7          	jalr	1226(ra) # 8000053a <mappages>
    80001078:	04054063          	bltz	a0,800010b8 <proc_pagetable+0x94>
  if(mappages(pagetable, USYSCALL, PGSIZE,
    8000107c:	4749                	li	a4,18
    8000107e:	06093683          	ld	a3,96(s2)
    80001082:	6605                	lui	a2,0x1
    80001084:	040005b7          	lui	a1,0x4000
    80001088:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    8000108a:	05b2                	slli	a1,a1,0xc
    8000108c:	8526                	mv	a0,s1
    8000108e:	fffff097          	auipc	ra,0xfffff
    80001092:	4ac080e7          	jalr	1196(ra) # 8000053a <mappages>
    80001096:	04054463          	bltz	a0,800010de <proc_pagetable+0xba>
}
    8000109a:	8526                	mv	a0,s1
    8000109c:	60e2                	ld	ra,24(sp)
    8000109e:	6442                	ld	s0,16(sp)
    800010a0:	64a2                	ld	s1,8(sp)
    800010a2:	6902                	ld	s2,0(sp)
    800010a4:	6105                	addi	sp,sp,32
    800010a6:	8082                	ret
    uvmfree(pagetable, 0);
    800010a8:	4581                	li	a1,0
    800010aa:	8526                	mv	a0,s1
    800010ac:	00000097          	auipc	ra,0x0
    800010b0:	92e080e7          	jalr	-1746(ra) # 800009da <uvmfree>
    return 0;
    800010b4:	4481                	li	s1,0
    800010b6:	b7d5                	j	8000109a <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010b8:	4681                	li	a3,0
    800010ba:	4605                	li	a2,1
    800010bc:	040005b7          	lui	a1,0x4000
    800010c0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010c2:	05b2                	slli	a1,a1,0xc
    800010c4:	8526                	mv	a0,s1
    800010c6:	fffff097          	auipc	ra,0xfffff
    800010ca:	63a080e7          	jalr	1594(ra) # 80000700 <uvmunmap>
    uvmfree(pagetable, 0);
    800010ce:	4581                	li	a1,0
    800010d0:	8526                	mv	a0,s1
    800010d2:	00000097          	auipc	ra,0x0
    800010d6:	908080e7          	jalr	-1784(ra) # 800009da <uvmfree>
    return 0;
    800010da:	4481                	li	s1,0
    800010dc:	bf7d                	j	8000109a <proc_pagetable+0x76>
    uvmunmap(pagetable, USYSCALL, 1, 0);
    800010de:	4681                	li	a3,0
    800010e0:	4605                	li	a2,1
    800010e2:	040005b7          	lui	a1,0x4000
    800010e6:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    800010e8:	05b2                	slli	a1,a1,0xc
    800010ea:	8526                	mv	a0,s1
    800010ec:	fffff097          	auipc	ra,0xfffff
    800010f0:	614080e7          	jalr	1556(ra) # 80000700 <uvmunmap>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010f4:	4681                	li	a3,0
    800010f6:	4605                	li	a2,1
    800010f8:	040005b7          	lui	a1,0x4000
    800010fc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010fe:	05b2                	slli	a1,a1,0xc
    80001100:	8526                	mv	a0,s1
    80001102:	fffff097          	auipc	ra,0xfffff
    80001106:	5fe080e7          	jalr	1534(ra) # 80000700 <uvmunmap>
    uvmfree(pagetable, 0);
    8000110a:	4581                	li	a1,0
    8000110c:	8526                	mv	a0,s1
    8000110e:	00000097          	auipc	ra,0x0
    80001112:	8cc080e7          	jalr	-1844(ra) # 800009da <uvmfree>
    return 0;
    80001116:	4481                	li	s1,0
    80001118:	b749                	j	8000109a <proc_pagetable+0x76>

000000008000111a <proc_freepagetable>:
{
    8000111a:	1101                	addi	sp,sp,-32
    8000111c:	ec06                	sd	ra,24(sp)
    8000111e:	e822                	sd	s0,16(sp)
    80001120:	e426                	sd	s1,8(sp)
    80001122:	e04a                	sd	s2,0(sp)
    80001124:	1000                	addi	s0,sp,32
    80001126:	84aa                	mv	s1,a0
    80001128:	892e                	mv	s2,a1
  uvmunmap(pagetable, USYSCALL, 1, 0);
    8000112a:	4681                	li	a3,0
    8000112c:	4605                	li	a2,1
    8000112e:	040005b7          	lui	a1,0x4000
    80001132:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80001134:	05b2                	slli	a1,a1,0xc
    80001136:	fffff097          	auipc	ra,0xfffff
    8000113a:	5ca080e7          	jalr	1482(ra) # 80000700 <uvmunmap>
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000113e:	4681                	li	a3,0
    80001140:	4605                	li	a2,1
    80001142:	040005b7          	lui	a1,0x4000
    80001146:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001148:	05b2                	slli	a1,a1,0xc
    8000114a:	8526                	mv	a0,s1
    8000114c:	fffff097          	auipc	ra,0xfffff
    80001150:	5b4080e7          	jalr	1460(ra) # 80000700 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001154:	4681                	li	a3,0
    80001156:	4605                	li	a2,1
    80001158:	020005b7          	lui	a1,0x2000
    8000115c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000115e:	05b6                	slli	a1,a1,0xd
    80001160:	8526                	mv	a0,s1
    80001162:	fffff097          	auipc	ra,0xfffff
    80001166:	59e080e7          	jalr	1438(ra) # 80000700 <uvmunmap>
  uvmfree(pagetable, sz);
    8000116a:	85ca                	mv	a1,s2
    8000116c:	8526                	mv	a0,s1
    8000116e:	00000097          	auipc	ra,0x0
    80001172:	86c080e7          	jalr	-1940(ra) # 800009da <uvmfree>
}
    80001176:	60e2                	ld	ra,24(sp)
    80001178:	6442                	ld	s0,16(sp)
    8000117a:	64a2                	ld	s1,8(sp)
    8000117c:	6902                	ld	s2,0(sp)
    8000117e:	6105                	addi	sp,sp,32
    80001180:	8082                	ret

0000000080001182 <freeproc>:
{
    80001182:	1101                	addi	sp,sp,-32
    80001184:	ec06                	sd	ra,24(sp)
    80001186:	e822                	sd	s0,16(sp)
    80001188:	e426                	sd	s1,8(sp)
    8000118a:	1000                	addi	s0,sp,32
    8000118c:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000118e:	6d28                	ld	a0,88(a0)
    80001190:	c509                	beqz	a0,8000119a <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001192:	fffff097          	auipc	ra,0xfffff
    80001196:	e8a080e7          	jalr	-374(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000119a:	0404bc23          	sd	zero,88(s1)
  if(p->usyscall)
    8000119e:	70a8                	ld	a0,96(s1)
    800011a0:	c509                	beqz	a0,800011aa <freeproc+0x28>
    kfree((void*)p->usyscall);
    800011a2:	fffff097          	auipc	ra,0xfffff
    800011a6:	e7a080e7          	jalr	-390(ra) # 8000001c <kfree>
  p->usyscall = 0;
    800011aa:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    800011ae:	68a8                	ld	a0,80(s1)
    800011b0:	c511                	beqz	a0,800011bc <freeproc+0x3a>
    proc_freepagetable(p->pagetable, p->sz);
    800011b2:	64ac                	ld	a1,72(s1)
    800011b4:	00000097          	auipc	ra,0x0
    800011b8:	f66080e7          	jalr	-154(ra) # 8000111a <proc_freepagetable>
  p->pagetable = 0;
    800011bc:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011c0:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800011c4:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011c8:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011cc:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    800011d0:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011d4:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011d8:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011dc:	0004ac23          	sw	zero,24(s1)
}
    800011e0:	60e2                	ld	ra,24(sp)
    800011e2:	6442                	ld	s0,16(sp)
    800011e4:	64a2                	ld	s1,8(sp)
    800011e6:	6105                	addi	sp,sp,32
    800011e8:	8082                	ret

00000000800011ea <allocproc>:
{
    800011ea:	1101                	addi	sp,sp,-32
    800011ec:	ec06                	sd	ra,24(sp)
    800011ee:	e822                	sd	s0,16(sp)
    800011f0:	e426                	sd	s1,8(sp)
    800011f2:	e04a                	sd	s2,0(sp)
    800011f4:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011f6:	0000b497          	auipc	s1,0xb
    800011fa:	28a48493          	addi	s1,s1,650 # 8000c480 <proc>
    800011fe:	00011917          	auipc	s2,0x11
    80001202:	e8290913          	addi	s2,s2,-382 # 80012080 <tickslock>
    acquire(&p->lock);
    80001206:	8526                	mv	a0,s1
    80001208:	00005097          	auipc	ra,0x5
    8000120c:	1fe080e7          	jalr	510(ra) # 80006406 <acquire>
    if(p->state == UNUSED) {
    80001210:	4c9c                	lw	a5,24(s1)
    80001212:	cf81                	beqz	a5,8000122a <allocproc+0x40>
      release(&p->lock);
    80001214:	8526                	mv	a0,s1
    80001216:	00005097          	auipc	ra,0x5
    8000121a:	2a4080e7          	jalr	676(ra) # 800064ba <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000121e:	17048493          	addi	s1,s1,368
    80001222:	ff2492e3          	bne	s1,s2,80001206 <allocproc+0x1c>
  return 0;
    80001226:	4481                	li	s1,0
    80001228:	a095                	j	8000128c <allocproc+0xa2>
  p->pid = allocpid();
    8000122a:	00000097          	auipc	ra,0x0
    8000122e:	db4080e7          	jalr	-588(ra) # 80000fde <allocpid>
    80001232:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001234:	4785                	li	a5,1
    80001236:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001238:	fffff097          	auipc	ra,0xfffff
    8000123c:	ee2080e7          	jalr	-286(ra) # 8000011a <kalloc>
    80001240:	892a                	mv	s2,a0
    80001242:	eca8                	sd	a0,88(s1)
    80001244:	c939                	beqz	a0,8000129a <allocproc+0xb0>
  if((p->usyscall = (struct usyscall *)kalloc()) == 0){
    80001246:	fffff097          	auipc	ra,0xfffff
    8000124a:	ed4080e7          	jalr	-300(ra) # 8000011a <kalloc>
    8000124e:	892a                	mv	s2,a0
    80001250:	f0a8                	sd	a0,96(s1)
    80001252:	c125                	beqz	a0,800012b2 <allocproc+0xc8>
  p->usyscall->pid = p->pid;
    80001254:	589c                	lw	a5,48(s1)
    80001256:	c11c                	sw	a5,0(a0)
  p->pagetable = proc_pagetable(p);
    80001258:	8526                	mv	a0,s1
    8000125a:	00000097          	auipc	ra,0x0
    8000125e:	dca080e7          	jalr	-566(ra) # 80001024 <proc_pagetable>
    80001262:	892a                	mv	s2,a0
    80001264:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001266:	c135                	beqz	a0,800012ca <allocproc+0xe0>
  memset(&p->context, 0, sizeof(p->context));
    80001268:	07000613          	li	a2,112
    8000126c:	4581                	li	a1,0
    8000126e:	06848513          	addi	a0,s1,104
    80001272:	fffff097          	auipc	ra,0xfffff
    80001276:	f08080e7          	jalr	-248(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    8000127a:	00000797          	auipc	a5,0x0
    8000127e:	d1e78793          	addi	a5,a5,-738 # 80000f98 <forkret>
    80001282:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001284:	60bc                	ld	a5,64(s1)
    80001286:	6705                	lui	a4,0x1
    80001288:	97ba                	add	a5,a5,a4
    8000128a:	f8bc                	sd	a5,112(s1)
}
    8000128c:	8526                	mv	a0,s1
    8000128e:	60e2                	ld	ra,24(sp)
    80001290:	6442                	ld	s0,16(sp)
    80001292:	64a2                	ld	s1,8(sp)
    80001294:	6902                	ld	s2,0(sp)
    80001296:	6105                	addi	sp,sp,32
    80001298:	8082                	ret
    freeproc(p);
    8000129a:	8526                	mv	a0,s1
    8000129c:	00000097          	auipc	ra,0x0
    800012a0:	ee6080e7          	jalr	-282(ra) # 80001182 <freeproc>
    release(&p->lock);
    800012a4:	8526                	mv	a0,s1
    800012a6:	00005097          	auipc	ra,0x5
    800012aa:	214080e7          	jalr	532(ra) # 800064ba <release>
    return 0;
    800012ae:	84ca                	mv	s1,s2
    800012b0:	bff1                	j	8000128c <allocproc+0xa2>
    freeproc(p);
    800012b2:	8526                	mv	a0,s1
    800012b4:	00000097          	auipc	ra,0x0
    800012b8:	ece080e7          	jalr	-306(ra) # 80001182 <freeproc>
    release(&p->lock);
    800012bc:	8526                	mv	a0,s1
    800012be:	00005097          	auipc	ra,0x5
    800012c2:	1fc080e7          	jalr	508(ra) # 800064ba <release>
    return 0;
    800012c6:	84ca                	mv	s1,s2
    800012c8:	b7d1                	j	8000128c <allocproc+0xa2>
    freeproc(p);
    800012ca:	8526                	mv	a0,s1
    800012cc:	00000097          	auipc	ra,0x0
    800012d0:	eb6080e7          	jalr	-330(ra) # 80001182 <freeproc>
    release(&p->lock);
    800012d4:	8526                	mv	a0,s1
    800012d6:	00005097          	auipc	ra,0x5
    800012da:	1e4080e7          	jalr	484(ra) # 800064ba <release>
    return 0;
    800012de:	84ca                	mv	s1,s2
    800012e0:	b775                	j	8000128c <allocproc+0xa2>

00000000800012e2 <userinit>:
{
    800012e2:	1101                	addi	sp,sp,-32
    800012e4:	ec06                	sd	ra,24(sp)
    800012e6:	e822                	sd	s0,16(sp)
    800012e8:	e426                	sd	s1,8(sp)
    800012ea:	1000                	addi	s0,sp,32
  p = allocproc();
    800012ec:	00000097          	auipc	ra,0x0
    800012f0:	efe080e7          	jalr	-258(ra) # 800011ea <allocproc>
    800012f4:	84aa                	mv	s1,a0
  initproc = p;
    800012f6:	0000b797          	auipc	a5,0xb
    800012fa:	d0a7bd23          	sd	a0,-742(a5) # 8000c010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800012fe:	03400613          	li	a2,52
    80001302:	0000a597          	auipc	a1,0xa
    80001306:	e1e58593          	addi	a1,a1,-482 # 8000b120 <initcode>
    8000130a:	6928                	ld	a0,80(a0)
    8000130c:	fffff097          	auipc	ra,0xfffff
    80001310:	4f6080e7          	jalr	1270(ra) # 80000802 <uvminit>
  p->sz = PGSIZE;
    80001314:	6785                	lui	a5,0x1
    80001316:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001318:	6cb8                	ld	a4,88(s1)
    8000131a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000131e:	6cb8                	ld	a4,88(s1)
    80001320:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001322:	4641                	li	a2,16
    80001324:	00007597          	auipc	a1,0x7
    80001328:	ea458593          	addi	a1,a1,-348 # 800081c8 <etext+0x1c8>
    8000132c:	16048513          	addi	a0,s1,352
    80001330:	fffff097          	auipc	ra,0xfffff
    80001334:	f8c080e7          	jalr	-116(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    80001338:	00007517          	auipc	a0,0x7
    8000133c:	ea050513          	addi	a0,a0,-352 # 800081d8 <etext+0x1d8>
    80001340:	00002097          	auipc	ra,0x2
    80001344:	198080e7          	jalr	408(ra) # 800034d8 <namei>
    80001348:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    8000134c:	478d                	li	a5,3
    8000134e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001350:	8526                	mv	a0,s1
    80001352:	00005097          	auipc	ra,0x5
    80001356:	168080e7          	jalr	360(ra) # 800064ba <release>
}
    8000135a:	60e2                	ld	ra,24(sp)
    8000135c:	6442                	ld	s0,16(sp)
    8000135e:	64a2                	ld	s1,8(sp)
    80001360:	6105                	addi	sp,sp,32
    80001362:	8082                	ret

0000000080001364 <growproc>:
{
    80001364:	1101                	addi	sp,sp,-32
    80001366:	ec06                	sd	ra,24(sp)
    80001368:	e822                	sd	s0,16(sp)
    8000136a:	e426                	sd	s1,8(sp)
    8000136c:	e04a                	sd	s2,0(sp)
    8000136e:	1000                	addi	s0,sp,32
    80001370:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001372:	00000097          	auipc	ra,0x0
    80001376:	bee080e7          	jalr	-1042(ra) # 80000f60 <myproc>
    8000137a:	892a                	mv	s2,a0
  sz = p->sz;
    8000137c:	652c                	ld	a1,72(a0)
    8000137e:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001382:	00904f63          	bgtz	s1,800013a0 <growproc+0x3c>
  } else if(n < 0){
    80001386:	0204cd63          	bltz	s1,800013c0 <growproc+0x5c>
  p->sz = sz;
    8000138a:	1782                	slli	a5,a5,0x20
    8000138c:	9381                	srli	a5,a5,0x20
    8000138e:	04f93423          	sd	a5,72(s2)
  return 0;
    80001392:	4501                	li	a0,0
}
    80001394:	60e2                	ld	ra,24(sp)
    80001396:	6442                	ld	s0,16(sp)
    80001398:	64a2                	ld	s1,8(sp)
    8000139a:	6902                	ld	s2,0(sp)
    8000139c:	6105                	addi	sp,sp,32
    8000139e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800013a0:	00f4863b          	addw	a2,s1,a5
    800013a4:	1602                	slli	a2,a2,0x20
    800013a6:	9201                	srli	a2,a2,0x20
    800013a8:	1582                	slli	a1,a1,0x20
    800013aa:	9181                	srli	a1,a1,0x20
    800013ac:	6928                	ld	a0,80(a0)
    800013ae:	fffff097          	auipc	ra,0xfffff
    800013b2:	50e080e7          	jalr	1294(ra) # 800008bc <uvmalloc>
    800013b6:	0005079b          	sext.w	a5,a0
    800013ba:	fbe1                	bnez	a5,8000138a <growproc+0x26>
      return -1;
    800013bc:	557d                	li	a0,-1
    800013be:	bfd9                	j	80001394 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800013c0:	00f4863b          	addw	a2,s1,a5
    800013c4:	1602                	slli	a2,a2,0x20
    800013c6:	9201                	srli	a2,a2,0x20
    800013c8:	1582                	slli	a1,a1,0x20
    800013ca:	9181                	srli	a1,a1,0x20
    800013cc:	6928                	ld	a0,80(a0)
    800013ce:	fffff097          	auipc	ra,0xfffff
    800013d2:	4a6080e7          	jalr	1190(ra) # 80000874 <uvmdealloc>
    800013d6:	0005079b          	sext.w	a5,a0
    800013da:	bf45                	j	8000138a <growproc+0x26>

00000000800013dc <fork>:
{
    800013dc:	7139                	addi	sp,sp,-64
    800013de:	fc06                	sd	ra,56(sp)
    800013e0:	f822                	sd	s0,48(sp)
    800013e2:	f04a                	sd	s2,32(sp)
    800013e4:	e456                	sd	s5,8(sp)
    800013e6:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800013e8:	00000097          	auipc	ra,0x0
    800013ec:	b78080e7          	jalr	-1160(ra) # 80000f60 <myproc>
    800013f0:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800013f2:	00000097          	auipc	ra,0x0
    800013f6:	df8080e7          	jalr	-520(ra) # 800011ea <allocproc>
    800013fa:	12050063          	beqz	a0,8000151a <fork+0x13e>
    800013fe:	e852                	sd	s4,16(sp)
    80001400:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001402:	048ab603          	ld	a2,72(s5)
    80001406:	692c                	ld	a1,80(a0)
    80001408:	050ab503          	ld	a0,80(s5)
    8000140c:	fffff097          	auipc	ra,0xfffff
    80001410:	608080e7          	jalr	1544(ra) # 80000a14 <uvmcopy>
    80001414:	04054a63          	bltz	a0,80001468 <fork+0x8c>
    80001418:	f426                	sd	s1,40(sp)
    8000141a:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000141c:	048ab783          	ld	a5,72(s5)
    80001420:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001424:	058ab683          	ld	a3,88(s5)
    80001428:	87b6                	mv	a5,a3
    8000142a:	058a3703          	ld	a4,88(s4)
    8000142e:	12068693          	addi	a3,a3,288
    80001432:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001436:	6788                	ld	a0,8(a5)
    80001438:	6b8c                	ld	a1,16(a5)
    8000143a:	6f90                	ld	a2,24(a5)
    8000143c:	01073023          	sd	a6,0(a4)
    80001440:	e708                	sd	a0,8(a4)
    80001442:	eb0c                	sd	a1,16(a4)
    80001444:	ef10                	sd	a2,24(a4)
    80001446:	02078793          	addi	a5,a5,32
    8000144a:	02070713          	addi	a4,a4,32
    8000144e:	fed792e3          	bne	a5,a3,80001432 <fork+0x56>
  np->trapframe->a0 = 0;
    80001452:	058a3783          	ld	a5,88(s4)
    80001456:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000145a:	0d8a8493          	addi	s1,s5,216
    8000145e:	0d8a0913          	addi	s2,s4,216
    80001462:	158a8993          	addi	s3,s5,344
    80001466:	a015                	j	8000148a <fork+0xae>
    freeproc(np);
    80001468:	8552                	mv	a0,s4
    8000146a:	00000097          	auipc	ra,0x0
    8000146e:	d18080e7          	jalr	-744(ra) # 80001182 <freeproc>
    release(&np->lock);
    80001472:	8552                	mv	a0,s4
    80001474:	00005097          	auipc	ra,0x5
    80001478:	046080e7          	jalr	70(ra) # 800064ba <release>
    return -1;
    8000147c:	597d                	li	s2,-1
    8000147e:	6a42                	ld	s4,16(sp)
    80001480:	a071                	j	8000150c <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001482:	04a1                	addi	s1,s1,8
    80001484:	0921                	addi	s2,s2,8
    80001486:	01348b63          	beq	s1,s3,8000149c <fork+0xc0>
    if(p->ofile[i])
    8000148a:	6088                	ld	a0,0(s1)
    8000148c:	d97d                	beqz	a0,80001482 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    8000148e:	00002097          	auipc	ra,0x2
    80001492:	6c2080e7          	jalr	1730(ra) # 80003b50 <filedup>
    80001496:	00a93023          	sd	a0,0(s2)
    8000149a:	b7e5                	j	80001482 <fork+0xa6>
  np->cwd = idup(p->cwd);
    8000149c:	158ab503          	ld	a0,344(s5)
    800014a0:	00002097          	auipc	ra,0x2
    800014a4:	828080e7          	jalr	-2008(ra) # 80002cc8 <idup>
    800014a8:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800014ac:	4641                	li	a2,16
    800014ae:	160a8593          	addi	a1,s5,352
    800014b2:	160a0513          	addi	a0,s4,352
    800014b6:	fffff097          	auipc	ra,0xfffff
    800014ba:	e06080e7          	jalr	-506(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    800014be:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800014c2:	8552                	mv	a0,s4
    800014c4:	00005097          	auipc	ra,0x5
    800014c8:	ff6080e7          	jalr	-10(ra) # 800064ba <release>
  acquire(&wait_lock);
    800014cc:	0000b497          	auipc	s1,0xb
    800014d0:	b9c48493          	addi	s1,s1,-1124 # 8000c068 <wait_lock>
    800014d4:	8526                	mv	a0,s1
    800014d6:	00005097          	auipc	ra,0x5
    800014da:	f30080e7          	jalr	-208(ra) # 80006406 <acquire>
  np->parent = p;
    800014de:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800014e2:	8526                	mv	a0,s1
    800014e4:	00005097          	auipc	ra,0x5
    800014e8:	fd6080e7          	jalr	-42(ra) # 800064ba <release>
  acquire(&np->lock);
    800014ec:	8552                	mv	a0,s4
    800014ee:	00005097          	auipc	ra,0x5
    800014f2:	f18080e7          	jalr	-232(ra) # 80006406 <acquire>
  np->state = RUNNABLE;
    800014f6:	478d                	li	a5,3
    800014f8:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800014fc:	8552                	mv	a0,s4
    800014fe:	00005097          	auipc	ra,0x5
    80001502:	fbc080e7          	jalr	-68(ra) # 800064ba <release>
  return pid;
    80001506:	74a2                	ld	s1,40(sp)
    80001508:	69e2                	ld	s3,24(sp)
    8000150a:	6a42                	ld	s4,16(sp)
}
    8000150c:	854a                	mv	a0,s2
    8000150e:	70e2                	ld	ra,56(sp)
    80001510:	7442                	ld	s0,48(sp)
    80001512:	7902                	ld	s2,32(sp)
    80001514:	6aa2                	ld	s5,8(sp)
    80001516:	6121                	addi	sp,sp,64
    80001518:	8082                	ret
    return -1;
    8000151a:	597d                	li	s2,-1
    8000151c:	bfc5                	j	8000150c <fork+0x130>

000000008000151e <scheduler>:
{
    8000151e:	7139                	addi	sp,sp,-64
    80001520:	fc06                	sd	ra,56(sp)
    80001522:	f822                	sd	s0,48(sp)
    80001524:	f426                	sd	s1,40(sp)
    80001526:	f04a                	sd	s2,32(sp)
    80001528:	ec4e                	sd	s3,24(sp)
    8000152a:	e852                	sd	s4,16(sp)
    8000152c:	e456                	sd	s5,8(sp)
    8000152e:	e05a                	sd	s6,0(sp)
    80001530:	0080                	addi	s0,sp,64
    80001532:	8792                	mv	a5,tp
  int id = r_tp();
    80001534:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001536:	00779a93          	slli	s5,a5,0x7
    8000153a:	0000b717          	auipc	a4,0xb
    8000153e:	b1670713          	addi	a4,a4,-1258 # 8000c050 <pid_lock>
    80001542:	9756                	add	a4,a4,s5
    80001544:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001548:	0000b717          	auipc	a4,0xb
    8000154c:	b4070713          	addi	a4,a4,-1216 # 8000c088 <cpus+0x8>
    80001550:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001552:	498d                	li	s3,3
        p->state = RUNNING;
    80001554:	4b11                	li	s6,4
        c->proc = p;
    80001556:	079e                	slli	a5,a5,0x7
    80001558:	0000ba17          	auipc	s4,0xb
    8000155c:	af8a0a13          	addi	s4,s4,-1288 # 8000c050 <pid_lock>
    80001560:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001562:	00011917          	auipc	s2,0x11
    80001566:	b1e90913          	addi	s2,s2,-1250 # 80012080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000156a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000156e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001572:	10079073          	csrw	sstatus,a5
    80001576:	0000b497          	auipc	s1,0xb
    8000157a:	f0a48493          	addi	s1,s1,-246 # 8000c480 <proc>
    8000157e:	a811                	j	80001592 <scheduler+0x74>
      release(&p->lock);
    80001580:	8526                	mv	a0,s1
    80001582:	00005097          	auipc	ra,0x5
    80001586:	f38080e7          	jalr	-200(ra) # 800064ba <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000158a:	17048493          	addi	s1,s1,368
    8000158e:	fd248ee3          	beq	s1,s2,8000156a <scheduler+0x4c>
      acquire(&p->lock);
    80001592:	8526                	mv	a0,s1
    80001594:	00005097          	auipc	ra,0x5
    80001598:	e72080e7          	jalr	-398(ra) # 80006406 <acquire>
      if(p->state == RUNNABLE) {
    8000159c:	4c9c                	lw	a5,24(s1)
    8000159e:	ff3791e3          	bne	a5,s3,80001580 <scheduler+0x62>
        p->state = RUNNING;
    800015a2:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800015a6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800015aa:	06848593          	addi	a1,s1,104
    800015ae:	8556                	mv	a0,s5
    800015b0:	00000097          	auipc	ra,0x0
    800015b4:	620080e7          	jalr	1568(ra) # 80001bd0 <swtch>
        c->proc = 0;
    800015b8:	020a3823          	sd	zero,48(s4)
    800015bc:	b7d1                	j	80001580 <scheduler+0x62>

00000000800015be <sched>:
{
    800015be:	7179                	addi	sp,sp,-48
    800015c0:	f406                	sd	ra,40(sp)
    800015c2:	f022                	sd	s0,32(sp)
    800015c4:	ec26                	sd	s1,24(sp)
    800015c6:	e84a                	sd	s2,16(sp)
    800015c8:	e44e                	sd	s3,8(sp)
    800015ca:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015cc:	00000097          	auipc	ra,0x0
    800015d0:	994080e7          	jalr	-1644(ra) # 80000f60 <myproc>
    800015d4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015d6:	00005097          	auipc	ra,0x5
    800015da:	db6080e7          	jalr	-586(ra) # 8000638c <holding>
    800015de:	c93d                	beqz	a0,80001654 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015e0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015e2:	2781                	sext.w	a5,a5
    800015e4:	079e                	slli	a5,a5,0x7
    800015e6:	0000b717          	auipc	a4,0xb
    800015ea:	a6a70713          	addi	a4,a4,-1430 # 8000c050 <pid_lock>
    800015ee:	97ba                	add	a5,a5,a4
    800015f0:	0a87a703          	lw	a4,168(a5)
    800015f4:	4785                	li	a5,1
    800015f6:	06f71763          	bne	a4,a5,80001664 <sched+0xa6>
  if(p->state == RUNNING)
    800015fa:	4c98                	lw	a4,24(s1)
    800015fc:	4791                	li	a5,4
    800015fe:	06f70b63          	beq	a4,a5,80001674 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001602:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001606:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001608:	efb5                	bnez	a5,80001684 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000160a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000160c:	0000b917          	auipc	s2,0xb
    80001610:	a4490913          	addi	s2,s2,-1468 # 8000c050 <pid_lock>
    80001614:	2781                	sext.w	a5,a5
    80001616:	079e                	slli	a5,a5,0x7
    80001618:	97ca                	add	a5,a5,s2
    8000161a:	0ac7a983          	lw	s3,172(a5)
    8000161e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001620:	2781                	sext.w	a5,a5
    80001622:	079e                	slli	a5,a5,0x7
    80001624:	0000b597          	auipc	a1,0xb
    80001628:	a6458593          	addi	a1,a1,-1436 # 8000c088 <cpus+0x8>
    8000162c:	95be                	add	a1,a1,a5
    8000162e:	06848513          	addi	a0,s1,104
    80001632:	00000097          	auipc	ra,0x0
    80001636:	59e080e7          	jalr	1438(ra) # 80001bd0 <swtch>
    8000163a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000163c:	2781                	sext.w	a5,a5
    8000163e:	079e                	slli	a5,a5,0x7
    80001640:	993e                	add	s2,s2,a5
    80001642:	0b392623          	sw	s3,172(s2)
}
    80001646:	70a2                	ld	ra,40(sp)
    80001648:	7402                	ld	s0,32(sp)
    8000164a:	64e2                	ld	s1,24(sp)
    8000164c:	6942                	ld	s2,16(sp)
    8000164e:	69a2                	ld	s3,8(sp)
    80001650:	6145                	addi	sp,sp,48
    80001652:	8082                	ret
    panic("sched p->lock");
    80001654:	00007517          	auipc	a0,0x7
    80001658:	b8c50513          	addi	a0,a0,-1140 # 800081e0 <etext+0x1e0>
    8000165c:	00005097          	auipc	ra,0x5
    80001660:	830080e7          	jalr	-2000(ra) # 80005e8c <panic>
    panic("sched locks");
    80001664:	00007517          	auipc	a0,0x7
    80001668:	b8c50513          	addi	a0,a0,-1140 # 800081f0 <etext+0x1f0>
    8000166c:	00005097          	auipc	ra,0x5
    80001670:	820080e7          	jalr	-2016(ra) # 80005e8c <panic>
    panic("sched running");
    80001674:	00007517          	auipc	a0,0x7
    80001678:	b8c50513          	addi	a0,a0,-1140 # 80008200 <etext+0x200>
    8000167c:	00005097          	auipc	ra,0x5
    80001680:	810080e7          	jalr	-2032(ra) # 80005e8c <panic>
    panic("sched interruptible");
    80001684:	00007517          	auipc	a0,0x7
    80001688:	b8c50513          	addi	a0,a0,-1140 # 80008210 <etext+0x210>
    8000168c:	00005097          	auipc	ra,0x5
    80001690:	800080e7          	jalr	-2048(ra) # 80005e8c <panic>

0000000080001694 <yield>:
{
    80001694:	1101                	addi	sp,sp,-32
    80001696:	ec06                	sd	ra,24(sp)
    80001698:	e822                	sd	s0,16(sp)
    8000169a:	e426                	sd	s1,8(sp)
    8000169c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000169e:	00000097          	auipc	ra,0x0
    800016a2:	8c2080e7          	jalr	-1854(ra) # 80000f60 <myproc>
    800016a6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800016a8:	00005097          	auipc	ra,0x5
    800016ac:	d5e080e7          	jalr	-674(ra) # 80006406 <acquire>
  p->state = RUNNABLE;
    800016b0:	478d                	li	a5,3
    800016b2:	cc9c                	sw	a5,24(s1)
  sched();
    800016b4:	00000097          	auipc	ra,0x0
    800016b8:	f0a080e7          	jalr	-246(ra) # 800015be <sched>
  release(&p->lock);
    800016bc:	8526                	mv	a0,s1
    800016be:	00005097          	auipc	ra,0x5
    800016c2:	dfc080e7          	jalr	-516(ra) # 800064ba <release>
}
    800016c6:	60e2                	ld	ra,24(sp)
    800016c8:	6442                	ld	s0,16(sp)
    800016ca:	64a2                	ld	s1,8(sp)
    800016cc:	6105                	addi	sp,sp,32
    800016ce:	8082                	ret

00000000800016d0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800016d0:	7179                	addi	sp,sp,-48
    800016d2:	f406                	sd	ra,40(sp)
    800016d4:	f022                	sd	s0,32(sp)
    800016d6:	ec26                	sd	s1,24(sp)
    800016d8:	e84a                	sd	s2,16(sp)
    800016da:	e44e                	sd	s3,8(sp)
    800016dc:	1800                	addi	s0,sp,48
    800016de:	89aa                	mv	s3,a0
    800016e0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016e2:	00000097          	auipc	ra,0x0
    800016e6:	87e080e7          	jalr	-1922(ra) # 80000f60 <myproc>
    800016ea:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016ec:	00005097          	auipc	ra,0x5
    800016f0:	d1a080e7          	jalr	-742(ra) # 80006406 <acquire>
  release(lk);
    800016f4:	854a                	mv	a0,s2
    800016f6:	00005097          	auipc	ra,0x5
    800016fa:	dc4080e7          	jalr	-572(ra) # 800064ba <release>

  // Go to sleep.
  p->chan = chan;
    800016fe:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001702:	4789                	li	a5,2
    80001704:	cc9c                	sw	a5,24(s1)

  sched();
    80001706:	00000097          	auipc	ra,0x0
    8000170a:	eb8080e7          	jalr	-328(ra) # 800015be <sched>

  // Tidy up.
  p->chan = 0;
    8000170e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001712:	8526                	mv	a0,s1
    80001714:	00005097          	auipc	ra,0x5
    80001718:	da6080e7          	jalr	-602(ra) # 800064ba <release>
  acquire(lk);
    8000171c:	854a                	mv	a0,s2
    8000171e:	00005097          	auipc	ra,0x5
    80001722:	ce8080e7          	jalr	-792(ra) # 80006406 <acquire>
}
    80001726:	70a2                	ld	ra,40(sp)
    80001728:	7402                	ld	s0,32(sp)
    8000172a:	64e2                	ld	s1,24(sp)
    8000172c:	6942                	ld	s2,16(sp)
    8000172e:	69a2                	ld	s3,8(sp)
    80001730:	6145                	addi	sp,sp,48
    80001732:	8082                	ret

0000000080001734 <wait>:
{
    80001734:	715d                	addi	sp,sp,-80
    80001736:	e486                	sd	ra,72(sp)
    80001738:	e0a2                	sd	s0,64(sp)
    8000173a:	fc26                	sd	s1,56(sp)
    8000173c:	f84a                	sd	s2,48(sp)
    8000173e:	f44e                	sd	s3,40(sp)
    80001740:	f052                	sd	s4,32(sp)
    80001742:	ec56                	sd	s5,24(sp)
    80001744:	e85a                	sd	s6,16(sp)
    80001746:	e45e                	sd	s7,8(sp)
    80001748:	e062                	sd	s8,0(sp)
    8000174a:	0880                	addi	s0,sp,80
    8000174c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000174e:	00000097          	auipc	ra,0x0
    80001752:	812080e7          	jalr	-2030(ra) # 80000f60 <myproc>
    80001756:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001758:	0000b517          	auipc	a0,0xb
    8000175c:	91050513          	addi	a0,a0,-1776 # 8000c068 <wait_lock>
    80001760:	00005097          	auipc	ra,0x5
    80001764:	ca6080e7          	jalr	-858(ra) # 80006406 <acquire>
    havekids = 0;
    80001768:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000176a:	4a15                	li	s4,5
        havekids = 1;
    8000176c:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000176e:	00011997          	auipc	s3,0x11
    80001772:	91298993          	addi	s3,s3,-1774 # 80012080 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001776:	0000bc17          	auipc	s8,0xb
    8000177a:	8f2c0c13          	addi	s8,s8,-1806 # 8000c068 <wait_lock>
    8000177e:	a87d                	j	8000183c <wait+0x108>
          pid = np->pid;
    80001780:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001784:	000b0e63          	beqz	s6,800017a0 <wait+0x6c>
    80001788:	4691                	li	a3,4
    8000178a:	02c48613          	addi	a2,s1,44
    8000178e:	85da                	mv	a1,s6
    80001790:	05093503          	ld	a0,80(s2)
    80001794:	fffff097          	auipc	ra,0xfffff
    80001798:	384080e7          	jalr	900(ra) # 80000b18 <copyout>
    8000179c:	04054163          	bltz	a0,800017de <wait+0xaa>
          freeproc(np);
    800017a0:	8526                	mv	a0,s1
    800017a2:	00000097          	auipc	ra,0x0
    800017a6:	9e0080e7          	jalr	-1568(ra) # 80001182 <freeproc>
          release(&np->lock);
    800017aa:	8526                	mv	a0,s1
    800017ac:	00005097          	auipc	ra,0x5
    800017b0:	d0e080e7          	jalr	-754(ra) # 800064ba <release>
          release(&wait_lock);
    800017b4:	0000b517          	auipc	a0,0xb
    800017b8:	8b450513          	addi	a0,a0,-1868 # 8000c068 <wait_lock>
    800017bc:	00005097          	auipc	ra,0x5
    800017c0:	cfe080e7          	jalr	-770(ra) # 800064ba <release>
}
    800017c4:	854e                	mv	a0,s3
    800017c6:	60a6                	ld	ra,72(sp)
    800017c8:	6406                	ld	s0,64(sp)
    800017ca:	74e2                	ld	s1,56(sp)
    800017cc:	7942                	ld	s2,48(sp)
    800017ce:	79a2                	ld	s3,40(sp)
    800017d0:	7a02                	ld	s4,32(sp)
    800017d2:	6ae2                	ld	s5,24(sp)
    800017d4:	6b42                	ld	s6,16(sp)
    800017d6:	6ba2                	ld	s7,8(sp)
    800017d8:	6c02                	ld	s8,0(sp)
    800017da:	6161                	addi	sp,sp,80
    800017dc:	8082                	ret
            release(&np->lock);
    800017de:	8526                	mv	a0,s1
    800017e0:	00005097          	auipc	ra,0x5
    800017e4:	cda080e7          	jalr	-806(ra) # 800064ba <release>
            release(&wait_lock);
    800017e8:	0000b517          	auipc	a0,0xb
    800017ec:	88050513          	addi	a0,a0,-1920 # 8000c068 <wait_lock>
    800017f0:	00005097          	auipc	ra,0x5
    800017f4:	cca080e7          	jalr	-822(ra) # 800064ba <release>
            return -1;
    800017f8:	59fd                	li	s3,-1
    800017fa:	b7e9                	j	800017c4 <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    800017fc:	17048493          	addi	s1,s1,368
    80001800:	03348463          	beq	s1,s3,80001828 <wait+0xf4>
      if(np->parent == p){
    80001804:	7c9c                	ld	a5,56(s1)
    80001806:	ff279be3          	bne	a5,s2,800017fc <wait+0xc8>
        acquire(&np->lock);
    8000180a:	8526                	mv	a0,s1
    8000180c:	00005097          	auipc	ra,0x5
    80001810:	bfa080e7          	jalr	-1030(ra) # 80006406 <acquire>
        if(np->state == ZOMBIE){
    80001814:	4c9c                	lw	a5,24(s1)
    80001816:	f74785e3          	beq	a5,s4,80001780 <wait+0x4c>
        release(&np->lock);
    8000181a:	8526                	mv	a0,s1
    8000181c:	00005097          	auipc	ra,0x5
    80001820:	c9e080e7          	jalr	-866(ra) # 800064ba <release>
        havekids = 1;
    80001824:	8756                	mv	a4,s5
    80001826:	bfd9                	j	800017fc <wait+0xc8>
    if(!havekids || p->killed){
    80001828:	c305                	beqz	a4,80001848 <wait+0x114>
    8000182a:	02892783          	lw	a5,40(s2)
    8000182e:	ef89                	bnez	a5,80001848 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001830:	85e2                	mv	a1,s8
    80001832:	854a                	mv	a0,s2
    80001834:	00000097          	auipc	ra,0x0
    80001838:	e9c080e7          	jalr	-356(ra) # 800016d0 <sleep>
    havekids = 0;
    8000183c:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000183e:	0000b497          	auipc	s1,0xb
    80001842:	c4248493          	addi	s1,s1,-958 # 8000c480 <proc>
    80001846:	bf7d                	j	80001804 <wait+0xd0>
      release(&wait_lock);
    80001848:	0000b517          	auipc	a0,0xb
    8000184c:	82050513          	addi	a0,a0,-2016 # 8000c068 <wait_lock>
    80001850:	00005097          	auipc	ra,0x5
    80001854:	c6a080e7          	jalr	-918(ra) # 800064ba <release>
      return -1;
    80001858:	59fd                	li	s3,-1
    8000185a:	b7ad                	j	800017c4 <wait+0x90>

000000008000185c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000185c:	7139                	addi	sp,sp,-64
    8000185e:	fc06                	sd	ra,56(sp)
    80001860:	f822                	sd	s0,48(sp)
    80001862:	f426                	sd	s1,40(sp)
    80001864:	f04a                	sd	s2,32(sp)
    80001866:	ec4e                	sd	s3,24(sp)
    80001868:	e852                	sd	s4,16(sp)
    8000186a:	e456                	sd	s5,8(sp)
    8000186c:	0080                	addi	s0,sp,64
    8000186e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001870:	0000b497          	auipc	s1,0xb
    80001874:	c1048493          	addi	s1,s1,-1008 # 8000c480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001878:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000187a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000187c:	00011917          	auipc	s2,0x11
    80001880:	80490913          	addi	s2,s2,-2044 # 80012080 <tickslock>
    80001884:	a811                	j	80001898 <wakeup+0x3c>
      }
      release(&p->lock);
    80001886:	8526                	mv	a0,s1
    80001888:	00005097          	auipc	ra,0x5
    8000188c:	c32080e7          	jalr	-974(ra) # 800064ba <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001890:	17048493          	addi	s1,s1,368
    80001894:	03248663          	beq	s1,s2,800018c0 <wakeup+0x64>
    if(p != myproc()){
    80001898:	fffff097          	auipc	ra,0xfffff
    8000189c:	6c8080e7          	jalr	1736(ra) # 80000f60 <myproc>
    800018a0:	fea488e3          	beq	s1,a0,80001890 <wakeup+0x34>
      acquire(&p->lock);
    800018a4:	8526                	mv	a0,s1
    800018a6:	00005097          	auipc	ra,0x5
    800018aa:	b60080e7          	jalr	-1184(ra) # 80006406 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800018ae:	4c9c                	lw	a5,24(s1)
    800018b0:	fd379be3          	bne	a5,s3,80001886 <wakeup+0x2a>
    800018b4:	709c                	ld	a5,32(s1)
    800018b6:	fd4798e3          	bne	a5,s4,80001886 <wakeup+0x2a>
        p->state = RUNNABLE;
    800018ba:	0154ac23          	sw	s5,24(s1)
    800018be:	b7e1                	j	80001886 <wakeup+0x2a>
    }
  }
}
    800018c0:	70e2                	ld	ra,56(sp)
    800018c2:	7442                	ld	s0,48(sp)
    800018c4:	74a2                	ld	s1,40(sp)
    800018c6:	7902                	ld	s2,32(sp)
    800018c8:	69e2                	ld	s3,24(sp)
    800018ca:	6a42                	ld	s4,16(sp)
    800018cc:	6aa2                	ld	s5,8(sp)
    800018ce:	6121                	addi	sp,sp,64
    800018d0:	8082                	ret

00000000800018d2 <reparent>:
{
    800018d2:	7179                	addi	sp,sp,-48
    800018d4:	f406                	sd	ra,40(sp)
    800018d6:	f022                	sd	s0,32(sp)
    800018d8:	ec26                	sd	s1,24(sp)
    800018da:	e84a                	sd	s2,16(sp)
    800018dc:	e44e                	sd	s3,8(sp)
    800018de:	e052                	sd	s4,0(sp)
    800018e0:	1800                	addi	s0,sp,48
    800018e2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018e4:	0000b497          	auipc	s1,0xb
    800018e8:	b9c48493          	addi	s1,s1,-1124 # 8000c480 <proc>
      pp->parent = initproc;
    800018ec:	0000aa17          	auipc	s4,0xa
    800018f0:	724a0a13          	addi	s4,s4,1828 # 8000c010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018f4:	00010997          	auipc	s3,0x10
    800018f8:	78c98993          	addi	s3,s3,1932 # 80012080 <tickslock>
    800018fc:	a029                	j	80001906 <reparent+0x34>
    800018fe:	17048493          	addi	s1,s1,368
    80001902:	01348d63          	beq	s1,s3,8000191c <reparent+0x4a>
    if(pp->parent == p){
    80001906:	7c9c                	ld	a5,56(s1)
    80001908:	ff279be3          	bne	a5,s2,800018fe <reparent+0x2c>
      pp->parent = initproc;
    8000190c:	000a3503          	ld	a0,0(s4)
    80001910:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001912:	00000097          	auipc	ra,0x0
    80001916:	f4a080e7          	jalr	-182(ra) # 8000185c <wakeup>
    8000191a:	b7d5                	j	800018fe <reparent+0x2c>
}
    8000191c:	70a2                	ld	ra,40(sp)
    8000191e:	7402                	ld	s0,32(sp)
    80001920:	64e2                	ld	s1,24(sp)
    80001922:	6942                	ld	s2,16(sp)
    80001924:	69a2                	ld	s3,8(sp)
    80001926:	6a02                	ld	s4,0(sp)
    80001928:	6145                	addi	sp,sp,48
    8000192a:	8082                	ret

000000008000192c <exit>:
{
    8000192c:	7179                	addi	sp,sp,-48
    8000192e:	f406                	sd	ra,40(sp)
    80001930:	f022                	sd	s0,32(sp)
    80001932:	ec26                	sd	s1,24(sp)
    80001934:	e84a                	sd	s2,16(sp)
    80001936:	e44e                	sd	s3,8(sp)
    80001938:	e052                	sd	s4,0(sp)
    8000193a:	1800                	addi	s0,sp,48
    8000193c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000193e:	fffff097          	auipc	ra,0xfffff
    80001942:	622080e7          	jalr	1570(ra) # 80000f60 <myproc>
    80001946:	89aa                	mv	s3,a0
  if(p == initproc)
    80001948:	0000a797          	auipc	a5,0xa
    8000194c:	6c87b783          	ld	a5,1736(a5) # 8000c010 <initproc>
    80001950:	0d850493          	addi	s1,a0,216
    80001954:	15850913          	addi	s2,a0,344
    80001958:	02a79363          	bne	a5,a0,8000197e <exit+0x52>
    panic("init exiting");
    8000195c:	00007517          	auipc	a0,0x7
    80001960:	8cc50513          	addi	a0,a0,-1844 # 80008228 <etext+0x228>
    80001964:	00004097          	auipc	ra,0x4
    80001968:	528080e7          	jalr	1320(ra) # 80005e8c <panic>
      fileclose(f);
    8000196c:	00002097          	auipc	ra,0x2
    80001970:	236080e7          	jalr	566(ra) # 80003ba2 <fileclose>
      p->ofile[fd] = 0;
    80001974:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001978:	04a1                	addi	s1,s1,8
    8000197a:	01248563          	beq	s1,s2,80001984 <exit+0x58>
    if(p->ofile[fd]){
    8000197e:	6088                	ld	a0,0(s1)
    80001980:	f575                	bnez	a0,8000196c <exit+0x40>
    80001982:	bfdd                	j	80001978 <exit+0x4c>
  begin_op();
    80001984:	00002097          	auipc	ra,0x2
    80001988:	d54080e7          	jalr	-684(ra) # 800036d8 <begin_op>
  iput(p->cwd);
    8000198c:	1589b503          	ld	a0,344(s3)
    80001990:	00001097          	auipc	ra,0x1
    80001994:	534080e7          	jalr	1332(ra) # 80002ec4 <iput>
  end_op();
    80001998:	00002097          	auipc	ra,0x2
    8000199c:	dba080e7          	jalr	-582(ra) # 80003752 <end_op>
  p->cwd = 0;
    800019a0:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    800019a4:	0000a497          	auipc	s1,0xa
    800019a8:	6c448493          	addi	s1,s1,1732 # 8000c068 <wait_lock>
    800019ac:	8526                	mv	a0,s1
    800019ae:	00005097          	auipc	ra,0x5
    800019b2:	a58080e7          	jalr	-1448(ra) # 80006406 <acquire>
  reparent(p);
    800019b6:	854e                	mv	a0,s3
    800019b8:	00000097          	auipc	ra,0x0
    800019bc:	f1a080e7          	jalr	-230(ra) # 800018d2 <reparent>
  wakeup(p->parent);
    800019c0:	0389b503          	ld	a0,56(s3)
    800019c4:	00000097          	auipc	ra,0x0
    800019c8:	e98080e7          	jalr	-360(ra) # 8000185c <wakeup>
  acquire(&p->lock);
    800019cc:	854e                	mv	a0,s3
    800019ce:	00005097          	auipc	ra,0x5
    800019d2:	a38080e7          	jalr	-1480(ra) # 80006406 <acquire>
  p->xstate = status;
    800019d6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800019da:	4795                	li	a5,5
    800019dc:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800019e0:	8526                	mv	a0,s1
    800019e2:	00005097          	auipc	ra,0x5
    800019e6:	ad8080e7          	jalr	-1320(ra) # 800064ba <release>
  sched();
    800019ea:	00000097          	auipc	ra,0x0
    800019ee:	bd4080e7          	jalr	-1068(ra) # 800015be <sched>
  panic("zombie exit");
    800019f2:	00007517          	auipc	a0,0x7
    800019f6:	84650513          	addi	a0,a0,-1978 # 80008238 <etext+0x238>
    800019fa:	00004097          	auipc	ra,0x4
    800019fe:	492080e7          	jalr	1170(ra) # 80005e8c <panic>

0000000080001a02 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001a02:	7179                	addi	sp,sp,-48
    80001a04:	f406                	sd	ra,40(sp)
    80001a06:	f022                	sd	s0,32(sp)
    80001a08:	ec26                	sd	s1,24(sp)
    80001a0a:	e84a                	sd	s2,16(sp)
    80001a0c:	e44e                	sd	s3,8(sp)
    80001a0e:	1800                	addi	s0,sp,48
    80001a10:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a12:	0000b497          	auipc	s1,0xb
    80001a16:	a6e48493          	addi	s1,s1,-1426 # 8000c480 <proc>
    80001a1a:	00010997          	auipc	s3,0x10
    80001a1e:	66698993          	addi	s3,s3,1638 # 80012080 <tickslock>
    acquire(&p->lock);
    80001a22:	8526                	mv	a0,s1
    80001a24:	00005097          	auipc	ra,0x5
    80001a28:	9e2080e7          	jalr	-1566(ra) # 80006406 <acquire>
    if(p->pid == pid){
    80001a2c:	589c                	lw	a5,48(s1)
    80001a2e:	01278d63          	beq	a5,s2,80001a48 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a32:	8526                	mv	a0,s1
    80001a34:	00005097          	auipc	ra,0x5
    80001a38:	a86080e7          	jalr	-1402(ra) # 800064ba <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a3c:	17048493          	addi	s1,s1,368
    80001a40:	ff3491e3          	bne	s1,s3,80001a22 <kill+0x20>
  }
  return -1;
    80001a44:	557d                	li	a0,-1
    80001a46:	a829                	j	80001a60 <kill+0x5e>
      p->killed = 1;
    80001a48:	4785                	li	a5,1
    80001a4a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001a4c:	4c98                	lw	a4,24(s1)
    80001a4e:	4789                	li	a5,2
    80001a50:	00f70f63          	beq	a4,a5,80001a6e <kill+0x6c>
      release(&p->lock);
    80001a54:	8526                	mv	a0,s1
    80001a56:	00005097          	auipc	ra,0x5
    80001a5a:	a64080e7          	jalr	-1436(ra) # 800064ba <release>
      return 0;
    80001a5e:	4501                	li	a0,0
}
    80001a60:	70a2                	ld	ra,40(sp)
    80001a62:	7402                	ld	s0,32(sp)
    80001a64:	64e2                	ld	s1,24(sp)
    80001a66:	6942                	ld	s2,16(sp)
    80001a68:	69a2                	ld	s3,8(sp)
    80001a6a:	6145                	addi	sp,sp,48
    80001a6c:	8082                	ret
        p->state = RUNNABLE;
    80001a6e:	478d                	li	a5,3
    80001a70:	cc9c                	sw	a5,24(s1)
    80001a72:	b7cd                	j	80001a54 <kill+0x52>

0000000080001a74 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a74:	7179                	addi	sp,sp,-48
    80001a76:	f406                	sd	ra,40(sp)
    80001a78:	f022                	sd	s0,32(sp)
    80001a7a:	ec26                	sd	s1,24(sp)
    80001a7c:	e84a                	sd	s2,16(sp)
    80001a7e:	e44e                	sd	s3,8(sp)
    80001a80:	e052                	sd	s4,0(sp)
    80001a82:	1800                	addi	s0,sp,48
    80001a84:	84aa                	mv	s1,a0
    80001a86:	892e                	mv	s2,a1
    80001a88:	89b2                	mv	s3,a2
    80001a8a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a8c:	fffff097          	auipc	ra,0xfffff
    80001a90:	4d4080e7          	jalr	1236(ra) # 80000f60 <myproc>
  if(user_dst){
    80001a94:	c08d                	beqz	s1,80001ab6 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a96:	86d2                	mv	a3,s4
    80001a98:	864e                	mv	a2,s3
    80001a9a:	85ca                	mv	a1,s2
    80001a9c:	6928                	ld	a0,80(a0)
    80001a9e:	fffff097          	auipc	ra,0xfffff
    80001aa2:	07a080e7          	jalr	122(ra) # 80000b18 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001aa6:	70a2                	ld	ra,40(sp)
    80001aa8:	7402                	ld	s0,32(sp)
    80001aaa:	64e2                	ld	s1,24(sp)
    80001aac:	6942                	ld	s2,16(sp)
    80001aae:	69a2                	ld	s3,8(sp)
    80001ab0:	6a02                	ld	s4,0(sp)
    80001ab2:	6145                	addi	sp,sp,48
    80001ab4:	8082                	ret
    memmove((char *)dst, src, len);
    80001ab6:	000a061b          	sext.w	a2,s4
    80001aba:	85ce                	mv	a1,s3
    80001abc:	854a                	mv	a0,s2
    80001abe:	ffffe097          	auipc	ra,0xffffe
    80001ac2:	718080e7          	jalr	1816(ra) # 800001d6 <memmove>
    return 0;
    80001ac6:	8526                	mv	a0,s1
    80001ac8:	bff9                	j	80001aa6 <either_copyout+0x32>

0000000080001aca <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001aca:	7179                	addi	sp,sp,-48
    80001acc:	f406                	sd	ra,40(sp)
    80001ace:	f022                	sd	s0,32(sp)
    80001ad0:	ec26                	sd	s1,24(sp)
    80001ad2:	e84a                	sd	s2,16(sp)
    80001ad4:	e44e                	sd	s3,8(sp)
    80001ad6:	e052                	sd	s4,0(sp)
    80001ad8:	1800                	addi	s0,sp,48
    80001ada:	892a                	mv	s2,a0
    80001adc:	84ae                	mv	s1,a1
    80001ade:	89b2                	mv	s3,a2
    80001ae0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ae2:	fffff097          	auipc	ra,0xfffff
    80001ae6:	47e080e7          	jalr	1150(ra) # 80000f60 <myproc>
  if(user_src){
    80001aea:	c08d                	beqz	s1,80001b0c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001aec:	86d2                	mv	a3,s4
    80001aee:	864e                	mv	a2,s3
    80001af0:	85ca                	mv	a1,s2
    80001af2:	6928                	ld	a0,80(a0)
    80001af4:	fffff097          	auipc	ra,0xfffff
    80001af8:	0b0080e7          	jalr	176(ra) # 80000ba4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001afc:	70a2                	ld	ra,40(sp)
    80001afe:	7402                	ld	s0,32(sp)
    80001b00:	64e2                	ld	s1,24(sp)
    80001b02:	6942                	ld	s2,16(sp)
    80001b04:	69a2                	ld	s3,8(sp)
    80001b06:	6a02                	ld	s4,0(sp)
    80001b08:	6145                	addi	sp,sp,48
    80001b0a:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b0c:	000a061b          	sext.w	a2,s4
    80001b10:	85ce                	mv	a1,s3
    80001b12:	854a                	mv	a0,s2
    80001b14:	ffffe097          	auipc	ra,0xffffe
    80001b18:	6c2080e7          	jalr	1730(ra) # 800001d6 <memmove>
    return 0;
    80001b1c:	8526                	mv	a0,s1
    80001b1e:	bff9                	j	80001afc <either_copyin+0x32>

0000000080001b20 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b20:	715d                	addi	sp,sp,-80
    80001b22:	e486                	sd	ra,72(sp)
    80001b24:	e0a2                	sd	s0,64(sp)
    80001b26:	fc26                	sd	s1,56(sp)
    80001b28:	f84a                	sd	s2,48(sp)
    80001b2a:	f44e                	sd	s3,40(sp)
    80001b2c:	f052                	sd	s4,32(sp)
    80001b2e:	ec56                	sd	s5,24(sp)
    80001b30:	e85a                	sd	s6,16(sp)
    80001b32:	e45e                	sd	s7,8(sp)
    80001b34:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b36:	00006517          	auipc	a0,0x6
    80001b3a:	4e250513          	addi	a0,a0,1250 # 80008018 <etext+0x18>
    80001b3e:	00004097          	auipc	ra,0x4
    80001b42:	398080e7          	jalr	920(ra) # 80005ed6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b46:	0000b497          	auipc	s1,0xb
    80001b4a:	a9a48493          	addi	s1,s1,-1382 # 8000c5e0 <proc+0x160>
    80001b4e:	00010917          	auipc	s2,0x10
    80001b52:	69290913          	addi	s2,s2,1682 # 800121e0 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b56:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b58:	00006997          	auipc	s3,0x6
    80001b5c:	6f098993          	addi	s3,s3,1776 # 80008248 <etext+0x248>
    printf("%d %s %s", p->pid, state, p->name);
    80001b60:	00006a97          	auipc	s5,0x6
    80001b64:	6f0a8a93          	addi	s5,s5,1776 # 80008250 <etext+0x250>
    printf("\n");
    80001b68:	00006a17          	auipc	s4,0x6
    80001b6c:	4b0a0a13          	addi	s4,s4,1200 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b70:	00007b97          	auipc	s7,0x7
    80001b74:	be8b8b93          	addi	s7,s7,-1048 # 80008758 <states.0>
    80001b78:	a00d                	j	80001b9a <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b7a:	ed06a583          	lw	a1,-304(a3)
    80001b7e:	8556                	mv	a0,s5
    80001b80:	00004097          	auipc	ra,0x4
    80001b84:	356080e7          	jalr	854(ra) # 80005ed6 <printf>
    printf("\n");
    80001b88:	8552                	mv	a0,s4
    80001b8a:	00004097          	auipc	ra,0x4
    80001b8e:	34c080e7          	jalr	844(ra) # 80005ed6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b92:	17048493          	addi	s1,s1,368
    80001b96:	03248263          	beq	s1,s2,80001bba <procdump+0x9a>
    if(p->state == UNUSED)
    80001b9a:	86a6                	mv	a3,s1
    80001b9c:	eb84a783          	lw	a5,-328(s1)
    80001ba0:	dbed                	beqz	a5,80001b92 <procdump+0x72>
      state = "???";
    80001ba2:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ba4:	fcfb6be3          	bltu	s6,a5,80001b7a <procdump+0x5a>
    80001ba8:	02079713          	slli	a4,a5,0x20
    80001bac:	01d75793          	srli	a5,a4,0x1d
    80001bb0:	97de                	add	a5,a5,s7
    80001bb2:	6390                	ld	a2,0(a5)
    80001bb4:	f279                	bnez	a2,80001b7a <procdump+0x5a>
      state = "???";
    80001bb6:	864e                	mv	a2,s3
    80001bb8:	b7c9                	j	80001b7a <procdump+0x5a>
  }
}
    80001bba:	60a6                	ld	ra,72(sp)
    80001bbc:	6406                	ld	s0,64(sp)
    80001bbe:	74e2                	ld	s1,56(sp)
    80001bc0:	7942                	ld	s2,48(sp)
    80001bc2:	79a2                	ld	s3,40(sp)
    80001bc4:	7a02                	ld	s4,32(sp)
    80001bc6:	6ae2                	ld	s5,24(sp)
    80001bc8:	6b42                	ld	s6,16(sp)
    80001bca:	6ba2                	ld	s7,8(sp)
    80001bcc:	6161                	addi	sp,sp,80
    80001bce:	8082                	ret

0000000080001bd0 <swtch>:
    80001bd0:	00153023          	sd	ra,0(a0)
    80001bd4:	00253423          	sd	sp,8(a0)
    80001bd8:	e900                	sd	s0,16(a0)
    80001bda:	ed04                	sd	s1,24(a0)
    80001bdc:	03253023          	sd	s2,32(a0)
    80001be0:	03353423          	sd	s3,40(a0)
    80001be4:	03453823          	sd	s4,48(a0)
    80001be8:	03553c23          	sd	s5,56(a0)
    80001bec:	05653023          	sd	s6,64(a0)
    80001bf0:	05753423          	sd	s7,72(a0)
    80001bf4:	05853823          	sd	s8,80(a0)
    80001bf8:	05953c23          	sd	s9,88(a0)
    80001bfc:	07a53023          	sd	s10,96(a0)
    80001c00:	07b53423          	sd	s11,104(a0)
    80001c04:	0005b083          	ld	ra,0(a1)
    80001c08:	0085b103          	ld	sp,8(a1)
    80001c0c:	6980                	ld	s0,16(a1)
    80001c0e:	6d84                	ld	s1,24(a1)
    80001c10:	0205b903          	ld	s2,32(a1)
    80001c14:	0285b983          	ld	s3,40(a1)
    80001c18:	0305ba03          	ld	s4,48(a1)
    80001c1c:	0385ba83          	ld	s5,56(a1)
    80001c20:	0405bb03          	ld	s6,64(a1)
    80001c24:	0485bb83          	ld	s7,72(a1)
    80001c28:	0505bc03          	ld	s8,80(a1)
    80001c2c:	0585bc83          	ld	s9,88(a1)
    80001c30:	0605bd03          	ld	s10,96(a1)
    80001c34:	0685bd83          	ld	s11,104(a1)
    80001c38:	8082                	ret

0000000080001c3a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c3a:	1141                	addi	sp,sp,-16
    80001c3c:	e406                	sd	ra,8(sp)
    80001c3e:	e022                	sd	s0,0(sp)
    80001c40:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c42:	00006597          	auipc	a1,0x6
    80001c46:	64658593          	addi	a1,a1,1606 # 80008288 <etext+0x288>
    80001c4a:	00010517          	auipc	a0,0x10
    80001c4e:	43650513          	addi	a0,a0,1078 # 80012080 <tickslock>
    80001c52:	00004097          	auipc	ra,0x4
    80001c56:	724080e7          	jalr	1828(ra) # 80006376 <initlock>
}
    80001c5a:	60a2                	ld	ra,8(sp)
    80001c5c:	6402                	ld	s0,0(sp)
    80001c5e:	0141                	addi	sp,sp,16
    80001c60:	8082                	ret

0000000080001c62 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c62:	1141                	addi	sp,sp,-16
    80001c64:	e422                	sd	s0,8(sp)
    80001c66:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c68:	00003797          	auipc	a5,0x3
    80001c6c:	63878793          	addi	a5,a5,1592 # 800052a0 <kernelvec>
    80001c70:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c74:	6422                	ld	s0,8(sp)
    80001c76:	0141                	addi	sp,sp,16
    80001c78:	8082                	ret

0000000080001c7a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c7a:	1141                	addi	sp,sp,-16
    80001c7c:	e406                	sd	ra,8(sp)
    80001c7e:	e022                	sd	s0,0(sp)
    80001c80:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c82:	fffff097          	auipc	ra,0xfffff
    80001c86:	2de080e7          	jalr	734(ra) # 80000f60 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c8a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c8e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c90:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c94:	00005697          	auipc	a3,0x5
    80001c98:	36c68693          	addi	a3,a3,876 # 80007000 <_trampoline>
    80001c9c:	00005717          	auipc	a4,0x5
    80001ca0:	36470713          	addi	a4,a4,868 # 80007000 <_trampoline>
    80001ca4:	8f15                	sub	a4,a4,a3
    80001ca6:	040007b7          	lui	a5,0x4000
    80001caa:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001cac:	07b2                	slli	a5,a5,0xc
    80001cae:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cb0:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cb4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cb6:	18002673          	csrr	a2,satp
    80001cba:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cbc:	6d30                	ld	a2,88(a0)
    80001cbe:	6138                	ld	a4,64(a0)
    80001cc0:	6585                	lui	a1,0x1
    80001cc2:	972e                	add	a4,a4,a1
    80001cc4:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cc6:	6d38                	ld	a4,88(a0)
    80001cc8:	00000617          	auipc	a2,0x0
    80001ccc:	14060613          	addi	a2,a2,320 # 80001e08 <usertrap>
    80001cd0:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001cd2:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cd4:	8612                	mv	a2,tp
    80001cd6:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cd8:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001cdc:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001ce0:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ce4:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001ce8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001cea:	6f18                	ld	a4,24(a4)
    80001cec:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001cf0:	692c                	ld	a1,80(a0)
    80001cf2:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001cf4:	00005717          	auipc	a4,0x5
    80001cf8:	39c70713          	addi	a4,a4,924 # 80007090 <userret>
    80001cfc:	8f15                	sub	a4,a4,a3
    80001cfe:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001d00:	577d                	li	a4,-1
    80001d02:	177e                	slli	a4,a4,0x3f
    80001d04:	8dd9                	or	a1,a1,a4
    80001d06:	02000537          	lui	a0,0x2000
    80001d0a:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001d0c:	0536                	slli	a0,a0,0xd
    80001d0e:	9782                	jalr	a5
}
    80001d10:	60a2                	ld	ra,8(sp)
    80001d12:	6402                	ld	s0,0(sp)
    80001d14:	0141                	addi	sp,sp,16
    80001d16:	8082                	ret

0000000080001d18 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d18:	1101                	addi	sp,sp,-32
    80001d1a:	ec06                	sd	ra,24(sp)
    80001d1c:	e822                	sd	s0,16(sp)
    80001d1e:	e426                	sd	s1,8(sp)
    80001d20:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d22:	00010497          	auipc	s1,0x10
    80001d26:	35e48493          	addi	s1,s1,862 # 80012080 <tickslock>
    80001d2a:	8526                	mv	a0,s1
    80001d2c:	00004097          	auipc	ra,0x4
    80001d30:	6da080e7          	jalr	1754(ra) # 80006406 <acquire>
  ticks++;
    80001d34:	0000a517          	auipc	a0,0xa
    80001d38:	2e450513          	addi	a0,a0,740 # 8000c018 <ticks>
    80001d3c:	411c                	lw	a5,0(a0)
    80001d3e:	2785                	addiw	a5,a5,1
    80001d40:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d42:	00000097          	auipc	ra,0x0
    80001d46:	b1a080e7          	jalr	-1254(ra) # 8000185c <wakeup>
  release(&tickslock);
    80001d4a:	8526                	mv	a0,s1
    80001d4c:	00004097          	auipc	ra,0x4
    80001d50:	76e080e7          	jalr	1902(ra) # 800064ba <release>
}
    80001d54:	60e2                	ld	ra,24(sp)
    80001d56:	6442                	ld	s0,16(sp)
    80001d58:	64a2                	ld	s1,8(sp)
    80001d5a:	6105                	addi	sp,sp,32
    80001d5c:	8082                	ret

0000000080001d5e <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d5e:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d62:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001d64:	0a07d163          	bgez	a5,80001e06 <devintr+0xa8>
{
    80001d68:	1101                	addi	sp,sp,-32
    80001d6a:	ec06                	sd	ra,24(sp)
    80001d6c:	e822                	sd	s0,16(sp)
    80001d6e:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001d70:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001d74:	46a5                	li	a3,9
    80001d76:	00d70c63          	beq	a4,a3,80001d8e <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001d7a:	577d                	li	a4,-1
    80001d7c:	177e                	slli	a4,a4,0x3f
    80001d7e:	0705                	addi	a4,a4,1
    return 0;
    80001d80:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d82:	06e78163          	beq	a5,a4,80001de4 <devintr+0x86>
  }
}
    80001d86:	60e2                	ld	ra,24(sp)
    80001d88:	6442                	ld	s0,16(sp)
    80001d8a:	6105                	addi	sp,sp,32
    80001d8c:	8082                	ret
    80001d8e:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001d90:	00003097          	auipc	ra,0x3
    80001d94:	61c080e7          	jalr	1564(ra) # 800053ac <plic_claim>
    80001d98:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d9a:	47a9                	li	a5,10
    80001d9c:	00f50963          	beq	a0,a5,80001dae <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001da0:	4785                	li	a5,1
    80001da2:	00f50b63          	beq	a0,a5,80001db8 <devintr+0x5a>
    return 1;
    80001da6:	4505                	li	a0,1
    } else if(irq){
    80001da8:	ec89                	bnez	s1,80001dc2 <devintr+0x64>
    80001daa:	64a2                	ld	s1,8(sp)
    80001dac:	bfe9                	j	80001d86 <devintr+0x28>
      uartintr();
    80001dae:	00004097          	auipc	ra,0x4
    80001db2:	578080e7          	jalr	1400(ra) # 80006326 <uartintr>
    if(irq)
    80001db6:	a839                	j	80001dd4 <devintr+0x76>
      virtio_disk_intr();
    80001db8:	00004097          	auipc	ra,0x4
    80001dbc:	ac8080e7          	jalr	-1336(ra) # 80005880 <virtio_disk_intr>
    if(irq)
    80001dc0:	a811                	j	80001dd4 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001dc2:	85a6                	mv	a1,s1
    80001dc4:	00006517          	auipc	a0,0x6
    80001dc8:	4cc50513          	addi	a0,a0,1228 # 80008290 <etext+0x290>
    80001dcc:	00004097          	auipc	ra,0x4
    80001dd0:	10a080e7          	jalr	266(ra) # 80005ed6 <printf>
      plic_complete(irq);
    80001dd4:	8526                	mv	a0,s1
    80001dd6:	00003097          	auipc	ra,0x3
    80001dda:	5fa080e7          	jalr	1530(ra) # 800053d0 <plic_complete>
    return 1;
    80001dde:	4505                	li	a0,1
    80001de0:	64a2                	ld	s1,8(sp)
    80001de2:	b755                	j	80001d86 <devintr+0x28>
    if(cpuid() == 0){
    80001de4:	fffff097          	auipc	ra,0xfffff
    80001de8:	150080e7          	jalr	336(ra) # 80000f34 <cpuid>
    80001dec:	c901                	beqz	a0,80001dfc <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001dee:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001df2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001df4:	14479073          	csrw	sip,a5
    return 2;
    80001df8:	4509                	li	a0,2
    80001dfa:	b771                	j	80001d86 <devintr+0x28>
      clockintr();
    80001dfc:	00000097          	auipc	ra,0x0
    80001e00:	f1c080e7          	jalr	-228(ra) # 80001d18 <clockintr>
    80001e04:	b7ed                	j	80001dee <devintr+0x90>
}
    80001e06:	8082                	ret

0000000080001e08 <usertrap>:
{
    80001e08:	1101                	addi	sp,sp,-32
    80001e0a:	ec06                	sd	ra,24(sp)
    80001e0c:	e822                	sd	s0,16(sp)
    80001e0e:	e426                	sd	s1,8(sp)
    80001e10:	e04a                	sd	s2,0(sp)
    80001e12:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e14:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e18:	1007f793          	andi	a5,a5,256
    80001e1c:	e3ad                	bnez	a5,80001e7e <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e1e:	00003797          	auipc	a5,0x3
    80001e22:	48278793          	addi	a5,a5,1154 # 800052a0 <kernelvec>
    80001e26:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e2a:	fffff097          	auipc	ra,0xfffff
    80001e2e:	136080e7          	jalr	310(ra) # 80000f60 <myproc>
    80001e32:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e34:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e36:	14102773          	csrr	a4,sepc
    80001e3a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e3c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e40:	47a1                	li	a5,8
    80001e42:	04f71c63          	bne	a4,a5,80001e9a <usertrap+0x92>
    if(p->killed)
    80001e46:	551c                	lw	a5,40(a0)
    80001e48:	e3b9                	bnez	a5,80001e8e <usertrap+0x86>
    p->trapframe->epc += 4;
    80001e4a:	6cb8                	ld	a4,88(s1)
    80001e4c:	6f1c                	ld	a5,24(a4)
    80001e4e:	0791                	addi	a5,a5,4
    80001e50:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e52:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e56:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e5a:	10079073          	csrw	sstatus,a5
    syscall();
    80001e5e:	00000097          	auipc	ra,0x0
    80001e62:	2e0080e7          	jalr	736(ra) # 8000213e <syscall>
  if(p->killed)
    80001e66:	549c                	lw	a5,40(s1)
    80001e68:	ebc1                	bnez	a5,80001ef8 <usertrap+0xf0>
  usertrapret();
    80001e6a:	00000097          	auipc	ra,0x0
    80001e6e:	e10080e7          	jalr	-496(ra) # 80001c7a <usertrapret>
}
    80001e72:	60e2                	ld	ra,24(sp)
    80001e74:	6442                	ld	s0,16(sp)
    80001e76:	64a2                	ld	s1,8(sp)
    80001e78:	6902                	ld	s2,0(sp)
    80001e7a:	6105                	addi	sp,sp,32
    80001e7c:	8082                	ret
    panic("usertrap: not from user mode");
    80001e7e:	00006517          	auipc	a0,0x6
    80001e82:	43250513          	addi	a0,a0,1074 # 800082b0 <etext+0x2b0>
    80001e86:	00004097          	auipc	ra,0x4
    80001e8a:	006080e7          	jalr	6(ra) # 80005e8c <panic>
      exit(-1);
    80001e8e:	557d                	li	a0,-1
    80001e90:	00000097          	auipc	ra,0x0
    80001e94:	a9c080e7          	jalr	-1380(ra) # 8000192c <exit>
    80001e98:	bf4d                	j	80001e4a <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001e9a:	00000097          	auipc	ra,0x0
    80001e9e:	ec4080e7          	jalr	-316(ra) # 80001d5e <devintr>
    80001ea2:	892a                	mv	s2,a0
    80001ea4:	c501                	beqz	a0,80001eac <usertrap+0xa4>
  if(p->killed)
    80001ea6:	549c                	lw	a5,40(s1)
    80001ea8:	c3a1                	beqz	a5,80001ee8 <usertrap+0xe0>
    80001eaa:	a815                	j	80001ede <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001eac:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001eb0:	5890                	lw	a2,48(s1)
    80001eb2:	00006517          	auipc	a0,0x6
    80001eb6:	41e50513          	addi	a0,a0,1054 # 800082d0 <etext+0x2d0>
    80001eba:	00004097          	auipc	ra,0x4
    80001ebe:	01c080e7          	jalr	28(ra) # 80005ed6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ec2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ec6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001eca:	00006517          	auipc	a0,0x6
    80001ece:	43650513          	addi	a0,a0,1078 # 80008300 <etext+0x300>
    80001ed2:	00004097          	auipc	ra,0x4
    80001ed6:	004080e7          	jalr	4(ra) # 80005ed6 <printf>
    p->killed = 1;
    80001eda:	4785                	li	a5,1
    80001edc:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001ede:	557d                	li	a0,-1
    80001ee0:	00000097          	auipc	ra,0x0
    80001ee4:	a4c080e7          	jalr	-1460(ra) # 8000192c <exit>
  if(which_dev == 2)
    80001ee8:	4789                	li	a5,2
    80001eea:	f8f910e3          	bne	s2,a5,80001e6a <usertrap+0x62>
    yield();
    80001eee:	fffff097          	auipc	ra,0xfffff
    80001ef2:	7a6080e7          	jalr	1958(ra) # 80001694 <yield>
    80001ef6:	bf95                	j	80001e6a <usertrap+0x62>
  int which_dev = 0;
    80001ef8:	4901                	li	s2,0
    80001efa:	b7d5                	j	80001ede <usertrap+0xd6>

0000000080001efc <kerneltrap>:
{
    80001efc:	7179                	addi	sp,sp,-48
    80001efe:	f406                	sd	ra,40(sp)
    80001f00:	f022                	sd	s0,32(sp)
    80001f02:	ec26                	sd	s1,24(sp)
    80001f04:	e84a                	sd	s2,16(sp)
    80001f06:	e44e                	sd	s3,8(sp)
    80001f08:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f0a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f0e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f12:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f16:	1004f793          	andi	a5,s1,256
    80001f1a:	cb85                	beqz	a5,80001f4a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f1c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f20:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f22:	ef85                	bnez	a5,80001f5a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f24:	00000097          	auipc	ra,0x0
    80001f28:	e3a080e7          	jalr	-454(ra) # 80001d5e <devintr>
    80001f2c:	cd1d                	beqz	a0,80001f6a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f2e:	4789                	li	a5,2
    80001f30:	06f50a63          	beq	a0,a5,80001fa4 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f34:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f38:	10049073          	csrw	sstatus,s1
}
    80001f3c:	70a2                	ld	ra,40(sp)
    80001f3e:	7402                	ld	s0,32(sp)
    80001f40:	64e2                	ld	s1,24(sp)
    80001f42:	6942                	ld	s2,16(sp)
    80001f44:	69a2                	ld	s3,8(sp)
    80001f46:	6145                	addi	sp,sp,48
    80001f48:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f4a:	00006517          	auipc	a0,0x6
    80001f4e:	3d650513          	addi	a0,a0,982 # 80008320 <etext+0x320>
    80001f52:	00004097          	auipc	ra,0x4
    80001f56:	f3a080e7          	jalr	-198(ra) # 80005e8c <panic>
    panic("kerneltrap: interrupts enabled");
    80001f5a:	00006517          	auipc	a0,0x6
    80001f5e:	3ee50513          	addi	a0,a0,1006 # 80008348 <etext+0x348>
    80001f62:	00004097          	auipc	ra,0x4
    80001f66:	f2a080e7          	jalr	-214(ra) # 80005e8c <panic>
    printf("scause %p\n", scause);
    80001f6a:	85ce                	mv	a1,s3
    80001f6c:	00006517          	auipc	a0,0x6
    80001f70:	3fc50513          	addi	a0,a0,1020 # 80008368 <etext+0x368>
    80001f74:	00004097          	auipc	ra,0x4
    80001f78:	f62080e7          	jalr	-158(ra) # 80005ed6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f7c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f80:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f84:	00006517          	auipc	a0,0x6
    80001f88:	3f450513          	addi	a0,a0,1012 # 80008378 <etext+0x378>
    80001f8c:	00004097          	auipc	ra,0x4
    80001f90:	f4a080e7          	jalr	-182(ra) # 80005ed6 <printf>
    panic("kerneltrap");
    80001f94:	00006517          	auipc	a0,0x6
    80001f98:	3fc50513          	addi	a0,a0,1020 # 80008390 <etext+0x390>
    80001f9c:	00004097          	auipc	ra,0x4
    80001fa0:	ef0080e7          	jalr	-272(ra) # 80005e8c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fa4:	fffff097          	auipc	ra,0xfffff
    80001fa8:	fbc080e7          	jalr	-68(ra) # 80000f60 <myproc>
    80001fac:	d541                	beqz	a0,80001f34 <kerneltrap+0x38>
    80001fae:	fffff097          	auipc	ra,0xfffff
    80001fb2:	fb2080e7          	jalr	-78(ra) # 80000f60 <myproc>
    80001fb6:	4d18                	lw	a4,24(a0)
    80001fb8:	4791                	li	a5,4
    80001fba:	f6f71de3          	bne	a4,a5,80001f34 <kerneltrap+0x38>
    yield();
    80001fbe:	fffff097          	auipc	ra,0xfffff
    80001fc2:	6d6080e7          	jalr	1750(ra) # 80001694 <yield>
    80001fc6:	b7bd                	j	80001f34 <kerneltrap+0x38>

0000000080001fc8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fc8:	1101                	addi	sp,sp,-32
    80001fca:	ec06                	sd	ra,24(sp)
    80001fcc:	e822                	sd	s0,16(sp)
    80001fce:	e426                	sd	s1,8(sp)
    80001fd0:	1000                	addi	s0,sp,32
    80001fd2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fd4:	fffff097          	auipc	ra,0xfffff
    80001fd8:	f8c080e7          	jalr	-116(ra) # 80000f60 <myproc>
  switch (n) {
    80001fdc:	4795                	li	a5,5
    80001fde:	0497e163          	bltu	a5,s1,80002020 <argraw+0x58>
    80001fe2:	048a                	slli	s1,s1,0x2
    80001fe4:	00006717          	auipc	a4,0x6
    80001fe8:	7a470713          	addi	a4,a4,1956 # 80008788 <states.0+0x30>
    80001fec:	94ba                	add	s1,s1,a4
    80001fee:	409c                	lw	a5,0(s1)
    80001ff0:	97ba                	add	a5,a5,a4
    80001ff2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ff4:	6d3c                	ld	a5,88(a0)
    80001ff6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ff8:	60e2                	ld	ra,24(sp)
    80001ffa:	6442                	ld	s0,16(sp)
    80001ffc:	64a2                	ld	s1,8(sp)
    80001ffe:	6105                	addi	sp,sp,32
    80002000:	8082                	ret
    return p->trapframe->a1;
    80002002:	6d3c                	ld	a5,88(a0)
    80002004:	7fa8                	ld	a0,120(a5)
    80002006:	bfcd                	j	80001ff8 <argraw+0x30>
    return p->trapframe->a2;
    80002008:	6d3c                	ld	a5,88(a0)
    8000200a:	63c8                	ld	a0,128(a5)
    8000200c:	b7f5                	j	80001ff8 <argraw+0x30>
    return p->trapframe->a3;
    8000200e:	6d3c                	ld	a5,88(a0)
    80002010:	67c8                	ld	a0,136(a5)
    80002012:	b7dd                	j	80001ff8 <argraw+0x30>
    return p->trapframe->a4;
    80002014:	6d3c                	ld	a5,88(a0)
    80002016:	6bc8                	ld	a0,144(a5)
    80002018:	b7c5                	j	80001ff8 <argraw+0x30>
    return p->trapframe->a5;
    8000201a:	6d3c                	ld	a5,88(a0)
    8000201c:	6fc8                	ld	a0,152(a5)
    8000201e:	bfe9                	j	80001ff8 <argraw+0x30>
  panic("argraw");
    80002020:	00006517          	auipc	a0,0x6
    80002024:	38050513          	addi	a0,a0,896 # 800083a0 <etext+0x3a0>
    80002028:	00004097          	auipc	ra,0x4
    8000202c:	e64080e7          	jalr	-412(ra) # 80005e8c <panic>

0000000080002030 <fetchaddr>:
{
    80002030:	1101                	addi	sp,sp,-32
    80002032:	ec06                	sd	ra,24(sp)
    80002034:	e822                	sd	s0,16(sp)
    80002036:	e426                	sd	s1,8(sp)
    80002038:	e04a                	sd	s2,0(sp)
    8000203a:	1000                	addi	s0,sp,32
    8000203c:	84aa                	mv	s1,a0
    8000203e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002040:	fffff097          	auipc	ra,0xfffff
    80002044:	f20080e7          	jalr	-224(ra) # 80000f60 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002048:	653c                	ld	a5,72(a0)
    8000204a:	02f4f863          	bgeu	s1,a5,8000207a <fetchaddr+0x4a>
    8000204e:	00848713          	addi	a4,s1,8
    80002052:	02e7e663          	bltu	a5,a4,8000207e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002056:	46a1                	li	a3,8
    80002058:	8626                	mv	a2,s1
    8000205a:	85ca                	mv	a1,s2
    8000205c:	6928                	ld	a0,80(a0)
    8000205e:	fffff097          	auipc	ra,0xfffff
    80002062:	b46080e7          	jalr	-1210(ra) # 80000ba4 <copyin>
    80002066:	00a03533          	snez	a0,a0
    8000206a:	40a00533          	neg	a0,a0
}
    8000206e:	60e2                	ld	ra,24(sp)
    80002070:	6442                	ld	s0,16(sp)
    80002072:	64a2                	ld	s1,8(sp)
    80002074:	6902                	ld	s2,0(sp)
    80002076:	6105                	addi	sp,sp,32
    80002078:	8082                	ret
    return -1;
    8000207a:	557d                	li	a0,-1
    8000207c:	bfcd                	j	8000206e <fetchaddr+0x3e>
    8000207e:	557d                	li	a0,-1
    80002080:	b7fd                	j	8000206e <fetchaddr+0x3e>

0000000080002082 <fetchstr>:
{
    80002082:	7179                	addi	sp,sp,-48
    80002084:	f406                	sd	ra,40(sp)
    80002086:	f022                	sd	s0,32(sp)
    80002088:	ec26                	sd	s1,24(sp)
    8000208a:	e84a                	sd	s2,16(sp)
    8000208c:	e44e                	sd	s3,8(sp)
    8000208e:	1800                	addi	s0,sp,48
    80002090:	892a                	mv	s2,a0
    80002092:	84ae                	mv	s1,a1
    80002094:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002096:	fffff097          	auipc	ra,0xfffff
    8000209a:	eca080e7          	jalr	-310(ra) # 80000f60 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000209e:	86ce                	mv	a3,s3
    800020a0:	864a                	mv	a2,s2
    800020a2:	85a6                	mv	a1,s1
    800020a4:	6928                	ld	a0,80(a0)
    800020a6:	fffff097          	auipc	ra,0xfffff
    800020aa:	b8c080e7          	jalr	-1140(ra) # 80000c32 <copyinstr>
  if(err < 0)
    800020ae:	00054763          	bltz	a0,800020bc <fetchstr+0x3a>
  return strlen(buf);
    800020b2:	8526                	mv	a0,s1
    800020b4:	ffffe097          	auipc	ra,0xffffe
    800020b8:	23a080e7          	jalr	570(ra) # 800002ee <strlen>
}
    800020bc:	70a2                	ld	ra,40(sp)
    800020be:	7402                	ld	s0,32(sp)
    800020c0:	64e2                	ld	s1,24(sp)
    800020c2:	6942                	ld	s2,16(sp)
    800020c4:	69a2                	ld	s3,8(sp)
    800020c6:	6145                	addi	sp,sp,48
    800020c8:	8082                	ret

00000000800020ca <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800020ca:	1101                	addi	sp,sp,-32
    800020cc:	ec06                	sd	ra,24(sp)
    800020ce:	e822                	sd	s0,16(sp)
    800020d0:	e426                	sd	s1,8(sp)
    800020d2:	1000                	addi	s0,sp,32
    800020d4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020d6:	00000097          	auipc	ra,0x0
    800020da:	ef2080e7          	jalr	-270(ra) # 80001fc8 <argraw>
    800020de:	c088                	sw	a0,0(s1)
  return 0;
}
    800020e0:	4501                	li	a0,0
    800020e2:	60e2                	ld	ra,24(sp)
    800020e4:	6442                	ld	s0,16(sp)
    800020e6:	64a2                	ld	s1,8(sp)
    800020e8:	6105                	addi	sp,sp,32
    800020ea:	8082                	ret

00000000800020ec <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800020ec:	1101                	addi	sp,sp,-32
    800020ee:	ec06                	sd	ra,24(sp)
    800020f0:	e822                	sd	s0,16(sp)
    800020f2:	e426                	sd	s1,8(sp)
    800020f4:	1000                	addi	s0,sp,32
    800020f6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020f8:	00000097          	auipc	ra,0x0
    800020fc:	ed0080e7          	jalr	-304(ra) # 80001fc8 <argraw>
    80002100:	e088                	sd	a0,0(s1)
  return 0;
}
    80002102:	4501                	li	a0,0
    80002104:	60e2                	ld	ra,24(sp)
    80002106:	6442                	ld	s0,16(sp)
    80002108:	64a2                	ld	s1,8(sp)
    8000210a:	6105                	addi	sp,sp,32
    8000210c:	8082                	ret

000000008000210e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000210e:	1101                	addi	sp,sp,-32
    80002110:	ec06                	sd	ra,24(sp)
    80002112:	e822                	sd	s0,16(sp)
    80002114:	e426                	sd	s1,8(sp)
    80002116:	e04a                	sd	s2,0(sp)
    80002118:	1000                	addi	s0,sp,32
    8000211a:	84ae                	mv	s1,a1
    8000211c:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000211e:	00000097          	auipc	ra,0x0
    80002122:	eaa080e7          	jalr	-342(ra) # 80001fc8 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002126:	864a                	mv	a2,s2
    80002128:	85a6                	mv	a1,s1
    8000212a:	00000097          	auipc	ra,0x0
    8000212e:	f58080e7          	jalr	-168(ra) # 80002082 <fetchstr>
}
    80002132:	60e2                	ld	ra,24(sp)
    80002134:	6442                	ld	s0,16(sp)
    80002136:	64a2                	ld	s1,8(sp)
    80002138:	6902                	ld	s2,0(sp)
    8000213a:	6105                	addi	sp,sp,32
    8000213c:	8082                	ret

000000008000213e <syscall>:



void
syscall(void)
{
    8000213e:	1101                	addi	sp,sp,-32
    80002140:	ec06                	sd	ra,24(sp)
    80002142:	e822                	sd	s0,16(sp)
    80002144:	e426                	sd	s1,8(sp)
    80002146:	e04a                	sd	s2,0(sp)
    80002148:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000214a:	fffff097          	auipc	ra,0xfffff
    8000214e:	e16080e7          	jalr	-490(ra) # 80000f60 <myproc>
    80002152:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002154:	05853903          	ld	s2,88(a0)
    80002158:	0a893783          	ld	a5,168(s2)
    8000215c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002160:	37fd                	addiw	a5,a5,-1
    80002162:	4775                	li	a4,29
    80002164:	00f76f63          	bltu	a4,a5,80002182 <syscall+0x44>
    80002168:	00369713          	slli	a4,a3,0x3
    8000216c:	00006797          	auipc	a5,0x6
    80002170:	63478793          	addi	a5,a5,1588 # 800087a0 <syscalls>
    80002174:	97ba                	add	a5,a5,a4
    80002176:	639c                	ld	a5,0(a5)
    80002178:	c789                	beqz	a5,80002182 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000217a:	9782                	jalr	a5
    8000217c:	06a93823          	sd	a0,112(s2)
    80002180:	a839                	j	8000219e <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002182:	16048613          	addi	a2,s1,352
    80002186:	588c                	lw	a1,48(s1)
    80002188:	00006517          	auipc	a0,0x6
    8000218c:	22050513          	addi	a0,a0,544 # 800083a8 <etext+0x3a8>
    80002190:	00004097          	auipc	ra,0x4
    80002194:	d46080e7          	jalr	-698(ra) # 80005ed6 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002198:	6cbc                	ld	a5,88(s1)
    8000219a:	577d                	li	a4,-1
    8000219c:	fbb8                	sd	a4,112(a5)
  }
}
    8000219e:	60e2                	ld	ra,24(sp)
    800021a0:	6442                	ld	s0,16(sp)
    800021a2:	64a2                	ld	s1,8(sp)
    800021a4:	6902                	ld	s2,0(sp)
    800021a6:	6105                	addi	sp,sp,32
    800021a8:	8082                	ret

00000000800021aa <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021aa:	1101                	addi	sp,sp,-32
    800021ac:	ec06                	sd	ra,24(sp)
    800021ae:	e822                	sd	s0,16(sp)
    800021b0:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800021b2:	fec40593          	addi	a1,s0,-20
    800021b6:	4501                	li	a0,0
    800021b8:	00000097          	auipc	ra,0x0
    800021bc:	f12080e7          	jalr	-238(ra) # 800020ca <argint>
    return -1;
    800021c0:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021c2:	00054963          	bltz	a0,800021d4 <sys_exit+0x2a>
  exit(n);
    800021c6:	fec42503          	lw	a0,-20(s0)
    800021ca:	fffff097          	auipc	ra,0xfffff
    800021ce:	762080e7          	jalr	1890(ra) # 8000192c <exit>
  return 0;  // not reached
    800021d2:	4781                	li	a5,0
}
    800021d4:	853e                	mv	a0,a5
    800021d6:	60e2                	ld	ra,24(sp)
    800021d8:	6442                	ld	s0,16(sp)
    800021da:	6105                	addi	sp,sp,32
    800021dc:	8082                	ret

00000000800021de <sys_getpid>:

uint64
sys_getpid(void)
{
    800021de:	1141                	addi	sp,sp,-16
    800021e0:	e406                	sd	ra,8(sp)
    800021e2:	e022                	sd	s0,0(sp)
    800021e4:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021e6:	fffff097          	auipc	ra,0xfffff
    800021ea:	d7a080e7          	jalr	-646(ra) # 80000f60 <myproc>
}
    800021ee:	5908                	lw	a0,48(a0)
    800021f0:	60a2                	ld	ra,8(sp)
    800021f2:	6402                	ld	s0,0(sp)
    800021f4:	0141                	addi	sp,sp,16
    800021f6:	8082                	ret

00000000800021f8 <sys_fork>:

uint64
sys_fork(void)
{
    800021f8:	1141                	addi	sp,sp,-16
    800021fa:	e406                	sd	ra,8(sp)
    800021fc:	e022                	sd	s0,0(sp)
    800021fe:	0800                	addi	s0,sp,16
  return fork();
    80002200:	fffff097          	auipc	ra,0xfffff
    80002204:	1dc080e7          	jalr	476(ra) # 800013dc <fork>
}
    80002208:	60a2                	ld	ra,8(sp)
    8000220a:	6402                	ld	s0,0(sp)
    8000220c:	0141                	addi	sp,sp,16
    8000220e:	8082                	ret

0000000080002210 <sys_wait>:

uint64
sys_wait(void)
{
    80002210:	1101                	addi	sp,sp,-32
    80002212:	ec06                	sd	ra,24(sp)
    80002214:	e822                	sd	s0,16(sp)
    80002216:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002218:	fe840593          	addi	a1,s0,-24
    8000221c:	4501                	li	a0,0
    8000221e:	00000097          	auipc	ra,0x0
    80002222:	ece080e7          	jalr	-306(ra) # 800020ec <argaddr>
    80002226:	87aa                	mv	a5,a0
    return -1;
    80002228:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000222a:	0007c863          	bltz	a5,8000223a <sys_wait+0x2a>
  return wait(p);
    8000222e:	fe843503          	ld	a0,-24(s0)
    80002232:	fffff097          	auipc	ra,0xfffff
    80002236:	502080e7          	jalr	1282(ra) # 80001734 <wait>
}
    8000223a:	60e2                	ld	ra,24(sp)
    8000223c:	6442                	ld	s0,16(sp)
    8000223e:	6105                	addi	sp,sp,32
    80002240:	8082                	ret

0000000080002242 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002242:	7179                	addi	sp,sp,-48
    80002244:	f406                	sd	ra,40(sp)
    80002246:	f022                	sd	s0,32(sp)
    80002248:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000224a:	fdc40593          	addi	a1,s0,-36
    8000224e:	4501                	li	a0,0
    80002250:	00000097          	auipc	ra,0x0
    80002254:	e7a080e7          	jalr	-390(ra) # 800020ca <argint>
    80002258:	87aa                	mv	a5,a0
    return -1;
    8000225a:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000225c:	0207c263          	bltz	a5,80002280 <sys_sbrk+0x3e>
    80002260:	ec26                	sd	s1,24(sp)
  
  addr = myproc()->sz;
    80002262:	fffff097          	auipc	ra,0xfffff
    80002266:	cfe080e7          	jalr	-770(ra) # 80000f60 <myproc>
    8000226a:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000226c:	fdc42503          	lw	a0,-36(s0)
    80002270:	fffff097          	auipc	ra,0xfffff
    80002274:	0f4080e7          	jalr	244(ra) # 80001364 <growproc>
    80002278:	00054863          	bltz	a0,80002288 <sys_sbrk+0x46>
    return -1;
  return addr;
    8000227c:	8526                	mv	a0,s1
    8000227e:	64e2                	ld	s1,24(sp)
}
    80002280:	70a2                	ld	ra,40(sp)
    80002282:	7402                	ld	s0,32(sp)
    80002284:	6145                	addi	sp,sp,48
    80002286:	8082                	ret
    return -1;
    80002288:	557d                	li	a0,-1
    8000228a:	64e2                	ld	s1,24(sp)
    8000228c:	bfd5                	j	80002280 <sys_sbrk+0x3e>

000000008000228e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000228e:	7139                	addi	sp,sp,-64
    80002290:	fc06                	sd	ra,56(sp)
    80002292:	f822                	sd	s0,48(sp)
    80002294:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    80002296:	fcc40593          	addi	a1,s0,-52
    8000229a:	4501                	li	a0,0
    8000229c:	00000097          	auipc	ra,0x0
    800022a0:	e2e080e7          	jalr	-466(ra) # 800020ca <argint>
    return -1;
    800022a4:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800022a6:	06054b63          	bltz	a0,8000231c <sys_sleep+0x8e>
    800022aa:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    800022ac:	00010517          	auipc	a0,0x10
    800022b0:	dd450513          	addi	a0,a0,-556 # 80012080 <tickslock>
    800022b4:	00004097          	auipc	ra,0x4
    800022b8:	152080e7          	jalr	338(ra) # 80006406 <acquire>
  ticks0 = ticks;
    800022bc:	0000a917          	auipc	s2,0xa
    800022c0:	d5c92903          	lw	s2,-676(s2) # 8000c018 <ticks>
  while(ticks - ticks0 < n){
    800022c4:	fcc42783          	lw	a5,-52(s0)
    800022c8:	c3a1                	beqz	a5,80002308 <sys_sleep+0x7a>
    800022ca:	f426                	sd	s1,40(sp)
    800022cc:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022ce:	00010997          	auipc	s3,0x10
    800022d2:	db298993          	addi	s3,s3,-590 # 80012080 <tickslock>
    800022d6:	0000a497          	auipc	s1,0xa
    800022da:	d4248493          	addi	s1,s1,-702 # 8000c018 <ticks>
    if(myproc()->killed){
    800022de:	fffff097          	auipc	ra,0xfffff
    800022e2:	c82080e7          	jalr	-894(ra) # 80000f60 <myproc>
    800022e6:	551c                	lw	a5,40(a0)
    800022e8:	ef9d                	bnez	a5,80002326 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800022ea:	85ce                	mv	a1,s3
    800022ec:	8526                	mv	a0,s1
    800022ee:	fffff097          	auipc	ra,0xfffff
    800022f2:	3e2080e7          	jalr	994(ra) # 800016d0 <sleep>
  while(ticks - ticks0 < n){
    800022f6:	409c                	lw	a5,0(s1)
    800022f8:	412787bb          	subw	a5,a5,s2
    800022fc:	fcc42703          	lw	a4,-52(s0)
    80002300:	fce7efe3          	bltu	a5,a4,800022de <sys_sleep+0x50>
    80002304:	74a2                	ld	s1,40(sp)
    80002306:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002308:	00010517          	auipc	a0,0x10
    8000230c:	d7850513          	addi	a0,a0,-648 # 80012080 <tickslock>
    80002310:	00004097          	auipc	ra,0x4
    80002314:	1aa080e7          	jalr	426(ra) # 800064ba <release>
  return 0;
    80002318:	4781                	li	a5,0
    8000231a:	7902                	ld	s2,32(sp)
}
    8000231c:	853e                	mv	a0,a5
    8000231e:	70e2                	ld	ra,56(sp)
    80002320:	7442                	ld	s0,48(sp)
    80002322:	6121                	addi	sp,sp,64
    80002324:	8082                	ret
      release(&tickslock);
    80002326:	00010517          	auipc	a0,0x10
    8000232a:	d5a50513          	addi	a0,a0,-678 # 80012080 <tickslock>
    8000232e:	00004097          	auipc	ra,0x4
    80002332:	18c080e7          	jalr	396(ra) # 800064ba <release>
      return -1;
    80002336:	57fd                	li	a5,-1
    80002338:	74a2                	ld	s1,40(sp)
    8000233a:	7902                	ld	s2,32(sp)
    8000233c:	69e2                	ld	s3,24(sp)
    8000233e:	bff9                	j	8000231c <sys_sleep+0x8e>

0000000080002340 <sys_pgaccess>:


//#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    80002340:	7139                	addi	sp,sp,-64
    80002342:	fc06                	sd	ra,56(sp)
    80002344:	f822                	sd	s0,48(sp)
    80002346:	0080                	addi	s0,sp,64
  uint64 addr;
  int len;
  int bitmask;
  if(argint(1, &len) < 0)
    80002348:	fd440593          	addi	a1,s0,-44
    8000234c:	4505                	li	a0,1
    8000234e:	00000097          	auipc	ra,0x0
    80002352:	d7c080e7          	jalr	-644(ra) # 800020ca <argint>
    80002356:	0a054263          	bltz	a0,800023fa <sys_pgaccess+0xba>
    return -1;
  if(argaddr(0, &addr) < 0)
    8000235a:	fd840593          	addi	a1,s0,-40
    8000235e:	4501                	li	a0,0
    80002360:	00000097          	auipc	ra,0x0
    80002364:	d8c080e7          	jalr	-628(ra) # 800020ec <argaddr>
    80002368:	08054b63          	bltz	a0,800023fe <sys_pgaccess+0xbe>
    return -1;
  if(argint(2, &bitmask) < 0)
    8000236c:	fd040593          	addi	a1,s0,-48
    80002370:	4509                	li	a0,2
    80002372:	00000097          	auipc	ra,0x0
    80002376:	d58080e7          	jalr	-680(ra) # 800020ca <argint>
    8000237a:	08054463          	bltz	a0,80002402 <sys_pgaccess+0xc2>
    return -1;
  if(len > 32 || len < 0)
    8000237e:	fd442703          	lw	a4,-44(s0)
    80002382:	02000793          	li	a5,32
    80002386:	08e7e063          	bltu	a5,a4,80002406 <sys_pgaccess+0xc6>
    8000238a:	f04a                	sd	s2,32(sp)
    return -1;
  int res = 0;
    8000238c:	fc042623          	sw	zero,-52(s0)
  struct proc *p = myproc();
    80002390:	fffff097          	auipc	ra,0xfffff
    80002394:	bd0080e7          	jalr	-1072(ra) # 80000f60 <myproc>
    80002398:	892a                	mv	s2,a0
  for(int i=0;i<len;i++){
    8000239a:	fd442783          	lw	a5,-44(s0)
    8000239e:	02f05c63          	blez	a5,800023d6 <sys_pgaccess+0x96>
    800023a2:	f426                	sd	s1,40(sp)
    800023a4:	4481                	li	s1,0
    int va = addr + i * PGSIZE;
    800023a6:	00c4959b          	slliw	a1,s1,0xc
    int abit = vm_pgaccess(p->pagetable, va);
    800023aa:	fd843783          	ld	a5,-40(s0)
    800023ae:	9dbd                	addw	a1,a1,a5
    800023b0:	05093503          	ld	a0,80(s2)
    800023b4:	fffff097          	auipc	ra,0xfffff
    800023b8:	9e0080e7          	jalr	-1568(ra) # 80000d94 <vm_pgaccess>
    res = res | abit << i;
    800023bc:	0095153b          	sllw	a0,a0,s1
    800023c0:	fcc42783          	lw	a5,-52(s0)
    800023c4:	8fc9                	or	a5,a5,a0
    800023c6:	fcf42623          	sw	a5,-52(s0)
  for(int i=0;i<len;i++){
    800023ca:	2485                	addiw	s1,s1,1
    800023cc:	fd442783          	lw	a5,-44(s0)
    800023d0:	fcf4cbe3          	blt	s1,a5,800023a6 <sys_pgaccess+0x66>
    800023d4:	74a2                	ld	s1,40(sp)
  }
  if(copyout(p->pagetable, bitmask, (char*)&res,sizeof(res)) < 0)
    800023d6:	4691                	li	a3,4
    800023d8:	fcc40613          	addi	a2,s0,-52
    800023dc:	fd042583          	lw	a1,-48(s0)
    800023e0:	05093503          	ld	a0,80(s2)
    800023e4:	ffffe097          	auipc	ra,0xffffe
    800023e8:	734080e7          	jalr	1844(ra) # 80000b18 <copyout>
    800023ec:	41f5551b          	sraiw	a0,a0,0x1f
    800023f0:	7902                	ld	s2,32(sp)
    return -1;
  return 0;
}
    800023f2:	70e2                	ld	ra,56(sp)
    800023f4:	7442                	ld	s0,48(sp)
    800023f6:	6121                	addi	sp,sp,64
    800023f8:	8082                	ret
    return -1;
    800023fa:	557d                	li	a0,-1
    800023fc:	bfdd                	j	800023f2 <sys_pgaccess+0xb2>
    return -1;
    800023fe:	557d                	li	a0,-1
    80002400:	bfcd                	j	800023f2 <sys_pgaccess+0xb2>
    return -1;
    80002402:	557d                	li	a0,-1
    80002404:	b7fd                	j	800023f2 <sys_pgaccess+0xb2>
    return -1;
    80002406:	557d                	li	a0,-1
    80002408:	b7ed                	j	800023f2 <sys_pgaccess+0xb2>

000000008000240a <sys_kill>:
//#endif

uint64
sys_kill(void)
{
    8000240a:	1101                	addi	sp,sp,-32
    8000240c:	ec06                	sd	ra,24(sp)
    8000240e:	e822                	sd	s0,16(sp)
    80002410:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002412:	fec40593          	addi	a1,s0,-20
    80002416:	4501                	li	a0,0
    80002418:	00000097          	auipc	ra,0x0
    8000241c:	cb2080e7          	jalr	-846(ra) # 800020ca <argint>
    80002420:	87aa                	mv	a5,a0
    return -1;
    80002422:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002424:	0007c863          	bltz	a5,80002434 <sys_kill+0x2a>
  return kill(pid);
    80002428:	fec42503          	lw	a0,-20(s0)
    8000242c:	fffff097          	auipc	ra,0xfffff
    80002430:	5d6080e7          	jalr	1494(ra) # 80001a02 <kill>
}
    80002434:	60e2                	ld	ra,24(sp)
    80002436:	6442                	ld	s0,16(sp)
    80002438:	6105                	addi	sp,sp,32
    8000243a:	8082                	ret

000000008000243c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000243c:	1101                	addi	sp,sp,-32
    8000243e:	ec06                	sd	ra,24(sp)
    80002440:	e822                	sd	s0,16(sp)
    80002442:	e426                	sd	s1,8(sp)
    80002444:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002446:	00010517          	auipc	a0,0x10
    8000244a:	c3a50513          	addi	a0,a0,-966 # 80012080 <tickslock>
    8000244e:	00004097          	auipc	ra,0x4
    80002452:	fb8080e7          	jalr	-72(ra) # 80006406 <acquire>
  xticks = ticks;
    80002456:	0000a497          	auipc	s1,0xa
    8000245a:	bc24a483          	lw	s1,-1086(s1) # 8000c018 <ticks>
  release(&tickslock);
    8000245e:	00010517          	auipc	a0,0x10
    80002462:	c2250513          	addi	a0,a0,-990 # 80012080 <tickslock>
    80002466:	00004097          	auipc	ra,0x4
    8000246a:	054080e7          	jalr	84(ra) # 800064ba <release>
  return xticks;
}
    8000246e:	02049513          	slli	a0,s1,0x20
    80002472:	9101                	srli	a0,a0,0x20
    80002474:	60e2                	ld	ra,24(sp)
    80002476:	6442                	ld	s0,16(sp)
    80002478:	64a2                	ld	s1,8(sp)
    8000247a:	6105                	addi	sp,sp,32
    8000247c:	8082                	ret

000000008000247e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000247e:	7179                	addi	sp,sp,-48
    80002480:	f406                	sd	ra,40(sp)
    80002482:	f022                	sd	s0,32(sp)
    80002484:	ec26                	sd	s1,24(sp)
    80002486:	e84a                	sd	s2,16(sp)
    80002488:	e44e                	sd	s3,8(sp)
    8000248a:	e052                	sd	s4,0(sp)
    8000248c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000248e:	00006597          	auipc	a1,0x6
    80002492:	f3a58593          	addi	a1,a1,-198 # 800083c8 <etext+0x3c8>
    80002496:	00010517          	auipc	a0,0x10
    8000249a:	c0250513          	addi	a0,a0,-1022 # 80012098 <bcache>
    8000249e:	00004097          	auipc	ra,0x4
    800024a2:	ed8080e7          	jalr	-296(ra) # 80006376 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024a6:	00018797          	auipc	a5,0x18
    800024aa:	bf278793          	addi	a5,a5,-1038 # 8001a098 <bcache+0x8000>
    800024ae:	00018717          	auipc	a4,0x18
    800024b2:	e5270713          	addi	a4,a4,-430 # 8001a300 <bcache+0x8268>
    800024b6:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024ba:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024be:	00010497          	auipc	s1,0x10
    800024c2:	bf248493          	addi	s1,s1,-1038 # 800120b0 <bcache+0x18>
    b->next = bcache.head.next;
    800024c6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024c8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024ca:	00006a17          	auipc	s4,0x6
    800024ce:	f06a0a13          	addi	s4,s4,-250 # 800083d0 <etext+0x3d0>
    b->next = bcache.head.next;
    800024d2:	2b893783          	ld	a5,696(s2)
    800024d6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024d8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024dc:	85d2                	mv	a1,s4
    800024de:	01048513          	addi	a0,s1,16
    800024e2:	00001097          	auipc	ra,0x1
    800024e6:	4b2080e7          	jalr	1202(ra) # 80003994 <initsleeplock>
    bcache.head.next->prev = b;
    800024ea:	2b893783          	ld	a5,696(s2)
    800024ee:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024f0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024f4:	45848493          	addi	s1,s1,1112
    800024f8:	fd349de3          	bne	s1,s3,800024d2 <binit+0x54>
  }
}
    800024fc:	70a2                	ld	ra,40(sp)
    800024fe:	7402                	ld	s0,32(sp)
    80002500:	64e2                	ld	s1,24(sp)
    80002502:	6942                	ld	s2,16(sp)
    80002504:	69a2                	ld	s3,8(sp)
    80002506:	6a02                	ld	s4,0(sp)
    80002508:	6145                	addi	sp,sp,48
    8000250a:	8082                	ret

000000008000250c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000250c:	7179                	addi	sp,sp,-48
    8000250e:	f406                	sd	ra,40(sp)
    80002510:	f022                	sd	s0,32(sp)
    80002512:	ec26                	sd	s1,24(sp)
    80002514:	e84a                	sd	s2,16(sp)
    80002516:	e44e                	sd	s3,8(sp)
    80002518:	1800                	addi	s0,sp,48
    8000251a:	892a                	mv	s2,a0
    8000251c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000251e:	00010517          	auipc	a0,0x10
    80002522:	b7a50513          	addi	a0,a0,-1158 # 80012098 <bcache>
    80002526:	00004097          	auipc	ra,0x4
    8000252a:	ee0080e7          	jalr	-288(ra) # 80006406 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000252e:	00018497          	auipc	s1,0x18
    80002532:	e224b483          	ld	s1,-478(s1) # 8001a350 <bcache+0x82b8>
    80002536:	00018797          	auipc	a5,0x18
    8000253a:	dca78793          	addi	a5,a5,-566 # 8001a300 <bcache+0x8268>
    8000253e:	02f48f63          	beq	s1,a5,8000257c <bread+0x70>
    80002542:	873e                	mv	a4,a5
    80002544:	a021                	j	8000254c <bread+0x40>
    80002546:	68a4                	ld	s1,80(s1)
    80002548:	02e48a63          	beq	s1,a4,8000257c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000254c:	449c                	lw	a5,8(s1)
    8000254e:	ff279ce3          	bne	a5,s2,80002546 <bread+0x3a>
    80002552:	44dc                	lw	a5,12(s1)
    80002554:	ff3799e3          	bne	a5,s3,80002546 <bread+0x3a>
      b->refcnt++;
    80002558:	40bc                	lw	a5,64(s1)
    8000255a:	2785                	addiw	a5,a5,1
    8000255c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000255e:	00010517          	auipc	a0,0x10
    80002562:	b3a50513          	addi	a0,a0,-1222 # 80012098 <bcache>
    80002566:	00004097          	auipc	ra,0x4
    8000256a:	f54080e7          	jalr	-172(ra) # 800064ba <release>
      acquiresleep(&b->lock);
    8000256e:	01048513          	addi	a0,s1,16
    80002572:	00001097          	auipc	ra,0x1
    80002576:	45c080e7          	jalr	1116(ra) # 800039ce <acquiresleep>
      return b;
    8000257a:	a8b9                	j	800025d8 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000257c:	00018497          	auipc	s1,0x18
    80002580:	dcc4b483          	ld	s1,-564(s1) # 8001a348 <bcache+0x82b0>
    80002584:	00018797          	auipc	a5,0x18
    80002588:	d7c78793          	addi	a5,a5,-644 # 8001a300 <bcache+0x8268>
    8000258c:	00f48863          	beq	s1,a5,8000259c <bread+0x90>
    80002590:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002592:	40bc                	lw	a5,64(s1)
    80002594:	cf81                	beqz	a5,800025ac <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002596:	64a4                	ld	s1,72(s1)
    80002598:	fee49de3          	bne	s1,a4,80002592 <bread+0x86>
  panic("bget: no buffers");
    8000259c:	00006517          	auipc	a0,0x6
    800025a0:	e3c50513          	addi	a0,a0,-452 # 800083d8 <etext+0x3d8>
    800025a4:	00004097          	auipc	ra,0x4
    800025a8:	8e8080e7          	jalr	-1816(ra) # 80005e8c <panic>
      b->dev = dev;
    800025ac:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800025b0:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800025b4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025b8:	4785                	li	a5,1
    800025ba:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025bc:	00010517          	auipc	a0,0x10
    800025c0:	adc50513          	addi	a0,a0,-1316 # 80012098 <bcache>
    800025c4:	00004097          	auipc	ra,0x4
    800025c8:	ef6080e7          	jalr	-266(ra) # 800064ba <release>
      acquiresleep(&b->lock);
    800025cc:	01048513          	addi	a0,s1,16
    800025d0:	00001097          	auipc	ra,0x1
    800025d4:	3fe080e7          	jalr	1022(ra) # 800039ce <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025d8:	409c                	lw	a5,0(s1)
    800025da:	cb89                	beqz	a5,800025ec <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025dc:	8526                	mv	a0,s1
    800025de:	70a2                	ld	ra,40(sp)
    800025e0:	7402                	ld	s0,32(sp)
    800025e2:	64e2                	ld	s1,24(sp)
    800025e4:	6942                	ld	s2,16(sp)
    800025e6:	69a2                	ld	s3,8(sp)
    800025e8:	6145                	addi	sp,sp,48
    800025ea:	8082                	ret
    virtio_disk_rw(b, 0);
    800025ec:	4581                	li	a1,0
    800025ee:	8526                	mv	a0,s1
    800025f0:	00003097          	auipc	ra,0x3
    800025f4:	002080e7          	jalr	2(ra) # 800055f2 <virtio_disk_rw>
    b->valid = 1;
    800025f8:	4785                	li	a5,1
    800025fa:	c09c                	sw	a5,0(s1)
  return b;
    800025fc:	b7c5                	j	800025dc <bread+0xd0>

00000000800025fe <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025fe:	1101                	addi	sp,sp,-32
    80002600:	ec06                	sd	ra,24(sp)
    80002602:	e822                	sd	s0,16(sp)
    80002604:	e426                	sd	s1,8(sp)
    80002606:	1000                	addi	s0,sp,32
    80002608:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000260a:	0541                	addi	a0,a0,16
    8000260c:	00001097          	auipc	ra,0x1
    80002610:	45c080e7          	jalr	1116(ra) # 80003a68 <holdingsleep>
    80002614:	cd01                	beqz	a0,8000262c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002616:	4585                	li	a1,1
    80002618:	8526                	mv	a0,s1
    8000261a:	00003097          	auipc	ra,0x3
    8000261e:	fd8080e7          	jalr	-40(ra) # 800055f2 <virtio_disk_rw>
}
    80002622:	60e2                	ld	ra,24(sp)
    80002624:	6442                	ld	s0,16(sp)
    80002626:	64a2                	ld	s1,8(sp)
    80002628:	6105                	addi	sp,sp,32
    8000262a:	8082                	ret
    panic("bwrite");
    8000262c:	00006517          	auipc	a0,0x6
    80002630:	dc450513          	addi	a0,a0,-572 # 800083f0 <etext+0x3f0>
    80002634:	00004097          	auipc	ra,0x4
    80002638:	858080e7          	jalr	-1960(ra) # 80005e8c <panic>

000000008000263c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000263c:	1101                	addi	sp,sp,-32
    8000263e:	ec06                	sd	ra,24(sp)
    80002640:	e822                	sd	s0,16(sp)
    80002642:	e426                	sd	s1,8(sp)
    80002644:	e04a                	sd	s2,0(sp)
    80002646:	1000                	addi	s0,sp,32
    80002648:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000264a:	01050913          	addi	s2,a0,16
    8000264e:	854a                	mv	a0,s2
    80002650:	00001097          	auipc	ra,0x1
    80002654:	418080e7          	jalr	1048(ra) # 80003a68 <holdingsleep>
    80002658:	c925                	beqz	a0,800026c8 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000265a:	854a                	mv	a0,s2
    8000265c:	00001097          	auipc	ra,0x1
    80002660:	3c8080e7          	jalr	968(ra) # 80003a24 <releasesleep>

  acquire(&bcache.lock);
    80002664:	00010517          	auipc	a0,0x10
    80002668:	a3450513          	addi	a0,a0,-1484 # 80012098 <bcache>
    8000266c:	00004097          	auipc	ra,0x4
    80002670:	d9a080e7          	jalr	-614(ra) # 80006406 <acquire>
  b->refcnt--;
    80002674:	40bc                	lw	a5,64(s1)
    80002676:	37fd                	addiw	a5,a5,-1
    80002678:	0007871b          	sext.w	a4,a5
    8000267c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000267e:	e71d                	bnez	a4,800026ac <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002680:	68b8                	ld	a4,80(s1)
    80002682:	64bc                	ld	a5,72(s1)
    80002684:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002686:	68b8                	ld	a4,80(s1)
    80002688:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000268a:	00018797          	auipc	a5,0x18
    8000268e:	a0e78793          	addi	a5,a5,-1522 # 8001a098 <bcache+0x8000>
    80002692:	2b87b703          	ld	a4,696(a5)
    80002696:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002698:	00018717          	auipc	a4,0x18
    8000269c:	c6870713          	addi	a4,a4,-920 # 8001a300 <bcache+0x8268>
    800026a0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026a2:	2b87b703          	ld	a4,696(a5)
    800026a6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026a8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026ac:	00010517          	auipc	a0,0x10
    800026b0:	9ec50513          	addi	a0,a0,-1556 # 80012098 <bcache>
    800026b4:	00004097          	auipc	ra,0x4
    800026b8:	e06080e7          	jalr	-506(ra) # 800064ba <release>
}
    800026bc:	60e2                	ld	ra,24(sp)
    800026be:	6442                	ld	s0,16(sp)
    800026c0:	64a2                	ld	s1,8(sp)
    800026c2:	6902                	ld	s2,0(sp)
    800026c4:	6105                	addi	sp,sp,32
    800026c6:	8082                	ret
    panic("brelse");
    800026c8:	00006517          	auipc	a0,0x6
    800026cc:	d3050513          	addi	a0,a0,-720 # 800083f8 <etext+0x3f8>
    800026d0:	00003097          	auipc	ra,0x3
    800026d4:	7bc080e7          	jalr	1980(ra) # 80005e8c <panic>

00000000800026d8 <bpin>:

void
bpin(struct buf *b) {
    800026d8:	1101                	addi	sp,sp,-32
    800026da:	ec06                	sd	ra,24(sp)
    800026dc:	e822                	sd	s0,16(sp)
    800026de:	e426                	sd	s1,8(sp)
    800026e0:	1000                	addi	s0,sp,32
    800026e2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026e4:	00010517          	auipc	a0,0x10
    800026e8:	9b450513          	addi	a0,a0,-1612 # 80012098 <bcache>
    800026ec:	00004097          	auipc	ra,0x4
    800026f0:	d1a080e7          	jalr	-742(ra) # 80006406 <acquire>
  b->refcnt++;
    800026f4:	40bc                	lw	a5,64(s1)
    800026f6:	2785                	addiw	a5,a5,1
    800026f8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026fa:	00010517          	auipc	a0,0x10
    800026fe:	99e50513          	addi	a0,a0,-1634 # 80012098 <bcache>
    80002702:	00004097          	auipc	ra,0x4
    80002706:	db8080e7          	jalr	-584(ra) # 800064ba <release>
}
    8000270a:	60e2                	ld	ra,24(sp)
    8000270c:	6442                	ld	s0,16(sp)
    8000270e:	64a2                	ld	s1,8(sp)
    80002710:	6105                	addi	sp,sp,32
    80002712:	8082                	ret

0000000080002714 <bunpin>:

void
bunpin(struct buf *b) {
    80002714:	1101                	addi	sp,sp,-32
    80002716:	ec06                	sd	ra,24(sp)
    80002718:	e822                	sd	s0,16(sp)
    8000271a:	e426                	sd	s1,8(sp)
    8000271c:	1000                	addi	s0,sp,32
    8000271e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002720:	00010517          	auipc	a0,0x10
    80002724:	97850513          	addi	a0,a0,-1672 # 80012098 <bcache>
    80002728:	00004097          	auipc	ra,0x4
    8000272c:	cde080e7          	jalr	-802(ra) # 80006406 <acquire>
  b->refcnt--;
    80002730:	40bc                	lw	a5,64(s1)
    80002732:	37fd                	addiw	a5,a5,-1
    80002734:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002736:	00010517          	auipc	a0,0x10
    8000273a:	96250513          	addi	a0,a0,-1694 # 80012098 <bcache>
    8000273e:	00004097          	auipc	ra,0x4
    80002742:	d7c080e7          	jalr	-644(ra) # 800064ba <release>
}
    80002746:	60e2                	ld	ra,24(sp)
    80002748:	6442                	ld	s0,16(sp)
    8000274a:	64a2                	ld	s1,8(sp)
    8000274c:	6105                	addi	sp,sp,32
    8000274e:	8082                	ret

0000000080002750 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002750:	1101                	addi	sp,sp,-32
    80002752:	ec06                	sd	ra,24(sp)
    80002754:	e822                	sd	s0,16(sp)
    80002756:	e426                	sd	s1,8(sp)
    80002758:	e04a                	sd	s2,0(sp)
    8000275a:	1000                	addi	s0,sp,32
    8000275c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000275e:	00d5d59b          	srliw	a1,a1,0xd
    80002762:	00018797          	auipc	a5,0x18
    80002766:	0127a783          	lw	a5,18(a5) # 8001a774 <sb+0x1c>
    8000276a:	9dbd                	addw	a1,a1,a5
    8000276c:	00000097          	auipc	ra,0x0
    80002770:	da0080e7          	jalr	-608(ra) # 8000250c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002774:	0074f713          	andi	a4,s1,7
    80002778:	4785                	li	a5,1
    8000277a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000277e:	14ce                	slli	s1,s1,0x33
    80002780:	90d9                	srli	s1,s1,0x36
    80002782:	00950733          	add	a4,a0,s1
    80002786:	05874703          	lbu	a4,88(a4)
    8000278a:	00e7f6b3          	and	a3,a5,a4
    8000278e:	c69d                	beqz	a3,800027bc <bfree+0x6c>
    80002790:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002792:	94aa                	add	s1,s1,a0
    80002794:	fff7c793          	not	a5,a5
    80002798:	8f7d                	and	a4,a4,a5
    8000279a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000279e:	00001097          	auipc	ra,0x1
    800027a2:	112080e7          	jalr	274(ra) # 800038b0 <log_write>
  brelse(bp);
    800027a6:	854a                	mv	a0,s2
    800027a8:	00000097          	auipc	ra,0x0
    800027ac:	e94080e7          	jalr	-364(ra) # 8000263c <brelse>
}
    800027b0:	60e2                	ld	ra,24(sp)
    800027b2:	6442                	ld	s0,16(sp)
    800027b4:	64a2                	ld	s1,8(sp)
    800027b6:	6902                	ld	s2,0(sp)
    800027b8:	6105                	addi	sp,sp,32
    800027ba:	8082                	ret
    panic("freeing free block");
    800027bc:	00006517          	auipc	a0,0x6
    800027c0:	c4450513          	addi	a0,a0,-956 # 80008400 <etext+0x400>
    800027c4:	00003097          	auipc	ra,0x3
    800027c8:	6c8080e7          	jalr	1736(ra) # 80005e8c <panic>

00000000800027cc <balloc>:
{
    800027cc:	711d                	addi	sp,sp,-96
    800027ce:	ec86                	sd	ra,88(sp)
    800027d0:	e8a2                	sd	s0,80(sp)
    800027d2:	e4a6                	sd	s1,72(sp)
    800027d4:	e0ca                	sd	s2,64(sp)
    800027d6:	fc4e                	sd	s3,56(sp)
    800027d8:	f852                	sd	s4,48(sp)
    800027da:	f456                	sd	s5,40(sp)
    800027dc:	f05a                	sd	s6,32(sp)
    800027de:	ec5e                	sd	s7,24(sp)
    800027e0:	e862                	sd	s8,16(sp)
    800027e2:	e466                	sd	s9,8(sp)
    800027e4:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027e6:	00018797          	auipc	a5,0x18
    800027ea:	f767a783          	lw	a5,-138(a5) # 8001a75c <sb+0x4>
    800027ee:	cbc1                	beqz	a5,8000287e <balloc+0xb2>
    800027f0:	8baa                	mv	s7,a0
    800027f2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027f4:	00018b17          	auipc	s6,0x18
    800027f8:	f64b0b13          	addi	s6,s6,-156 # 8001a758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027fc:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800027fe:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002800:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002802:	6c89                	lui	s9,0x2
    80002804:	a831                	j	80002820 <balloc+0x54>
    brelse(bp);
    80002806:	854a                	mv	a0,s2
    80002808:	00000097          	auipc	ra,0x0
    8000280c:	e34080e7          	jalr	-460(ra) # 8000263c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002810:	015c87bb          	addw	a5,s9,s5
    80002814:	00078a9b          	sext.w	s5,a5
    80002818:	004b2703          	lw	a4,4(s6)
    8000281c:	06eaf163          	bgeu	s5,a4,8000287e <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002820:	41fad79b          	sraiw	a5,s5,0x1f
    80002824:	0137d79b          	srliw	a5,a5,0x13
    80002828:	015787bb          	addw	a5,a5,s5
    8000282c:	40d7d79b          	sraiw	a5,a5,0xd
    80002830:	01cb2583          	lw	a1,28(s6)
    80002834:	9dbd                	addw	a1,a1,a5
    80002836:	855e                	mv	a0,s7
    80002838:	00000097          	auipc	ra,0x0
    8000283c:	cd4080e7          	jalr	-812(ra) # 8000250c <bread>
    80002840:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002842:	004b2503          	lw	a0,4(s6)
    80002846:	000a849b          	sext.w	s1,s5
    8000284a:	8762                	mv	a4,s8
    8000284c:	faa4fde3          	bgeu	s1,a0,80002806 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002850:	00777693          	andi	a3,a4,7
    80002854:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002858:	41f7579b          	sraiw	a5,a4,0x1f
    8000285c:	01d7d79b          	srliw	a5,a5,0x1d
    80002860:	9fb9                	addw	a5,a5,a4
    80002862:	4037d79b          	sraiw	a5,a5,0x3
    80002866:	00f90633          	add	a2,s2,a5
    8000286a:	05864603          	lbu	a2,88(a2)
    8000286e:	00c6f5b3          	and	a1,a3,a2
    80002872:	cd91                	beqz	a1,8000288e <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002874:	2705                	addiw	a4,a4,1
    80002876:	2485                	addiw	s1,s1,1
    80002878:	fd471ae3          	bne	a4,s4,8000284c <balloc+0x80>
    8000287c:	b769                	j	80002806 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000287e:	00006517          	auipc	a0,0x6
    80002882:	b9a50513          	addi	a0,a0,-1126 # 80008418 <etext+0x418>
    80002886:	00003097          	auipc	ra,0x3
    8000288a:	606080e7          	jalr	1542(ra) # 80005e8c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000288e:	97ca                	add	a5,a5,s2
    80002890:	8e55                	or	a2,a2,a3
    80002892:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002896:	854a                	mv	a0,s2
    80002898:	00001097          	auipc	ra,0x1
    8000289c:	018080e7          	jalr	24(ra) # 800038b0 <log_write>
        brelse(bp);
    800028a0:	854a                	mv	a0,s2
    800028a2:	00000097          	auipc	ra,0x0
    800028a6:	d9a080e7          	jalr	-614(ra) # 8000263c <brelse>
  bp = bread(dev, bno);
    800028aa:	85a6                	mv	a1,s1
    800028ac:	855e                	mv	a0,s7
    800028ae:	00000097          	auipc	ra,0x0
    800028b2:	c5e080e7          	jalr	-930(ra) # 8000250c <bread>
    800028b6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028b8:	40000613          	li	a2,1024
    800028bc:	4581                	li	a1,0
    800028be:	05850513          	addi	a0,a0,88
    800028c2:	ffffe097          	auipc	ra,0xffffe
    800028c6:	8b8080e7          	jalr	-1864(ra) # 8000017a <memset>
  log_write(bp);
    800028ca:	854a                	mv	a0,s2
    800028cc:	00001097          	auipc	ra,0x1
    800028d0:	fe4080e7          	jalr	-28(ra) # 800038b0 <log_write>
  brelse(bp);
    800028d4:	854a                	mv	a0,s2
    800028d6:	00000097          	auipc	ra,0x0
    800028da:	d66080e7          	jalr	-666(ra) # 8000263c <brelse>
}
    800028de:	8526                	mv	a0,s1
    800028e0:	60e6                	ld	ra,88(sp)
    800028e2:	6446                	ld	s0,80(sp)
    800028e4:	64a6                	ld	s1,72(sp)
    800028e6:	6906                	ld	s2,64(sp)
    800028e8:	79e2                	ld	s3,56(sp)
    800028ea:	7a42                	ld	s4,48(sp)
    800028ec:	7aa2                	ld	s5,40(sp)
    800028ee:	7b02                	ld	s6,32(sp)
    800028f0:	6be2                	ld	s7,24(sp)
    800028f2:	6c42                	ld	s8,16(sp)
    800028f4:	6ca2                	ld	s9,8(sp)
    800028f6:	6125                	addi	sp,sp,96
    800028f8:	8082                	ret

00000000800028fa <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800028fa:	7179                	addi	sp,sp,-48
    800028fc:	f406                	sd	ra,40(sp)
    800028fe:	f022                	sd	s0,32(sp)
    80002900:	ec26                	sd	s1,24(sp)
    80002902:	e84a                	sd	s2,16(sp)
    80002904:	e44e                	sd	s3,8(sp)
    80002906:	1800                	addi	s0,sp,48
    80002908:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000290a:	47ad                	li	a5,11
    8000290c:	04b7ff63          	bgeu	a5,a1,8000296a <bmap+0x70>
    80002910:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002912:	ff45849b          	addiw	s1,a1,-12
    80002916:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000291a:	0ff00793          	li	a5,255
    8000291e:	0ae7e463          	bltu	a5,a4,800029c6 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002922:	08052583          	lw	a1,128(a0)
    80002926:	c5b5                	beqz	a1,80002992 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002928:	00092503          	lw	a0,0(s2)
    8000292c:	00000097          	auipc	ra,0x0
    80002930:	be0080e7          	jalr	-1056(ra) # 8000250c <bread>
    80002934:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002936:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000293a:	02049713          	slli	a4,s1,0x20
    8000293e:	01e75593          	srli	a1,a4,0x1e
    80002942:	00b784b3          	add	s1,a5,a1
    80002946:	0004a983          	lw	s3,0(s1)
    8000294a:	04098e63          	beqz	s3,800029a6 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000294e:	8552                	mv	a0,s4
    80002950:	00000097          	auipc	ra,0x0
    80002954:	cec080e7          	jalr	-788(ra) # 8000263c <brelse>
    return addr;
    80002958:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000295a:	854e                	mv	a0,s3
    8000295c:	70a2                	ld	ra,40(sp)
    8000295e:	7402                	ld	s0,32(sp)
    80002960:	64e2                	ld	s1,24(sp)
    80002962:	6942                	ld	s2,16(sp)
    80002964:	69a2                	ld	s3,8(sp)
    80002966:	6145                	addi	sp,sp,48
    80002968:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000296a:	02059793          	slli	a5,a1,0x20
    8000296e:	01e7d593          	srli	a1,a5,0x1e
    80002972:	00b504b3          	add	s1,a0,a1
    80002976:	0504a983          	lw	s3,80(s1)
    8000297a:	fe0990e3          	bnez	s3,8000295a <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000297e:	4108                	lw	a0,0(a0)
    80002980:	00000097          	auipc	ra,0x0
    80002984:	e4c080e7          	jalr	-436(ra) # 800027cc <balloc>
    80002988:	0005099b          	sext.w	s3,a0
    8000298c:	0534a823          	sw	s3,80(s1)
    80002990:	b7e9                	j	8000295a <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002992:	4108                	lw	a0,0(a0)
    80002994:	00000097          	auipc	ra,0x0
    80002998:	e38080e7          	jalr	-456(ra) # 800027cc <balloc>
    8000299c:	0005059b          	sext.w	a1,a0
    800029a0:	08b92023          	sw	a1,128(s2)
    800029a4:	b751                	j	80002928 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800029a6:	00092503          	lw	a0,0(s2)
    800029aa:	00000097          	auipc	ra,0x0
    800029ae:	e22080e7          	jalr	-478(ra) # 800027cc <balloc>
    800029b2:	0005099b          	sext.w	s3,a0
    800029b6:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800029ba:	8552                	mv	a0,s4
    800029bc:	00001097          	auipc	ra,0x1
    800029c0:	ef4080e7          	jalr	-268(ra) # 800038b0 <log_write>
    800029c4:	b769                	j	8000294e <bmap+0x54>
  panic("bmap: out of range");
    800029c6:	00006517          	auipc	a0,0x6
    800029ca:	a6a50513          	addi	a0,a0,-1430 # 80008430 <etext+0x430>
    800029ce:	00003097          	auipc	ra,0x3
    800029d2:	4be080e7          	jalr	1214(ra) # 80005e8c <panic>

00000000800029d6 <iget>:
{
    800029d6:	7179                	addi	sp,sp,-48
    800029d8:	f406                	sd	ra,40(sp)
    800029da:	f022                	sd	s0,32(sp)
    800029dc:	ec26                	sd	s1,24(sp)
    800029de:	e84a                	sd	s2,16(sp)
    800029e0:	e44e                	sd	s3,8(sp)
    800029e2:	e052                	sd	s4,0(sp)
    800029e4:	1800                	addi	s0,sp,48
    800029e6:	89aa                	mv	s3,a0
    800029e8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029ea:	00018517          	auipc	a0,0x18
    800029ee:	d8e50513          	addi	a0,a0,-626 # 8001a778 <itable>
    800029f2:	00004097          	auipc	ra,0x4
    800029f6:	a14080e7          	jalr	-1516(ra) # 80006406 <acquire>
  empty = 0;
    800029fa:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029fc:	00018497          	auipc	s1,0x18
    80002a00:	d9448493          	addi	s1,s1,-620 # 8001a790 <itable+0x18>
    80002a04:	0001a697          	auipc	a3,0x1a
    80002a08:	81c68693          	addi	a3,a3,-2020 # 8001c220 <log>
    80002a0c:	a039                	j	80002a1a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a0e:	02090b63          	beqz	s2,80002a44 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a12:	08848493          	addi	s1,s1,136
    80002a16:	02d48a63          	beq	s1,a3,80002a4a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a1a:	449c                	lw	a5,8(s1)
    80002a1c:	fef059e3          	blez	a5,80002a0e <iget+0x38>
    80002a20:	4098                	lw	a4,0(s1)
    80002a22:	ff3716e3          	bne	a4,s3,80002a0e <iget+0x38>
    80002a26:	40d8                	lw	a4,4(s1)
    80002a28:	ff4713e3          	bne	a4,s4,80002a0e <iget+0x38>
      ip->ref++;
    80002a2c:	2785                	addiw	a5,a5,1
    80002a2e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a30:	00018517          	auipc	a0,0x18
    80002a34:	d4850513          	addi	a0,a0,-696 # 8001a778 <itable>
    80002a38:	00004097          	auipc	ra,0x4
    80002a3c:	a82080e7          	jalr	-1406(ra) # 800064ba <release>
      return ip;
    80002a40:	8926                	mv	s2,s1
    80002a42:	a03d                	j	80002a70 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a44:	f7f9                	bnez	a5,80002a12 <iget+0x3c>
      empty = ip;
    80002a46:	8926                	mv	s2,s1
    80002a48:	b7e9                	j	80002a12 <iget+0x3c>
  if(empty == 0)
    80002a4a:	02090c63          	beqz	s2,80002a82 <iget+0xac>
  ip->dev = dev;
    80002a4e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a52:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a56:	4785                	li	a5,1
    80002a58:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a5c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a60:	00018517          	auipc	a0,0x18
    80002a64:	d1850513          	addi	a0,a0,-744 # 8001a778 <itable>
    80002a68:	00004097          	auipc	ra,0x4
    80002a6c:	a52080e7          	jalr	-1454(ra) # 800064ba <release>
}
    80002a70:	854a                	mv	a0,s2
    80002a72:	70a2                	ld	ra,40(sp)
    80002a74:	7402                	ld	s0,32(sp)
    80002a76:	64e2                	ld	s1,24(sp)
    80002a78:	6942                	ld	s2,16(sp)
    80002a7a:	69a2                	ld	s3,8(sp)
    80002a7c:	6a02                	ld	s4,0(sp)
    80002a7e:	6145                	addi	sp,sp,48
    80002a80:	8082                	ret
    panic("iget: no inodes");
    80002a82:	00006517          	auipc	a0,0x6
    80002a86:	9c650513          	addi	a0,a0,-1594 # 80008448 <etext+0x448>
    80002a8a:	00003097          	auipc	ra,0x3
    80002a8e:	402080e7          	jalr	1026(ra) # 80005e8c <panic>

0000000080002a92 <fsinit>:
fsinit(int dev) {
    80002a92:	7179                	addi	sp,sp,-48
    80002a94:	f406                	sd	ra,40(sp)
    80002a96:	f022                	sd	s0,32(sp)
    80002a98:	ec26                	sd	s1,24(sp)
    80002a9a:	e84a                	sd	s2,16(sp)
    80002a9c:	e44e                	sd	s3,8(sp)
    80002a9e:	1800                	addi	s0,sp,48
    80002aa0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002aa2:	4585                	li	a1,1
    80002aa4:	00000097          	auipc	ra,0x0
    80002aa8:	a68080e7          	jalr	-1432(ra) # 8000250c <bread>
    80002aac:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002aae:	00018997          	auipc	s3,0x18
    80002ab2:	caa98993          	addi	s3,s3,-854 # 8001a758 <sb>
    80002ab6:	02000613          	li	a2,32
    80002aba:	05850593          	addi	a1,a0,88
    80002abe:	854e                	mv	a0,s3
    80002ac0:	ffffd097          	auipc	ra,0xffffd
    80002ac4:	716080e7          	jalr	1814(ra) # 800001d6 <memmove>
  brelse(bp);
    80002ac8:	8526                	mv	a0,s1
    80002aca:	00000097          	auipc	ra,0x0
    80002ace:	b72080e7          	jalr	-1166(ra) # 8000263c <brelse>
  if(sb.magic != FSMAGIC)
    80002ad2:	0009a703          	lw	a4,0(s3)
    80002ad6:	102037b7          	lui	a5,0x10203
    80002ada:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002ade:	02f71263          	bne	a4,a5,80002b02 <fsinit+0x70>
  initlog(dev, &sb);
    80002ae2:	00018597          	auipc	a1,0x18
    80002ae6:	c7658593          	addi	a1,a1,-906 # 8001a758 <sb>
    80002aea:	854a                	mv	a0,s2
    80002aec:	00001097          	auipc	ra,0x1
    80002af0:	b54080e7          	jalr	-1196(ra) # 80003640 <initlog>
}
    80002af4:	70a2                	ld	ra,40(sp)
    80002af6:	7402                	ld	s0,32(sp)
    80002af8:	64e2                	ld	s1,24(sp)
    80002afa:	6942                	ld	s2,16(sp)
    80002afc:	69a2                	ld	s3,8(sp)
    80002afe:	6145                	addi	sp,sp,48
    80002b00:	8082                	ret
    panic("invalid file system");
    80002b02:	00006517          	auipc	a0,0x6
    80002b06:	95650513          	addi	a0,a0,-1706 # 80008458 <etext+0x458>
    80002b0a:	00003097          	auipc	ra,0x3
    80002b0e:	382080e7          	jalr	898(ra) # 80005e8c <panic>

0000000080002b12 <iinit>:
{
    80002b12:	7179                	addi	sp,sp,-48
    80002b14:	f406                	sd	ra,40(sp)
    80002b16:	f022                	sd	s0,32(sp)
    80002b18:	ec26                	sd	s1,24(sp)
    80002b1a:	e84a                	sd	s2,16(sp)
    80002b1c:	e44e                	sd	s3,8(sp)
    80002b1e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b20:	00006597          	auipc	a1,0x6
    80002b24:	95058593          	addi	a1,a1,-1712 # 80008470 <etext+0x470>
    80002b28:	00018517          	auipc	a0,0x18
    80002b2c:	c5050513          	addi	a0,a0,-944 # 8001a778 <itable>
    80002b30:	00004097          	auipc	ra,0x4
    80002b34:	846080e7          	jalr	-1978(ra) # 80006376 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b38:	00018497          	auipc	s1,0x18
    80002b3c:	c6848493          	addi	s1,s1,-920 # 8001a7a0 <itable+0x28>
    80002b40:	00019997          	auipc	s3,0x19
    80002b44:	6f098993          	addi	s3,s3,1776 # 8001c230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b48:	00006917          	auipc	s2,0x6
    80002b4c:	93090913          	addi	s2,s2,-1744 # 80008478 <etext+0x478>
    80002b50:	85ca                	mv	a1,s2
    80002b52:	8526                	mv	a0,s1
    80002b54:	00001097          	auipc	ra,0x1
    80002b58:	e40080e7          	jalr	-448(ra) # 80003994 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b5c:	08848493          	addi	s1,s1,136
    80002b60:	ff3498e3          	bne	s1,s3,80002b50 <iinit+0x3e>
}
    80002b64:	70a2                	ld	ra,40(sp)
    80002b66:	7402                	ld	s0,32(sp)
    80002b68:	64e2                	ld	s1,24(sp)
    80002b6a:	6942                	ld	s2,16(sp)
    80002b6c:	69a2                	ld	s3,8(sp)
    80002b6e:	6145                	addi	sp,sp,48
    80002b70:	8082                	ret

0000000080002b72 <ialloc>:
{
    80002b72:	7139                	addi	sp,sp,-64
    80002b74:	fc06                	sd	ra,56(sp)
    80002b76:	f822                	sd	s0,48(sp)
    80002b78:	f426                	sd	s1,40(sp)
    80002b7a:	f04a                	sd	s2,32(sp)
    80002b7c:	ec4e                	sd	s3,24(sp)
    80002b7e:	e852                	sd	s4,16(sp)
    80002b80:	e456                	sd	s5,8(sp)
    80002b82:	e05a                	sd	s6,0(sp)
    80002b84:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b86:	00018717          	auipc	a4,0x18
    80002b8a:	bde72703          	lw	a4,-1058(a4) # 8001a764 <sb+0xc>
    80002b8e:	4785                	li	a5,1
    80002b90:	04e7f863          	bgeu	a5,a4,80002be0 <ialloc+0x6e>
    80002b94:	8aaa                	mv	s5,a0
    80002b96:	8b2e                	mv	s6,a1
    80002b98:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b9a:	00018a17          	auipc	s4,0x18
    80002b9e:	bbea0a13          	addi	s4,s4,-1090 # 8001a758 <sb>
    80002ba2:	00495593          	srli	a1,s2,0x4
    80002ba6:	018a2783          	lw	a5,24(s4)
    80002baa:	9dbd                	addw	a1,a1,a5
    80002bac:	8556                	mv	a0,s5
    80002bae:	00000097          	auipc	ra,0x0
    80002bb2:	95e080e7          	jalr	-1698(ra) # 8000250c <bread>
    80002bb6:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002bb8:	05850993          	addi	s3,a0,88
    80002bbc:	00f97793          	andi	a5,s2,15
    80002bc0:	079a                	slli	a5,a5,0x6
    80002bc2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bc4:	00099783          	lh	a5,0(s3)
    80002bc8:	c785                	beqz	a5,80002bf0 <ialloc+0x7e>
    brelse(bp);
    80002bca:	00000097          	auipc	ra,0x0
    80002bce:	a72080e7          	jalr	-1422(ra) # 8000263c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bd2:	0905                	addi	s2,s2,1
    80002bd4:	00ca2703          	lw	a4,12(s4)
    80002bd8:	0009079b          	sext.w	a5,s2
    80002bdc:	fce7e3e3          	bltu	a5,a4,80002ba2 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002be0:	00006517          	auipc	a0,0x6
    80002be4:	8a050513          	addi	a0,a0,-1888 # 80008480 <etext+0x480>
    80002be8:	00003097          	auipc	ra,0x3
    80002bec:	2a4080e7          	jalr	676(ra) # 80005e8c <panic>
      memset(dip, 0, sizeof(*dip));
    80002bf0:	04000613          	li	a2,64
    80002bf4:	4581                	li	a1,0
    80002bf6:	854e                	mv	a0,s3
    80002bf8:	ffffd097          	auipc	ra,0xffffd
    80002bfc:	582080e7          	jalr	1410(ra) # 8000017a <memset>
      dip->type = type;
    80002c00:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c04:	8526                	mv	a0,s1
    80002c06:	00001097          	auipc	ra,0x1
    80002c0a:	caa080e7          	jalr	-854(ra) # 800038b0 <log_write>
      brelse(bp);
    80002c0e:	8526                	mv	a0,s1
    80002c10:	00000097          	auipc	ra,0x0
    80002c14:	a2c080e7          	jalr	-1492(ra) # 8000263c <brelse>
      return iget(dev, inum);
    80002c18:	0009059b          	sext.w	a1,s2
    80002c1c:	8556                	mv	a0,s5
    80002c1e:	00000097          	auipc	ra,0x0
    80002c22:	db8080e7          	jalr	-584(ra) # 800029d6 <iget>
}
    80002c26:	70e2                	ld	ra,56(sp)
    80002c28:	7442                	ld	s0,48(sp)
    80002c2a:	74a2                	ld	s1,40(sp)
    80002c2c:	7902                	ld	s2,32(sp)
    80002c2e:	69e2                	ld	s3,24(sp)
    80002c30:	6a42                	ld	s4,16(sp)
    80002c32:	6aa2                	ld	s5,8(sp)
    80002c34:	6b02                	ld	s6,0(sp)
    80002c36:	6121                	addi	sp,sp,64
    80002c38:	8082                	ret

0000000080002c3a <iupdate>:
{
    80002c3a:	1101                	addi	sp,sp,-32
    80002c3c:	ec06                	sd	ra,24(sp)
    80002c3e:	e822                	sd	s0,16(sp)
    80002c40:	e426                	sd	s1,8(sp)
    80002c42:	e04a                	sd	s2,0(sp)
    80002c44:	1000                	addi	s0,sp,32
    80002c46:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c48:	415c                	lw	a5,4(a0)
    80002c4a:	0047d79b          	srliw	a5,a5,0x4
    80002c4e:	00018597          	auipc	a1,0x18
    80002c52:	b225a583          	lw	a1,-1246(a1) # 8001a770 <sb+0x18>
    80002c56:	9dbd                	addw	a1,a1,a5
    80002c58:	4108                	lw	a0,0(a0)
    80002c5a:	00000097          	auipc	ra,0x0
    80002c5e:	8b2080e7          	jalr	-1870(ra) # 8000250c <bread>
    80002c62:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c64:	05850793          	addi	a5,a0,88
    80002c68:	40d8                	lw	a4,4(s1)
    80002c6a:	8b3d                	andi	a4,a4,15
    80002c6c:	071a                	slli	a4,a4,0x6
    80002c6e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c70:	04449703          	lh	a4,68(s1)
    80002c74:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c78:	04649703          	lh	a4,70(s1)
    80002c7c:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002c80:	04849703          	lh	a4,72(s1)
    80002c84:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c88:	04a49703          	lh	a4,74(s1)
    80002c8c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c90:	44f8                	lw	a4,76(s1)
    80002c92:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c94:	03400613          	li	a2,52
    80002c98:	05048593          	addi	a1,s1,80
    80002c9c:	00c78513          	addi	a0,a5,12
    80002ca0:	ffffd097          	auipc	ra,0xffffd
    80002ca4:	536080e7          	jalr	1334(ra) # 800001d6 <memmove>
  log_write(bp);
    80002ca8:	854a                	mv	a0,s2
    80002caa:	00001097          	auipc	ra,0x1
    80002cae:	c06080e7          	jalr	-1018(ra) # 800038b0 <log_write>
  brelse(bp);
    80002cb2:	854a                	mv	a0,s2
    80002cb4:	00000097          	auipc	ra,0x0
    80002cb8:	988080e7          	jalr	-1656(ra) # 8000263c <brelse>
}
    80002cbc:	60e2                	ld	ra,24(sp)
    80002cbe:	6442                	ld	s0,16(sp)
    80002cc0:	64a2                	ld	s1,8(sp)
    80002cc2:	6902                	ld	s2,0(sp)
    80002cc4:	6105                	addi	sp,sp,32
    80002cc6:	8082                	ret

0000000080002cc8 <idup>:
{
    80002cc8:	1101                	addi	sp,sp,-32
    80002cca:	ec06                	sd	ra,24(sp)
    80002ccc:	e822                	sd	s0,16(sp)
    80002cce:	e426                	sd	s1,8(sp)
    80002cd0:	1000                	addi	s0,sp,32
    80002cd2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cd4:	00018517          	auipc	a0,0x18
    80002cd8:	aa450513          	addi	a0,a0,-1372 # 8001a778 <itable>
    80002cdc:	00003097          	auipc	ra,0x3
    80002ce0:	72a080e7          	jalr	1834(ra) # 80006406 <acquire>
  ip->ref++;
    80002ce4:	449c                	lw	a5,8(s1)
    80002ce6:	2785                	addiw	a5,a5,1
    80002ce8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cea:	00018517          	auipc	a0,0x18
    80002cee:	a8e50513          	addi	a0,a0,-1394 # 8001a778 <itable>
    80002cf2:	00003097          	auipc	ra,0x3
    80002cf6:	7c8080e7          	jalr	1992(ra) # 800064ba <release>
}
    80002cfa:	8526                	mv	a0,s1
    80002cfc:	60e2                	ld	ra,24(sp)
    80002cfe:	6442                	ld	s0,16(sp)
    80002d00:	64a2                	ld	s1,8(sp)
    80002d02:	6105                	addi	sp,sp,32
    80002d04:	8082                	ret

0000000080002d06 <ilock>:
{
    80002d06:	1101                	addi	sp,sp,-32
    80002d08:	ec06                	sd	ra,24(sp)
    80002d0a:	e822                	sd	s0,16(sp)
    80002d0c:	e426                	sd	s1,8(sp)
    80002d0e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d10:	c10d                	beqz	a0,80002d32 <ilock+0x2c>
    80002d12:	84aa                	mv	s1,a0
    80002d14:	451c                	lw	a5,8(a0)
    80002d16:	00f05e63          	blez	a5,80002d32 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002d1a:	0541                	addi	a0,a0,16
    80002d1c:	00001097          	auipc	ra,0x1
    80002d20:	cb2080e7          	jalr	-846(ra) # 800039ce <acquiresleep>
  if(ip->valid == 0){
    80002d24:	40bc                	lw	a5,64(s1)
    80002d26:	cf99                	beqz	a5,80002d44 <ilock+0x3e>
}
    80002d28:	60e2                	ld	ra,24(sp)
    80002d2a:	6442                	ld	s0,16(sp)
    80002d2c:	64a2                	ld	s1,8(sp)
    80002d2e:	6105                	addi	sp,sp,32
    80002d30:	8082                	ret
    80002d32:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002d34:	00005517          	auipc	a0,0x5
    80002d38:	76450513          	addi	a0,a0,1892 # 80008498 <etext+0x498>
    80002d3c:	00003097          	auipc	ra,0x3
    80002d40:	150080e7          	jalr	336(ra) # 80005e8c <panic>
    80002d44:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d46:	40dc                	lw	a5,4(s1)
    80002d48:	0047d79b          	srliw	a5,a5,0x4
    80002d4c:	00018597          	auipc	a1,0x18
    80002d50:	a245a583          	lw	a1,-1500(a1) # 8001a770 <sb+0x18>
    80002d54:	9dbd                	addw	a1,a1,a5
    80002d56:	4088                	lw	a0,0(s1)
    80002d58:	fffff097          	auipc	ra,0xfffff
    80002d5c:	7b4080e7          	jalr	1972(ra) # 8000250c <bread>
    80002d60:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d62:	05850593          	addi	a1,a0,88
    80002d66:	40dc                	lw	a5,4(s1)
    80002d68:	8bbd                	andi	a5,a5,15
    80002d6a:	079a                	slli	a5,a5,0x6
    80002d6c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d6e:	00059783          	lh	a5,0(a1)
    80002d72:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d76:	00259783          	lh	a5,2(a1)
    80002d7a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d7e:	00459783          	lh	a5,4(a1)
    80002d82:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d86:	00659783          	lh	a5,6(a1)
    80002d8a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d8e:	459c                	lw	a5,8(a1)
    80002d90:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d92:	03400613          	li	a2,52
    80002d96:	05b1                	addi	a1,a1,12
    80002d98:	05048513          	addi	a0,s1,80
    80002d9c:	ffffd097          	auipc	ra,0xffffd
    80002da0:	43a080e7          	jalr	1082(ra) # 800001d6 <memmove>
    brelse(bp);
    80002da4:	854a                	mv	a0,s2
    80002da6:	00000097          	auipc	ra,0x0
    80002daa:	896080e7          	jalr	-1898(ra) # 8000263c <brelse>
    ip->valid = 1;
    80002dae:	4785                	li	a5,1
    80002db0:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002db2:	04449783          	lh	a5,68(s1)
    80002db6:	c399                	beqz	a5,80002dbc <ilock+0xb6>
    80002db8:	6902                	ld	s2,0(sp)
    80002dba:	b7bd                	j	80002d28 <ilock+0x22>
      panic("ilock: no type");
    80002dbc:	00005517          	auipc	a0,0x5
    80002dc0:	6e450513          	addi	a0,a0,1764 # 800084a0 <etext+0x4a0>
    80002dc4:	00003097          	auipc	ra,0x3
    80002dc8:	0c8080e7          	jalr	200(ra) # 80005e8c <panic>

0000000080002dcc <iunlock>:
{
    80002dcc:	1101                	addi	sp,sp,-32
    80002dce:	ec06                	sd	ra,24(sp)
    80002dd0:	e822                	sd	s0,16(sp)
    80002dd2:	e426                	sd	s1,8(sp)
    80002dd4:	e04a                	sd	s2,0(sp)
    80002dd6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002dd8:	c905                	beqz	a0,80002e08 <iunlock+0x3c>
    80002dda:	84aa                	mv	s1,a0
    80002ddc:	01050913          	addi	s2,a0,16
    80002de0:	854a                	mv	a0,s2
    80002de2:	00001097          	auipc	ra,0x1
    80002de6:	c86080e7          	jalr	-890(ra) # 80003a68 <holdingsleep>
    80002dea:	cd19                	beqz	a0,80002e08 <iunlock+0x3c>
    80002dec:	449c                	lw	a5,8(s1)
    80002dee:	00f05d63          	blez	a5,80002e08 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002df2:	854a                	mv	a0,s2
    80002df4:	00001097          	auipc	ra,0x1
    80002df8:	c30080e7          	jalr	-976(ra) # 80003a24 <releasesleep>
}
    80002dfc:	60e2                	ld	ra,24(sp)
    80002dfe:	6442                	ld	s0,16(sp)
    80002e00:	64a2                	ld	s1,8(sp)
    80002e02:	6902                	ld	s2,0(sp)
    80002e04:	6105                	addi	sp,sp,32
    80002e06:	8082                	ret
    panic("iunlock");
    80002e08:	00005517          	auipc	a0,0x5
    80002e0c:	6a850513          	addi	a0,a0,1704 # 800084b0 <etext+0x4b0>
    80002e10:	00003097          	auipc	ra,0x3
    80002e14:	07c080e7          	jalr	124(ra) # 80005e8c <panic>

0000000080002e18 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e18:	7179                	addi	sp,sp,-48
    80002e1a:	f406                	sd	ra,40(sp)
    80002e1c:	f022                	sd	s0,32(sp)
    80002e1e:	ec26                	sd	s1,24(sp)
    80002e20:	e84a                	sd	s2,16(sp)
    80002e22:	e44e                	sd	s3,8(sp)
    80002e24:	1800                	addi	s0,sp,48
    80002e26:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e28:	05050493          	addi	s1,a0,80
    80002e2c:	08050913          	addi	s2,a0,128
    80002e30:	a021                	j	80002e38 <itrunc+0x20>
    80002e32:	0491                	addi	s1,s1,4
    80002e34:	01248d63          	beq	s1,s2,80002e4e <itrunc+0x36>
    if(ip->addrs[i]){
    80002e38:	408c                	lw	a1,0(s1)
    80002e3a:	dde5                	beqz	a1,80002e32 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002e3c:	0009a503          	lw	a0,0(s3)
    80002e40:	00000097          	auipc	ra,0x0
    80002e44:	910080e7          	jalr	-1776(ra) # 80002750 <bfree>
      ip->addrs[i] = 0;
    80002e48:	0004a023          	sw	zero,0(s1)
    80002e4c:	b7dd                	j	80002e32 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e4e:	0809a583          	lw	a1,128(s3)
    80002e52:	ed99                	bnez	a1,80002e70 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e54:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e58:	854e                	mv	a0,s3
    80002e5a:	00000097          	auipc	ra,0x0
    80002e5e:	de0080e7          	jalr	-544(ra) # 80002c3a <iupdate>
}
    80002e62:	70a2                	ld	ra,40(sp)
    80002e64:	7402                	ld	s0,32(sp)
    80002e66:	64e2                	ld	s1,24(sp)
    80002e68:	6942                	ld	s2,16(sp)
    80002e6a:	69a2                	ld	s3,8(sp)
    80002e6c:	6145                	addi	sp,sp,48
    80002e6e:	8082                	ret
    80002e70:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e72:	0009a503          	lw	a0,0(s3)
    80002e76:	fffff097          	auipc	ra,0xfffff
    80002e7a:	696080e7          	jalr	1686(ra) # 8000250c <bread>
    80002e7e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e80:	05850493          	addi	s1,a0,88
    80002e84:	45850913          	addi	s2,a0,1112
    80002e88:	a021                	j	80002e90 <itrunc+0x78>
    80002e8a:	0491                	addi	s1,s1,4
    80002e8c:	01248b63          	beq	s1,s2,80002ea2 <itrunc+0x8a>
      if(a[j])
    80002e90:	408c                	lw	a1,0(s1)
    80002e92:	dde5                	beqz	a1,80002e8a <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002e94:	0009a503          	lw	a0,0(s3)
    80002e98:	00000097          	auipc	ra,0x0
    80002e9c:	8b8080e7          	jalr	-1864(ra) # 80002750 <bfree>
    80002ea0:	b7ed                	j	80002e8a <itrunc+0x72>
    brelse(bp);
    80002ea2:	8552                	mv	a0,s4
    80002ea4:	fffff097          	auipc	ra,0xfffff
    80002ea8:	798080e7          	jalr	1944(ra) # 8000263c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002eac:	0809a583          	lw	a1,128(s3)
    80002eb0:	0009a503          	lw	a0,0(s3)
    80002eb4:	00000097          	auipc	ra,0x0
    80002eb8:	89c080e7          	jalr	-1892(ra) # 80002750 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ebc:	0809a023          	sw	zero,128(s3)
    80002ec0:	6a02                	ld	s4,0(sp)
    80002ec2:	bf49                	j	80002e54 <itrunc+0x3c>

0000000080002ec4 <iput>:
{
    80002ec4:	1101                	addi	sp,sp,-32
    80002ec6:	ec06                	sd	ra,24(sp)
    80002ec8:	e822                	sd	s0,16(sp)
    80002eca:	e426                	sd	s1,8(sp)
    80002ecc:	1000                	addi	s0,sp,32
    80002ece:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ed0:	00018517          	auipc	a0,0x18
    80002ed4:	8a850513          	addi	a0,a0,-1880 # 8001a778 <itable>
    80002ed8:	00003097          	auipc	ra,0x3
    80002edc:	52e080e7          	jalr	1326(ra) # 80006406 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ee0:	4498                	lw	a4,8(s1)
    80002ee2:	4785                	li	a5,1
    80002ee4:	02f70263          	beq	a4,a5,80002f08 <iput+0x44>
  ip->ref--;
    80002ee8:	449c                	lw	a5,8(s1)
    80002eea:	37fd                	addiw	a5,a5,-1
    80002eec:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002eee:	00018517          	auipc	a0,0x18
    80002ef2:	88a50513          	addi	a0,a0,-1910 # 8001a778 <itable>
    80002ef6:	00003097          	auipc	ra,0x3
    80002efa:	5c4080e7          	jalr	1476(ra) # 800064ba <release>
}
    80002efe:	60e2                	ld	ra,24(sp)
    80002f00:	6442                	ld	s0,16(sp)
    80002f02:	64a2                	ld	s1,8(sp)
    80002f04:	6105                	addi	sp,sp,32
    80002f06:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f08:	40bc                	lw	a5,64(s1)
    80002f0a:	dff9                	beqz	a5,80002ee8 <iput+0x24>
    80002f0c:	04a49783          	lh	a5,74(s1)
    80002f10:	ffe1                	bnez	a5,80002ee8 <iput+0x24>
    80002f12:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002f14:	01048913          	addi	s2,s1,16
    80002f18:	854a                	mv	a0,s2
    80002f1a:	00001097          	auipc	ra,0x1
    80002f1e:	ab4080e7          	jalr	-1356(ra) # 800039ce <acquiresleep>
    release(&itable.lock);
    80002f22:	00018517          	auipc	a0,0x18
    80002f26:	85650513          	addi	a0,a0,-1962 # 8001a778 <itable>
    80002f2a:	00003097          	auipc	ra,0x3
    80002f2e:	590080e7          	jalr	1424(ra) # 800064ba <release>
    itrunc(ip);
    80002f32:	8526                	mv	a0,s1
    80002f34:	00000097          	auipc	ra,0x0
    80002f38:	ee4080e7          	jalr	-284(ra) # 80002e18 <itrunc>
    ip->type = 0;
    80002f3c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f40:	8526                	mv	a0,s1
    80002f42:	00000097          	auipc	ra,0x0
    80002f46:	cf8080e7          	jalr	-776(ra) # 80002c3a <iupdate>
    ip->valid = 0;
    80002f4a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f4e:	854a                	mv	a0,s2
    80002f50:	00001097          	auipc	ra,0x1
    80002f54:	ad4080e7          	jalr	-1324(ra) # 80003a24 <releasesleep>
    acquire(&itable.lock);
    80002f58:	00018517          	auipc	a0,0x18
    80002f5c:	82050513          	addi	a0,a0,-2016 # 8001a778 <itable>
    80002f60:	00003097          	auipc	ra,0x3
    80002f64:	4a6080e7          	jalr	1190(ra) # 80006406 <acquire>
    80002f68:	6902                	ld	s2,0(sp)
    80002f6a:	bfbd                	j	80002ee8 <iput+0x24>

0000000080002f6c <iunlockput>:
{
    80002f6c:	1101                	addi	sp,sp,-32
    80002f6e:	ec06                	sd	ra,24(sp)
    80002f70:	e822                	sd	s0,16(sp)
    80002f72:	e426                	sd	s1,8(sp)
    80002f74:	1000                	addi	s0,sp,32
    80002f76:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f78:	00000097          	auipc	ra,0x0
    80002f7c:	e54080e7          	jalr	-428(ra) # 80002dcc <iunlock>
  iput(ip);
    80002f80:	8526                	mv	a0,s1
    80002f82:	00000097          	auipc	ra,0x0
    80002f86:	f42080e7          	jalr	-190(ra) # 80002ec4 <iput>
}
    80002f8a:	60e2                	ld	ra,24(sp)
    80002f8c:	6442                	ld	s0,16(sp)
    80002f8e:	64a2                	ld	s1,8(sp)
    80002f90:	6105                	addi	sp,sp,32
    80002f92:	8082                	ret

0000000080002f94 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f94:	1141                	addi	sp,sp,-16
    80002f96:	e422                	sd	s0,8(sp)
    80002f98:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f9a:	411c                	lw	a5,0(a0)
    80002f9c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f9e:	415c                	lw	a5,4(a0)
    80002fa0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002fa2:	04451783          	lh	a5,68(a0)
    80002fa6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002faa:	04a51783          	lh	a5,74(a0)
    80002fae:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fb2:	04c56783          	lwu	a5,76(a0)
    80002fb6:	e99c                	sd	a5,16(a1)
}
    80002fb8:	6422                	ld	s0,8(sp)
    80002fba:	0141                	addi	sp,sp,16
    80002fbc:	8082                	ret

0000000080002fbe <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fbe:	457c                	lw	a5,76(a0)
    80002fc0:	0ed7ef63          	bltu	a5,a3,800030be <readi+0x100>
{
    80002fc4:	7159                	addi	sp,sp,-112
    80002fc6:	f486                	sd	ra,104(sp)
    80002fc8:	f0a2                	sd	s0,96(sp)
    80002fca:	eca6                	sd	s1,88(sp)
    80002fcc:	fc56                	sd	s5,56(sp)
    80002fce:	f85a                	sd	s6,48(sp)
    80002fd0:	f45e                	sd	s7,40(sp)
    80002fd2:	f062                	sd	s8,32(sp)
    80002fd4:	1880                	addi	s0,sp,112
    80002fd6:	8baa                	mv	s7,a0
    80002fd8:	8c2e                	mv	s8,a1
    80002fda:	8ab2                	mv	s5,a2
    80002fdc:	84b6                	mv	s1,a3
    80002fde:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fe0:	9f35                	addw	a4,a4,a3
    return 0;
    80002fe2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002fe4:	0ad76c63          	bltu	a4,a3,8000309c <readi+0xde>
    80002fe8:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002fea:	00e7f463          	bgeu	a5,a4,80002ff2 <readi+0x34>
    n = ip->size - off;
    80002fee:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ff2:	0c0b0463          	beqz	s6,800030ba <readi+0xfc>
    80002ff6:	e8ca                	sd	s2,80(sp)
    80002ff8:	e0d2                	sd	s4,64(sp)
    80002ffa:	ec66                	sd	s9,24(sp)
    80002ffc:	e86a                	sd	s10,16(sp)
    80002ffe:	e46e                	sd	s11,8(sp)
    80003000:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003002:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003006:	5cfd                	li	s9,-1
    80003008:	a82d                	j	80003042 <readi+0x84>
    8000300a:	020a1d93          	slli	s11,s4,0x20
    8000300e:	020ddd93          	srli	s11,s11,0x20
    80003012:	05890613          	addi	a2,s2,88
    80003016:	86ee                	mv	a3,s11
    80003018:	963a                	add	a2,a2,a4
    8000301a:	85d6                	mv	a1,s5
    8000301c:	8562                	mv	a0,s8
    8000301e:	fffff097          	auipc	ra,0xfffff
    80003022:	a56080e7          	jalr	-1450(ra) # 80001a74 <either_copyout>
    80003026:	05950d63          	beq	a0,s9,80003080 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000302a:	854a                	mv	a0,s2
    8000302c:	fffff097          	auipc	ra,0xfffff
    80003030:	610080e7          	jalr	1552(ra) # 8000263c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003034:	013a09bb          	addw	s3,s4,s3
    80003038:	009a04bb          	addw	s1,s4,s1
    8000303c:	9aee                	add	s5,s5,s11
    8000303e:	0769f863          	bgeu	s3,s6,800030ae <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003042:	000ba903          	lw	s2,0(s7)
    80003046:	00a4d59b          	srliw	a1,s1,0xa
    8000304a:	855e                	mv	a0,s7
    8000304c:	00000097          	auipc	ra,0x0
    80003050:	8ae080e7          	jalr	-1874(ra) # 800028fa <bmap>
    80003054:	0005059b          	sext.w	a1,a0
    80003058:	854a                	mv	a0,s2
    8000305a:	fffff097          	auipc	ra,0xfffff
    8000305e:	4b2080e7          	jalr	1202(ra) # 8000250c <bread>
    80003062:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003064:	3ff4f713          	andi	a4,s1,1023
    80003068:	40ed07bb          	subw	a5,s10,a4
    8000306c:	413b06bb          	subw	a3,s6,s3
    80003070:	8a3e                	mv	s4,a5
    80003072:	2781                	sext.w	a5,a5
    80003074:	0006861b          	sext.w	a2,a3
    80003078:	f8f679e3          	bgeu	a2,a5,8000300a <readi+0x4c>
    8000307c:	8a36                	mv	s4,a3
    8000307e:	b771                	j	8000300a <readi+0x4c>
      brelse(bp);
    80003080:	854a                	mv	a0,s2
    80003082:	fffff097          	auipc	ra,0xfffff
    80003086:	5ba080e7          	jalr	1466(ra) # 8000263c <brelse>
      tot = -1;
    8000308a:	59fd                	li	s3,-1
      break;
    8000308c:	6946                	ld	s2,80(sp)
    8000308e:	6a06                	ld	s4,64(sp)
    80003090:	6ce2                	ld	s9,24(sp)
    80003092:	6d42                	ld	s10,16(sp)
    80003094:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003096:	0009851b          	sext.w	a0,s3
    8000309a:	69a6                	ld	s3,72(sp)
}
    8000309c:	70a6                	ld	ra,104(sp)
    8000309e:	7406                	ld	s0,96(sp)
    800030a0:	64e6                	ld	s1,88(sp)
    800030a2:	7ae2                	ld	s5,56(sp)
    800030a4:	7b42                	ld	s6,48(sp)
    800030a6:	7ba2                	ld	s7,40(sp)
    800030a8:	7c02                	ld	s8,32(sp)
    800030aa:	6165                	addi	sp,sp,112
    800030ac:	8082                	ret
    800030ae:	6946                	ld	s2,80(sp)
    800030b0:	6a06                	ld	s4,64(sp)
    800030b2:	6ce2                	ld	s9,24(sp)
    800030b4:	6d42                	ld	s10,16(sp)
    800030b6:	6da2                	ld	s11,8(sp)
    800030b8:	bff9                	j	80003096 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030ba:	89da                	mv	s3,s6
    800030bc:	bfe9                	j	80003096 <readi+0xd8>
    return 0;
    800030be:	4501                	li	a0,0
}
    800030c0:	8082                	ret

00000000800030c2 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030c2:	457c                	lw	a5,76(a0)
    800030c4:	10d7ee63          	bltu	a5,a3,800031e0 <writei+0x11e>
{
    800030c8:	7159                	addi	sp,sp,-112
    800030ca:	f486                	sd	ra,104(sp)
    800030cc:	f0a2                	sd	s0,96(sp)
    800030ce:	e8ca                	sd	s2,80(sp)
    800030d0:	fc56                	sd	s5,56(sp)
    800030d2:	f85a                	sd	s6,48(sp)
    800030d4:	f45e                	sd	s7,40(sp)
    800030d6:	f062                	sd	s8,32(sp)
    800030d8:	1880                	addi	s0,sp,112
    800030da:	8b2a                	mv	s6,a0
    800030dc:	8c2e                	mv	s8,a1
    800030de:	8ab2                	mv	s5,a2
    800030e0:	8936                	mv	s2,a3
    800030e2:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800030e4:	00e687bb          	addw	a5,a3,a4
    800030e8:	0ed7ee63          	bltu	a5,a3,800031e4 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030ec:	00043737          	lui	a4,0x43
    800030f0:	0ef76c63          	bltu	a4,a5,800031e8 <writei+0x126>
    800030f4:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030f6:	0c0b8d63          	beqz	s7,800031d0 <writei+0x10e>
    800030fa:	eca6                	sd	s1,88(sp)
    800030fc:	e4ce                	sd	s3,72(sp)
    800030fe:	ec66                	sd	s9,24(sp)
    80003100:	e86a                	sd	s10,16(sp)
    80003102:	e46e                	sd	s11,8(sp)
    80003104:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003106:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000310a:	5cfd                	li	s9,-1
    8000310c:	a091                	j	80003150 <writei+0x8e>
    8000310e:	02099d93          	slli	s11,s3,0x20
    80003112:	020ddd93          	srli	s11,s11,0x20
    80003116:	05848513          	addi	a0,s1,88
    8000311a:	86ee                	mv	a3,s11
    8000311c:	8656                	mv	a2,s5
    8000311e:	85e2                	mv	a1,s8
    80003120:	953a                	add	a0,a0,a4
    80003122:	fffff097          	auipc	ra,0xfffff
    80003126:	9a8080e7          	jalr	-1624(ra) # 80001aca <either_copyin>
    8000312a:	07950263          	beq	a0,s9,8000318e <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000312e:	8526                	mv	a0,s1
    80003130:	00000097          	auipc	ra,0x0
    80003134:	780080e7          	jalr	1920(ra) # 800038b0 <log_write>
    brelse(bp);
    80003138:	8526                	mv	a0,s1
    8000313a:	fffff097          	auipc	ra,0xfffff
    8000313e:	502080e7          	jalr	1282(ra) # 8000263c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003142:	01498a3b          	addw	s4,s3,s4
    80003146:	0129893b          	addw	s2,s3,s2
    8000314a:	9aee                	add	s5,s5,s11
    8000314c:	057a7663          	bgeu	s4,s7,80003198 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003150:	000b2483          	lw	s1,0(s6)
    80003154:	00a9559b          	srliw	a1,s2,0xa
    80003158:	855a                	mv	a0,s6
    8000315a:	fffff097          	auipc	ra,0xfffff
    8000315e:	7a0080e7          	jalr	1952(ra) # 800028fa <bmap>
    80003162:	0005059b          	sext.w	a1,a0
    80003166:	8526                	mv	a0,s1
    80003168:	fffff097          	auipc	ra,0xfffff
    8000316c:	3a4080e7          	jalr	932(ra) # 8000250c <bread>
    80003170:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003172:	3ff97713          	andi	a4,s2,1023
    80003176:	40ed07bb          	subw	a5,s10,a4
    8000317a:	414b86bb          	subw	a3,s7,s4
    8000317e:	89be                	mv	s3,a5
    80003180:	2781                	sext.w	a5,a5
    80003182:	0006861b          	sext.w	a2,a3
    80003186:	f8f674e3          	bgeu	a2,a5,8000310e <writei+0x4c>
    8000318a:	89b6                	mv	s3,a3
    8000318c:	b749                	j	8000310e <writei+0x4c>
      brelse(bp);
    8000318e:	8526                	mv	a0,s1
    80003190:	fffff097          	auipc	ra,0xfffff
    80003194:	4ac080e7          	jalr	1196(ra) # 8000263c <brelse>
  }

  if(off > ip->size)
    80003198:	04cb2783          	lw	a5,76(s6)
    8000319c:	0327fc63          	bgeu	a5,s2,800031d4 <writei+0x112>
    ip->size = off;
    800031a0:	052b2623          	sw	s2,76(s6)
    800031a4:	64e6                	ld	s1,88(sp)
    800031a6:	69a6                	ld	s3,72(sp)
    800031a8:	6ce2                	ld	s9,24(sp)
    800031aa:	6d42                	ld	s10,16(sp)
    800031ac:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031ae:	855a                	mv	a0,s6
    800031b0:	00000097          	auipc	ra,0x0
    800031b4:	a8a080e7          	jalr	-1398(ra) # 80002c3a <iupdate>

  return tot;
    800031b8:	000a051b          	sext.w	a0,s4
    800031bc:	6a06                	ld	s4,64(sp)
}
    800031be:	70a6                	ld	ra,104(sp)
    800031c0:	7406                	ld	s0,96(sp)
    800031c2:	6946                	ld	s2,80(sp)
    800031c4:	7ae2                	ld	s5,56(sp)
    800031c6:	7b42                	ld	s6,48(sp)
    800031c8:	7ba2                	ld	s7,40(sp)
    800031ca:	7c02                	ld	s8,32(sp)
    800031cc:	6165                	addi	sp,sp,112
    800031ce:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031d0:	8a5e                	mv	s4,s7
    800031d2:	bff1                	j	800031ae <writei+0xec>
    800031d4:	64e6                	ld	s1,88(sp)
    800031d6:	69a6                	ld	s3,72(sp)
    800031d8:	6ce2                	ld	s9,24(sp)
    800031da:	6d42                	ld	s10,16(sp)
    800031dc:	6da2                	ld	s11,8(sp)
    800031de:	bfc1                	j	800031ae <writei+0xec>
    return -1;
    800031e0:	557d                	li	a0,-1
}
    800031e2:	8082                	ret
    return -1;
    800031e4:	557d                	li	a0,-1
    800031e6:	bfe1                	j	800031be <writei+0xfc>
    return -1;
    800031e8:	557d                	li	a0,-1
    800031ea:	bfd1                	j	800031be <writei+0xfc>

00000000800031ec <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031ec:	1141                	addi	sp,sp,-16
    800031ee:	e406                	sd	ra,8(sp)
    800031f0:	e022                	sd	s0,0(sp)
    800031f2:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031f4:	4639                	li	a2,14
    800031f6:	ffffd097          	auipc	ra,0xffffd
    800031fa:	054080e7          	jalr	84(ra) # 8000024a <strncmp>
}
    800031fe:	60a2                	ld	ra,8(sp)
    80003200:	6402                	ld	s0,0(sp)
    80003202:	0141                	addi	sp,sp,16
    80003204:	8082                	ret

0000000080003206 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003206:	7139                	addi	sp,sp,-64
    80003208:	fc06                	sd	ra,56(sp)
    8000320a:	f822                	sd	s0,48(sp)
    8000320c:	f426                	sd	s1,40(sp)
    8000320e:	f04a                	sd	s2,32(sp)
    80003210:	ec4e                	sd	s3,24(sp)
    80003212:	e852                	sd	s4,16(sp)
    80003214:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003216:	04451703          	lh	a4,68(a0)
    8000321a:	4785                	li	a5,1
    8000321c:	00f71a63          	bne	a4,a5,80003230 <dirlookup+0x2a>
    80003220:	892a                	mv	s2,a0
    80003222:	89ae                	mv	s3,a1
    80003224:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003226:	457c                	lw	a5,76(a0)
    80003228:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000322a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000322c:	e79d                	bnez	a5,8000325a <dirlookup+0x54>
    8000322e:	a8a5                	j	800032a6 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003230:	00005517          	auipc	a0,0x5
    80003234:	28850513          	addi	a0,a0,648 # 800084b8 <etext+0x4b8>
    80003238:	00003097          	auipc	ra,0x3
    8000323c:	c54080e7          	jalr	-940(ra) # 80005e8c <panic>
      panic("dirlookup read");
    80003240:	00005517          	auipc	a0,0x5
    80003244:	29050513          	addi	a0,a0,656 # 800084d0 <etext+0x4d0>
    80003248:	00003097          	auipc	ra,0x3
    8000324c:	c44080e7          	jalr	-956(ra) # 80005e8c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003250:	24c1                	addiw	s1,s1,16
    80003252:	04c92783          	lw	a5,76(s2)
    80003256:	04f4f763          	bgeu	s1,a5,800032a4 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000325a:	4741                	li	a4,16
    8000325c:	86a6                	mv	a3,s1
    8000325e:	fc040613          	addi	a2,s0,-64
    80003262:	4581                	li	a1,0
    80003264:	854a                	mv	a0,s2
    80003266:	00000097          	auipc	ra,0x0
    8000326a:	d58080e7          	jalr	-680(ra) # 80002fbe <readi>
    8000326e:	47c1                	li	a5,16
    80003270:	fcf518e3          	bne	a0,a5,80003240 <dirlookup+0x3a>
    if(de.inum == 0)
    80003274:	fc045783          	lhu	a5,-64(s0)
    80003278:	dfe1                	beqz	a5,80003250 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000327a:	fc240593          	addi	a1,s0,-62
    8000327e:	854e                	mv	a0,s3
    80003280:	00000097          	auipc	ra,0x0
    80003284:	f6c080e7          	jalr	-148(ra) # 800031ec <namecmp>
    80003288:	f561                	bnez	a0,80003250 <dirlookup+0x4a>
      if(poff)
    8000328a:	000a0463          	beqz	s4,80003292 <dirlookup+0x8c>
        *poff = off;
    8000328e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003292:	fc045583          	lhu	a1,-64(s0)
    80003296:	00092503          	lw	a0,0(s2)
    8000329a:	fffff097          	auipc	ra,0xfffff
    8000329e:	73c080e7          	jalr	1852(ra) # 800029d6 <iget>
    800032a2:	a011                	j	800032a6 <dirlookup+0xa0>
  return 0;
    800032a4:	4501                	li	a0,0
}
    800032a6:	70e2                	ld	ra,56(sp)
    800032a8:	7442                	ld	s0,48(sp)
    800032aa:	74a2                	ld	s1,40(sp)
    800032ac:	7902                	ld	s2,32(sp)
    800032ae:	69e2                	ld	s3,24(sp)
    800032b0:	6a42                	ld	s4,16(sp)
    800032b2:	6121                	addi	sp,sp,64
    800032b4:	8082                	ret

00000000800032b6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032b6:	711d                	addi	sp,sp,-96
    800032b8:	ec86                	sd	ra,88(sp)
    800032ba:	e8a2                	sd	s0,80(sp)
    800032bc:	e4a6                	sd	s1,72(sp)
    800032be:	e0ca                	sd	s2,64(sp)
    800032c0:	fc4e                	sd	s3,56(sp)
    800032c2:	f852                	sd	s4,48(sp)
    800032c4:	f456                	sd	s5,40(sp)
    800032c6:	f05a                	sd	s6,32(sp)
    800032c8:	ec5e                	sd	s7,24(sp)
    800032ca:	e862                	sd	s8,16(sp)
    800032cc:	e466                	sd	s9,8(sp)
    800032ce:	1080                	addi	s0,sp,96
    800032d0:	84aa                	mv	s1,a0
    800032d2:	8b2e                	mv	s6,a1
    800032d4:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032d6:	00054703          	lbu	a4,0(a0)
    800032da:	02f00793          	li	a5,47
    800032de:	02f70263          	beq	a4,a5,80003302 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032e2:	ffffe097          	auipc	ra,0xffffe
    800032e6:	c7e080e7          	jalr	-898(ra) # 80000f60 <myproc>
    800032ea:	15853503          	ld	a0,344(a0)
    800032ee:	00000097          	auipc	ra,0x0
    800032f2:	9da080e7          	jalr	-1574(ra) # 80002cc8 <idup>
    800032f6:	8a2a                	mv	s4,a0
  while(*path == '/')
    800032f8:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800032fc:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032fe:	4b85                	li	s7,1
    80003300:	a875                	j	800033bc <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003302:	4585                	li	a1,1
    80003304:	4505                	li	a0,1
    80003306:	fffff097          	auipc	ra,0xfffff
    8000330a:	6d0080e7          	jalr	1744(ra) # 800029d6 <iget>
    8000330e:	8a2a                	mv	s4,a0
    80003310:	b7e5                	j	800032f8 <namex+0x42>
      iunlockput(ip);
    80003312:	8552                	mv	a0,s4
    80003314:	00000097          	auipc	ra,0x0
    80003318:	c58080e7          	jalr	-936(ra) # 80002f6c <iunlockput>
      return 0;
    8000331c:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000331e:	8552                	mv	a0,s4
    80003320:	60e6                	ld	ra,88(sp)
    80003322:	6446                	ld	s0,80(sp)
    80003324:	64a6                	ld	s1,72(sp)
    80003326:	6906                	ld	s2,64(sp)
    80003328:	79e2                	ld	s3,56(sp)
    8000332a:	7a42                	ld	s4,48(sp)
    8000332c:	7aa2                	ld	s5,40(sp)
    8000332e:	7b02                	ld	s6,32(sp)
    80003330:	6be2                	ld	s7,24(sp)
    80003332:	6c42                	ld	s8,16(sp)
    80003334:	6ca2                	ld	s9,8(sp)
    80003336:	6125                	addi	sp,sp,96
    80003338:	8082                	ret
      iunlock(ip);
    8000333a:	8552                	mv	a0,s4
    8000333c:	00000097          	auipc	ra,0x0
    80003340:	a90080e7          	jalr	-1392(ra) # 80002dcc <iunlock>
      return ip;
    80003344:	bfe9                	j	8000331e <namex+0x68>
      iunlockput(ip);
    80003346:	8552                	mv	a0,s4
    80003348:	00000097          	auipc	ra,0x0
    8000334c:	c24080e7          	jalr	-988(ra) # 80002f6c <iunlockput>
      return 0;
    80003350:	8a4e                	mv	s4,s3
    80003352:	b7f1                	j	8000331e <namex+0x68>
  len = path - s;
    80003354:	40998633          	sub	a2,s3,s1
    80003358:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000335c:	099c5863          	bge	s8,s9,800033ec <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003360:	4639                	li	a2,14
    80003362:	85a6                	mv	a1,s1
    80003364:	8556                	mv	a0,s5
    80003366:	ffffd097          	auipc	ra,0xffffd
    8000336a:	e70080e7          	jalr	-400(ra) # 800001d6 <memmove>
    8000336e:	84ce                	mv	s1,s3
  while(*path == '/')
    80003370:	0004c783          	lbu	a5,0(s1)
    80003374:	01279763          	bne	a5,s2,80003382 <namex+0xcc>
    path++;
    80003378:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000337a:	0004c783          	lbu	a5,0(s1)
    8000337e:	ff278de3          	beq	a5,s2,80003378 <namex+0xc2>
    ilock(ip);
    80003382:	8552                	mv	a0,s4
    80003384:	00000097          	auipc	ra,0x0
    80003388:	982080e7          	jalr	-1662(ra) # 80002d06 <ilock>
    if(ip->type != T_DIR){
    8000338c:	044a1783          	lh	a5,68(s4)
    80003390:	f97791e3          	bne	a5,s7,80003312 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003394:	000b0563          	beqz	s6,8000339e <namex+0xe8>
    80003398:	0004c783          	lbu	a5,0(s1)
    8000339c:	dfd9                	beqz	a5,8000333a <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000339e:	4601                	li	a2,0
    800033a0:	85d6                	mv	a1,s5
    800033a2:	8552                	mv	a0,s4
    800033a4:	00000097          	auipc	ra,0x0
    800033a8:	e62080e7          	jalr	-414(ra) # 80003206 <dirlookup>
    800033ac:	89aa                	mv	s3,a0
    800033ae:	dd41                	beqz	a0,80003346 <namex+0x90>
    iunlockput(ip);
    800033b0:	8552                	mv	a0,s4
    800033b2:	00000097          	auipc	ra,0x0
    800033b6:	bba080e7          	jalr	-1094(ra) # 80002f6c <iunlockput>
    ip = next;
    800033ba:	8a4e                	mv	s4,s3
  while(*path == '/')
    800033bc:	0004c783          	lbu	a5,0(s1)
    800033c0:	01279763          	bne	a5,s2,800033ce <namex+0x118>
    path++;
    800033c4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033c6:	0004c783          	lbu	a5,0(s1)
    800033ca:	ff278de3          	beq	a5,s2,800033c4 <namex+0x10e>
  if(*path == 0)
    800033ce:	cb9d                	beqz	a5,80003404 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800033d0:	0004c783          	lbu	a5,0(s1)
    800033d4:	89a6                	mv	s3,s1
  len = path - s;
    800033d6:	4c81                	li	s9,0
    800033d8:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800033da:	01278963          	beq	a5,s2,800033ec <namex+0x136>
    800033de:	dbbd                	beqz	a5,80003354 <namex+0x9e>
    path++;
    800033e0:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800033e2:	0009c783          	lbu	a5,0(s3)
    800033e6:	ff279ce3          	bne	a5,s2,800033de <namex+0x128>
    800033ea:	b7ad                	j	80003354 <namex+0x9e>
    memmove(name, s, len);
    800033ec:	2601                	sext.w	a2,a2
    800033ee:	85a6                	mv	a1,s1
    800033f0:	8556                	mv	a0,s5
    800033f2:	ffffd097          	auipc	ra,0xffffd
    800033f6:	de4080e7          	jalr	-540(ra) # 800001d6 <memmove>
    name[len] = 0;
    800033fa:	9cd6                	add	s9,s9,s5
    800033fc:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003400:	84ce                	mv	s1,s3
    80003402:	b7bd                	j	80003370 <namex+0xba>
  if(nameiparent){
    80003404:	f00b0de3          	beqz	s6,8000331e <namex+0x68>
    iput(ip);
    80003408:	8552                	mv	a0,s4
    8000340a:	00000097          	auipc	ra,0x0
    8000340e:	aba080e7          	jalr	-1350(ra) # 80002ec4 <iput>
    return 0;
    80003412:	4a01                	li	s4,0
    80003414:	b729                	j	8000331e <namex+0x68>

0000000080003416 <dirlink>:
{
    80003416:	7139                	addi	sp,sp,-64
    80003418:	fc06                	sd	ra,56(sp)
    8000341a:	f822                	sd	s0,48(sp)
    8000341c:	f04a                	sd	s2,32(sp)
    8000341e:	ec4e                	sd	s3,24(sp)
    80003420:	e852                	sd	s4,16(sp)
    80003422:	0080                	addi	s0,sp,64
    80003424:	892a                	mv	s2,a0
    80003426:	8a2e                	mv	s4,a1
    80003428:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000342a:	4601                	li	a2,0
    8000342c:	00000097          	auipc	ra,0x0
    80003430:	dda080e7          	jalr	-550(ra) # 80003206 <dirlookup>
    80003434:	ed25                	bnez	a0,800034ac <dirlink+0x96>
    80003436:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003438:	04c92483          	lw	s1,76(s2)
    8000343c:	c49d                	beqz	s1,8000346a <dirlink+0x54>
    8000343e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003440:	4741                	li	a4,16
    80003442:	86a6                	mv	a3,s1
    80003444:	fc040613          	addi	a2,s0,-64
    80003448:	4581                	li	a1,0
    8000344a:	854a                	mv	a0,s2
    8000344c:	00000097          	auipc	ra,0x0
    80003450:	b72080e7          	jalr	-1166(ra) # 80002fbe <readi>
    80003454:	47c1                	li	a5,16
    80003456:	06f51163          	bne	a0,a5,800034b8 <dirlink+0xa2>
    if(de.inum == 0)
    8000345a:	fc045783          	lhu	a5,-64(s0)
    8000345e:	c791                	beqz	a5,8000346a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003460:	24c1                	addiw	s1,s1,16
    80003462:	04c92783          	lw	a5,76(s2)
    80003466:	fcf4ede3          	bltu	s1,a5,80003440 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000346a:	4639                	li	a2,14
    8000346c:	85d2                	mv	a1,s4
    8000346e:	fc240513          	addi	a0,s0,-62
    80003472:	ffffd097          	auipc	ra,0xffffd
    80003476:	e0e080e7          	jalr	-498(ra) # 80000280 <strncpy>
  de.inum = inum;
    8000347a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000347e:	4741                	li	a4,16
    80003480:	86a6                	mv	a3,s1
    80003482:	fc040613          	addi	a2,s0,-64
    80003486:	4581                	li	a1,0
    80003488:	854a                	mv	a0,s2
    8000348a:	00000097          	auipc	ra,0x0
    8000348e:	c38080e7          	jalr	-968(ra) # 800030c2 <writei>
    80003492:	872a                	mv	a4,a0
    80003494:	47c1                	li	a5,16
  return 0;
    80003496:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003498:	02f71863          	bne	a4,a5,800034c8 <dirlink+0xb2>
    8000349c:	74a2                	ld	s1,40(sp)
}
    8000349e:	70e2                	ld	ra,56(sp)
    800034a0:	7442                	ld	s0,48(sp)
    800034a2:	7902                	ld	s2,32(sp)
    800034a4:	69e2                	ld	s3,24(sp)
    800034a6:	6a42                	ld	s4,16(sp)
    800034a8:	6121                	addi	sp,sp,64
    800034aa:	8082                	ret
    iput(ip);
    800034ac:	00000097          	auipc	ra,0x0
    800034b0:	a18080e7          	jalr	-1512(ra) # 80002ec4 <iput>
    return -1;
    800034b4:	557d                	li	a0,-1
    800034b6:	b7e5                	j	8000349e <dirlink+0x88>
      panic("dirlink read");
    800034b8:	00005517          	auipc	a0,0x5
    800034bc:	02850513          	addi	a0,a0,40 # 800084e0 <etext+0x4e0>
    800034c0:	00003097          	auipc	ra,0x3
    800034c4:	9cc080e7          	jalr	-1588(ra) # 80005e8c <panic>
    panic("dirlink");
    800034c8:	00005517          	auipc	a0,0x5
    800034cc:	12050513          	addi	a0,a0,288 # 800085e8 <etext+0x5e8>
    800034d0:	00003097          	auipc	ra,0x3
    800034d4:	9bc080e7          	jalr	-1604(ra) # 80005e8c <panic>

00000000800034d8 <namei>:

struct inode*
namei(char *path)
{
    800034d8:	1101                	addi	sp,sp,-32
    800034da:	ec06                	sd	ra,24(sp)
    800034dc:	e822                	sd	s0,16(sp)
    800034de:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034e0:	fe040613          	addi	a2,s0,-32
    800034e4:	4581                	li	a1,0
    800034e6:	00000097          	auipc	ra,0x0
    800034ea:	dd0080e7          	jalr	-560(ra) # 800032b6 <namex>
}
    800034ee:	60e2                	ld	ra,24(sp)
    800034f0:	6442                	ld	s0,16(sp)
    800034f2:	6105                	addi	sp,sp,32
    800034f4:	8082                	ret

00000000800034f6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034f6:	1141                	addi	sp,sp,-16
    800034f8:	e406                	sd	ra,8(sp)
    800034fa:	e022                	sd	s0,0(sp)
    800034fc:	0800                	addi	s0,sp,16
    800034fe:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003500:	4585                	li	a1,1
    80003502:	00000097          	auipc	ra,0x0
    80003506:	db4080e7          	jalr	-588(ra) # 800032b6 <namex>
}
    8000350a:	60a2                	ld	ra,8(sp)
    8000350c:	6402                	ld	s0,0(sp)
    8000350e:	0141                	addi	sp,sp,16
    80003510:	8082                	ret

0000000080003512 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003512:	1101                	addi	sp,sp,-32
    80003514:	ec06                	sd	ra,24(sp)
    80003516:	e822                	sd	s0,16(sp)
    80003518:	e426                	sd	s1,8(sp)
    8000351a:	e04a                	sd	s2,0(sp)
    8000351c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000351e:	00019917          	auipc	s2,0x19
    80003522:	d0290913          	addi	s2,s2,-766 # 8001c220 <log>
    80003526:	01892583          	lw	a1,24(s2)
    8000352a:	02892503          	lw	a0,40(s2)
    8000352e:	fffff097          	auipc	ra,0xfffff
    80003532:	fde080e7          	jalr	-34(ra) # 8000250c <bread>
    80003536:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003538:	02c92603          	lw	a2,44(s2)
    8000353c:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000353e:	00c05f63          	blez	a2,8000355c <write_head+0x4a>
    80003542:	00019717          	auipc	a4,0x19
    80003546:	d0e70713          	addi	a4,a4,-754 # 8001c250 <log+0x30>
    8000354a:	87aa                	mv	a5,a0
    8000354c:	060a                	slli	a2,a2,0x2
    8000354e:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003550:	4314                	lw	a3,0(a4)
    80003552:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003554:	0711                	addi	a4,a4,4
    80003556:	0791                	addi	a5,a5,4
    80003558:	fec79ce3          	bne	a5,a2,80003550 <write_head+0x3e>
  }
  bwrite(buf);
    8000355c:	8526                	mv	a0,s1
    8000355e:	fffff097          	auipc	ra,0xfffff
    80003562:	0a0080e7          	jalr	160(ra) # 800025fe <bwrite>
  brelse(buf);
    80003566:	8526                	mv	a0,s1
    80003568:	fffff097          	auipc	ra,0xfffff
    8000356c:	0d4080e7          	jalr	212(ra) # 8000263c <brelse>
}
    80003570:	60e2                	ld	ra,24(sp)
    80003572:	6442                	ld	s0,16(sp)
    80003574:	64a2                	ld	s1,8(sp)
    80003576:	6902                	ld	s2,0(sp)
    80003578:	6105                	addi	sp,sp,32
    8000357a:	8082                	ret

000000008000357c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000357c:	00019797          	auipc	a5,0x19
    80003580:	cd07a783          	lw	a5,-816(a5) # 8001c24c <log+0x2c>
    80003584:	0af05d63          	blez	a5,8000363e <install_trans+0xc2>
{
    80003588:	7139                	addi	sp,sp,-64
    8000358a:	fc06                	sd	ra,56(sp)
    8000358c:	f822                	sd	s0,48(sp)
    8000358e:	f426                	sd	s1,40(sp)
    80003590:	f04a                	sd	s2,32(sp)
    80003592:	ec4e                	sd	s3,24(sp)
    80003594:	e852                	sd	s4,16(sp)
    80003596:	e456                	sd	s5,8(sp)
    80003598:	e05a                	sd	s6,0(sp)
    8000359a:	0080                	addi	s0,sp,64
    8000359c:	8b2a                	mv	s6,a0
    8000359e:	00019a97          	auipc	s5,0x19
    800035a2:	cb2a8a93          	addi	s5,s5,-846 # 8001c250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035a6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035a8:	00019997          	auipc	s3,0x19
    800035ac:	c7898993          	addi	s3,s3,-904 # 8001c220 <log>
    800035b0:	a00d                	j	800035d2 <install_trans+0x56>
    brelse(lbuf);
    800035b2:	854a                	mv	a0,s2
    800035b4:	fffff097          	auipc	ra,0xfffff
    800035b8:	088080e7          	jalr	136(ra) # 8000263c <brelse>
    brelse(dbuf);
    800035bc:	8526                	mv	a0,s1
    800035be:	fffff097          	auipc	ra,0xfffff
    800035c2:	07e080e7          	jalr	126(ra) # 8000263c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035c6:	2a05                	addiw	s4,s4,1
    800035c8:	0a91                	addi	s5,s5,4
    800035ca:	02c9a783          	lw	a5,44(s3)
    800035ce:	04fa5e63          	bge	s4,a5,8000362a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035d2:	0189a583          	lw	a1,24(s3)
    800035d6:	014585bb          	addw	a1,a1,s4
    800035da:	2585                	addiw	a1,a1,1
    800035dc:	0289a503          	lw	a0,40(s3)
    800035e0:	fffff097          	auipc	ra,0xfffff
    800035e4:	f2c080e7          	jalr	-212(ra) # 8000250c <bread>
    800035e8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035ea:	000aa583          	lw	a1,0(s5)
    800035ee:	0289a503          	lw	a0,40(s3)
    800035f2:	fffff097          	auipc	ra,0xfffff
    800035f6:	f1a080e7          	jalr	-230(ra) # 8000250c <bread>
    800035fa:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035fc:	40000613          	li	a2,1024
    80003600:	05890593          	addi	a1,s2,88
    80003604:	05850513          	addi	a0,a0,88
    80003608:	ffffd097          	auipc	ra,0xffffd
    8000360c:	bce080e7          	jalr	-1074(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003610:	8526                	mv	a0,s1
    80003612:	fffff097          	auipc	ra,0xfffff
    80003616:	fec080e7          	jalr	-20(ra) # 800025fe <bwrite>
    if(recovering == 0)
    8000361a:	f80b1ce3          	bnez	s6,800035b2 <install_trans+0x36>
      bunpin(dbuf);
    8000361e:	8526                	mv	a0,s1
    80003620:	fffff097          	auipc	ra,0xfffff
    80003624:	0f4080e7          	jalr	244(ra) # 80002714 <bunpin>
    80003628:	b769                	j	800035b2 <install_trans+0x36>
}
    8000362a:	70e2                	ld	ra,56(sp)
    8000362c:	7442                	ld	s0,48(sp)
    8000362e:	74a2                	ld	s1,40(sp)
    80003630:	7902                	ld	s2,32(sp)
    80003632:	69e2                	ld	s3,24(sp)
    80003634:	6a42                	ld	s4,16(sp)
    80003636:	6aa2                	ld	s5,8(sp)
    80003638:	6b02                	ld	s6,0(sp)
    8000363a:	6121                	addi	sp,sp,64
    8000363c:	8082                	ret
    8000363e:	8082                	ret

0000000080003640 <initlog>:
{
    80003640:	7179                	addi	sp,sp,-48
    80003642:	f406                	sd	ra,40(sp)
    80003644:	f022                	sd	s0,32(sp)
    80003646:	ec26                	sd	s1,24(sp)
    80003648:	e84a                	sd	s2,16(sp)
    8000364a:	e44e                	sd	s3,8(sp)
    8000364c:	1800                	addi	s0,sp,48
    8000364e:	892a                	mv	s2,a0
    80003650:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003652:	00019497          	auipc	s1,0x19
    80003656:	bce48493          	addi	s1,s1,-1074 # 8001c220 <log>
    8000365a:	00005597          	auipc	a1,0x5
    8000365e:	e9658593          	addi	a1,a1,-362 # 800084f0 <etext+0x4f0>
    80003662:	8526                	mv	a0,s1
    80003664:	00003097          	auipc	ra,0x3
    80003668:	d12080e7          	jalr	-750(ra) # 80006376 <initlock>
  log.start = sb->logstart;
    8000366c:	0149a583          	lw	a1,20(s3)
    80003670:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003672:	0109a783          	lw	a5,16(s3)
    80003676:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003678:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000367c:	854a                	mv	a0,s2
    8000367e:	fffff097          	auipc	ra,0xfffff
    80003682:	e8e080e7          	jalr	-370(ra) # 8000250c <bread>
  log.lh.n = lh->n;
    80003686:	4d30                	lw	a2,88(a0)
    80003688:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000368a:	00c05f63          	blez	a2,800036a8 <initlog+0x68>
    8000368e:	87aa                	mv	a5,a0
    80003690:	00019717          	auipc	a4,0x19
    80003694:	bc070713          	addi	a4,a4,-1088 # 8001c250 <log+0x30>
    80003698:	060a                	slli	a2,a2,0x2
    8000369a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000369c:	4ff4                	lw	a3,92(a5)
    8000369e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800036a0:	0791                	addi	a5,a5,4
    800036a2:	0711                	addi	a4,a4,4
    800036a4:	fec79ce3          	bne	a5,a2,8000369c <initlog+0x5c>
  brelse(buf);
    800036a8:	fffff097          	auipc	ra,0xfffff
    800036ac:	f94080e7          	jalr	-108(ra) # 8000263c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036b0:	4505                	li	a0,1
    800036b2:	00000097          	auipc	ra,0x0
    800036b6:	eca080e7          	jalr	-310(ra) # 8000357c <install_trans>
  log.lh.n = 0;
    800036ba:	00019797          	auipc	a5,0x19
    800036be:	b807a923          	sw	zero,-1134(a5) # 8001c24c <log+0x2c>
  write_head(); // clear the log
    800036c2:	00000097          	auipc	ra,0x0
    800036c6:	e50080e7          	jalr	-432(ra) # 80003512 <write_head>
}
    800036ca:	70a2                	ld	ra,40(sp)
    800036cc:	7402                	ld	s0,32(sp)
    800036ce:	64e2                	ld	s1,24(sp)
    800036d0:	6942                	ld	s2,16(sp)
    800036d2:	69a2                	ld	s3,8(sp)
    800036d4:	6145                	addi	sp,sp,48
    800036d6:	8082                	ret

00000000800036d8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036d8:	1101                	addi	sp,sp,-32
    800036da:	ec06                	sd	ra,24(sp)
    800036dc:	e822                	sd	s0,16(sp)
    800036de:	e426                	sd	s1,8(sp)
    800036e0:	e04a                	sd	s2,0(sp)
    800036e2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036e4:	00019517          	auipc	a0,0x19
    800036e8:	b3c50513          	addi	a0,a0,-1220 # 8001c220 <log>
    800036ec:	00003097          	auipc	ra,0x3
    800036f0:	d1a080e7          	jalr	-742(ra) # 80006406 <acquire>
  while(1){
    if(log.committing){
    800036f4:	00019497          	auipc	s1,0x19
    800036f8:	b2c48493          	addi	s1,s1,-1236 # 8001c220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036fc:	4979                	li	s2,30
    800036fe:	a039                	j	8000370c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003700:	85a6                	mv	a1,s1
    80003702:	8526                	mv	a0,s1
    80003704:	ffffe097          	auipc	ra,0xffffe
    80003708:	fcc080e7          	jalr	-52(ra) # 800016d0 <sleep>
    if(log.committing){
    8000370c:	50dc                	lw	a5,36(s1)
    8000370e:	fbed                	bnez	a5,80003700 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003710:	5098                	lw	a4,32(s1)
    80003712:	2705                	addiw	a4,a4,1
    80003714:	0027179b          	slliw	a5,a4,0x2
    80003718:	9fb9                	addw	a5,a5,a4
    8000371a:	0017979b          	slliw	a5,a5,0x1
    8000371e:	54d4                	lw	a3,44(s1)
    80003720:	9fb5                	addw	a5,a5,a3
    80003722:	00f95963          	bge	s2,a5,80003734 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003726:	85a6                	mv	a1,s1
    80003728:	8526                	mv	a0,s1
    8000372a:	ffffe097          	auipc	ra,0xffffe
    8000372e:	fa6080e7          	jalr	-90(ra) # 800016d0 <sleep>
    80003732:	bfe9                	j	8000370c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003734:	00019517          	auipc	a0,0x19
    80003738:	aec50513          	addi	a0,a0,-1300 # 8001c220 <log>
    8000373c:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000373e:	00003097          	auipc	ra,0x3
    80003742:	d7c080e7          	jalr	-644(ra) # 800064ba <release>
      break;
    }
  }
}
    80003746:	60e2                	ld	ra,24(sp)
    80003748:	6442                	ld	s0,16(sp)
    8000374a:	64a2                	ld	s1,8(sp)
    8000374c:	6902                	ld	s2,0(sp)
    8000374e:	6105                	addi	sp,sp,32
    80003750:	8082                	ret

0000000080003752 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003752:	7139                	addi	sp,sp,-64
    80003754:	fc06                	sd	ra,56(sp)
    80003756:	f822                	sd	s0,48(sp)
    80003758:	f426                	sd	s1,40(sp)
    8000375a:	f04a                	sd	s2,32(sp)
    8000375c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000375e:	00019497          	auipc	s1,0x19
    80003762:	ac248493          	addi	s1,s1,-1342 # 8001c220 <log>
    80003766:	8526                	mv	a0,s1
    80003768:	00003097          	auipc	ra,0x3
    8000376c:	c9e080e7          	jalr	-866(ra) # 80006406 <acquire>
  log.outstanding -= 1;
    80003770:	509c                	lw	a5,32(s1)
    80003772:	37fd                	addiw	a5,a5,-1
    80003774:	0007891b          	sext.w	s2,a5
    80003778:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000377a:	50dc                	lw	a5,36(s1)
    8000377c:	e7b9                	bnez	a5,800037ca <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    8000377e:	06091163          	bnez	s2,800037e0 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003782:	00019497          	auipc	s1,0x19
    80003786:	a9e48493          	addi	s1,s1,-1378 # 8001c220 <log>
    8000378a:	4785                	li	a5,1
    8000378c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000378e:	8526                	mv	a0,s1
    80003790:	00003097          	auipc	ra,0x3
    80003794:	d2a080e7          	jalr	-726(ra) # 800064ba <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003798:	54dc                	lw	a5,44(s1)
    8000379a:	06f04763          	bgtz	a5,80003808 <end_op+0xb6>
    acquire(&log.lock);
    8000379e:	00019497          	auipc	s1,0x19
    800037a2:	a8248493          	addi	s1,s1,-1406 # 8001c220 <log>
    800037a6:	8526                	mv	a0,s1
    800037a8:	00003097          	auipc	ra,0x3
    800037ac:	c5e080e7          	jalr	-930(ra) # 80006406 <acquire>
    log.committing = 0;
    800037b0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037b4:	8526                	mv	a0,s1
    800037b6:	ffffe097          	auipc	ra,0xffffe
    800037ba:	0a6080e7          	jalr	166(ra) # 8000185c <wakeup>
    release(&log.lock);
    800037be:	8526                	mv	a0,s1
    800037c0:	00003097          	auipc	ra,0x3
    800037c4:	cfa080e7          	jalr	-774(ra) # 800064ba <release>
}
    800037c8:	a815                	j	800037fc <end_op+0xaa>
    800037ca:	ec4e                	sd	s3,24(sp)
    800037cc:	e852                	sd	s4,16(sp)
    800037ce:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800037d0:	00005517          	auipc	a0,0x5
    800037d4:	d2850513          	addi	a0,a0,-728 # 800084f8 <etext+0x4f8>
    800037d8:	00002097          	auipc	ra,0x2
    800037dc:	6b4080e7          	jalr	1716(ra) # 80005e8c <panic>
    wakeup(&log);
    800037e0:	00019497          	auipc	s1,0x19
    800037e4:	a4048493          	addi	s1,s1,-1472 # 8001c220 <log>
    800037e8:	8526                	mv	a0,s1
    800037ea:	ffffe097          	auipc	ra,0xffffe
    800037ee:	072080e7          	jalr	114(ra) # 8000185c <wakeup>
  release(&log.lock);
    800037f2:	8526                	mv	a0,s1
    800037f4:	00003097          	auipc	ra,0x3
    800037f8:	cc6080e7          	jalr	-826(ra) # 800064ba <release>
}
    800037fc:	70e2                	ld	ra,56(sp)
    800037fe:	7442                	ld	s0,48(sp)
    80003800:	74a2                	ld	s1,40(sp)
    80003802:	7902                	ld	s2,32(sp)
    80003804:	6121                	addi	sp,sp,64
    80003806:	8082                	ret
    80003808:	ec4e                	sd	s3,24(sp)
    8000380a:	e852                	sd	s4,16(sp)
    8000380c:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000380e:	00019a97          	auipc	s5,0x19
    80003812:	a42a8a93          	addi	s5,s5,-1470 # 8001c250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003816:	00019a17          	auipc	s4,0x19
    8000381a:	a0aa0a13          	addi	s4,s4,-1526 # 8001c220 <log>
    8000381e:	018a2583          	lw	a1,24(s4)
    80003822:	012585bb          	addw	a1,a1,s2
    80003826:	2585                	addiw	a1,a1,1
    80003828:	028a2503          	lw	a0,40(s4)
    8000382c:	fffff097          	auipc	ra,0xfffff
    80003830:	ce0080e7          	jalr	-800(ra) # 8000250c <bread>
    80003834:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003836:	000aa583          	lw	a1,0(s5)
    8000383a:	028a2503          	lw	a0,40(s4)
    8000383e:	fffff097          	auipc	ra,0xfffff
    80003842:	cce080e7          	jalr	-818(ra) # 8000250c <bread>
    80003846:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003848:	40000613          	li	a2,1024
    8000384c:	05850593          	addi	a1,a0,88
    80003850:	05848513          	addi	a0,s1,88
    80003854:	ffffd097          	auipc	ra,0xffffd
    80003858:	982080e7          	jalr	-1662(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    8000385c:	8526                	mv	a0,s1
    8000385e:	fffff097          	auipc	ra,0xfffff
    80003862:	da0080e7          	jalr	-608(ra) # 800025fe <bwrite>
    brelse(from);
    80003866:	854e                	mv	a0,s3
    80003868:	fffff097          	auipc	ra,0xfffff
    8000386c:	dd4080e7          	jalr	-556(ra) # 8000263c <brelse>
    brelse(to);
    80003870:	8526                	mv	a0,s1
    80003872:	fffff097          	auipc	ra,0xfffff
    80003876:	dca080e7          	jalr	-566(ra) # 8000263c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000387a:	2905                	addiw	s2,s2,1
    8000387c:	0a91                	addi	s5,s5,4
    8000387e:	02ca2783          	lw	a5,44(s4)
    80003882:	f8f94ee3          	blt	s2,a5,8000381e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003886:	00000097          	auipc	ra,0x0
    8000388a:	c8c080e7          	jalr	-884(ra) # 80003512 <write_head>
    install_trans(0); // Now install writes to home locations
    8000388e:	4501                	li	a0,0
    80003890:	00000097          	auipc	ra,0x0
    80003894:	cec080e7          	jalr	-788(ra) # 8000357c <install_trans>
    log.lh.n = 0;
    80003898:	00019797          	auipc	a5,0x19
    8000389c:	9a07aa23          	sw	zero,-1612(a5) # 8001c24c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038a0:	00000097          	auipc	ra,0x0
    800038a4:	c72080e7          	jalr	-910(ra) # 80003512 <write_head>
    800038a8:	69e2                	ld	s3,24(sp)
    800038aa:	6a42                	ld	s4,16(sp)
    800038ac:	6aa2                	ld	s5,8(sp)
    800038ae:	bdc5                	j	8000379e <end_op+0x4c>

00000000800038b0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038b0:	1101                	addi	sp,sp,-32
    800038b2:	ec06                	sd	ra,24(sp)
    800038b4:	e822                	sd	s0,16(sp)
    800038b6:	e426                	sd	s1,8(sp)
    800038b8:	e04a                	sd	s2,0(sp)
    800038ba:	1000                	addi	s0,sp,32
    800038bc:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038be:	00019917          	auipc	s2,0x19
    800038c2:	96290913          	addi	s2,s2,-1694 # 8001c220 <log>
    800038c6:	854a                	mv	a0,s2
    800038c8:	00003097          	auipc	ra,0x3
    800038cc:	b3e080e7          	jalr	-1218(ra) # 80006406 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038d0:	02c92603          	lw	a2,44(s2)
    800038d4:	47f5                	li	a5,29
    800038d6:	06c7c563          	blt	a5,a2,80003940 <log_write+0x90>
    800038da:	00019797          	auipc	a5,0x19
    800038de:	9627a783          	lw	a5,-1694(a5) # 8001c23c <log+0x1c>
    800038e2:	37fd                	addiw	a5,a5,-1
    800038e4:	04f65e63          	bge	a2,a5,80003940 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038e8:	00019797          	auipc	a5,0x19
    800038ec:	9587a783          	lw	a5,-1704(a5) # 8001c240 <log+0x20>
    800038f0:	06f05063          	blez	a5,80003950 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038f4:	4781                	li	a5,0
    800038f6:	06c05563          	blez	a2,80003960 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038fa:	44cc                	lw	a1,12(s1)
    800038fc:	00019717          	auipc	a4,0x19
    80003900:	95470713          	addi	a4,a4,-1708 # 8001c250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003904:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003906:	4314                	lw	a3,0(a4)
    80003908:	04b68c63          	beq	a3,a1,80003960 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000390c:	2785                	addiw	a5,a5,1
    8000390e:	0711                	addi	a4,a4,4
    80003910:	fef61be3          	bne	a2,a5,80003906 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003914:	0621                	addi	a2,a2,8
    80003916:	060a                	slli	a2,a2,0x2
    80003918:	00019797          	auipc	a5,0x19
    8000391c:	90878793          	addi	a5,a5,-1784 # 8001c220 <log>
    80003920:	97b2                	add	a5,a5,a2
    80003922:	44d8                	lw	a4,12(s1)
    80003924:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003926:	8526                	mv	a0,s1
    80003928:	fffff097          	auipc	ra,0xfffff
    8000392c:	db0080e7          	jalr	-592(ra) # 800026d8 <bpin>
    log.lh.n++;
    80003930:	00019717          	auipc	a4,0x19
    80003934:	8f070713          	addi	a4,a4,-1808 # 8001c220 <log>
    80003938:	575c                	lw	a5,44(a4)
    8000393a:	2785                	addiw	a5,a5,1
    8000393c:	d75c                	sw	a5,44(a4)
    8000393e:	a82d                	j	80003978 <log_write+0xc8>
    panic("too big a transaction");
    80003940:	00005517          	auipc	a0,0x5
    80003944:	bc850513          	addi	a0,a0,-1080 # 80008508 <etext+0x508>
    80003948:	00002097          	auipc	ra,0x2
    8000394c:	544080e7          	jalr	1348(ra) # 80005e8c <panic>
    panic("log_write outside of trans");
    80003950:	00005517          	auipc	a0,0x5
    80003954:	bd050513          	addi	a0,a0,-1072 # 80008520 <etext+0x520>
    80003958:	00002097          	auipc	ra,0x2
    8000395c:	534080e7          	jalr	1332(ra) # 80005e8c <panic>
  log.lh.block[i] = b->blockno;
    80003960:	00878693          	addi	a3,a5,8
    80003964:	068a                	slli	a3,a3,0x2
    80003966:	00019717          	auipc	a4,0x19
    8000396a:	8ba70713          	addi	a4,a4,-1862 # 8001c220 <log>
    8000396e:	9736                	add	a4,a4,a3
    80003970:	44d4                	lw	a3,12(s1)
    80003972:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003974:	faf609e3          	beq	a2,a5,80003926 <log_write+0x76>
  }
  release(&log.lock);
    80003978:	00019517          	auipc	a0,0x19
    8000397c:	8a850513          	addi	a0,a0,-1880 # 8001c220 <log>
    80003980:	00003097          	auipc	ra,0x3
    80003984:	b3a080e7          	jalr	-1222(ra) # 800064ba <release>
}
    80003988:	60e2                	ld	ra,24(sp)
    8000398a:	6442                	ld	s0,16(sp)
    8000398c:	64a2                	ld	s1,8(sp)
    8000398e:	6902                	ld	s2,0(sp)
    80003990:	6105                	addi	sp,sp,32
    80003992:	8082                	ret

0000000080003994 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003994:	1101                	addi	sp,sp,-32
    80003996:	ec06                	sd	ra,24(sp)
    80003998:	e822                	sd	s0,16(sp)
    8000399a:	e426                	sd	s1,8(sp)
    8000399c:	e04a                	sd	s2,0(sp)
    8000399e:	1000                	addi	s0,sp,32
    800039a0:	84aa                	mv	s1,a0
    800039a2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039a4:	00005597          	auipc	a1,0x5
    800039a8:	b9c58593          	addi	a1,a1,-1124 # 80008540 <etext+0x540>
    800039ac:	0521                	addi	a0,a0,8
    800039ae:	00003097          	auipc	ra,0x3
    800039b2:	9c8080e7          	jalr	-1592(ra) # 80006376 <initlock>
  lk->name = name;
    800039b6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039ba:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039be:	0204a423          	sw	zero,40(s1)
}
    800039c2:	60e2                	ld	ra,24(sp)
    800039c4:	6442                	ld	s0,16(sp)
    800039c6:	64a2                	ld	s1,8(sp)
    800039c8:	6902                	ld	s2,0(sp)
    800039ca:	6105                	addi	sp,sp,32
    800039cc:	8082                	ret

00000000800039ce <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039ce:	1101                	addi	sp,sp,-32
    800039d0:	ec06                	sd	ra,24(sp)
    800039d2:	e822                	sd	s0,16(sp)
    800039d4:	e426                	sd	s1,8(sp)
    800039d6:	e04a                	sd	s2,0(sp)
    800039d8:	1000                	addi	s0,sp,32
    800039da:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039dc:	00850913          	addi	s2,a0,8
    800039e0:	854a                	mv	a0,s2
    800039e2:	00003097          	auipc	ra,0x3
    800039e6:	a24080e7          	jalr	-1500(ra) # 80006406 <acquire>
  while (lk->locked) {
    800039ea:	409c                	lw	a5,0(s1)
    800039ec:	cb89                	beqz	a5,800039fe <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039ee:	85ca                	mv	a1,s2
    800039f0:	8526                	mv	a0,s1
    800039f2:	ffffe097          	auipc	ra,0xffffe
    800039f6:	cde080e7          	jalr	-802(ra) # 800016d0 <sleep>
  while (lk->locked) {
    800039fa:	409c                	lw	a5,0(s1)
    800039fc:	fbed                	bnez	a5,800039ee <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039fe:	4785                	li	a5,1
    80003a00:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a02:	ffffd097          	auipc	ra,0xffffd
    80003a06:	55e080e7          	jalr	1374(ra) # 80000f60 <myproc>
    80003a0a:	591c                	lw	a5,48(a0)
    80003a0c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a0e:	854a                	mv	a0,s2
    80003a10:	00003097          	auipc	ra,0x3
    80003a14:	aaa080e7          	jalr	-1366(ra) # 800064ba <release>
}
    80003a18:	60e2                	ld	ra,24(sp)
    80003a1a:	6442                	ld	s0,16(sp)
    80003a1c:	64a2                	ld	s1,8(sp)
    80003a1e:	6902                	ld	s2,0(sp)
    80003a20:	6105                	addi	sp,sp,32
    80003a22:	8082                	ret

0000000080003a24 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a24:	1101                	addi	sp,sp,-32
    80003a26:	ec06                	sd	ra,24(sp)
    80003a28:	e822                	sd	s0,16(sp)
    80003a2a:	e426                	sd	s1,8(sp)
    80003a2c:	e04a                	sd	s2,0(sp)
    80003a2e:	1000                	addi	s0,sp,32
    80003a30:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a32:	00850913          	addi	s2,a0,8
    80003a36:	854a                	mv	a0,s2
    80003a38:	00003097          	auipc	ra,0x3
    80003a3c:	9ce080e7          	jalr	-1586(ra) # 80006406 <acquire>
  lk->locked = 0;
    80003a40:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a44:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a48:	8526                	mv	a0,s1
    80003a4a:	ffffe097          	auipc	ra,0xffffe
    80003a4e:	e12080e7          	jalr	-494(ra) # 8000185c <wakeup>
  release(&lk->lk);
    80003a52:	854a                	mv	a0,s2
    80003a54:	00003097          	auipc	ra,0x3
    80003a58:	a66080e7          	jalr	-1434(ra) # 800064ba <release>
}
    80003a5c:	60e2                	ld	ra,24(sp)
    80003a5e:	6442                	ld	s0,16(sp)
    80003a60:	64a2                	ld	s1,8(sp)
    80003a62:	6902                	ld	s2,0(sp)
    80003a64:	6105                	addi	sp,sp,32
    80003a66:	8082                	ret

0000000080003a68 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a68:	7179                	addi	sp,sp,-48
    80003a6a:	f406                	sd	ra,40(sp)
    80003a6c:	f022                	sd	s0,32(sp)
    80003a6e:	ec26                	sd	s1,24(sp)
    80003a70:	e84a                	sd	s2,16(sp)
    80003a72:	1800                	addi	s0,sp,48
    80003a74:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a76:	00850913          	addi	s2,a0,8
    80003a7a:	854a                	mv	a0,s2
    80003a7c:	00003097          	auipc	ra,0x3
    80003a80:	98a080e7          	jalr	-1654(ra) # 80006406 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a84:	409c                	lw	a5,0(s1)
    80003a86:	ef91                	bnez	a5,80003aa2 <holdingsleep+0x3a>
    80003a88:	4481                	li	s1,0
  release(&lk->lk);
    80003a8a:	854a                	mv	a0,s2
    80003a8c:	00003097          	auipc	ra,0x3
    80003a90:	a2e080e7          	jalr	-1490(ra) # 800064ba <release>
  return r;
}
    80003a94:	8526                	mv	a0,s1
    80003a96:	70a2                	ld	ra,40(sp)
    80003a98:	7402                	ld	s0,32(sp)
    80003a9a:	64e2                	ld	s1,24(sp)
    80003a9c:	6942                	ld	s2,16(sp)
    80003a9e:	6145                	addi	sp,sp,48
    80003aa0:	8082                	ret
    80003aa2:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003aa4:	0284a983          	lw	s3,40(s1)
    80003aa8:	ffffd097          	auipc	ra,0xffffd
    80003aac:	4b8080e7          	jalr	1208(ra) # 80000f60 <myproc>
    80003ab0:	5904                	lw	s1,48(a0)
    80003ab2:	413484b3          	sub	s1,s1,s3
    80003ab6:	0014b493          	seqz	s1,s1
    80003aba:	69a2                	ld	s3,8(sp)
    80003abc:	b7f9                	j	80003a8a <holdingsleep+0x22>

0000000080003abe <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003abe:	1141                	addi	sp,sp,-16
    80003ac0:	e406                	sd	ra,8(sp)
    80003ac2:	e022                	sd	s0,0(sp)
    80003ac4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ac6:	00005597          	auipc	a1,0x5
    80003aca:	a8a58593          	addi	a1,a1,-1398 # 80008550 <etext+0x550>
    80003ace:	00019517          	auipc	a0,0x19
    80003ad2:	89a50513          	addi	a0,a0,-1894 # 8001c368 <ftable>
    80003ad6:	00003097          	auipc	ra,0x3
    80003ada:	8a0080e7          	jalr	-1888(ra) # 80006376 <initlock>
}
    80003ade:	60a2                	ld	ra,8(sp)
    80003ae0:	6402                	ld	s0,0(sp)
    80003ae2:	0141                	addi	sp,sp,16
    80003ae4:	8082                	ret

0000000080003ae6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003ae6:	1101                	addi	sp,sp,-32
    80003ae8:	ec06                	sd	ra,24(sp)
    80003aea:	e822                	sd	s0,16(sp)
    80003aec:	e426                	sd	s1,8(sp)
    80003aee:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003af0:	00019517          	auipc	a0,0x19
    80003af4:	87850513          	addi	a0,a0,-1928 # 8001c368 <ftable>
    80003af8:	00003097          	auipc	ra,0x3
    80003afc:	90e080e7          	jalr	-1778(ra) # 80006406 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b00:	00019497          	auipc	s1,0x19
    80003b04:	88048493          	addi	s1,s1,-1920 # 8001c380 <ftable+0x18>
    80003b08:	0001a717          	auipc	a4,0x1a
    80003b0c:	81870713          	addi	a4,a4,-2024 # 8001d320 <ftable+0xfb8>
    if(f->ref == 0){
    80003b10:	40dc                	lw	a5,4(s1)
    80003b12:	cf99                	beqz	a5,80003b30 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b14:	02848493          	addi	s1,s1,40
    80003b18:	fee49ce3          	bne	s1,a4,80003b10 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b1c:	00019517          	auipc	a0,0x19
    80003b20:	84c50513          	addi	a0,a0,-1972 # 8001c368 <ftable>
    80003b24:	00003097          	auipc	ra,0x3
    80003b28:	996080e7          	jalr	-1642(ra) # 800064ba <release>
  return 0;
    80003b2c:	4481                	li	s1,0
    80003b2e:	a819                	j	80003b44 <filealloc+0x5e>
      f->ref = 1;
    80003b30:	4785                	li	a5,1
    80003b32:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b34:	00019517          	auipc	a0,0x19
    80003b38:	83450513          	addi	a0,a0,-1996 # 8001c368 <ftable>
    80003b3c:	00003097          	auipc	ra,0x3
    80003b40:	97e080e7          	jalr	-1666(ra) # 800064ba <release>
}
    80003b44:	8526                	mv	a0,s1
    80003b46:	60e2                	ld	ra,24(sp)
    80003b48:	6442                	ld	s0,16(sp)
    80003b4a:	64a2                	ld	s1,8(sp)
    80003b4c:	6105                	addi	sp,sp,32
    80003b4e:	8082                	ret

0000000080003b50 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b50:	1101                	addi	sp,sp,-32
    80003b52:	ec06                	sd	ra,24(sp)
    80003b54:	e822                	sd	s0,16(sp)
    80003b56:	e426                	sd	s1,8(sp)
    80003b58:	1000                	addi	s0,sp,32
    80003b5a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b5c:	00019517          	auipc	a0,0x19
    80003b60:	80c50513          	addi	a0,a0,-2036 # 8001c368 <ftable>
    80003b64:	00003097          	auipc	ra,0x3
    80003b68:	8a2080e7          	jalr	-1886(ra) # 80006406 <acquire>
  if(f->ref < 1)
    80003b6c:	40dc                	lw	a5,4(s1)
    80003b6e:	02f05263          	blez	a5,80003b92 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b72:	2785                	addiw	a5,a5,1
    80003b74:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b76:	00018517          	auipc	a0,0x18
    80003b7a:	7f250513          	addi	a0,a0,2034 # 8001c368 <ftable>
    80003b7e:	00003097          	auipc	ra,0x3
    80003b82:	93c080e7          	jalr	-1732(ra) # 800064ba <release>
  return f;
}
    80003b86:	8526                	mv	a0,s1
    80003b88:	60e2                	ld	ra,24(sp)
    80003b8a:	6442                	ld	s0,16(sp)
    80003b8c:	64a2                	ld	s1,8(sp)
    80003b8e:	6105                	addi	sp,sp,32
    80003b90:	8082                	ret
    panic("filedup");
    80003b92:	00005517          	auipc	a0,0x5
    80003b96:	9c650513          	addi	a0,a0,-1594 # 80008558 <etext+0x558>
    80003b9a:	00002097          	auipc	ra,0x2
    80003b9e:	2f2080e7          	jalr	754(ra) # 80005e8c <panic>

0000000080003ba2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003ba2:	7139                	addi	sp,sp,-64
    80003ba4:	fc06                	sd	ra,56(sp)
    80003ba6:	f822                	sd	s0,48(sp)
    80003ba8:	f426                	sd	s1,40(sp)
    80003baa:	0080                	addi	s0,sp,64
    80003bac:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bae:	00018517          	auipc	a0,0x18
    80003bb2:	7ba50513          	addi	a0,a0,1978 # 8001c368 <ftable>
    80003bb6:	00003097          	auipc	ra,0x3
    80003bba:	850080e7          	jalr	-1968(ra) # 80006406 <acquire>
  if(f->ref < 1)
    80003bbe:	40dc                	lw	a5,4(s1)
    80003bc0:	04f05c63          	blez	a5,80003c18 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003bc4:	37fd                	addiw	a5,a5,-1
    80003bc6:	0007871b          	sext.w	a4,a5
    80003bca:	c0dc                	sw	a5,4(s1)
    80003bcc:	06e04263          	bgtz	a4,80003c30 <fileclose+0x8e>
    80003bd0:	f04a                	sd	s2,32(sp)
    80003bd2:	ec4e                	sd	s3,24(sp)
    80003bd4:	e852                	sd	s4,16(sp)
    80003bd6:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003bd8:	0004a903          	lw	s2,0(s1)
    80003bdc:	0094ca83          	lbu	s5,9(s1)
    80003be0:	0104ba03          	ld	s4,16(s1)
    80003be4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003be8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003bec:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003bf0:	00018517          	auipc	a0,0x18
    80003bf4:	77850513          	addi	a0,a0,1912 # 8001c368 <ftable>
    80003bf8:	00003097          	auipc	ra,0x3
    80003bfc:	8c2080e7          	jalr	-1854(ra) # 800064ba <release>

  if(ff.type == FD_PIPE){
    80003c00:	4785                	li	a5,1
    80003c02:	04f90463          	beq	s2,a5,80003c4a <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c06:	3979                	addiw	s2,s2,-2
    80003c08:	4785                	li	a5,1
    80003c0a:	0527fb63          	bgeu	a5,s2,80003c60 <fileclose+0xbe>
    80003c0e:	7902                	ld	s2,32(sp)
    80003c10:	69e2                	ld	s3,24(sp)
    80003c12:	6a42                	ld	s4,16(sp)
    80003c14:	6aa2                	ld	s5,8(sp)
    80003c16:	a02d                	j	80003c40 <fileclose+0x9e>
    80003c18:	f04a                	sd	s2,32(sp)
    80003c1a:	ec4e                	sd	s3,24(sp)
    80003c1c:	e852                	sd	s4,16(sp)
    80003c1e:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003c20:	00005517          	auipc	a0,0x5
    80003c24:	94050513          	addi	a0,a0,-1728 # 80008560 <etext+0x560>
    80003c28:	00002097          	auipc	ra,0x2
    80003c2c:	264080e7          	jalr	612(ra) # 80005e8c <panic>
    release(&ftable.lock);
    80003c30:	00018517          	auipc	a0,0x18
    80003c34:	73850513          	addi	a0,a0,1848 # 8001c368 <ftable>
    80003c38:	00003097          	auipc	ra,0x3
    80003c3c:	882080e7          	jalr	-1918(ra) # 800064ba <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003c40:	70e2                	ld	ra,56(sp)
    80003c42:	7442                	ld	s0,48(sp)
    80003c44:	74a2                	ld	s1,40(sp)
    80003c46:	6121                	addi	sp,sp,64
    80003c48:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c4a:	85d6                	mv	a1,s5
    80003c4c:	8552                	mv	a0,s4
    80003c4e:	00000097          	auipc	ra,0x0
    80003c52:	3a2080e7          	jalr	930(ra) # 80003ff0 <pipeclose>
    80003c56:	7902                	ld	s2,32(sp)
    80003c58:	69e2                	ld	s3,24(sp)
    80003c5a:	6a42                	ld	s4,16(sp)
    80003c5c:	6aa2                	ld	s5,8(sp)
    80003c5e:	b7cd                	j	80003c40 <fileclose+0x9e>
    begin_op();
    80003c60:	00000097          	auipc	ra,0x0
    80003c64:	a78080e7          	jalr	-1416(ra) # 800036d8 <begin_op>
    iput(ff.ip);
    80003c68:	854e                	mv	a0,s3
    80003c6a:	fffff097          	auipc	ra,0xfffff
    80003c6e:	25a080e7          	jalr	602(ra) # 80002ec4 <iput>
    end_op();
    80003c72:	00000097          	auipc	ra,0x0
    80003c76:	ae0080e7          	jalr	-1312(ra) # 80003752 <end_op>
    80003c7a:	7902                	ld	s2,32(sp)
    80003c7c:	69e2                	ld	s3,24(sp)
    80003c7e:	6a42                	ld	s4,16(sp)
    80003c80:	6aa2                	ld	s5,8(sp)
    80003c82:	bf7d                	j	80003c40 <fileclose+0x9e>

0000000080003c84 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c84:	715d                	addi	sp,sp,-80
    80003c86:	e486                	sd	ra,72(sp)
    80003c88:	e0a2                	sd	s0,64(sp)
    80003c8a:	fc26                	sd	s1,56(sp)
    80003c8c:	f44e                	sd	s3,40(sp)
    80003c8e:	0880                	addi	s0,sp,80
    80003c90:	84aa                	mv	s1,a0
    80003c92:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c94:	ffffd097          	auipc	ra,0xffffd
    80003c98:	2cc080e7          	jalr	716(ra) # 80000f60 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c9c:	409c                	lw	a5,0(s1)
    80003c9e:	37f9                	addiw	a5,a5,-2
    80003ca0:	4705                	li	a4,1
    80003ca2:	04f76863          	bltu	a4,a5,80003cf2 <filestat+0x6e>
    80003ca6:	f84a                	sd	s2,48(sp)
    80003ca8:	892a                	mv	s2,a0
    ilock(f->ip);
    80003caa:	6c88                	ld	a0,24(s1)
    80003cac:	fffff097          	auipc	ra,0xfffff
    80003cb0:	05a080e7          	jalr	90(ra) # 80002d06 <ilock>
    stati(f->ip, &st);
    80003cb4:	fb840593          	addi	a1,s0,-72
    80003cb8:	6c88                	ld	a0,24(s1)
    80003cba:	fffff097          	auipc	ra,0xfffff
    80003cbe:	2da080e7          	jalr	730(ra) # 80002f94 <stati>
    iunlock(f->ip);
    80003cc2:	6c88                	ld	a0,24(s1)
    80003cc4:	fffff097          	auipc	ra,0xfffff
    80003cc8:	108080e7          	jalr	264(ra) # 80002dcc <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ccc:	46e1                	li	a3,24
    80003cce:	fb840613          	addi	a2,s0,-72
    80003cd2:	85ce                	mv	a1,s3
    80003cd4:	05093503          	ld	a0,80(s2)
    80003cd8:	ffffd097          	auipc	ra,0xffffd
    80003cdc:	e40080e7          	jalr	-448(ra) # 80000b18 <copyout>
    80003ce0:	41f5551b          	sraiw	a0,a0,0x1f
    80003ce4:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003ce6:	60a6                	ld	ra,72(sp)
    80003ce8:	6406                	ld	s0,64(sp)
    80003cea:	74e2                	ld	s1,56(sp)
    80003cec:	79a2                	ld	s3,40(sp)
    80003cee:	6161                	addi	sp,sp,80
    80003cf0:	8082                	ret
  return -1;
    80003cf2:	557d                	li	a0,-1
    80003cf4:	bfcd                	j	80003ce6 <filestat+0x62>

0000000080003cf6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003cf6:	7179                	addi	sp,sp,-48
    80003cf8:	f406                	sd	ra,40(sp)
    80003cfa:	f022                	sd	s0,32(sp)
    80003cfc:	e84a                	sd	s2,16(sp)
    80003cfe:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d00:	00854783          	lbu	a5,8(a0)
    80003d04:	cbc5                	beqz	a5,80003db4 <fileread+0xbe>
    80003d06:	ec26                	sd	s1,24(sp)
    80003d08:	e44e                	sd	s3,8(sp)
    80003d0a:	84aa                	mv	s1,a0
    80003d0c:	89ae                	mv	s3,a1
    80003d0e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d10:	411c                	lw	a5,0(a0)
    80003d12:	4705                	li	a4,1
    80003d14:	04e78963          	beq	a5,a4,80003d66 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d18:	470d                	li	a4,3
    80003d1a:	04e78f63          	beq	a5,a4,80003d78 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d1e:	4709                	li	a4,2
    80003d20:	08e79263          	bne	a5,a4,80003da4 <fileread+0xae>
    ilock(f->ip);
    80003d24:	6d08                	ld	a0,24(a0)
    80003d26:	fffff097          	auipc	ra,0xfffff
    80003d2a:	fe0080e7          	jalr	-32(ra) # 80002d06 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d2e:	874a                	mv	a4,s2
    80003d30:	5094                	lw	a3,32(s1)
    80003d32:	864e                	mv	a2,s3
    80003d34:	4585                	li	a1,1
    80003d36:	6c88                	ld	a0,24(s1)
    80003d38:	fffff097          	auipc	ra,0xfffff
    80003d3c:	286080e7          	jalr	646(ra) # 80002fbe <readi>
    80003d40:	892a                	mv	s2,a0
    80003d42:	00a05563          	blez	a0,80003d4c <fileread+0x56>
      f->off += r;
    80003d46:	509c                	lw	a5,32(s1)
    80003d48:	9fa9                	addw	a5,a5,a0
    80003d4a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d4c:	6c88                	ld	a0,24(s1)
    80003d4e:	fffff097          	auipc	ra,0xfffff
    80003d52:	07e080e7          	jalr	126(ra) # 80002dcc <iunlock>
    80003d56:	64e2                	ld	s1,24(sp)
    80003d58:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003d5a:	854a                	mv	a0,s2
    80003d5c:	70a2                	ld	ra,40(sp)
    80003d5e:	7402                	ld	s0,32(sp)
    80003d60:	6942                	ld	s2,16(sp)
    80003d62:	6145                	addi	sp,sp,48
    80003d64:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d66:	6908                	ld	a0,16(a0)
    80003d68:	00000097          	auipc	ra,0x0
    80003d6c:	3fa080e7          	jalr	1018(ra) # 80004162 <piperead>
    80003d70:	892a                	mv	s2,a0
    80003d72:	64e2                	ld	s1,24(sp)
    80003d74:	69a2                	ld	s3,8(sp)
    80003d76:	b7d5                	j	80003d5a <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d78:	02451783          	lh	a5,36(a0)
    80003d7c:	03079693          	slli	a3,a5,0x30
    80003d80:	92c1                	srli	a3,a3,0x30
    80003d82:	4725                	li	a4,9
    80003d84:	02d76a63          	bltu	a4,a3,80003db8 <fileread+0xc2>
    80003d88:	0792                	slli	a5,a5,0x4
    80003d8a:	00018717          	auipc	a4,0x18
    80003d8e:	53e70713          	addi	a4,a4,1342 # 8001c2c8 <devsw>
    80003d92:	97ba                	add	a5,a5,a4
    80003d94:	639c                	ld	a5,0(a5)
    80003d96:	c78d                	beqz	a5,80003dc0 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003d98:	4505                	li	a0,1
    80003d9a:	9782                	jalr	a5
    80003d9c:	892a                	mv	s2,a0
    80003d9e:	64e2                	ld	s1,24(sp)
    80003da0:	69a2                	ld	s3,8(sp)
    80003da2:	bf65                	j	80003d5a <fileread+0x64>
    panic("fileread");
    80003da4:	00004517          	auipc	a0,0x4
    80003da8:	7cc50513          	addi	a0,a0,1996 # 80008570 <etext+0x570>
    80003dac:	00002097          	auipc	ra,0x2
    80003db0:	0e0080e7          	jalr	224(ra) # 80005e8c <panic>
    return -1;
    80003db4:	597d                	li	s2,-1
    80003db6:	b755                	j	80003d5a <fileread+0x64>
      return -1;
    80003db8:	597d                	li	s2,-1
    80003dba:	64e2                	ld	s1,24(sp)
    80003dbc:	69a2                	ld	s3,8(sp)
    80003dbe:	bf71                	j	80003d5a <fileread+0x64>
    80003dc0:	597d                	li	s2,-1
    80003dc2:	64e2                	ld	s1,24(sp)
    80003dc4:	69a2                	ld	s3,8(sp)
    80003dc6:	bf51                	j	80003d5a <fileread+0x64>

0000000080003dc8 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003dc8:	00954783          	lbu	a5,9(a0)
    80003dcc:	12078963          	beqz	a5,80003efe <filewrite+0x136>
{
    80003dd0:	715d                	addi	sp,sp,-80
    80003dd2:	e486                	sd	ra,72(sp)
    80003dd4:	e0a2                	sd	s0,64(sp)
    80003dd6:	f84a                	sd	s2,48(sp)
    80003dd8:	f052                	sd	s4,32(sp)
    80003dda:	e85a                	sd	s6,16(sp)
    80003ddc:	0880                	addi	s0,sp,80
    80003dde:	892a                	mv	s2,a0
    80003de0:	8b2e                	mv	s6,a1
    80003de2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003de4:	411c                	lw	a5,0(a0)
    80003de6:	4705                	li	a4,1
    80003de8:	02e78763          	beq	a5,a4,80003e16 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dec:	470d                	li	a4,3
    80003dee:	02e78a63          	beq	a5,a4,80003e22 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003df2:	4709                	li	a4,2
    80003df4:	0ee79863          	bne	a5,a4,80003ee4 <filewrite+0x11c>
    80003df8:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003dfa:	0cc05463          	blez	a2,80003ec2 <filewrite+0xfa>
    80003dfe:	fc26                	sd	s1,56(sp)
    80003e00:	ec56                	sd	s5,24(sp)
    80003e02:	e45e                	sd	s7,8(sp)
    80003e04:	e062                	sd	s8,0(sp)
    int i = 0;
    80003e06:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003e08:	6b85                	lui	s7,0x1
    80003e0a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003e0e:	6c05                	lui	s8,0x1
    80003e10:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003e14:	a851                	j	80003ea8 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003e16:	6908                	ld	a0,16(a0)
    80003e18:	00000097          	auipc	ra,0x0
    80003e1c:	248080e7          	jalr	584(ra) # 80004060 <pipewrite>
    80003e20:	a85d                	j	80003ed6 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e22:	02451783          	lh	a5,36(a0)
    80003e26:	03079693          	slli	a3,a5,0x30
    80003e2a:	92c1                	srli	a3,a3,0x30
    80003e2c:	4725                	li	a4,9
    80003e2e:	0cd76a63          	bltu	a4,a3,80003f02 <filewrite+0x13a>
    80003e32:	0792                	slli	a5,a5,0x4
    80003e34:	00018717          	auipc	a4,0x18
    80003e38:	49470713          	addi	a4,a4,1172 # 8001c2c8 <devsw>
    80003e3c:	97ba                	add	a5,a5,a4
    80003e3e:	679c                	ld	a5,8(a5)
    80003e40:	c3f9                	beqz	a5,80003f06 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003e42:	4505                	li	a0,1
    80003e44:	9782                	jalr	a5
    80003e46:	a841                	j	80003ed6 <filewrite+0x10e>
      if(n1 > max)
    80003e48:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003e4c:	00000097          	auipc	ra,0x0
    80003e50:	88c080e7          	jalr	-1908(ra) # 800036d8 <begin_op>
      ilock(f->ip);
    80003e54:	01893503          	ld	a0,24(s2)
    80003e58:	fffff097          	auipc	ra,0xfffff
    80003e5c:	eae080e7          	jalr	-338(ra) # 80002d06 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e60:	8756                	mv	a4,s5
    80003e62:	02092683          	lw	a3,32(s2)
    80003e66:	01698633          	add	a2,s3,s6
    80003e6a:	4585                	li	a1,1
    80003e6c:	01893503          	ld	a0,24(s2)
    80003e70:	fffff097          	auipc	ra,0xfffff
    80003e74:	252080e7          	jalr	594(ra) # 800030c2 <writei>
    80003e78:	84aa                	mv	s1,a0
    80003e7a:	00a05763          	blez	a0,80003e88 <filewrite+0xc0>
        f->off += r;
    80003e7e:	02092783          	lw	a5,32(s2)
    80003e82:	9fa9                	addw	a5,a5,a0
    80003e84:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e88:	01893503          	ld	a0,24(s2)
    80003e8c:	fffff097          	auipc	ra,0xfffff
    80003e90:	f40080e7          	jalr	-192(ra) # 80002dcc <iunlock>
      end_op();
    80003e94:	00000097          	auipc	ra,0x0
    80003e98:	8be080e7          	jalr	-1858(ra) # 80003752 <end_op>

      if(r != n1){
    80003e9c:	029a9563          	bne	s5,s1,80003ec6 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003ea0:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ea4:	0149da63          	bge	s3,s4,80003eb8 <filewrite+0xf0>
      int n1 = n - i;
    80003ea8:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003eac:	0004879b          	sext.w	a5,s1
    80003eb0:	f8fbdce3          	bge	s7,a5,80003e48 <filewrite+0x80>
    80003eb4:	84e2                	mv	s1,s8
    80003eb6:	bf49                	j	80003e48 <filewrite+0x80>
    80003eb8:	74e2                	ld	s1,56(sp)
    80003eba:	6ae2                	ld	s5,24(sp)
    80003ebc:	6ba2                	ld	s7,8(sp)
    80003ebe:	6c02                	ld	s8,0(sp)
    80003ec0:	a039                	j	80003ece <filewrite+0x106>
    int i = 0;
    80003ec2:	4981                	li	s3,0
    80003ec4:	a029                	j	80003ece <filewrite+0x106>
    80003ec6:	74e2                	ld	s1,56(sp)
    80003ec8:	6ae2                	ld	s5,24(sp)
    80003eca:	6ba2                	ld	s7,8(sp)
    80003ecc:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003ece:	033a1e63          	bne	s4,s3,80003f0a <filewrite+0x142>
    80003ed2:	8552                	mv	a0,s4
    80003ed4:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ed6:	60a6                	ld	ra,72(sp)
    80003ed8:	6406                	ld	s0,64(sp)
    80003eda:	7942                	ld	s2,48(sp)
    80003edc:	7a02                	ld	s4,32(sp)
    80003ede:	6b42                	ld	s6,16(sp)
    80003ee0:	6161                	addi	sp,sp,80
    80003ee2:	8082                	ret
    80003ee4:	fc26                	sd	s1,56(sp)
    80003ee6:	f44e                	sd	s3,40(sp)
    80003ee8:	ec56                	sd	s5,24(sp)
    80003eea:	e45e                	sd	s7,8(sp)
    80003eec:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003eee:	00004517          	auipc	a0,0x4
    80003ef2:	69250513          	addi	a0,a0,1682 # 80008580 <etext+0x580>
    80003ef6:	00002097          	auipc	ra,0x2
    80003efa:	f96080e7          	jalr	-106(ra) # 80005e8c <panic>
    return -1;
    80003efe:	557d                	li	a0,-1
}
    80003f00:	8082                	ret
      return -1;
    80003f02:	557d                	li	a0,-1
    80003f04:	bfc9                	j	80003ed6 <filewrite+0x10e>
    80003f06:	557d                	li	a0,-1
    80003f08:	b7f9                	j	80003ed6 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003f0a:	557d                	li	a0,-1
    80003f0c:	79a2                	ld	s3,40(sp)
    80003f0e:	b7e1                	j	80003ed6 <filewrite+0x10e>

0000000080003f10 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f10:	7179                	addi	sp,sp,-48
    80003f12:	f406                	sd	ra,40(sp)
    80003f14:	f022                	sd	s0,32(sp)
    80003f16:	ec26                	sd	s1,24(sp)
    80003f18:	e052                	sd	s4,0(sp)
    80003f1a:	1800                	addi	s0,sp,48
    80003f1c:	84aa                	mv	s1,a0
    80003f1e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f20:	0005b023          	sd	zero,0(a1)
    80003f24:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f28:	00000097          	auipc	ra,0x0
    80003f2c:	bbe080e7          	jalr	-1090(ra) # 80003ae6 <filealloc>
    80003f30:	e088                	sd	a0,0(s1)
    80003f32:	cd49                	beqz	a0,80003fcc <pipealloc+0xbc>
    80003f34:	00000097          	auipc	ra,0x0
    80003f38:	bb2080e7          	jalr	-1102(ra) # 80003ae6 <filealloc>
    80003f3c:	00aa3023          	sd	a0,0(s4)
    80003f40:	c141                	beqz	a0,80003fc0 <pipealloc+0xb0>
    80003f42:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f44:	ffffc097          	auipc	ra,0xffffc
    80003f48:	1d6080e7          	jalr	470(ra) # 8000011a <kalloc>
    80003f4c:	892a                	mv	s2,a0
    80003f4e:	c13d                	beqz	a0,80003fb4 <pipealloc+0xa4>
    80003f50:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003f52:	4985                	li	s3,1
    80003f54:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f58:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f5c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f60:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f64:	00004597          	auipc	a1,0x4
    80003f68:	62c58593          	addi	a1,a1,1580 # 80008590 <etext+0x590>
    80003f6c:	00002097          	auipc	ra,0x2
    80003f70:	40a080e7          	jalr	1034(ra) # 80006376 <initlock>
  (*f0)->type = FD_PIPE;
    80003f74:	609c                	ld	a5,0(s1)
    80003f76:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f7a:	609c                	ld	a5,0(s1)
    80003f7c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f80:	609c                	ld	a5,0(s1)
    80003f82:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f86:	609c                	ld	a5,0(s1)
    80003f88:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f8c:	000a3783          	ld	a5,0(s4)
    80003f90:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f94:	000a3783          	ld	a5,0(s4)
    80003f98:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f9c:	000a3783          	ld	a5,0(s4)
    80003fa0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003fa4:	000a3783          	ld	a5,0(s4)
    80003fa8:	0127b823          	sd	s2,16(a5)
  return 0;
    80003fac:	4501                	li	a0,0
    80003fae:	6942                	ld	s2,16(sp)
    80003fb0:	69a2                	ld	s3,8(sp)
    80003fb2:	a03d                	j	80003fe0 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fb4:	6088                	ld	a0,0(s1)
    80003fb6:	c119                	beqz	a0,80003fbc <pipealloc+0xac>
    80003fb8:	6942                	ld	s2,16(sp)
    80003fba:	a029                	j	80003fc4 <pipealloc+0xb4>
    80003fbc:	6942                	ld	s2,16(sp)
    80003fbe:	a039                	j	80003fcc <pipealloc+0xbc>
    80003fc0:	6088                	ld	a0,0(s1)
    80003fc2:	c50d                	beqz	a0,80003fec <pipealloc+0xdc>
    fileclose(*f0);
    80003fc4:	00000097          	auipc	ra,0x0
    80003fc8:	bde080e7          	jalr	-1058(ra) # 80003ba2 <fileclose>
  if(*f1)
    80003fcc:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fd0:	557d                	li	a0,-1
  if(*f1)
    80003fd2:	c799                	beqz	a5,80003fe0 <pipealloc+0xd0>
    fileclose(*f1);
    80003fd4:	853e                	mv	a0,a5
    80003fd6:	00000097          	auipc	ra,0x0
    80003fda:	bcc080e7          	jalr	-1076(ra) # 80003ba2 <fileclose>
  return -1;
    80003fde:	557d                	li	a0,-1
}
    80003fe0:	70a2                	ld	ra,40(sp)
    80003fe2:	7402                	ld	s0,32(sp)
    80003fe4:	64e2                	ld	s1,24(sp)
    80003fe6:	6a02                	ld	s4,0(sp)
    80003fe8:	6145                	addi	sp,sp,48
    80003fea:	8082                	ret
  return -1;
    80003fec:	557d                	li	a0,-1
    80003fee:	bfcd                	j	80003fe0 <pipealloc+0xd0>

0000000080003ff0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ff0:	1101                	addi	sp,sp,-32
    80003ff2:	ec06                	sd	ra,24(sp)
    80003ff4:	e822                	sd	s0,16(sp)
    80003ff6:	e426                	sd	s1,8(sp)
    80003ff8:	e04a                	sd	s2,0(sp)
    80003ffa:	1000                	addi	s0,sp,32
    80003ffc:	84aa                	mv	s1,a0
    80003ffe:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004000:	00002097          	auipc	ra,0x2
    80004004:	406080e7          	jalr	1030(ra) # 80006406 <acquire>
  if(writable){
    80004008:	02090d63          	beqz	s2,80004042 <pipeclose+0x52>
    pi->writeopen = 0;
    8000400c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004010:	21848513          	addi	a0,s1,536
    80004014:	ffffe097          	auipc	ra,0xffffe
    80004018:	848080e7          	jalr	-1976(ra) # 8000185c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000401c:	2204b783          	ld	a5,544(s1)
    80004020:	eb95                	bnez	a5,80004054 <pipeclose+0x64>
    release(&pi->lock);
    80004022:	8526                	mv	a0,s1
    80004024:	00002097          	auipc	ra,0x2
    80004028:	496080e7          	jalr	1174(ra) # 800064ba <release>
    kfree((char*)pi);
    8000402c:	8526                	mv	a0,s1
    8000402e:	ffffc097          	auipc	ra,0xffffc
    80004032:	fee080e7          	jalr	-18(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004036:	60e2                	ld	ra,24(sp)
    80004038:	6442                	ld	s0,16(sp)
    8000403a:	64a2                	ld	s1,8(sp)
    8000403c:	6902                	ld	s2,0(sp)
    8000403e:	6105                	addi	sp,sp,32
    80004040:	8082                	ret
    pi->readopen = 0;
    80004042:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004046:	21c48513          	addi	a0,s1,540
    8000404a:	ffffe097          	auipc	ra,0xffffe
    8000404e:	812080e7          	jalr	-2030(ra) # 8000185c <wakeup>
    80004052:	b7e9                	j	8000401c <pipeclose+0x2c>
    release(&pi->lock);
    80004054:	8526                	mv	a0,s1
    80004056:	00002097          	auipc	ra,0x2
    8000405a:	464080e7          	jalr	1124(ra) # 800064ba <release>
}
    8000405e:	bfe1                	j	80004036 <pipeclose+0x46>

0000000080004060 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004060:	711d                	addi	sp,sp,-96
    80004062:	ec86                	sd	ra,88(sp)
    80004064:	e8a2                	sd	s0,80(sp)
    80004066:	e4a6                	sd	s1,72(sp)
    80004068:	e0ca                	sd	s2,64(sp)
    8000406a:	fc4e                	sd	s3,56(sp)
    8000406c:	f852                	sd	s4,48(sp)
    8000406e:	f456                	sd	s5,40(sp)
    80004070:	1080                	addi	s0,sp,96
    80004072:	84aa                	mv	s1,a0
    80004074:	8aae                	mv	s5,a1
    80004076:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004078:	ffffd097          	auipc	ra,0xffffd
    8000407c:	ee8080e7          	jalr	-280(ra) # 80000f60 <myproc>
    80004080:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004082:	8526                	mv	a0,s1
    80004084:	00002097          	auipc	ra,0x2
    80004088:	382080e7          	jalr	898(ra) # 80006406 <acquire>
  while(i < n){
    8000408c:	0d405563          	blez	s4,80004156 <pipewrite+0xf6>
    80004090:	f05a                	sd	s6,32(sp)
    80004092:	ec5e                	sd	s7,24(sp)
    80004094:	e862                	sd	s8,16(sp)
  int i = 0;
    80004096:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004098:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000409a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000409e:	21c48b93          	addi	s7,s1,540
    800040a2:	a089                	j	800040e4 <pipewrite+0x84>
      release(&pi->lock);
    800040a4:	8526                	mv	a0,s1
    800040a6:	00002097          	auipc	ra,0x2
    800040aa:	414080e7          	jalr	1044(ra) # 800064ba <release>
      return -1;
    800040ae:	597d                	li	s2,-1
    800040b0:	7b02                	ld	s6,32(sp)
    800040b2:	6be2                	ld	s7,24(sp)
    800040b4:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800040b6:	854a                	mv	a0,s2
    800040b8:	60e6                	ld	ra,88(sp)
    800040ba:	6446                	ld	s0,80(sp)
    800040bc:	64a6                	ld	s1,72(sp)
    800040be:	6906                	ld	s2,64(sp)
    800040c0:	79e2                	ld	s3,56(sp)
    800040c2:	7a42                	ld	s4,48(sp)
    800040c4:	7aa2                	ld	s5,40(sp)
    800040c6:	6125                	addi	sp,sp,96
    800040c8:	8082                	ret
      wakeup(&pi->nread);
    800040ca:	8562                	mv	a0,s8
    800040cc:	ffffd097          	auipc	ra,0xffffd
    800040d0:	790080e7          	jalr	1936(ra) # 8000185c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040d4:	85a6                	mv	a1,s1
    800040d6:	855e                	mv	a0,s7
    800040d8:	ffffd097          	auipc	ra,0xffffd
    800040dc:	5f8080e7          	jalr	1528(ra) # 800016d0 <sleep>
  while(i < n){
    800040e0:	05495c63          	bge	s2,s4,80004138 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    800040e4:	2204a783          	lw	a5,544(s1)
    800040e8:	dfd5                	beqz	a5,800040a4 <pipewrite+0x44>
    800040ea:	0289a783          	lw	a5,40(s3)
    800040ee:	fbdd                	bnez	a5,800040a4 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040f0:	2184a783          	lw	a5,536(s1)
    800040f4:	21c4a703          	lw	a4,540(s1)
    800040f8:	2007879b          	addiw	a5,a5,512
    800040fc:	fcf707e3          	beq	a4,a5,800040ca <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004100:	4685                	li	a3,1
    80004102:	01590633          	add	a2,s2,s5
    80004106:	faf40593          	addi	a1,s0,-81
    8000410a:	0509b503          	ld	a0,80(s3)
    8000410e:	ffffd097          	auipc	ra,0xffffd
    80004112:	a96080e7          	jalr	-1386(ra) # 80000ba4 <copyin>
    80004116:	05650263          	beq	a0,s6,8000415a <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000411a:	21c4a783          	lw	a5,540(s1)
    8000411e:	0017871b          	addiw	a4,a5,1
    80004122:	20e4ae23          	sw	a4,540(s1)
    80004126:	1ff7f793          	andi	a5,a5,511
    8000412a:	97a6                	add	a5,a5,s1
    8000412c:	faf44703          	lbu	a4,-81(s0)
    80004130:	00e78c23          	sb	a4,24(a5)
      i++;
    80004134:	2905                	addiw	s2,s2,1
    80004136:	b76d                	j	800040e0 <pipewrite+0x80>
    80004138:	7b02                	ld	s6,32(sp)
    8000413a:	6be2                	ld	s7,24(sp)
    8000413c:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    8000413e:	21848513          	addi	a0,s1,536
    80004142:	ffffd097          	auipc	ra,0xffffd
    80004146:	71a080e7          	jalr	1818(ra) # 8000185c <wakeup>
  release(&pi->lock);
    8000414a:	8526                	mv	a0,s1
    8000414c:	00002097          	auipc	ra,0x2
    80004150:	36e080e7          	jalr	878(ra) # 800064ba <release>
  return i;
    80004154:	b78d                	j	800040b6 <pipewrite+0x56>
  int i = 0;
    80004156:	4901                	li	s2,0
    80004158:	b7dd                	j	8000413e <pipewrite+0xde>
    8000415a:	7b02                	ld	s6,32(sp)
    8000415c:	6be2                	ld	s7,24(sp)
    8000415e:	6c42                	ld	s8,16(sp)
    80004160:	bff9                	j	8000413e <pipewrite+0xde>

0000000080004162 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004162:	715d                	addi	sp,sp,-80
    80004164:	e486                	sd	ra,72(sp)
    80004166:	e0a2                	sd	s0,64(sp)
    80004168:	fc26                	sd	s1,56(sp)
    8000416a:	f84a                	sd	s2,48(sp)
    8000416c:	f44e                	sd	s3,40(sp)
    8000416e:	f052                	sd	s4,32(sp)
    80004170:	ec56                	sd	s5,24(sp)
    80004172:	0880                	addi	s0,sp,80
    80004174:	84aa                	mv	s1,a0
    80004176:	892e                	mv	s2,a1
    80004178:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000417a:	ffffd097          	auipc	ra,0xffffd
    8000417e:	de6080e7          	jalr	-538(ra) # 80000f60 <myproc>
    80004182:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004184:	8526                	mv	a0,s1
    80004186:	00002097          	auipc	ra,0x2
    8000418a:	280080e7          	jalr	640(ra) # 80006406 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000418e:	2184a703          	lw	a4,536(s1)
    80004192:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004196:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000419a:	02f71663          	bne	a4,a5,800041c6 <piperead+0x64>
    8000419e:	2244a783          	lw	a5,548(s1)
    800041a2:	cb9d                	beqz	a5,800041d8 <piperead+0x76>
    if(pr->killed){
    800041a4:	028a2783          	lw	a5,40(s4)
    800041a8:	e38d                	bnez	a5,800041ca <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041aa:	85a6                	mv	a1,s1
    800041ac:	854e                	mv	a0,s3
    800041ae:	ffffd097          	auipc	ra,0xffffd
    800041b2:	522080e7          	jalr	1314(ra) # 800016d0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041b6:	2184a703          	lw	a4,536(s1)
    800041ba:	21c4a783          	lw	a5,540(s1)
    800041be:	fef700e3          	beq	a4,a5,8000419e <piperead+0x3c>
    800041c2:	e85a                	sd	s6,16(sp)
    800041c4:	a819                	j	800041da <piperead+0x78>
    800041c6:	e85a                	sd	s6,16(sp)
    800041c8:	a809                	j	800041da <piperead+0x78>
      release(&pi->lock);
    800041ca:	8526                	mv	a0,s1
    800041cc:	00002097          	auipc	ra,0x2
    800041d0:	2ee080e7          	jalr	750(ra) # 800064ba <release>
      return -1;
    800041d4:	59fd                	li	s3,-1
    800041d6:	a0a5                	j	8000423e <piperead+0xdc>
    800041d8:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041da:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041dc:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041de:	05505463          	blez	s5,80004226 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    800041e2:	2184a783          	lw	a5,536(s1)
    800041e6:	21c4a703          	lw	a4,540(s1)
    800041ea:	02f70e63          	beq	a4,a5,80004226 <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041ee:	0017871b          	addiw	a4,a5,1
    800041f2:	20e4ac23          	sw	a4,536(s1)
    800041f6:	1ff7f793          	andi	a5,a5,511
    800041fa:	97a6                	add	a5,a5,s1
    800041fc:	0187c783          	lbu	a5,24(a5)
    80004200:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004204:	4685                	li	a3,1
    80004206:	fbf40613          	addi	a2,s0,-65
    8000420a:	85ca                	mv	a1,s2
    8000420c:	050a3503          	ld	a0,80(s4)
    80004210:	ffffd097          	auipc	ra,0xffffd
    80004214:	908080e7          	jalr	-1784(ra) # 80000b18 <copyout>
    80004218:	01650763          	beq	a0,s6,80004226 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000421c:	2985                	addiw	s3,s3,1
    8000421e:	0905                	addi	s2,s2,1
    80004220:	fd3a91e3          	bne	s5,s3,800041e2 <piperead+0x80>
    80004224:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004226:	21c48513          	addi	a0,s1,540
    8000422a:	ffffd097          	auipc	ra,0xffffd
    8000422e:	632080e7          	jalr	1586(ra) # 8000185c <wakeup>
  release(&pi->lock);
    80004232:	8526                	mv	a0,s1
    80004234:	00002097          	auipc	ra,0x2
    80004238:	286080e7          	jalr	646(ra) # 800064ba <release>
    8000423c:	6b42                	ld	s6,16(sp)
  return i;
}
    8000423e:	854e                	mv	a0,s3
    80004240:	60a6                	ld	ra,72(sp)
    80004242:	6406                	ld	s0,64(sp)
    80004244:	74e2                	ld	s1,56(sp)
    80004246:	7942                	ld	s2,48(sp)
    80004248:	79a2                	ld	s3,40(sp)
    8000424a:	7a02                	ld	s4,32(sp)
    8000424c:	6ae2                	ld	s5,24(sp)
    8000424e:	6161                	addi	sp,sp,80
    80004250:	8082                	ret

0000000080004252 <exec>:
static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);
void vmprint(pagetable_t pagetable, uint64 depth);

int
exec(char *path, char **argv)
{
    80004252:	df010113          	addi	sp,sp,-528
    80004256:	20113423          	sd	ra,520(sp)
    8000425a:	20813023          	sd	s0,512(sp)
    8000425e:	ffa6                	sd	s1,504(sp)
    80004260:	fbca                	sd	s2,496(sp)
    80004262:	0c00                	addi	s0,sp,528
    80004264:	892a                	mv	s2,a0
    80004266:	dea43c23          	sd	a0,-520(s0)
    8000426a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000426e:	ffffd097          	auipc	ra,0xffffd
    80004272:	cf2080e7          	jalr	-782(ra) # 80000f60 <myproc>
    80004276:	84aa                	mv	s1,a0

  begin_op();
    80004278:	fffff097          	auipc	ra,0xfffff
    8000427c:	460080e7          	jalr	1120(ra) # 800036d8 <begin_op>

  if((ip = namei(path)) == 0){
    80004280:	854a                	mv	a0,s2
    80004282:	fffff097          	auipc	ra,0xfffff
    80004286:	256080e7          	jalr	598(ra) # 800034d8 <namei>
    8000428a:	c135                	beqz	a0,800042ee <exec+0x9c>
    8000428c:	f3d2                	sd	s4,480(sp)
    8000428e:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004290:	fffff097          	auipc	ra,0xfffff
    80004294:	a76080e7          	jalr	-1418(ra) # 80002d06 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004298:	04000713          	li	a4,64
    8000429c:	4681                	li	a3,0
    8000429e:	e5040613          	addi	a2,s0,-432
    800042a2:	4581                	li	a1,0
    800042a4:	8552                	mv	a0,s4
    800042a6:	fffff097          	auipc	ra,0xfffff
    800042aa:	d18080e7          	jalr	-744(ra) # 80002fbe <readi>
    800042ae:	04000793          	li	a5,64
    800042b2:	00f51a63          	bne	a0,a5,800042c6 <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800042b6:	e5042703          	lw	a4,-432(s0)
    800042ba:	464c47b7          	lui	a5,0x464c4
    800042be:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042c2:	02f70c63          	beq	a4,a5,800042fa <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042c6:	8552                	mv	a0,s4
    800042c8:	fffff097          	auipc	ra,0xfffff
    800042cc:	ca4080e7          	jalr	-860(ra) # 80002f6c <iunlockput>
    end_op();
    800042d0:	fffff097          	auipc	ra,0xfffff
    800042d4:	482080e7          	jalr	1154(ra) # 80003752 <end_op>
  }
  return -1;
    800042d8:	557d                	li	a0,-1
    800042da:	7a1e                	ld	s4,480(sp)
}
    800042dc:	20813083          	ld	ra,520(sp)
    800042e0:	20013403          	ld	s0,512(sp)
    800042e4:	74fe                	ld	s1,504(sp)
    800042e6:	795e                	ld	s2,496(sp)
    800042e8:	21010113          	addi	sp,sp,528
    800042ec:	8082                	ret
    end_op();
    800042ee:	fffff097          	auipc	ra,0xfffff
    800042f2:	464080e7          	jalr	1124(ra) # 80003752 <end_op>
    return -1;
    800042f6:	557d                	li	a0,-1
    800042f8:	b7d5                	j	800042dc <exec+0x8a>
    800042fa:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800042fc:	8526                	mv	a0,s1
    800042fe:	ffffd097          	auipc	ra,0xffffd
    80004302:	d26080e7          	jalr	-730(ra) # 80001024 <proc_pagetable>
    80004306:	8b2a                	mv	s6,a0
    80004308:	32050263          	beqz	a0,8000462c <exec+0x3da>
    8000430c:	f7ce                	sd	s3,488(sp)
    8000430e:	efd6                	sd	s5,472(sp)
    80004310:	e7de                	sd	s7,456(sp)
    80004312:	e3e2                	sd	s8,448(sp)
    80004314:	ff66                	sd	s9,440(sp)
    80004316:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004318:	e7042d03          	lw	s10,-400(s0)
    8000431c:	e8845783          	lhu	a5,-376(s0)
    80004320:	14078563          	beqz	a5,8000446a <exec+0x218>
    80004324:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004326:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004328:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    8000432a:	6c85                	lui	s9,0x1
    8000432c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004330:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004334:	6a85                	lui	s5,0x1
    80004336:	a0b5                	j	800043a2 <exec+0x150>
      panic("loadseg: address should exist");
    80004338:	00004517          	auipc	a0,0x4
    8000433c:	26050513          	addi	a0,a0,608 # 80008598 <etext+0x598>
    80004340:	00002097          	auipc	ra,0x2
    80004344:	b4c080e7          	jalr	-1204(ra) # 80005e8c <panic>
    if(sz - i < PGSIZE)
    80004348:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000434a:	8726                	mv	a4,s1
    8000434c:	012c06bb          	addw	a3,s8,s2
    80004350:	4581                	li	a1,0
    80004352:	8552                	mv	a0,s4
    80004354:	fffff097          	auipc	ra,0xfffff
    80004358:	c6a080e7          	jalr	-918(ra) # 80002fbe <readi>
    8000435c:	2501                	sext.w	a0,a0
    8000435e:	28a49b63          	bne	s1,a0,800045f4 <exec+0x3a2>
  for(i = 0; i < sz; i += PGSIZE){
    80004362:	012a893b          	addw	s2,s5,s2
    80004366:	03397563          	bgeu	s2,s3,80004390 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    8000436a:	02091593          	slli	a1,s2,0x20
    8000436e:	9181                	srli	a1,a1,0x20
    80004370:	95de                	add	a1,a1,s7
    80004372:	855a                	mv	a0,s6
    80004374:	ffffc097          	auipc	ra,0xffffc
    80004378:	184080e7          	jalr	388(ra) # 800004f8 <walkaddr>
    8000437c:	862a                	mv	a2,a0
    if(pa == 0)
    8000437e:	dd4d                	beqz	a0,80004338 <exec+0xe6>
    if(sz - i < PGSIZE)
    80004380:	412984bb          	subw	s1,s3,s2
    80004384:	0004879b          	sext.w	a5,s1
    80004388:	fcfcf0e3          	bgeu	s9,a5,80004348 <exec+0xf6>
    8000438c:	84d6                	mv	s1,s5
    8000438e:	bf6d                	j	80004348 <exec+0xf6>
    sz = sz1;
    80004390:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004394:	2d85                	addiw	s11,s11,1
    80004396:	038d0d1b          	addiw	s10,s10,56
    8000439a:	e8845783          	lhu	a5,-376(s0)
    8000439e:	06fddf63          	bge	s11,a5,8000441c <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043a2:	2d01                	sext.w	s10,s10
    800043a4:	03800713          	li	a4,56
    800043a8:	86ea                	mv	a3,s10
    800043aa:	e1840613          	addi	a2,s0,-488
    800043ae:	4581                	li	a1,0
    800043b0:	8552                	mv	a0,s4
    800043b2:	fffff097          	auipc	ra,0xfffff
    800043b6:	c0c080e7          	jalr	-1012(ra) # 80002fbe <readi>
    800043ba:	03800793          	li	a5,56
    800043be:	20f51563          	bne	a0,a5,800045c8 <exec+0x376>
    if(ph.type != ELF_PROG_LOAD)
    800043c2:	e1842783          	lw	a5,-488(s0)
    800043c6:	4705                	li	a4,1
    800043c8:	fce796e3          	bne	a5,a4,80004394 <exec+0x142>
    if(ph.memsz < ph.filesz)
    800043cc:	e4043603          	ld	a2,-448(s0)
    800043d0:	e3843783          	ld	a5,-456(s0)
    800043d4:	1ef66e63          	bltu	a2,a5,800045d0 <exec+0x37e>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043d8:	e2843783          	ld	a5,-472(s0)
    800043dc:	963e                	add	a2,a2,a5
    800043de:	1ef66d63          	bltu	a2,a5,800045d8 <exec+0x386>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043e2:	85a6                	mv	a1,s1
    800043e4:	855a                	mv	a0,s6
    800043e6:	ffffc097          	auipc	ra,0xffffc
    800043ea:	4d6080e7          	jalr	1238(ra) # 800008bc <uvmalloc>
    800043ee:	e0a43423          	sd	a0,-504(s0)
    800043f2:	1e050763          	beqz	a0,800045e0 <exec+0x38e>
    if((ph.vaddr % PGSIZE) != 0)
    800043f6:	e2843b83          	ld	s7,-472(s0)
    800043fa:	df043783          	ld	a5,-528(s0)
    800043fe:	00fbf7b3          	and	a5,s7,a5
    80004402:	1e079763          	bnez	a5,800045f0 <exec+0x39e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004406:	e2042c03          	lw	s8,-480(s0)
    8000440a:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000440e:	00098463          	beqz	s3,80004416 <exec+0x1c4>
    80004412:	4901                	li	s2,0
    80004414:	bf99                	j	8000436a <exec+0x118>
    sz = sz1;
    80004416:	e0843483          	ld	s1,-504(s0)
    8000441a:	bfad                	j	80004394 <exec+0x142>
    8000441c:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000441e:	8552                	mv	a0,s4
    80004420:	fffff097          	auipc	ra,0xfffff
    80004424:	b4c080e7          	jalr	-1204(ra) # 80002f6c <iunlockput>
  end_op();
    80004428:	fffff097          	auipc	ra,0xfffff
    8000442c:	32a080e7          	jalr	810(ra) # 80003752 <end_op>
  p = myproc();
    80004430:	ffffd097          	auipc	ra,0xffffd
    80004434:	b30080e7          	jalr	-1232(ra) # 80000f60 <myproc>
    80004438:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000443a:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000443e:	6985                	lui	s3,0x1
    80004440:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004442:	99a6                	add	s3,s3,s1
    80004444:	77fd                	lui	a5,0xfffff
    80004446:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000444a:	6609                	lui	a2,0x2
    8000444c:	964e                	add	a2,a2,s3
    8000444e:	85ce                	mv	a1,s3
    80004450:	855a                	mv	a0,s6
    80004452:	ffffc097          	auipc	ra,0xffffc
    80004456:	46a080e7          	jalr	1130(ra) # 800008bc <uvmalloc>
    8000445a:	892a                	mv	s2,a0
    8000445c:	e0a43423          	sd	a0,-504(s0)
    80004460:	e519                	bnez	a0,8000446e <exec+0x21c>
  if(pagetable)
    80004462:	e1343423          	sd	s3,-504(s0)
    80004466:	4a01                	li	s4,0
    80004468:	a279                	j	800045f6 <exec+0x3a4>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000446a:	4481                	li	s1,0
    8000446c:	bf4d                	j	8000441e <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000446e:	75f9                	lui	a1,0xffffe
    80004470:	95aa                	add	a1,a1,a0
    80004472:	855a                	mv	a0,s6
    80004474:	ffffc097          	auipc	ra,0xffffc
    80004478:	672080e7          	jalr	1650(ra) # 80000ae6 <uvmclear>
  stackbase = sp - PGSIZE;
    8000447c:	7bfd                	lui	s7,0xfffff
    8000447e:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004480:	e0043783          	ld	a5,-512(s0)
    80004484:	6388                	ld	a0,0(a5)
    80004486:	c52d                	beqz	a0,800044f0 <exec+0x29e>
    80004488:	e9040993          	addi	s3,s0,-368
    8000448c:	f9040c13          	addi	s8,s0,-112
    80004490:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004492:	ffffc097          	auipc	ra,0xffffc
    80004496:	e5c080e7          	jalr	-420(ra) # 800002ee <strlen>
    8000449a:	0015079b          	addiw	a5,a0,1
    8000449e:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800044a2:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800044a6:	15796163          	bltu	s2,s7,800045e8 <exec+0x396>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800044aa:	e0043d03          	ld	s10,-512(s0)
    800044ae:	000d3a03          	ld	s4,0(s10)
    800044b2:	8552                	mv	a0,s4
    800044b4:	ffffc097          	auipc	ra,0xffffc
    800044b8:	e3a080e7          	jalr	-454(ra) # 800002ee <strlen>
    800044bc:	0015069b          	addiw	a3,a0,1
    800044c0:	8652                	mv	a2,s4
    800044c2:	85ca                	mv	a1,s2
    800044c4:	855a                	mv	a0,s6
    800044c6:	ffffc097          	auipc	ra,0xffffc
    800044ca:	652080e7          	jalr	1618(ra) # 80000b18 <copyout>
    800044ce:	10054f63          	bltz	a0,800045ec <exec+0x39a>
    ustack[argc] = sp;
    800044d2:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800044d6:	0485                	addi	s1,s1,1
    800044d8:	008d0793          	addi	a5,s10,8
    800044dc:	e0f43023          	sd	a5,-512(s0)
    800044e0:	008d3503          	ld	a0,8(s10)
    800044e4:	c909                	beqz	a0,800044f6 <exec+0x2a4>
    if(argc >= MAXARG)
    800044e6:	09a1                	addi	s3,s3,8
    800044e8:	fb8995e3          	bne	s3,s8,80004492 <exec+0x240>
  ip = 0;
    800044ec:	4a01                	li	s4,0
    800044ee:	a221                	j	800045f6 <exec+0x3a4>
  sp = sz;
    800044f0:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800044f4:	4481                	li	s1,0
  ustack[argc] = 0;
    800044f6:	00349793          	slli	a5,s1,0x3
    800044fa:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd5d50>
    800044fe:	97a2                	add	a5,a5,s0
    80004500:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004504:	00148693          	addi	a3,s1,1
    80004508:	068e                	slli	a3,a3,0x3
    8000450a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000450e:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004512:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004516:	f57966e3          	bltu	s2,s7,80004462 <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000451a:	e9040613          	addi	a2,s0,-368
    8000451e:	85ca                	mv	a1,s2
    80004520:	855a                	mv	a0,s6
    80004522:	ffffc097          	auipc	ra,0xffffc
    80004526:	5f6080e7          	jalr	1526(ra) # 80000b18 <copyout>
    8000452a:	10054363          	bltz	a0,80004630 <exec+0x3de>
  p->trapframe->a1 = sp;
    8000452e:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004532:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004536:	df843783          	ld	a5,-520(s0)
    8000453a:	0007c703          	lbu	a4,0(a5)
    8000453e:	cf11                	beqz	a4,8000455a <exec+0x308>
    80004540:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004542:	02f00693          	li	a3,47
    80004546:	a039                	j	80004554 <exec+0x302>
      last = s+1;
    80004548:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000454c:	0785                	addi	a5,a5,1
    8000454e:	fff7c703          	lbu	a4,-1(a5)
    80004552:	c701                	beqz	a4,8000455a <exec+0x308>
    if(*s == '/')
    80004554:	fed71ce3          	bne	a4,a3,8000454c <exec+0x2fa>
    80004558:	bfc5                	j	80004548 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    8000455a:	4641                	li	a2,16
    8000455c:	df843583          	ld	a1,-520(s0)
    80004560:	160a8513          	addi	a0,s5,352
    80004564:	ffffc097          	auipc	ra,0xffffc
    80004568:	d58080e7          	jalr	-680(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    8000456c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004570:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004574:	e0843783          	ld	a5,-504(s0)
    80004578:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000457c:	058ab783          	ld	a5,88(s5)
    80004580:	e6843703          	ld	a4,-408(s0)
    80004584:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004586:	058ab783          	ld	a5,88(s5)
    8000458a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000458e:	85e6                	mv	a1,s9
    80004590:	ffffd097          	auipc	ra,0xffffd
    80004594:	b8a080e7          	jalr	-1142(ra) # 8000111a <proc_freepagetable>
  if(p->pid == 1)
    80004598:	030aa703          	lw	a4,48(s5)
    8000459c:	4785                	li	a5,1
    8000459e:	00f70d63          	beq	a4,a5,800045b8 <exec+0x366>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800045a2:	0004851b          	sext.w	a0,s1
    800045a6:	79be                	ld	s3,488(sp)
    800045a8:	7a1e                	ld	s4,480(sp)
    800045aa:	6afe                	ld	s5,472(sp)
    800045ac:	6b5e                	ld	s6,464(sp)
    800045ae:	6bbe                	ld	s7,456(sp)
    800045b0:	6c1e                	ld	s8,448(sp)
    800045b2:	7cfa                	ld	s9,440(sp)
    800045b4:	7d5a                	ld	s10,432(sp)
    800045b6:	b31d                	j	800042dc <exec+0x8a>
    vmprint(p->pagetable, 0);
    800045b8:	4581                	li	a1,0
    800045ba:	050ab503          	ld	a0,80(s5)
    800045be:	ffffc097          	auipc	ra,0xffffc
    800045c2:	730080e7          	jalr	1840(ra) # 80000cee <vmprint>
    800045c6:	bff1                	j	800045a2 <exec+0x350>
    800045c8:	e0943423          	sd	s1,-504(s0)
    800045cc:	7dba                	ld	s11,424(sp)
    800045ce:	a025                	j	800045f6 <exec+0x3a4>
    800045d0:	e0943423          	sd	s1,-504(s0)
    800045d4:	7dba                	ld	s11,424(sp)
    800045d6:	a005                	j	800045f6 <exec+0x3a4>
    800045d8:	e0943423          	sd	s1,-504(s0)
    800045dc:	7dba                	ld	s11,424(sp)
    800045de:	a821                	j	800045f6 <exec+0x3a4>
    800045e0:	e0943423          	sd	s1,-504(s0)
    800045e4:	7dba                	ld	s11,424(sp)
    800045e6:	a801                	j	800045f6 <exec+0x3a4>
  ip = 0;
    800045e8:	4a01                	li	s4,0
    800045ea:	a031                	j	800045f6 <exec+0x3a4>
    800045ec:	4a01                	li	s4,0
  if(pagetable)
    800045ee:	a021                	j	800045f6 <exec+0x3a4>
    800045f0:	7dba                	ld	s11,424(sp)
    800045f2:	a011                	j	800045f6 <exec+0x3a4>
    800045f4:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800045f6:	e0843583          	ld	a1,-504(s0)
    800045fa:	855a                	mv	a0,s6
    800045fc:	ffffd097          	auipc	ra,0xffffd
    80004600:	b1e080e7          	jalr	-1250(ra) # 8000111a <proc_freepagetable>
  return -1;
    80004604:	557d                	li	a0,-1
  if(ip){
    80004606:	000a1b63          	bnez	s4,8000461c <exec+0x3ca>
    8000460a:	79be                	ld	s3,488(sp)
    8000460c:	7a1e                	ld	s4,480(sp)
    8000460e:	6afe                	ld	s5,472(sp)
    80004610:	6b5e                	ld	s6,464(sp)
    80004612:	6bbe                	ld	s7,456(sp)
    80004614:	6c1e                	ld	s8,448(sp)
    80004616:	7cfa                	ld	s9,440(sp)
    80004618:	7d5a                	ld	s10,432(sp)
    8000461a:	b1c9                	j	800042dc <exec+0x8a>
    8000461c:	79be                	ld	s3,488(sp)
    8000461e:	6afe                	ld	s5,472(sp)
    80004620:	6b5e                	ld	s6,464(sp)
    80004622:	6bbe                	ld	s7,456(sp)
    80004624:	6c1e                	ld	s8,448(sp)
    80004626:	7cfa                	ld	s9,440(sp)
    80004628:	7d5a                	ld	s10,432(sp)
    8000462a:	b971                	j	800042c6 <exec+0x74>
    8000462c:	6b5e                	ld	s6,464(sp)
    8000462e:	b961                	j	800042c6 <exec+0x74>
  sz = sz1;
    80004630:	e0843983          	ld	s3,-504(s0)
    80004634:	b53d                	j	80004462 <exec+0x210>

0000000080004636 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004636:	7179                	addi	sp,sp,-48
    80004638:	f406                	sd	ra,40(sp)
    8000463a:	f022                	sd	s0,32(sp)
    8000463c:	ec26                	sd	s1,24(sp)
    8000463e:	e84a                	sd	s2,16(sp)
    80004640:	1800                	addi	s0,sp,48
    80004642:	892e                	mv	s2,a1
    80004644:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004646:	fdc40593          	addi	a1,s0,-36
    8000464a:	ffffe097          	auipc	ra,0xffffe
    8000464e:	a80080e7          	jalr	-1408(ra) # 800020ca <argint>
    80004652:	04054063          	bltz	a0,80004692 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004656:	fdc42703          	lw	a4,-36(s0)
    8000465a:	47bd                	li	a5,15
    8000465c:	02e7ed63          	bltu	a5,a4,80004696 <argfd+0x60>
    80004660:	ffffd097          	auipc	ra,0xffffd
    80004664:	900080e7          	jalr	-1792(ra) # 80000f60 <myproc>
    80004668:	fdc42703          	lw	a4,-36(s0)
    8000466c:	01a70793          	addi	a5,a4,26
    80004670:	078e                	slli	a5,a5,0x3
    80004672:	953e                	add	a0,a0,a5
    80004674:	651c                	ld	a5,8(a0)
    80004676:	c395                	beqz	a5,8000469a <argfd+0x64>
    return -1;
  if(pfd)
    80004678:	00090463          	beqz	s2,80004680 <argfd+0x4a>
    *pfd = fd;
    8000467c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004680:	4501                	li	a0,0
  if(pf)
    80004682:	c091                	beqz	s1,80004686 <argfd+0x50>
    *pf = f;
    80004684:	e09c                	sd	a5,0(s1)
}
    80004686:	70a2                	ld	ra,40(sp)
    80004688:	7402                	ld	s0,32(sp)
    8000468a:	64e2                	ld	s1,24(sp)
    8000468c:	6942                	ld	s2,16(sp)
    8000468e:	6145                	addi	sp,sp,48
    80004690:	8082                	ret
    return -1;
    80004692:	557d                	li	a0,-1
    80004694:	bfcd                	j	80004686 <argfd+0x50>
    return -1;
    80004696:	557d                	li	a0,-1
    80004698:	b7fd                	j	80004686 <argfd+0x50>
    8000469a:	557d                	li	a0,-1
    8000469c:	b7ed                	j	80004686 <argfd+0x50>

000000008000469e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000469e:	1101                	addi	sp,sp,-32
    800046a0:	ec06                	sd	ra,24(sp)
    800046a2:	e822                	sd	s0,16(sp)
    800046a4:	e426                	sd	s1,8(sp)
    800046a6:	1000                	addi	s0,sp,32
    800046a8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046aa:	ffffd097          	auipc	ra,0xffffd
    800046ae:	8b6080e7          	jalr	-1866(ra) # 80000f60 <myproc>
    800046b2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046b4:	0d850793          	addi	a5,a0,216
    800046b8:	4501                	li	a0,0
    800046ba:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046bc:	6398                	ld	a4,0(a5)
    800046be:	cb19                	beqz	a4,800046d4 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800046c0:	2505                	addiw	a0,a0,1
    800046c2:	07a1                	addi	a5,a5,8
    800046c4:	fed51ce3          	bne	a0,a3,800046bc <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046c8:	557d                	li	a0,-1
}
    800046ca:	60e2                	ld	ra,24(sp)
    800046cc:	6442                	ld	s0,16(sp)
    800046ce:	64a2                	ld	s1,8(sp)
    800046d0:	6105                	addi	sp,sp,32
    800046d2:	8082                	ret
      p->ofile[fd] = f;
    800046d4:	01a50793          	addi	a5,a0,26
    800046d8:	078e                	slli	a5,a5,0x3
    800046da:	963e                	add	a2,a2,a5
    800046dc:	e604                	sd	s1,8(a2)
      return fd;
    800046de:	b7f5                	j	800046ca <fdalloc+0x2c>

00000000800046e0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046e0:	715d                	addi	sp,sp,-80
    800046e2:	e486                	sd	ra,72(sp)
    800046e4:	e0a2                	sd	s0,64(sp)
    800046e6:	fc26                	sd	s1,56(sp)
    800046e8:	f84a                	sd	s2,48(sp)
    800046ea:	f44e                	sd	s3,40(sp)
    800046ec:	f052                	sd	s4,32(sp)
    800046ee:	ec56                	sd	s5,24(sp)
    800046f0:	0880                	addi	s0,sp,80
    800046f2:	8aae                	mv	s5,a1
    800046f4:	8a32                	mv	s4,a2
    800046f6:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800046f8:	fb040593          	addi	a1,s0,-80
    800046fc:	fffff097          	auipc	ra,0xfffff
    80004700:	dfa080e7          	jalr	-518(ra) # 800034f6 <nameiparent>
    80004704:	892a                	mv	s2,a0
    80004706:	12050c63          	beqz	a0,8000483e <create+0x15e>
    return 0;

  ilock(dp);
    8000470a:	ffffe097          	auipc	ra,0xffffe
    8000470e:	5fc080e7          	jalr	1532(ra) # 80002d06 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004712:	4601                	li	a2,0
    80004714:	fb040593          	addi	a1,s0,-80
    80004718:	854a                	mv	a0,s2
    8000471a:	fffff097          	auipc	ra,0xfffff
    8000471e:	aec080e7          	jalr	-1300(ra) # 80003206 <dirlookup>
    80004722:	84aa                	mv	s1,a0
    80004724:	c539                	beqz	a0,80004772 <create+0x92>
    iunlockput(dp);
    80004726:	854a                	mv	a0,s2
    80004728:	fffff097          	auipc	ra,0xfffff
    8000472c:	844080e7          	jalr	-1980(ra) # 80002f6c <iunlockput>
    ilock(ip);
    80004730:	8526                	mv	a0,s1
    80004732:	ffffe097          	auipc	ra,0xffffe
    80004736:	5d4080e7          	jalr	1492(ra) # 80002d06 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000473a:	4789                	li	a5,2
    8000473c:	02fa9463          	bne	s5,a5,80004764 <create+0x84>
    80004740:	0444d783          	lhu	a5,68(s1)
    80004744:	37f9                	addiw	a5,a5,-2
    80004746:	17c2                	slli	a5,a5,0x30
    80004748:	93c1                	srli	a5,a5,0x30
    8000474a:	4705                	li	a4,1
    8000474c:	00f76c63          	bltu	a4,a5,80004764 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004750:	8526                	mv	a0,s1
    80004752:	60a6                	ld	ra,72(sp)
    80004754:	6406                	ld	s0,64(sp)
    80004756:	74e2                	ld	s1,56(sp)
    80004758:	7942                	ld	s2,48(sp)
    8000475a:	79a2                	ld	s3,40(sp)
    8000475c:	7a02                	ld	s4,32(sp)
    8000475e:	6ae2                	ld	s5,24(sp)
    80004760:	6161                	addi	sp,sp,80
    80004762:	8082                	ret
    iunlockput(ip);
    80004764:	8526                	mv	a0,s1
    80004766:	fffff097          	auipc	ra,0xfffff
    8000476a:	806080e7          	jalr	-2042(ra) # 80002f6c <iunlockput>
    return 0;
    8000476e:	4481                	li	s1,0
    80004770:	b7c5                	j	80004750 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004772:	85d6                	mv	a1,s5
    80004774:	00092503          	lw	a0,0(s2)
    80004778:	ffffe097          	auipc	ra,0xffffe
    8000477c:	3fa080e7          	jalr	1018(ra) # 80002b72 <ialloc>
    80004780:	84aa                	mv	s1,a0
    80004782:	c139                	beqz	a0,800047c8 <create+0xe8>
  ilock(ip);
    80004784:	ffffe097          	auipc	ra,0xffffe
    80004788:	582080e7          	jalr	1410(ra) # 80002d06 <ilock>
  ip->major = major;
    8000478c:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    80004790:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    80004794:	4985                	li	s3,1
    80004796:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    8000479a:	8526                	mv	a0,s1
    8000479c:	ffffe097          	auipc	ra,0xffffe
    800047a0:	49e080e7          	jalr	1182(ra) # 80002c3a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047a4:	033a8a63          	beq	s5,s3,800047d8 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    800047a8:	40d0                	lw	a2,4(s1)
    800047aa:	fb040593          	addi	a1,s0,-80
    800047ae:	854a                	mv	a0,s2
    800047b0:	fffff097          	auipc	ra,0xfffff
    800047b4:	c66080e7          	jalr	-922(ra) # 80003416 <dirlink>
    800047b8:	06054b63          	bltz	a0,8000482e <create+0x14e>
  iunlockput(dp);
    800047bc:	854a                	mv	a0,s2
    800047be:	ffffe097          	auipc	ra,0xffffe
    800047c2:	7ae080e7          	jalr	1966(ra) # 80002f6c <iunlockput>
  return ip;
    800047c6:	b769                	j	80004750 <create+0x70>
    panic("create: ialloc");
    800047c8:	00004517          	auipc	a0,0x4
    800047cc:	df050513          	addi	a0,a0,-528 # 800085b8 <etext+0x5b8>
    800047d0:	00001097          	auipc	ra,0x1
    800047d4:	6bc080e7          	jalr	1724(ra) # 80005e8c <panic>
    dp->nlink++;  // for ".."
    800047d8:	04a95783          	lhu	a5,74(s2)
    800047dc:	2785                	addiw	a5,a5,1
    800047de:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800047e2:	854a                	mv	a0,s2
    800047e4:	ffffe097          	auipc	ra,0xffffe
    800047e8:	456080e7          	jalr	1110(ra) # 80002c3a <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047ec:	40d0                	lw	a2,4(s1)
    800047ee:	00004597          	auipc	a1,0x4
    800047f2:	dda58593          	addi	a1,a1,-550 # 800085c8 <etext+0x5c8>
    800047f6:	8526                	mv	a0,s1
    800047f8:	fffff097          	auipc	ra,0xfffff
    800047fc:	c1e080e7          	jalr	-994(ra) # 80003416 <dirlink>
    80004800:	00054f63          	bltz	a0,8000481e <create+0x13e>
    80004804:	00492603          	lw	a2,4(s2)
    80004808:	00004597          	auipc	a1,0x4
    8000480c:	97858593          	addi	a1,a1,-1672 # 80008180 <etext+0x180>
    80004810:	8526                	mv	a0,s1
    80004812:	fffff097          	auipc	ra,0xfffff
    80004816:	c04080e7          	jalr	-1020(ra) # 80003416 <dirlink>
    8000481a:	f80557e3          	bgez	a0,800047a8 <create+0xc8>
      panic("create dots");
    8000481e:	00004517          	auipc	a0,0x4
    80004822:	db250513          	addi	a0,a0,-590 # 800085d0 <etext+0x5d0>
    80004826:	00001097          	auipc	ra,0x1
    8000482a:	666080e7          	jalr	1638(ra) # 80005e8c <panic>
    panic("create: dirlink");
    8000482e:	00004517          	auipc	a0,0x4
    80004832:	db250513          	addi	a0,a0,-590 # 800085e0 <etext+0x5e0>
    80004836:	00001097          	auipc	ra,0x1
    8000483a:	656080e7          	jalr	1622(ra) # 80005e8c <panic>
    return 0;
    8000483e:	84aa                	mv	s1,a0
    80004840:	bf01                	j	80004750 <create+0x70>

0000000080004842 <sys_dup>:
{
    80004842:	7179                	addi	sp,sp,-48
    80004844:	f406                	sd	ra,40(sp)
    80004846:	f022                	sd	s0,32(sp)
    80004848:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000484a:	fd840613          	addi	a2,s0,-40
    8000484e:	4581                	li	a1,0
    80004850:	4501                	li	a0,0
    80004852:	00000097          	auipc	ra,0x0
    80004856:	de4080e7          	jalr	-540(ra) # 80004636 <argfd>
    return -1;
    8000485a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000485c:	02054763          	bltz	a0,8000488a <sys_dup+0x48>
    80004860:	ec26                	sd	s1,24(sp)
    80004862:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004864:	fd843903          	ld	s2,-40(s0)
    80004868:	854a                	mv	a0,s2
    8000486a:	00000097          	auipc	ra,0x0
    8000486e:	e34080e7          	jalr	-460(ra) # 8000469e <fdalloc>
    80004872:	84aa                	mv	s1,a0
    return -1;
    80004874:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004876:	00054f63          	bltz	a0,80004894 <sys_dup+0x52>
  filedup(f);
    8000487a:	854a                	mv	a0,s2
    8000487c:	fffff097          	auipc	ra,0xfffff
    80004880:	2d4080e7          	jalr	724(ra) # 80003b50 <filedup>
  return fd;
    80004884:	87a6                	mv	a5,s1
    80004886:	64e2                	ld	s1,24(sp)
    80004888:	6942                	ld	s2,16(sp)
}
    8000488a:	853e                	mv	a0,a5
    8000488c:	70a2                	ld	ra,40(sp)
    8000488e:	7402                	ld	s0,32(sp)
    80004890:	6145                	addi	sp,sp,48
    80004892:	8082                	ret
    80004894:	64e2                	ld	s1,24(sp)
    80004896:	6942                	ld	s2,16(sp)
    80004898:	bfcd                	j	8000488a <sys_dup+0x48>

000000008000489a <sys_read>:
{
    8000489a:	7179                	addi	sp,sp,-48
    8000489c:	f406                	sd	ra,40(sp)
    8000489e:	f022                	sd	s0,32(sp)
    800048a0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048a2:	fe840613          	addi	a2,s0,-24
    800048a6:	4581                	li	a1,0
    800048a8:	4501                	li	a0,0
    800048aa:	00000097          	auipc	ra,0x0
    800048ae:	d8c080e7          	jalr	-628(ra) # 80004636 <argfd>
    return -1;
    800048b2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048b4:	04054163          	bltz	a0,800048f6 <sys_read+0x5c>
    800048b8:	fe440593          	addi	a1,s0,-28
    800048bc:	4509                	li	a0,2
    800048be:	ffffe097          	auipc	ra,0xffffe
    800048c2:	80c080e7          	jalr	-2036(ra) # 800020ca <argint>
    return -1;
    800048c6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048c8:	02054763          	bltz	a0,800048f6 <sys_read+0x5c>
    800048cc:	fd840593          	addi	a1,s0,-40
    800048d0:	4505                	li	a0,1
    800048d2:	ffffe097          	auipc	ra,0xffffe
    800048d6:	81a080e7          	jalr	-2022(ra) # 800020ec <argaddr>
    return -1;
    800048da:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048dc:	00054d63          	bltz	a0,800048f6 <sys_read+0x5c>
  return fileread(f, p, n);
    800048e0:	fe442603          	lw	a2,-28(s0)
    800048e4:	fd843583          	ld	a1,-40(s0)
    800048e8:	fe843503          	ld	a0,-24(s0)
    800048ec:	fffff097          	auipc	ra,0xfffff
    800048f0:	40a080e7          	jalr	1034(ra) # 80003cf6 <fileread>
    800048f4:	87aa                	mv	a5,a0
}
    800048f6:	853e                	mv	a0,a5
    800048f8:	70a2                	ld	ra,40(sp)
    800048fa:	7402                	ld	s0,32(sp)
    800048fc:	6145                	addi	sp,sp,48
    800048fe:	8082                	ret

0000000080004900 <sys_write>:
{
    80004900:	7179                	addi	sp,sp,-48
    80004902:	f406                	sd	ra,40(sp)
    80004904:	f022                	sd	s0,32(sp)
    80004906:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004908:	fe840613          	addi	a2,s0,-24
    8000490c:	4581                	li	a1,0
    8000490e:	4501                	li	a0,0
    80004910:	00000097          	auipc	ra,0x0
    80004914:	d26080e7          	jalr	-730(ra) # 80004636 <argfd>
    return -1;
    80004918:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000491a:	04054163          	bltz	a0,8000495c <sys_write+0x5c>
    8000491e:	fe440593          	addi	a1,s0,-28
    80004922:	4509                	li	a0,2
    80004924:	ffffd097          	auipc	ra,0xffffd
    80004928:	7a6080e7          	jalr	1958(ra) # 800020ca <argint>
    return -1;
    8000492c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000492e:	02054763          	bltz	a0,8000495c <sys_write+0x5c>
    80004932:	fd840593          	addi	a1,s0,-40
    80004936:	4505                	li	a0,1
    80004938:	ffffd097          	auipc	ra,0xffffd
    8000493c:	7b4080e7          	jalr	1972(ra) # 800020ec <argaddr>
    return -1;
    80004940:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004942:	00054d63          	bltz	a0,8000495c <sys_write+0x5c>
  return filewrite(f, p, n);
    80004946:	fe442603          	lw	a2,-28(s0)
    8000494a:	fd843583          	ld	a1,-40(s0)
    8000494e:	fe843503          	ld	a0,-24(s0)
    80004952:	fffff097          	auipc	ra,0xfffff
    80004956:	476080e7          	jalr	1142(ra) # 80003dc8 <filewrite>
    8000495a:	87aa                	mv	a5,a0
}
    8000495c:	853e                	mv	a0,a5
    8000495e:	70a2                	ld	ra,40(sp)
    80004960:	7402                	ld	s0,32(sp)
    80004962:	6145                	addi	sp,sp,48
    80004964:	8082                	ret

0000000080004966 <sys_close>:
{
    80004966:	1101                	addi	sp,sp,-32
    80004968:	ec06                	sd	ra,24(sp)
    8000496a:	e822                	sd	s0,16(sp)
    8000496c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000496e:	fe040613          	addi	a2,s0,-32
    80004972:	fec40593          	addi	a1,s0,-20
    80004976:	4501                	li	a0,0
    80004978:	00000097          	auipc	ra,0x0
    8000497c:	cbe080e7          	jalr	-834(ra) # 80004636 <argfd>
    return -1;
    80004980:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004982:	02054463          	bltz	a0,800049aa <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004986:	ffffc097          	auipc	ra,0xffffc
    8000498a:	5da080e7          	jalr	1498(ra) # 80000f60 <myproc>
    8000498e:	fec42783          	lw	a5,-20(s0)
    80004992:	07e9                	addi	a5,a5,26
    80004994:	078e                	slli	a5,a5,0x3
    80004996:	953e                	add	a0,a0,a5
    80004998:	00053423          	sd	zero,8(a0)
  fileclose(f);
    8000499c:	fe043503          	ld	a0,-32(s0)
    800049a0:	fffff097          	auipc	ra,0xfffff
    800049a4:	202080e7          	jalr	514(ra) # 80003ba2 <fileclose>
  return 0;
    800049a8:	4781                	li	a5,0
}
    800049aa:	853e                	mv	a0,a5
    800049ac:	60e2                	ld	ra,24(sp)
    800049ae:	6442                	ld	s0,16(sp)
    800049b0:	6105                	addi	sp,sp,32
    800049b2:	8082                	ret

00000000800049b4 <sys_fstat>:
{
    800049b4:	1101                	addi	sp,sp,-32
    800049b6:	ec06                	sd	ra,24(sp)
    800049b8:	e822                	sd	s0,16(sp)
    800049ba:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049bc:	fe840613          	addi	a2,s0,-24
    800049c0:	4581                	li	a1,0
    800049c2:	4501                	li	a0,0
    800049c4:	00000097          	auipc	ra,0x0
    800049c8:	c72080e7          	jalr	-910(ra) # 80004636 <argfd>
    return -1;
    800049cc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049ce:	02054563          	bltz	a0,800049f8 <sys_fstat+0x44>
    800049d2:	fe040593          	addi	a1,s0,-32
    800049d6:	4505                	li	a0,1
    800049d8:	ffffd097          	auipc	ra,0xffffd
    800049dc:	714080e7          	jalr	1812(ra) # 800020ec <argaddr>
    return -1;
    800049e0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049e2:	00054b63          	bltz	a0,800049f8 <sys_fstat+0x44>
  return filestat(f, st);
    800049e6:	fe043583          	ld	a1,-32(s0)
    800049ea:	fe843503          	ld	a0,-24(s0)
    800049ee:	fffff097          	auipc	ra,0xfffff
    800049f2:	296080e7          	jalr	662(ra) # 80003c84 <filestat>
    800049f6:	87aa                	mv	a5,a0
}
    800049f8:	853e                	mv	a0,a5
    800049fa:	60e2                	ld	ra,24(sp)
    800049fc:	6442                	ld	s0,16(sp)
    800049fe:	6105                	addi	sp,sp,32
    80004a00:	8082                	ret

0000000080004a02 <sys_link>:
{
    80004a02:	7169                	addi	sp,sp,-304
    80004a04:	f606                	sd	ra,296(sp)
    80004a06:	f222                	sd	s0,288(sp)
    80004a08:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a0a:	08000613          	li	a2,128
    80004a0e:	ed040593          	addi	a1,s0,-304
    80004a12:	4501                	li	a0,0
    80004a14:	ffffd097          	auipc	ra,0xffffd
    80004a18:	6fa080e7          	jalr	1786(ra) # 8000210e <argstr>
    return -1;
    80004a1c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a1e:	12054663          	bltz	a0,80004b4a <sys_link+0x148>
    80004a22:	08000613          	li	a2,128
    80004a26:	f5040593          	addi	a1,s0,-176
    80004a2a:	4505                	li	a0,1
    80004a2c:	ffffd097          	auipc	ra,0xffffd
    80004a30:	6e2080e7          	jalr	1762(ra) # 8000210e <argstr>
    return -1;
    80004a34:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a36:	10054a63          	bltz	a0,80004b4a <sys_link+0x148>
    80004a3a:	ee26                	sd	s1,280(sp)
  begin_op();
    80004a3c:	fffff097          	auipc	ra,0xfffff
    80004a40:	c9c080e7          	jalr	-868(ra) # 800036d8 <begin_op>
  if((ip = namei(old)) == 0){
    80004a44:	ed040513          	addi	a0,s0,-304
    80004a48:	fffff097          	auipc	ra,0xfffff
    80004a4c:	a90080e7          	jalr	-1392(ra) # 800034d8 <namei>
    80004a50:	84aa                	mv	s1,a0
    80004a52:	c949                	beqz	a0,80004ae4 <sys_link+0xe2>
  ilock(ip);
    80004a54:	ffffe097          	auipc	ra,0xffffe
    80004a58:	2b2080e7          	jalr	690(ra) # 80002d06 <ilock>
  if(ip->type == T_DIR){
    80004a5c:	04449703          	lh	a4,68(s1)
    80004a60:	4785                	li	a5,1
    80004a62:	08f70863          	beq	a4,a5,80004af2 <sys_link+0xf0>
    80004a66:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004a68:	04a4d783          	lhu	a5,74(s1)
    80004a6c:	2785                	addiw	a5,a5,1
    80004a6e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a72:	8526                	mv	a0,s1
    80004a74:	ffffe097          	auipc	ra,0xffffe
    80004a78:	1c6080e7          	jalr	454(ra) # 80002c3a <iupdate>
  iunlock(ip);
    80004a7c:	8526                	mv	a0,s1
    80004a7e:	ffffe097          	auipc	ra,0xffffe
    80004a82:	34e080e7          	jalr	846(ra) # 80002dcc <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a86:	fd040593          	addi	a1,s0,-48
    80004a8a:	f5040513          	addi	a0,s0,-176
    80004a8e:	fffff097          	auipc	ra,0xfffff
    80004a92:	a68080e7          	jalr	-1432(ra) # 800034f6 <nameiparent>
    80004a96:	892a                	mv	s2,a0
    80004a98:	cd35                	beqz	a0,80004b14 <sys_link+0x112>
  ilock(dp);
    80004a9a:	ffffe097          	auipc	ra,0xffffe
    80004a9e:	26c080e7          	jalr	620(ra) # 80002d06 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004aa2:	00092703          	lw	a4,0(s2)
    80004aa6:	409c                	lw	a5,0(s1)
    80004aa8:	06f71163          	bne	a4,a5,80004b0a <sys_link+0x108>
    80004aac:	40d0                	lw	a2,4(s1)
    80004aae:	fd040593          	addi	a1,s0,-48
    80004ab2:	854a                	mv	a0,s2
    80004ab4:	fffff097          	auipc	ra,0xfffff
    80004ab8:	962080e7          	jalr	-1694(ra) # 80003416 <dirlink>
    80004abc:	04054763          	bltz	a0,80004b0a <sys_link+0x108>
  iunlockput(dp);
    80004ac0:	854a                	mv	a0,s2
    80004ac2:	ffffe097          	auipc	ra,0xffffe
    80004ac6:	4aa080e7          	jalr	1194(ra) # 80002f6c <iunlockput>
  iput(ip);
    80004aca:	8526                	mv	a0,s1
    80004acc:	ffffe097          	auipc	ra,0xffffe
    80004ad0:	3f8080e7          	jalr	1016(ra) # 80002ec4 <iput>
  end_op();
    80004ad4:	fffff097          	auipc	ra,0xfffff
    80004ad8:	c7e080e7          	jalr	-898(ra) # 80003752 <end_op>
  return 0;
    80004adc:	4781                	li	a5,0
    80004ade:	64f2                	ld	s1,280(sp)
    80004ae0:	6952                	ld	s2,272(sp)
    80004ae2:	a0a5                	j	80004b4a <sys_link+0x148>
    end_op();
    80004ae4:	fffff097          	auipc	ra,0xfffff
    80004ae8:	c6e080e7          	jalr	-914(ra) # 80003752 <end_op>
    return -1;
    80004aec:	57fd                	li	a5,-1
    80004aee:	64f2                	ld	s1,280(sp)
    80004af0:	a8a9                	j	80004b4a <sys_link+0x148>
    iunlockput(ip);
    80004af2:	8526                	mv	a0,s1
    80004af4:	ffffe097          	auipc	ra,0xffffe
    80004af8:	478080e7          	jalr	1144(ra) # 80002f6c <iunlockput>
    end_op();
    80004afc:	fffff097          	auipc	ra,0xfffff
    80004b00:	c56080e7          	jalr	-938(ra) # 80003752 <end_op>
    return -1;
    80004b04:	57fd                	li	a5,-1
    80004b06:	64f2                	ld	s1,280(sp)
    80004b08:	a089                	j	80004b4a <sys_link+0x148>
    iunlockput(dp);
    80004b0a:	854a                	mv	a0,s2
    80004b0c:	ffffe097          	auipc	ra,0xffffe
    80004b10:	460080e7          	jalr	1120(ra) # 80002f6c <iunlockput>
  ilock(ip);
    80004b14:	8526                	mv	a0,s1
    80004b16:	ffffe097          	auipc	ra,0xffffe
    80004b1a:	1f0080e7          	jalr	496(ra) # 80002d06 <ilock>
  ip->nlink--;
    80004b1e:	04a4d783          	lhu	a5,74(s1)
    80004b22:	37fd                	addiw	a5,a5,-1
    80004b24:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b28:	8526                	mv	a0,s1
    80004b2a:	ffffe097          	auipc	ra,0xffffe
    80004b2e:	110080e7          	jalr	272(ra) # 80002c3a <iupdate>
  iunlockput(ip);
    80004b32:	8526                	mv	a0,s1
    80004b34:	ffffe097          	auipc	ra,0xffffe
    80004b38:	438080e7          	jalr	1080(ra) # 80002f6c <iunlockput>
  end_op();
    80004b3c:	fffff097          	auipc	ra,0xfffff
    80004b40:	c16080e7          	jalr	-1002(ra) # 80003752 <end_op>
  return -1;
    80004b44:	57fd                	li	a5,-1
    80004b46:	64f2                	ld	s1,280(sp)
    80004b48:	6952                	ld	s2,272(sp)
}
    80004b4a:	853e                	mv	a0,a5
    80004b4c:	70b2                	ld	ra,296(sp)
    80004b4e:	7412                	ld	s0,288(sp)
    80004b50:	6155                	addi	sp,sp,304
    80004b52:	8082                	ret

0000000080004b54 <sys_unlink>:
{
    80004b54:	7151                	addi	sp,sp,-240
    80004b56:	f586                	sd	ra,232(sp)
    80004b58:	f1a2                	sd	s0,224(sp)
    80004b5a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b5c:	08000613          	li	a2,128
    80004b60:	f3040593          	addi	a1,s0,-208
    80004b64:	4501                	li	a0,0
    80004b66:	ffffd097          	auipc	ra,0xffffd
    80004b6a:	5a8080e7          	jalr	1448(ra) # 8000210e <argstr>
    80004b6e:	1a054a63          	bltz	a0,80004d22 <sys_unlink+0x1ce>
    80004b72:	eda6                	sd	s1,216(sp)
  begin_op();
    80004b74:	fffff097          	auipc	ra,0xfffff
    80004b78:	b64080e7          	jalr	-1180(ra) # 800036d8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b7c:	fb040593          	addi	a1,s0,-80
    80004b80:	f3040513          	addi	a0,s0,-208
    80004b84:	fffff097          	auipc	ra,0xfffff
    80004b88:	972080e7          	jalr	-1678(ra) # 800034f6 <nameiparent>
    80004b8c:	84aa                	mv	s1,a0
    80004b8e:	cd71                	beqz	a0,80004c6a <sys_unlink+0x116>
  ilock(dp);
    80004b90:	ffffe097          	auipc	ra,0xffffe
    80004b94:	176080e7          	jalr	374(ra) # 80002d06 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b98:	00004597          	auipc	a1,0x4
    80004b9c:	a3058593          	addi	a1,a1,-1488 # 800085c8 <etext+0x5c8>
    80004ba0:	fb040513          	addi	a0,s0,-80
    80004ba4:	ffffe097          	auipc	ra,0xffffe
    80004ba8:	648080e7          	jalr	1608(ra) # 800031ec <namecmp>
    80004bac:	14050c63          	beqz	a0,80004d04 <sys_unlink+0x1b0>
    80004bb0:	00003597          	auipc	a1,0x3
    80004bb4:	5d058593          	addi	a1,a1,1488 # 80008180 <etext+0x180>
    80004bb8:	fb040513          	addi	a0,s0,-80
    80004bbc:	ffffe097          	auipc	ra,0xffffe
    80004bc0:	630080e7          	jalr	1584(ra) # 800031ec <namecmp>
    80004bc4:	14050063          	beqz	a0,80004d04 <sys_unlink+0x1b0>
    80004bc8:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004bca:	f2c40613          	addi	a2,s0,-212
    80004bce:	fb040593          	addi	a1,s0,-80
    80004bd2:	8526                	mv	a0,s1
    80004bd4:	ffffe097          	auipc	ra,0xffffe
    80004bd8:	632080e7          	jalr	1586(ra) # 80003206 <dirlookup>
    80004bdc:	892a                	mv	s2,a0
    80004bde:	12050263          	beqz	a0,80004d02 <sys_unlink+0x1ae>
  ilock(ip);
    80004be2:	ffffe097          	auipc	ra,0xffffe
    80004be6:	124080e7          	jalr	292(ra) # 80002d06 <ilock>
  if(ip->nlink < 1)
    80004bea:	04a91783          	lh	a5,74(s2)
    80004bee:	08f05563          	blez	a5,80004c78 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004bf2:	04491703          	lh	a4,68(s2)
    80004bf6:	4785                	li	a5,1
    80004bf8:	08f70963          	beq	a4,a5,80004c8a <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004bfc:	4641                	li	a2,16
    80004bfe:	4581                	li	a1,0
    80004c00:	fc040513          	addi	a0,s0,-64
    80004c04:	ffffb097          	auipc	ra,0xffffb
    80004c08:	576080e7          	jalr	1398(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c0c:	4741                	li	a4,16
    80004c0e:	f2c42683          	lw	a3,-212(s0)
    80004c12:	fc040613          	addi	a2,s0,-64
    80004c16:	4581                	li	a1,0
    80004c18:	8526                	mv	a0,s1
    80004c1a:	ffffe097          	auipc	ra,0xffffe
    80004c1e:	4a8080e7          	jalr	1192(ra) # 800030c2 <writei>
    80004c22:	47c1                	li	a5,16
    80004c24:	0af51b63          	bne	a0,a5,80004cda <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004c28:	04491703          	lh	a4,68(s2)
    80004c2c:	4785                	li	a5,1
    80004c2e:	0af70f63          	beq	a4,a5,80004cec <sys_unlink+0x198>
  iunlockput(dp);
    80004c32:	8526                	mv	a0,s1
    80004c34:	ffffe097          	auipc	ra,0xffffe
    80004c38:	338080e7          	jalr	824(ra) # 80002f6c <iunlockput>
  ip->nlink--;
    80004c3c:	04a95783          	lhu	a5,74(s2)
    80004c40:	37fd                	addiw	a5,a5,-1
    80004c42:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c46:	854a                	mv	a0,s2
    80004c48:	ffffe097          	auipc	ra,0xffffe
    80004c4c:	ff2080e7          	jalr	-14(ra) # 80002c3a <iupdate>
  iunlockput(ip);
    80004c50:	854a                	mv	a0,s2
    80004c52:	ffffe097          	auipc	ra,0xffffe
    80004c56:	31a080e7          	jalr	794(ra) # 80002f6c <iunlockput>
  end_op();
    80004c5a:	fffff097          	auipc	ra,0xfffff
    80004c5e:	af8080e7          	jalr	-1288(ra) # 80003752 <end_op>
  return 0;
    80004c62:	4501                	li	a0,0
    80004c64:	64ee                	ld	s1,216(sp)
    80004c66:	694e                	ld	s2,208(sp)
    80004c68:	a84d                	j	80004d1a <sys_unlink+0x1c6>
    end_op();
    80004c6a:	fffff097          	auipc	ra,0xfffff
    80004c6e:	ae8080e7          	jalr	-1304(ra) # 80003752 <end_op>
    return -1;
    80004c72:	557d                	li	a0,-1
    80004c74:	64ee                	ld	s1,216(sp)
    80004c76:	a055                	j	80004d1a <sys_unlink+0x1c6>
    80004c78:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004c7a:	00004517          	auipc	a0,0x4
    80004c7e:	97650513          	addi	a0,a0,-1674 # 800085f0 <etext+0x5f0>
    80004c82:	00001097          	auipc	ra,0x1
    80004c86:	20a080e7          	jalr	522(ra) # 80005e8c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c8a:	04c92703          	lw	a4,76(s2)
    80004c8e:	02000793          	li	a5,32
    80004c92:	f6e7f5e3          	bgeu	a5,a4,80004bfc <sys_unlink+0xa8>
    80004c96:	e5ce                	sd	s3,200(sp)
    80004c98:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c9c:	4741                	li	a4,16
    80004c9e:	86ce                	mv	a3,s3
    80004ca0:	f1840613          	addi	a2,s0,-232
    80004ca4:	4581                	li	a1,0
    80004ca6:	854a                	mv	a0,s2
    80004ca8:	ffffe097          	auipc	ra,0xffffe
    80004cac:	316080e7          	jalr	790(ra) # 80002fbe <readi>
    80004cb0:	47c1                	li	a5,16
    80004cb2:	00f51c63          	bne	a0,a5,80004cca <sys_unlink+0x176>
    if(de.inum != 0)
    80004cb6:	f1845783          	lhu	a5,-232(s0)
    80004cba:	e7b5                	bnez	a5,80004d26 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cbc:	29c1                	addiw	s3,s3,16
    80004cbe:	04c92783          	lw	a5,76(s2)
    80004cc2:	fcf9ede3          	bltu	s3,a5,80004c9c <sys_unlink+0x148>
    80004cc6:	69ae                	ld	s3,200(sp)
    80004cc8:	bf15                	j	80004bfc <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004cca:	00004517          	auipc	a0,0x4
    80004cce:	93e50513          	addi	a0,a0,-1730 # 80008608 <etext+0x608>
    80004cd2:	00001097          	auipc	ra,0x1
    80004cd6:	1ba080e7          	jalr	442(ra) # 80005e8c <panic>
    80004cda:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004cdc:	00004517          	auipc	a0,0x4
    80004ce0:	94450513          	addi	a0,a0,-1724 # 80008620 <etext+0x620>
    80004ce4:	00001097          	auipc	ra,0x1
    80004ce8:	1a8080e7          	jalr	424(ra) # 80005e8c <panic>
    dp->nlink--;
    80004cec:	04a4d783          	lhu	a5,74(s1)
    80004cf0:	37fd                	addiw	a5,a5,-1
    80004cf2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004cf6:	8526                	mv	a0,s1
    80004cf8:	ffffe097          	auipc	ra,0xffffe
    80004cfc:	f42080e7          	jalr	-190(ra) # 80002c3a <iupdate>
    80004d00:	bf0d                	j	80004c32 <sys_unlink+0xde>
    80004d02:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004d04:	8526                	mv	a0,s1
    80004d06:	ffffe097          	auipc	ra,0xffffe
    80004d0a:	266080e7          	jalr	614(ra) # 80002f6c <iunlockput>
  end_op();
    80004d0e:	fffff097          	auipc	ra,0xfffff
    80004d12:	a44080e7          	jalr	-1468(ra) # 80003752 <end_op>
  return -1;
    80004d16:	557d                	li	a0,-1
    80004d18:	64ee                	ld	s1,216(sp)
}
    80004d1a:	70ae                	ld	ra,232(sp)
    80004d1c:	740e                	ld	s0,224(sp)
    80004d1e:	616d                	addi	sp,sp,240
    80004d20:	8082                	ret
    return -1;
    80004d22:	557d                	li	a0,-1
    80004d24:	bfdd                	j	80004d1a <sys_unlink+0x1c6>
    iunlockput(ip);
    80004d26:	854a                	mv	a0,s2
    80004d28:	ffffe097          	auipc	ra,0xffffe
    80004d2c:	244080e7          	jalr	580(ra) # 80002f6c <iunlockput>
    goto bad;
    80004d30:	694e                	ld	s2,208(sp)
    80004d32:	69ae                	ld	s3,200(sp)
    80004d34:	bfc1                	j	80004d04 <sys_unlink+0x1b0>

0000000080004d36 <sys_open>:

uint64
sys_open(void)
{
    80004d36:	7131                	addi	sp,sp,-192
    80004d38:	fd06                	sd	ra,184(sp)
    80004d3a:	f922                	sd	s0,176(sp)
    80004d3c:	f526                	sd	s1,168(sp)
    80004d3e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d40:	08000613          	li	a2,128
    80004d44:	f5040593          	addi	a1,s0,-176
    80004d48:	4501                	li	a0,0
    80004d4a:	ffffd097          	auipc	ra,0xffffd
    80004d4e:	3c4080e7          	jalr	964(ra) # 8000210e <argstr>
    return -1;
    80004d52:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d54:	0c054463          	bltz	a0,80004e1c <sys_open+0xe6>
    80004d58:	f4c40593          	addi	a1,s0,-180
    80004d5c:	4505                	li	a0,1
    80004d5e:	ffffd097          	auipc	ra,0xffffd
    80004d62:	36c080e7          	jalr	876(ra) # 800020ca <argint>
    80004d66:	0a054b63          	bltz	a0,80004e1c <sys_open+0xe6>
    80004d6a:	f14a                	sd	s2,160(sp)

  begin_op();
    80004d6c:	fffff097          	auipc	ra,0xfffff
    80004d70:	96c080e7          	jalr	-1684(ra) # 800036d8 <begin_op>

  if(omode & O_CREATE){
    80004d74:	f4c42783          	lw	a5,-180(s0)
    80004d78:	2007f793          	andi	a5,a5,512
    80004d7c:	cfc5                	beqz	a5,80004e34 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d7e:	4681                	li	a3,0
    80004d80:	4601                	li	a2,0
    80004d82:	4589                	li	a1,2
    80004d84:	f5040513          	addi	a0,s0,-176
    80004d88:	00000097          	auipc	ra,0x0
    80004d8c:	958080e7          	jalr	-1704(ra) # 800046e0 <create>
    80004d90:	892a                	mv	s2,a0
    if(ip == 0){
    80004d92:	c959                	beqz	a0,80004e28 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d94:	04491703          	lh	a4,68(s2)
    80004d98:	478d                	li	a5,3
    80004d9a:	00f71763          	bne	a4,a5,80004da8 <sys_open+0x72>
    80004d9e:	04695703          	lhu	a4,70(s2)
    80004da2:	47a5                	li	a5,9
    80004da4:	0ce7ef63          	bltu	a5,a4,80004e82 <sys_open+0x14c>
    80004da8:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004daa:	fffff097          	auipc	ra,0xfffff
    80004dae:	d3c080e7          	jalr	-708(ra) # 80003ae6 <filealloc>
    80004db2:	89aa                	mv	s3,a0
    80004db4:	c965                	beqz	a0,80004ea4 <sys_open+0x16e>
    80004db6:	00000097          	auipc	ra,0x0
    80004dba:	8e8080e7          	jalr	-1816(ra) # 8000469e <fdalloc>
    80004dbe:	84aa                	mv	s1,a0
    80004dc0:	0c054d63          	bltz	a0,80004e9a <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004dc4:	04491703          	lh	a4,68(s2)
    80004dc8:	478d                	li	a5,3
    80004dca:	0ef70a63          	beq	a4,a5,80004ebe <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004dce:	4789                	li	a5,2
    80004dd0:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004dd4:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004dd8:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004ddc:	f4c42783          	lw	a5,-180(s0)
    80004de0:	0017c713          	xori	a4,a5,1
    80004de4:	8b05                	andi	a4,a4,1
    80004de6:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004dea:	0037f713          	andi	a4,a5,3
    80004dee:	00e03733          	snez	a4,a4
    80004df2:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004df6:	4007f793          	andi	a5,a5,1024
    80004dfa:	c791                	beqz	a5,80004e06 <sys_open+0xd0>
    80004dfc:	04491703          	lh	a4,68(s2)
    80004e00:	4789                	li	a5,2
    80004e02:	0cf70563          	beq	a4,a5,80004ecc <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004e06:	854a                	mv	a0,s2
    80004e08:	ffffe097          	auipc	ra,0xffffe
    80004e0c:	fc4080e7          	jalr	-60(ra) # 80002dcc <iunlock>
  end_op();
    80004e10:	fffff097          	auipc	ra,0xfffff
    80004e14:	942080e7          	jalr	-1726(ra) # 80003752 <end_op>
    80004e18:	790a                	ld	s2,160(sp)
    80004e1a:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004e1c:	8526                	mv	a0,s1
    80004e1e:	70ea                	ld	ra,184(sp)
    80004e20:	744a                	ld	s0,176(sp)
    80004e22:	74aa                	ld	s1,168(sp)
    80004e24:	6129                	addi	sp,sp,192
    80004e26:	8082                	ret
      end_op();
    80004e28:	fffff097          	auipc	ra,0xfffff
    80004e2c:	92a080e7          	jalr	-1750(ra) # 80003752 <end_op>
      return -1;
    80004e30:	790a                	ld	s2,160(sp)
    80004e32:	b7ed                	j	80004e1c <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004e34:	f5040513          	addi	a0,s0,-176
    80004e38:	ffffe097          	auipc	ra,0xffffe
    80004e3c:	6a0080e7          	jalr	1696(ra) # 800034d8 <namei>
    80004e40:	892a                	mv	s2,a0
    80004e42:	c90d                	beqz	a0,80004e74 <sys_open+0x13e>
    ilock(ip);
    80004e44:	ffffe097          	auipc	ra,0xffffe
    80004e48:	ec2080e7          	jalr	-318(ra) # 80002d06 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e4c:	04491703          	lh	a4,68(s2)
    80004e50:	4785                	li	a5,1
    80004e52:	f4f711e3          	bne	a4,a5,80004d94 <sys_open+0x5e>
    80004e56:	f4c42783          	lw	a5,-180(s0)
    80004e5a:	d7b9                	beqz	a5,80004da8 <sys_open+0x72>
      iunlockput(ip);
    80004e5c:	854a                	mv	a0,s2
    80004e5e:	ffffe097          	auipc	ra,0xffffe
    80004e62:	10e080e7          	jalr	270(ra) # 80002f6c <iunlockput>
      end_op();
    80004e66:	fffff097          	auipc	ra,0xfffff
    80004e6a:	8ec080e7          	jalr	-1812(ra) # 80003752 <end_op>
      return -1;
    80004e6e:	54fd                	li	s1,-1
    80004e70:	790a                	ld	s2,160(sp)
    80004e72:	b76d                	j	80004e1c <sys_open+0xe6>
      end_op();
    80004e74:	fffff097          	auipc	ra,0xfffff
    80004e78:	8de080e7          	jalr	-1826(ra) # 80003752 <end_op>
      return -1;
    80004e7c:	54fd                	li	s1,-1
    80004e7e:	790a                	ld	s2,160(sp)
    80004e80:	bf71                	j	80004e1c <sys_open+0xe6>
    iunlockput(ip);
    80004e82:	854a                	mv	a0,s2
    80004e84:	ffffe097          	auipc	ra,0xffffe
    80004e88:	0e8080e7          	jalr	232(ra) # 80002f6c <iunlockput>
    end_op();
    80004e8c:	fffff097          	auipc	ra,0xfffff
    80004e90:	8c6080e7          	jalr	-1850(ra) # 80003752 <end_op>
    return -1;
    80004e94:	54fd                	li	s1,-1
    80004e96:	790a                	ld	s2,160(sp)
    80004e98:	b751                	j	80004e1c <sys_open+0xe6>
      fileclose(f);
    80004e9a:	854e                	mv	a0,s3
    80004e9c:	fffff097          	auipc	ra,0xfffff
    80004ea0:	d06080e7          	jalr	-762(ra) # 80003ba2 <fileclose>
    iunlockput(ip);
    80004ea4:	854a                	mv	a0,s2
    80004ea6:	ffffe097          	auipc	ra,0xffffe
    80004eaa:	0c6080e7          	jalr	198(ra) # 80002f6c <iunlockput>
    end_op();
    80004eae:	fffff097          	auipc	ra,0xfffff
    80004eb2:	8a4080e7          	jalr	-1884(ra) # 80003752 <end_op>
    return -1;
    80004eb6:	54fd                	li	s1,-1
    80004eb8:	790a                	ld	s2,160(sp)
    80004eba:	69ea                	ld	s3,152(sp)
    80004ebc:	b785                	j	80004e1c <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004ebe:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004ec2:	04691783          	lh	a5,70(s2)
    80004ec6:	02f99223          	sh	a5,36(s3)
    80004eca:	b739                	j	80004dd8 <sys_open+0xa2>
    itrunc(ip);
    80004ecc:	854a                	mv	a0,s2
    80004ece:	ffffe097          	auipc	ra,0xffffe
    80004ed2:	f4a080e7          	jalr	-182(ra) # 80002e18 <itrunc>
    80004ed6:	bf05                	j	80004e06 <sys_open+0xd0>

0000000080004ed8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ed8:	7175                	addi	sp,sp,-144
    80004eda:	e506                	sd	ra,136(sp)
    80004edc:	e122                	sd	s0,128(sp)
    80004ede:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ee0:	ffffe097          	auipc	ra,0xffffe
    80004ee4:	7f8080e7          	jalr	2040(ra) # 800036d8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ee8:	08000613          	li	a2,128
    80004eec:	f7040593          	addi	a1,s0,-144
    80004ef0:	4501                	li	a0,0
    80004ef2:	ffffd097          	auipc	ra,0xffffd
    80004ef6:	21c080e7          	jalr	540(ra) # 8000210e <argstr>
    80004efa:	02054963          	bltz	a0,80004f2c <sys_mkdir+0x54>
    80004efe:	4681                	li	a3,0
    80004f00:	4601                	li	a2,0
    80004f02:	4585                	li	a1,1
    80004f04:	f7040513          	addi	a0,s0,-144
    80004f08:	fffff097          	auipc	ra,0xfffff
    80004f0c:	7d8080e7          	jalr	2008(ra) # 800046e0 <create>
    80004f10:	cd11                	beqz	a0,80004f2c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f12:	ffffe097          	auipc	ra,0xffffe
    80004f16:	05a080e7          	jalr	90(ra) # 80002f6c <iunlockput>
  end_op();
    80004f1a:	fffff097          	auipc	ra,0xfffff
    80004f1e:	838080e7          	jalr	-1992(ra) # 80003752 <end_op>
  return 0;
    80004f22:	4501                	li	a0,0
}
    80004f24:	60aa                	ld	ra,136(sp)
    80004f26:	640a                	ld	s0,128(sp)
    80004f28:	6149                	addi	sp,sp,144
    80004f2a:	8082                	ret
    end_op();
    80004f2c:	fffff097          	auipc	ra,0xfffff
    80004f30:	826080e7          	jalr	-2010(ra) # 80003752 <end_op>
    return -1;
    80004f34:	557d                	li	a0,-1
    80004f36:	b7fd                	j	80004f24 <sys_mkdir+0x4c>

0000000080004f38 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f38:	7135                	addi	sp,sp,-160
    80004f3a:	ed06                	sd	ra,152(sp)
    80004f3c:	e922                	sd	s0,144(sp)
    80004f3e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f40:	ffffe097          	auipc	ra,0xffffe
    80004f44:	798080e7          	jalr	1944(ra) # 800036d8 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f48:	08000613          	li	a2,128
    80004f4c:	f7040593          	addi	a1,s0,-144
    80004f50:	4501                	li	a0,0
    80004f52:	ffffd097          	auipc	ra,0xffffd
    80004f56:	1bc080e7          	jalr	444(ra) # 8000210e <argstr>
    80004f5a:	04054a63          	bltz	a0,80004fae <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004f5e:	f6c40593          	addi	a1,s0,-148
    80004f62:	4505                	li	a0,1
    80004f64:	ffffd097          	auipc	ra,0xffffd
    80004f68:	166080e7          	jalr	358(ra) # 800020ca <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f6c:	04054163          	bltz	a0,80004fae <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f70:	f6840593          	addi	a1,s0,-152
    80004f74:	4509                	li	a0,2
    80004f76:	ffffd097          	auipc	ra,0xffffd
    80004f7a:	154080e7          	jalr	340(ra) # 800020ca <argint>
     argint(1, &major) < 0 ||
    80004f7e:	02054863          	bltz	a0,80004fae <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f82:	f6841683          	lh	a3,-152(s0)
    80004f86:	f6c41603          	lh	a2,-148(s0)
    80004f8a:	458d                	li	a1,3
    80004f8c:	f7040513          	addi	a0,s0,-144
    80004f90:	fffff097          	auipc	ra,0xfffff
    80004f94:	750080e7          	jalr	1872(ra) # 800046e0 <create>
     argint(2, &minor) < 0 ||
    80004f98:	c919                	beqz	a0,80004fae <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f9a:	ffffe097          	auipc	ra,0xffffe
    80004f9e:	fd2080e7          	jalr	-46(ra) # 80002f6c <iunlockput>
  end_op();
    80004fa2:	ffffe097          	auipc	ra,0xffffe
    80004fa6:	7b0080e7          	jalr	1968(ra) # 80003752 <end_op>
  return 0;
    80004faa:	4501                	li	a0,0
    80004fac:	a031                	j	80004fb8 <sys_mknod+0x80>
    end_op();
    80004fae:	ffffe097          	auipc	ra,0xffffe
    80004fb2:	7a4080e7          	jalr	1956(ra) # 80003752 <end_op>
    return -1;
    80004fb6:	557d                	li	a0,-1
}
    80004fb8:	60ea                	ld	ra,152(sp)
    80004fba:	644a                	ld	s0,144(sp)
    80004fbc:	610d                	addi	sp,sp,160
    80004fbe:	8082                	ret

0000000080004fc0 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fc0:	7135                	addi	sp,sp,-160
    80004fc2:	ed06                	sd	ra,152(sp)
    80004fc4:	e922                	sd	s0,144(sp)
    80004fc6:	e14a                	sd	s2,128(sp)
    80004fc8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004fca:	ffffc097          	auipc	ra,0xffffc
    80004fce:	f96080e7          	jalr	-106(ra) # 80000f60 <myproc>
    80004fd2:	892a                	mv	s2,a0
  
  begin_op();
    80004fd4:	ffffe097          	auipc	ra,0xffffe
    80004fd8:	704080e7          	jalr	1796(ra) # 800036d8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004fdc:	08000613          	li	a2,128
    80004fe0:	f6040593          	addi	a1,s0,-160
    80004fe4:	4501                	li	a0,0
    80004fe6:	ffffd097          	auipc	ra,0xffffd
    80004fea:	128080e7          	jalr	296(ra) # 8000210e <argstr>
    80004fee:	04054d63          	bltz	a0,80005048 <sys_chdir+0x88>
    80004ff2:	e526                	sd	s1,136(sp)
    80004ff4:	f6040513          	addi	a0,s0,-160
    80004ff8:	ffffe097          	auipc	ra,0xffffe
    80004ffc:	4e0080e7          	jalr	1248(ra) # 800034d8 <namei>
    80005000:	84aa                	mv	s1,a0
    80005002:	c131                	beqz	a0,80005046 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005004:	ffffe097          	auipc	ra,0xffffe
    80005008:	d02080e7          	jalr	-766(ra) # 80002d06 <ilock>
  if(ip->type != T_DIR){
    8000500c:	04449703          	lh	a4,68(s1)
    80005010:	4785                	li	a5,1
    80005012:	04f71163          	bne	a4,a5,80005054 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005016:	8526                	mv	a0,s1
    80005018:	ffffe097          	auipc	ra,0xffffe
    8000501c:	db4080e7          	jalr	-588(ra) # 80002dcc <iunlock>
  iput(p->cwd);
    80005020:	15893503          	ld	a0,344(s2)
    80005024:	ffffe097          	auipc	ra,0xffffe
    80005028:	ea0080e7          	jalr	-352(ra) # 80002ec4 <iput>
  end_op();
    8000502c:	ffffe097          	auipc	ra,0xffffe
    80005030:	726080e7          	jalr	1830(ra) # 80003752 <end_op>
  p->cwd = ip;
    80005034:	14993c23          	sd	s1,344(s2)
  return 0;
    80005038:	4501                	li	a0,0
    8000503a:	64aa                	ld	s1,136(sp)
}
    8000503c:	60ea                	ld	ra,152(sp)
    8000503e:	644a                	ld	s0,144(sp)
    80005040:	690a                	ld	s2,128(sp)
    80005042:	610d                	addi	sp,sp,160
    80005044:	8082                	ret
    80005046:	64aa                	ld	s1,136(sp)
    end_op();
    80005048:	ffffe097          	auipc	ra,0xffffe
    8000504c:	70a080e7          	jalr	1802(ra) # 80003752 <end_op>
    return -1;
    80005050:	557d                	li	a0,-1
    80005052:	b7ed                	j	8000503c <sys_chdir+0x7c>
    iunlockput(ip);
    80005054:	8526                	mv	a0,s1
    80005056:	ffffe097          	auipc	ra,0xffffe
    8000505a:	f16080e7          	jalr	-234(ra) # 80002f6c <iunlockput>
    end_op();
    8000505e:	ffffe097          	auipc	ra,0xffffe
    80005062:	6f4080e7          	jalr	1780(ra) # 80003752 <end_op>
    return -1;
    80005066:	557d                	li	a0,-1
    80005068:	64aa                	ld	s1,136(sp)
    8000506a:	bfc9                	j	8000503c <sys_chdir+0x7c>

000000008000506c <sys_exec>:

uint64
sys_exec(void)
{
    8000506c:	7121                	addi	sp,sp,-448
    8000506e:	ff06                	sd	ra,440(sp)
    80005070:	fb22                	sd	s0,432(sp)
    80005072:	f34a                	sd	s2,416(sp)
    80005074:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005076:	08000613          	li	a2,128
    8000507a:	f5040593          	addi	a1,s0,-176
    8000507e:	4501                	li	a0,0
    80005080:	ffffd097          	auipc	ra,0xffffd
    80005084:	08e080e7          	jalr	142(ra) # 8000210e <argstr>
    return -1;
    80005088:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000508a:	0e054a63          	bltz	a0,8000517e <sys_exec+0x112>
    8000508e:	e4840593          	addi	a1,s0,-440
    80005092:	4505                	li	a0,1
    80005094:	ffffd097          	auipc	ra,0xffffd
    80005098:	058080e7          	jalr	88(ra) # 800020ec <argaddr>
    8000509c:	0e054163          	bltz	a0,8000517e <sys_exec+0x112>
    800050a0:	f726                	sd	s1,424(sp)
    800050a2:	ef4e                	sd	s3,408(sp)
    800050a4:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800050a6:	10000613          	li	a2,256
    800050aa:	4581                	li	a1,0
    800050ac:	e5040513          	addi	a0,s0,-432
    800050b0:	ffffb097          	auipc	ra,0xffffb
    800050b4:	0ca080e7          	jalr	202(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800050b8:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800050bc:	89a6                	mv	s3,s1
    800050be:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800050c0:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050c4:	00391513          	slli	a0,s2,0x3
    800050c8:	e4040593          	addi	a1,s0,-448
    800050cc:	e4843783          	ld	a5,-440(s0)
    800050d0:	953e                	add	a0,a0,a5
    800050d2:	ffffd097          	auipc	ra,0xffffd
    800050d6:	f5e080e7          	jalr	-162(ra) # 80002030 <fetchaddr>
    800050da:	02054a63          	bltz	a0,8000510e <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    800050de:	e4043783          	ld	a5,-448(s0)
    800050e2:	c7b1                	beqz	a5,8000512e <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800050e4:	ffffb097          	auipc	ra,0xffffb
    800050e8:	036080e7          	jalr	54(ra) # 8000011a <kalloc>
    800050ec:	85aa                	mv	a1,a0
    800050ee:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800050f2:	cd11                	beqz	a0,8000510e <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050f4:	6605                	lui	a2,0x1
    800050f6:	e4043503          	ld	a0,-448(s0)
    800050fa:	ffffd097          	auipc	ra,0xffffd
    800050fe:	f88080e7          	jalr	-120(ra) # 80002082 <fetchstr>
    80005102:	00054663          	bltz	a0,8000510e <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80005106:	0905                	addi	s2,s2,1
    80005108:	09a1                	addi	s3,s3,8
    8000510a:	fb491de3          	bne	s2,s4,800050c4 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000510e:	f5040913          	addi	s2,s0,-176
    80005112:	6088                	ld	a0,0(s1)
    80005114:	c12d                	beqz	a0,80005176 <sys_exec+0x10a>
    kfree(argv[i]);
    80005116:	ffffb097          	auipc	ra,0xffffb
    8000511a:	f06080e7          	jalr	-250(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000511e:	04a1                	addi	s1,s1,8
    80005120:	ff2499e3          	bne	s1,s2,80005112 <sys_exec+0xa6>
  return -1;
    80005124:	597d                	li	s2,-1
    80005126:	74ba                	ld	s1,424(sp)
    80005128:	69fa                	ld	s3,408(sp)
    8000512a:	6a5a                	ld	s4,400(sp)
    8000512c:	a889                	j	8000517e <sys_exec+0x112>
      argv[i] = 0;
    8000512e:	0009079b          	sext.w	a5,s2
    80005132:	078e                	slli	a5,a5,0x3
    80005134:	fd078793          	addi	a5,a5,-48
    80005138:	97a2                	add	a5,a5,s0
    8000513a:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000513e:	e5040593          	addi	a1,s0,-432
    80005142:	f5040513          	addi	a0,s0,-176
    80005146:	fffff097          	auipc	ra,0xfffff
    8000514a:	10c080e7          	jalr	268(ra) # 80004252 <exec>
    8000514e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005150:	f5040993          	addi	s3,s0,-176
    80005154:	6088                	ld	a0,0(s1)
    80005156:	cd01                	beqz	a0,8000516e <sys_exec+0x102>
    kfree(argv[i]);
    80005158:	ffffb097          	auipc	ra,0xffffb
    8000515c:	ec4080e7          	jalr	-316(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005160:	04a1                	addi	s1,s1,8
    80005162:	ff3499e3          	bne	s1,s3,80005154 <sys_exec+0xe8>
    80005166:	74ba                	ld	s1,424(sp)
    80005168:	69fa                	ld	s3,408(sp)
    8000516a:	6a5a                	ld	s4,400(sp)
    8000516c:	a809                	j	8000517e <sys_exec+0x112>
  return ret;
    8000516e:	74ba                	ld	s1,424(sp)
    80005170:	69fa                	ld	s3,408(sp)
    80005172:	6a5a                	ld	s4,400(sp)
    80005174:	a029                	j	8000517e <sys_exec+0x112>
  return -1;
    80005176:	597d                	li	s2,-1
    80005178:	74ba                	ld	s1,424(sp)
    8000517a:	69fa                	ld	s3,408(sp)
    8000517c:	6a5a                	ld	s4,400(sp)
}
    8000517e:	854a                	mv	a0,s2
    80005180:	70fa                	ld	ra,440(sp)
    80005182:	745a                	ld	s0,432(sp)
    80005184:	791a                	ld	s2,416(sp)
    80005186:	6139                	addi	sp,sp,448
    80005188:	8082                	ret

000000008000518a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000518a:	7139                	addi	sp,sp,-64
    8000518c:	fc06                	sd	ra,56(sp)
    8000518e:	f822                	sd	s0,48(sp)
    80005190:	f426                	sd	s1,40(sp)
    80005192:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005194:	ffffc097          	auipc	ra,0xffffc
    80005198:	dcc080e7          	jalr	-564(ra) # 80000f60 <myproc>
    8000519c:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000519e:	fd840593          	addi	a1,s0,-40
    800051a2:	4501                	li	a0,0
    800051a4:	ffffd097          	auipc	ra,0xffffd
    800051a8:	f48080e7          	jalr	-184(ra) # 800020ec <argaddr>
    return -1;
    800051ac:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800051ae:	0e054063          	bltz	a0,8000528e <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800051b2:	fc840593          	addi	a1,s0,-56
    800051b6:	fd040513          	addi	a0,s0,-48
    800051ba:	fffff097          	auipc	ra,0xfffff
    800051be:	d56080e7          	jalr	-682(ra) # 80003f10 <pipealloc>
    return -1;
    800051c2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800051c4:	0c054563          	bltz	a0,8000528e <sys_pipe+0x104>
  fd0 = -1;
    800051c8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800051cc:	fd043503          	ld	a0,-48(s0)
    800051d0:	fffff097          	auipc	ra,0xfffff
    800051d4:	4ce080e7          	jalr	1230(ra) # 8000469e <fdalloc>
    800051d8:	fca42223          	sw	a0,-60(s0)
    800051dc:	08054c63          	bltz	a0,80005274 <sys_pipe+0xea>
    800051e0:	fc843503          	ld	a0,-56(s0)
    800051e4:	fffff097          	auipc	ra,0xfffff
    800051e8:	4ba080e7          	jalr	1210(ra) # 8000469e <fdalloc>
    800051ec:	fca42023          	sw	a0,-64(s0)
    800051f0:	06054963          	bltz	a0,80005262 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051f4:	4691                	li	a3,4
    800051f6:	fc440613          	addi	a2,s0,-60
    800051fa:	fd843583          	ld	a1,-40(s0)
    800051fe:	68a8                	ld	a0,80(s1)
    80005200:	ffffc097          	auipc	ra,0xffffc
    80005204:	918080e7          	jalr	-1768(ra) # 80000b18 <copyout>
    80005208:	02054063          	bltz	a0,80005228 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000520c:	4691                	li	a3,4
    8000520e:	fc040613          	addi	a2,s0,-64
    80005212:	fd843583          	ld	a1,-40(s0)
    80005216:	0591                	addi	a1,a1,4
    80005218:	68a8                	ld	a0,80(s1)
    8000521a:	ffffc097          	auipc	ra,0xffffc
    8000521e:	8fe080e7          	jalr	-1794(ra) # 80000b18 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005222:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005224:	06055563          	bgez	a0,8000528e <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005228:	fc442783          	lw	a5,-60(s0)
    8000522c:	07e9                	addi	a5,a5,26
    8000522e:	078e                	slli	a5,a5,0x3
    80005230:	97a6                	add	a5,a5,s1
    80005232:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005236:	fc042783          	lw	a5,-64(s0)
    8000523a:	07e9                	addi	a5,a5,26
    8000523c:	078e                	slli	a5,a5,0x3
    8000523e:	00f48533          	add	a0,s1,a5
    80005242:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005246:	fd043503          	ld	a0,-48(s0)
    8000524a:	fffff097          	auipc	ra,0xfffff
    8000524e:	958080e7          	jalr	-1704(ra) # 80003ba2 <fileclose>
    fileclose(wf);
    80005252:	fc843503          	ld	a0,-56(s0)
    80005256:	fffff097          	auipc	ra,0xfffff
    8000525a:	94c080e7          	jalr	-1716(ra) # 80003ba2 <fileclose>
    return -1;
    8000525e:	57fd                	li	a5,-1
    80005260:	a03d                	j	8000528e <sys_pipe+0x104>
    if(fd0 >= 0)
    80005262:	fc442783          	lw	a5,-60(s0)
    80005266:	0007c763          	bltz	a5,80005274 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000526a:	07e9                	addi	a5,a5,26
    8000526c:	078e                	slli	a5,a5,0x3
    8000526e:	97a6                	add	a5,a5,s1
    80005270:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80005274:	fd043503          	ld	a0,-48(s0)
    80005278:	fffff097          	auipc	ra,0xfffff
    8000527c:	92a080e7          	jalr	-1750(ra) # 80003ba2 <fileclose>
    fileclose(wf);
    80005280:	fc843503          	ld	a0,-56(s0)
    80005284:	fffff097          	auipc	ra,0xfffff
    80005288:	91e080e7          	jalr	-1762(ra) # 80003ba2 <fileclose>
    return -1;
    8000528c:	57fd                	li	a5,-1
}
    8000528e:	853e                	mv	a0,a5
    80005290:	70e2                	ld	ra,56(sp)
    80005292:	7442                	ld	s0,48(sp)
    80005294:	74a2                	ld	s1,40(sp)
    80005296:	6121                	addi	sp,sp,64
    80005298:	8082                	ret
    8000529a:	0000                	unimp
    8000529c:	0000                	unimp
	...

00000000800052a0 <kernelvec>:
    800052a0:	7111                	addi	sp,sp,-256
    800052a2:	e006                	sd	ra,0(sp)
    800052a4:	e40a                	sd	sp,8(sp)
    800052a6:	e80e                	sd	gp,16(sp)
    800052a8:	ec12                	sd	tp,24(sp)
    800052aa:	f016                	sd	t0,32(sp)
    800052ac:	f41a                	sd	t1,40(sp)
    800052ae:	f81e                	sd	t2,48(sp)
    800052b0:	fc22                	sd	s0,56(sp)
    800052b2:	e0a6                	sd	s1,64(sp)
    800052b4:	e4aa                	sd	a0,72(sp)
    800052b6:	e8ae                	sd	a1,80(sp)
    800052b8:	ecb2                	sd	a2,88(sp)
    800052ba:	f0b6                	sd	a3,96(sp)
    800052bc:	f4ba                	sd	a4,104(sp)
    800052be:	f8be                	sd	a5,112(sp)
    800052c0:	fcc2                	sd	a6,120(sp)
    800052c2:	e146                	sd	a7,128(sp)
    800052c4:	e54a                	sd	s2,136(sp)
    800052c6:	e94e                	sd	s3,144(sp)
    800052c8:	ed52                	sd	s4,152(sp)
    800052ca:	f156                	sd	s5,160(sp)
    800052cc:	f55a                	sd	s6,168(sp)
    800052ce:	f95e                	sd	s7,176(sp)
    800052d0:	fd62                	sd	s8,184(sp)
    800052d2:	e1e6                	sd	s9,192(sp)
    800052d4:	e5ea                	sd	s10,200(sp)
    800052d6:	e9ee                	sd	s11,208(sp)
    800052d8:	edf2                	sd	t3,216(sp)
    800052da:	f1f6                	sd	t4,224(sp)
    800052dc:	f5fa                	sd	t5,232(sp)
    800052de:	f9fe                	sd	t6,240(sp)
    800052e0:	c1dfc0ef          	jal	80001efc <kerneltrap>
    800052e4:	6082                	ld	ra,0(sp)
    800052e6:	6122                	ld	sp,8(sp)
    800052e8:	61c2                	ld	gp,16(sp)
    800052ea:	7282                	ld	t0,32(sp)
    800052ec:	7322                	ld	t1,40(sp)
    800052ee:	73c2                	ld	t2,48(sp)
    800052f0:	7462                	ld	s0,56(sp)
    800052f2:	6486                	ld	s1,64(sp)
    800052f4:	6526                	ld	a0,72(sp)
    800052f6:	65c6                	ld	a1,80(sp)
    800052f8:	6666                	ld	a2,88(sp)
    800052fa:	7686                	ld	a3,96(sp)
    800052fc:	7726                	ld	a4,104(sp)
    800052fe:	77c6                	ld	a5,112(sp)
    80005300:	7866                	ld	a6,120(sp)
    80005302:	688a                	ld	a7,128(sp)
    80005304:	692a                	ld	s2,136(sp)
    80005306:	69ca                	ld	s3,144(sp)
    80005308:	6a6a                	ld	s4,152(sp)
    8000530a:	7a8a                	ld	s5,160(sp)
    8000530c:	7b2a                	ld	s6,168(sp)
    8000530e:	7bca                	ld	s7,176(sp)
    80005310:	7c6a                	ld	s8,184(sp)
    80005312:	6c8e                	ld	s9,192(sp)
    80005314:	6d2e                	ld	s10,200(sp)
    80005316:	6dce                	ld	s11,208(sp)
    80005318:	6e6e                	ld	t3,216(sp)
    8000531a:	7e8e                	ld	t4,224(sp)
    8000531c:	7f2e                	ld	t5,232(sp)
    8000531e:	7fce                	ld	t6,240(sp)
    80005320:	6111                	addi	sp,sp,256
    80005322:	10200073          	sret
    80005326:	00000013          	nop
    8000532a:	00000013          	nop
    8000532e:	0001                	nop

0000000080005330 <timervec>:
    80005330:	34051573          	csrrw	a0,mscratch,a0
    80005334:	e10c                	sd	a1,0(a0)
    80005336:	e510                	sd	a2,8(a0)
    80005338:	e914                	sd	a3,16(a0)
    8000533a:	6d0c                	ld	a1,24(a0)
    8000533c:	7110                	ld	a2,32(a0)
    8000533e:	6194                	ld	a3,0(a1)
    80005340:	96b2                	add	a3,a3,a2
    80005342:	e194                	sd	a3,0(a1)
    80005344:	4589                	li	a1,2
    80005346:	14459073          	csrw	sip,a1
    8000534a:	6914                	ld	a3,16(a0)
    8000534c:	6510                	ld	a2,8(a0)
    8000534e:	610c                	ld	a1,0(a0)
    80005350:	34051573          	csrrw	a0,mscratch,a0
    80005354:	30200073          	mret
	...

000000008000535a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000535a:	1141                	addi	sp,sp,-16
    8000535c:	e422                	sd	s0,8(sp)
    8000535e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005360:	0c0007b7          	lui	a5,0xc000
    80005364:	4705                	li	a4,1
    80005366:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005368:	0c0007b7          	lui	a5,0xc000
    8000536c:	c3d8                	sw	a4,4(a5)
}
    8000536e:	6422                	ld	s0,8(sp)
    80005370:	0141                	addi	sp,sp,16
    80005372:	8082                	ret

0000000080005374 <plicinithart>:

void
plicinithart(void)
{
    80005374:	1141                	addi	sp,sp,-16
    80005376:	e406                	sd	ra,8(sp)
    80005378:	e022                	sd	s0,0(sp)
    8000537a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000537c:	ffffc097          	auipc	ra,0xffffc
    80005380:	bb8080e7          	jalr	-1096(ra) # 80000f34 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005384:	0085171b          	slliw	a4,a0,0x8
    80005388:	0c0027b7          	lui	a5,0xc002
    8000538c:	97ba                	add	a5,a5,a4
    8000538e:	40200713          	li	a4,1026
    80005392:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005396:	00d5151b          	slliw	a0,a0,0xd
    8000539a:	0c2017b7          	lui	a5,0xc201
    8000539e:	97aa                	add	a5,a5,a0
    800053a0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800053a4:	60a2                	ld	ra,8(sp)
    800053a6:	6402                	ld	s0,0(sp)
    800053a8:	0141                	addi	sp,sp,16
    800053aa:	8082                	ret

00000000800053ac <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800053ac:	1141                	addi	sp,sp,-16
    800053ae:	e406                	sd	ra,8(sp)
    800053b0:	e022                	sd	s0,0(sp)
    800053b2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053b4:	ffffc097          	auipc	ra,0xffffc
    800053b8:	b80080e7          	jalr	-1152(ra) # 80000f34 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053bc:	00d5151b          	slliw	a0,a0,0xd
    800053c0:	0c2017b7          	lui	a5,0xc201
    800053c4:	97aa                	add	a5,a5,a0
  return irq;
}
    800053c6:	43c8                	lw	a0,4(a5)
    800053c8:	60a2                	ld	ra,8(sp)
    800053ca:	6402                	ld	s0,0(sp)
    800053cc:	0141                	addi	sp,sp,16
    800053ce:	8082                	ret

00000000800053d0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053d0:	1101                	addi	sp,sp,-32
    800053d2:	ec06                	sd	ra,24(sp)
    800053d4:	e822                	sd	s0,16(sp)
    800053d6:	e426                	sd	s1,8(sp)
    800053d8:	1000                	addi	s0,sp,32
    800053da:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053dc:	ffffc097          	auipc	ra,0xffffc
    800053e0:	b58080e7          	jalr	-1192(ra) # 80000f34 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053e4:	00d5151b          	slliw	a0,a0,0xd
    800053e8:	0c2017b7          	lui	a5,0xc201
    800053ec:	97aa                	add	a5,a5,a0
    800053ee:	c3c4                	sw	s1,4(a5)
}
    800053f0:	60e2                	ld	ra,24(sp)
    800053f2:	6442                	ld	s0,16(sp)
    800053f4:	64a2                	ld	s1,8(sp)
    800053f6:	6105                	addi	sp,sp,32
    800053f8:	8082                	ret

00000000800053fa <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053fa:	1141                	addi	sp,sp,-16
    800053fc:	e406                	sd	ra,8(sp)
    800053fe:	e022                	sd	s0,0(sp)
    80005400:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005402:	479d                	li	a5,7
    80005404:	06a7c863          	blt	a5,a0,80005474 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005408:	00019717          	auipc	a4,0x19
    8000540c:	bf870713          	addi	a4,a4,-1032 # 8001e000 <disk>
    80005410:	972a                	add	a4,a4,a0
    80005412:	6789                	lui	a5,0x2
    80005414:	97ba                	add	a5,a5,a4
    80005416:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000541a:	e7ad                	bnez	a5,80005484 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000541c:	00451793          	slli	a5,a0,0x4
    80005420:	0001b717          	auipc	a4,0x1b
    80005424:	be070713          	addi	a4,a4,-1056 # 80020000 <disk+0x2000>
    80005428:	6314                	ld	a3,0(a4)
    8000542a:	96be                	add	a3,a3,a5
    8000542c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005430:	6314                	ld	a3,0(a4)
    80005432:	96be                	add	a3,a3,a5
    80005434:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005438:	6314                	ld	a3,0(a4)
    8000543a:	96be                	add	a3,a3,a5
    8000543c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005440:	6318                	ld	a4,0(a4)
    80005442:	97ba                	add	a5,a5,a4
    80005444:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005448:	00019717          	auipc	a4,0x19
    8000544c:	bb870713          	addi	a4,a4,-1096 # 8001e000 <disk>
    80005450:	972a                	add	a4,a4,a0
    80005452:	6789                	lui	a5,0x2
    80005454:	97ba                	add	a5,a5,a4
    80005456:	4705                	li	a4,1
    80005458:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000545c:	0001b517          	auipc	a0,0x1b
    80005460:	bbc50513          	addi	a0,a0,-1092 # 80020018 <disk+0x2018>
    80005464:	ffffc097          	auipc	ra,0xffffc
    80005468:	3f8080e7          	jalr	1016(ra) # 8000185c <wakeup>
}
    8000546c:	60a2                	ld	ra,8(sp)
    8000546e:	6402                	ld	s0,0(sp)
    80005470:	0141                	addi	sp,sp,16
    80005472:	8082                	ret
    panic("free_desc 1");
    80005474:	00003517          	auipc	a0,0x3
    80005478:	1bc50513          	addi	a0,a0,444 # 80008630 <etext+0x630>
    8000547c:	00001097          	auipc	ra,0x1
    80005480:	a10080e7          	jalr	-1520(ra) # 80005e8c <panic>
    panic("free_desc 2");
    80005484:	00003517          	auipc	a0,0x3
    80005488:	1bc50513          	addi	a0,a0,444 # 80008640 <etext+0x640>
    8000548c:	00001097          	auipc	ra,0x1
    80005490:	a00080e7          	jalr	-1536(ra) # 80005e8c <panic>

0000000080005494 <virtio_disk_init>:
{
    80005494:	1141                	addi	sp,sp,-16
    80005496:	e406                	sd	ra,8(sp)
    80005498:	e022                	sd	s0,0(sp)
    8000549a:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000549c:	00003597          	auipc	a1,0x3
    800054a0:	1b458593          	addi	a1,a1,436 # 80008650 <etext+0x650>
    800054a4:	0001b517          	auipc	a0,0x1b
    800054a8:	c8450513          	addi	a0,a0,-892 # 80020128 <disk+0x2128>
    800054ac:	00001097          	auipc	ra,0x1
    800054b0:	eca080e7          	jalr	-310(ra) # 80006376 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054b4:	100017b7          	lui	a5,0x10001
    800054b8:	4398                	lw	a4,0(a5)
    800054ba:	2701                	sext.w	a4,a4
    800054bc:	747277b7          	lui	a5,0x74727
    800054c0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800054c4:	0ef71f63          	bne	a4,a5,800055c2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800054c8:	100017b7          	lui	a5,0x10001
    800054cc:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800054ce:	439c                	lw	a5,0(a5)
    800054d0:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054d2:	4705                	li	a4,1
    800054d4:	0ee79763          	bne	a5,a4,800055c2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054d8:	100017b7          	lui	a5,0x10001
    800054dc:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800054de:	439c                	lw	a5,0(a5)
    800054e0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800054e2:	4709                	li	a4,2
    800054e4:	0ce79f63          	bne	a5,a4,800055c2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800054e8:	100017b7          	lui	a5,0x10001
    800054ec:	47d8                	lw	a4,12(a5)
    800054ee:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054f0:	554d47b7          	lui	a5,0x554d4
    800054f4:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054f8:	0cf71563          	bne	a4,a5,800055c2 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054fc:	100017b7          	lui	a5,0x10001
    80005500:	4705                	li	a4,1
    80005502:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005504:	470d                	li	a4,3
    80005506:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005508:	10001737          	lui	a4,0x10001
    8000550c:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000550e:	c7ffe737          	lui	a4,0xc7ffe
    80005512:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd551f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005516:	8ef9                	and	a3,a3,a4
    80005518:	10001737          	lui	a4,0x10001
    8000551c:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000551e:	472d                	li	a4,11
    80005520:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005522:	473d                	li	a4,15
    80005524:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005526:	100017b7          	lui	a5,0x10001
    8000552a:	6705                	lui	a4,0x1
    8000552c:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000552e:	100017b7          	lui	a5,0x10001
    80005532:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005536:	100017b7          	lui	a5,0x10001
    8000553a:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000553e:	439c                	lw	a5,0(a5)
    80005540:	2781                	sext.w	a5,a5
  if(max == 0)
    80005542:	cbc1                	beqz	a5,800055d2 <virtio_disk_init+0x13e>
  if(max < NUM)
    80005544:	471d                	li	a4,7
    80005546:	08f77e63          	bgeu	a4,a5,800055e2 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000554a:	100017b7          	lui	a5,0x10001
    8000554e:	4721                	li	a4,8
    80005550:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005552:	6609                	lui	a2,0x2
    80005554:	4581                	li	a1,0
    80005556:	00019517          	auipc	a0,0x19
    8000555a:	aaa50513          	addi	a0,a0,-1366 # 8001e000 <disk>
    8000555e:	ffffb097          	auipc	ra,0xffffb
    80005562:	c1c080e7          	jalr	-996(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005566:	00019697          	auipc	a3,0x19
    8000556a:	a9a68693          	addi	a3,a3,-1382 # 8001e000 <disk>
    8000556e:	00c6d713          	srli	a4,a3,0xc
    80005572:	2701                	sext.w	a4,a4
    80005574:	100017b7          	lui	a5,0x10001
    80005578:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000557a:	0001b797          	auipc	a5,0x1b
    8000557e:	a8678793          	addi	a5,a5,-1402 # 80020000 <disk+0x2000>
    80005582:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005584:	00019717          	auipc	a4,0x19
    80005588:	afc70713          	addi	a4,a4,-1284 # 8001e080 <disk+0x80>
    8000558c:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000558e:	0001a717          	auipc	a4,0x1a
    80005592:	a7270713          	addi	a4,a4,-1422 # 8001f000 <disk+0x1000>
    80005596:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005598:	4705                	li	a4,1
    8000559a:	00e78c23          	sb	a4,24(a5)
    8000559e:	00e78ca3          	sb	a4,25(a5)
    800055a2:	00e78d23          	sb	a4,26(a5)
    800055a6:	00e78da3          	sb	a4,27(a5)
    800055aa:	00e78e23          	sb	a4,28(a5)
    800055ae:	00e78ea3          	sb	a4,29(a5)
    800055b2:	00e78f23          	sb	a4,30(a5)
    800055b6:	00e78fa3          	sb	a4,31(a5)
}
    800055ba:	60a2                	ld	ra,8(sp)
    800055bc:	6402                	ld	s0,0(sp)
    800055be:	0141                	addi	sp,sp,16
    800055c0:	8082                	ret
    panic("could not find virtio disk");
    800055c2:	00003517          	auipc	a0,0x3
    800055c6:	09e50513          	addi	a0,a0,158 # 80008660 <etext+0x660>
    800055ca:	00001097          	auipc	ra,0x1
    800055ce:	8c2080e7          	jalr	-1854(ra) # 80005e8c <panic>
    panic("virtio disk has no queue 0");
    800055d2:	00003517          	auipc	a0,0x3
    800055d6:	0ae50513          	addi	a0,a0,174 # 80008680 <etext+0x680>
    800055da:	00001097          	auipc	ra,0x1
    800055de:	8b2080e7          	jalr	-1870(ra) # 80005e8c <panic>
    panic("virtio disk max queue too short");
    800055e2:	00003517          	auipc	a0,0x3
    800055e6:	0be50513          	addi	a0,a0,190 # 800086a0 <etext+0x6a0>
    800055ea:	00001097          	auipc	ra,0x1
    800055ee:	8a2080e7          	jalr	-1886(ra) # 80005e8c <panic>

00000000800055f2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800055f2:	7159                	addi	sp,sp,-112
    800055f4:	f486                	sd	ra,104(sp)
    800055f6:	f0a2                	sd	s0,96(sp)
    800055f8:	eca6                	sd	s1,88(sp)
    800055fa:	e8ca                	sd	s2,80(sp)
    800055fc:	e4ce                	sd	s3,72(sp)
    800055fe:	e0d2                	sd	s4,64(sp)
    80005600:	fc56                	sd	s5,56(sp)
    80005602:	f85a                	sd	s6,48(sp)
    80005604:	f45e                	sd	s7,40(sp)
    80005606:	f062                	sd	s8,32(sp)
    80005608:	ec66                	sd	s9,24(sp)
    8000560a:	1880                	addi	s0,sp,112
    8000560c:	8a2a                	mv	s4,a0
    8000560e:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005610:	00c52c03          	lw	s8,12(a0)
    80005614:	001c1c1b          	slliw	s8,s8,0x1
    80005618:	1c02                	slli	s8,s8,0x20
    8000561a:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    8000561e:	0001b517          	auipc	a0,0x1b
    80005622:	b0a50513          	addi	a0,a0,-1270 # 80020128 <disk+0x2128>
    80005626:	00001097          	auipc	ra,0x1
    8000562a:	de0080e7          	jalr	-544(ra) # 80006406 <acquire>
  for(int i = 0; i < 3; i++){
    8000562e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005630:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005632:	00019b97          	auipc	s7,0x19
    80005636:	9ceb8b93          	addi	s7,s7,-1586 # 8001e000 <disk>
    8000563a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000563c:	4a8d                	li	s5,3
    8000563e:	a88d                	j	800056b0 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80005640:	00fb8733          	add	a4,s7,a5
    80005644:	975a                	add	a4,a4,s6
    80005646:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000564a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000564c:	0207c563          	bltz	a5,80005676 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005650:	2905                	addiw	s2,s2,1
    80005652:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005654:	1b590163          	beq	s2,s5,800057f6 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    80005658:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000565a:	0001b717          	auipc	a4,0x1b
    8000565e:	9be70713          	addi	a4,a4,-1602 # 80020018 <disk+0x2018>
    80005662:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005664:	00074683          	lbu	a3,0(a4)
    80005668:	fee1                	bnez	a3,80005640 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    8000566a:	2785                	addiw	a5,a5,1
    8000566c:	0705                	addi	a4,a4,1
    8000566e:	fe979be3          	bne	a5,s1,80005664 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005672:	57fd                	li	a5,-1
    80005674:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005676:	03205163          	blez	s2,80005698 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000567a:	f9042503          	lw	a0,-112(s0)
    8000567e:	00000097          	auipc	ra,0x0
    80005682:	d7c080e7          	jalr	-644(ra) # 800053fa <free_desc>
      for(int j = 0; j < i; j++)
    80005686:	4785                	li	a5,1
    80005688:	0127d863          	bge	a5,s2,80005698 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000568c:	f9442503          	lw	a0,-108(s0)
    80005690:	00000097          	auipc	ra,0x0
    80005694:	d6a080e7          	jalr	-662(ra) # 800053fa <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005698:	0001b597          	auipc	a1,0x1b
    8000569c:	a9058593          	addi	a1,a1,-1392 # 80020128 <disk+0x2128>
    800056a0:	0001b517          	auipc	a0,0x1b
    800056a4:	97850513          	addi	a0,a0,-1672 # 80020018 <disk+0x2018>
    800056a8:	ffffc097          	auipc	ra,0xffffc
    800056ac:	028080e7          	jalr	40(ra) # 800016d0 <sleep>
  for(int i = 0; i < 3; i++){
    800056b0:	f9040613          	addi	a2,s0,-112
    800056b4:	894e                	mv	s2,s3
    800056b6:	b74d                	j	80005658 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800056b8:	0001b717          	auipc	a4,0x1b
    800056bc:	94873703          	ld	a4,-1720(a4) # 80020000 <disk+0x2000>
    800056c0:	973e                	add	a4,a4,a5
    800056c2:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800056c6:	00019897          	auipc	a7,0x19
    800056ca:	93a88893          	addi	a7,a7,-1734 # 8001e000 <disk>
    800056ce:	0001b717          	auipc	a4,0x1b
    800056d2:	93270713          	addi	a4,a4,-1742 # 80020000 <disk+0x2000>
    800056d6:	6314                	ld	a3,0(a4)
    800056d8:	96be                	add	a3,a3,a5
    800056da:	00c6d583          	lhu	a1,12(a3)
    800056de:	0015e593          	ori	a1,a1,1
    800056e2:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800056e6:	f9842683          	lw	a3,-104(s0)
    800056ea:	630c                	ld	a1,0(a4)
    800056ec:	97ae                	add	a5,a5,a1
    800056ee:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056f2:	20050593          	addi	a1,a0,512
    800056f6:	0592                	slli	a1,a1,0x4
    800056f8:	95c6                	add	a1,a1,a7
    800056fa:	57fd                	li	a5,-1
    800056fc:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005700:	00469793          	slli	a5,a3,0x4
    80005704:	00073803          	ld	a6,0(a4)
    80005708:	983e                	add	a6,a6,a5
    8000570a:	6689                	lui	a3,0x2
    8000570c:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005710:	96b2                	add	a3,a3,a2
    80005712:	96c6                	add	a3,a3,a7
    80005714:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005718:	6314                	ld	a3,0(a4)
    8000571a:	96be                	add	a3,a3,a5
    8000571c:	4605                	li	a2,1
    8000571e:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005720:	6314                	ld	a3,0(a4)
    80005722:	96be                	add	a3,a3,a5
    80005724:	4809                	li	a6,2
    80005726:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    8000572a:	6314                	ld	a3,0(a4)
    8000572c:	97b6                	add	a5,a5,a3
    8000572e:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005732:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005736:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000573a:	6714                	ld	a3,8(a4)
    8000573c:	0026d783          	lhu	a5,2(a3)
    80005740:	8b9d                	andi	a5,a5,7
    80005742:	0786                	slli	a5,a5,0x1
    80005744:	96be                	add	a3,a3,a5
    80005746:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000574a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000574e:	6718                	ld	a4,8(a4)
    80005750:	00275783          	lhu	a5,2(a4)
    80005754:	2785                	addiw	a5,a5,1
    80005756:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000575a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000575e:	100017b7          	lui	a5,0x10001
    80005762:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005766:	004a2783          	lw	a5,4(s4)
    8000576a:	02c79163          	bne	a5,a2,8000578c <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    8000576e:	0001b917          	auipc	s2,0x1b
    80005772:	9ba90913          	addi	s2,s2,-1606 # 80020128 <disk+0x2128>
  while(b->disk == 1) {
    80005776:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005778:	85ca                	mv	a1,s2
    8000577a:	8552                	mv	a0,s4
    8000577c:	ffffc097          	auipc	ra,0xffffc
    80005780:	f54080e7          	jalr	-172(ra) # 800016d0 <sleep>
  while(b->disk == 1) {
    80005784:	004a2783          	lw	a5,4(s4)
    80005788:	fe9788e3          	beq	a5,s1,80005778 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    8000578c:	f9042903          	lw	s2,-112(s0)
    80005790:	20090713          	addi	a4,s2,512
    80005794:	0712                	slli	a4,a4,0x4
    80005796:	00019797          	auipc	a5,0x19
    8000579a:	86a78793          	addi	a5,a5,-1942 # 8001e000 <disk>
    8000579e:	97ba                	add	a5,a5,a4
    800057a0:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800057a4:	0001b997          	auipc	s3,0x1b
    800057a8:	85c98993          	addi	s3,s3,-1956 # 80020000 <disk+0x2000>
    800057ac:	00491713          	slli	a4,s2,0x4
    800057b0:	0009b783          	ld	a5,0(s3)
    800057b4:	97ba                	add	a5,a5,a4
    800057b6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057ba:	854a                	mv	a0,s2
    800057bc:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057c0:	00000097          	auipc	ra,0x0
    800057c4:	c3a080e7          	jalr	-966(ra) # 800053fa <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057c8:	8885                	andi	s1,s1,1
    800057ca:	f0ed                	bnez	s1,800057ac <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057cc:	0001b517          	auipc	a0,0x1b
    800057d0:	95c50513          	addi	a0,a0,-1700 # 80020128 <disk+0x2128>
    800057d4:	00001097          	auipc	ra,0x1
    800057d8:	ce6080e7          	jalr	-794(ra) # 800064ba <release>
}
    800057dc:	70a6                	ld	ra,104(sp)
    800057de:	7406                	ld	s0,96(sp)
    800057e0:	64e6                	ld	s1,88(sp)
    800057e2:	6946                	ld	s2,80(sp)
    800057e4:	69a6                	ld	s3,72(sp)
    800057e6:	6a06                	ld	s4,64(sp)
    800057e8:	7ae2                	ld	s5,56(sp)
    800057ea:	7b42                	ld	s6,48(sp)
    800057ec:	7ba2                	ld	s7,40(sp)
    800057ee:	7c02                	ld	s8,32(sp)
    800057f0:	6ce2                	ld	s9,24(sp)
    800057f2:	6165                	addi	sp,sp,112
    800057f4:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057f6:	f9042503          	lw	a0,-112(s0)
    800057fa:	00451613          	slli	a2,a0,0x4
  if(write)
    800057fe:	00019597          	auipc	a1,0x19
    80005802:	80258593          	addi	a1,a1,-2046 # 8001e000 <disk>
    80005806:	20050793          	addi	a5,a0,512
    8000580a:	0792                	slli	a5,a5,0x4
    8000580c:	97ae                	add	a5,a5,a1
    8000580e:	01903733          	snez	a4,s9
    80005812:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    80005816:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    8000581a:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000581e:	0001a717          	auipc	a4,0x1a
    80005822:	7e270713          	addi	a4,a4,2018 # 80020000 <disk+0x2000>
    80005826:	6314                	ld	a3,0(a4)
    80005828:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000582a:	6789                	lui	a5,0x2
    8000582c:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005830:	97b2                	add	a5,a5,a2
    80005832:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005834:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005836:	631c                	ld	a5,0(a4)
    80005838:	97b2                	add	a5,a5,a2
    8000583a:	46c1                	li	a3,16
    8000583c:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000583e:	631c                	ld	a5,0(a4)
    80005840:	97b2                	add	a5,a5,a2
    80005842:	4685                	li	a3,1
    80005844:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005848:	f9442783          	lw	a5,-108(s0)
    8000584c:	6314                	ld	a3,0(a4)
    8000584e:	96b2                	add	a3,a3,a2
    80005850:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005854:	0792                	slli	a5,a5,0x4
    80005856:	6314                	ld	a3,0(a4)
    80005858:	96be                	add	a3,a3,a5
    8000585a:	058a0593          	addi	a1,s4,88
    8000585e:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005860:	6318                	ld	a4,0(a4)
    80005862:	973e                	add	a4,a4,a5
    80005864:	40000693          	li	a3,1024
    80005868:	c714                	sw	a3,8(a4)
  if(write)
    8000586a:	e40c97e3          	bnez	s9,800056b8 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000586e:	0001a717          	auipc	a4,0x1a
    80005872:	79273703          	ld	a4,1938(a4) # 80020000 <disk+0x2000>
    80005876:	973e                	add	a4,a4,a5
    80005878:	4689                	li	a3,2
    8000587a:	00d71623          	sh	a3,12(a4)
    8000587e:	b5a1                	j	800056c6 <virtio_disk_rw+0xd4>

0000000080005880 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005880:	1101                	addi	sp,sp,-32
    80005882:	ec06                	sd	ra,24(sp)
    80005884:	e822                	sd	s0,16(sp)
    80005886:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005888:	0001b517          	auipc	a0,0x1b
    8000588c:	8a050513          	addi	a0,a0,-1888 # 80020128 <disk+0x2128>
    80005890:	00001097          	auipc	ra,0x1
    80005894:	b76080e7          	jalr	-1162(ra) # 80006406 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005898:	100017b7          	lui	a5,0x10001
    8000589c:	53b8                	lw	a4,96(a5)
    8000589e:	8b0d                	andi	a4,a4,3
    800058a0:	100017b7          	lui	a5,0x10001
    800058a4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800058a6:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058aa:	0001a797          	auipc	a5,0x1a
    800058ae:	75678793          	addi	a5,a5,1878 # 80020000 <disk+0x2000>
    800058b2:	6b94                	ld	a3,16(a5)
    800058b4:	0207d703          	lhu	a4,32(a5)
    800058b8:	0026d783          	lhu	a5,2(a3)
    800058bc:	06f70563          	beq	a4,a5,80005926 <virtio_disk_intr+0xa6>
    800058c0:	e426                	sd	s1,8(sp)
    800058c2:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058c4:	00018917          	auipc	s2,0x18
    800058c8:	73c90913          	addi	s2,s2,1852 # 8001e000 <disk>
    800058cc:	0001a497          	auipc	s1,0x1a
    800058d0:	73448493          	addi	s1,s1,1844 # 80020000 <disk+0x2000>
    __sync_synchronize();
    800058d4:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058d8:	6898                	ld	a4,16(s1)
    800058da:	0204d783          	lhu	a5,32(s1)
    800058de:	8b9d                	andi	a5,a5,7
    800058e0:	078e                	slli	a5,a5,0x3
    800058e2:	97ba                	add	a5,a5,a4
    800058e4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058e6:	20078713          	addi	a4,a5,512
    800058ea:	0712                	slli	a4,a4,0x4
    800058ec:	974a                	add	a4,a4,s2
    800058ee:	03074703          	lbu	a4,48(a4)
    800058f2:	e731                	bnez	a4,8000593e <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058f4:	20078793          	addi	a5,a5,512
    800058f8:	0792                	slli	a5,a5,0x4
    800058fa:	97ca                	add	a5,a5,s2
    800058fc:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800058fe:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005902:	ffffc097          	auipc	ra,0xffffc
    80005906:	f5a080e7          	jalr	-166(ra) # 8000185c <wakeup>

    disk.used_idx += 1;
    8000590a:	0204d783          	lhu	a5,32(s1)
    8000590e:	2785                	addiw	a5,a5,1
    80005910:	17c2                	slli	a5,a5,0x30
    80005912:	93c1                	srli	a5,a5,0x30
    80005914:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005918:	6898                	ld	a4,16(s1)
    8000591a:	00275703          	lhu	a4,2(a4)
    8000591e:	faf71be3          	bne	a4,a5,800058d4 <virtio_disk_intr+0x54>
    80005922:	64a2                	ld	s1,8(sp)
    80005924:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005926:	0001b517          	auipc	a0,0x1b
    8000592a:	80250513          	addi	a0,a0,-2046 # 80020128 <disk+0x2128>
    8000592e:	00001097          	auipc	ra,0x1
    80005932:	b8c080e7          	jalr	-1140(ra) # 800064ba <release>
}
    80005936:	60e2                	ld	ra,24(sp)
    80005938:	6442                	ld	s0,16(sp)
    8000593a:	6105                	addi	sp,sp,32
    8000593c:	8082                	ret
      panic("virtio_disk_intr status");
    8000593e:	00003517          	auipc	a0,0x3
    80005942:	d8250513          	addi	a0,a0,-638 # 800086c0 <etext+0x6c0>
    80005946:	00000097          	auipc	ra,0x0
    8000594a:	546080e7          	jalr	1350(ra) # 80005e8c <panic>

000000008000594e <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000594e:	1141                	addi	sp,sp,-16
    80005950:	e422                	sd	s0,8(sp)
    80005952:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005954:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005958:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000595c:	0037979b          	slliw	a5,a5,0x3
    80005960:	02004737          	lui	a4,0x2004
    80005964:	97ba                	add	a5,a5,a4
    80005966:	0200c737          	lui	a4,0x200c
    8000596a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000596c:	6318                	ld	a4,0(a4)
    8000596e:	000f4637          	lui	a2,0xf4
    80005972:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005976:	9732                	add	a4,a4,a2
    80005978:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000597a:	00259693          	slli	a3,a1,0x2
    8000597e:	96ae                	add	a3,a3,a1
    80005980:	068e                	slli	a3,a3,0x3
    80005982:	0001b717          	auipc	a4,0x1b
    80005986:	67e70713          	addi	a4,a4,1662 # 80021000 <timer_scratch>
    8000598a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000598c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000598e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005990:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005994:	00000797          	auipc	a5,0x0
    80005998:	99c78793          	addi	a5,a5,-1636 # 80005330 <timervec>
    8000599c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059a0:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800059a4:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800059ac:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800059b0:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800059b4:	30479073          	csrw	mie,a5
}
    800059b8:	6422                	ld	s0,8(sp)
    800059ba:	0141                	addi	sp,sp,16
    800059bc:	8082                	ret

00000000800059be <start>:
{
    800059be:	1141                	addi	sp,sp,-16
    800059c0:	e406                	sd	ra,8(sp)
    800059c2:	e022                	sd	s0,0(sp)
    800059c4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059c6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800059ca:	7779                	lui	a4,0xffffe
    800059cc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd55bf>
    800059d0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800059d2:	6705                	lui	a4,0x1
    800059d4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800059d8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059da:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800059de:	ffffb797          	auipc	a5,0xffffb
    800059e2:	93a78793          	addi	a5,a5,-1734 # 80000318 <main>
    800059e6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800059ea:	4781                	li	a5,0
    800059ec:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800059f0:	67c1                	lui	a5,0x10
    800059f2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800059f4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800059f8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800059fc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a00:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005a04:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005a08:	57fd                	li	a5,-1
    80005a0a:	83a9                	srli	a5,a5,0xa
    80005a0c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005a10:	47bd                	li	a5,15
    80005a12:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a16:	00000097          	auipc	ra,0x0
    80005a1a:	f38080e7          	jalr	-200(ra) # 8000594e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a1e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a22:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005a24:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a26:	30200073          	mret
}
    80005a2a:	60a2                	ld	ra,8(sp)
    80005a2c:	6402                	ld	s0,0(sp)
    80005a2e:	0141                	addi	sp,sp,16
    80005a30:	8082                	ret

0000000080005a32 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a32:	715d                	addi	sp,sp,-80
    80005a34:	e486                	sd	ra,72(sp)
    80005a36:	e0a2                	sd	s0,64(sp)
    80005a38:	f84a                	sd	s2,48(sp)
    80005a3a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a3c:	04c05663          	blez	a2,80005a88 <consolewrite+0x56>
    80005a40:	fc26                	sd	s1,56(sp)
    80005a42:	f44e                	sd	s3,40(sp)
    80005a44:	f052                	sd	s4,32(sp)
    80005a46:	ec56                	sd	s5,24(sp)
    80005a48:	8a2a                	mv	s4,a0
    80005a4a:	84ae                	mv	s1,a1
    80005a4c:	89b2                	mv	s3,a2
    80005a4e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a50:	5afd                	li	s5,-1
    80005a52:	4685                	li	a3,1
    80005a54:	8626                	mv	a2,s1
    80005a56:	85d2                	mv	a1,s4
    80005a58:	fbf40513          	addi	a0,s0,-65
    80005a5c:	ffffc097          	auipc	ra,0xffffc
    80005a60:	06e080e7          	jalr	110(ra) # 80001aca <either_copyin>
    80005a64:	03550463          	beq	a0,s5,80005a8c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005a68:	fbf44503          	lbu	a0,-65(s0)
    80005a6c:	00000097          	auipc	ra,0x0
    80005a70:	7de080e7          	jalr	2014(ra) # 8000624a <uartputc>
  for(i = 0; i < n; i++){
    80005a74:	2905                	addiw	s2,s2,1
    80005a76:	0485                	addi	s1,s1,1
    80005a78:	fd299de3          	bne	s3,s2,80005a52 <consolewrite+0x20>
    80005a7c:	894e                	mv	s2,s3
    80005a7e:	74e2                	ld	s1,56(sp)
    80005a80:	79a2                	ld	s3,40(sp)
    80005a82:	7a02                	ld	s4,32(sp)
    80005a84:	6ae2                	ld	s5,24(sp)
    80005a86:	a039                	j	80005a94 <consolewrite+0x62>
    80005a88:	4901                	li	s2,0
    80005a8a:	a029                	j	80005a94 <consolewrite+0x62>
    80005a8c:	74e2                	ld	s1,56(sp)
    80005a8e:	79a2                	ld	s3,40(sp)
    80005a90:	7a02                	ld	s4,32(sp)
    80005a92:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005a94:	854a                	mv	a0,s2
    80005a96:	60a6                	ld	ra,72(sp)
    80005a98:	6406                	ld	s0,64(sp)
    80005a9a:	7942                	ld	s2,48(sp)
    80005a9c:	6161                	addi	sp,sp,80
    80005a9e:	8082                	ret

0000000080005aa0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005aa0:	711d                	addi	sp,sp,-96
    80005aa2:	ec86                	sd	ra,88(sp)
    80005aa4:	e8a2                	sd	s0,80(sp)
    80005aa6:	e4a6                	sd	s1,72(sp)
    80005aa8:	e0ca                	sd	s2,64(sp)
    80005aaa:	fc4e                	sd	s3,56(sp)
    80005aac:	f852                	sd	s4,48(sp)
    80005aae:	f456                	sd	s5,40(sp)
    80005ab0:	f05a                	sd	s6,32(sp)
    80005ab2:	1080                	addi	s0,sp,96
    80005ab4:	8aaa                	mv	s5,a0
    80005ab6:	8a2e                	mv	s4,a1
    80005ab8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005aba:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005abe:	00023517          	auipc	a0,0x23
    80005ac2:	68250513          	addi	a0,a0,1666 # 80029140 <cons>
    80005ac6:	00001097          	auipc	ra,0x1
    80005aca:	940080e7          	jalr	-1728(ra) # 80006406 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005ace:	00023497          	auipc	s1,0x23
    80005ad2:	67248493          	addi	s1,s1,1650 # 80029140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005ad6:	00023917          	auipc	s2,0x23
    80005ada:	70290913          	addi	s2,s2,1794 # 800291d8 <cons+0x98>
  while(n > 0){
    80005ade:	0d305463          	blez	s3,80005ba6 <consoleread+0x106>
    while(cons.r == cons.w){
    80005ae2:	0984a783          	lw	a5,152(s1)
    80005ae6:	09c4a703          	lw	a4,156(s1)
    80005aea:	0af71963          	bne	a4,a5,80005b9c <consoleread+0xfc>
      if(myproc()->killed){
    80005aee:	ffffb097          	auipc	ra,0xffffb
    80005af2:	472080e7          	jalr	1138(ra) # 80000f60 <myproc>
    80005af6:	551c                	lw	a5,40(a0)
    80005af8:	e7ad                	bnez	a5,80005b62 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80005afa:	85a6                	mv	a1,s1
    80005afc:	854a                	mv	a0,s2
    80005afe:	ffffc097          	auipc	ra,0xffffc
    80005b02:	bd2080e7          	jalr	-1070(ra) # 800016d0 <sleep>
    while(cons.r == cons.w){
    80005b06:	0984a783          	lw	a5,152(s1)
    80005b0a:	09c4a703          	lw	a4,156(s1)
    80005b0e:	fef700e3          	beq	a4,a5,80005aee <consoleread+0x4e>
    80005b12:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005b14:	00023717          	auipc	a4,0x23
    80005b18:	62c70713          	addi	a4,a4,1580 # 80029140 <cons>
    80005b1c:	0017869b          	addiw	a3,a5,1
    80005b20:	08d72c23          	sw	a3,152(a4)
    80005b24:	07f7f693          	andi	a3,a5,127
    80005b28:	9736                	add	a4,a4,a3
    80005b2a:	01874703          	lbu	a4,24(a4)
    80005b2e:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005b32:	4691                	li	a3,4
    80005b34:	04db8a63          	beq	s7,a3,80005b88 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005b38:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b3c:	4685                	li	a3,1
    80005b3e:	faf40613          	addi	a2,s0,-81
    80005b42:	85d2                	mv	a1,s4
    80005b44:	8556                	mv	a0,s5
    80005b46:	ffffc097          	auipc	ra,0xffffc
    80005b4a:	f2e080e7          	jalr	-210(ra) # 80001a74 <either_copyout>
    80005b4e:	57fd                	li	a5,-1
    80005b50:	04f50a63          	beq	a0,a5,80005ba4 <consoleread+0x104>
      break;

    dst++;
    80005b54:	0a05                	addi	s4,s4,1
    --n;
    80005b56:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005b58:	47a9                	li	a5,10
    80005b5a:	06fb8163          	beq	s7,a5,80005bbc <consoleread+0x11c>
    80005b5e:	6be2                	ld	s7,24(sp)
    80005b60:	bfbd                	j	80005ade <consoleread+0x3e>
        release(&cons.lock);
    80005b62:	00023517          	auipc	a0,0x23
    80005b66:	5de50513          	addi	a0,a0,1502 # 80029140 <cons>
    80005b6a:	00001097          	auipc	ra,0x1
    80005b6e:	950080e7          	jalr	-1712(ra) # 800064ba <release>
        return -1;
    80005b72:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005b74:	60e6                	ld	ra,88(sp)
    80005b76:	6446                	ld	s0,80(sp)
    80005b78:	64a6                	ld	s1,72(sp)
    80005b7a:	6906                	ld	s2,64(sp)
    80005b7c:	79e2                	ld	s3,56(sp)
    80005b7e:	7a42                	ld	s4,48(sp)
    80005b80:	7aa2                	ld	s5,40(sp)
    80005b82:	7b02                	ld	s6,32(sp)
    80005b84:	6125                	addi	sp,sp,96
    80005b86:	8082                	ret
      if(n < target){
    80005b88:	0009871b          	sext.w	a4,s3
    80005b8c:	01677a63          	bgeu	a4,s6,80005ba0 <consoleread+0x100>
        cons.r--;
    80005b90:	00023717          	auipc	a4,0x23
    80005b94:	64f72423          	sw	a5,1608(a4) # 800291d8 <cons+0x98>
    80005b98:	6be2                	ld	s7,24(sp)
    80005b9a:	a031                	j	80005ba6 <consoleread+0x106>
    80005b9c:	ec5e                	sd	s7,24(sp)
    80005b9e:	bf9d                	j	80005b14 <consoleread+0x74>
    80005ba0:	6be2                	ld	s7,24(sp)
    80005ba2:	a011                	j	80005ba6 <consoleread+0x106>
    80005ba4:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005ba6:	00023517          	auipc	a0,0x23
    80005baa:	59a50513          	addi	a0,a0,1434 # 80029140 <cons>
    80005bae:	00001097          	auipc	ra,0x1
    80005bb2:	90c080e7          	jalr	-1780(ra) # 800064ba <release>
  return target - n;
    80005bb6:	413b053b          	subw	a0,s6,s3
    80005bba:	bf6d                	j	80005b74 <consoleread+0xd4>
    80005bbc:	6be2                	ld	s7,24(sp)
    80005bbe:	b7e5                	j	80005ba6 <consoleread+0x106>

0000000080005bc0 <consputc>:
{
    80005bc0:	1141                	addi	sp,sp,-16
    80005bc2:	e406                	sd	ra,8(sp)
    80005bc4:	e022                	sd	s0,0(sp)
    80005bc6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005bc8:	10000793          	li	a5,256
    80005bcc:	00f50a63          	beq	a0,a5,80005be0 <consputc+0x20>
    uartputc_sync(c);
    80005bd0:	00000097          	auipc	ra,0x0
    80005bd4:	59c080e7          	jalr	1436(ra) # 8000616c <uartputc_sync>
}
    80005bd8:	60a2                	ld	ra,8(sp)
    80005bda:	6402                	ld	s0,0(sp)
    80005bdc:	0141                	addi	sp,sp,16
    80005bde:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005be0:	4521                	li	a0,8
    80005be2:	00000097          	auipc	ra,0x0
    80005be6:	58a080e7          	jalr	1418(ra) # 8000616c <uartputc_sync>
    80005bea:	02000513          	li	a0,32
    80005bee:	00000097          	auipc	ra,0x0
    80005bf2:	57e080e7          	jalr	1406(ra) # 8000616c <uartputc_sync>
    80005bf6:	4521                	li	a0,8
    80005bf8:	00000097          	auipc	ra,0x0
    80005bfc:	574080e7          	jalr	1396(ra) # 8000616c <uartputc_sync>
    80005c00:	bfe1                	j	80005bd8 <consputc+0x18>

0000000080005c02 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005c02:	1101                	addi	sp,sp,-32
    80005c04:	ec06                	sd	ra,24(sp)
    80005c06:	e822                	sd	s0,16(sp)
    80005c08:	e426                	sd	s1,8(sp)
    80005c0a:	1000                	addi	s0,sp,32
    80005c0c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c0e:	00023517          	auipc	a0,0x23
    80005c12:	53250513          	addi	a0,a0,1330 # 80029140 <cons>
    80005c16:	00000097          	auipc	ra,0x0
    80005c1a:	7f0080e7          	jalr	2032(ra) # 80006406 <acquire>

  switch(c){
    80005c1e:	47d5                	li	a5,21
    80005c20:	0af48563          	beq	s1,a5,80005cca <consoleintr+0xc8>
    80005c24:	0297c963          	blt	a5,s1,80005c56 <consoleintr+0x54>
    80005c28:	47a1                	li	a5,8
    80005c2a:	0ef48c63          	beq	s1,a5,80005d22 <consoleintr+0x120>
    80005c2e:	47c1                	li	a5,16
    80005c30:	10f49f63          	bne	s1,a5,80005d4e <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005c34:	ffffc097          	auipc	ra,0xffffc
    80005c38:	eec080e7          	jalr	-276(ra) # 80001b20 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c3c:	00023517          	auipc	a0,0x23
    80005c40:	50450513          	addi	a0,a0,1284 # 80029140 <cons>
    80005c44:	00001097          	auipc	ra,0x1
    80005c48:	876080e7          	jalr	-1930(ra) # 800064ba <release>
}
    80005c4c:	60e2                	ld	ra,24(sp)
    80005c4e:	6442                	ld	s0,16(sp)
    80005c50:	64a2                	ld	s1,8(sp)
    80005c52:	6105                	addi	sp,sp,32
    80005c54:	8082                	ret
  switch(c){
    80005c56:	07f00793          	li	a5,127
    80005c5a:	0cf48463          	beq	s1,a5,80005d22 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c5e:	00023717          	auipc	a4,0x23
    80005c62:	4e270713          	addi	a4,a4,1250 # 80029140 <cons>
    80005c66:	0a072783          	lw	a5,160(a4)
    80005c6a:	09872703          	lw	a4,152(a4)
    80005c6e:	9f99                	subw	a5,a5,a4
    80005c70:	07f00713          	li	a4,127
    80005c74:	fcf764e3          	bltu	a4,a5,80005c3c <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005c78:	47b5                	li	a5,13
    80005c7a:	0cf48d63          	beq	s1,a5,80005d54 <consoleintr+0x152>
      consputc(c);
    80005c7e:	8526                	mv	a0,s1
    80005c80:	00000097          	auipc	ra,0x0
    80005c84:	f40080e7          	jalr	-192(ra) # 80005bc0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c88:	00023797          	auipc	a5,0x23
    80005c8c:	4b878793          	addi	a5,a5,1208 # 80029140 <cons>
    80005c90:	0a07a703          	lw	a4,160(a5)
    80005c94:	0017069b          	addiw	a3,a4,1
    80005c98:	0006861b          	sext.w	a2,a3
    80005c9c:	0ad7a023          	sw	a3,160(a5)
    80005ca0:	07f77713          	andi	a4,a4,127
    80005ca4:	97ba                	add	a5,a5,a4
    80005ca6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005caa:	47a9                	li	a5,10
    80005cac:	0cf48b63          	beq	s1,a5,80005d82 <consoleintr+0x180>
    80005cb0:	4791                	li	a5,4
    80005cb2:	0cf48863          	beq	s1,a5,80005d82 <consoleintr+0x180>
    80005cb6:	00023797          	auipc	a5,0x23
    80005cba:	5227a783          	lw	a5,1314(a5) # 800291d8 <cons+0x98>
    80005cbe:	0807879b          	addiw	a5,a5,128
    80005cc2:	f6f61de3          	bne	a2,a5,80005c3c <consoleintr+0x3a>
    80005cc6:	863e                	mv	a2,a5
    80005cc8:	a86d                	j	80005d82 <consoleintr+0x180>
    80005cca:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005ccc:	00023717          	auipc	a4,0x23
    80005cd0:	47470713          	addi	a4,a4,1140 # 80029140 <cons>
    80005cd4:	0a072783          	lw	a5,160(a4)
    80005cd8:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005cdc:	00023497          	auipc	s1,0x23
    80005ce0:	46448493          	addi	s1,s1,1124 # 80029140 <cons>
    while(cons.e != cons.w &&
    80005ce4:	4929                	li	s2,10
    80005ce6:	02f70a63          	beq	a4,a5,80005d1a <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005cea:	37fd                	addiw	a5,a5,-1
    80005cec:	07f7f713          	andi	a4,a5,127
    80005cf0:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005cf2:	01874703          	lbu	a4,24(a4)
    80005cf6:	03270463          	beq	a4,s2,80005d1e <consoleintr+0x11c>
      cons.e--;
    80005cfa:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005cfe:	10000513          	li	a0,256
    80005d02:	00000097          	auipc	ra,0x0
    80005d06:	ebe080e7          	jalr	-322(ra) # 80005bc0 <consputc>
    while(cons.e != cons.w &&
    80005d0a:	0a04a783          	lw	a5,160(s1)
    80005d0e:	09c4a703          	lw	a4,156(s1)
    80005d12:	fcf71ce3          	bne	a4,a5,80005cea <consoleintr+0xe8>
    80005d16:	6902                	ld	s2,0(sp)
    80005d18:	b715                	j	80005c3c <consoleintr+0x3a>
    80005d1a:	6902                	ld	s2,0(sp)
    80005d1c:	b705                	j	80005c3c <consoleintr+0x3a>
    80005d1e:	6902                	ld	s2,0(sp)
    80005d20:	bf31                	j	80005c3c <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005d22:	00023717          	auipc	a4,0x23
    80005d26:	41e70713          	addi	a4,a4,1054 # 80029140 <cons>
    80005d2a:	0a072783          	lw	a5,160(a4)
    80005d2e:	09c72703          	lw	a4,156(a4)
    80005d32:	f0f705e3          	beq	a4,a5,80005c3c <consoleintr+0x3a>
      cons.e--;
    80005d36:	37fd                	addiw	a5,a5,-1
    80005d38:	00023717          	auipc	a4,0x23
    80005d3c:	4af72423          	sw	a5,1192(a4) # 800291e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005d40:	10000513          	li	a0,256
    80005d44:	00000097          	auipc	ra,0x0
    80005d48:	e7c080e7          	jalr	-388(ra) # 80005bc0 <consputc>
    80005d4c:	bdc5                	j	80005c3c <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005d4e:	ee0487e3          	beqz	s1,80005c3c <consoleintr+0x3a>
    80005d52:	b731                	j	80005c5e <consoleintr+0x5c>
      consputc(c);
    80005d54:	4529                	li	a0,10
    80005d56:	00000097          	auipc	ra,0x0
    80005d5a:	e6a080e7          	jalr	-406(ra) # 80005bc0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005d5e:	00023797          	auipc	a5,0x23
    80005d62:	3e278793          	addi	a5,a5,994 # 80029140 <cons>
    80005d66:	0a07a703          	lw	a4,160(a5)
    80005d6a:	0017069b          	addiw	a3,a4,1
    80005d6e:	0006861b          	sext.w	a2,a3
    80005d72:	0ad7a023          	sw	a3,160(a5)
    80005d76:	07f77713          	andi	a4,a4,127
    80005d7a:	97ba                	add	a5,a5,a4
    80005d7c:	4729                	li	a4,10
    80005d7e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d82:	00023797          	auipc	a5,0x23
    80005d86:	44c7ad23          	sw	a2,1114(a5) # 800291dc <cons+0x9c>
        wakeup(&cons.r);
    80005d8a:	00023517          	auipc	a0,0x23
    80005d8e:	44e50513          	addi	a0,a0,1102 # 800291d8 <cons+0x98>
    80005d92:	ffffc097          	auipc	ra,0xffffc
    80005d96:	aca080e7          	jalr	-1334(ra) # 8000185c <wakeup>
    80005d9a:	b54d                	j	80005c3c <consoleintr+0x3a>

0000000080005d9c <consoleinit>:

void
consoleinit(void)
{
    80005d9c:	1141                	addi	sp,sp,-16
    80005d9e:	e406                	sd	ra,8(sp)
    80005da0:	e022                	sd	s0,0(sp)
    80005da2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005da4:	00003597          	auipc	a1,0x3
    80005da8:	93458593          	addi	a1,a1,-1740 # 800086d8 <etext+0x6d8>
    80005dac:	00023517          	auipc	a0,0x23
    80005db0:	39450513          	addi	a0,a0,916 # 80029140 <cons>
    80005db4:	00000097          	auipc	ra,0x0
    80005db8:	5c2080e7          	jalr	1474(ra) # 80006376 <initlock>

  uartinit();
    80005dbc:	00000097          	auipc	ra,0x0
    80005dc0:	354080e7          	jalr	852(ra) # 80006110 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005dc4:	00016797          	auipc	a5,0x16
    80005dc8:	50478793          	addi	a5,a5,1284 # 8001c2c8 <devsw>
    80005dcc:	00000717          	auipc	a4,0x0
    80005dd0:	cd470713          	addi	a4,a4,-812 # 80005aa0 <consoleread>
    80005dd4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005dd6:	00000717          	auipc	a4,0x0
    80005dda:	c5c70713          	addi	a4,a4,-932 # 80005a32 <consolewrite>
    80005dde:	ef98                	sd	a4,24(a5)
}
    80005de0:	60a2                	ld	ra,8(sp)
    80005de2:	6402                	ld	s0,0(sp)
    80005de4:	0141                	addi	sp,sp,16
    80005de6:	8082                	ret

0000000080005de8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005de8:	7179                	addi	sp,sp,-48
    80005dea:	f406                	sd	ra,40(sp)
    80005dec:	f022                	sd	s0,32(sp)
    80005dee:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005df0:	c219                	beqz	a2,80005df6 <printint+0xe>
    80005df2:	08054963          	bltz	a0,80005e84 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005df6:	2501                	sext.w	a0,a0
    80005df8:	4881                	li	a7,0
    80005dfa:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005dfe:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005e00:	2581                	sext.w	a1,a1
    80005e02:	00003617          	auipc	a2,0x3
    80005e06:	a9660613          	addi	a2,a2,-1386 # 80008898 <digits>
    80005e0a:	883a                	mv	a6,a4
    80005e0c:	2705                	addiw	a4,a4,1
    80005e0e:	02b577bb          	remuw	a5,a0,a1
    80005e12:	1782                	slli	a5,a5,0x20
    80005e14:	9381                	srli	a5,a5,0x20
    80005e16:	97b2                	add	a5,a5,a2
    80005e18:	0007c783          	lbu	a5,0(a5)
    80005e1c:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005e20:	0005079b          	sext.w	a5,a0
    80005e24:	02b5553b          	divuw	a0,a0,a1
    80005e28:	0685                	addi	a3,a3,1
    80005e2a:	feb7f0e3          	bgeu	a5,a1,80005e0a <printint+0x22>

  if(sign)
    80005e2e:	00088c63          	beqz	a7,80005e46 <printint+0x5e>
    buf[i++] = '-';
    80005e32:	fe070793          	addi	a5,a4,-32
    80005e36:	00878733          	add	a4,a5,s0
    80005e3a:	02d00793          	li	a5,45
    80005e3e:	fef70823          	sb	a5,-16(a4)
    80005e42:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005e46:	02e05b63          	blez	a4,80005e7c <printint+0x94>
    80005e4a:	ec26                	sd	s1,24(sp)
    80005e4c:	e84a                	sd	s2,16(sp)
    80005e4e:	fd040793          	addi	a5,s0,-48
    80005e52:	00e784b3          	add	s1,a5,a4
    80005e56:	fff78913          	addi	s2,a5,-1
    80005e5a:	993a                	add	s2,s2,a4
    80005e5c:	377d                	addiw	a4,a4,-1
    80005e5e:	1702                	slli	a4,a4,0x20
    80005e60:	9301                	srli	a4,a4,0x20
    80005e62:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e66:	fff4c503          	lbu	a0,-1(s1)
    80005e6a:	00000097          	auipc	ra,0x0
    80005e6e:	d56080e7          	jalr	-682(ra) # 80005bc0 <consputc>
  while(--i >= 0)
    80005e72:	14fd                	addi	s1,s1,-1
    80005e74:	ff2499e3          	bne	s1,s2,80005e66 <printint+0x7e>
    80005e78:	64e2                	ld	s1,24(sp)
    80005e7a:	6942                	ld	s2,16(sp)
}
    80005e7c:	70a2                	ld	ra,40(sp)
    80005e7e:	7402                	ld	s0,32(sp)
    80005e80:	6145                	addi	sp,sp,48
    80005e82:	8082                	ret
    x = -xx;
    80005e84:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e88:	4885                	li	a7,1
    x = -xx;
    80005e8a:	bf85                	j	80005dfa <printint+0x12>

0000000080005e8c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e8c:	1101                	addi	sp,sp,-32
    80005e8e:	ec06                	sd	ra,24(sp)
    80005e90:	e822                	sd	s0,16(sp)
    80005e92:	e426                	sd	s1,8(sp)
    80005e94:	1000                	addi	s0,sp,32
    80005e96:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e98:	00023797          	auipc	a5,0x23
    80005e9c:	3607a423          	sw	zero,872(a5) # 80029200 <pr+0x18>
  printf("panic: ");
    80005ea0:	00003517          	auipc	a0,0x3
    80005ea4:	84050513          	addi	a0,a0,-1984 # 800086e0 <etext+0x6e0>
    80005ea8:	00000097          	auipc	ra,0x0
    80005eac:	02e080e7          	jalr	46(ra) # 80005ed6 <printf>
  printf(s);
    80005eb0:	8526                	mv	a0,s1
    80005eb2:	00000097          	auipc	ra,0x0
    80005eb6:	024080e7          	jalr	36(ra) # 80005ed6 <printf>
  printf("\n");
    80005eba:	00002517          	auipc	a0,0x2
    80005ebe:	15e50513          	addi	a0,a0,350 # 80008018 <etext+0x18>
    80005ec2:	00000097          	auipc	ra,0x0
    80005ec6:	014080e7          	jalr	20(ra) # 80005ed6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005eca:	4785                	li	a5,1
    80005ecc:	00006717          	auipc	a4,0x6
    80005ed0:	14f72823          	sw	a5,336(a4) # 8000c01c <panicked>
  for(;;)
    80005ed4:	a001                	j	80005ed4 <panic+0x48>

0000000080005ed6 <printf>:
{
    80005ed6:	7131                	addi	sp,sp,-192
    80005ed8:	fc86                	sd	ra,120(sp)
    80005eda:	f8a2                	sd	s0,112(sp)
    80005edc:	e8d2                	sd	s4,80(sp)
    80005ede:	f06a                	sd	s10,32(sp)
    80005ee0:	0100                	addi	s0,sp,128
    80005ee2:	8a2a                	mv	s4,a0
    80005ee4:	e40c                	sd	a1,8(s0)
    80005ee6:	e810                	sd	a2,16(s0)
    80005ee8:	ec14                	sd	a3,24(s0)
    80005eea:	f018                	sd	a4,32(s0)
    80005eec:	f41c                	sd	a5,40(s0)
    80005eee:	03043823          	sd	a6,48(s0)
    80005ef2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005ef6:	00023d17          	auipc	s10,0x23
    80005efa:	30ad2d03          	lw	s10,778(s10) # 80029200 <pr+0x18>
  if(locking)
    80005efe:	040d1463          	bnez	s10,80005f46 <printf+0x70>
  if (fmt == 0)
    80005f02:	040a0b63          	beqz	s4,80005f58 <printf+0x82>
  va_start(ap, fmt);
    80005f06:	00840793          	addi	a5,s0,8
    80005f0a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f0e:	000a4503          	lbu	a0,0(s4)
    80005f12:	18050b63          	beqz	a0,800060a8 <printf+0x1d2>
    80005f16:	f4a6                	sd	s1,104(sp)
    80005f18:	f0ca                	sd	s2,96(sp)
    80005f1a:	ecce                	sd	s3,88(sp)
    80005f1c:	e4d6                	sd	s5,72(sp)
    80005f1e:	e0da                	sd	s6,64(sp)
    80005f20:	fc5e                	sd	s7,56(sp)
    80005f22:	f862                	sd	s8,48(sp)
    80005f24:	f466                	sd	s9,40(sp)
    80005f26:	ec6e                	sd	s11,24(sp)
    80005f28:	4981                	li	s3,0
    if(c != '%'){
    80005f2a:	02500b13          	li	s6,37
    switch(c){
    80005f2e:	07000b93          	li	s7,112
  consputc('x');
    80005f32:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f34:	00003a97          	auipc	s5,0x3
    80005f38:	964a8a93          	addi	s5,s5,-1692 # 80008898 <digits>
    switch(c){
    80005f3c:	07300c13          	li	s8,115
    80005f40:	06400d93          	li	s11,100
    80005f44:	a0b1                	j	80005f90 <printf+0xba>
    acquire(&pr.lock);
    80005f46:	00023517          	auipc	a0,0x23
    80005f4a:	2a250513          	addi	a0,a0,674 # 800291e8 <pr>
    80005f4e:	00000097          	auipc	ra,0x0
    80005f52:	4b8080e7          	jalr	1208(ra) # 80006406 <acquire>
    80005f56:	b775                	j	80005f02 <printf+0x2c>
    80005f58:	f4a6                	sd	s1,104(sp)
    80005f5a:	f0ca                	sd	s2,96(sp)
    80005f5c:	ecce                	sd	s3,88(sp)
    80005f5e:	e4d6                	sd	s5,72(sp)
    80005f60:	e0da                	sd	s6,64(sp)
    80005f62:	fc5e                	sd	s7,56(sp)
    80005f64:	f862                	sd	s8,48(sp)
    80005f66:	f466                	sd	s9,40(sp)
    80005f68:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005f6a:	00002517          	auipc	a0,0x2
    80005f6e:	78650513          	addi	a0,a0,1926 # 800086f0 <etext+0x6f0>
    80005f72:	00000097          	auipc	ra,0x0
    80005f76:	f1a080e7          	jalr	-230(ra) # 80005e8c <panic>
      consputc(c);
    80005f7a:	00000097          	auipc	ra,0x0
    80005f7e:	c46080e7          	jalr	-954(ra) # 80005bc0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f82:	2985                	addiw	s3,s3,1
    80005f84:	013a07b3          	add	a5,s4,s3
    80005f88:	0007c503          	lbu	a0,0(a5)
    80005f8c:	10050563          	beqz	a0,80006096 <printf+0x1c0>
    if(c != '%'){
    80005f90:	ff6515e3          	bne	a0,s6,80005f7a <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005f94:	2985                	addiw	s3,s3,1
    80005f96:	013a07b3          	add	a5,s4,s3
    80005f9a:	0007c783          	lbu	a5,0(a5)
    80005f9e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005fa2:	10078b63          	beqz	a5,800060b8 <printf+0x1e2>
    switch(c){
    80005fa6:	05778a63          	beq	a5,s7,80005ffa <printf+0x124>
    80005faa:	02fbf663          	bgeu	s7,a5,80005fd6 <printf+0x100>
    80005fae:	09878863          	beq	a5,s8,8000603e <printf+0x168>
    80005fb2:	07800713          	li	a4,120
    80005fb6:	0ce79563          	bne	a5,a4,80006080 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80005fba:	f8843783          	ld	a5,-120(s0)
    80005fbe:	00878713          	addi	a4,a5,8
    80005fc2:	f8e43423          	sd	a4,-120(s0)
    80005fc6:	4605                	li	a2,1
    80005fc8:	85e6                	mv	a1,s9
    80005fca:	4388                	lw	a0,0(a5)
    80005fcc:	00000097          	auipc	ra,0x0
    80005fd0:	e1c080e7          	jalr	-484(ra) # 80005de8 <printint>
      break;
    80005fd4:	b77d                	j	80005f82 <printf+0xac>
    switch(c){
    80005fd6:	09678f63          	beq	a5,s6,80006074 <printf+0x19e>
    80005fda:	0bb79363          	bne	a5,s11,80006080 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80005fde:	f8843783          	ld	a5,-120(s0)
    80005fe2:	00878713          	addi	a4,a5,8
    80005fe6:	f8e43423          	sd	a4,-120(s0)
    80005fea:	4605                	li	a2,1
    80005fec:	45a9                	li	a1,10
    80005fee:	4388                	lw	a0,0(a5)
    80005ff0:	00000097          	auipc	ra,0x0
    80005ff4:	df8080e7          	jalr	-520(ra) # 80005de8 <printint>
      break;
    80005ff8:	b769                	j	80005f82 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005ffa:	f8843783          	ld	a5,-120(s0)
    80005ffe:	00878713          	addi	a4,a5,8
    80006002:	f8e43423          	sd	a4,-120(s0)
    80006006:	0007b903          	ld	s2,0(a5)
  consputc('0');
    8000600a:	03000513          	li	a0,48
    8000600e:	00000097          	auipc	ra,0x0
    80006012:	bb2080e7          	jalr	-1102(ra) # 80005bc0 <consputc>
  consputc('x');
    80006016:	07800513          	li	a0,120
    8000601a:	00000097          	auipc	ra,0x0
    8000601e:	ba6080e7          	jalr	-1114(ra) # 80005bc0 <consputc>
    80006022:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006024:	03c95793          	srli	a5,s2,0x3c
    80006028:	97d6                	add	a5,a5,s5
    8000602a:	0007c503          	lbu	a0,0(a5)
    8000602e:	00000097          	auipc	ra,0x0
    80006032:	b92080e7          	jalr	-1134(ra) # 80005bc0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006036:	0912                	slli	s2,s2,0x4
    80006038:	34fd                	addiw	s1,s1,-1
    8000603a:	f4ed                	bnez	s1,80006024 <printf+0x14e>
    8000603c:	b799                	j	80005f82 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    8000603e:	f8843783          	ld	a5,-120(s0)
    80006042:	00878713          	addi	a4,a5,8
    80006046:	f8e43423          	sd	a4,-120(s0)
    8000604a:	6384                	ld	s1,0(a5)
    8000604c:	cc89                	beqz	s1,80006066 <printf+0x190>
      for(; *s; s++)
    8000604e:	0004c503          	lbu	a0,0(s1)
    80006052:	d905                	beqz	a0,80005f82 <printf+0xac>
        consputc(*s);
    80006054:	00000097          	auipc	ra,0x0
    80006058:	b6c080e7          	jalr	-1172(ra) # 80005bc0 <consputc>
      for(; *s; s++)
    8000605c:	0485                	addi	s1,s1,1
    8000605e:	0004c503          	lbu	a0,0(s1)
    80006062:	f96d                	bnez	a0,80006054 <printf+0x17e>
    80006064:	bf39                	j	80005f82 <printf+0xac>
        s = "(null)";
    80006066:	00002497          	auipc	s1,0x2
    8000606a:	68248493          	addi	s1,s1,1666 # 800086e8 <etext+0x6e8>
      for(; *s; s++)
    8000606e:	02800513          	li	a0,40
    80006072:	b7cd                	j	80006054 <printf+0x17e>
      consputc('%');
    80006074:	855a                	mv	a0,s6
    80006076:	00000097          	auipc	ra,0x0
    8000607a:	b4a080e7          	jalr	-1206(ra) # 80005bc0 <consputc>
      break;
    8000607e:	b711                	j	80005f82 <printf+0xac>
      consputc('%');
    80006080:	855a                	mv	a0,s6
    80006082:	00000097          	auipc	ra,0x0
    80006086:	b3e080e7          	jalr	-1218(ra) # 80005bc0 <consputc>
      consputc(c);
    8000608a:	8526                	mv	a0,s1
    8000608c:	00000097          	auipc	ra,0x0
    80006090:	b34080e7          	jalr	-1228(ra) # 80005bc0 <consputc>
      break;
    80006094:	b5fd                	j	80005f82 <printf+0xac>
    80006096:	74a6                	ld	s1,104(sp)
    80006098:	7906                	ld	s2,96(sp)
    8000609a:	69e6                	ld	s3,88(sp)
    8000609c:	6aa6                	ld	s5,72(sp)
    8000609e:	6b06                	ld	s6,64(sp)
    800060a0:	7be2                	ld	s7,56(sp)
    800060a2:	7c42                	ld	s8,48(sp)
    800060a4:	7ca2                	ld	s9,40(sp)
    800060a6:	6de2                	ld	s11,24(sp)
  if(locking)
    800060a8:	020d1263          	bnez	s10,800060cc <printf+0x1f6>
}
    800060ac:	70e6                	ld	ra,120(sp)
    800060ae:	7446                	ld	s0,112(sp)
    800060b0:	6a46                	ld	s4,80(sp)
    800060b2:	7d02                	ld	s10,32(sp)
    800060b4:	6129                	addi	sp,sp,192
    800060b6:	8082                	ret
    800060b8:	74a6                	ld	s1,104(sp)
    800060ba:	7906                	ld	s2,96(sp)
    800060bc:	69e6                	ld	s3,88(sp)
    800060be:	6aa6                	ld	s5,72(sp)
    800060c0:	6b06                	ld	s6,64(sp)
    800060c2:	7be2                	ld	s7,56(sp)
    800060c4:	7c42                	ld	s8,48(sp)
    800060c6:	7ca2                	ld	s9,40(sp)
    800060c8:	6de2                	ld	s11,24(sp)
    800060ca:	bff9                	j	800060a8 <printf+0x1d2>
    release(&pr.lock);
    800060cc:	00023517          	auipc	a0,0x23
    800060d0:	11c50513          	addi	a0,a0,284 # 800291e8 <pr>
    800060d4:	00000097          	auipc	ra,0x0
    800060d8:	3e6080e7          	jalr	998(ra) # 800064ba <release>
}
    800060dc:	bfc1                	j	800060ac <printf+0x1d6>

00000000800060de <printfinit>:
    ;
}

void
printfinit(void)
{
    800060de:	1101                	addi	sp,sp,-32
    800060e0:	ec06                	sd	ra,24(sp)
    800060e2:	e822                	sd	s0,16(sp)
    800060e4:	e426                	sd	s1,8(sp)
    800060e6:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800060e8:	00023497          	auipc	s1,0x23
    800060ec:	10048493          	addi	s1,s1,256 # 800291e8 <pr>
    800060f0:	00002597          	auipc	a1,0x2
    800060f4:	61058593          	addi	a1,a1,1552 # 80008700 <etext+0x700>
    800060f8:	8526                	mv	a0,s1
    800060fa:	00000097          	auipc	ra,0x0
    800060fe:	27c080e7          	jalr	636(ra) # 80006376 <initlock>
  pr.locking = 1;
    80006102:	4785                	li	a5,1
    80006104:	cc9c                	sw	a5,24(s1)
}
    80006106:	60e2                	ld	ra,24(sp)
    80006108:	6442                	ld	s0,16(sp)
    8000610a:	64a2                	ld	s1,8(sp)
    8000610c:	6105                	addi	sp,sp,32
    8000610e:	8082                	ret

0000000080006110 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006110:	1141                	addi	sp,sp,-16
    80006112:	e406                	sd	ra,8(sp)
    80006114:	e022                	sd	s0,0(sp)
    80006116:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006118:	100007b7          	lui	a5,0x10000
    8000611c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006120:	10000737          	lui	a4,0x10000
    80006124:	f8000693          	li	a3,-128
    80006128:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000612c:	468d                	li	a3,3
    8000612e:	10000637          	lui	a2,0x10000
    80006132:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006136:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000613a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000613e:	10000737          	lui	a4,0x10000
    80006142:	461d                	li	a2,7
    80006144:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006148:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000614c:	00002597          	auipc	a1,0x2
    80006150:	5bc58593          	addi	a1,a1,1468 # 80008708 <etext+0x708>
    80006154:	00023517          	auipc	a0,0x23
    80006158:	0b450513          	addi	a0,a0,180 # 80029208 <uart_tx_lock>
    8000615c:	00000097          	auipc	ra,0x0
    80006160:	21a080e7          	jalr	538(ra) # 80006376 <initlock>
}
    80006164:	60a2                	ld	ra,8(sp)
    80006166:	6402                	ld	s0,0(sp)
    80006168:	0141                	addi	sp,sp,16
    8000616a:	8082                	ret

000000008000616c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000616c:	1101                	addi	sp,sp,-32
    8000616e:	ec06                	sd	ra,24(sp)
    80006170:	e822                	sd	s0,16(sp)
    80006172:	e426                	sd	s1,8(sp)
    80006174:	1000                	addi	s0,sp,32
    80006176:	84aa                	mv	s1,a0
  push_off();
    80006178:	00000097          	auipc	ra,0x0
    8000617c:	242080e7          	jalr	578(ra) # 800063ba <push_off>

  if(panicked){
    80006180:	00006797          	auipc	a5,0x6
    80006184:	e9c7a783          	lw	a5,-356(a5) # 8000c01c <panicked>
    80006188:	eb85                	bnez	a5,800061b8 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000618a:	10000737          	lui	a4,0x10000
    8000618e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006190:	00074783          	lbu	a5,0(a4)
    80006194:	0207f793          	andi	a5,a5,32
    80006198:	dfe5                	beqz	a5,80006190 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000619a:	0ff4f513          	zext.b	a0,s1
    8000619e:	100007b7          	lui	a5,0x10000
    800061a2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800061a6:	00000097          	auipc	ra,0x0
    800061aa:	2b4080e7          	jalr	692(ra) # 8000645a <pop_off>
}
    800061ae:	60e2                	ld	ra,24(sp)
    800061b0:	6442                	ld	s0,16(sp)
    800061b2:	64a2                	ld	s1,8(sp)
    800061b4:	6105                	addi	sp,sp,32
    800061b6:	8082                	ret
    for(;;)
    800061b8:	a001                	j	800061b8 <uartputc_sync+0x4c>

00000000800061ba <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800061ba:	00006797          	auipc	a5,0x6
    800061be:	e667b783          	ld	a5,-410(a5) # 8000c020 <uart_tx_r>
    800061c2:	00006717          	auipc	a4,0x6
    800061c6:	e6673703          	ld	a4,-410(a4) # 8000c028 <uart_tx_w>
    800061ca:	06f70f63          	beq	a4,a5,80006248 <uartstart+0x8e>
{
    800061ce:	7139                	addi	sp,sp,-64
    800061d0:	fc06                	sd	ra,56(sp)
    800061d2:	f822                	sd	s0,48(sp)
    800061d4:	f426                	sd	s1,40(sp)
    800061d6:	f04a                	sd	s2,32(sp)
    800061d8:	ec4e                	sd	s3,24(sp)
    800061da:	e852                	sd	s4,16(sp)
    800061dc:	e456                	sd	s5,8(sp)
    800061de:	e05a                	sd	s6,0(sp)
    800061e0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061e2:	10000937          	lui	s2,0x10000
    800061e6:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061e8:	00023a97          	auipc	s5,0x23
    800061ec:	020a8a93          	addi	s5,s5,32 # 80029208 <uart_tx_lock>
    uart_tx_r += 1;
    800061f0:	00006497          	auipc	s1,0x6
    800061f4:	e3048493          	addi	s1,s1,-464 # 8000c020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800061f8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800061fc:	00006997          	auipc	s3,0x6
    80006200:	e2c98993          	addi	s3,s3,-468 # 8000c028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006204:	00094703          	lbu	a4,0(s2)
    80006208:	02077713          	andi	a4,a4,32
    8000620c:	c705                	beqz	a4,80006234 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000620e:	01f7f713          	andi	a4,a5,31
    80006212:	9756                	add	a4,a4,s5
    80006214:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80006218:	0785                	addi	a5,a5,1
    8000621a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000621c:	8526                	mv	a0,s1
    8000621e:	ffffb097          	auipc	ra,0xffffb
    80006222:	63e080e7          	jalr	1598(ra) # 8000185c <wakeup>
    WriteReg(THR, c);
    80006226:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000622a:	609c                	ld	a5,0(s1)
    8000622c:	0009b703          	ld	a4,0(s3)
    80006230:	fcf71ae3          	bne	a4,a5,80006204 <uartstart+0x4a>
  }
}
    80006234:	70e2                	ld	ra,56(sp)
    80006236:	7442                	ld	s0,48(sp)
    80006238:	74a2                	ld	s1,40(sp)
    8000623a:	7902                	ld	s2,32(sp)
    8000623c:	69e2                	ld	s3,24(sp)
    8000623e:	6a42                	ld	s4,16(sp)
    80006240:	6aa2                	ld	s5,8(sp)
    80006242:	6b02                	ld	s6,0(sp)
    80006244:	6121                	addi	sp,sp,64
    80006246:	8082                	ret
    80006248:	8082                	ret

000000008000624a <uartputc>:
{
    8000624a:	7179                	addi	sp,sp,-48
    8000624c:	f406                	sd	ra,40(sp)
    8000624e:	f022                	sd	s0,32(sp)
    80006250:	e052                	sd	s4,0(sp)
    80006252:	1800                	addi	s0,sp,48
    80006254:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006256:	00023517          	auipc	a0,0x23
    8000625a:	fb250513          	addi	a0,a0,-78 # 80029208 <uart_tx_lock>
    8000625e:	00000097          	auipc	ra,0x0
    80006262:	1a8080e7          	jalr	424(ra) # 80006406 <acquire>
  if(panicked){
    80006266:	00006797          	auipc	a5,0x6
    8000626a:	db67a783          	lw	a5,-586(a5) # 8000c01c <panicked>
    8000626e:	c391                	beqz	a5,80006272 <uartputc+0x28>
    for(;;)
    80006270:	a001                	j	80006270 <uartputc+0x26>
    80006272:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006274:	00006717          	auipc	a4,0x6
    80006278:	db473703          	ld	a4,-588(a4) # 8000c028 <uart_tx_w>
    8000627c:	00006797          	auipc	a5,0x6
    80006280:	da47b783          	ld	a5,-604(a5) # 8000c020 <uart_tx_r>
    80006284:	02078793          	addi	a5,a5,32
    80006288:	02e79f63          	bne	a5,a4,800062c6 <uartputc+0x7c>
    8000628c:	e84a                	sd	s2,16(sp)
    8000628e:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    80006290:	00023997          	auipc	s3,0x23
    80006294:	f7898993          	addi	s3,s3,-136 # 80029208 <uart_tx_lock>
    80006298:	00006497          	auipc	s1,0x6
    8000629c:	d8848493          	addi	s1,s1,-632 # 8000c020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062a0:	00006917          	auipc	s2,0x6
    800062a4:	d8890913          	addi	s2,s2,-632 # 8000c028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800062a8:	85ce                	mv	a1,s3
    800062aa:	8526                	mv	a0,s1
    800062ac:	ffffb097          	auipc	ra,0xffffb
    800062b0:	424080e7          	jalr	1060(ra) # 800016d0 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062b4:	00093703          	ld	a4,0(s2)
    800062b8:	609c                	ld	a5,0(s1)
    800062ba:	02078793          	addi	a5,a5,32
    800062be:	fee785e3          	beq	a5,a4,800062a8 <uartputc+0x5e>
    800062c2:	6942                	ld	s2,16(sp)
    800062c4:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800062c6:	00023497          	auipc	s1,0x23
    800062ca:	f4248493          	addi	s1,s1,-190 # 80029208 <uart_tx_lock>
    800062ce:	01f77793          	andi	a5,a4,31
    800062d2:	97a6                	add	a5,a5,s1
    800062d4:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800062d8:	0705                	addi	a4,a4,1
    800062da:	00006797          	auipc	a5,0x6
    800062de:	d4e7b723          	sd	a4,-690(a5) # 8000c028 <uart_tx_w>
      uartstart();
    800062e2:	00000097          	auipc	ra,0x0
    800062e6:	ed8080e7          	jalr	-296(ra) # 800061ba <uartstart>
      release(&uart_tx_lock);
    800062ea:	8526                	mv	a0,s1
    800062ec:	00000097          	auipc	ra,0x0
    800062f0:	1ce080e7          	jalr	462(ra) # 800064ba <release>
    800062f4:	64e2                	ld	s1,24(sp)
}
    800062f6:	70a2                	ld	ra,40(sp)
    800062f8:	7402                	ld	s0,32(sp)
    800062fa:	6a02                	ld	s4,0(sp)
    800062fc:	6145                	addi	sp,sp,48
    800062fe:	8082                	ret

0000000080006300 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006300:	1141                	addi	sp,sp,-16
    80006302:	e422                	sd	s0,8(sp)
    80006304:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006306:	100007b7          	lui	a5,0x10000
    8000630a:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000630c:	0007c783          	lbu	a5,0(a5)
    80006310:	8b85                	andi	a5,a5,1
    80006312:	cb81                	beqz	a5,80006322 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80006314:	100007b7          	lui	a5,0x10000
    80006318:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000631c:	6422                	ld	s0,8(sp)
    8000631e:	0141                	addi	sp,sp,16
    80006320:	8082                	ret
    return -1;
    80006322:	557d                	li	a0,-1
    80006324:	bfe5                	j	8000631c <uartgetc+0x1c>

0000000080006326 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006326:	1101                	addi	sp,sp,-32
    80006328:	ec06                	sd	ra,24(sp)
    8000632a:	e822                	sd	s0,16(sp)
    8000632c:	e426                	sd	s1,8(sp)
    8000632e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006330:	54fd                	li	s1,-1
    80006332:	a029                	j	8000633c <uartintr+0x16>
      break;
    consoleintr(c);
    80006334:	00000097          	auipc	ra,0x0
    80006338:	8ce080e7          	jalr	-1842(ra) # 80005c02 <consoleintr>
    int c = uartgetc();
    8000633c:	00000097          	auipc	ra,0x0
    80006340:	fc4080e7          	jalr	-60(ra) # 80006300 <uartgetc>
    if(c == -1)
    80006344:	fe9518e3          	bne	a0,s1,80006334 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006348:	00023497          	auipc	s1,0x23
    8000634c:	ec048493          	addi	s1,s1,-320 # 80029208 <uart_tx_lock>
    80006350:	8526                	mv	a0,s1
    80006352:	00000097          	auipc	ra,0x0
    80006356:	0b4080e7          	jalr	180(ra) # 80006406 <acquire>
  uartstart();
    8000635a:	00000097          	auipc	ra,0x0
    8000635e:	e60080e7          	jalr	-416(ra) # 800061ba <uartstart>
  release(&uart_tx_lock);
    80006362:	8526                	mv	a0,s1
    80006364:	00000097          	auipc	ra,0x0
    80006368:	156080e7          	jalr	342(ra) # 800064ba <release>
}
    8000636c:	60e2                	ld	ra,24(sp)
    8000636e:	6442                	ld	s0,16(sp)
    80006370:	64a2                	ld	s1,8(sp)
    80006372:	6105                	addi	sp,sp,32
    80006374:	8082                	ret

0000000080006376 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006376:	1141                	addi	sp,sp,-16
    80006378:	e422                	sd	s0,8(sp)
    8000637a:	0800                	addi	s0,sp,16
  lk->name = name;
    8000637c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000637e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006382:	00053823          	sd	zero,16(a0)
}
    80006386:	6422                	ld	s0,8(sp)
    80006388:	0141                	addi	sp,sp,16
    8000638a:	8082                	ret

000000008000638c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000638c:	411c                	lw	a5,0(a0)
    8000638e:	e399                	bnez	a5,80006394 <holding+0x8>
    80006390:	4501                	li	a0,0
  return r;
}
    80006392:	8082                	ret
{
    80006394:	1101                	addi	sp,sp,-32
    80006396:	ec06                	sd	ra,24(sp)
    80006398:	e822                	sd	s0,16(sp)
    8000639a:	e426                	sd	s1,8(sp)
    8000639c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000639e:	6904                	ld	s1,16(a0)
    800063a0:	ffffb097          	auipc	ra,0xffffb
    800063a4:	ba4080e7          	jalr	-1116(ra) # 80000f44 <mycpu>
    800063a8:	40a48533          	sub	a0,s1,a0
    800063ac:	00153513          	seqz	a0,a0
}
    800063b0:	60e2                	ld	ra,24(sp)
    800063b2:	6442                	ld	s0,16(sp)
    800063b4:	64a2                	ld	s1,8(sp)
    800063b6:	6105                	addi	sp,sp,32
    800063b8:	8082                	ret

00000000800063ba <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800063ba:	1101                	addi	sp,sp,-32
    800063bc:	ec06                	sd	ra,24(sp)
    800063be:	e822                	sd	s0,16(sp)
    800063c0:	e426                	sd	s1,8(sp)
    800063c2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063c4:	100024f3          	csrr	s1,sstatus
    800063c8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800063cc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063ce:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800063d2:	ffffb097          	auipc	ra,0xffffb
    800063d6:	b72080e7          	jalr	-1166(ra) # 80000f44 <mycpu>
    800063da:	5d3c                	lw	a5,120(a0)
    800063dc:	cf89                	beqz	a5,800063f6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800063de:	ffffb097          	auipc	ra,0xffffb
    800063e2:	b66080e7          	jalr	-1178(ra) # 80000f44 <mycpu>
    800063e6:	5d3c                	lw	a5,120(a0)
    800063e8:	2785                	addiw	a5,a5,1
    800063ea:	dd3c                	sw	a5,120(a0)
}
    800063ec:	60e2                	ld	ra,24(sp)
    800063ee:	6442                	ld	s0,16(sp)
    800063f0:	64a2                	ld	s1,8(sp)
    800063f2:	6105                	addi	sp,sp,32
    800063f4:	8082                	ret
    mycpu()->intena = old;
    800063f6:	ffffb097          	auipc	ra,0xffffb
    800063fa:	b4e080e7          	jalr	-1202(ra) # 80000f44 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800063fe:	8085                	srli	s1,s1,0x1
    80006400:	8885                	andi	s1,s1,1
    80006402:	dd64                	sw	s1,124(a0)
    80006404:	bfe9                	j	800063de <push_off+0x24>

0000000080006406 <acquire>:
{
    80006406:	1101                	addi	sp,sp,-32
    80006408:	ec06                	sd	ra,24(sp)
    8000640a:	e822                	sd	s0,16(sp)
    8000640c:	e426                	sd	s1,8(sp)
    8000640e:	1000                	addi	s0,sp,32
    80006410:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006412:	00000097          	auipc	ra,0x0
    80006416:	fa8080e7          	jalr	-88(ra) # 800063ba <push_off>
  if(holding(lk))
    8000641a:	8526                	mv	a0,s1
    8000641c:	00000097          	auipc	ra,0x0
    80006420:	f70080e7          	jalr	-144(ra) # 8000638c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006424:	4705                	li	a4,1
  if(holding(lk))
    80006426:	e115                	bnez	a0,8000644a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006428:	87ba                	mv	a5,a4
    8000642a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000642e:	2781                	sext.w	a5,a5
    80006430:	ffe5                	bnez	a5,80006428 <acquire+0x22>
  __sync_synchronize();
    80006432:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80006436:	ffffb097          	auipc	ra,0xffffb
    8000643a:	b0e080e7          	jalr	-1266(ra) # 80000f44 <mycpu>
    8000643e:	e888                	sd	a0,16(s1)
}
    80006440:	60e2                	ld	ra,24(sp)
    80006442:	6442                	ld	s0,16(sp)
    80006444:	64a2                	ld	s1,8(sp)
    80006446:	6105                	addi	sp,sp,32
    80006448:	8082                	ret
    panic("acquire");
    8000644a:	00002517          	auipc	a0,0x2
    8000644e:	2c650513          	addi	a0,a0,710 # 80008710 <etext+0x710>
    80006452:	00000097          	auipc	ra,0x0
    80006456:	a3a080e7          	jalr	-1478(ra) # 80005e8c <panic>

000000008000645a <pop_off>:

void
pop_off(void)
{
    8000645a:	1141                	addi	sp,sp,-16
    8000645c:	e406                	sd	ra,8(sp)
    8000645e:	e022                	sd	s0,0(sp)
    80006460:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006462:	ffffb097          	auipc	ra,0xffffb
    80006466:	ae2080e7          	jalr	-1310(ra) # 80000f44 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000646a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000646e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006470:	e78d                	bnez	a5,8000649a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006472:	5d3c                	lw	a5,120(a0)
    80006474:	02f05b63          	blez	a5,800064aa <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006478:	37fd                	addiw	a5,a5,-1
    8000647a:	0007871b          	sext.w	a4,a5
    8000647e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006480:	eb09                	bnez	a4,80006492 <pop_off+0x38>
    80006482:	5d7c                	lw	a5,124(a0)
    80006484:	c799                	beqz	a5,80006492 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006486:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000648a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000648e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006492:	60a2                	ld	ra,8(sp)
    80006494:	6402                	ld	s0,0(sp)
    80006496:	0141                	addi	sp,sp,16
    80006498:	8082                	ret
    panic("pop_off - interruptible");
    8000649a:	00002517          	auipc	a0,0x2
    8000649e:	27e50513          	addi	a0,a0,638 # 80008718 <etext+0x718>
    800064a2:	00000097          	auipc	ra,0x0
    800064a6:	9ea080e7          	jalr	-1558(ra) # 80005e8c <panic>
    panic("pop_off");
    800064aa:	00002517          	auipc	a0,0x2
    800064ae:	28650513          	addi	a0,a0,646 # 80008730 <etext+0x730>
    800064b2:	00000097          	auipc	ra,0x0
    800064b6:	9da080e7          	jalr	-1574(ra) # 80005e8c <panic>

00000000800064ba <release>:
{
    800064ba:	1101                	addi	sp,sp,-32
    800064bc:	ec06                	sd	ra,24(sp)
    800064be:	e822                	sd	s0,16(sp)
    800064c0:	e426                	sd	s1,8(sp)
    800064c2:	1000                	addi	s0,sp,32
    800064c4:	84aa                	mv	s1,a0
  if(!holding(lk))
    800064c6:	00000097          	auipc	ra,0x0
    800064ca:	ec6080e7          	jalr	-314(ra) # 8000638c <holding>
    800064ce:	c115                	beqz	a0,800064f2 <release+0x38>
  lk->cpu = 0;
    800064d0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800064d4:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800064d8:	0310000f          	fence	rw,w
    800064dc:	0004a023          	sw	zero,0(s1)
  pop_off();
    800064e0:	00000097          	auipc	ra,0x0
    800064e4:	f7a080e7          	jalr	-134(ra) # 8000645a <pop_off>
}
    800064e8:	60e2                	ld	ra,24(sp)
    800064ea:	6442                	ld	s0,16(sp)
    800064ec:	64a2                	ld	s1,8(sp)
    800064ee:	6105                	addi	sp,sp,32
    800064f0:	8082                	ret
    panic("release");
    800064f2:	00002517          	auipc	a0,0x2
    800064f6:	24650513          	addi	a0,a0,582 # 80008738 <etext+0x738>
    800064fa:	00000097          	auipc	ra,0x0
    800064fe:	992080e7          	jalr	-1646(ra) # 80005e8c <panic>
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
