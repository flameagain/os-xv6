
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	26013103          	ld	sp,608(sp) # 8000b260 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0b9050ef          	jal	800058ce <start>

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
    8000004c:	17c080e7          	jalr	380(ra) # 800001c4 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	0000c917          	auipc	s2,0xc
    80000054:	fe090913          	addi	s2,s2,-32 # 8000c030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	2bc080e7          	jalr	700(ra) # 80006316 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	35c080e7          	jalr	860(ra) # 800063ca <release>
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
    8000008e:	d12080e7          	jalr	-750(ra) # 80005d9c <panic>

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
    800000fa:	190080e7          	jalr	400(ra) # 80006286 <initlock>
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
    80000132:	1e8080e7          	jalr	488(ra) # 80006316 <acquire>
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
    8000014a:	284080e7          	jalr	644(ra) # 800063ca <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	070080e7          	jalr	112(ra) # 800001c4 <memset>
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
    80000174:	25a080e7          	jalr	602(ra) # 800063ca <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <acquire_freemem>:

uint64 acquire_freemem(){
    8000017a:	1101                	addi	sp,sp,-32
    8000017c:	ec06                	sd	ra,24(sp)
    8000017e:	e822                	sd	s0,16(sp)
    80000180:	e426                	sd	s1,8(sp)
    80000182:	1000                	addi	s0,sp,32
   struct run *r;
   uint64 cnt = 0;
   
  acquire(&kmem.lock);
    80000184:	0000c497          	auipc	s1,0xc
    80000188:	eac48493          	addi	s1,s1,-340 # 8000c030 <kmem>
    8000018c:	8526                	mv	a0,s1
    8000018e:	00006097          	auipc	ra,0x6
    80000192:	188080e7          	jalr	392(ra) # 80006316 <acquire>
  r = kmem.freelist;
    80000196:	6c9c                	ld	a5,24(s1)
  while(r){
    80000198:	c785                	beqz	a5,800001c0 <acquire_freemem+0x46>
   uint64 cnt = 0;
    8000019a:	4481                	li	s1,0
    r=r->next;
    8000019c:	639c                	ld	a5,0(a5)
    cnt++;
    8000019e:	0485                	addi	s1,s1,1
  while(r){
    800001a0:	fff5                	bnez	a5,8000019c <acquire_freemem+0x22>
  }
  release(&kmem.lock);
    800001a2:	0000c517          	auipc	a0,0xc
    800001a6:	e8e50513          	addi	a0,a0,-370 # 8000c030 <kmem>
    800001aa:	00006097          	auipc	ra,0x6
    800001ae:	220080e7          	jalr	544(ra) # 800063ca <release>
  return cnt*PGSIZE;
}
    800001b2:	00c49513          	slli	a0,s1,0xc
    800001b6:	60e2                	ld	ra,24(sp)
    800001b8:	6442                	ld	s0,16(sp)
    800001ba:	64a2                	ld	s1,8(sp)
    800001bc:	6105                	addi	sp,sp,32
    800001be:	8082                	ret
   uint64 cnt = 0;
    800001c0:	4481                	li	s1,0
    800001c2:	b7c5                	j	800001a2 <acquire_freemem+0x28>

00000000800001c4 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c4:	1141                	addi	sp,sp,-16
    800001c6:	e422                	sd	s0,8(sp)
    800001c8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001ca:	ca19                	beqz	a2,800001e0 <memset+0x1c>
    800001cc:	87aa                	mv	a5,a0
    800001ce:	1602                	slli	a2,a2,0x20
    800001d0:	9201                	srli	a2,a2,0x20
    800001d2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001d6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001da:	0785                	addi	a5,a5,1
    800001dc:	fee79de3          	bne	a5,a4,800001d6 <memset+0x12>
  }
  return dst;
}
    800001e0:	6422                	ld	s0,8(sp)
    800001e2:	0141                	addi	sp,sp,16
    800001e4:	8082                	ret

00000000800001e6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001e6:	1141                	addi	sp,sp,-16
    800001e8:	e422                	sd	s0,8(sp)
    800001ea:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ec:	ca05                	beqz	a2,8000021c <memcmp+0x36>
    800001ee:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001f2:	1682                	slli	a3,a3,0x20
    800001f4:	9281                	srli	a3,a3,0x20
    800001f6:	0685                	addi	a3,a3,1
    800001f8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001fa:	00054783          	lbu	a5,0(a0)
    800001fe:	0005c703          	lbu	a4,0(a1)
    80000202:	00e79863          	bne	a5,a4,80000212 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000206:	0505                	addi	a0,a0,1
    80000208:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000020a:	fed518e3          	bne	a0,a3,800001fa <memcmp+0x14>
  }

  return 0;
    8000020e:	4501                	li	a0,0
    80000210:	a019                	j	80000216 <memcmp+0x30>
      return *s1 - *s2;
    80000212:	40e7853b          	subw	a0,a5,a4
}
    80000216:	6422                	ld	s0,8(sp)
    80000218:	0141                	addi	sp,sp,16
    8000021a:	8082                	ret
  return 0;
    8000021c:	4501                	li	a0,0
    8000021e:	bfe5                	j	80000216 <memcmp+0x30>

0000000080000220 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000220:	1141                	addi	sp,sp,-16
    80000222:	e422                	sd	s0,8(sp)
    80000224:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000226:	c205                	beqz	a2,80000246 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000228:	02a5e263          	bltu	a1,a0,8000024c <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000022c:	1602                	slli	a2,a2,0x20
    8000022e:	9201                	srli	a2,a2,0x20
    80000230:	00c587b3          	add	a5,a1,a2
{
    80000234:	872a                	mv	a4,a0
      *d++ = *s++;
    80000236:	0585                	addi	a1,a1,1
    80000238:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd5dc1>
    8000023a:	fff5c683          	lbu	a3,-1(a1)
    8000023e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000242:	feb79ae3          	bne	a5,a1,80000236 <memmove+0x16>

  return dst;
}
    80000246:	6422                	ld	s0,8(sp)
    80000248:	0141                	addi	sp,sp,16
    8000024a:	8082                	ret
  if(s < d && s + n > d){
    8000024c:	02061693          	slli	a3,a2,0x20
    80000250:	9281                	srli	a3,a3,0x20
    80000252:	00d58733          	add	a4,a1,a3
    80000256:	fce57be3          	bgeu	a0,a4,8000022c <memmove+0xc>
    d += n;
    8000025a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000025c:	fff6079b          	addiw	a5,a2,-1
    80000260:	1782                	slli	a5,a5,0x20
    80000262:	9381                	srli	a5,a5,0x20
    80000264:	fff7c793          	not	a5,a5
    80000268:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000026a:	177d                	addi	a4,a4,-1
    8000026c:	16fd                	addi	a3,a3,-1
    8000026e:	00074603          	lbu	a2,0(a4)
    80000272:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000276:	fef71ae3          	bne	a4,a5,8000026a <memmove+0x4a>
    8000027a:	b7f1                	j	80000246 <memmove+0x26>

000000008000027c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000284:	00000097          	auipc	ra,0x0
    80000288:	f9c080e7          	jalr	-100(ra) # 80000220 <memmove>
}
    8000028c:	60a2                	ld	ra,8(sp)
    8000028e:	6402                	ld	s0,0(sp)
    80000290:	0141                	addi	sp,sp,16
    80000292:	8082                	ret

0000000080000294 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000294:	1141                	addi	sp,sp,-16
    80000296:	e422                	sd	s0,8(sp)
    80000298:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000029a:	ce11                	beqz	a2,800002b6 <strncmp+0x22>
    8000029c:	00054783          	lbu	a5,0(a0)
    800002a0:	cf89                	beqz	a5,800002ba <strncmp+0x26>
    800002a2:	0005c703          	lbu	a4,0(a1)
    800002a6:	00f71a63          	bne	a4,a5,800002ba <strncmp+0x26>
    n--, p++, q++;
    800002aa:	367d                	addiw	a2,a2,-1
    800002ac:	0505                	addi	a0,a0,1
    800002ae:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002b0:	f675                	bnez	a2,8000029c <strncmp+0x8>
  if(n == 0)
    return 0;
    800002b2:	4501                	li	a0,0
    800002b4:	a801                	j	800002c4 <strncmp+0x30>
    800002b6:	4501                	li	a0,0
    800002b8:	a031                	j	800002c4 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    800002ba:	00054503          	lbu	a0,0(a0)
    800002be:	0005c783          	lbu	a5,0(a1)
    800002c2:	9d1d                	subw	a0,a0,a5
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002d0:	87aa                	mv	a5,a0
    800002d2:	86b2                	mv	a3,a2
    800002d4:	367d                	addiw	a2,a2,-1
    800002d6:	02d05563          	blez	a3,80000300 <strncpy+0x36>
    800002da:	0785                	addi	a5,a5,1
    800002dc:	0005c703          	lbu	a4,0(a1)
    800002e0:	fee78fa3          	sb	a4,-1(a5)
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	f775                	bnez	a4,800002d2 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002e8:	873e                	mv	a4,a5
    800002ea:	9fb5                	addw	a5,a5,a3
    800002ec:	37fd                	addiw	a5,a5,-1
    800002ee:	00c05963          	blez	a2,80000300 <strncpy+0x36>
    *s++ = 0;
    800002f2:	0705                	addi	a4,a4,1
    800002f4:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002f8:	40e786bb          	subw	a3,a5,a4
    800002fc:	fed04be3          	bgtz	a3,800002f2 <strncpy+0x28>
  return os;
}
    80000300:	6422                	ld	s0,8(sp)
    80000302:	0141                	addi	sp,sp,16
    80000304:	8082                	ret

0000000080000306 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000306:	1141                	addi	sp,sp,-16
    80000308:	e422                	sd	s0,8(sp)
    8000030a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000030c:	02c05363          	blez	a2,80000332 <safestrcpy+0x2c>
    80000310:	fff6069b          	addiw	a3,a2,-1
    80000314:	1682                	slli	a3,a3,0x20
    80000316:	9281                	srli	a3,a3,0x20
    80000318:	96ae                	add	a3,a3,a1
    8000031a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000031c:	00d58963          	beq	a1,a3,8000032e <safestrcpy+0x28>
    80000320:	0585                	addi	a1,a1,1
    80000322:	0785                	addi	a5,a5,1
    80000324:	fff5c703          	lbu	a4,-1(a1)
    80000328:	fee78fa3          	sb	a4,-1(a5)
    8000032c:	fb65                	bnez	a4,8000031c <safestrcpy+0x16>
    ;
  *s = 0;
    8000032e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000332:	6422                	ld	s0,8(sp)
    80000334:	0141                	addi	sp,sp,16
    80000336:	8082                	ret

0000000080000338 <strlen>:

int
strlen(const char *s)
{
    80000338:	1141                	addi	sp,sp,-16
    8000033a:	e422                	sd	s0,8(sp)
    8000033c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000033e:	00054783          	lbu	a5,0(a0)
    80000342:	cf91                	beqz	a5,8000035e <strlen+0x26>
    80000344:	0505                	addi	a0,a0,1
    80000346:	87aa                	mv	a5,a0
    80000348:	86be                	mv	a3,a5
    8000034a:	0785                	addi	a5,a5,1
    8000034c:	fff7c703          	lbu	a4,-1(a5)
    80000350:	ff65                	bnez	a4,80000348 <strlen+0x10>
    80000352:	40a6853b          	subw	a0,a3,a0
    80000356:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000358:	6422                	ld	s0,8(sp)
    8000035a:	0141                	addi	sp,sp,16
    8000035c:	8082                	ret
  for(n = 0; s[n]; n++)
    8000035e:	4501                	li	a0,0
    80000360:	bfe5                	j	80000358 <strlen+0x20>

0000000080000362 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000362:	1141                	addi	sp,sp,-16
    80000364:	e406                	sd	ra,8(sp)
    80000366:	e022                	sd	s0,0(sp)
    80000368:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000036a:	00001097          	auipc	ra,0x1
    8000036e:	b30080e7          	jalr	-1232(ra) # 80000e9a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000372:	0000c717          	auipc	a4,0xc
    80000376:	c8e70713          	addi	a4,a4,-882 # 8000c000 <started>
  if(cpuid() == 0){
    8000037a:	c139                	beqz	a0,800003c0 <main+0x5e>
    while(started == 0)
    8000037c:	431c                	lw	a5,0(a4)
    8000037e:	2781                	sext.w	a5,a5
    80000380:	dff5                	beqz	a5,8000037c <main+0x1a>
      ;
    __sync_synchronize();
    80000382:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000386:	00001097          	auipc	ra,0x1
    8000038a:	b14080e7          	jalr	-1260(ra) # 80000e9a <cpuid>
    8000038e:	85aa                	mv	a1,a0
    80000390:	00008517          	auipc	a0,0x8
    80000394:	ca850513          	addi	a0,a0,-856 # 80008038 <etext+0x38>
    80000398:	00006097          	auipc	ra,0x6
    8000039c:	a4e080e7          	jalr	-1458(ra) # 80005de6 <printf>
    kvminithart();    // turn on paging
    800003a0:	00000097          	auipc	ra,0x0
    800003a4:	0d8080e7          	jalr	216(ra) # 80000478 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003a8:	00001097          	auipc	ra,0x1
    800003ac:	7d8080e7          	jalr	2008(ra) # 80001b80 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003b0:	00005097          	auipc	ra,0x5
    800003b4:	ed4080e7          	jalr	-300(ra) # 80005284 <plicinithart>
  }

  scheduler();        
    800003b8:	00001097          	auipc	ra,0x1
    800003bc:	02e080e7          	jalr	46(ra) # 800013e6 <scheduler>
    consoleinit();
    800003c0:	00006097          	auipc	ra,0x6
    800003c4:	8ec080e7          	jalr	-1812(ra) # 80005cac <consoleinit>
    printfinit();
    800003c8:	00006097          	auipc	ra,0x6
    800003cc:	c26080e7          	jalr	-986(ra) # 80005fee <printfinit>
    printf("\n");
    800003d0:	00008517          	auipc	a0,0x8
    800003d4:	c4850513          	addi	a0,a0,-952 # 80008018 <etext+0x18>
    800003d8:	00006097          	auipc	ra,0x6
    800003dc:	a0e080e7          	jalr	-1522(ra) # 80005de6 <printf>
    printf("xv6 kernel is booting\n");
    800003e0:	00008517          	auipc	a0,0x8
    800003e4:	c4050513          	addi	a0,a0,-960 # 80008020 <etext+0x20>
    800003e8:	00006097          	auipc	ra,0x6
    800003ec:	9fe080e7          	jalr	-1538(ra) # 80005de6 <printf>
    printf("\n");
    800003f0:	00008517          	auipc	a0,0x8
    800003f4:	c2850513          	addi	a0,a0,-984 # 80008018 <etext+0x18>
    800003f8:	00006097          	auipc	ra,0x6
    800003fc:	9ee080e7          	jalr	-1554(ra) # 80005de6 <printf>
    kinit();         // physical page allocator
    80000400:	00000097          	auipc	ra,0x0
    80000404:	cde080e7          	jalr	-802(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    80000408:	00000097          	auipc	ra,0x0
    8000040c:	322080e7          	jalr	802(ra) # 8000072a <kvminit>
    kvminithart();   // turn on paging
    80000410:	00000097          	auipc	ra,0x0
    80000414:	068080e7          	jalr	104(ra) # 80000478 <kvminithart>
    procinit();      // process table
    80000418:	00001097          	auipc	ra,0x1
    8000041c:	9c4080e7          	jalr	-1596(ra) # 80000ddc <procinit>
    trapinit();      // trap vectors
    80000420:	00001097          	auipc	ra,0x1
    80000424:	738080e7          	jalr	1848(ra) # 80001b58 <trapinit>
    trapinithart();  // install kernel trap vector
    80000428:	00001097          	auipc	ra,0x1
    8000042c:	758080e7          	jalr	1880(ra) # 80001b80 <trapinithart>
    plicinit();      // set up interrupt controller
    80000430:	00005097          	auipc	ra,0x5
    80000434:	e3a080e7          	jalr	-454(ra) # 8000526a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000438:	00005097          	auipc	ra,0x5
    8000043c:	e4c080e7          	jalr	-436(ra) # 80005284 <plicinithart>
    binit();         // buffer cache
    80000440:	00002097          	auipc	ra,0x2
    80000444:	f66080e7          	jalr	-154(ra) # 800023a6 <binit>
    iinit();         // inode table
    80000448:	00002097          	auipc	ra,0x2
    8000044c:	5f2080e7          	jalr	1522(ra) # 80002a3a <iinit>
    fileinit();      // file table
    80000450:	00003097          	auipc	ra,0x3
    80000454:	596080e7          	jalr	1430(ra) # 800039e6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000458:	00005097          	auipc	ra,0x5
    8000045c:	f4c080e7          	jalr	-180(ra) # 800053a4 <virtio_disk_init>
    userinit();      // first user process
    80000460:	00001097          	auipc	ra,0x1
    80000464:	d42080e7          	jalr	-702(ra) # 800011a2 <userinit>
    __sync_synchronize();
    80000468:	0330000f          	fence	rw,rw
    started = 1;
    8000046c:	4785                	li	a5,1
    8000046e:	0000c717          	auipc	a4,0xc
    80000472:	b8f72923          	sw	a5,-1134(a4) # 8000c000 <started>
    80000476:	b789                	j	800003b8 <main+0x56>

0000000080000478 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000478:	1141                	addi	sp,sp,-16
    8000047a:	e422                	sd	s0,8(sp)
    8000047c:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000047e:	0000c797          	auipc	a5,0xc
    80000482:	b8a7b783          	ld	a5,-1142(a5) # 8000c008 <kernel_pagetable>
    80000486:	83b1                	srli	a5,a5,0xc
    80000488:	577d                	li	a4,-1
    8000048a:	177e                	slli	a4,a4,0x3f
    8000048c:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000048e:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000492:	12000073          	sfence.vma
  sfence_vma();
}
    80000496:	6422                	ld	s0,8(sp)
    80000498:	0141                	addi	sp,sp,16
    8000049a:	8082                	ret

000000008000049c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000049c:	7139                	addi	sp,sp,-64
    8000049e:	fc06                	sd	ra,56(sp)
    800004a0:	f822                	sd	s0,48(sp)
    800004a2:	f426                	sd	s1,40(sp)
    800004a4:	f04a                	sd	s2,32(sp)
    800004a6:	ec4e                	sd	s3,24(sp)
    800004a8:	e852                	sd	s4,16(sp)
    800004aa:	e456                	sd	s5,8(sp)
    800004ac:	e05a                	sd	s6,0(sp)
    800004ae:	0080                	addi	s0,sp,64
    800004b0:	84aa                	mv	s1,a0
    800004b2:	89ae                	mv	s3,a1
    800004b4:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004b6:	57fd                	li	a5,-1
    800004b8:	83e9                	srli	a5,a5,0x1a
    800004ba:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004bc:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004be:	04b7f263          	bgeu	a5,a1,80000502 <walk+0x66>
    panic("walk");
    800004c2:	00008517          	auipc	a0,0x8
    800004c6:	b8e50513          	addi	a0,a0,-1138 # 80008050 <etext+0x50>
    800004ca:	00006097          	auipc	ra,0x6
    800004ce:	8d2080e7          	jalr	-1838(ra) # 80005d9c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004d2:	060a8663          	beqz	s5,8000053e <walk+0xa2>
    800004d6:	00000097          	auipc	ra,0x0
    800004da:	c44080e7          	jalr	-956(ra) # 8000011a <kalloc>
    800004de:	84aa                	mv	s1,a0
    800004e0:	c529                	beqz	a0,8000052a <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004e2:	6605                	lui	a2,0x1
    800004e4:	4581                	li	a1,0
    800004e6:	00000097          	auipc	ra,0x0
    800004ea:	cde080e7          	jalr	-802(ra) # 800001c4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004ee:	00c4d793          	srli	a5,s1,0xc
    800004f2:	07aa                	slli	a5,a5,0xa
    800004f4:	0017e793          	ori	a5,a5,1
    800004f8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004fc:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd5db7>
    800004fe:	036a0063          	beq	s4,s6,8000051e <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000502:	0149d933          	srl	s2,s3,s4
    80000506:	1ff97913          	andi	s2,s2,511
    8000050a:	090e                	slli	s2,s2,0x3
    8000050c:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000050e:	00093483          	ld	s1,0(s2)
    80000512:	0014f793          	andi	a5,s1,1
    80000516:	dfd5                	beqz	a5,800004d2 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000518:	80a9                	srli	s1,s1,0xa
    8000051a:	04b2                	slli	s1,s1,0xc
    8000051c:	b7c5                	j	800004fc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000051e:	00c9d513          	srli	a0,s3,0xc
    80000522:	1ff57513          	andi	a0,a0,511
    80000526:	050e                	slli	a0,a0,0x3
    80000528:	9526                	add	a0,a0,s1
}
    8000052a:	70e2                	ld	ra,56(sp)
    8000052c:	7442                	ld	s0,48(sp)
    8000052e:	74a2                	ld	s1,40(sp)
    80000530:	7902                	ld	s2,32(sp)
    80000532:	69e2                	ld	s3,24(sp)
    80000534:	6a42                	ld	s4,16(sp)
    80000536:	6aa2                	ld	s5,8(sp)
    80000538:	6b02                	ld	s6,0(sp)
    8000053a:	6121                	addi	sp,sp,64
    8000053c:	8082                	ret
        return 0;
    8000053e:	4501                	li	a0,0
    80000540:	b7ed                	j	8000052a <walk+0x8e>

0000000080000542 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000542:	57fd                	li	a5,-1
    80000544:	83e9                	srli	a5,a5,0x1a
    80000546:	00b7f463          	bgeu	a5,a1,8000054e <walkaddr+0xc>
    return 0;
    8000054a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000054c:	8082                	ret
{
    8000054e:	1141                	addi	sp,sp,-16
    80000550:	e406                	sd	ra,8(sp)
    80000552:	e022                	sd	s0,0(sp)
    80000554:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000556:	4601                	li	a2,0
    80000558:	00000097          	auipc	ra,0x0
    8000055c:	f44080e7          	jalr	-188(ra) # 8000049c <walk>
  if(pte == 0)
    80000560:	c105                	beqz	a0,80000580 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000562:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000564:	0117f693          	andi	a3,a5,17
    80000568:	4745                	li	a4,17
    return 0;
    8000056a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000056c:	00e68663          	beq	a3,a4,80000578 <walkaddr+0x36>
}
    80000570:	60a2                	ld	ra,8(sp)
    80000572:	6402                	ld	s0,0(sp)
    80000574:	0141                	addi	sp,sp,16
    80000576:	8082                	ret
  pa = PTE2PA(*pte);
    80000578:	83a9                	srli	a5,a5,0xa
    8000057a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000057e:	bfcd                	j	80000570 <walkaddr+0x2e>
    return 0;
    80000580:	4501                	li	a0,0
    80000582:	b7fd                	j	80000570 <walkaddr+0x2e>

0000000080000584 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000584:	715d                	addi	sp,sp,-80
    80000586:	e486                	sd	ra,72(sp)
    80000588:	e0a2                	sd	s0,64(sp)
    8000058a:	fc26                	sd	s1,56(sp)
    8000058c:	f84a                	sd	s2,48(sp)
    8000058e:	f44e                	sd	s3,40(sp)
    80000590:	f052                	sd	s4,32(sp)
    80000592:	ec56                	sd	s5,24(sp)
    80000594:	e85a                	sd	s6,16(sp)
    80000596:	e45e                	sd	s7,8(sp)
    80000598:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000059a:	c639                	beqz	a2,800005e8 <mappages+0x64>
    8000059c:	8aaa                	mv	s5,a0
    8000059e:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005a0:	777d                	lui	a4,0xfffff
    800005a2:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800005a6:	fff58993          	addi	s3,a1,-1
    800005aa:	99b2                	add	s3,s3,a2
    800005ac:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800005b0:	893e                	mv	s2,a5
    800005b2:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005b6:	6b85                	lui	s7,0x1
    800005b8:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800005bc:	4605                	li	a2,1
    800005be:	85ca                	mv	a1,s2
    800005c0:	8556                	mv	a0,s5
    800005c2:	00000097          	auipc	ra,0x0
    800005c6:	eda080e7          	jalr	-294(ra) # 8000049c <walk>
    800005ca:	cd1d                	beqz	a0,80000608 <mappages+0x84>
    if(*pte & PTE_V)
    800005cc:	611c                	ld	a5,0(a0)
    800005ce:	8b85                	andi	a5,a5,1
    800005d0:	e785                	bnez	a5,800005f8 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005d2:	80b1                	srli	s1,s1,0xc
    800005d4:	04aa                	slli	s1,s1,0xa
    800005d6:	0164e4b3          	or	s1,s1,s6
    800005da:	0014e493          	ori	s1,s1,1
    800005de:	e104                	sd	s1,0(a0)
    if(a == last)
    800005e0:	05390063          	beq	s2,s3,80000620 <mappages+0x9c>
    a += PGSIZE;
    800005e4:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005e6:	bfc9                	j	800005b8 <mappages+0x34>
    panic("mappages: size");
    800005e8:	00008517          	auipc	a0,0x8
    800005ec:	a7050513          	addi	a0,a0,-1424 # 80008058 <etext+0x58>
    800005f0:	00005097          	auipc	ra,0x5
    800005f4:	7ac080e7          	jalr	1964(ra) # 80005d9c <panic>
      panic("mappages: remap");
    800005f8:	00008517          	auipc	a0,0x8
    800005fc:	a7050513          	addi	a0,a0,-1424 # 80008068 <etext+0x68>
    80000600:	00005097          	auipc	ra,0x5
    80000604:	79c080e7          	jalr	1948(ra) # 80005d9c <panic>
      return -1;
    80000608:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000060a:	60a6                	ld	ra,72(sp)
    8000060c:	6406                	ld	s0,64(sp)
    8000060e:	74e2                	ld	s1,56(sp)
    80000610:	7942                	ld	s2,48(sp)
    80000612:	79a2                	ld	s3,40(sp)
    80000614:	7a02                	ld	s4,32(sp)
    80000616:	6ae2                	ld	s5,24(sp)
    80000618:	6b42                	ld	s6,16(sp)
    8000061a:	6ba2                	ld	s7,8(sp)
    8000061c:	6161                	addi	sp,sp,80
    8000061e:	8082                	ret
  return 0;
    80000620:	4501                	li	a0,0
    80000622:	b7e5                	j	8000060a <mappages+0x86>

0000000080000624 <kvmmap>:
{
    80000624:	1141                	addi	sp,sp,-16
    80000626:	e406                	sd	ra,8(sp)
    80000628:	e022                	sd	s0,0(sp)
    8000062a:	0800                	addi	s0,sp,16
    8000062c:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000062e:	86b2                	mv	a3,a2
    80000630:	863e                	mv	a2,a5
    80000632:	00000097          	auipc	ra,0x0
    80000636:	f52080e7          	jalr	-174(ra) # 80000584 <mappages>
    8000063a:	e509                	bnez	a0,80000644 <kvmmap+0x20>
}
    8000063c:	60a2                	ld	ra,8(sp)
    8000063e:	6402                	ld	s0,0(sp)
    80000640:	0141                	addi	sp,sp,16
    80000642:	8082                	ret
    panic("kvmmap");
    80000644:	00008517          	auipc	a0,0x8
    80000648:	a3450513          	addi	a0,a0,-1484 # 80008078 <etext+0x78>
    8000064c:	00005097          	auipc	ra,0x5
    80000650:	750080e7          	jalr	1872(ra) # 80005d9c <panic>

0000000080000654 <kvmmake>:
{
    80000654:	1101                	addi	sp,sp,-32
    80000656:	ec06                	sd	ra,24(sp)
    80000658:	e822                	sd	s0,16(sp)
    8000065a:	e426                	sd	s1,8(sp)
    8000065c:	e04a                	sd	s2,0(sp)
    8000065e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000660:	00000097          	auipc	ra,0x0
    80000664:	aba080e7          	jalr	-1350(ra) # 8000011a <kalloc>
    80000668:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000066a:	6605                	lui	a2,0x1
    8000066c:	4581                	li	a1,0
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	b56080e7          	jalr	-1194(ra) # 800001c4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000676:	4719                	li	a4,6
    80000678:	6685                	lui	a3,0x1
    8000067a:	10000637          	lui	a2,0x10000
    8000067e:	100005b7          	lui	a1,0x10000
    80000682:	8526                	mv	a0,s1
    80000684:	00000097          	auipc	ra,0x0
    80000688:	fa0080e7          	jalr	-96(ra) # 80000624 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000068c:	4719                	li	a4,6
    8000068e:	6685                	lui	a3,0x1
    80000690:	10001637          	lui	a2,0x10001
    80000694:	100015b7          	lui	a1,0x10001
    80000698:	8526                	mv	a0,s1
    8000069a:	00000097          	auipc	ra,0x0
    8000069e:	f8a080e7          	jalr	-118(ra) # 80000624 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006a2:	4719                	li	a4,6
    800006a4:	004006b7          	lui	a3,0x400
    800006a8:	0c000637          	lui	a2,0xc000
    800006ac:	0c0005b7          	lui	a1,0xc000
    800006b0:	8526                	mv	a0,s1
    800006b2:	00000097          	auipc	ra,0x0
    800006b6:	f72080e7          	jalr	-142(ra) # 80000624 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006ba:	00008917          	auipc	s2,0x8
    800006be:	94690913          	addi	s2,s2,-1722 # 80008000 <etext>
    800006c2:	4729                	li	a4,10
    800006c4:	80008697          	auipc	a3,0x80008
    800006c8:	93c68693          	addi	a3,a3,-1732 # 8000 <_entry-0x7fff8000>
    800006cc:	4605                	li	a2,1
    800006ce:	067e                	slli	a2,a2,0x1f
    800006d0:	85b2                	mv	a1,a2
    800006d2:	8526                	mv	a0,s1
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	f50080e7          	jalr	-176(ra) # 80000624 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006dc:	46c5                	li	a3,17
    800006de:	06ee                	slli	a3,a3,0x1b
    800006e0:	4719                	li	a4,6
    800006e2:	412686b3          	sub	a3,a3,s2
    800006e6:	864a                	mv	a2,s2
    800006e8:	85ca                	mv	a1,s2
    800006ea:	8526                	mv	a0,s1
    800006ec:	00000097          	auipc	ra,0x0
    800006f0:	f38080e7          	jalr	-200(ra) # 80000624 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006f4:	4729                	li	a4,10
    800006f6:	6685                	lui	a3,0x1
    800006f8:	00007617          	auipc	a2,0x7
    800006fc:	90860613          	addi	a2,a2,-1784 # 80007000 <_trampoline>
    80000700:	040005b7          	lui	a1,0x4000
    80000704:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000706:	05b2                	slli	a1,a1,0xc
    80000708:	8526                	mv	a0,s1
    8000070a:	00000097          	auipc	ra,0x0
    8000070e:	f1a080e7          	jalr	-230(ra) # 80000624 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000712:	8526                	mv	a0,s1
    80000714:	00000097          	auipc	ra,0x0
    80000718:	624080e7          	jalr	1572(ra) # 80000d38 <proc_mapstacks>
}
    8000071c:	8526                	mv	a0,s1
    8000071e:	60e2                	ld	ra,24(sp)
    80000720:	6442                	ld	s0,16(sp)
    80000722:	64a2                	ld	s1,8(sp)
    80000724:	6902                	ld	s2,0(sp)
    80000726:	6105                	addi	sp,sp,32
    80000728:	8082                	ret

000000008000072a <kvminit>:
{
    8000072a:	1141                	addi	sp,sp,-16
    8000072c:	e406                	sd	ra,8(sp)
    8000072e:	e022                	sd	s0,0(sp)
    80000730:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000732:	00000097          	auipc	ra,0x0
    80000736:	f22080e7          	jalr	-222(ra) # 80000654 <kvmmake>
    8000073a:	0000c797          	auipc	a5,0xc
    8000073e:	8ca7b723          	sd	a0,-1842(a5) # 8000c008 <kernel_pagetable>
}
    80000742:	60a2                	ld	ra,8(sp)
    80000744:	6402                	ld	s0,0(sp)
    80000746:	0141                	addi	sp,sp,16
    80000748:	8082                	ret

000000008000074a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000074a:	715d                	addi	sp,sp,-80
    8000074c:	e486                	sd	ra,72(sp)
    8000074e:	e0a2                	sd	s0,64(sp)
    80000750:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000752:	03459793          	slli	a5,a1,0x34
    80000756:	e39d                	bnez	a5,8000077c <uvmunmap+0x32>
    80000758:	f84a                	sd	s2,48(sp)
    8000075a:	f44e                	sd	s3,40(sp)
    8000075c:	f052                	sd	s4,32(sp)
    8000075e:	ec56                	sd	s5,24(sp)
    80000760:	e85a                	sd	s6,16(sp)
    80000762:	e45e                	sd	s7,8(sp)
    80000764:	8a2a                	mv	s4,a0
    80000766:	892e                	mv	s2,a1
    80000768:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000076a:	0632                	slli	a2,a2,0xc
    8000076c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000770:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000772:	6b05                	lui	s6,0x1
    80000774:	0935fb63          	bgeu	a1,s3,8000080a <uvmunmap+0xc0>
    80000778:	fc26                	sd	s1,56(sp)
    8000077a:	a8a9                	j	800007d4 <uvmunmap+0x8a>
    8000077c:	fc26                	sd	s1,56(sp)
    8000077e:	f84a                	sd	s2,48(sp)
    80000780:	f44e                	sd	s3,40(sp)
    80000782:	f052                	sd	s4,32(sp)
    80000784:	ec56                	sd	s5,24(sp)
    80000786:	e85a                	sd	s6,16(sp)
    80000788:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000078a:	00008517          	auipc	a0,0x8
    8000078e:	8f650513          	addi	a0,a0,-1802 # 80008080 <etext+0x80>
    80000792:	00005097          	auipc	ra,0x5
    80000796:	60a080e7          	jalr	1546(ra) # 80005d9c <panic>
      panic("uvmunmap: walk");
    8000079a:	00008517          	auipc	a0,0x8
    8000079e:	8fe50513          	addi	a0,a0,-1794 # 80008098 <etext+0x98>
    800007a2:	00005097          	auipc	ra,0x5
    800007a6:	5fa080e7          	jalr	1530(ra) # 80005d9c <panic>
      panic("uvmunmap: not mapped");
    800007aa:	00008517          	auipc	a0,0x8
    800007ae:	8fe50513          	addi	a0,a0,-1794 # 800080a8 <etext+0xa8>
    800007b2:	00005097          	auipc	ra,0x5
    800007b6:	5ea080e7          	jalr	1514(ra) # 80005d9c <panic>
      panic("uvmunmap: not a leaf");
    800007ba:	00008517          	auipc	a0,0x8
    800007be:	90650513          	addi	a0,a0,-1786 # 800080c0 <etext+0xc0>
    800007c2:	00005097          	auipc	ra,0x5
    800007c6:	5da080e7          	jalr	1498(ra) # 80005d9c <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800007ca:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ce:	995a                	add	s2,s2,s6
    800007d0:	03397c63          	bgeu	s2,s3,80000808 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007d4:	4601                	li	a2,0
    800007d6:	85ca                	mv	a1,s2
    800007d8:	8552                	mv	a0,s4
    800007da:	00000097          	auipc	ra,0x0
    800007de:	cc2080e7          	jalr	-830(ra) # 8000049c <walk>
    800007e2:	84aa                	mv	s1,a0
    800007e4:	d95d                	beqz	a0,8000079a <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    800007e6:	6108                	ld	a0,0(a0)
    800007e8:	00157793          	andi	a5,a0,1
    800007ec:	dfdd                	beqz	a5,800007aa <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007ee:	3ff57793          	andi	a5,a0,1023
    800007f2:	fd7784e3          	beq	a5,s7,800007ba <uvmunmap+0x70>
    if(do_free){
    800007f6:	fc0a8ae3          	beqz	s5,800007ca <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800007fa:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007fc:	0532                	slli	a0,a0,0xc
    800007fe:	00000097          	auipc	ra,0x0
    80000802:	81e080e7          	jalr	-2018(ra) # 8000001c <kfree>
    80000806:	b7d1                	j	800007ca <uvmunmap+0x80>
    80000808:	74e2                	ld	s1,56(sp)
    8000080a:	7942                	ld	s2,48(sp)
    8000080c:	79a2                	ld	s3,40(sp)
    8000080e:	7a02                	ld	s4,32(sp)
    80000810:	6ae2                	ld	s5,24(sp)
    80000812:	6b42                	ld	s6,16(sp)
    80000814:	6ba2                	ld	s7,8(sp)
  }
}
    80000816:	60a6                	ld	ra,72(sp)
    80000818:	6406                	ld	s0,64(sp)
    8000081a:	6161                	addi	sp,sp,80
    8000081c:	8082                	ret

000000008000081e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000081e:	1101                	addi	sp,sp,-32
    80000820:	ec06                	sd	ra,24(sp)
    80000822:	e822                	sd	s0,16(sp)
    80000824:	e426                	sd	s1,8(sp)
    80000826:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	8f2080e7          	jalr	-1806(ra) # 8000011a <kalloc>
    80000830:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000832:	c519                	beqz	a0,80000840 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000834:	6605                	lui	a2,0x1
    80000836:	4581                	li	a1,0
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	98c080e7          	jalr	-1652(ra) # 800001c4 <memset>
  return pagetable;
}
    80000840:	8526                	mv	a0,s1
    80000842:	60e2                	ld	ra,24(sp)
    80000844:	6442                	ld	s0,16(sp)
    80000846:	64a2                	ld	s1,8(sp)
    80000848:	6105                	addi	sp,sp,32
    8000084a:	8082                	ret

000000008000084c <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000084c:	7179                	addi	sp,sp,-48
    8000084e:	f406                	sd	ra,40(sp)
    80000850:	f022                	sd	s0,32(sp)
    80000852:	ec26                	sd	s1,24(sp)
    80000854:	e84a                	sd	s2,16(sp)
    80000856:	e44e                	sd	s3,8(sp)
    80000858:	e052                	sd	s4,0(sp)
    8000085a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000085c:	6785                	lui	a5,0x1
    8000085e:	04f67863          	bgeu	a2,a5,800008ae <uvminit+0x62>
    80000862:	8a2a                	mv	s4,a0
    80000864:	89ae                	mv	s3,a1
    80000866:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000868:	00000097          	auipc	ra,0x0
    8000086c:	8b2080e7          	jalr	-1870(ra) # 8000011a <kalloc>
    80000870:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000872:	6605                	lui	a2,0x1
    80000874:	4581                	li	a1,0
    80000876:	00000097          	auipc	ra,0x0
    8000087a:	94e080e7          	jalr	-1714(ra) # 800001c4 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000087e:	4779                	li	a4,30
    80000880:	86ca                	mv	a3,s2
    80000882:	6605                	lui	a2,0x1
    80000884:	4581                	li	a1,0
    80000886:	8552                	mv	a0,s4
    80000888:	00000097          	auipc	ra,0x0
    8000088c:	cfc080e7          	jalr	-772(ra) # 80000584 <mappages>
  memmove(mem, src, sz);
    80000890:	8626                	mv	a2,s1
    80000892:	85ce                	mv	a1,s3
    80000894:	854a                	mv	a0,s2
    80000896:	00000097          	auipc	ra,0x0
    8000089a:	98a080e7          	jalr	-1654(ra) # 80000220 <memmove>
}
    8000089e:	70a2                	ld	ra,40(sp)
    800008a0:	7402                	ld	s0,32(sp)
    800008a2:	64e2                	ld	s1,24(sp)
    800008a4:	6942                	ld	s2,16(sp)
    800008a6:	69a2                	ld	s3,8(sp)
    800008a8:	6a02                	ld	s4,0(sp)
    800008aa:	6145                	addi	sp,sp,48
    800008ac:	8082                	ret
    panic("inituvm: more than a page");
    800008ae:	00008517          	auipc	a0,0x8
    800008b2:	82a50513          	addi	a0,a0,-2006 # 800080d8 <etext+0xd8>
    800008b6:	00005097          	auipc	ra,0x5
    800008ba:	4e6080e7          	jalr	1254(ra) # 80005d9c <panic>

00000000800008be <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008be:	1101                	addi	sp,sp,-32
    800008c0:	ec06                	sd	ra,24(sp)
    800008c2:	e822                	sd	s0,16(sp)
    800008c4:	e426                	sd	s1,8(sp)
    800008c6:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008c8:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008ca:	00b67d63          	bgeu	a2,a1,800008e4 <uvmdealloc+0x26>
    800008ce:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008d0:	6785                	lui	a5,0x1
    800008d2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d4:	00f60733          	add	a4,a2,a5
    800008d8:	76fd                	lui	a3,0xfffff
    800008da:	8f75                	and	a4,a4,a3
    800008dc:	97ae                	add	a5,a5,a1
    800008de:	8ff5                	and	a5,a5,a3
    800008e0:	00f76863          	bltu	a4,a5,800008f0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008e4:	8526                	mv	a0,s1
    800008e6:	60e2                	ld	ra,24(sp)
    800008e8:	6442                	ld	s0,16(sp)
    800008ea:	64a2                	ld	s1,8(sp)
    800008ec:	6105                	addi	sp,sp,32
    800008ee:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008f0:	8f99                	sub	a5,a5,a4
    800008f2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008f4:	4685                	li	a3,1
    800008f6:	0007861b          	sext.w	a2,a5
    800008fa:	85ba                	mv	a1,a4
    800008fc:	00000097          	auipc	ra,0x0
    80000900:	e4e080e7          	jalr	-434(ra) # 8000074a <uvmunmap>
    80000904:	b7c5                	j	800008e4 <uvmdealloc+0x26>

0000000080000906 <uvmalloc>:
  if(newsz < oldsz)
    80000906:	0ab66563          	bltu	a2,a1,800009b0 <uvmalloc+0xaa>
{
    8000090a:	7139                	addi	sp,sp,-64
    8000090c:	fc06                	sd	ra,56(sp)
    8000090e:	f822                	sd	s0,48(sp)
    80000910:	ec4e                	sd	s3,24(sp)
    80000912:	e852                	sd	s4,16(sp)
    80000914:	e456                	sd	s5,8(sp)
    80000916:	0080                	addi	s0,sp,64
    80000918:	8aaa                	mv	s5,a0
    8000091a:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000091c:	6785                	lui	a5,0x1
    8000091e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000920:	95be                	add	a1,a1,a5
    80000922:	77fd                	lui	a5,0xfffff
    80000924:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000928:	08c9f663          	bgeu	s3,a2,800009b4 <uvmalloc+0xae>
    8000092c:	f426                	sd	s1,40(sp)
    8000092e:	f04a                	sd	s2,32(sp)
    80000930:	894e                	mv	s2,s3
    mem = kalloc();
    80000932:	fffff097          	auipc	ra,0xfffff
    80000936:	7e8080e7          	jalr	2024(ra) # 8000011a <kalloc>
    8000093a:	84aa                	mv	s1,a0
    if(mem == 0){
    8000093c:	c90d                	beqz	a0,8000096e <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    8000093e:	6605                	lui	a2,0x1
    80000940:	4581                	li	a1,0
    80000942:	00000097          	auipc	ra,0x0
    80000946:	882080e7          	jalr	-1918(ra) # 800001c4 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    8000094a:	4779                	li	a4,30
    8000094c:	86a6                	mv	a3,s1
    8000094e:	6605                	lui	a2,0x1
    80000950:	85ca                	mv	a1,s2
    80000952:	8556                	mv	a0,s5
    80000954:	00000097          	auipc	ra,0x0
    80000958:	c30080e7          	jalr	-976(ra) # 80000584 <mappages>
    8000095c:	e915                	bnez	a0,80000990 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000095e:	6785                	lui	a5,0x1
    80000960:	993e                	add	s2,s2,a5
    80000962:	fd4968e3          	bltu	s2,s4,80000932 <uvmalloc+0x2c>
  return newsz;
    80000966:	8552                	mv	a0,s4
    80000968:	74a2                	ld	s1,40(sp)
    8000096a:	7902                	ld	s2,32(sp)
    8000096c:	a819                	j	80000982 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    8000096e:	864e                	mv	a2,s3
    80000970:	85ca                	mv	a1,s2
    80000972:	8556                	mv	a0,s5
    80000974:	00000097          	auipc	ra,0x0
    80000978:	f4a080e7          	jalr	-182(ra) # 800008be <uvmdealloc>
      return 0;
    8000097c:	4501                	li	a0,0
    8000097e:	74a2                	ld	s1,40(sp)
    80000980:	7902                	ld	s2,32(sp)
}
    80000982:	70e2                	ld	ra,56(sp)
    80000984:	7442                	ld	s0,48(sp)
    80000986:	69e2                	ld	s3,24(sp)
    80000988:	6a42                	ld	s4,16(sp)
    8000098a:	6aa2                	ld	s5,8(sp)
    8000098c:	6121                	addi	sp,sp,64
    8000098e:	8082                	ret
      kfree(mem);
    80000990:	8526                	mv	a0,s1
    80000992:	fffff097          	auipc	ra,0xfffff
    80000996:	68a080e7          	jalr	1674(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000099a:	864e                	mv	a2,s3
    8000099c:	85ca                	mv	a1,s2
    8000099e:	8556                	mv	a0,s5
    800009a0:	00000097          	auipc	ra,0x0
    800009a4:	f1e080e7          	jalr	-226(ra) # 800008be <uvmdealloc>
      return 0;
    800009a8:	4501                	li	a0,0
    800009aa:	74a2                	ld	s1,40(sp)
    800009ac:	7902                	ld	s2,32(sp)
    800009ae:	bfd1                	j	80000982 <uvmalloc+0x7c>
    return oldsz;
    800009b0:	852e                	mv	a0,a1
}
    800009b2:	8082                	ret
  return newsz;
    800009b4:	8532                	mv	a0,a2
    800009b6:	b7f1                	j	80000982 <uvmalloc+0x7c>

00000000800009b8 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009b8:	7179                	addi	sp,sp,-48
    800009ba:	f406                	sd	ra,40(sp)
    800009bc:	f022                	sd	s0,32(sp)
    800009be:	ec26                	sd	s1,24(sp)
    800009c0:	e84a                	sd	s2,16(sp)
    800009c2:	e44e                	sd	s3,8(sp)
    800009c4:	e052                	sd	s4,0(sp)
    800009c6:	1800                	addi	s0,sp,48
    800009c8:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009ca:	84aa                	mv	s1,a0
    800009cc:	6905                	lui	s2,0x1
    800009ce:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009d0:	4985                	li	s3,1
    800009d2:	a829                	j	800009ec <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009d4:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009d6:	00c79513          	slli	a0,a5,0xc
    800009da:	00000097          	auipc	ra,0x0
    800009de:	fde080e7          	jalr	-34(ra) # 800009b8 <freewalk>
      pagetable[i] = 0;
    800009e2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009e6:	04a1                	addi	s1,s1,8
    800009e8:	03248163          	beq	s1,s2,80000a0a <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009ec:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ee:	00f7f713          	andi	a4,a5,15
    800009f2:	ff3701e3          	beq	a4,s3,800009d4 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009f6:	8b85                	andi	a5,a5,1
    800009f8:	d7fd                	beqz	a5,800009e6 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009fa:	00007517          	auipc	a0,0x7
    800009fe:	6fe50513          	addi	a0,a0,1790 # 800080f8 <etext+0xf8>
    80000a02:	00005097          	auipc	ra,0x5
    80000a06:	39a080e7          	jalr	922(ra) # 80005d9c <panic>
    }
  }
  kfree((void*)pagetable);
    80000a0a:	8552                	mv	a0,s4
    80000a0c:	fffff097          	auipc	ra,0xfffff
    80000a10:	610080e7          	jalr	1552(ra) # 8000001c <kfree>
}
    80000a14:	70a2                	ld	ra,40(sp)
    80000a16:	7402                	ld	s0,32(sp)
    80000a18:	64e2                	ld	s1,24(sp)
    80000a1a:	6942                	ld	s2,16(sp)
    80000a1c:	69a2                	ld	s3,8(sp)
    80000a1e:	6a02                	ld	s4,0(sp)
    80000a20:	6145                	addi	sp,sp,48
    80000a22:	8082                	ret

0000000080000a24 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a24:	1101                	addi	sp,sp,-32
    80000a26:	ec06                	sd	ra,24(sp)
    80000a28:	e822                	sd	s0,16(sp)
    80000a2a:	e426                	sd	s1,8(sp)
    80000a2c:	1000                	addi	s0,sp,32
    80000a2e:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a30:	e999                	bnez	a1,80000a46 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a32:	8526                	mv	a0,s1
    80000a34:	00000097          	auipc	ra,0x0
    80000a38:	f84080e7          	jalr	-124(ra) # 800009b8 <freewalk>
}
    80000a3c:	60e2                	ld	ra,24(sp)
    80000a3e:	6442                	ld	s0,16(sp)
    80000a40:	64a2                	ld	s1,8(sp)
    80000a42:	6105                	addi	sp,sp,32
    80000a44:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a46:	6785                	lui	a5,0x1
    80000a48:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a4a:	95be                	add	a1,a1,a5
    80000a4c:	4685                	li	a3,1
    80000a4e:	00c5d613          	srli	a2,a1,0xc
    80000a52:	4581                	li	a1,0
    80000a54:	00000097          	auipc	ra,0x0
    80000a58:	cf6080e7          	jalr	-778(ra) # 8000074a <uvmunmap>
    80000a5c:	bfd9                	j	80000a32 <uvmfree+0xe>

0000000080000a5e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a5e:	c679                	beqz	a2,80000b2c <uvmcopy+0xce>
{
    80000a60:	715d                	addi	sp,sp,-80
    80000a62:	e486                	sd	ra,72(sp)
    80000a64:	e0a2                	sd	s0,64(sp)
    80000a66:	fc26                	sd	s1,56(sp)
    80000a68:	f84a                	sd	s2,48(sp)
    80000a6a:	f44e                	sd	s3,40(sp)
    80000a6c:	f052                	sd	s4,32(sp)
    80000a6e:	ec56                	sd	s5,24(sp)
    80000a70:	e85a                	sd	s6,16(sp)
    80000a72:	e45e                	sd	s7,8(sp)
    80000a74:	0880                	addi	s0,sp,80
    80000a76:	8b2a                	mv	s6,a0
    80000a78:	8aae                	mv	s5,a1
    80000a7a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a7c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a7e:	4601                	li	a2,0
    80000a80:	85ce                	mv	a1,s3
    80000a82:	855a                	mv	a0,s6
    80000a84:	00000097          	auipc	ra,0x0
    80000a88:	a18080e7          	jalr	-1512(ra) # 8000049c <walk>
    80000a8c:	c531                	beqz	a0,80000ad8 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a8e:	6118                	ld	a4,0(a0)
    80000a90:	00177793          	andi	a5,a4,1
    80000a94:	cbb1                	beqz	a5,80000ae8 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a96:	00a75593          	srli	a1,a4,0xa
    80000a9a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a9e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	678080e7          	jalr	1656(ra) # 8000011a <kalloc>
    80000aaa:	892a                	mv	s2,a0
    80000aac:	c939                	beqz	a0,80000b02 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aae:	6605                	lui	a2,0x1
    80000ab0:	85de                	mv	a1,s7
    80000ab2:	fffff097          	auipc	ra,0xfffff
    80000ab6:	76e080e7          	jalr	1902(ra) # 80000220 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aba:	8726                	mv	a4,s1
    80000abc:	86ca                	mv	a3,s2
    80000abe:	6605                	lui	a2,0x1
    80000ac0:	85ce                	mv	a1,s3
    80000ac2:	8556                	mv	a0,s5
    80000ac4:	00000097          	auipc	ra,0x0
    80000ac8:	ac0080e7          	jalr	-1344(ra) # 80000584 <mappages>
    80000acc:	e515                	bnez	a0,80000af8 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ace:	6785                	lui	a5,0x1
    80000ad0:	99be                	add	s3,s3,a5
    80000ad2:	fb49e6e3          	bltu	s3,s4,80000a7e <uvmcopy+0x20>
    80000ad6:	a081                	j	80000b16 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ad8:	00007517          	auipc	a0,0x7
    80000adc:	63050513          	addi	a0,a0,1584 # 80008108 <etext+0x108>
    80000ae0:	00005097          	auipc	ra,0x5
    80000ae4:	2bc080e7          	jalr	700(ra) # 80005d9c <panic>
      panic("uvmcopy: page not present");
    80000ae8:	00007517          	auipc	a0,0x7
    80000aec:	64050513          	addi	a0,a0,1600 # 80008128 <etext+0x128>
    80000af0:	00005097          	auipc	ra,0x5
    80000af4:	2ac080e7          	jalr	684(ra) # 80005d9c <panic>
      kfree(mem);
    80000af8:	854a                	mv	a0,s2
    80000afa:	fffff097          	auipc	ra,0xfffff
    80000afe:	522080e7          	jalr	1314(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b02:	4685                	li	a3,1
    80000b04:	00c9d613          	srli	a2,s3,0xc
    80000b08:	4581                	li	a1,0
    80000b0a:	8556                	mv	a0,s5
    80000b0c:	00000097          	auipc	ra,0x0
    80000b10:	c3e080e7          	jalr	-962(ra) # 8000074a <uvmunmap>
  return -1;
    80000b14:	557d                	li	a0,-1
}
    80000b16:	60a6                	ld	ra,72(sp)
    80000b18:	6406                	ld	s0,64(sp)
    80000b1a:	74e2                	ld	s1,56(sp)
    80000b1c:	7942                	ld	s2,48(sp)
    80000b1e:	79a2                	ld	s3,40(sp)
    80000b20:	7a02                	ld	s4,32(sp)
    80000b22:	6ae2                	ld	s5,24(sp)
    80000b24:	6b42                	ld	s6,16(sp)
    80000b26:	6ba2                	ld	s7,8(sp)
    80000b28:	6161                	addi	sp,sp,80
    80000b2a:	8082                	ret
  return 0;
    80000b2c:	4501                	li	a0,0
}
    80000b2e:	8082                	ret

0000000080000b30 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b30:	1141                	addi	sp,sp,-16
    80000b32:	e406                	sd	ra,8(sp)
    80000b34:	e022                	sd	s0,0(sp)
    80000b36:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b38:	4601                	li	a2,0
    80000b3a:	00000097          	auipc	ra,0x0
    80000b3e:	962080e7          	jalr	-1694(ra) # 8000049c <walk>
  if(pte == 0)
    80000b42:	c901                	beqz	a0,80000b52 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b44:	611c                	ld	a5,0(a0)
    80000b46:	9bbd                	andi	a5,a5,-17
    80000b48:	e11c                	sd	a5,0(a0)
}
    80000b4a:	60a2                	ld	ra,8(sp)
    80000b4c:	6402                	ld	s0,0(sp)
    80000b4e:	0141                	addi	sp,sp,16
    80000b50:	8082                	ret
    panic("uvmclear");
    80000b52:	00007517          	auipc	a0,0x7
    80000b56:	5f650513          	addi	a0,a0,1526 # 80008148 <etext+0x148>
    80000b5a:	00005097          	auipc	ra,0x5
    80000b5e:	242080e7          	jalr	578(ra) # 80005d9c <panic>

0000000080000b62 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b62:	c6bd                	beqz	a3,80000bd0 <copyout+0x6e>
{
    80000b64:	715d                	addi	sp,sp,-80
    80000b66:	e486                	sd	ra,72(sp)
    80000b68:	e0a2                	sd	s0,64(sp)
    80000b6a:	fc26                	sd	s1,56(sp)
    80000b6c:	f84a                	sd	s2,48(sp)
    80000b6e:	f44e                	sd	s3,40(sp)
    80000b70:	f052                	sd	s4,32(sp)
    80000b72:	ec56                	sd	s5,24(sp)
    80000b74:	e85a                	sd	s6,16(sp)
    80000b76:	e45e                	sd	s7,8(sp)
    80000b78:	e062                	sd	s8,0(sp)
    80000b7a:	0880                	addi	s0,sp,80
    80000b7c:	8b2a                	mv	s6,a0
    80000b7e:	8c2e                	mv	s8,a1
    80000b80:	8a32                	mv	s4,a2
    80000b82:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b84:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b86:	6a85                	lui	s5,0x1
    80000b88:	a015                	j	80000bac <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b8a:	9562                	add	a0,a0,s8
    80000b8c:	0004861b          	sext.w	a2,s1
    80000b90:	85d2                	mv	a1,s4
    80000b92:	41250533          	sub	a0,a0,s2
    80000b96:	fffff097          	auipc	ra,0xfffff
    80000b9a:	68a080e7          	jalr	1674(ra) # 80000220 <memmove>

    len -= n;
    80000b9e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000ba2:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000ba4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ba8:	02098263          	beqz	s3,80000bcc <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000bac:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bb0:	85ca                	mv	a1,s2
    80000bb2:	855a                	mv	a0,s6
    80000bb4:	00000097          	auipc	ra,0x0
    80000bb8:	98e080e7          	jalr	-1650(ra) # 80000542 <walkaddr>
    if(pa0 == 0)
    80000bbc:	cd01                	beqz	a0,80000bd4 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bbe:	418904b3          	sub	s1,s2,s8
    80000bc2:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bc4:	fc99f3e3          	bgeu	s3,s1,80000b8a <copyout+0x28>
    80000bc8:	84ce                	mv	s1,s3
    80000bca:	b7c1                	j	80000b8a <copyout+0x28>
  }
  return 0;
    80000bcc:	4501                	li	a0,0
    80000bce:	a021                	j	80000bd6 <copyout+0x74>
    80000bd0:	4501                	li	a0,0
}
    80000bd2:	8082                	ret
      return -1;
    80000bd4:	557d                	li	a0,-1
}
    80000bd6:	60a6                	ld	ra,72(sp)
    80000bd8:	6406                	ld	s0,64(sp)
    80000bda:	74e2                	ld	s1,56(sp)
    80000bdc:	7942                	ld	s2,48(sp)
    80000bde:	79a2                	ld	s3,40(sp)
    80000be0:	7a02                	ld	s4,32(sp)
    80000be2:	6ae2                	ld	s5,24(sp)
    80000be4:	6b42                	ld	s6,16(sp)
    80000be6:	6ba2                	ld	s7,8(sp)
    80000be8:	6c02                	ld	s8,0(sp)
    80000bea:	6161                	addi	sp,sp,80
    80000bec:	8082                	ret

0000000080000bee <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bee:	caa5                	beqz	a3,80000c5e <copyin+0x70>
{
    80000bf0:	715d                	addi	sp,sp,-80
    80000bf2:	e486                	sd	ra,72(sp)
    80000bf4:	e0a2                	sd	s0,64(sp)
    80000bf6:	fc26                	sd	s1,56(sp)
    80000bf8:	f84a                	sd	s2,48(sp)
    80000bfa:	f44e                	sd	s3,40(sp)
    80000bfc:	f052                	sd	s4,32(sp)
    80000bfe:	ec56                	sd	s5,24(sp)
    80000c00:	e85a                	sd	s6,16(sp)
    80000c02:	e45e                	sd	s7,8(sp)
    80000c04:	e062                	sd	s8,0(sp)
    80000c06:	0880                	addi	s0,sp,80
    80000c08:	8b2a                	mv	s6,a0
    80000c0a:	8a2e                	mv	s4,a1
    80000c0c:	8c32                	mv	s8,a2
    80000c0e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c10:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c12:	6a85                	lui	s5,0x1
    80000c14:	a01d                	j	80000c3a <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c16:	018505b3          	add	a1,a0,s8
    80000c1a:	0004861b          	sext.w	a2,s1
    80000c1e:	412585b3          	sub	a1,a1,s2
    80000c22:	8552                	mv	a0,s4
    80000c24:	fffff097          	auipc	ra,0xfffff
    80000c28:	5fc080e7          	jalr	1532(ra) # 80000220 <memmove>

    len -= n;
    80000c2c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c30:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c32:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c36:	02098263          	beqz	s3,80000c5a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c3a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c3e:	85ca                	mv	a1,s2
    80000c40:	855a                	mv	a0,s6
    80000c42:	00000097          	auipc	ra,0x0
    80000c46:	900080e7          	jalr	-1792(ra) # 80000542 <walkaddr>
    if(pa0 == 0)
    80000c4a:	cd01                	beqz	a0,80000c62 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c4c:	418904b3          	sub	s1,s2,s8
    80000c50:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c52:	fc99f2e3          	bgeu	s3,s1,80000c16 <copyin+0x28>
    80000c56:	84ce                	mv	s1,s3
    80000c58:	bf7d                	j	80000c16 <copyin+0x28>
  }
  return 0;
    80000c5a:	4501                	li	a0,0
    80000c5c:	a021                	j	80000c64 <copyin+0x76>
    80000c5e:	4501                	li	a0,0
}
    80000c60:	8082                	ret
      return -1;
    80000c62:	557d                	li	a0,-1
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
    80000c76:	6c02                	ld	s8,0(sp)
    80000c78:	6161                	addi	sp,sp,80
    80000c7a:	8082                	ret

0000000080000c7c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c7c:	cacd                	beqz	a3,80000d2e <copyinstr+0xb2>
{
    80000c7e:	715d                	addi	sp,sp,-80
    80000c80:	e486                	sd	ra,72(sp)
    80000c82:	e0a2                	sd	s0,64(sp)
    80000c84:	fc26                	sd	s1,56(sp)
    80000c86:	f84a                	sd	s2,48(sp)
    80000c88:	f44e                	sd	s3,40(sp)
    80000c8a:	f052                	sd	s4,32(sp)
    80000c8c:	ec56                	sd	s5,24(sp)
    80000c8e:	e85a                	sd	s6,16(sp)
    80000c90:	e45e                	sd	s7,8(sp)
    80000c92:	0880                	addi	s0,sp,80
    80000c94:	8a2a                	mv	s4,a0
    80000c96:	8b2e                	mv	s6,a1
    80000c98:	8bb2                	mv	s7,a2
    80000c9a:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000c9c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c9e:	6985                	lui	s3,0x1
    80000ca0:	a825                	j	80000cd8 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000ca2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ca6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000ca8:	37fd                	addiw	a5,a5,-1
    80000caa:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cae:	60a6                	ld	ra,72(sp)
    80000cb0:	6406                	ld	s0,64(sp)
    80000cb2:	74e2                	ld	s1,56(sp)
    80000cb4:	7942                	ld	s2,48(sp)
    80000cb6:	79a2                	ld	s3,40(sp)
    80000cb8:	7a02                	ld	s4,32(sp)
    80000cba:	6ae2                	ld	s5,24(sp)
    80000cbc:	6b42                	ld	s6,16(sp)
    80000cbe:	6ba2                	ld	s7,8(sp)
    80000cc0:	6161                	addi	sp,sp,80
    80000cc2:	8082                	ret
    80000cc4:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000cc8:	9742                	add	a4,a4,a6
      --max;
    80000cca:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000cce:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000cd2:	04e58663          	beq	a1,a4,80000d1e <copyinstr+0xa2>
{
    80000cd6:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000cd8:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cdc:	85a6                	mv	a1,s1
    80000cde:	8552                	mv	a0,s4
    80000ce0:	00000097          	auipc	ra,0x0
    80000ce4:	862080e7          	jalr	-1950(ra) # 80000542 <walkaddr>
    if(pa0 == 0)
    80000ce8:	cd0d                	beqz	a0,80000d22 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000cea:	417486b3          	sub	a3,s1,s7
    80000cee:	96ce                	add	a3,a3,s3
    if(n > max)
    80000cf0:	00d97363          	bgeu	s2,a3,80000cf6 <copyinstr+0x7a>
    80000cf4:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000cf6:	955e                	add	a0,a0,s7
    80000cf8:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000cfa:	c695                	beqz	a3,80000d26 <copyinstr+0xaa>
    80000cfc:	87da                	mv	a5,s6
    80000cfe:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000d00:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000d04:	96da                	add	a3,a3,s6
    80000d06:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000d08:	00f60733          	add	a4,a2,a5
    80000d0c:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd5dc0>
    80000d10:	db49                	beqz	a4,80000ca2 <copyinstr+0x26>
        *dst = *p;
    80000d12:	00e78023          	sb	a4,0(a5)
      dst++;
    80000d16:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d18:	fed797e3          	bne	a5,a3,80000d06 <copyinstr+0x8a>
    80000d1c:	b765                	j	80000cc4 <copyinstr+0x48>
    80000d1e:	4781                	li	a5,0
    80000d20:	b761                	j	80000ca8 <copyinstr+0x2c>
      return -1;
    80000d22:	557d                	li	a0,-1
    80000d24:	b769                	j	80000cae <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000d26:	6b85                	lui	s7,0x1
    80000d28:	9ba6                	add	s7,s7,s1
    80000d2a:	87da                	mv	a5,s6
    80000d2c:	b76d                	j	80000cd6 <copyinstr+0x5a>
  int got_null = 0;
    80000d2e:	4781                	li	a5,0
  if(got_null){
    80000d30:	37fd                	addiw	a5,a5,-1
    80000d32:	0007851b          	sext.w	a0,a5
}
    80000d36:	8082                	ret

0000000080000d38 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000d38:	7139                	addi	sp,sp,-64
    80000d3a:	fc06                	sd	ra,56(sp)
    80000d3c:	f822                	sd	s0,48(sp)
    80000d3e:	f426                	sd	s1,40(sp)
    80000d40:	f04a                	sd	s2,32(sp)
    80000d42:	ec4e                	sd	s3,24(sp)
    80000d44:	e852                	sd	s4,16(sp)
    80000d46:	e456                	sd	s5,8(sp)
    80000d48:	e05a                	sd	s6,0(sp)
    80000d4a:	0080                	addi	s0,sp,64
    80000d4c:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d4e:	0000b497          	auipc	s1,0xb
    80000d52:	73248493          	addi	s1,s1,1842 # 8000c480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d56:	8b26                	mv	s6,s1
    80000d58:	ff4df937          	lui	s2,0xff4df
    80000d5c:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b577d>
    80000d60:	0936                	slli	s2,s2,0xd
    80000d62:	6f590913          	addi	s2,s2,1781
    80000d66:	0936                	slli	s2,s2,0xd
    80000d68:	bd390913          	addi	s2,s2,-1069
    80000d6c:	0932                	slli	s2,s2,0xc
    80000d6e:	7a790913          	addi	s2,s2,1959
    80000d72:	040009b7          	lui	s3,0x4000
    80000d76:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d78:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d7a:	00011a97          	auipc	s5,0x11
    80000d7e:	306a8a93          	addi	s5,s5,774 # 80012080 <tickslock>
    char *pa = kalloc();
    80000d82:	fffff097          	auipc	ra,0xfffff
    80000d86:	398080e7          	jalr	920(ra) # 8000011a <kalloc>
    80000d8a:	862a                	mv	a2,a0
    if(pa == 0)
    80000d8c:	c121                	beqz	a0,80000dcc <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000d8e:	416485b3          	sub	a1,s1,s6
    80000d92:	8591                	srai	a1,a1,0x4
    80000d94:	032585b3          	mul	a1,a1,s2
    80000d98:	2585                	addiw	a1,a1,1
    80000d9a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d9e:	4719                	li	a4,6
    80000da0:	6685                	lui	a3,0x1
    80000da2:	40b985b3          	sub	a1,s3,a1
    80000da6:	8552                	mv	a0,s4
    80000da8:	00000097          	auipc	ra,0x0
    80000dac:	87c080e7          	jalr	-1924(ra) # 80000624 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db0:	17048493          	addi	s1,s1,368
    80000db4:	fd5497e3          	bne	s1,s5,80000d82 <proc_mapstacks+0x4a>
  }
}
    80000db8:	70e2                	ld	ra,56(sp)
    80000dba:	7442                	ld	s0,48(sp)
    80000dbc:	74a2                	ld	s1,40(sp)
    80000dbe:	7902                	ld	s2,32(sp)
    80000dc0:	69e2                	ld	s3,24(sp)
    80000dc2:	6a42                	ld	s4,16(sp)
    80000dc4:	6aa2                	ld	s5,8(sp)
    80000dc6:	6b02                	ld	s6,0(sp)
    80000dc8:	6121                	addi	sp,sp,64
    80000dca:	8082                	ret
      panic("kalloc");
    80000dcc:	00007517          	auipc	a0,0x7
    80000dd0:	38c50513          	addi	a0,a0,908 # 80008158 <etext+0x158>
    80000dd4:	00005097          	auipc	ra,0x5
    80000dd8:	fc8080e7          	jalr	-56(ra) # 80005d9c <panic>

0000000080000ddc <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000ddc:	7139                	addi	sp,sp,-64
    80000dde:	fc06                	sd	ra,56(sp)
    80000de0:	f822                	sd	s0,48(sp)
    80000de2:	f426                	sd	s1,40(sp)
    80000de4:	f04a                	sd	s2,32(sp)
    80000de6:	ec4e                	sd	s3,24(sp)
    80000de8:	e852                	sd	s4,16(sp)
    80000dea:	e456                	sd	s5,8(sp)
    80000dec:	e05a                	sd	s6,0(sp)
    80000dee:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000df0:	00007597          	auipc	a1,0x7
    80000df4:	37058593          	addi	a1,a1,880 # 80008160 <etext+0x160>
    80000df8:	0000b517          	auipc	a0,0xb
    80000dfc:	25850513          	addi	a0,a0,600 # 8000c050 <pid_lock>
    80000e00:	00005097          	auipc	ra,0x5
    80000e04:	486080e7          	jalr	1158(ra) # 80006286 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e08:	00007597          	auipc	a1,0x7
    80000e0c:	36058593          	addi	a1,a1,864 # 80008168 <etext+0x168>
    80000e10:	0000b517          	auipc	a0,0xb
    80000e14:	25850513          	addi	a0,a0,600 # 8000c068 <wait_lock>
    80000e18:	00005097          	auipc	ra,0x5
    80000e1c:	46e080e7          	jalr	1134(ra) # 80006286 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e20:	0000b497          	auipc	s1,0xb
    80000e24:	66048493          	addi	s1,s1,1632 # 8000c480 <proc>
      initlock(&p->lock, "proc");
    80000e28:	00007b17          	auipc	s6,0x7
    80000e2c:	350b0b13          	addi	s6,s6,848 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000e30:	8aa6                	mv	s5,s1
    80000e32:	ff4df937          	lui	s2,0xff4df
    80000e36:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b577d>
    80000e3a:	0936                	slli	s2,s2,0xd
    80000e3c:	6f590913          	addi	s2,s2,1781
    80000e40:	0936                	slli	s2,s2,0xd
    80000e42:	bd390913          	addi	s2,s2,-1069
    80000e46:	0932                	slli	s2,s2,0xc
    80000e48:	7a790913          	addi	s2,s2,1959
    80000e4c:	040009b7          	lui	s3,0x4000
    80000e50:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e52:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e54:	00011a17          	auipc	s4,0x11
    80000e58:	22ca0a13          	addi	s4,s4,556 # 80012080 <tickslock>
      initlock(&p->lock, "proc");
    80000e5c:	85da                	mv	a1,s6
    80000e5e:	8526                	mv	a0,s1
    80000e60:	00005097          	auipc	ra,0x5
    80000e64:	426080e7          	jalr	1062(ra) # 80006286 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e68:	415487b3          	sub	a5,s1,s5
    80000e6c:	8791                	srai	a5,a5,0x4
    80000e6e:	032787b3          	mul	a5,a5,s2
    80000e72:	2785                	addiw	a5,a5,1
    80000e74:	00d7979b          	slliw	a5,a5,0xd
    80000e78:	40f987b3          	sub	a5,s3,a5
    80000e7c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e7e:	17048493          	addi	s1,s1,368
    80000e82:	fd449de3          	bne	s1,s4,80000e5c <procinit+0x80>
  }
}
    80000e86:	70e2                	ld	ra,56(sp)
    80000e88:	7442                	ld	s0,48(sp)
    80000e8a:	74a2                	ld	s1,40(sp)
    80000e8c:	7902                	ld	s2,32(sp)
    80000e8e:	69e2                	ld	s3,24(sp)
    80000e90:	6a42                	ld	s4,16(sp)
    80000e92:	6aa2                	ld	s5,8(sp)
    80000e94:	6b02                	ld	s6,0(sp)
    80000e96:	6121                	addi	sp,sp,64
    80000e98:	8082                	ret

0000000080000e9a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e9a:	1141                	addi	sp,sp,-16
    80000e9c:	e422                	sd	s0,8(sp)
    80000e9e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000ea0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000ea2:	2501                	sext.w	a0,a0
    80000ea4:	6422                	ld	s0,8(sp)
    80000ea6:	0141                	addi	sp,sp,16
    80000ea8:	8082                	ret

0000000080000eaa <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000eaa:	1141                	addi	sp,sp,-16
    80000eac:	e422                	sd	s0,8(sp)
    80000eae:	0800                	addi	s0,sp,16
    80000eb0:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000eb2:	2781                	sext.w	a5,a5
    80000eb4:	079e                	slli	a5,a5,0x7
  return c;
}
    80000eb6:	0000b517          	auipc	a0,0xb
    80000eba:	1ca50513          	addi	a0,a0,458 # 8000c080 <cpus>
    80000ebe:	953e                	add	a0,a0,a5
    80000ec0:	6422                	ld	s0,8(sp)
    80000ec2:	0141                	addi	sp,sp,16
    80000ec4:	8082                	ret

0000000080000ec6 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000ec6:	1101                	addi	sp,sp,-32
    80000ec8:	ec06                	sd	ra,24(sp)
    80000eca:	e822                	sd	s0,16(sp)
    80000ecc:	e426                	sd	s1,8(sp)
    80000ece:	1000                	addi	s0,sp,32
  push_off();
    80000ed0:	00005097          	auipc	ra,0x5
    80000ed4:	3fa080e7          	jalr	1018(ra) # 800062ca <push_off>
    80000ed8:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000eda:	2781                	sext.w	a5,a5
    80000edc:	079e                	slli	a5,a5,0x7
    80000ede:	0000b717          	auipc	a4,0xb
    80000ee2:	17270713          	addi	a4,a4,370 # 8000c050 <pid_lock>
    80000ee6:	97ba                	add	a5,a5,a4
    80000ee8:	7b84                	ld	s1,48(a5)
  pop_off();
    80000eea:	00005097          	auipc	ra,0x5
    80000eee:	480080e7          	jalr	1152(ra) # 8000636a <pop_off>
  return p;
}
    80000ef2:	8526                	mv	a0,s1
    80000ef4:	60e2                	ld	ra,24(sp)
    80000ef6:	6442                	ld	s0,16(sp)
    80000ef8:	64a2                	ld	s1,8(sp)
    80000efa:	6105                	addi	sp,sp,32
    80000efc:	8082                	ret

0000000080000efe <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000efe:	1141                	addi	sp,sp,-16
    80000f00:	e406                	sd	ra,8(sp)
    80000f02:	e022                	sd	s0,0(sp)
    80000f04:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f06:	00000097          	auipc	ra,0x0
    80000f0a:	fc0080e7          	jalr	-64(ra) # 80000ec6 <myproc>
    80000f0e:	00005097          	auipc	ra,0x5
    80000f12:	4bc080e7          	jalr	1212(ra) # 800063ca <release>

  if (first) {
    80000f16:	0000a797          	auipc	a5,0xa
    80000f1a:	2fa7a783          	lw	a5,762(a5) # 8000b210 <first.1>
    80000f1e:	eb89                	bnez	a5,80000f30 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f20:	00001097          	auipc	ra,0x1
    80000f24:	c78080e7          	jalr	-904(ra) # 80001b98 <usertrapret>
}
    80000f28:	60a2                	ld	ra,8(sp)
    80000f2a:	6402                	ld	s0,0(sp)
    80000f2c:	0141                	addi	sp,sp,16
    80000f2e:	8082                	ret
    first = 0;
    80000f30:	0000a797          	auipc	a5,0xa
    80000f34:	2e07a023          	sw	zero,736(a5) # 8000b210 <first.1>
    fsinit(ROOTDEV);
    80000f38:	4505                	li	a0,1
    80000f3a:	00002097          	auipc	ra,0x2
    80000f3e:	a80080e7          	jalr	-1408(ra) # 800029ba <fsinit>
    80000f42:	bff9                	j	80000f20 <forkret+0x22>

0000000080000f44 <allocpid>:
allocpid() {
    80000f44:	1101                	addi	sp,sp,-32
    80000f46:	ec06                	sd	ra,24(sp)
    80000f48:	e822                	sd	s0,16(sp)
    80000f4a:	e426                	sd	s1,8(sp)
    80000f4c:	e04a                	sd	s2,0(sp)
    80000f4e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f50:	0000b917          	auipc	s2,0xb
    80000f54:	10090913          	addi	s2,s2,256 # 8000c050 <pid_lock>
    80000f58:	854a                	mv	a0,s2
    80000f5a:	00005097          	auipc	ra,0x5
    80000f5e:	3bc080e7          	jalr	956(ra) # 80006316 <acquire>
  pid = nextpid;
    80000f62:	0000a797          	auipc	a5,0xa
    80000f66:	2b278793          	addi	a5,a5,690 # 8000b214 <nextpid>
    80000f6a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f6c:	0014871b          	addiw	a4,s1,1
    80000f70:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f72:	854a                	mv	a0,s2
    80000f74:	00005097          	auipc	ra,0x5
    80000f78:	456080e7          	jalr	1110(ra) # 800063ca <release>
}
    80000f7c:	8526                	mv	a0,s1
    80000f7e:	60e2                	ld	ra,24(sp)
    80000f80:	6442                	ld	s0,16(sp)
    80000f82:	64a2                	ld	s1,8(sp)
    80000f84:	6902                	ld	s2,0(sp)
    80000f86:	6105                	addi	sp,sp,32
    80000f88:	8082                	ret

0000000080000f8a <proc_pagetable>:
{
    80000f8a:	1101                	addi	sp,sp,-32
    80000f8c:	ec06                	sd	ra,24(sp)
    80000f8e:	e822                	sd	s0,16(sp)
    80000f90:	e426                	sd	s1,8(sp)
    80000f92:	e04a                	sd	s2,0(sp)
    80000f94:	1000                	addi	s0,sp,32
    80000f96:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f98:	00000097          	auipc	ra,0x0
    80000f9c:	886080e7          	jalr	-1914(ra) # 8000081e <uvmcreate>
    80000fa0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000fa2:	c121                	beqz	a0,80000fe2 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000fa4:	4729                	li	a4,10
    80000fa6:	00006697          	auipc	a3,0x6
    80000faa:	05a68693          	addi	a3,a3,90 # 80007000 <_trampoline>
    80000fae:	6605                	lui	a2,0x1
    80000fb0:	040005b7          	lui	a1,0x4000
    80000fb4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fb6:	05b2                	slli	a1,a1,0xc
    80000fb8:	fffff097          	auipc	ra,0xfffff
    80000fbc:	5cc080e7          	jalr	1484(ra) # 80000584 <mappages>
    80000fc0:	02054863          	bltz	a0,80000ff0 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fc4:	4719                	li	a4,6
    80000fc6:	05893683          	ld	a3,88(s2)
    80000fca:	6605                	lui	a2,0x1
    80000fcc:	020005b7          	lui	a1,0x2000
    80000fd0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fd2:	05b6                	slli	a1,a1,0xd
    80000fd4:	8526                	mv	a0,s1
    80000fd6:	fffff097          	auipc	ra,0xfffff
    80000fda:	5ae080e7          	jalr	1454(ra) # 80000584 <mappages>
    80000fde:	02054163          	bltz	a0,80001000 <proc_pagetable+0x76>
}
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	60e2                	ld	ra,24(sp)
    80000fe6:	6442                	ld	s0,16(sp)
    80000fe8:	64a2                	ld	s1,8(sp)
    80000fea:	6902                	ld	s2,0(sp)
    80000fec:	6105                	addi	sp,sp,32
    80000fee:	8082                	ret
    uvmfree(pagetable, 0);
    80000ff0:	4581                	li	a1,0
    80000ff2:	8526                	mv	a0,s1
    80000ff4:	00000097          	auipc	ra,0x0
    80000ff8:	a30080e7          	jalr	-1488(ra) # 80000a24 <uvmfree>
    return 0;
    80000ffc:	4481                	li	s1,0
    80000ffe:	b7d5                	j	80000fe2 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001000:	4681                	li	a3,0
    80001002:	4605                	li	a2,1
    80001004:	040005b7          	lui	a1,0x4000
    80001008:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000100a:	05b2                	slli	a1,a1,0xc
    8000100c:	8526                	mv	a0,s1
    8000100e:	fffff097          	auipc	ra,0xfffff
    80001012:	73c080e7          	jalr	1852(ra) # 8000074a <uvmunmap>
    uvmfree(pagetable, 0);
    80001016:	4581                	li	a1,0
    80001018:	8526                	mv	a0,s1
    8000101a:	00000097          	auipc	ra,0x0
    8000101e:	a0a080e7          	jalr	-1526(ra) # 80000a24 <uvmfree>
    return 0;
    80001022:	4481                	li	s1,0
    80001024:	bf7d                	j	80000fe2 <proc_pagetable+0x58>

0000000080001026 <proc_freepagetable>:
{
    80001026:	1101                	addi	sp,sp,-32
    80001028:	ec06                	sd	ra,24(sp)
    8000102a:	e822                	sd	s0,16(sp)
    8000102c:	e426                	sd	s1,8(sp)
    8000102e:	e04a                	sd	s2,0(sp)
    80001030:	1000                	addi	s0,sp,32
    80001032:	84aa                	mv	s1,a0
    80001034:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001036:	4681                	li	a3,0
    80001038:	4605                	li	a2,1
    8000103a:	040005b7          	lui	a1,0x4000
    8000103e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001040:	05b2                	slli	a1,a1,0xc
    80001042:	fffff097          	auipc	ra,0xfffff
    80001046:	708080e7          	jalr	1800(ra) # 8000074a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000104a:	4681                	li	a3,0
    8000104c:	4605                	li	a2,1
    8000104e:	020005b7          	lui	a1,0x2000
    80001052:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001054:	05b6                	slli	a1,a1,0xd
    80001056:	8526                	mv	a0,s1
    80001058:	fffff097          	auipc	ra,0xfffff
    8000105c:	6f2080e7          	jalr	1778(ra) # 8000074a <uvmunmap>
  uvmfree(pagetable, sz);
    80001060:	85ca                	mv	a1,s2
    80001062:	8526                	mv	a0,s1
    80001064:	00000097          	auipc	ra,0x0
    80001068:	9c0080e7          	jalr	-1600(ra) # 80000a24 <uvmfree>
}
    8000106c:	60e2                	ld	ra,24(sp)
    8000106e:	6442                	ld	s0,16(sp)
    80001070:	64a2                	ld	s1,8(sp)
    80001072:	6902                	ld	s2,0(sp)
    80001074:	6105                	addi	sp,sp,32
    80001076:	8082                	ret

0000000080001078 <freeproc>:
{
    80001078:	1101                	addi	sp,sp,-32
    8000107a:	ec06                	sd	ra,24(sp)
    8000107c:	e822                	sd	s0,16(sp)
    8000107e:	e426                	sd	s1,8(sp)
    80001080:	1000                	addi	s0,sp,32
    80001082:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001084:	6d28                	ld	a0,88(a0)
    80001086:	c509                	beqz	a0,80001090 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001088:	fffff097          	auipc	ra,0xfffff
    8000108c:	f94080e7          	jalr	-108(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001090:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001094:	68a8                	ld	a0,80(s1)
    80001096:	c511                	beqz	a0,800010a2 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001098:	64ac                	ld	a1,72(s1)
    8000109a:	00000097          	auipc	ra,0x0
    8000109e:	f8c080e7          	jalr	-116(ra) # 80001026 <proc_freepagetable>
  p->pagetable = 0;
    800010a2:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800010a6:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800010aa:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800010ae:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800010b2:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800010b6:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010ba:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800010be:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010c2:	0004ac23          	sw	zero,24(s1)
  p->trace_mask = 0;
    800010c6:	1604a423          	sw	zero,360(s1)
}
    800010ca:	60e2                	ld	ra,24(sp)
    800010cc:	6442                	ld	s0,16(sp)
    800010ce:	64a2                	ld	s1,8(sp)
    800010d0:	6105                	addi	sp,sp,32
    800010d2:	8082                	ret

00000000800010d4 <allocproc>:
{
    800010d4:	1101                	addi	sp,sp,-32
    800010d6:	ec06                	sd	ra,24(sp)
    800010d8:	e822                	sd	s0,16(sp)
    800010da:	e426                	sd	s1,8(sp)
    800010dc:	e04a                	sd	s2,0(sp)
    800010de:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010e0:	0000b497          	auipc	s1,0xb
    800010e4:	3a048493          	addi	s1,s1,928 # 8000c480 <proc>
    800010e8:	00011917          	auipc	s2,0x11
    800010ec:	f9890913          	addi	s2,s2,-104 # 80012080 <tickslock>
    acquire(&p->lock);
    800010f0:	8526                	mv	a0,s1
    800010f2:	00005097          	auipc	ra,0x5
    800010f6:	224080e7          	jalr	548(ra) # 80006316 <acquire>
    if(p->state == UNUSED) {
    800010fa:	4c9c                	lw	a5,24(s1)
    800010fc:	cf81                	beqz	a5,80001114 <allocproc+0x40>
      release(&p->lock);
    800010fe:	8526                	mv	a0,s1
    80001100:	00005097          	auipc	ra,0x5
    80001104:	2ca080e7          	jalr	714(ra) # 800063ca <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001108:	17048493          	addi	s1,s1,368
    8000110c:	ff2492e3          	bne	s1,s2,800010f0 <allocproc+0x1c>
  return 0;
    80001110:	4481                	li	s1,0
    80001112:	a889                	j	80001164 <allocproc+0x90>
  p->pid = allocpid();
    80001114:	00000097          	auipc	ra,0x0
    80001118:	e30080e7          	jalr	-464(ra) # 80000f44 <allocpid>
    8000111c:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000111e:	4785                	li	a5,1
    80001120:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001122:	fffff097          	auipc	ra,0xfffff
    80001126:	ff8080e7          	jalr	-8(ra) # 8000011a <kalloc>
    8000112a:	892a                	mv	s2,a0
    8000112c:	eca8                	sd	a0,88(s1)
    8000112e:	c131                	beqz	a0,80001172 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001130:	8526                	mv	a0,s1
    80001132:	00000097          	auipc	ra,0x0
    80001136:	e58080e7          	jalr	-424(ra) # 80000f8a <proc_pagetable>
    8000113a:	892a                	mv	s2,a0
    8000113c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000113e:	c531                	beqz	a0,8000118a <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001140:	07000613          	li	a2,112
    80001144:	4581                	li	a1,0
    80001146:	06048513          	addi	a0,s1,96
    8000114a:	fffff097          	auipc	ra,0xfffff
    8000114e:	07a080e7          	jalr	122(ra) # 800001c4 <memset>
  p->context.ra = (uint64)forkret;
    80001152:	00000797          	auipc	a5,0x0
    80001156:	dac78793          	addi	a5,a5,-596 # 80000efe <forkret>
    8000115a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000115c:	60bc                	ld	a5,64(s1)
    8000115e:	6705                	lui	a4,0x1
    80001160:	97ba                	add	a5,a5,a4
    80001162:	f4bc                	sd	a5,104(s1)
}
    80001164:	8526                	mv	a0,s1
    80001166:	60e2                	ld	ra,24(sp)
    80001168:	6442                	ld	s0,16(sp)
    8000116a:	64a2                	ld	s1,8(sp)
    8000116c:	6902                	ld	s2,0(sp)
    8000116e:	6105                	addi	sp,sp,32
    80001170:	8082                	ret
    freeproc(p);
    80001172:	8526                	mv	a0,s1
    80001174:	00000097          	auipc	ra,0x0
    80001178:	f04080e7          	jalr	-252(ra) # 80001078 <freeproc>
    release(&p->lock);
    8000117c:	8526                	mv	a0,s1
    8000117e:	00005097          	auipc	ra,0x5
    80001182:	24c080e7          	jalr	588(ra) # 800063ca <release>
    return 0;
    80001186:	84ca                	mv	s1,s2
    80001188:	bff1                	j	80001164 <allocproc+0x90>
    freeproc(p);
    8000118a:	8526                	mv	a0,s1
    8000118c:	00000097          	auipc	ra,0x0
    80001190:	eec080e7          	jalr	-276(ra) # 80001078 <freeproc>
    release(&p->lock);
    80001194:	8526                	mv	a0,s1
    80001196:	00005097          	auipc	ra,0x5
    8000119a:	234080e7          	jalr	564(ra) # 800063ca <release>
    return 0;
    8000119e:	84ca                	mv	s1,s2
    800011a0:	b7d1                	j	80001164 <allocproc+0x90>

00000000800011a2 <userinit>:
{
    800011a2:	1101                	addi	sp,sp,-32
    800011a4:	ec06                	sd	ra,24(sp)
    800011a6:	e822                	sd	s0,16(sp)
    800011a8:	e426                	sd	s1,8(sp)
    800011aa:	1000                	addi	s0,sp,32
  p = allocproc();
    800011ac:	00000097          	auipc	ra,0x0
    800011b0:	f28080e7          	jalr	-216(ra) # 800010d4 <allocproc>
    800011b4:	84aa                	mv	s1,a0
  initproc = p;
    800011b6:	0000b797          	auipc	a5,0xb
    800011ba:	e4a7bd23          	sd	a0,-422(a5) # 8000c010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800011be:	03400613          	li	a2,52
    800011c2:	0000a597          	auipc	a1,0xa
    800011c6:	05e58593          	addi	a1,a1,94 # 8000b220 <initcode>
    800011ca:	6928                	ld	a0,80(a0)
    800011cc:	fffff097          	auipc	ra,0xfffff
    800011d0:	680080e7          	jalr	1664(ra) # 8000084c <uvminit>
  p->sz = PGSIZE;
    800011d4:	6785                	lui	a5,0x1
    800011d6:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011d8:	6cb8                	ld	a4,88(s1)
    800011da:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011de:	6cb8                	ld	a4,88(s1)
    800011e0:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011e2:	4641                	li	a2,16
    800011e4:	00007597          	auipc	a1,0x7
    800011e8:	f9c58593          	addi	a1,a1,-100 # 80008180 <etext+0x180>
    800011ec:	15848513          	addi	a0,s1,344
    800011f0:	fffff097          	auipc	ra,0xfffff
    800011f4:	116080e7          	jalr	278(ra) # 80000306 <safestrcpy>
  p->cwd = namei("/");
    800011f8:	00007517          	auipc	a0,0x7
    800011fc:	f9850513          	addi	a0,a0,-104 # 80008190 <etext+0x190>
    80001200:	00002097          	auipc	ra,0x2
    80001204:	200080e7          	jalr	512(ra) # 80003400 <namei>
    80001208:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000120c:	478d                	li	a5,3
    8000120e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001210:	8526                	mv	a0,s1
    80001212:	00005097          	auipc	ra,0x5
    80001216:	1b8080e7          	jalr	440(ra) # 800063ca <release>
}
    8000121a:	60e2                	ld	ra,24(sp)
    8000121c:	6442                	ld	s0,16(sp)
    8000121e:	64a2                	ld	s1,8(sp)
    80001220:	6105                	addi	sp,sp,32
    80001222:	8082                	ret

0000000080001224 <growproc>:
{
    80001224:	1101                	addi	sp,sp,-32
    80001226:	ec06                	sd	ra,24(sp)
    80001228:	e822                	sd	s0,16(sp)
    8000122a:	e426                	sd	s1,8(sp)
    8000122c:	e04a                	sd	s2,0(sp)
    8000122e:	1000                	addi	s0,sp,32
    80001230:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001232:	00000097          	auipc	ra,0x0
    80001236:	c94080e7          	jalr	-876(ra) # 80000ec6 <myproc>
    8000123a:	892a                	mv	s2,a0
  sz = p->sz;
    8000123c:	652c                	ld	a1,72(a0)
    8000123e:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001242:	00904f63          	bgtz	s1,80001260 <growproc+0x3c>
  } else if(n < 0){
    80001246:	0204cd63          	bltz	s1,80001280 <growproc+0x5c>
  p->sz = sz;
    8000124a:	1782                	slli	a5,a5,0x20
    8000124c:	9381                	srli	a5,a5,0x20
    8000124e:	04f93423          	sd	a5,72(s2)
  return 0;
    80001252:	4501                	li	a0,0
}
    80001254:	60e2                	ld	ra,24(sp)
    80001256:	6442                	ld	s0,16(sp)
    80001258:	64a2                	ld	s1,8(sp)
    8000125a:	6902                	ld	s2,0(sp)
    8000125c:	6105                	addi	sp,sp,32
    8000125e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001260:	00f4863b          	addw	a2,s1,a5
    80001264:	1602                	slli	a2,a2,0x20
    80001266:	9201                	srli	a2,a2,0x20
    80001268:	1582                	slli	a1,a1,0x20
    8000126a:	9181                	srli	a1,a1,0x20
    8000126c:	6928                	ld	a0,80(a0)
    8000126e:	fffff097          	auipc	ra,0xfffff
    80001272:	698080e7          	jalr	1688(ra) # 80000906 <uvmalloc>
    80001276:	0005079b          	sext.w	a5,a0
    8000127a:	fbe1                	bnez	a5,8000124a <growproc+0x26>
      return -1;
    8000127c:	557d                	li	a0,-1
    8000127e:	bfd9                	j	80001254 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001280:	00f4863b          	addw	a2,s1,a5
    80001284:	1602                	slli	a2,a2,0x20
    80001286:	9201                	srli	a2,a2,0x20
    80001288:	1582                	slli	a1,a1,0x20
    8000128a:	9181                	srli	a1,a1,0x20
    8000128c:	6928                	ld	a0,80(a0)
    8000128e:	fffff097          	auipc	ra,0xfffff
    80001292:	630080e7          	jalr	1584(ra) # 800008be <uvmdealloc>
    80001296:	0005079b          	sext.w	a5,a0
    8000129a:	bf45                	j	8000124a <growproc+0x26>

000000008000129c <fork>:
{
    8000129c:	7139                	addi	sp,sp,-64
    8000129e:	fc06                	sd	ra,56(sp)
    800012a0:	f822                	sd	s0,48(sp)
    800012a2:	f04a                	sd	s2,32(sp)
    800012a4:	e456                	sd	s5,8(sp)
    800012a6:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800012a8:	00000097          	auipc	ra,0x0
    800012ac:	c1e080e7          	jalr	-994(ra) # 80000ec6 <myproc>
    800012b0:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800012b2:	00000097          	auipc	ra,0x0
    800012b6:	e22080e7          	jalr	-478(ra) # 800010d4 <allocproc>
    800012ba:	12050463          	beqz	a0,800013e2 <fork+0x146>
    800012be:	ec4e                	sd	s3,24(sp)
    800012c0:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800012c2:	048ab603          	ld	a2,72(s5)
    800012c6:	692c                	ld	a1,80(a0)
    800012c8:	050ab503          	ld	a0,80(s5)
    800012cc:	fffff097          	auipc	ra,0xfffff
    800012d0:	792080e7          	jalr	1938(ra) # 80000a5e <uvmcopy>
    800012d4:	04054e63          	bltz	a0,80001330 <fork+0x94>
    800012d8:	f426                	sd	s1,40(sp)
    800012da:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    800012dc:	048ab783          	ld	a5,72(s5)
    800012e0:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800012e4:	058ab683          	ld	a3,88(s5)
    800012e8:	87b6                	mv	a5,a3
    800012ea:	0589b703          	ld	a4,88(s3)
    800012ee:	12068693          	addi	a3,a3,288
    800012f2:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012f6:	6788                	ld	a0,8(a5)
    800012f8:	6b8c                	ld	a1,16(a5)
    800012fa:	6f90                	ld	a2,24(a5)
    800012fc:	01073023          	sd	a6,0(a4)
    80001300:	e708                	sd	a0,8(a4)
    80001302:	eb0c                	sd	a1,16(a4)
    80001304:	ef10                	sd	a2,24(a4)
    80001306:	02078793          	addi	a5,a5,32
    8000130a:	02070713          	addi	a4,a4,32
    8000130e:	fed792e3          	bne	a5,a3,800012f2 <fork+0x56>
  np->trapframe->a0 = 0;
    80001312:	0589b783          	ld	a5,88(s3)
    80001316:	0607b823          	sd	zero,112(a5)
  np->trace_mask = p->trace_mask;
    8000131a:	168aa783          	lw	a5,360(s5)
    8000131e:	16f9a423          	sw	a5,360(s3)
  for(i = 0; i < NOFILE; i++)
    80001322:	0d0a8493          	addi	s1,s5,208
    80001326:	0d098913          	addi	s2,s3,208
    8000132a:	150a8a13          	addi	s4,s5,336
    8000132e:	a015                	j	80001352 <fork+0xb6>
    freeproc(np);
    80001330:	854e                	mv	a0,s3
    80001332:	00000097          	auipc	ra,0x0
    80001336:	d46080e7          	jalr	-698(ra) # 80001078 <freeproc>
    release(&np->lock);
    8000133a:	854e                	mv	a0,s3
    8000133c:	00005097          	auipc	ra,0x5
    80001340:	08e080e7          	jalr	142(ra) # 800063ca <release>
    return -1;
    80001344:	597d                	li	s2,-1
    80001346:	69e2                	ld	s3,24(sp)
    80001348:	a071                	j	800013d4 <fork+0x138>
  for(i = 0; i < NOFILE; i++)
    8000134a:	04a1                	addi	s1,s1,8
    8000134c:	0921                	addi	s2,s2,8
    8000134e:	01448b63          	beq	s1,s4,80001364 <fork+0xc8>
    if(p->ofile[i])
    80001352:	6088                	ld	a0,0(s1)
    80001354:	d97d                	beqz	a0,8000134a <fork+0xae>
      np->ofile[i] = filedup(p->ofile[i]);
    80001356:	00002097          	auipc	ra,0x2
    8000135a:	722080e7          	jalr	1826(ra) # 80003a78 <filedup>
    8000135e:	00a93023          	sd	a0,0(s2)
    80001362:	b7e5                	j	8000134a <fork+0xae>
  np->cwd = idup(p->cwd);
    80001364:	150ab503          	ld	a0,336(s5)
    80001368:	00002097          	auipc	ra,0x2
    8000136c:	888080e7          	jalr	-1912(ra) # 80002bf0 <idup>
    80001370:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001374:	4641                	li	a2,16
    80001376:	158a8593          	addi	a1,s5,344
    8000137a:	15898513          	addi	a0,s3,344
    8000137e:	fffff097          	auipc	ra,0xfffff
    80001382:	f88080e7          	jalr	-120(ra) # 80000306 <safestrcpy>
  pid = np->pid;
    80001386:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000138a:	854e                	mv	a0,s3
    8000138c:	00005097          	auipc	ra,0x5
    80001390:	03e080e7          	jalr	62(ra) # 800063ca <release>
  acquire(&wait_lock);
    80001394:	0000b497          	auipc	s1,0xb
    80001398:	cd448493          	addi	s1,s1,-812 # 8000c068 <wait_lock>
    8000139c:	8526                	mv	a0,s1
    8000139e:	00005097          	auipc	ra,0x5
    800013a2:	f78080e7          	jalr	-136(ra) # 80006316 <acquire>
  np->parent = p;
    800013a6:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    800013aa:	8526                	mv	a0,s1
    800013ac:	00005097          	auipc	ra,0x5
    800013b0:	01e080e7          	jalr	30(ra) # 800063ca <release>
  acquire(&np->lock);
    800013b4:	854e                	mv	a0,s3
    800013b6:	00005097          	auipc	ra,0x5
    800013ba:	f60080e7          	jalr	-160(ra) # 80006316 <acquire>
  np->state = RUNNABLE;
    800013be:	478d                	li	a5,3
    800013c0:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800013c4:	854e                	mv	a0,s3
    800013c6:	00005097          	auipc	ra,0x5
    800013ca:	004080e7          	jalr	4(ra) # 800063ca <release>
  return pid;
    800013ce:	74a2                	ld	s1,40(sp)
    800013d0:	69e2                	ld	s3,24(sp)
    800013d2:	6a42                	ld	s4,16(sp)
}
    800013d4:	854a                	mv	a0,s2
    800013d6:	70e2                	ld	ra,56(sp)
    800013d8:	7442                	ld	s0,48(sp)
    800013da:	7902                	ld	s2,32(sp)
    800013dc:	6aa2                	ld	s5,8(sp)
    800013de:	6121                	addi	sp,sp,64
    800013e0:	8082                	ret
    return -1;
    800013e2:	597d                	li	s2,-1
    800013e4:	bfc5                	j	800013d4 <fork+0x138>

00000000800013e6 <scheduler>:
{
    800013e6:	7139                	addi	sp,sp,-64
    800013e8:	fc06                	sd	ra,56(sp)
    800013ea:	f822                	sd	s0,48(sp)
    800013ec:	f426                	sd	s1,40(sp)
    800013ee:	f04a                	sd	s2,32(sp)
    800013f0:	ec4e                	sd	s3,24(sp)
    800013f2:	e852                	sd	s4,16(sp)
    800013f4:	e456                	sd	s5,8(sp)
    800013f6:	e05a                	sd	s6,0(sp)
    800013f8:	0080                	addi	s0,sp,64
    800013fa:	8792                	mv	a5,tp
  int id = r_tp();
    800013fc:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013fe:	00779a93          	slli	s5,a5,0x7
    80001402:	0000b717          	auipc	a4,0xb
    80001406:	c4e70713          	addi	a4,a4,-946 # 8000c050 <pid_lock>
    8000140a:	9756                	add	a4,a4,s5
    8000140c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001410:	0000b717          	auipc	a4,0xb
    80001414:	c7870713          	addi	a4,a4,-904 # 8000c088 <cpus+0x8>
    80001418:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000141a:	498d                	li	s3,3
        p->state = RUNNING;
    8000141c:	4b11                	li	s6,4
        c->proc = p;
    8000141e:	079e                	slli	a5,a5,0x7
    80001420:	0000ba17          	auipc	s4,0xb
    80001424:	c30a0a13          	addi	s4,s4,-976 # 8000c050 <pid_lock>
    80001428:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000142a:	00011917          	auipc	s2,0x11
    8000142e:	c5690913          	addi	s2,s2,-938 # 80012080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001432:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001436:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000143a:	10079073          	csrw	sstatus,a5
    8000143e:	0000b497          	auipc	s1,0xb
    80001442:	04248493          	addi	s1,s1,66 # 8000c480 <proc>
    80001446:	a811                	j	8000145a <scheduler+0x74>
      release(&p->lock);
    80001448:	8526                	mv	a0,s1
    8000144a:	00005097          	auipc	ra,0x5
    8000144e:	f80080e7          	jalr	-128(ra) # 800063ca <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001452:	17048493          	addi	s1,s1,368
    80001456:	fd248ee3          	beq	s1,s2,80001432 <scheduler+0x4c>
      acquire(&p->lock);
    8000145a:	8526                	mv	a0,s1
    8000145c:	00005097          	auipc	ra,0x5
    80001460:	eba080e7          	jalr	-326(ra) # 80006316 <acquire>
      if(p->state == RUNNABLE) {
    80001464:	4c9c                	lw	a5,24(s1)
    80001466:	ff3791e3          	bne	a5,s3,80001448 <scheduler+0x62>
        p->state = RUNNING;
    8000146a:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000146e:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001472:	06048593          	addi	a1,s1,96
    80001476:	8556                	mv	a0,s5
    80001478:	00000097          	auipc	ra,0x0
    8000147c:	676080e7          	jalr	1654(ra) # 80001aee <swtch>
        c->proc = 0;
    80001480:	020a3823          	sd	zero,48(s4)
    80001484:	b7d1                	j	80001448 <scheduler+0x62>

0000000080001486 <sched>:
{
    80001486:	7179                	addi	sp,sp,-48
    80001488:	f406                	sd	ra,40(sp)
    8000148a:	f022                	sd	s0,32(sp)
    8000148c:	ec26                	sd	s1,24(sp)
    8000148e:	e84a                	sd	s2,16(sp)
    80001490:	e44e                	sd	s3,8(sp)
    80001492:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001494:	00000097          	auipc	ra,0x0
    80001498:	a32080e7          	jalr	-1486(ra) # 80000ec6 <myproc>
    8000149c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000149e:	00005097          	auipc	ra,0x5
    800014a2:	dfe080e7          	jalr	-514(ra) # 8000629c <holding>
    800014a6:	c93d                	beqz	a0,8000151c <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014a8:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800014aa:	2781                	sext.w	a5,a5
    800014ac:	079e                	slli	a5,a5,0x7
    800014ae:	0000b717          	auipc	a4,0xb
    800014b2:	ba270713          	addi	a4,a4,-1118 # 8000c050 <pid_lock>
    800014b6:	97ba                	add	a5,a5,a4
    800014b8:	0a87a703          	lw	a4,168(a5)
    800014bc:	4785                	li	a5,1
    800014be:	06f71763          	bne	a4,a5,8000152c <sched+0xa6>
  if(p->state == RUNNING)
    800014c2:	4c98                	lw	a4,24(s1)
    800014c4:	4791                	li	a5,4
    800014c6:	06f70b63          	beq	a4,a5,8000153c <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014ca:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014ce:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014d0:	efb5                	bnez	a5,8000154c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014d2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014d4:	0000b917          	auipc	s2,0xb
    800014d8:	b7c90913          	addi	s2,s2,-1156 # 8000c050 <pid_lock>
    800014dc:	2781                	sext.w	a5,a5
    800014de:	079e                	slli	a5,a5,0x7
    800014e0:	97ca                	add	a5,a5,s2
    800014e2:	0ac7a983          	lw	s3,172(a5)
    800014e6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014e8:	2781                	sext.w	a5,a5
    800014ea:	079e                	slli	a5,a5,0x7
    800014ec:	0000b597          	auipc	a1,0xb
    800014f0:	b9c58593          	addi	a1,a1,-1124 # 8000c088 <cpus+0x8>
    800014f4:	95be                	add	a1,a1,a5
    800014f6:	06048513          	addi	a0,s1,96
    800014fa:	00000097          	auipc	ra,0x0
    800014fe:	5f4080e7          	jalr	1524(ra) # 80001aee <swtch>
    80001502:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001504:	2781                	sext.w	a5,a5
    80001506:	079e                	slli	a5,a5,0x7
    80001508:	993e                	add	s2,s2,a5
    8000150a:	0b392623          	sw	s3,172(s2)
}
    8000150e:	70a2                	ld	ra,40(sp)
    80001510:	7402                	ld	s0,32(sp)
    80001512:	64e2                	ld	s1,24(sp)
    80001514:	6942                	ld	s2,16(sp)
    80001516:	69a2                	ld	s3,8(sp)
    80001518:	6145                	addi	sp,sp,48
    8000151a:	8082                	ret
    panic("sched p->lock");
    8000151c:	00007517          	auipc	a0,0x7
    80001520:	c7c50513          	addi	a0,a0,-900 # 80008198 <etext+0x198>
    80001524:	00005097          	auipc	ra,0x5
    80001528:	878080e7          	jalr	-1928(ra) # 80005d9c <panic>
    panic("sched locks");
    8000152c:	00007517          	auipc	a0,0x7
    80001530:	c7c50513          	addi	a0,a0,-900 # 800081a8 <etext+0x1a8>
    80001534:	00005097          	auipc	ra,0x5
    80001538:	868080e7          	jalr	-1944(ra) # 80005d9c <panic>
    panic("sched running");
    8000153c:	00007517          	auipc	a0,0x7
    80001540:	c7c50513          	addi	a0,a0,-900 # 800081b8 <etext+0x1b8>
    80001544:	00005097          	auipc	ra,0x5
    80001548:	858080e7          	jalr	-1960(ra) # 80005d9c <panic>
    panic("sched interruptible");
    8000154c:	00007517          	auipc	a0,0x7
    80001550:	c7c50513          	addi	a0,a0,-900 # 800081c8 <etext+0x1c8>
    80001554:	00005097          	auipc	ra,0x5
    80001558:	848080e7          	jalr	-1976(ra) # 80005d9c <panic>

000000008000155c <yield>:
{
    8000155c:	1101                	addi	sp,sp,-32
    8000155e:	ec06                	sd	ra,24(sp)
    80001560:	e822                	sd	s0,16(sp)
    80001562:	e426                	sd	s1,8(sp)
    80001564:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001566:	00000097          	auipc	ra,0x0
    8000156a:	960080e7          	jalr	-1696(ra) # 80000ec6 <myproc>
    8000156e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001570:	00005097          	auipc	ra,0x5
    80001574:	da6080e7          	jalr	-602(ra) # 80006316 <acquire>
  p->state = RUNNABLE;
    80001578:	478d                	li	a5,3
    8000157a:	cc9c                	sw	a5,24(s1)
  sched();
    8000157c:	00000097          	auipc	ra,0x0
    80001580:	f0a080e7          	jalr	-246(ra) # 80001486 <sched>
  release(&p->lock);
    80001584:	8526                	mv	a0,s1
    80001586:	00005097          	auipc	ra,0x5
    8000158a:	e44080e7          	jalr	-444(ra) # 800063ca <release>
}
    8000158e:	60e2                	ld	ra,24(sp)
    80001590:	6442                	ld	s0,16(sp)
    80001592:	64a2                	ld	s1,8(sp)
    80001594:	6105                	addi	sp,sp,32
    80001596:	8082                	ret

0000000080001598 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001598:	7179                	addi	sp,sp,-48
    8000159a:	f406                	sd	ra,40(sp)
    8000159c:	f022                	sd	s0,32(sp)
    8000159e:	ec26                	sd	s1,24(sp)
    800015a0:	e84a                	sd	s2,16(sp)
    800015a2:	e44e                	sd	s3,8(sp)
    800015a4:	1800                	addi	s0,sp,48
    800015a6:	89aa                	mv	s3,a0
    800015a8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015aa:	00000097          	auipc	ra,0x0
    800015ae:	91c080e7          	jalr	-1764(ra) # 80000ec6 <myproc>
    800015b2:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800015b4:	00005097          	auipc	ra,0x5
    800015b8:	d62080e7          	jalr	-670(ra) # 80006316 <acquire>
  release(lk);
    800015bc:	854a                	mv	a0,s2
    800015be:	00005097          	auipc	ra,0x5
    800015c2:	e0c080e7          	jalr	-500(ra) # 800063ca <release>

  // Go to sleep.
  p->chan = chan;
    800015c6:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015ca:	4789                	li	a5,2
    800015cc:	cc9c                	sw	a5,24(s1)

  sched();
    800015ce:	00000097          	auipc	ra,0x0
    800015d2:	eb8080e7          	jalr	-328(ra) # 80001486 <sched>

  // Tidy up.
  p->chan = 0;
    800015d6:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015da:	8526                	mv	a0,s1
    800015dc:	00005097          	auipc	ra,0x5
    800015e0:	dee080e7          	jalr	-530(ra) # 800063ca <release>
  acquire(lk);
    800015e4:	854a                	mv	a0,s2
    800015e6:	00005097          	auipc	ra,0x5
    800015ea:	d30080e7          	jalr	-720(ra) # 80006316 <acquire>
}
    800015ee:	70a2                	ld	ra,40(sp)
    800015f0:	7402                	ld	s0,32(sp)
    800015f2:	64e2                	ld	s1,24(sp)
    800015f4:	6942                	ld	s2,16(sp)
    800015f6:	69a2                	ld	s3,8(sp)
    800015f8:	6145                	addi	sp,sp,48
    800015fa:	8082                	ret

00000000800015fc <wait>:
{
    800015fc:	715d                	addi	sp,sp,-80
    800015fe:	e486                	sd	ra,72(sp)
    80001600:	e0a2                	sd	s0,64(sp)
    80001602:	fc26                	sd	s1,56(sp)
    80001604:	f84a                	sd	s2,48(sp)
    80001606:	f44e                	sd	s3,40(sp)
    80001608:	f052                	sd	s4,32(sp)
    8000160a:	ec56                	sd	s5,24(sp)
    8000160c:	e85a                	sd	s6,16(sp)
    8000160e:	e45e                	sd	s7,8(sp)
    80001610:	e062                	sd	s8,0(sp)
    80001612:	0880                	addi	s0,sp,80
    80001614:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	8b0080e7          	jalr	-1872(ra) # 80000ec6 <myproc>
    8000161e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001620:	0000b517          	auipc	a0,0xb
    80001624:	a4850513          	addi	a0,a0,-1464 # 8000c068 <wait_lock>
    80001628:	00005097          	auipc	ra,0x5
    8000162c:	cee080e7          	jalr	-786(ra) # 80006316 <acquire>
    havekids = 0;
    80001630:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001632:	4a15                	li	s4,5
        havekids = 1;
    80001634:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    80001636:	00011997          	auipc	s3,0x11
    8000163a:	a4a98993          	addi	s3,s3,-1462 # 80012080 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000163e:	0000bc17          	auipc	s8,0xb
    80001642:	a2ac0c13          	addi	s8,s8,-1494 # 8000c068 <wait_lock>
    80001646:	a87d                	j	80001704 <wait+0x108>
          pid = np->pid;
    80001648:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000164c:	000b0e63          	beqz	s6,80001668 <wait+0x6c>
    80001650:	4691                	li	a3,4
    80001652:	02c48613          	addi	a2,s1,44
    80001656:	85da                	mv	a1,s6
    80001658:	05093503          	ld	a0,80(s2)
    8000165c:	fffff097          	auipc	ra,0xfffff
    80001660:	506080e7          	jalr	1286(ra) # 80000b62 <copyout>
    80001664:	04054163          	bltz	a0,800016a6 <wait+0xaa>
          freeproc(np);
    80001668:	8526                	mv	a0,s1
    8000166a:	00000097          	auipc	ra,0x0
    8000166e:	a0e080e7          	jalr	-1522(ra) # 80001078 <freeproc>
          release(&np->lock);
    80001672:	8526                	mv	a0,s1
    80001674:	00005097          	auipc	ra,0x5
    80001678:	d56080e7          	jalr	-682(ra) # 800063ca <release>
          release(&wait_lock);
    8000167c:	0000b517          	auipc	a0,0xb
    80001680:	9ec50513          	addi	a0,a0,-1556 # 8000c068 <wait_lock>
    80001684:	00005097          	auipc	ra,0x5
    80001688:	d46080e7          	jalr	-698(ra) # 800063ca <release>
}
    8000168c:	854e                	mv	a0,s3
    8000168e:	60a6                	ld	ra,72(sp)
    80001690:	6406                	ld	s0,64(sp)
    80001692:	74e2                	ld	s1,56(sp)
    80001694:	7942                	ld	s2,48(sp)
    80001696:	79a2                	ld	s3,40(sp)
    80001698:	7a02                	ld	s4,32(sp)
    8000169a:	6ae2                	ld	s5,24(sp)
    8000169c:	6b42                	ld	s6,16(sp)
    8000169e:	6ba2                	ld	s7,8(sp)
    800016a0:	6c02                	ld	s8,0(sp)
    800016a2:	6161                	addi	sp,sp,80
    800016a4:	8082                	ret
            release(&np->lock);
    800016a6:	8526                	mv	a0,s1
    800016a8:	00005097          	auipc	ra,0x5
    800016ac:	d22080e7          	jalr	-734(ra) # 800063ca <release>
            release(&wait_lock);
    800016b0:	0000b517          	auipc	a0,0xb
    800016b4:	9b850513          	addi	a0,a0,-1608 # 8000c068 <wait_lock>
    800016b8:	00005097          	auipc	ra,0x5
    800016bc:	d12080e7          	jalr	-750(ra) # 800063ca <release>
            return -1;
    800016c0:	59fd                	li	s3,-1
    800016c2:	b7e9                	j	8000168c <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    800016c4:	17048493          	addi	s1,s1,368
    800016c8:	03348463          	beq	s1,s3,800016f0 <wait+0xf4>
      if(np->parent == p){
    800016cc:	7c9c                	ld	a5,56(s1)
    800016ce:	ff279be3          	bne	a5,s2,800016c4 <wait+0xc8>
        acquire(&np->lock);
    800016d2:	8526                	mv	a0,s1
    800016d4:	00005097          	auipc	ra,0x5
    800016d8:	c42080e7          	jalr	-958(ra) # 80006316 <acquire>
        if(np->state == ZOMBIE){
    800016dc:	4c9c                	lw	a5,24(s1)
    800016de:	f74785e3          	beq	a5,s4,80001648 <wait+0x4c>
        release(&np->lock);
    800016e2:	8526                	mv	a0,s1
    800016e4:	00005097          	auipc	ra,0x5
    800016e8:	ce6080e7          	jalr	-794(ra) # 800063ca <release>
        havekids = 1;
    800016ec:	8756                	mv	a4,s5
    800016ee:	bfd9                	j	800016c4 <wait+0xc8>
    if(!havekids || p->killed){
    800016f0:	c305                	beqz	a4,80001710 <wait+0x114>
    800016f2:	02892783          	lw	a5,40(s2)
    800016f6:	ef89                	bnez	a5,80001710 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016f8:	85e2                	mv	a1,s8
    800016fa:	854a                	mv	a0,s2
    800016fc:	00000097          	auipc	ra,0x0
    80001700:	e9c080e7          	jalr	-356(ra) # 80001598 <sleep>
    havekids = 0;
    80001704:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    80001706:	0000b497          	auipc	s1,0xb
    8000170a:	d7a48493          	addi	s1,s1,-646 # 8000c480 <proc>
    8000170e:	bf7d                	j	800016cc <wait+0xd0>
      release(&wait_lock);
    80001710:	0000b517          	auipc	a0,0xb
    80001714:	95850513          	addi	a0,a0,-1704 # 8000c068 <wait_lock>
    80001718:	00005097          	auipc	ra,0x5
    8000171c:	cb2080e7          	jalr	-846(ra) # 800063ca <release>
      return -1;
    80001720:	59fd                	li	s3,-1
    80001722:	b7ad                	j	8000168c <wait+0x90>

0000000080001724 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001724:	7139                	addi	sp,sp,-64
    80001726:	fc06                	sd	ra,56(sp)
    80001728:	f822                	sd	s0,48(sp)
    8000172a:	f426                	sd	s1,40(sp)
    8000172c:	f04a                	sd	s2,32(sp)
    8000172e:	ec4e                	sd	s3,24(sp)
    80001730:	e852                	sd	s4,16(sp)
    80001732:	e456                	sd	s5,8(sp)
    80001734:	0080                	addi	s0,sp,64
    80001736:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001738:	0000b497          	auipc	s1,0xb
    8000173c:	d4848493          	addi	s1,s1,-696 # 8000c480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001740:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001742:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001744:	00011917          	auipc	s2,0x11
    80001748:	93c90913          	addi	s2,s2,-1732 # 80012080 <tickslock>
    8000174c:	a811                	j	80001760 <wakeup+0x3c>
      }
      release(&p->lock);
    8000174e:	8526                	mv	a0,s1
    80001750:	00005097          	auipc	ra,0x5
    80001754:	c7a080e7          	jalr	-902(ra) # 800063ca <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001758:	17048493          	addi	s1,s1,368
    8000175c:	03248663          	beq	s1,s2,80001788 <wakeup+0x64>
    if(p != myproc()){
    80001760:	fffff097          	auipc	ra,0xfffff
    80001764:	766080e7          	jalr	1894(ra) # 80000ec6 <myproc>
    80001768:	fea488e3          	beq	s1,a0,80001758 <wakeup+0x34>
      acquire(&p->lock);
    8000176c:	8526                	mv	a0,s1
    8000176e:	00005097          	auipc	ra,0x5
    80001772:	ba8080e7          	jalr	-1112(ra) # 80006316 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001776:	4c9c                	lw	a5,24(s1)
    80001778:	fd379be3          	bne	a5,s3,8000174e <wakeup+0x2a>
    8000177c:	709c                	ld	a5,32(s1)
    8000177e:	fd4798e3          	bne	a5,s4,8000174e <wakeup+0x2a>
        p->state = RUNNABLE;
    80001782:	0154ac23          	sw	s5,24(s1)
    80001786:	b7e1                	j	8000174e <wakeup+0x2a>
    }
  }
}
    80001788:	70e2                	ld	ra,56(sp)
    8000178a:	7442                	ld	s0,48(sp)
    8000178c:	74a2                	ld	s1,40(sp)
    8000178e:	7902                	ld	s2,32(sp)
    80001790:	69e2                	ld	s3,24(sp)
    80001792:	6a42                	ld	s4,16(sp)
    80001794:	6aa2                	ld	s5,8(sp)
    80001796:	6121                	addi	sp,sp,64
    80001798:	8082                	ret

000000008000179a <reparent>:
{
    8000179a:	7179                	addi	sp,sp,-48
    8000179c:	f406                	sd	ra,40(sp)
    8000179e:	f022                	sd	s0,32(sp)
    800017a0:	ec26                	sd	s1,24(sp)
    800017a2:	e84a                	sd	s2,16(sp)
    800017a4:	e44e                	sd	s3,8(sp)
    800017a6:	e052                	sd	s4,0(sp)
    800017a8:	1800                	addi	s0,sp,48
    800017aa:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017ac:	0000b497          	auipc	s1,0xb
    800017b0:	cd448493          	addi	s1,s1,-812 # 8000c480 <proc>
      pp->parent = initproc;
    800017b4:	0000ba17          	auipc	s4,0xb
    800017b8:	85ca0a13          	addi	s4,s4,-1956 # 8000c010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017bc:	00011997          	auipc	s3,0x11
    800017c0:	8c498993          	addi	s3,s3,-1852 # 80012080 <tickslock>
    800017c4:	a029                	j	800017ce <reparent+0x34>
    800017c6:	17048493          	addi	s1,s1,368
    800017ca:	01348d63          	beq	s1,s3,800017e4 <reparent+0x4a>
    if(pp->parent == p){
    800017ce:	7c9c                	ld	a5,56(s1)
    800017d0:	ff279be3          	bne	a5,s2,800017c6 <reparent+0x2c>
      pp->parent = initproc;
    800017d4:	000a3503          	ld	a0,0(s4)
    800017d8:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017da:	00000097          	auipc	ra,0x0
    800017de:	f4a080e7          	jalr	-182(ra) # 80001724 <wakeup>
    800017e2:	b7d5                	j	800017c6 <reparent+0x2c>
}
    800017e4:	70a2                	ld	ra,40(sp)
    800017e6:	7402                	ld	s0,32(sp)
    800017e8:	64e2                	ld	s1,24(sp)
    800017ea:	6942                	ld	s2,16(sp)
    800017ec:	69a2                	ld	s3,8(sp)
    800017ee:	6a02                	ld	s4,0(sp)
    800017f0:	6145                	addi	sp,sp,48
    800017f2:	8082                	ret

00000000800017f4 <exit>:
{
    800017f4:	7179                	addi	sp,sp,-48
    800017f6:	f406                	sd	ra,40(sp)
    800017f8:	f022                	sd	s0,32(sp)
    800017fa:	ec26                	sd	s1,24(sp)
    800017fc:	e84a                	sd	s2,16(sp)
    800017fe:	e44e                	sd	s3,8(sp)
    80001800:	e052                	sd	s4,0(sp)
    80001802:	1800                	addi	s0,sp,48
    80001804:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001806:	fffff097          	auipc	ra,0xfffff
    8000180a:	6c0080e7          	jalr	1728(ra) # 80000ec6 <myproc>
    8000180e:	89aa                	mv	s3,a0
  if(p == initproc)
    80001810:	0000b797          	auipc	a5,0xb
    80001814:	8007b783          	ld	a5,-2048(a5) # 8000c010 <initproc>
    80001818:	0d050493          	addi	s1,a0,208
    8000181c:	15050913          	addi	s2,a0,336
    80001820:	02a79363          	bne	a5,a0,80001846 <exit+0x52>
    panic("init exiting");
    80001824:	00007517          	auipc	a0,0x7
    80001828:	9bc50513          	addi	a0,a0,-1604 # 800081e0 <etext+0x1e0>
    8000182c:	00004097          	auipc	ra,0x4
    80001830:	570080e7          	jalr	1392(ra) # 80005d9c <panic>
      fileclose(f);
    80001834:	00002097          	auipc	ra,0x2
    80001838:	296080e7          	jalr	662(ra) # 80003aca <fileclose>
      p->ofile[fd] = 0;
    8000183c:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001840:	04a1                	addi	s1,s1,8
    80001842:	01248563          	beq	s1,s2,8000184c <exit+0x58>
    if(p->ofile[fd]){
    80001846:	6088                	ld	a0,0(s1)
    80001848:	f575                	bnez	a0,80001834 <exit+0x40>
    8000184a:	bfdd                	j	80001840 <exit+0x4c>
  begin_op();
    8000184c:	00002097          	auipc	ra,0x2
    80001850:	db4080e7          	jalr	-588(ra) # 80003600 <begin_op>
  iput(p->cwd);
    80001854:	1509b503          	ld	a0,336(s3)
    80001858:	00001097          	auipc	ra,0x1
    8000185c:	594080e7          	jalr	1428(ra) # 80002dec <iput>
  end_op();
    80001860:	00002097          	auipc	ra,0x2
    80001864:	e1a080e7          	jalr	-486(ra) # 8000367a <end_op>
  p->cwd = 0;
    80001868:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000186c:	0000a497          	auipc	s1,0xa
    80001870:	7fc48493          	addi	s1,s1,2044 # 8000c068 <wait_lock>
    80001874:	8526                	mv	a0,s1
    80001876:	00005097          	auipc	ra,0x5
    8000187a:	aa0080e7          	jalr	-1376(ra) # 80006316 <acquire>
  reparent(p);
    8000187e:	854e                	mv	a0,s3
    80001880:	00000097          	auipc	ra,0x0
    80001884:	f1a080e7          	jalr	-230(ra) # 8000179a <reparent>
  wakeup(p->parent);
    80001888:	0389b503          	ld	a0,56(s3)
    8000188c:	00000097          	auipc	ra,0x0
    80001890:	e98080e7          	jalr	-360(ra) # 80001724 <wakeup>
  acquire(&p->lock);
    80001894:	854e                	mv	a0,s3
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	a80080e7          	jalr	-1408(ra) # 80006316 <acquire>
  p->xstate = status;
    8000189e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800018a2:	4795                	li	a5,5
    800018a4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800018a8:	8526                	mv	a0,s1
    800018aa:	00005097          	auipc	ra,0x5
    800018ae:	b20080e7          	jalr	-1248(ra) # 800063ca <release>
  sched();
    800018b2:	00000097          	auipc	ra,0x0
    800018b6:	bd4080e7          	jalr	-1068(ra) # 80001486 <sched>
  panic("zombie exit");
    800018ba:	00007517          	auipc	a0,0x7
    800018be:	93650513          	addi	a0,a0,-1738 # 800081f0 <etext+0x1f0>
    800018c2:	00004097          	auipc	ra,0x4
    800018c6:	4da080e7          	jalr	1242(ra) # 80005d9c <panic>

00000000800018ca <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800018ca:	7179                	addi	sp,sp,-48
    800018cc:	f406                	sd	ra,40(sp)
    800018ce:	f022                	sd	s0,32(sp)
    800018d0:	ec26                	sd	s1,24(sp)
    800018d2:	e84a                	sd	s2,16(sp)
    800018d4:	e44e                	sd	s3,8(sp)
    800018d6:	1800                	addi	s0,sp,48
    800018d8:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018da:	0000b497          	auipc	s1,0xb
    800018de:	ba648493          	addi	s1,s1,-1114 # 8000c480 <proc>
    800018e2:	00010997          	auipc	s3,0x10
    800018e6:	79e98993          	addi	s3,s3,1950 # 80012080 <tickslock>
    acquire(&p->lock);
    800018ea:	8526                	mv	a0,s1
    800018ec:	00005097          	auipc	ra,0x5
    800018f0:	a2a080e7          	jalr	-1494(ra) # 80006316 <acquire>
    if(p->pid == pid){
    800018f4:	589c                	lw	a5,48(s1)
    800018f6:	01278d63          	beq	a5,s2,80001910 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018fa:	8526                	mv	a0,s1
    800018fc:	00005097          	auipc	ra,0x5
    80001900:	ace080e7          	jalr	-1330(ra) # 800063ca <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001904:	17048493          	addi	s1,s1,368
    80001908:	ff3491e3          	bne	s1,s3,800018ea <kill+0x20>
  }
  return -1;
    8000190c:	557d                	li	a0,-1
    8000190e:	a829                	j	80001928 <kill+0x5e>
      p->killed = 1;
    80001910:	4785                	li	a5,1
    80001912:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001914:	4c98                	lw	a4,24(s1)
    80001916:	4789                	li	a5,2
    80001918:	00f70f63          	beq	a4,a5,80001936 <kill+0x6c>
      release(&p->lock);
    8000191c:	8526                	mv	a0,s1
    8000191e:	00005097          	auipc	ra,0x5
    80001922:	aac080e7          	jalr	-1364(ra) # 800063ca <release>
      return 0;
    80001926:	4501                	li	a0,0
}
    80001928:	70a2                	ld	ra,40(sp)
    8000192a:	7402                	ld	s0,32(sp)
    8000192c:	64e2                	ld	s1,24(sp)
    8000192e:	6942                	ld	s2,16(sp)
    80001930:	69a2                	ld	s3,8(sp)
    80001932:	6145                	addi	sp,sp,48
    80001934:	8082                	ret
        p->state = RUNNABLE;
    80001936:	478d                	li	a5,3
    80001938:	cc9c                	sw	a5,24(s1)
    8000193a:	b7cd                	j	8000191c <kill+0x52>

000000008000193c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000193c:	7179                	addi	sp,sp,-48
    8000193e:	f406                	sd	ra,40(sp)
    80001940:	f022                	sd	s0,32(sp)
    80001942:	ec26                	sd	s1,24(sp)
    80001944:	e84a                	sd	s2,16(sp)
    80001946:	e44e                	sd	s3,8(sp)
    80001948:	e052                	sd	s4,0(sp)
    8000194a:	1800                	addi	s0,sp,48
    8000194c:	84aa                	mv	s1,a0
    8000194e:	892e                	mv	s2,a1
    80001950:	89b2                	mv	s3,a2
    80001952:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001954:	fffff097          	auipc	ra,0xfffff
    80001958:	572080e7          	jalr	1394(ra) # 80000ec6 <myproc>
  if(user_dst){
    8000195c:	c08d                	beqz	s1,8000197e <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000195e:	86d2                	mv	a3,s4
    80001960:	864e                	mv	a2,s3
    80001962:	85ca                	mv	a1,s2
    80001964:	6928                	ld	a0,80(a0)
    80001966:	fffff097          	auipc	ra,0xfffff
    8000196a:	1fc080e7          	jalr	508(ra) # 80000b62 <copyout>
  } else {
    memmove((char *)dst, src, len);
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
    memmove((char *)dst, src, len);
    8000197e:	000a061b          	sext.w	a2,s4
    80001982:	85ce                	mv	a1,s3
    80001984:	854a                	mv	a0,s2
    80001986:	fffff097          	auipc	ra,0xfffff
    8000198a:	89a080e7          	jalr	-1894(ra) # 80000220 <memmove>
    return 0;
    8000198e:	8526                	mv	a0,s1
    80001990:	bff9                	j	8000196e <either_copyout+0x32>

0000000080001992 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001992:	7179                	addi	sp,sp,-48
    80001994:	f406                	sd	ra,40(sp)
    80001996:	f022                	sd	s0,32(sp)
    80001998:	ec26                	sd	s1,24(sp)
    8000199a:	e84a                	sd	s2,16(sp)
    8000199c:	e44e                	sd	s3,8(sp)
    8000199e:	e052                	sd	s4,0(sp)
    800019a0:	1800                	addi	s0,sp,48
    800019a2:	892a                	mv	s2,a0
    800019a4:	84ae                	mv	s1,a1
    800019a6:	89b2                	mv	s3,a2
    800019a8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019aa:	fffff097          	auipc	ra,0xfffff
    800019ae:	51c080e7          	jalr	1308(ra) # 80000ec6 <myproc>
  if(user_src){
    800019b2:	c08d                	beqz	s1,800019d4 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019b4:	86d2                	mv	a3,s4
    800019b6:	864e                	mv	a2,s3
    800019b8:	85ca                	mv	a1,s2
    800019ba:	6928                	ld	a0,80(a0)
    800019bc:	fffff097          	auipc	ra,0xfffff
    800019c0:	232080e7          	jalr	562(ra) # 80000bee <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019c4:	70a2                	ld	ra,40(sp)
    800019c6:	7402                	ld	s0,32(sp)
    800019c8:	64e2                	ld	s1,24(sp)
    800019ca:	6942                	ld	s2,16(sp)
    800019cc:	69a2                	ld	s3,8(sp)
    800019ce:	6a02                	ld	s4,0(sp)
    800019d0:	6145                	addi	sp,sp,48
    800019d2:	8082                	ret
    memmove(dst, (char*)src, len);
    800019d4:	000a061b          	sext.w	a2,s4
    800019d8:	85ce                	mv	a1,s3
    800019da:	854a                	mv	a0,s2
    800019dc:	fffff097          	auipc	ra,0xfffff
    800019e0:	844080e7          	jalr	-1980(ra) # 80000220 <memmove>
    return 0;
    800019e4:	8526                	mv	a0,s1
    800019e6:	bff9                	j	800019c4 <either_copyin+0x32>

00000000800019e8 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019e8:	715d                	addi	sp,sp,-80
    800019ea:	e486                	sd	ra,72(sp)
    800019ec:	e0a2                	sd	s0,64(sp)
    800019ee:	fc26                	sd	s1,56(sp)
    800019f0:	f84a                	sd	s2,48(sp)
    800019f2:	f44e                	sd	s3,40(sp)
    800019f4:	f052                	sd	s4,32(sp)
    800019f6:	ec56                	sd	s5,24(sp)
    800019f8:	e85a                	sd	s6,16(sp)
    800019fa:	e45e                	sd	s7,8(sp)
    800019fc:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019fe:	00006517          	auipc	a0,0x6
    80001a02:	61a50513          	addi	a0,a0,1562 # 80008018 <etext+0x18>
    80001a06:	00004097          	auipc	ra,0x4
    80001a0a:	3e0080e7          	jalr	992(ra) # 80005de6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a0e:	0000b497          	auipc	s1,0xb
    80001a12:	bca48493          	addi	s1,s1,-1078 # 8000c5d8 <proc+0x158>
    80001a16:	00010917          	auipc	s2,0x10
    80001a1a:	7c290913          	addi	s2,s2,1986 # 800121d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a1e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a20:	00006997          	auipc	s3,0x6
    80001a24:	7e098993          	addi	s3,s3,2016 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001a28:	00006a97          	auipc	s5,0x6
    80001a2c:	7e0a8a93          	addi	s5,s5,2016 # 80008208 <etext+0x208>
    printf("\n");
    80001a30:	00006a17          	auipc	s4,0x6
    80001a34:	5e8a0a13          	addi	s4,s4,1512 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a38:	00007b97          	auipc	s7,0x7
    80001a3c:	d80b8b93          	addi	s7,s7,-640 # 800087b8 <states.0>
    80001a40:	a00d                	j	80001a62 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a42:	ed86a583          	lw	a1,-296(a3)
    80001a46:	8556                	mv	a0,s5
    80001a48:	00004097          	auipc	ra,0x4
    80001a4c:	39e080e7          	jalr	926(ra) # 80005de6 <printf>
    printf("\n");
    80001a50:	8552                	mv	a0,s4
    80001a52:	00004097          	auipc	ra,0x4
    80001a56:	394080e7          	jalr	916(ra) # 80005de6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a5a:	17048493          	addi	s1,s1,368
    80001a5e:	03248263          	beq	s1,s2,80001a82 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a62:	86a6                	mv	a3,s1
    80001a64:	ec04a783          	lw	a5,-320(s1)
    80001a68:	dbed                	beqz	a5,80001a5a <procdump+0x72>
      state = "???";
    80001a6a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a6c:	fcfb6be3          	bltu	s6,a5,80001a42 <procdump+0x5a>
    80001a70:	02079713          	slli	a4,a5,0x20
    80001a74:	01d75793          	srli	a5,a4,0x1d
    80001a78:	97de                	add	a5,a5,s7
    80001a7a:	6390                	ld	a2,0(a5)
    80001a7c:	f279                	bnez	a2,80001a42 <procdump+0x5a>
      state = "???";
    80001a7e:	864e                	mv	a2,s3
    80001a80:	b7c9                	j	80001a42 <procdump+0x5a>
  }
}
    80001a82:	60a6                	ld	ra,72(sp)
    80001a84:	6406                	ld	s0,64(sp)
    80001a86:	74e2                	ld	s1,56(sp)
    80001a88:	7942                	ld	s2,48(sp)
    80001a8a:	79a2                	ld	s3,40(sp)
    80001a8c:	7a02                	ld	s4,32(sp)
    80001a8e:	6ae2                	ld	s5,24(sp)
    80001a90:	6b42                	ld	s6,16(sp)
    80001a92:	6ba2                	ld	s7,8(sp)
    80001a94:	6161                	addi	sp,sp,80
    80001a96:	8082                	ret

0000000080001a98 <acquire_nproc>:

uint64 acquire_nproc(){
    80001a98:	7179                	addi	sp,sp,-48
    80001a9a:	f406                	sd	ra,40(sp)
    80001a9c:	f022                	sd	s0,32(sp)
    80001a9e:	ec26                	sd	s1,24(sp)
    80001aa0:	e84a                	sd	s2,16(sp)
    80001aa2:	e44e                	sd	s3,8(sp)
    80001aa4:	1800                	addi	s0,sp,48
  struct proc *p;
  int cnt = 0;
    80001aa6:	4901                	li	s2,0

  for(p=proc;p<&proc[NPROC];p++)
    80001aa8:	0000b497          	auipc	s1,0xb
    80001aac:	9d848493          	addi	s1,s1,-1576 # 8000c480 <proc>
    80001ab0:	00010997          	auipc	s3,0x10
    80001ab4:	5d098993          	addi	s3,s3,1488 # 80012080 <tickslock>
    80001ab8:	a811                	j	80001acc <acquire_nproc+0x34>
  {
    acquire(&p->lock);
    if(p->state != UNUSED){
      cnt++;
    }
    release(&p->lock);
    80001aba:	8526                	mv	a0,s1
    80001abc:	00005097          	auipc	ra,0x5
    80001ac0:	90e080e7          	jalr	-1778(ra) # 800063ca <release>
  for(p=proc;p<&proc[NPROC];p++)
    80001ac4:	17048493          	addi	s1,s1,368
    80001ac8:	01348b63          	beq	s1,s3,80001ade <acquire_nproc+0x46>
    acquire(&p->lock);
    80001acc:	8526                	mv	a0,s1
    80001ace:	00005097          	auipc	ra,0x5
    80001ad2:	848080e7          	jalr	-1976(ra) # 80006316 <acquire>
    if(p->state != UNUSED){
    80001ad6:	4c9c                	lw	a5,24(s1)
    80001ad8:	d3ed                	beqz	a5,80001aba <acquire_nproc+0x22>
      cnt++;
    80001ada:	2905                	addiw	s2,s2,1
    80001adc:	bff9                	j	80001aba <acquire_nproc+0x22>
  }
  return cnt;
    80001ade:	854a                	mv	a0,s2
    80001ae0:	70a2                	ld	ra,40(sp)
    80001ae2:	7402                	ld	s0,32(sp)
    80001ae4:	64e2                	ld	s1,24(sp)
    80001ae6:	6942                	ld	s2,16(sp)
    80001ae8:	69a2                	ld	s3,8(sp)
    80001aea:	6145                	addi	sp,sp,48
    80001aec:	8082                	ret

0000000080001aee <swtch>:
    80001aee:	00153023          	sd	ra,0(a0)
    80001af2:	00253423          	sd	sp,8(a0)
    80001af6:	e900                	sd	s0,16(a0)
    80001af8:	ed04                	sd	s1,24(a0)
    80001afa:	03253023          	sd	s2,32(a0)
    80001afe:	03353423          	sd	s3,40(a0)
    80001b02:	03453823          	sd	s4,48(a0)
    80001b06:	03553c23          	sd	s5,56(a0)
    80001b0a:	05653023          	sd	s6,64(a0)
    80001b0e:	05753423          	sd	s7,72(a0)
    80001b12:	05853823          	sd	s8,80(a0)
    80001b16:	05953c23          	sd	s9,88(a0)
    80001b1a:	07a53023          	sd	s10,96(a0)
    80001b1e:	07b53423          	sd	s11,104(a0)
    80001b22:	0005b083          	ld	ra,0(a1)
    80001b26:	0085b103          	ld	sp,8(a1)
    80001b2a:	6980                	ld	s0,16(a1)
    80001b2c:	6d84                	ld	s1,24(a1)
    80001b2e:	0205b903          	ld	s2,32(a1)
    80001b32:	0285b983          	ld	s3,40(a1)
    80001b36:	0305ba03          	ld	s4,48(a1)
    80001b3a:	0385ba83          	ld	s5,56(a1)
    80001b3e:	0405bb03          	ld	s6,64(a1)
    80001b42:	0485bb83          	ld	s7,72(a1)
    80001b46:	0505bc03          	ld	s8,80(a1)
    80001b4a:	0585bc83          	ld	s9,88(a1)
    80001b4e:	0605bd03          	ld	s10,96(a1)
    80001b52:	0685bd83          	ld	s11,104(a1)
    80001b56:	8082                	ret

0000000080001b58 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b58:	1141                	addi	sp,sp,-16
    80001b5a:	e406                	sd	ra,8(sp)
    80001b5c:	e022                	sd	s0,0(sp)
    80001b5e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b60:	00006597          	auipc	a1,0x6
    80001b64:	6e058593          	addi	a1,a1,1760 # 80008240 <etext+0x240>
    80001b68:	00010517          	auipc	a0,0x10
    80001b6c:	51850513          	addi	a0,a0,1304 # 80012080 <tickslock>
    80001b70:	00004097          	auipc	ra,0x4
    80001b74:	716080e7          	jalr	1814(ra) # 80006286 <initlock>
}
    80001b78:	60a2                	ld	ra,8(sp)
    80001b7a:	6402                	ld	s0,0(sp)
    80001b7c:	0141                	addi	sp,sp,16
    80001b7e:	8082                	ret

0000000080001b80 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b80:	1141                	addi	sp,sp,-16
    80001b82:	e422                	sd	s0,8(sp)
    80001b84:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b86:	00003797          	auipc	a5,0x3
    80001b8a:	62a78793          	addi	a5,a5,1578 # 800051b0 <kernelvec>
    80001b8e:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b92:	6422                	ld	s0,8(sp)
    80001b94:	0141                	addi	sp,sp,16
    80001b96:	8082                	ret

0000000080001b98 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b98:	1141                	addi	sp,sp,-16
    80001b9a:	e406                	sd	ra,8(sp)
    80001b9c:	e022                	sd	s0,0(sp)
    80001b9e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ba0:	fffff097          	auipc	ra,0xfffff
    80001ba4:	326080e7          	jalr	806(ra) # 80000ec6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ba8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001bac:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bae:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001bb2:	00005697          	auipc	a3,0x5
    80001bb6:	44e68693          	addi	a3,a3,1102 # 80007000 <_trampoline>
    80001bba:	00005717          	auipc	a4,0x5
    80001bbe:	44670713          	addi	a4,a4,1094 # 80007000 <_trampoline>
    80001bc2:	8f15                	sub	a4,a4,a3
    80001bc4:	040007b7          	lui	a5,0x4000
    80001bc8:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001bca:	07b2                	slli	a5,a5,0xc
    80001bcc:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bce:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bd2:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bd4:	18002673          	csrr	a2,satp
    80001bd8:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bda:	6d30                	ld	a2,88(a0)
    80001bdc:	6138                	ld	a4,64(a0)
    80001bde:	6585                	lui	a1,0x1
    80001be0:	972e                	add	a4,a4,a1
    80001be2:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001be4:	6d38                	ld	a4,88(a0)
    80001be6:	00000617          	auipc	a2,0x0
    80001bea:	14060613          	addi	a2,a2,320 # 80001d26 <usertrap>
    80001bee:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bf0:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bf2:	8612                	mv	a2,tp
    80001bf4:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bf6:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bfa:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bfe:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c02:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c06:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c08:	6f18                	ld	a4,24(a4)
    80001c0a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c0e:	692c                	ld	a1,80(a0)
    80001c10:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c12:	00005717          	auipc	a4,0x5
    80001c16:	47e70713          	addi	a4,a4,1150 # 80007090 <userret>
    80001c1a:	8f15                	sub	a4,a4,a3
    80001c1c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001c1e:	577d                	li	a4,-1
    80001c20:	177e                	slli	a4,a4,0x3f
    80001c22:	8dd9                	or	a1,a1,a4
    80001c24:	02000537          	lui	a0,0x2000
    80001c28:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001c2a:	0536                	slli	a0,a0,0xd
    80001c2c:	9782                	jalr	a5
}
    80001c2e:	60a2                	ld	ra,8(sp)
    80001c30:	6402                	ld	s0,0(sp)
    80001c32:	0141                	addi	sp,sp,16
    80001c34:	8082                	ret

0000000080001c36 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c36:	1101                	addi	sp,sp,-32
    80001c38:	ec06                	sd	ra,24(sp)
    80001c3a:	e822                	sd	s0,16(sp)
    80001c3c:	e426                	sd	s1,8(sp)
    80001c3e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c40:	00010497          	auipc	s1,0x10
    80001c44:	44048493          	addi	s1,s1,1088 # 80012080 <tickslock>
    80001c48:	8526                	mv	a0,s1
    80001c4a:	00004097          	auipc	ra,0x4
    80001c4e:	6cc080e7          	jalr	1740(ra) # 80006316 <acquire>
  ticks++;
    80001c52:	0000a517          	auipc	a0,0xa
    80001c56:	3c650513          	addi	a0,a0,966 # 8000c018 <ticks>
    80001c5a:	411c                	lw	a5,0(a0)
    80001c5c:	2785                	addiw	a5,a5,1
    80001c5e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c60:	00000097          	auipc	ra,0x0
    80001c64:	ac4080e7          	jalr	-1340(ra) # 80001724 <wakeup>
  release(&tickslock);
    80001c68:	8526                	mv	a0,s1
    80001c6a:	00004097          	auipc	ra,0x4
    80001c6e:	760080e7          	jalr	1888(ra) # 800063ca <release>
}
    80001c72:	60e2                	ld	ra,24(sp)
    80001c74:	6442                	ld	s0,16(sp)
    80001c76:	64a2                	ld	s1,8(sp)
    80001c78:	6105                	addi	sp,sp,32
    80001c7a:	8082                	ret

0000000080001c7c <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c7c:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c80:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001c82:	0a07d163          	bgez	a5,80001d24 <devintr+0xa8>
{
    80001c86:	1101                	addi	sp,sp,-32
    80001c88:	ec06                	sd	ra,24(sp)
    80001c8a:	e822                	sd	s0,16(sp)
    80001c8c:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001c8e:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001c92:	46a5                	li	a3,9
    80001c94:	00d70c63          	beq	a4,a3,80001cac <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001c98:	577d                	li	a4,-1
    80001c9a:	177e                	slli	a4,a4,0x3f
    80001c9c:	0705                	addi	a4,a4,1
    return 0;
    80001c9e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001ca0:	06e78163          	beq	a5,a4,80001d02 <devintr+0x86>
  }
}
    80001ca4:	60e2                	ld	ra,24(sp)
    80001ca6:	6442                	ld	s0,16(sp)
    80001ca8:	6105                	addi	sp,sp,32
    80001caa:	8082                	ret
    80001cac:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001cae:	00003097          	auipc	ra,0x3
    80001cb2:	60e080e7          	jalr	1550(ra) # 800052bc <plic_claim>
    80001cb6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001cb8:	47a9                	li	a5,10
    80001cba:	00f50963          	beq	a0,a5,80001ccc <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001cbe:	4785                	li	a5,1
    80001cc0:	00f50b63          	beq	a0,a5,80001cd6 <devintr+0x5a>
    return 1;
    80001cc4:	4505                	li	a0,1
    } else if(irq){
    80001cc6:	ec89                	bnez	s1,80001ce0 <devintr+0x64>
    80001cc8:	64a2                	ld	s1,8(sp)
    80001cca:	bfe9                	j	80001ca4 <devintr+0x28>
      uartintr();
    80001ccc:	00004097          	auipc	ra,0x4
    80001cd0:	56a080e7          	jalr	1386(ra) # 80006236 <uartintr>
    if(irq)
    80001cd4:	a839                	j	80001cf2 <devintr+0x76>
      virtio_disk_intr();
    80001cd6:	00004097          	auipc	ra,0x4
    80001cda:	aba080e7          	jalr	-1350(ra) # 80005790 <virtio_disk_intr>
    if(irq)
    80001cde:	a811                	j	80001cf2 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001ce0:	85a6                	mv	a1,s1
    80001ce2:	00006517          	auipc	a0,0x6
    80001ce6:	56650513          	addi	a0,a0,1382 # 80008248 <etext+0x248>
    80001cea:	00004097          	auipc	ra,0x4
    80001cee:	0fc080e7          	jalr	252(ra) # 80005de6 <printf>
      plic_complete(irq);
    80001cf2:	8526                	mv	a0,s1
    80001cf4:	00003097          	auipc	ra,0x3
    80001cf8:	5ec080e7          	jalr	1516(ra) # 800052e0 <plic_complete>
    return 1;
    80001cfc:	4505                	li	a0,1
    80001cfe:	64a2                	ld	s1,8(sp)
    80001d00:	b755                	j	80001ca4 <devintr+0x28>
    if(cpuid() == 0){
    80001d02:	fffff097          	auipc	ra,0xfffff
    80001d06:	198080e7          	jalr	408(ra) # 80000e9a <cpuid>
    80001d0a:	c901                	beqz	a0,80001d1a <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d0c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d10:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d12:	14479073          	csrw	sip,a5
    return 2;
    80001d16:	4509                	li	a0,2
    80001d18:	b771                	j	80001ca4 <devintr+0x28>
      clockintr();
    80001d1a:	00000097          	auipc	ra,0x0
    80001d1e:	f1c080e7          	jalr	-228(ra) # 80001c36 <clockintr>
    80001d22:	b7ed                	j	80001d0c <devintr+0x90>
}
    80001d24:	8082                	ret

0000000080001d26 <usertrap>:
{
    80001d26:	1101                	addi	sp,sp,-32
    80001d28:	ec06                	sd	ra,24(sp)
    80001d2a:	e822                	sd	s0,16(sp)
    80001d2c:	e426                	sd	s1,8(sp)
    80001d2e:	e04a                	sd	s2,0(sp)
    80001d30:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d32:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d36:	1007f793          	andi	a5,a5,256
    80001d3a:	e3ad                	bnez	a5,80001d9c <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d3c:	00003797          	auipc	a5,0x3
    80001d40:	47478793          	addi	a5,a5,1140 # 800051b0 <kernelvec>
    80001d44:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d48:	fffff097          	auipc	ra,0xfffff
    80001d4c:	17e080e7          	jalr	382(ra) # 80000ec6 <myproc>
    80001d50:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d52:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d54:	14102773          	csrr	a4,sepc
    80001d58:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d5a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d5e:	47a1                	li	a5,8
    80001d60:	04f71c63          	bne	a4,a5,80001db8 <usertrap+0x92>
    if(p->killed)
    80001d64:	551c                	lw	a5,40(a0)
    80001d66:	e3b9                	bnez	a5,80001dac <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d68:	6cb8                	ld	a4,88(s1)
    80001d6a:	6f1c                	ld	a5,24(a4)
    80001d6c:	0791                	addi	a5,a5,4
    80001d6e:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d70:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d74:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d78:	10079073          	csrw	sstatus,a5
    syscall();
    80001d7c:	00000097          	auipc	ra,0x0
    80001d80:	2e0080e7          	jalr	736(ra) # 8000205c <syscall>
  if(p->killed)
    80001d84:	549c                	lw	a5,40(s1)
    80001d86:	ebc1                	bnez	a5,80001e16 <usertrap+0xf0>
  usertrapret();
    80001d88:	00000097          	auipc	ra,0x0
    80001d8c:	e10080e7          	jalr	-496(ra) # 80001b98 <usertrapret>
}
    80001d90:	60e2                	ld	ra,24(sp)
    80001d92:	6442                	ld	s0,16(sp)
    80001d94:	64a2                	ld	s1,8(sp)
    80001d96:	6902                	ld	s2,0(sp)
    80001d98:	6105                	addi	sp,sp,32
    80001d9a:	8082                	ret
    panic("usertrap: not from user mode");
    80001d9c:	00006517          	auipc	a0,0x6
    80001da0:	4cc50513          	addi	a0,a0,1228 # 80008268 <etext+0x268>
    80001da4:	00004097          	auipc	ra,0x4
    80001da8:	ff8080e7          	jalr	-8(ra) # 80005d9c <panic>
      exit(-1);
    80001dac:	557d                	li	a0,-1
    80001dae:	00000097          	auipc	ra,0x0
    80001db2:	a46080e7          	jalr	-1466(ra) # 800017f4 <exit>
    80001db6:	bf4d                	j	80001d68 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001db8:	00000097          	auipc	ra,0x0
    80001dbc:	ec4080e7          	jalr	-316(ra) # 80001c7c <devintr>
    80001dc0:	892a                	mv	s2,a0
    80001dc2:	c501                	beqz	a0,80001dca <usertrap+0xa4>
  if(p->killed)
    80001dc4:	549c                	lw	a5,40(s1)
    80001dc6:	c3a1                	beqz	a5,80001e06 <usertrap+0xe0>
    80001dc8:	a815                	j	80001dfc <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dca:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001dce:	5890                	lw	a2,48(s1)
    80001dd0:	00006517          	auipc	a0,0x6
    80001dd4:	4b850513          	addi	a0,a0,1208 # 80008288 <etext+0x288>
    80001dd8:	00004097          	auipc	ra,0x4
    80001ddc:	00e080e7          	jalr	14(ra) # 80005de6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001de0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001de4:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001de8:	00006517          	auipc	a0,0x6
    80001dec:	4d050513          	addi	a0,a0,1232 # 800082b8 <etext+0x2b8>
    80001df0:	00004097          	auipc	ra,0x4
    80001df4:	ff6080e7          	jalr	-10(ra) # 80005de6 <printf>
    p->killed = 1;
    80001df8:	4785                	li	a5,1
    80001dfa:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001dfc:	557d                	li	a0,-1
    80001dfe:	00000097          	auipc	ra,0x0
    80001e02:	9f6080e7          	jalr	-1546(ra) # 800017f4 <exit>
  if(which_dev == 2)
    80001e06:	4789                	li	a5,2
    80001e08:	f8f910e3          	bne	s2,a5,80001d88 <usertrap+0x62>
    yield();
    80001e0c:	fffff097          	auipc	ra,0xfffff
    80001e10:	750080e7          	jalr	1872(ra) # 8000155c <yield>
    80001e14:	bf95                	j	80001d88 <usertrap+0x62>
  int which_dev = 0;
    80001e16:	4901                	li	s2,0
    80001e18:	b7d5                	j	80001dfc <usertrap+0xd6>

0000000080001e1a <kerneltrap>:
{
    80001e1a:	7179                	addi	sp,sp,-48
    80001e1c:	f406                	sd	ra,40(sp)
    80001e1e:	f022                	sd	s0,32(sp)
    80001e20:	ec26                	sd	s1,24(sp)
    80001e22:	e84a                	sd	s2,16(sp)
    80001e24:	e44e                	sd	s3,8(sp)
    80001e26:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e28:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e2c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e30:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e34:	1004f793          	andi	a5,s1,256
    80001e38:	cb85                	beqz	a5,80001e68 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e3a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e3e:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e40:	ef85                	bnez	a5,80001e78 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e42:	00000097          	auipc	ra,0x0
    80001e46:	e3a080e7          	jalr	-454(ra) # 80001c7c <devintr>
    80001e4a:	cd1d                	beqz	a0,80001e88 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e4c:	4789                	li	a5,2
    80001e4e:	06f50a63          	beq	a0,a5,80001ec2 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e52:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e56:	10049073          	csrw	sstatus,s1
}
    80001e5a:	70a2                	ld	ra,40(sp)
    80001e5c:	7402                	ld	s0,32(sp)
    80001e5e:	64e2                	ld	s1,24(sp)
    80001e60:	6942                	ld	s2,16(sp)
    80001e62:	69a2                	ld	s3,8(sp)
    80001e64:	6145                	addi	sp,sp,48
    80001e66:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e68:	00006517          	auipc	a0,0x6
    80001e6c:	47050513          	addi	a0,a0,1136 # 800082d8 <etext+0x2d8>
    80001e70:	00004097          	auipc	ra,0x4
    80001e74:	f2c080e7          	jalr	-212(ra) # 80005d9c <panic>
    panic("kerneltrap: interrupts enabled");
    80001e78:	00006517          	auipc	a0,0x6
    80001e7c:	48850513          	addi	a0,a0,1160 # 80008300 <etext+0x300>
    80001e80:	00004097          	auipc	ra,0x4
    80001e84:	f1c080e7          	jalr	-228(ra) # 80005d9c <panic>
    printf("scause %p\n", scause);
    80001e88:	85ce                	mv	a1,s3
    80001e8a:	00006517          	auipc	a0,0x6
    80001e8e:	49650513          	addi	a0,a0,1174 # 80008320 <etext+0x320>
    80001e92:	00004097          	auipc	ra,0x4
    80001e96:	f54080e7          	jalr	-172(ra) # 80005de6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e9a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e9e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ea2:	00006517          	auipc	a0,0x6
    80001ea6:	48e50513          	addi	a0,a0,1166 # 80008330 <etext+0x330>
    80001eaa:	00004097          	auipc	ra,0x4
    80001eae:	f3c080e7          	jalr	-196(ra) # 80005de6 <printf>
    panic("kerneltrap");
    80001eb2:	00006517          	auipc	a0,0x6
    80001eb6:	49650513          	addi	a0,a0,1174 # 80008348 <etext+0x348>
    80001eba:	00004097          	auipc	ra,0x4
    80001ebe:	ee2080e7          	jalr	-286(ra) # 80005d9c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ec2:	fffff097          	auipc	ra,0xfffff
    80001ec6:	004080e7          	jalr	4(ra) # 80000ec6 <myproc>
    80001eca:	d541                	beqz	a0,80001e52 <kerneltrap+0x38>
    80001ecc:	fffff097          	auipc	ra,0xfffff
    80001ed0:	ffa080e7          	jalr	-6(ra) # 80000ec6 <myproc>
    80001ed4:	4d18                	lw	a4,24(a0)
    80001ed6:	4791                	li	a5,4
    80001ed8:	f6f71de3          	bne	a4,a5,80001e52 <kerneltrap+0x38>
    yield();
    80001edc:	fffff097          	auipc	ra,0xfffff
    80001ee0:	680080e7          	jalr	1664(ra) # 8000155c <yield>
    80001ee4:	b7bd                	j	80001e52 <kerneltrap+0x38>

0000000080001ee6 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ee6:	1101                	addi	sp,sp,-32
    80001ee8:	ec06                	sd	ra,24(sp)
    80001eea:	e822                	sd	s0,16(sp)
    80001eec:	e426                	sd	s1,8(sp)
    80001eee:	1000                	addi	s0,sp,32
    80001ef0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ef2:	fffff097          	auipc	ra,0xfffff
    80001ef6:	fd4080e7          	jalr	-44(ra) # 80000ec6 <myproc>
  switch (n) {
    80001efa:	4795                	li	a5,5
    80001efc:	0497e163          	bltu	a5,s1,80001f3e <argraw+0x58>
    80001f00:	048a                	slli	s1,s1,0x2
    80001f02:	00007717          	auipc	a4,0x7
    80001f06:	8e670713          	addi	a4,a4,-1818 # 800087e8 <states.0+0x30>
    80001f0a:	94ba                	add	s1,s1,a4
    80001f0c:	409c                	lw	a5,0(s1)
    80001f0e:	97ba                	add	a5,a5,a4
    80001f10:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f12:	6d3c                	ld	a5,88(a0)
    80001f14:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f16:	60e2                	ld	ra,24(sp)
    80001f18:	6442                	ld	s0,16(sp)
    80001f1a:	64a2                	ld	s1,8(sp)
    80001f1c:	6105                	addi	sp,sp,32
    80001f1e:	8082                	ret
    return p->trapframe->a1;
    80001f20:	6d3c                	ld	a5,88(a0)
    80001f22:	7fa8                	ld	a0,120(a5)
    80001f24:	bfcd                	j	80001f16 <argraw+0x30>
    return p->trapframe->a2;
    80001f26:	6d3c                	ld	a5,88(a0)
    80001f28:	63c8                	ld	a0,128(a5)
    80001f2a:	b7f5                	j	80001f16 <argraw+0x30>
    return p->trapframe->a3;
    80001f2c:	6d3c                	ld	a5,88(a0)
    80001f2e:	67c8                	ld	a0,136(a5)
    80001f30:	b7dd                	j	80001f16 <argraw+0x30>
    return p->trapframe->a4;
    80001f32:	6d3c                	ld	a5,88(a0)
    80001f34:	6bc8                	ld	a0,144(a5)
    80001f36:	b7c5                	j	80001f16 <argraw+0x30>
    return p->trapframe->a5;
    80001f38:	6d3c                	ld	a5,88(a0)
    80001f3a:	6fc8                	ld	a0,152(a5)
    80001f3c:	bfe9                	j	80001f16 <argraw+0x30>
  panic("argraw");
    80001f3e:	00006517          	auipc	a0,0x6
    80001f42:	41a50513          	addi	a0,a0,1050 # 80008358 <etext+0x358>
    80001f46:	00004097          	auipc	ra,0x4
    80001f4a:	e56080e7          	jalr	-426(ra) # 80005d9c <panic>

0000000080001f4e <fetchaddr>:
{
    80001f4e:	1101                	addi	sp,sp,-32
    80001f50:	ec06                	sd	ra,24(sp)
    80001f52:	e822                	sd	s0,16(sp)
    80001f54:	e426                	sd	s1,8(sp)
    80001f56:	e04a                	sd	s2,0(sp)
    80001f58:	1000                	addi	s0,sp,32
    80001f5a:	84aa                	mv	s1,a0
    80001f5c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f5e:	fffff097          	auipc	ra,0xfffff
    80001f62:	f68080e7          	jalr	-152(ra) # 80000ec6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f66:	653c                	ld	a5,72(a0)
    80001f68:	02f4f863          	bgeu	s1,a5,80001f98 <fetchaddr+0x4a>
    80001f6c:	00848713          	addi	a4,s1,8
    80001f70:	02e7e663          	bltu	a5,a4,80001f9c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f74:	46a1                	li	a3,8
    80001f76:	8626                	mv	a2,s1
    80001f78:	85ca                	mv	a1,s2
    80001f7a:	6928                	ld	a0,80(a0)
    80001f7c:	fffff097          	auipc	ra,0xfffff
    80001f80:	c72080e7          	jalr	-910(ra) # 80000bee <copyin>
    80001f84:	00a03533          	snez	a0,a0
    80001f88:	40a00533          	neg	a0,a0
}
    80001f8c:	60e2                	ld	ra,24(sp)
    80001f8e:	6442                	ld	s0,16(sp)
    80001f90:	64a2                	ld	s1,8(sp)
    80001f92:	6902                	ld	s2,0(sp)
    80001f94:	6105                	addi	sp,sp,32
    80001f96:	8082                	ret
    return -1;
    80001f98:	557d                	li	a0,-1
    80001f9a:	bfcd                	j	80001f8c <fetchaddr+0x3e>
    80001f9c:	557d                	li	a0,-1
    80001f9e:	b7fd                	j	80001f8c <fetchaddr+0x3e>

0000000080001fa0 <fetchstr>:
{
    80001fa0:	7179                	addi	sp,sp,-48
    80001fa2:	f406                	sd	ra,40(sp)
    80001fa4:	f022                	sd	s0,32(sp)
    80001fa6:	ec26                	sd	s1,24(sp)
    80001fa8:	e84a                	sd	s2,16(sp)
    80001faa:	e44e                	sd	s3,8(sp)
    80001fac:	1800                	addi	s0,sp,48
    80001fae:	892a                	mv	s2,a0
    80001fb0:	84ae                	mv	s1,a1
    80001fb2:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fb4:	fffff097          	auipc	ra,0xfffff
    80001fb8:	f12080e7          	jalr	-238(ra) # 80000ec6 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001fbc:	86ce                	mv	a3,s3
    80001fbe:	864a                	mv	a2,s2
    80001fc0:	85a6                	mv	a1,s1
    80001fc2:	6928                	ld	a0,80(a0)
    80001fc4:	fffff097          	auipc	ra,0xfffff
    80001fc8:	cb8080e7          	jalr	-840(ra) # 80000c7c <copyinstr>
  if(err < 0)
    80001fcc:	00054763          	bltz	a0,80001fda <fetchstr+0x3a>
  return strlen(buf);
    80001fd0:	8526                	mv	a0,s1
    80001fd2:	ffffe097          	auipc	ra,0xffffe
    80001fd6:	366080e7          	jalr	870(ra) # 80000338 <strlen>
}
    80001fda:	70a2                	ld	ra,40(sp)
    80001fdc:	7402                	ld	s0,32(sp)
    80001fde:	64e2                	ld	s1,24(sp)
    80001fe0:	6942                	ld	s2,16(sp)
    80001fe2:	69a2                	ld	s3,8(sp)
    80001fe4:	6145                	addi	sp,sp,48
    80001fe6:	8082                	ret

0000000080001fe8 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001fe8:	1101                	addi	sp,sp,-32
    80001fea:	ec06                	sd	ra,24(sp)
    80001fec:	e822                	sd	s0,16(sp)
    80001fee:	e426                	sd	s1,8(sp)
    80001ff0:	1000                	addi	s0,sp,32
    80001ff2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001ff4:	00000097          	auipc	ra,0x0
    80001ff8:	ef2080e7          	jalr	-270(ra) # 80001ee6 <argraw>
    80001ffc:	c088                	sw	a0,0(s1)
  return 0;
}
    80001ffe:	4501                	li	a0,0
    80002000:	60e2                	ld	ra,24(sp)
    80002002:	6442                	ld	s0,16(sp)
    80002004:	64a2                	ld	s1,8(sp)
    80002006:	6105                	addi	sp,sp,32
    80002008:	8082                	ret

000000008000200a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    8000200a:	1101                	addi	sp,sp,-32
    8000200c:	ec06                	sd	ra,24(sp)
    8000200e:	e822                	sd	s0,16(sp)
    80002010:	e426                	sd	s1,8(sp)
    80002012:	1000                	addi	s0,sp,32
    80002014:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002016:	00000097          	auipc	ra,0x0
    8000201a:	ed0080e7          	jalr	-304(ra) # 80001ee6 <argraw>
    8000201e:	e088                	sd	a0,0(s1)
  return 0;
}
    80002020:	4501                	li	a0,0
    80002022:	60e2                	ld	ra,24(sp)
    80002024:	6442                	ld	s0,16(sp)
    80002026:	64a2                	ld	s1,8(sp)
    80002028:	6105                	addi	sp,sp,32
    8000202a:	8082                	ret

000000008000202c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000202c:	1101                	addi	sp,sp,-32
    8000202e:	ec06                	sd	ra,24(sp)
    80002030:	e822                	sd	s0,16(sp)
    80002032:	e426                	sd	s1,8(sp)
    80002034:	e04a                	sd	s2,0(sp)
    80002036:	1000                	addi	s0,sp,32
    80002038:	84ae                	mv	s1,a1
    8000203a:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000203c:	00000097          	auipc	ra,0x0
    80002040:	eaa080e7          	jalr	-342(ra) # 80001ee6 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002044:	864a                	mv	a2,s2
    80002046:	85a6                	mv	a1,s1
    80002048:	00000097          	auipc	ra,0x0
    8000204c:	f58080e7          	jalr	-168(ra) # 80001fa0 <fetchstr>
}
    80002050:	60e2                	ld	ra,24(sp)
    80002052:	6442                	ld	s0,16(sp)
    80002054:	64a2                	ld	s1,8(sp)
    80002056:	6902                	ld	s2,0(sp)
    80002058:	6105                	addi	sp,sp,32
    8000205a:	8082                	ret

000000008000205c <syscall>:
  "mknod", "unlink", "link", "mkdir", "close", "trace"
};

void
syscall(void)
{
    8000205c:	7179                	addi	sp,sp,-48
    8000205e:	f406                	sd	ra,40(sp)
    80002060:	f022                	sd	s0,32(sp)
    80002062:	ec26                	sd	s1,24(sp)
    80002064:	e84a                	sd	s2,16(sp)
    80002066:	e44e                	sd	s3,8(sp)
    80002068:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    8000206a:	fffff097          	auipc	ra,0xfffff
    8000206e:	e5c080e7          	jalr	-420(ra) # 80000ec6 <myproc>
    80002072:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002074:	05853903          	ld	s2,88(a0)
    80002078:	0a893783          	ld	a5,168(s2)
    8000207c:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002080:	37fd                	addiw	a5,a5,-1
    80002082:	4759                	li	a4,22
    80002084:	04f76863          	bltu	a4,a5,800020d4 <syscall+0x78>
    80002088:	00399713          	slli	a4,s3,0x3
    8000208c:	00006797          	auipc	a5,0x6
    80002090:	77478793          	addi	a5,a5,1908 # 80008800 <syscalls>
    80002094:	97ba                	add	a5,a5,a4
    80002096:	639c                	ld	a5,0(a5)
    80002098:	cf95                	beqz	a5,800020d4 <syscall+0x78>
    p->trapframe->a0 = syscalls[num]();
    8000209a:	9782                	jalr	a5
    8000209c:	06a93823          	sd	a0,112(s2)
    int trace_mask = p->trace_mask;
    if((trace_mask>>num) & 1){
    800020a0:	1684a783          	lw	a5,360(s1)
    800020a4:	4137d7bb          	sraw	a5,a5,s3
    800020a8:	8b85                	andi	a5,a5,1
    800020aa:	c7a1                	beqz	a5,800020f2 <syscall+0x96>
      printf("%d: syscall %s -> %d\n", p->pid,syscall_names[num-1], p->trapframe->a0);
    800020ac:	6cb8                	ld	a4,88(s1)
    800020ae:	39fd                	addiw	s3,s3,-1
    800020b0:	098e                	slli	s3,s3,0x3
    800020b2:	00006797          	auipc	a5,0x6
    800020b6:	74e78793          	addi	a5,a5,1870 # 80008800 <syscalls>
    800020ba:	97ce                	add	a5,a5,s3
    800020bc:	7b34                	ld	a3,112(a4)
    800020be:	63f0                	ld	a2,192(a5)
    800020c0:	588c                	lw	a1,48(s1)
    800020c2:	00006517          	auipc	a0,0x6
    800020c6:	29e50513          	addi	a0,a0,670 # 80008360 <etext+0x360>
    800020ca:	00004097          	auipc	ra,0x4
    800020ce:	d1c080e7          	jalr	-740(ra) # 80005de6 <printf>
    800020d2:	a005                	j	800020f2 <syscall+0x96>
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020d4:	86ce                	mv	a3,s3
    800020d6:	15848613          	addi	a2,s1,344
    800020da:	588c                	lw	a1,48(s1)
    800020dc:	00006517          	auipc	a0,0x6
    800020e0:	29c50513          	addi	a0,a0,668 # 80008378 <etext+0x378>
    800020e4:	00004097          	auipc	ra,0x4
    800020e8:	d02080e7          	jalr	-766(ra) # 80005de6 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020ec:	6cbc                	ld	a5,88(s1)
    800020ee:	577d                	li	a4,-1
    800020f0:	fbb8                	sd	a4,112(a5)
  }
}
    800020f2:	70a2                	ld	ra,40(sp)
    800020f4:	7402                	ld	s0,32(sp)
    800020f6:	64e2                	ld	s1,24(sp)
    800020f8:	6942                	ld	s2,16(sp)
    800020fa:	69a2                	ld	s3,8(sp)
    800020fc:	6145                	addi	sp,sp,48
    800020fe:	8082                	ret

0000000080002100 <sys_exit>:
uint64 acquire_nproc();
uint64 acquire_freemem();

uint64
sys_exit(void)
{
    80002100:	1101                	addi	sp,sp,-32
    80002102:	ec06                	sd	ra,24(sp)
    80002104:	e822                	sd	s0,16(sp)
    80002106:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002108:	fec40593          	addi	a1,s0,-20
    8000210c:	4501                	li	a0,0
    8000210e:	00000097          	auipc	ra,0x0
    80002112:	eda080e7          	jalr	-294(ra) # 80001fe8 <argint>
    return -1;
    80002116:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002118:	00054963          	bltz	a0,8000212a <sys_exit+0x2a>
  exit(n);
    8000211c:	fec42503          	lw	a0,-20(s0)
    80002120:	fffff097          	auipc	ra,0xfffff
    80002124:	6d4080e7          	jalr	1748(ra) # 800017f4 <exit>
  return 0;  // not reached
    80002128:	4781                	li	a5,0
}
    8000212a:	853e                	mv	a0,a5
    8000212c:	60e2                	ld	ra,24(sp)
    8000212e:	6442                	ld	s0,16(sp)
    80002130:	6105                	addi	sp,sp,32
    80002132:	8082                	ret

0000000080002134 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002134:	1141                	addi	sp,sp,-16
    80002136:	e406                	sd	ra,8(sp)
    80002138:	e022                	sd	s0,0(sp)
    8000213a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000213c:	fffff097          	auipc	ra,0xfffff
    80002140:	d8a080e7          	jalr	-630(ra) # 80000ec6 <myproc>
}
    80002144:	5908                	lw	a0,48(a0)
    80002146:	60a2                	ld	ra,8(sp)
    80002148:	6402                	ld	s0,0(sp)
    8000214a:	0141                	addi	sp,sp,16
    8000214c:	8082                	ret

000000008000214e <sys_fork>:

uint64
sys_fork(void)
{
    8000214e:	1141                	addi	sp,sp,-16
    80002150:	e406                	sd	ra,8(sp)
    80002152:	e022                	sd	s0,0(sp)
    80002154:	0800                	addi	s0,sp,16
  return fork();
    80002156:	fffff097          	auipc	ra,0xfffff
    8000215a:	146080e7          	jalr	326(ra) # 8000129c <fork>
}
    8000215e:	60a2                	ld	ra,8(sp)
    80002160:	6402                	ld	s0,0(sp)
    80002162:	0141                	addi	sp,sp,16
    80002164:	8082                	ret

0000000080002166 <sys_wait>:

uint64
sys_wait(void)
{
    80002166:	1101                	addi	sp,sp,-32
    80002168:	ec06                	sd	ra,24(sp)
    8000216a:	e822                	sd	s0,16(sp)
    8000216c:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000216e:	fe840593          	addi	a1,s0,-24
    80002172:	4501                	li	a0,0
    80002174:	00000097          	auipc	ra,0x0
    80002178:	e96080e7          	jalr	-362(ra) # 8000200a <argaddr>
    8000217c:	87aa                	mv	a5,a0
    return -1;
    8000217e:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002180:	0007c863          	bltz	a5,80002190 <sys_wait+0x2a>
  return wait(p);
    80002184:	fe843503          	ld	a0,-24(s0)
    80002188:	fffff097          	auipc	ra,0xfffff
    8000218c:	474080e7          	jalr	1140(ra) # 800015fc <wait>
}
    80002190:	60e2                	ld	ra,24(sp)
    80002192:	6442                	ld	s0,16(sp)
    80002194:	6105                	addi	sp,sp,32
    80002196:	8082                	ret

0000000080002198 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002198:	7179                	addi	sp,sp,-48
    8000219a:	f406                	sd	ra,40(sp)
    8000219c:	f022                	sd	s0,32(sp)
    8000219e:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800021a0:	fdc40593          	addi	a1,s0,-36
    800021a4:	4501                	li	a0,0
    800021a6:	00000097          	auipc	ra,0x0
    800021aa:	e42080e7          	jalr	-446(ra) # 80001fe8 <argint>
    800021ae:	87aa                	mv	a5,a0
    return -1;
    800021b0:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800021b2:	0207c263          	bltz	a5,800021d6 <sys_sbrk+0x3e>
    800021b6:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    800021b8:	fffff097          	auipc	ra,0xfffff
    800021bc:	d0e080e7          	jalr	-754(ra) # 80000ec6 <myproc>
    800021c0:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800021c2:	fdc42503          	lw	a0,-36(s0)
    800021c6:	fffff097          	auipc	ra,0xfffff
    800021ca:	05e080e7          	jalr	94(ra) # 80001224 <growproc>
    800021ce:	00054863          	bltz	a0,800021de <sys_sbrk+0x46>
    return -1;
  return addr;
    800021d2:	8526                	mv	a0,s1
    800021d4:	64e2                	ld	s1,24(sp)
}
    800021d6:	70a2                	ld	ra,40(sp)
    800021d8:	7402                	ld	s0,32(sp)
    800021da:	6145                	addi	sp,sp,48
    800021dc:	8082                	ret
    return -1;
    800021de:	557d                	li	a0,-1
    800021e0:	64e2                	ld	s1,24(sp)
    800021e2:	bfd5                	j	800021d6 <sys_sbrk+0x3e>

00000000800021e4 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021e4:	7139                	addi	sp,sp,-64
    800021e6:	fc06                	sd	ra,56(sp)
    800021e8:	f822                	sd	s0,48(sp)
    800021ea:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800021ec:	fcc40593          	addi	a1,s0,-52
    800021f0:	4501                	li	a0,0
    800021f2:	00000097          	auipc	ra,0x0
    800021f6:	df6080e7          	jalr	-522(ra) # 80001fe8 <argint>
    return -1;
    800021fa:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021fc:	06054b63          	bltz	a0,80002272 <sys_sleep+0x8e>
    80002200:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    80002202:	00010517          	auipc	a0,0x10
    80002206:	e7e50513          	addi	a0,a0,-386 # 80012080 <tickslock>
    8000220a:	00004097          	auipc	ra,0x4
    8000220e:	10c080e7          	jalr	268(ra) # 80006316 <acquire>
  ticks0 = ticks;
    80002212:	0000a917          	auipc	s2,0xa
    80002216:	e0692903          	lw	s2,-506(s2) # 8000c018 <ticks>
  while(ticks - ticks0 < n){
    8000221a:	fcc42783          	lw	a5,-52(s0)
    8000221e:	c3a1                	beqz	a5,8000225e <sys_sleep+0x7a>
    80002220:	f426                	sd	s1,40(sp)
    80002222:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002224:	00010997          	auipc	s3,0x10
    80002228:	e5c98993          	addi	s3,s3,-420 # 80012080 <tickslock>
    8000222c:	0000a497          	auipc	s1,0xa
    80002230:	dec48493          	addi	s1,s1,-532 # 8000c018 <ticks>
    if(myproc()->killed){
    80002234:	fffff097          	auipc	ra,0xfffff
    80002238:	c92080e7          	jalr	-878(ra) # 80000ec6 <myproc>
    8000223c:	551c                	lw	a5,40(a0)
    8000223e:	ef9d                	bnez	a5,8000227c <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002240:	85ce                	mv	a1,s3
    80002242:	8526                	mv	a0,s1
    80002244:	fffff097          	auipc	ra,0xfffff
    80002248:	354080e7          	jalr	852(ra) # 80001598 <sleep>
  while(ticks - ticks0 < n){
    8000224c:	409c                	lw	a5,0(s1)
    8000224e:	412787bb          	subw	a5,a5,s2
    80002252:	fcc42703          	lw	a4,-52(s0)
    80002256:	fce7efe3          	bltu	a5,a4,80002234 <sys_sleep+0x50>
    8000225a:	74a2                	ld	s1,40(sp)
    8000225c:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000225e:	00010517          	auipc	a0,0x10
    80002262:	e2250513          	addi	a0,a0,-478 # 80012080 <tickslock>
    80002266:	00004097          	auipc	ra,0x4
    8000226a:	164080e7          	jalr	356(ra) # 800063ca <release>
  return 0;
    8000226e:	4781                	li	a5,0
    80002270:	7902                	ld	s2,32(sp)
}
    80002272:	853e                	mv	a0,a5
    80002274:	70e2                	ld	ra,56(sp)
    80002276:	7442                	ld	s0,48(sp)
    80002278:	6121                	addi	sp,sp,64
    8000227a:	8082                	ret
      release(&tickslock);
    8000227c:	00010517          	auipc	a0,0x10
    80002280:	e0450513          	addi	a0,a0,-508 # 80012080 <tickslock>
    80002284:	00004097          	auipc	ra,0x4
    80002288:	146080e7          	jalr	326(ra) # 800063ca <release>
      return -1;
    8000228c:	57fd                	li	a5,-1
    8000228e:	74a2                	ld	s1,40(sp)
    80002290:	7902                	ld	s2,32(sp)
    80002292:	69e2                	ld	s3,24(sp)
    80002294:	bff9                	j	80002272 <sys_sleep+0x8e>

0000000080002296 <sys_kill>:

uint64
sys_kill(void)
{
    80002296:	1101                	addi	sp,sp,-32
    80002298:	ec06                	sd	ra,24(sp)
    8000229a:	e822                	sd	s0,16(sp)
    8000229c:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000229e:	fec40593          	addi	a1,s0,-20
    800022a2:	4501                	li	a0,0
    800022a4:	00000097          	auipc	ra,0x0
    800022a8:	d44080e7          	jalr	-700(ra) # 80001fe8 <argint>
    800022ac:	87aa                	mv	a5,a0
    return -1;
    800022ae:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800022b0:	0007c863          	bltz	a5,800022c0 <sys_kill+0x2a>
  return kill(pid);
    800022b4:	fec42503          	lw	a0,-20(s0)
    800022b8:	fffff097          	auipc	ra,0xfffff
    800022bc:	612080e7          	jalr	1554(ra) # 800018ca <kill>
}
    800022c0:	60e2                	ld	ra,24(sp)
    800022c2:	6442                	ld	s0,16(sp)
    800022c4:	6105                	addi	sp,sp,32
    800022c6:	8082                	ret

00000000800022c8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022c8:	1101                	addi	sp,sp,-32
    800022ca:	ec06                	sd	ra,24(sp)
    800022cc:	e822                	sd	s0,16(sp)
    800022ce:	e426                	sd	s1,8(sp)
    800022d0:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022d2:	00010517          	auipc	a0,0x10
    800022d6:	dae50513          	addi	a0,a0,-594 # 80012080 <tickslock>
    800022da:	00004097          	auipc	ra,0x4
    800022de:	03c080e7          	jalr	60(ra) # 80006316 <acquire>
  xticks = ticks;
    800022e2:	0000a497          	auipc	s1,0xa
    800022e6:	d364a483          	lw	s1,-714(s1) # 8000c018 <ticks>
  release(&tickslock);
    800022ea:	00010517          	auipc	a0,0x10
    800022ee:	d9650513          	addi	a0,a0,-618 # 80012080 <tickslock>
    800022f2:	00004097          	auipc	ra,0x4
    800022f6:	0d8080e7          	jalr	216(ra) # 800063ca <release>
  return xticks;
}
    800022fa:	02049513          	slli	a0,s1,0x20
    800022fe:	9101                	srli	a0,a0,0x20
    80002300:	60e2                	ld	ra,24(sp)
    80002302:	6442                	ld	s0,16(sp)
    80002304:	64a2                	ld	s1,8(sp)
    80002306:	6105                	addi	sp,sp,32
    80002308:	8082                	ret

000000008000230a <sys_trace>:

uint64
sys_trace(void)
{
    8000230a:	1101                	addi	sp,sp,-32
    8000230c:	ec06                	sd	ra,24(sp)
    8000230e:	e822                	sd	s0,16(sp)
    80002310:	1000                	addi	s0,sp,32
  int mask;
  if(argint(0, &mask) < 0)
    80002312:	fec40593          	addi	a1,s0,-20
    80002316:	4501                	li	a0,0
    80002318:	00000097          	auipc	ra,0x0
    8000231c:	cd0080e7          	jalr	-816(ra) # 80001fe8 <argint>
    return -1;
    80002320:	57fd                	li	a5,-1
  if(argint(0, &mask) < 0)
    80002322:	00054b63          	bltz	a0,80002338 <sys_trace+0x2e>
  
  struct proc *p = myproc();
    80002326:	fffff097          	auipc	ra,0xfffff
    8000232a:	ba0080e7          	jalr	-1120(ra) # 80000ec6 <myproc>
  p->trace_mask = mask;
    8000232e:	fec42783          	lw	a5,-20(s0)
    80002332:	16f52423          	sw	a5,360(a0)
  return 0;
    80002336:	4781                	li	a5,0
}
    80002338:	853e                	mv	a0,a5
    8000233a:	60e2                	ld	ra,24(sp)
    8000233c:	6442                	ld	s0,16(sp)
    8000233e:	6105                	addi	sp,sp,32
    80002340:	8082                	ret

0000000080002342 <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    80002342:	7139                	addi	sp,sp,-64
    80002344:	fc06                	sd	ra,56(sp)
    80002346:	f822                	sd	s0,48(sp)
    80002348:	f426                	sd	s1,40(sp)
    8000234a:	0080                	addi	s0,sp,64
  struct sysinfo info;
  uint64 addr;
  struct proc *p = myproc();
    8000234c:	fffff097          	auipc	ra,0xfffff
    80002350:	b7a080e7          	jalr	-1158(ra) # 80000ec6 <myproc>
    80002354:	84aa                	mv	s1,a0
  info.freemem = acquire_freemem();
    80002356:	ffffe097          	auipc	ra,0xffffe
    8000235a:	e24080e7          	jalr	-476(ra) # 8000017a <acquire_freemem>
    8000235e:	fca43823          	sd	a0,-48(s0)
  info.nproc = acquire_nproc();
    80002362:	fffff097          	auipc	ra,0xfffff
    80002366:	736080e7          	jalr	1846(ra) # 80001a98 <acquire_nproc>
    8000236a:	fca43c23          	sd	a0,-40(s0)

  if(argaddr(0,&addr)<0)
    8000236e:	fc840593          	addi	a1,s0,-56
    80002372:	4501                	li	a0,0
    80002374:	00000097          	auipc	ra,0x0
    80002378:	c96080e7          	jalr	-874(ra) # 8000200a <argaddr>
    return -1;
    8000237c:	57fd                	li	a5,-1
  if(argaddr(0,&addr)<0)
    8000237e:	00054e63          	bltz	a0,8000239a <sys_sysinfo+0x58>
  if(copyout(p->pagetable,addr,(char*)&info, sizeof(info))<0)
    80002382:	46c1                	li	a3,16
    80002384:	fd040613          	addi	a2,s0,-48
    80002388:	fc843583          	ld	a1,-56(s0)
    8000238c:	68a8                	ld	a0,80(s1)
    8000238e:	ffffe097          	auipc	ra,0xffffe
    80002392:	7d4080e7          	jalr	2004(ra) # 80000b62 <copyout>
    80002396:	43f55793          	srai	a5,a0,0x3f
    return -1;
  return 0;
}
    8000239a:	853e                	mv	a0,a5
    8000239c:	70e2                	ld	ra,56(sp)
    8000239e:	7442                	ld	s0,48(sp)
    800023a0:	74a2                	ld	s1,40(sp)
    800023a2:	6121                	addi	sp,sp,64
    800023a4:	8082                	ret

00000000800023a6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023a6:	7179                	addi	sp,sp,-48
    800023a8:	f406                	sd	ra,40(sp)
    800023aa:	f022                	sd	s0,32(sp)
    800023ac:	ec26                	sd	s1,24(sp)
    800023ae:	e84a                	sd	s2,16(sp)
    800023b0:	e44e                	sd	s3,8(sp)
    800023b2:	e052                	sd	s4,0(sp)
    800023b4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023b6:	00006597          	auipc	a1,0x6
    800023ba:	08a58593          	addi	a1,a1,138 # 80008440 <etext+0x440>
    800023be:	00010517          	auipc	a0,0x10
    800023c2:	cda50513          	addi	a0,a0,-806 # 80012098 <bcache>
    800023c6:	00004097          	auipc	ra,0x4
    800023ca:	ec0080e7          	jalr	-320(ra) # 80006286 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023ce:	00018797          	auipc	a5,0x18
    800023d2:	cca78793          	addi	a5,a5,-822 # 8001a098 <bcache+0x8000>
    800023d6:	00018717          	auipc	a4,0x18
    800023da:	f2a70713          	addi	a4,a4,-214 # 8001a300 <bcache+0x8268>
    800023de:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023e2:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023e6:	00010497          	auipc	s1,0x10
    800023ea:	cca48493          	addi	s1,s1,-822 # 800120b0 <bcache+0x18>
    b->next = bcache.head.next;
    800023ee:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023f0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023f2:	00006a17          	auipc	s4,0x6
    800023f6:	056a0a13          	addi	s4,s4,86 # 80008448 <etext+0x448>
    b->next = bcache.head.next;
    800023fa:	2b893783          	ld	a5,696(s2)
    800023fe:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002400:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002404:	85d2                	mv	a1,s4
    80002406:	01048513          	addi	a0,s1,16
    8000240a:	00001097          	auipc	ra,0x1
    8000240e:	4b2080e7          	jalr	1202(ra) # 800038bc <initsleeplock>
    bcache.head.next->prev = b;
    80002412:	2b893783          	ld	a5,696(s2)
    80002416:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002418:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000241c:	45848493          	addi	s1,s1,1112
    80002420:	fd349de3          	bne	s1,s3,800023fa <binit+0x54>
  }
}
    80002424:	70a2                	ld	ra,40(sp)
    80002426:	7402                	ld	s0,32(sp)
    80002428:	64e2                	ld	s1,24(sp)
    8000242a:	6942                	ld	s2,16(sp)
    8000242c:	69a2                	ld	s3,8(sp)
    8000242e:	6a02                	ld	s4,0(sp)
    80002430:	6145                	addi	sp,sp,48
    80002432:	8082                	ret

0000000080002434 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002434:	7179                	addi	sp,sp,-48
    80002436:	f406                	sd	ra,40(sp)
    80002438:	f022                	sd	s0,32(sp)
    8000243a:	ec26                	sd	s1,24(sp)
    8000243c:	e84a                	sd	s2,16(sp)
    8000243e:	e44e                	sd	s3,8(sp)
    80002440:	1800                	addi	s0,sp,48
    80002442:	892a                	mv	s2,a0
    80002444:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002446:	00010517          	auipc	a0,0x10
    8000244a:	c5250513          	addi	a0,a0,-942 # 80012098 <bcache>
    8000244e:	00004097          	auipc	ra,0x4
    80002452:	ec8080e7          	jalr	-312(ra) # 80006316 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002456:	00018497          	auipc	s1,0x18
    8000245a:	efa4b483          	ld	s1,-262(s1) # 8001a350 <bcache+0x82b8>
    8000245e:	00018797          	auipc	a5,0x18
    80002462:	ea278793          	addi	a5,a5,-350 # 8001a300 <bcache+0x8268>
    80002466:	02f48f63          	beq	s1,a5,800024a4 <bread+0x70>
    8000246a:	873e                	mv	a4,a5
    8000246c:	a021                	j	80002474 <bread+0x40>
    8000246e:	68a4                	ld	s1,80(s1)
    80002470:	02e48a63          	beq	s1,a4,800024a4 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002474:	449c                	lw	a5,8(s1)
    80002476:	ff279ce3          	bne	a5,s2,8000246e <bread+0x3a>
    8000247a:	44dc                	lw	a5,12(s1)
    8000247c:	ff3799e3          	bne	a5,s3,8000246e <bread+0x3a>
      b->refcnt++;
    80002480:	40bc                	lw	a5,64(s1)
    80002482:	2785                	addiw	a5,a5,1
    80002484:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002486:	00010517          	auipc	a0,0x10
    8000248a:	c1250513          	addi	a0,a0,-1006 # 80012098 <bcache>
    8000248e:	00004097          	auipc	ra,0x4
    80002492:	f3c080e7          	jalr	-196(ra) # 800063ca <release>
      acquiresleep(&b->lock);
    80002496:	01048513          	addi	a0,s1,16
    8000249a:	00001097          	auipc	ra,0x1
    8000249e:	45c080e7          	jalr	1116(ra) # 800038f6 <acquiresleep>
      return b;
    800024a2:	a8b9                	j	80002500 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024a4:	00018497          	auipc	s1,0x18
    800024a8:	ea44b483          	ld	s1,-348(s1) # 8001a348 <bcache+0x82b0>
    800024ac:	00018797          	auipc	a5,0x18
    800024b0:	e5478793          	addi	a5,a5,-428 # 8001a300 <bcache+0x8268>
    800024b4:	00f48863          	beq	s1,a5,800024c4 <bread+0x90>
    800024b8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024ba:	40bc                	lw	a5,64(s1)
    800024bc:	cf81                	beqz	a5,800024d4 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024be:	64a4                	ld	s1,72(s1)
    800024c0:	fee49de3          	bne	s1,a4,800024ba <bread+0x86>
  panic("bget: no buffers");
    800024c4:	00006517          	auipc	a0,0x6
    800024c8:	f8c50513          	addi	a0,a0,-116 # 80008450 <etext+0x450>
    800024cc:	00004097          	auipc	ra,0x4
    800024d0:	8d0080e7          	jalr	-1840(ra) # 80005d9c <panic>
      b->dev = dev;
    800024d4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800024d8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800024dc:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024e0:	4785                	li	a5,1
    800024e2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024e4:	00010517          	auipc	a0,0x10
    800024e8:	bb450513          	addi	a0,a0,-1100 # 80012098 <bcache>
    800024ec:	00004097          	auipc	ra,0x4
    800024f0:	ede080e7          	jalr	-290(ra) # 800063ca <release>
      acquiresleep(&b->lock);
    800024f4:	01048513          	addi	a0,s1,16
    800024f8:	00001097          	auipc	ra,0x1
    800024fc:	3fe080e7          	jalr	1022(ra) # 800038f6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002500:	409c                	lw	a5,0(s1)
    80002502:	cb89                	beqz	a5,80002514 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002504:	8526                	mv	a0,s1
    80002506:	70a2                	ld	ra,40(sp)
    80002508:	7402                	ld	s0,32(sp)
    8000250a:	64e2                	ld	s1,24(sp)
    8000250c:	6942                	ld	s2,16(sp)
    8000250e:	69a2                	ld	s3,8(sp)
    80002510:	6145                	addi	sp,sp,48
    80002512:	8082                	ret
    virtio_disk_rw(b, 0);
    80002514:	4581                	li	a1,0
    80002516:	8526                	mv	a0,s1
    80002518:	00003097          	auipc	ra,0x3
    8000251c:	fea080e7          	jalr	-22(ra) # 80005502 <virtio_disk_rw>
    b->valid = 1;
    80002520:	4785                	li	a5,1
    80002522:	c09c                	sw	a5,0(s1)
  return b;
    80002524:	b7c5                	j	80002504 <bread+0xd0>

0000000080002526 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002526:	1101                	addi	sp,sp,-32
    80002528:	ec06                	sd	ra,24(sp)
    8000252a:	e822                	sd	s0,16(sp)
    8000252c:	e426                	sd	s1,8(sp)
    8000252e:	1000                	addi	s0,sp,32
    80002530:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002532:	0541                	addi	a0,a0,16
    80002534:	00001097          	auipc	ra,0x1
    80002538:	45c080e7          	jalr	1116(ra) # 80003990 <holdingsleep>
    8000253c:	cd01                	beqz	a0,80002554 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000253e:	4585                	li	a1,1
    80002540:	8526                	mv	a0,s1
    80002542:	00003097          	auipc	ra,0x3
    80002546:	fc0080e7          	jalr	-64(ra) # 80005502 <virtio_disk_rw>
}
    8000254a:	60e2                	ld	ra,24(sp)
    8000254c:	6442                	ld	s0,16(sp)
    8000254e:	64a2                	ld	s1,8(sp)
    80002550:	6105                	addi	sp,sp,32
    80002552:	8082                	ret
    panic("bwrite");
    80002554:	00006517          	auipc	a0,0x6
    80002558:	f1450513          	addi	a0,a0,-236 # 80008468 <etext+0x468>
    8000255c:	00004097          	auipc	ra,0x4
    80002560:	840080e7          	jalr	-1984(ra) # 80005d9c <panic>

0000000080002564 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002564:	1101                	addi	sp,sp,-32
    80002566:	ec06                	sd	ra,24(sp)
    80002568:	e822                	sd	s0,16(sp)
    8000256a:	e426                	sd	s1,8(sp)
    8000256c:	e04a                	sd	s2,0(sp)
    8000256e:	1000                	addi	s0,sp,32
    80002570:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002572:	01050913          	addi	s2,a0,16
    80002576:	854a                	mv	a0,s2
    80002578:	00001097          	auipc	ra,0x1
    8000257c:	418080e7          	jalr	1048(ra) # 80003990 <holdingsleep>
    80002580:	c925                	beqz	a0,800025f0 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002582:	854a                	mv	a0,s2
    80002584:	00001097          	auipc	ra,0x1
    80002588:	3c8080e7          	jalr	968(ra) # 8000394c <releasesleep>

  acquire(&bcache.lock);
    8000258c:	00010517          	auipc	a0,0x10
    80002590:	b0c50513          	addi	a0,a0,-1268 # 80012098 <bcache>
    80002594:	00004097          	auipc	ra,0x4
    80002598:	d82080e7          	jalr	-638(ra) # 80006316 <acquire>
  b->refcnt--;
    8000259c:	40bc                	lw	a5,64(s1)
    8000259e:	37fd                	addiw	a5,a5,-1
    800025a0:	0007871b          	sext.w	a4,a5
    800025a4:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025a6:	e71d                	bnez	a4,800025d4 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025a8:	68b8                	ld	a4,80(s1)
    800025aa:	64bc                	ld	a5,72(s1)
    800025ac:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800025ae:	68b8                	ld	a4,80(s1)
    800025b0:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025b2:	00018797          	auipc	a5,0x18
    800025b6:	ae678793          	addi	a5,a5,-1306 # 8001a098 <bcache+0x8000>
    800025ba:	2b87b703          	ld	a4,696(a5)
    800025be:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025c0:	00018717          	auipc	a4,0x18
    800025c4:	d4070713          	addi	a4,a4,-704 # 8001a300 <bcache+0x8268>
    800025c8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025ca:	2b87b703          	ld	a4,696(a5)
    800025ce:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025d0:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025d4:	00010517          	auipc	a0,0x10
    800025d8:	ac450513          	addi	a0,a0,-1340 # 80012098 <bcache>
    800025dc:	00004097          	auipc	ra,0x4
    800025e0:	dee080e7          	jalr	-530(ra) # 800063ca <release>
}
    800025e4:	60e2                	ld	ra,24(sp)
    800025e6:	6442                	ld	s0,16(sp)
    800025e8:	64a2                	ld	s1,8(sp)
    800025ea:	6902                	ld	s2,0(sp)
    800025ec:	6105                	addi	sp,sp,32
    800025ee:	8082                	ret
    panic("brelse");
    800025f0:	00006517          	auipc	a0,0x6
    800025f4:	e8050513          	addi	a0,a0,-384 # 80008470 <etext+0x470>
    800025f8:	00003097          	auipc	ra,0x3
    800025fc:	7a4080e7          	jalr	1956(ra) # 80005d9c <panic>

0000000080002600 <bpin>:

void
bpin(struct buf *b) {
    80002600:	1101                	addi	sp,sp,-32
    80002602:	ec06                	sd	ra,24(sp)
    80002604:	e822                	sd	s0,16(sp)
    80002606:	e426                	sd	s1,8(sp)
    80002608:	1000                	addi	s0,sp,32
    8000260a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000260c:	00010517          	auipc	a0,0x10
    80002610:	a8c50513          	addi	a0,a0,-1396 # 80012098 <bcache>
    80002614:	00004097          	auipc	ra,0x4
    80002618:	d02080e7          	jalr	-766(ra) # 80006316 <acquire>
  b->refcnt++;
    8000261c:	40bc                	lw	a5,64(s1)
    8000261e:	2785                	addiw	a5,a5,1
    80002620:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002622:	00010517          	auipc	a0,0x10
    80002626:	a7650513          	addi	a0,a0,-1418 # 80012098 <bcache>
    8000262a:	00004097          	auipc	ra,0x4
    8000262e:	da0080e7          	jalr	-608(ra) # 800063ca <release>
}
    80002632:	60e2                	ld	ra,24(sp)
    80002634:	6442                	ld	s0,16(sp)
    80002636:	64a2                	ld	s1,8(sp)
    80002638:	6105                	addi	sp,sp,32
    8000263a:	8082                	ret

000000008000263c <bunpin>:

void
bunpin(struct buf *b) {
    8000263c:	1101                	addi	sp,sp,-32
    8000263e:	ec06                	sd	ra,24(sp)
    80002640:	e822                	sd	s0,16(sp)
    80002642:	e426                	sd	s1,8(sp)
    80002644:	1000                	addi	s0,sp,32
    80002646:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002648:	00010517          	auipc	a0,0x10
    8000264c:	a5050513          	addi	a0,a0,-1456 # 80012098 <bcache>
    80002650:	00004097          	auipc	ra,0x4
    80002654:	cc6080e7          	jalr	-826(ra) # 80006316 <acquire>
  b->refcnt--;
    80002658:	40bc                	lw	a5,64(s1)
    8000265a:	37fd                	addiw	a5,a5,-1
    8000265c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000265e:	00010517          	auipc	a0,0x10
    80002662:	a3a50513          	addi	a0,a0,-1478 # 80012098 <bcache>
    80002666:	00004097          	auipc	ra,0x4
    8000266a:	d64080e7          	jalr	-668(ra) # 800063ca <release>
}
    8000266e:	60e2                	ld	ra,24(sp)
    80002670:	6442                	ld	s0,16(sp)
    80002672:	64a2                	ld	s1,8(sp)
    80002674:	6105                	addi	sp,sp,32
    80002676:	8082                	ret

0000000080002678 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002678:	1101                	addi	sp,sp,-32
    8000267a:	ec06                	sd	ra,24(sp)
    8000267c:	e822                	sd	s0,16(sp)
    8000267e:	e426                	sd	s1,8(sp)
    80002680:	e04a                	sd	s2,0(sp)
    80002682:	1000                	addi	s0,sp,32
    80002684:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002686:	00d5d59b          	srliw	a1,a1,0xd
    8000268a:	00018797          	auipc	a5,0x18
    8000268e:	0ea7a783          	lw	a5,234(a5) # 8001a774 <sb+0x1c>
    80002692:	9dbd                	addw	a1,a1,a5
    80002694:	00000097          	auipc	ra,0x0
    80002698:	da0080e7          	jalr	-608(ra) # 80002434 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000269c:	0074f713          	andi	a4,s1,7
    800026a0:	4785                	li	a5,1
    800026a2:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026a6:	14ce                	slli	s1,s1,0x33
    800026a8:	90d9                	srli	s1,s1,0x36
    800026aa:	00950733          	add	a4,a0,s1
    800026ae:	05874703          	lbu	a4,88(a4)
    800026b2:	00e7f6b3          	and	a3,a5,a4
    800026b6:	c69d                	beqz	a3,800026e4 <bfree+0x6c>
    800026b8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026ba:	94aa                	add	s1,s1,a0
    800026bc:	fff7c793          	not	a5,a5
    800026c0:	8f7d                	and	a4,a4,a5
    800026c2:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800026c6:	00001097          	auipc	ra,0x1
    800026ca:	112080e7          	jalr	274(ra) # 800037d8 <log_write>
  brelse(bp);
    800026ce:	854a                	mv	a0,s2
    800026d0:	00000097          	auipc	ra,0x0
    800026d4:	e94080e7          	jalr	-364(ra) # 80002564 <brelse>
}
    800026d8:	60e2                	ld	ra,24(sp)
    800026da:	6442                	ld	s0,16(sp)
    800026dc:	64a2                	ld	s1,8(sp)
    800026de:	6902                	ld	s2,0(sp)
    800026e0:	6105                	addi	sp,sp,32
    800026e2:	8082                	ret
    panic("freeing free block");
    800026e4:	00006517          	auipc	a0,0x6
    800026e8:	d9450513          	addi	a0,a0,-620 # 80008478 <etext+0x478>
    800026ec:	00003097          	auipc	ra,0x3
    800026f0:	6b0080e7          	jalr	1712(ra) # 80005d9c <panic>

00000000800026f4 <balloc>:
{
    800026f4:	711d                	addi	sp,sp,-96
    800026f6:	ec86                	sd	ra,88(sp)
    800026f8:	e8a2                	sd	s0,80(sp)
    800026fa:	e4a6                	sd	s1,72(sp)
    800026fc:	e0ca                	sd	s2,64(sp)
    800026fe:	fc4e                	sd	s3,56(sp)
    80002700:	f852                	sd	s4,48(sp)
    80002702:	f456                	sd	s5,40(sp)
    80002704:	f05a                	sd	s6,32(sp)
    80002706:	ec5e                	sd	s7,24(sp)
    80002708:	e862                	sd	s8,16(sp)
    8000270a:	e466                	sd	s9,8(sp)
    8000270c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000270e:	00018797          	auipc	a5,0x18
    80002712:	04e7a783          	lw	a5,78(a5) # 8001a75c <sb+0x4>
    80002716:	cbc1                	beqz	a5,800027a6 <balloc+0xb2>
    80002718:	8baa                	mv	s7,a0
    8000271a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000271c:	00018b17          	auipc	s6,0x18
    80002720:	03cb0b13          	addi	s6,s6,60 # 8001a758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002724:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002726:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002728:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000272a:	6c89                	lui	s9,0x2
    8000272c:	a831                	j	80002748 <balloc+0x54>
    brelse(bp);
    8000272e:	854a                	mv	a0,s2
    80002730:	00000097          	auipc	ra,0x0
    80002734:	e34080e7          	jalr	-460(ra) # 80002564 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002738:	015c87bb          	addw	a5,s9,s5
    8000273c:	00078a9b          	sext.w	s5,a5
    80002740:	004b2703          	lw	a4,4(s6)
    80002744:	06eaf163          	bgeu	s5,a4,800027a6 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002748:	41fad79b          	sraiw	a5,s5,0x1f
    8000274c:	0137d79b          	srliw	a5,a5,0x13
    80002750:	015787bb          	addw	a5,a5,s5
    80002754:	40d7d79b          	sraiw	a5,a5,0xd
    80002758:	01cb2583          	lw	a1,28(s6)
    8000275c:	9dbd                	addw	a1,a1,a5
    8000275e:	855e                	mv	a0,s7
    80002760:	00000097          	auipc	ra,0x0
    80002764:	cd4080e7          	jalr	-812(ra) # 80002434 <bread>
    80002768:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000276a:	004b2503          	lw	a0,4(s6)
    8000276e:	000a849b          	sext.w	s1,s5
    80002772:	8762                	mv	a4,s8
    80002774:	faa4fde3          	bgeu	s1,a0,8000272e <balloc+0x3a>
      m = 1 << (bi % 8);
    80002778:	00777693          	andi	a3,a4,7
    8000277c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002780:	41f7579b          	sraiw	a5,a4,0x1f
    80002784:	01d7d79b          	srliw	a5,a5,0x1d
    80002788:	9fb9                	addw	a5,a5,a4
    8000278a:	4037d79b          	sraiw	a5,a5,0x3
    8000278e:	00f90633          	add	a2,s2,a5
    80002792:	05864603          	lbu	a2,88(a2)
    80002796:	00c6f5b3          	and	a1,a3,a2
    8000279a:	cd91                	beqz	a1,800027b6 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000279c:	2705                	addiw	a4,a4,1
    8000279e:	2485                	addiw	s1,s1,1
    800027a0:	fd471ae3          	bne	a4,s4,80002774 <balloc+0x80>
    800027a4:	b769                	j	8000272e <balloc+0x3a>
  panic("balloc: out of blocks");
    800027a6:	00006517          	auipc	a0,0x6
    800027aa:	cea50513          	addi	a0,a0,-790 # 80008490 <etext+0x490>
    800027ae:	00003097          	auipc	ra,0x3
    800027b2:	5ee080e7          	jalr	1518(ra) # 80005d9c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800027b6:	97ca                	add	a5,a5,s2
    800027b8:	8e55                	or	a2,a2,a3
    800027ba:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800027be:	854a                	mv	a0,s2
    800027c0:	00001097          	auipc	ra,0x1
    800027c4:	018080e7          	jalr	24(ra) # 800037d8 <log_write>
        brelse(bp);
    800027c8:	854a                	mv	a0,s2
    800027ca:	00000097          	auipc	ra,0x0
    800027ce:	d9a080e7          	jalr	-614(ra) # 80002564 <brelse>
  bp = bread(dev, bno);
    800027d2:	85a6                	mv	a1,s1
    800027d4:	855e                	mv	a0,s7
    800027d6:	00000097          	auipc	ra,0x0
    800027da:	c5e080e7          	jalr	-930(ra) # 80002434 <bread>
    800027de:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800027e0:	40000613          	li	a2,1024
    800027e4:	4581                	li	a1,0
    800027e6:	05850513          	addi	a0,a0,88
    800027ea:	ffffe097          	auipc	ra,0xffffe
    800027ee:	9da080e7          	jalr	-1574(ra) # 800001c4 <memset>
  log_write(bp);
    800027f2:	854a                	mv	a0,s2
    800027f4:	00001097          	auipc	ra,0x1
    800027f8:	fe4080e7          	jalr	-28(ra) # 800037d8 <log_write>
  brelse(bp);
    800027fc:	854a                	mv	a0,s2
    800027fe:	00000097          	auipc	ra,0x0
    80002802:	d66080e7          	jalr	-666(ra) # 80002564 <brelse>
}
    80002806:	8526                	mv	a0,s1
    80002808:	60e6                	ld	ra,88(sp)
    8000280a:	6446                	ld	s0,80(sp)
    8000280c:	64a6                	ld	s1,72(sp)
    8000280e:	6906                	ld	s2,64(sp)
    80002810:	79e2                	ld	s3,56(sp)
    80002812:	7a42                	ld	s4,48(sp)
    80002814:	7aa2                	ld	s5,40(sp)
    80002816:	7b02                	ld	s6,32(sp)
    80002818:	6be2                	ld	s7,24(sp)
    8000281a:	6c42                	ld	s8,16(sp)
    8000281c:	6ca2                	ld	s9,8(sp)
    8000281e:	6125                	addi	sp,sp,96
    80002820:	8082                	ret

0000000080002822 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002822:	7179                	addi	sp,sp,-48
    80002824:	f406                	sd	ra,40(sp)
    80002826:	f022                	sd	s0,32(sp)
    80002828:	ec26                	sd	s1,24(sp)
    8000282a:	e84a                	sd	s2,16(sp)
    8000282c:	e44e                	sd	s3,8(sp)
    8000282e:	1800                	addi	s0,sp,48
    80002830:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002832:	47ad                	li	a5,11
    80002834:	04b7ff63          	bgeu	a5,a1,80002892 <bmap+0x70>
    80002838:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000283a:	ff45849b          	addiw	s1,a1,-12
    8000283e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002842:	0ff00793          	li	a5,255
    80002846:	0ae7e463          	bltu	a5,a4,800028ee <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000284a:	08052583          	lw	a1,128(a0)
    8000284e:	c5b5                	beqz	a1,800028ba <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002850:	00092503          	lw	a0,0(s2)
    80002854:	00000097          	auipc	ra,0x0
    80002858:	be0080e7          	jalr	-1056(ra) # 80002434 <bread>
    8000285c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000285e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002862:	02049713          	slli	a4,s1,0x20
    80002866:	01e75593          	srli	a1,a4,0x1e
    8000286a:	00b784b3          	add	s1,a5,a1
    8000286e:	0004a983          	lw	s3,0(s1)
    80002872:	04098e63          	beqz	s3,800028ce <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002876:	8552                	mv	a0,s4
    80002878:	00000097          	auipc	ra,0x0
    8000287c:	cec080e7          	jalr	-788(ra) # 80002564 <brelse>
    return addr;
    80002880:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002882:	854e                	mv	a0,s3
    80002884:	70a2                	ld	ra,40(sp)
    80002886:	7402                	ld	s0,32(sp)
    80002888:	64e2                	ld	s1,24(sp)
    8000288a:	6942                	ld	s2,16(sp)
    8000288c:	69a2                	ld	s3,8(sp)
    8000288e:	6145                	addi	sp,sp,48
    80002890:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002892:	02059793          	slli	a5,a1,0x20
    80002896:	01e7d593          	srli	a1,a5,0x1e
    8000289a:	00b504b3          	add	s1,a0,a1
    8000289e:	0504a983          	lw	s3,80(s1)
    800028a2:	fe0990e3          	bnez	s3,80002882 <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800028a6:	4108                	lw	a0,0(a0)
    800028a8:	00000097          	auipc	ra,0x0
    800028ac:	e4c080e7          	jalr	-436(ra) # 800026f4 <balloc>
    800028b0:	0005099b          	sext.w	s3,a0
    800028b4:	0534a823          	sw	s3,80(s1)
    800028b8:	b7e9                	j	80002882 <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800028ba:	4108                	lw	a0,0(a0)
    800028bc:	00000097          	auipc	ra,0x0
    800028c0:	e38080e7          	jalr	-456(ra) # 800026f4 <balloc>
    800028c4:	0005059b          	sext.w	a1,a0
    800028c8:	08b92023          	sw	a1,128(s2)
    800028cc:	b751                	j	80002850 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800028ce:	00092503          	lw	a0,0(s2)
    800028d2:	00000097          	auipc	ra,0x0
    800028d6:	e22080e7          	jalr	-478(ra) # 800026f4 <balloc>
    800028da:	0005099b          	sext.w	s3,a0
    800028de:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800028e2:	8552                	mv	a0,s4
    800028e4:	00001097          	auipc	ra,0x1
    800028e8:	ef4080e7          	jalr	-268(ra) # 800037d8 <log_write>
    800028ec:	b769                	j	80002876 <bmap+0x54>
  panic("bmap: out of range");
    800028ee:	00006517          	auipc	a0,0x6
    800028f2:	bba50513          	addi	a0,a0,-1094 # 800084a8 <etext+0x4a8>
    800028f6:	00003097          	auipc	ra,0x3
    800028fa:	4a6080e7          	jalr	1190(ra) # 80005d9c <panic>

00000000800028fe <iget>:
{
    800028fe:	7179                	addi	sp,sp,-48
    80002900:	f406                	sd	ra,40(sp)
    80002902:	f022                	sd	s0,32(sp)
    80002904:	ec26                	sd	s1,24(sp)
    80002906:	e84a                	sd	s2,16(sp)
    80002908:	e44e                	sd	s3,8(sp)
    8000290a:	e052                	sd	s4,0(sp)
    8000290c:	1800                	addi	s0,sp,48
    8000290e:	89aa                	mv	s3,a0
    80002910:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002912:	00018517          	auipc	a0,0x18
    80002916:	e6650513          	addi	a0,a0,-410 # 8001a778 <itable>
    8000291a:	00004097          	auipc	ra,0x4
    8000291e:	9fc080e7          	jalr	-1540(ra) # 80006316 <acquire>
  empty = 0;
    80002922:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002924:	00018497          	auipc	s1,0x18
    80002928:	e6c48493          	addi	s1,s1,-404 # 8001a790 <itable+0x18>
    8000292c:	0001a697          	auipc	a3,0x1a
    80002930:	8f468693          	addi	a3,a3,-1804 # 8001c220 <log>
    80002934:	a039                	j	80002942 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002936:	02090b63          	beqz	s2,8000296c <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000293a:	08848493          	addi	s1,s1,136
    8000293e:	02d48a63          	beq	s1,a3,80002972 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002942:	449c                	lw	a5,8(s1)
    80002944:	fef059e3          	blez	a5,80002936 <iget+0x38>
    80002948:	4098                	lw	a4,0(s1)
    8000294a:	ff3716e3          	bne	a4,s3,80002936 <iget+0x38>
    8000294e:	40d8                	lw	a4,4(s1)
    80002950:	ff4713e3          	bne	a4,s4,80002936 <iget+0x38>
      ip->ref++;
    80002954:	2785                	addiw	a5,a5,1
    80002956:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002958:	00018517          	auipc	a0,0x18
    8000295c:	e2050513          	addi	a0,a0,-480 # 8001a778 <itable>
    80002960:	00004097          	auipc	ra,0x4
    80002964:	a6a080e7          	jalr	-1430(ra) # 800063ca <release>
      return ip;
    80002968:	8926                	mv	s2,s1
    8000296a:	a03d                	j	80002998 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000296c:	f7f9                	bnez	a5,8000293a <iget+0x3c>
      empty = ip;
    8000296e:	8926                	mv	s2,s1
    80002970:	b7e9                	j	8000293a <iget+0x3c>
  if(empty == 0)
    80002972:	02090c63          	beqz	s2,800029aa <iget+0xac>
  ip->dev = dev;
    80002976:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000297a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000297e:	4785                	li	a5,1
    80002980:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002984:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002988:	00018517          	auipc	a0,0x18
    8000298c:	df050513          	addi	a0,a0,-528 # 8001a778 <itable>
    80002990:	00004097          	auipc	ra,0x4
    80002994:	a3a080e7          	jalr	-1478(ra) # 800063ca <release>
}
    80002998:	854a                	mv	a0,s2
    8000299a:	70a2                	ld	ra,40(sp)
    8000299c:	7402                	ld	s0,32(sp)
    8000299e:	64e2                	ld	s1,24(sp)
    800029a0:	6942                	ld	s2,16(sp)
    800029a2:	69a2                	ld	s3,8(sp)
    800029a4:	6a02                	ld	s4,0(sp)
    800029a6:	6145                	addi	sp,sp,48
    800029a8:	8082                	ret
    panic("iget: no inodes");
    800029aa:	00006517          	auipc	a0,0x6
    800029ae:	b1650513          	addi	a0,a0,-1258 # 800084c0 <etext+0x4c0>
    800029b2:	00003097          	auipc	ra,0x3
    800029b6:	3ea080e7          	jalr	1002(ra) # 80005d9c <panic>

00000000800029ba <fsinit>:
fsinit(int dev) {
    800029ba:	7179                	addi	sp,sp,-48
    800029bc:	f406                	sd	ra,40(sp)
    800029be:	f022                	sd	s0,32(sp)
    800029c0:	ec26                	sd	s1,24(sp)
    800029c2:	e84a                	sd	s2,16(sp)
    800029c4:	e44e                	sd	s3,8(sp)
    800029c6:	1800                	addi	s0,sp,48
    800029c8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029ca:	4585                	li	a1,1
    800029cc:	00000097          	auipc	ra,0x0
    800029d0:	a68080e7          	jalr	-1432(ra) # 80002434 <bread>
    800029d4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029d6:	00018997          	auipc	s3,0x18
    800029da:	d8298993          	addi	s3,s3,-638 # 8001a758 <sb>
    800029de:	02000613          	li	a2,32
    800029e2:	05850593          	addi	a1,a0,88
    800029e6:	854e                	mv	a0,s3
    800029e8:	ffffe097          	auipc	ra,0xffffe
    800029ec:	838080e7          	jalr	-1992(ra) # 80000220 <memmove>
  brelse(bp);
    800029f0:	8526                	mv	a0,s1
    800029f2:	00000097          	auipc	ra,0x0
    800029f6:	b72080e7          	jalr	-1166(ra) # 80002564 <brelse>
  if(sb.magic != FSMAGIC)
    800029fa:	0009a703          	lw	a4,0(s3)
    800029fe:	102037b7          	lui	a5,0x10203
    80002a02:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a06:	02f71263          	bne	a4,a5,80002a2a <fsinit+0x70>
  initlog(dev, &sb);
    80002a0a:	00018597          	auipc	a1,0x18
    80002a0e:	d4e58593          	addi	a1,a1,-690 # 8001a758 <sb>
    80002a12:	854a                	mv	a0,s2
    80002a14:	00001097          	auipc	ra,0x1
    80002a18:	b54080e7          	jalr	-1196(ra) # 80003568 <initlog>
}
    80002a1c:	70a2                	ld	ra,40(sp)
    80002a1e:	7402                	ld	s0,32(sp)
    80002a20:	64e2                	ld	s1,24(sp)
    80002a22:	6942                	ld	s2,16(sp)
    80002a24:	69a2                	ld	s3,8(sp)
    80002a26:	6145                	addi	sp,sp,48
    80002a28:	8082                	ret
    panic("invalid file system");
    80002a2a:	00006517          	auipc	a0,0x6
    80002a2e:	aa650513          	addi	a0,a0,-1370 # 800084d0 <etext+0x4d0>
    80002a32:	00003097          	auipc	ra,0x3
    80002a36:	36a080e7          	jalr	874(ra) # 80005d9c <panic>

0000000080002a3a <iinit>:
{
    80002a3a:	7179                	addi	sp,sp,-48
    80002a3c:	f406                	sd	ra,40(sp)
    80002a3e:	f022                	sd	s0,32(sp)
    80002a40:	ec26                	sd	s1,24(sp)
    80002a42:	e84a                	sd	s2,16(sp)
    80002a44:	e44e                	sd	s3,8(sp)
    80002a46:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a48:	00006597          	auipc	a1,0x6
    80002a4c:	aa058593          	addi	a1,a1,-1376 # 800084e8 <etext+0x4e8>
    80002a50:	00018517          	auipc	a0,0x18
    80002a54:	d2850513          	addi	a0,a0,-728 # 8001a778 <itable>
    80002a58:	00004097          	auipc	ra,0x4
    80002a5c:	82e080e7          	jalr	-2002(ra) # 80006286 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a60:	00018497          	auipc	s1,0x18
    80002a64:	d4048493          	addi	s1,s1,-704 # 8001a7a0 <itable+0x28>
    80002a68:	00019997          	auipc	s3,0x19
    80002a6c:	7c898993          	addi	s3,s3,1992 # 8001c230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a70:	00006917          	auipc	s2,0x6
    80002a74:	a8090913          	addi	s2,s2,-1408 # 800084f0 <etext+0x4f0>
    80002a78:	85ca                	mv	a1,s2
    80002a7a:	8526                	mv	a0,s1
    80002a7c:	00001097          	auipc	ra,0x1
    80002a80:	e40080e7          	jalr	-448(ra) # 800038bc <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a84:	08848493          	addi	s1,s1,136
    80002a88:	ff3498e3          	bne	s1,s3,80002a78 <iinit+0x3e>
}
    80002a8c:	70a2                	ld	ra,40(sp)
    80002a8e:	7402                	ld	s0,32(sp)
    80002a90:	64e2                	ld	s1,24(sp)
    80002a92:	6942                	ld	s2,16(sp)
    80002a94:	69a2                	ld	s3,8(sp)
    80002a96:	6145                	addi	sp,sp,48
    80002a98:	8082                	ret

0000000080002a9a <ialloc>:
{
    80002a9a:	7139                	addi	sp,sp,-64
    80002a9c:	fc06                	sd	ra,56(sp)
    80002a9e:	f822                	sd	s0,48(sp)
    80002aa0:	f426                	sd	s1,40(sp)
    80002aa2:	f04a                	sd	s2,32(sp)
    80002aa4:	ec4e                	sd	s3,24(sp)
    80002aa6:	e852                	sd	s4,16(sp)
    80002aa8:	e456                	sd	s5,8(sp)
    80002aaa:	e05a                	sd	s6,0(sp)
    80002aac:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002aae:	00018717          	auipc	a4,0x18
    80002ab2:	cb672703          	lw	a4,-842(a4) # 8001a764 <sb+0xc>
    80002ab6:	4785                	li	a5,1
    80002ab8:	04e7f863          	bgeu	a5,a4,80002b08 <ialloc+0x6e>
    80002abc:	8aaa                	mv	s5,a0
    80002abe:	8b2e                	mv	s6,a1
    80002ac0:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002ac2:	00018a17          	auipc	s4,0x18
    80002ac6:	c96a0a13          	addi	s4,s4,-874 # 8001a758 <sb>
    80002aca:	00495593          	srli	a1,s2,0x4
    80002ace:	018a2783          	lw	a5,24(s4)
    80002ad2:	9dbd                	addw	a1,a1,a5
    80002ad4:	8556                	mv	a0,s5
    80002ad6:	00000097          	auipc	ra,0x0
    80002ada:	95e080e7          	jalr	-1698(ra) # 80002434 <bread>
    80002ade:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002ae0:	05850993          	addi	s3,a0,88
    80002ae4:	00f97793          	andi	a5,s2,15
    80002ae8:	079a                	slli	a5,a5,0x6
    80002aea:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002aec:	00099783          	lh	a5,0(s3)
    80002af0:	c785                	beqz	a5,80002b18 <ialloc+0x7e>
    brelse(bp);
    80002af2:	00000097          	auipc	ra,0x0
    80002af6:	a72080e7          	jalr	-1422(ra) # 80002564 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002afa:	0905                	addi	s2,s2,1
    80002afc:	00ca2703          	lw	a4,12(s4)
    80002b00:	0009079b          	sext.w	a5,s2
    80002b04:	fce7e3e3          	bltu	a5,a4,80002aca <ialloc+0x30>
  panic("ialloc: no inodes");
    80002b08:	00006517          	auipc	a0,0x6
    80002b0c:	9f050513          	addi	a0,a0,-1552 # 800084f8 <etext+0x4f8>
    80002b10:	00003097          	auipc	ra,0x3
    80002b14:	28c080e7          	jalr	652(ra) # 80005d9c <panic>
      memset(dip, 0, sizeof(*dip));
    80002b18:	04000613          	li	a2,64
    80002b1c:	4581                	li	a1,0
    80002b1e:	854e                	mv	a0,s3
    80002b20:	ffffd097          	auipc	ra,0xffffd
    80002b24:	6a4080e7          	jalr	1700(ra) # 800001c4 <memset>
      dip->type = type;
    80002b28:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b2c:	8526                	mv	a0,s1
    80002b2e:	00001097          	auipc	ra,0x1
    80002b32:	caa080e7          	jalr	-854(ra) # 800037d8 <log_write>
      brelse(bp);
    80002b36:	8526                	mv	a0,s1
    80002b38:	00000097          	auipc	ra,0x0
    80002b3c:	a2c080e7          	jalr	-1492(ra) # 80002564 <brelse>
      return iget(dev, inum);
    80002b40:	0009059b          	sext.w	a1,s2
    80002b44:	8556                	mv	a0,s5
    80002b46:	00000097          	auipc	ra,0x0
    80002b4a:	db8080e7          	jalr	-584(ra) # 800028fe <iget>
}
    80002b4e:	70e2                	ld	ra,56(sp)
    80002b50:	7442                	ld	s0,48(sp)
    80002b52:	74a2                	ld	s1,40(sp)
    80002b54:	7902                	ld	s2,32(sp)
    80002b56:	69e2                	ld	s3,24(sp)
    80002b58:	6a42                	ld	s4,16(sp)
    80002b5a:	6aa2                	ld	s5,8(sp)
    80002b5c:	6b02                	ld	s6,0(sp)
    80002b5e:	6121                	addi	sp,sp,64
    80002b60:	8082                	ret

0000000080002b62 <iupdate>:
{
    80002b62:	1101                	addi	sp,sp,-32
    80002b64:	ec06                	sd	ra,24(sp)
    80002b66:	e822                	sd	s0,16(sp)
    80002b68:	e426                	sd	s1,8(sp)
    80002b6a:	e04a                	sd	s2,0(sp)
    80002b6c:	1000                	addi	s0,sp,32
    80002b6e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b70:	415c                	lw	a5,4(a0)
    80002b72:	0047d79b          	srliw	a5,a5,0x4
    80002b76:	00018597          	auipc	a1,0x18
    80002b7a:	bfa5a583          	lw	a1,-1030(a1) # 8001a770 <sb+0x18>
    80002b7e:	9dbd                	addw	a1,a1,a5
    80002b80:	4108                	lw	a0,0(a0)
    80002b82:	00000097          	auipc	ra,0x0
    80002b86:	8b2080e7          	jalr	-1870(ra) # 80002434 <bread>
    80002b8a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b8c:	05850793          	addi	a5,a0,88
    80002b90:	40d8                	lw	a4,4(s1)
    80002b92:	8b3d                	andi	a4,a4,15
    80002b94:	071a                	slli	a4,a4,0x6
    80002b96:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b98:	04449703          	lh	a4,68(s1)
    80002b9c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002ba0:	04649703          	lh	a4,70(s1)
    80002ba4:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002ba8:	04849703          	lh	a4,72(s1)
    80002bac:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002bb0:	04a49703          	lh	a4,74(s1)
    80002bb4:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002bb8:	44f8                	lw	a4,76(s1)
    80002bba:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002bbc:	03400613          	li	a2,52
    80002bc0:	05048593          	addi	a1,s1,80
    80002bc4:	00c78513          	addi	a0,a5,12
    80002bc8:	ffffd097          	auipc	ra,0xffffd
    80002bcc:	658080e7          	jalr	1624(ra) # 80000220 <memmove>
  log_write(bp);
    80002bd0:	854a                	mv	a0,s2
    80002bd2:	00001097          	auipc	ra,0x1
    80002bd6:	c06080e7          	jalr	-1018(ra) # 800037d8 <log_write>
  brelse(bp);
    80002bda:	854a                	mv	a0,s2
    80002bdc:	00000097          	auipc	ra,0x0
    80002be0:	988080e7          	jalr	-1656(ra) # 80002564 <brelse>
}
    80002be4:	60e2                	ld	ra,24(sp)
    80002be6:	6442                	ld	s0,16(sp)
    80002be8:	64a2                	ld	s1,8(sp)
    80002bea:	6902                	ld	s2,0(sp)
    80002bec:	6105                	addi	sp,sp,32
    80002bee:	8082                	ret

0000000080002bf0 <idup>:
{
    80002bf0:	1101                	addi	sp,sp,-32
    80002bf2:	ec06                	sd	ra,24(sp)
    80002bf4:	e822                	sd	s0,16(sp)
    80002bf6:	e426                	sd	s1,8(sp)
    80002bf8:	1000                	addi	s0,sp,32
    80002bfa:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bfc:	00018517          	auipc	a0,0x18
    80002c00:	b7c50513          	addi	a0,a0,-1156 # 8001a778 <itable>
    80002c04:	00003097          	auipc	ra,0x3
    80002c08:	712080e7          	jalr	1810(ra) # 80006316 <acquire>
  ip->ref++;
    80002c0c:	449c                	lw	a5,8(s1)
    80002c0e:	2785                	addiw	a5,a5,1
    80002c10:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c12:	00018517          	auipc	a0,0x18
    80002c16:	b6650513          	addi	a0,a0,-1178 # 8001a778 <itable>
    80002c1a:	00003097          	auipc	ra,0x3
    80002c1e:	7b0080e7          	jalr	1968(ra) # 800063ca <release>
}
    80002c22:	8526                	mv	a0,s1
    80002c24:	60e2                	ld	ra,24(sp)
    80002c26:	6442                	ld	s0,16(sp)
    80002c28:	64a2                	ld	s1,8(sp)
    80002c2a:	6105                	addi	sp,sp,32
    80002c2c:	8082                	ret

0000000080002c2e <ilock>:
{
    80002c2e:	1101                	addi	sp,sp,-32
    80002c30:	ec06                	sd	ra,24(sp)
    80002c32:	e822                	sd	s0,16(sp)
    80002c34:	e426                	sd	s1,8(sp)
    80002c36:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c38:	c10d                	beqz	a0,80002c5a <ilock+0x2c>
    80002c3a:	84aa                	mv	s1,a0
    80002c3c:	451c                	lw	a5,8(a0)
    80002c3e:	00f05e63          	blez	a5,80002c5a <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002c42:	0541                	addi	a0,a0,16
    80002c44:	00001097          	auipc	ra,0x1
    80002c48:	cb2080e7          	jalr	-846(ra) # 800038f6 <acquiresleep>
  if(ip->valid == 0){
    80002c4c:	40bc                	lw	a5,64(s1)
    80002c4e:	cf99                	beqz	a5,80002c6c <ilock+0x3e>
}
    80002c50:	60e2                	ld	ra,24(sp)
    80002c52:	6442                	ld	s0,16(sp)
    80002c54:	64a2                	ld	s1,8(sp)
    80002c56:	6105                	addi	sp,sp,32
    80002c58:	8082                	ret
    80002c5a:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002c5c:	00006517          	auipc	a0,0x6
    80002c60:	8b450513          	addi	a0,a0,-1868 # 80008510 <etext+0x510>
    80002c64:	00003097          	auipc	ra,0x3
    80002c68:	138080e7          	jalr	312(ra) # 80005d9c <panic>
    80002c6c:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c6e:	40dc                	lw	a5,4(s1)
    80002c70:	0047d79b          	srliw	a5,a5,0x4
    80002c74:	00018597          	auipc	a1,0x18
    80002c78:	afc5a583          	lw	a1,-1284(a1) # 8001a770 <sb+0x18>
    80002c7c:	9dbd                	addw	a1,a1,a5
    80002c7e:	4088                	lw	a0,0(s1)
    80002c80:	fffff097          	auipc	ra,0xfffff
    80002c84:	7b4080e7          	jalr	1972(ra) # 80002434 <bread>
    80002c88:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c8a:	05850593          	addi	a1,a0,88
    80002c8e:	40dc                	lw	a5,4(s1)
    80002c90:	8bbd                	andi	a5,a5,15
    80002c92:	079a                	slli	a5,a5,0x6
    80002c94:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c96:	00059783          	lh	a5,0(a1)
    80002c9a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c9e:	00259783          	lh	a5,2(a1)
    80002ca2:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002ca6:	00459783          	lh	a5,4(a1)
    80002caa:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002cae:	00659783          	lh	a5,6(a1)
    80002cb2:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002cb6:	459c                	lw	a5,8(a1)
    80002cb8:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cba:	03400613          	li	a2,52
    80002cbe:	05b1                	addi	a1,a1,12
    80002cc0:	05048513          	addi	a0,s1,80
    80002cc4:	ffffd097          	auipc	ra,0xffffd
    80002cc8:	55c080e7          	jalr	1372(ra) # 80000220 <memmove>
    brelse(bp);
    80002ccc:	854a                	mv	a0,s2
    80002cce:	00000097          	auipc	ra,0x0
    80002cd2:	896080e7          	jalr	-1898(ra) # 80002564 <brelse>
    ip->valid = 1;
    80002cd6:	4785                	li	a5,1
    80002cd8:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002cda:	04449783          	lh	a5,68(s1)
    80002cde:	c399                	beqz	a5,80002ce4 <ilock+0xb6>
    80002ce0:	6902                	ld	s2,0(sp)
    80002ce2:	b7bd                	j	80002c50 <ilock+0x22>
      panic("ilock: no type");
    80002ce4:	00006517          	auipc	a0,0x6
    80002ce8:	83450513          	addi	a0,a0,-1996 # 80008518 <etext+0x518>
    80002cec:	00003097          	auipc	ra,0x3
    80002cf0:	0b0080e7          	jalr	176(ra) # 80005d9c <panic>

0000000080002cf4 <iunlock>:
{
    80002cf4:	1101                	addi	sp,sp,-32
    80002cf6:	ec06                	sd	ra,24(sp)
    80002cf8:	e822                	sd	s0,16(sp)
    80002cfa:	e426                	sd	s1,8(sp)
    80002cfc:	e04a                	sd	s2,0(sp)
    80002cfe:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d00:	c905                	beqz	a0,80002d30 <iunlock+0x3c>
    80002d02:	84aa                	mv	s1,a0
    80002d04:	01050913          	addi	s2,a0,16
    80002d08:	854a                	mv	a0,s2
    80002d0a:	00001097          	auipc	ra,0x1
    80002d0e:	c86080e7          	jalr	-890(ra) # 80003990 <holdingsleep>
    80002d12:	cd19                	beqz	a0,80002d30 <iunlock+0x3c>
    80002d14:	449c                	lw	a5,8(s1)
    80002d16:	00f05d63          	blez	a5,80002d30 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d1a:	854a                	mv	a0,s2
    80002d1c:	00001097          	auipc	ra,0x1
    80002d20:	c30080e7          	jalr	-976(ra) # 8000394c <releasesleep>
}
    80002d24:	60e2                	ld	ra,24(sp)
    80002d26:	6442                	ld	s0,16(sp)
    80002d28:	64a2                	ld	s1,8(sp)
    80002d2a:	6902                	ld	s2,0(sp)
    80002d2c:	6105                	addi	sp,sp,32
    80002d2e:	8082                	ret
    panic("iunlock");
    80002d30:	00005517          	auipc	a0,0x5
    80002d34:	7f850513          	addi	a0,a0,2040 # 80008528 <etext+0x528>
    80002d38:	00003097          	auipc	ra,0x3
    80002d3c:	064080e7          	jalr	100(ra) # 80005d9c <panic>

0000000080002d40 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d40:	7179                	addi	sp,sp,-48
    80002d42:	f406                	sd	ra,40(sp)
    80002d44:	f022                	sd	s0,32(sp)
    80002d46:	ec26                	sd	s1,24(sp)
    80002d48:	e84a                	sd	s2,16(sp)
    80002d4a:	e44e                	sd	s3,8(sp)
    80002d4c:	1800                	addi	s0,sp,48
    80002d4e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d50:	05050493          	addi	s1,a0,80
    80002d54:	08050913          	addi	s2,a0,128
    80002d58:	a021                	j	80002d60 <itrunc+0x20>
    80002d5a:	0491                	addi	s1,s1,4
    80002d5c:	01248d63          	beq	s1,s2,80002d76 <itrunc+0x36>
    if(ip->addrs[i]){
    80002d60:	408c                	lw	a1,0(s1)
    80002d62:	dde5                	beqz	a1,80002d5a <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002d64:	0009a503          	lw	a0,0(s3)
    80002d68:	00000097          	auipc	ra,0x0
    80002d6c:	910080e7          	jalr	-1776(ra) # 80002678 <bfree>
      ip->addrs[i] = 0;
    80002d70:	0004a023          	sw	zero,0(s1)
    80002d74:	b7dd                	j	80002d5a <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d76:	0809a583          	lw	a1,128(s3)
    80002d7a:	ed99                	bnez	a1,80002d98 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d7c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d80:	854e                	mv	a0,s3
    80002d82:	00000097          	auipc	ra,0x0
    80002d86:	de0080e7          	jalr	-544(ra) # 80002b62 <iupdate>
}
    80002d8a:	70a2                	ld	ra,40(sp)
    80002d8c:	7402                	ld	s0,32(sp)
    80002d8e:	64e2                	ld	s1,24(sp)
    80002d90:	6942                	ld	s2,16(sp)
    80002d92:	69a2                	ld	s3,8(sp)
    80002d94:	6145                	addi	sp,sp,48
    80002d96:	8082                	ret
    80002d98:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d9a:	0009a503          	lw	a0,0(s3)
    80002d9e:	fffff097          	auipc	ra,0xfffff
    80002da2:	696080e7          	jalr	1686(ra) # 80002434 <bread>
    80002da6:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002da8:	05850493          	addi	s1,a0,88
    80002dac:	45850913          	addi	s2,a0,1112
    80002db0:	a021                	j	80002db8 <itrunc+0x78>
    80002db2:	0491                	addi	s1,s1,4
    80002db4:	01248b63          	beq	s1,s2,80002dca <itrunc+0x8a>
      if(a[j])
    80002db8:	408c                	lw	a1,0(s1)
    80002dba:	dde5                	beqz	a1,80002db2 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002dbc:	0009a503          	lw	a0,0(s3)
    80002dc0:	00000097          	auipc	ra,0x0
    80002dc4:	8b8080e7          	jalr	-1864(ra) # 80002678 <bfree>
    80002dc8:	b7ed                	j	80002db2 <itrunc+0x72>
    brelse(bp);
    80002dca:	8552                	mv	a0,s4
    80002dcc:	fffff097          	auipc	ra,0xfffff
    80002dd0:	798080e7          	jalr	1944(ra) # 80002564 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002dd4:	0809a583          	lw	a1,128(s3)
    80002dd8:	0009a503          	lw	a0,0(s3)
    80002ddc:	00000097          	auipc	ra,0x0
    80002de0:	89c080e7          	jalr	-1892(ra) # 80002678 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002de4:	0809a023          	sw	zero,128(s3)
    80002de8:	6a02                	ld	s4,0(sp)
    80002dea:	bf49                	j	80002d7c <itrunc+0x3c>

0000000080002dec <iput>:
{
    80002dec:	1101                	addi	sp,sp,-32
    80002dee:	ec06                	sd	ra,24(sp)
    80002df0:	e822                	sd	s0,16(sp)
    80002df2:	e426                	sd	s1,8(sp)
    80002df4:	1000                	addi	s0,sp,32
    80002df6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002df8:	00018517          	auipc	a0,0x18
    80002dfc:	98050513          	addi	a0,a0,-1664 # 8001a778 <itable>
    80002e00:	00003097          	auipc	ra,0x3
    80002e04:	516080e7          	jalr	1302(ra) # 80006316 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e08:	4498                	lw	a4,8(s1)
    80002e0a:	4785                	li	a5,1
    80002e0c:	02f70263          	beq	a4,a5,80002e30 <iput+0x44>
  ip->ref--;
    80002e10:	449c                	lw	a5,8(s1)
    80002e12:	37fd                	addiw	a5,a5,-1
    80002e14:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e16:	00018517          	auipc	a0,0x18
    80002e1a:	96250513          	addi	a0,a0,-1694 # 8001a778 <itable>
    80002e1e:	00003097          	auipc	ra,0x3
    80002e22:	5ac080e7          	jalr	1452(ra) # 800063ca <release>
}
    80002e26:	60e2                	ld	ra,24(sp)
    80002e28:	6442                	ld	s0,16(sp)
    80002e2a:	64a2                	ld	s1,8(sp)
    80002e2c:	6105                	addi	sp,sp,32
    80002e2e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e30:	40bc                	lw	a5,64(s1)
    80002e32:	dff9                	beqz	a5,80002e10 <iput+0x24>
    80002e34:	04a49783          	lh	a5,74(s1)
    80002e38:	ffe1                	bnez	a5,80002e10 <iput+0x24>
    80002e3a:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002e3c:	01048913          	addi	s2,s1,16
    80002e40:	854a                	mv	a0,s2
    80002e42:	00001097          	auipc	ra,0x1
    80002e46:	ab4080e7          	jalr	-1356(ra) # 800038f6 <acquiresleep>
    release(&itable.lock);
    80002e4a:	00018517          	auipc	a0,0x18
    80002e4e:	92e50513          	addi	a0,a0,-1746 # 8001a778 <itable>
    80002e52:	00003097          	auipc	ra,0x3
    80002e56:	578080e7          	jalr	1400(ra) # 800063ca <release>
    itrunc(ip);
    80002e5a:	8526                	mv	a0,s1
    80002e5c:	00000097          	auipc	ra,0x0
    80002e60:	ee4080e7          	jalr	-284(ra) # 80002d40 <itrunc>
    ip->type = 0;
    80002e64:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e68:	8526                	mv	a0,s1
    80002e6a:	00000097          	auipc	ra,0x0
    80002e6e:	cf8080e7          	jalr	-776(ra) # 80002b62 <iupdate>
    ip->valid = 0;
    80002e72:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e76:	854a                	mv	a0,s2
    80002e78:	00001097          	auipc	ra,0x1
    80002e7c:	ad4080e7          	jalr	-1324(ra) # 8000394c <releasesleep>
    acquire(&itable.lock);
    80002e80:	00018517          	auipc	a0,0x18
    80002e84:	8f850513          	addi	a0,a0,-1800 # 8001a778 <itable>
    80002e88:	00003097          	auipc	ra,0x3
    80002e8c:	48e080e7          	jalr	1166(ra) # 80006316 <acquire>
    80002e90:	6902                	ld	s2,0(sp)
    80002e92:	bfbd                	j	80002e10 <iput+0x24>

0000000080002e94 <iunlockput>:
{
    80002e94:	1101                	addi	sp,sp,-32
    80002e96:	ec06                	sd	ra,24(sp)
    80002e98:	e822                	sd	s0,16(sp)
    80002e9a:	e426                	sd	s1,8(sp)
    80002e9c:	1000                	addi	s0,sp,32
    80002e9e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002ea0:	00000097          	auipc	ra,0x0
    80002ea4:	e54080e7          	jalr	-428(ra) # 80002cf4 <iunlock>
  iput(ip);
    80002ea8:	8526                	mv	a0,s1
    80002eaa:	00000097          	auipc	ra,0x0
    80002eae:	f42080e7          	jalr	-190(ra) # 80002dec <iput>
}
    80002eb2:	60e2                	ld	ra,24(sp)
    80002eb4:	6442                	ld	s0,16(sp)
    80002eb6:	64a2                	ld	s1,8(sp)
    80002eb8:	6105                	addi	sp,sp,32
    80002eba:	8082                	ret

0000000080002ebc <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ebc:	1141                	addi	sp,sp,-16
    80002ebe:	e422                	sd	s0,8(sp)
    80002ec0:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ec2:	411c                	lw	a5,0(a0)
    80002ec4:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002ec6:	415c                	lw	a5,4(a0)
    80002ec8:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002eca:	04451783          	lh	a5,68(a0)
    80002ece:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ed2:	04a51783          	lh	a5,74(a0)
    80002ed6:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002eda:	04c56783          	lwu	a5,76(a0)
    80002ede:	e99c                	sd	a5,16(a1)
}
    80002ee0:	6422                	ld	s0,8(sp)
    80002ee2:	0141                	addi	sp,sp,16
    80002ee4:	8082                	ret

0000000080002ee6 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ee6:	457c                	lw	a5,76(a0)
    80002ee8:	0ed7ef63          	bltu	a5,a3,80002fe6 <readi+0x100>
{
    80002eec:	7159                	addi	sp,sp,-112
    80002eee:	f486                	sd	ra,104(sp)
    80002ef0:	f0a2                	sd	s0,96(sp)
    80002ef2:	eca6                	sd	s1,88(sp)
    80002ef4:	fc56                	sd	s5,56(sp)
    80002ef6:	f85a                	sd	s6,48(sp)
    80002ef8:	f45e                	sd	s7,40(sp)
    80002efa:	f062                	sd	s8,32(sp)
    80002efc:	1880                	addi	s0,sp,112
    80002efe:	8baa                	mv	s7,a0
    80002f00:	8c2e                	mv	s8,a1
    80002f02:	8ab2                	mv	s5,a2
    80002f04:	84b6                	mv	s1,a3
    80002f06:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f08:	9f35                	addw	a4,a4,a3
    return 0;
    80002f0a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f0c:	0ad76c63          	bltu	a4,a3,80002fc4 <readi+0xde>
    80002f10:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002f12:	00e7f463          	bgeu	a5,a4,80002f1a <readi+0x34>
    n = ip->size - off;
    80002f16:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f1a:	0c0b0463          	beqz	s6,80002fe2 <readi+0xfc>
    80002f1e:	e8ca                	sd	s2,80(sp)
    80002f20:	e0d2                	sd	s4,64(sp)
    80002f22:	ec66                	sd	s9,24(sp)
    80002f24:	e86a                	sd	s10,16(sp)
    80002f26:	e46e                	sd	s11,8(sp)
    80002f28:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f2a:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f2e:	5cfd                	li	s9,-1
    80002f30:	a82d                	j	80002f6a <readi+0x84>
    80002f32:	020a1d93          	slli	s11,s4,0x20
    80002f36:	020ddd93          	srli	s11,s11,0x20
    80002f3a:	05890613          	addi	a2,s2,88
    80002f3e:	86ee                	mv	a3,s11
    80002f40:	963a                	add	a2,a2,a4
    80002f42:	85d6                	mv	a1,s5
    80002f44:	8562                	mv	a0,s8
    80002f46:	fffff097          	auipc	ra,0xfffff
    80002f4a:	9f6080e7          	jalr	-1546(ra) # 8000193c <either_copyout>
    80002f4e:	05950d63          	beq	a0,s9,80002fa8 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f52:	854a                	mv	a0,s2
    80002f54:	fffff097          	auipc	ra,0xfffff
    80002f58:	610080e7          	jalr	1552(ra) # 80002564 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f5c:	013a09bb          	addw	s3,s4,s3
    80002f60:	009a04bb          	addw	s1,s4,s1
    80002f64:	9aee                	add	s5,s5,s11
    80002f66:	0769f863          	bgeu	s3,s6,80002fd6 <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f6a:	000ba903          	lw	s2,0(s7)
    80002f6e:	00a4d59b          	srliw	a1,s1,0xa
    80002f72:	855e                	mv	a0,s7
    80002f74:	00000097          	auipc	ra,0x0
    80002f78:	8ae080e7          	jalr	-1874(ra) # 80002822 <bmap>
    80002f7c:	0005059b          	sext.w	a1,a0
    80002f80:	854a                	mv	a0,s2
    80002f82:	fffff097          	auipc	ra,0xfffff
    80002f86:	4b2080e7          	jalr	1202(ra) # 80002434 <bread>
    80002f8a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f8c:	3ff4f713          	andi	a4,s1,1023
    80002f90:	40ed07bb          	subw	a5,s10,a4
    80002f94:	413b06bb          	subw	a3,s6,s3
    80002f98:	8a3e                	mv	s4,a5
    80002f9a:	2781                	sext.w	a5,a5
    80002f9c:	0006861b          	sext.w	a2,a3
    80002fa0:	f8f679e3          	bgeu	a2,a5,80002f32 <readi+0x4c>
    80002fa4:	8a36                	mv	s4,a3
    80002fa6:	b771                	j	80002f32 <readi+0x4c>
      brelse(bp);
    80002fa8:	854a                	mv	a0,s2
    80002faa:	fffff097          	auipc	ra,0xfffff
    80002fae:	5ba080e7          	jalr	1466(ra) # 80002564 <brelse>
      tot = -1;
    80002fb2:	59fd                	li	s3,-1
      break;
    80002fb4:	6946                	ld	s2,80(sp)
    80002fb6:	6a06                	ld	s4,64(sp)
    80002fb8:	6ce2                	ld	s9,24(sp)
    80002fba:	6d42                	ld	s10,16(sp)
    80002fbc:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002fbe:	0009851b          	sext.w	a0,s3
    80002fc2:	69a6                	ld	s3,72(sp)
}
    80002fc4:	70a6                	ld	ra,104(sp)
    80002fc6:	7406                	ld	s0,96(sp)
    80002fc8:	64e6                	ld	s1,88(sp)
    80002fca:	7ae2                	ld	s5,56(sp)
    80002fcc:	7b42                	ld	s6,48(sp)
    80002fce:	7ba2                	ld	s7,40(sp)
    80002fd0:	7c02                	ld	s8,32(sp)
    80002fd2:	6165                	addi	sp,sp,112
    80002fd4:	8082                	ret
    80002fd6:	6946                	ld	s2,80(sp)
    80002fd8:	6a06                	ld	s4,64(sp)
    80002fda:	6ce2                	ld	s9,24(sp)
    80002fdc:	6d42                	ld	s10,16(sp)
    80002fde:	6da2                	ld	s11,8(sp)
    80002fe0:	bff9                	j	80002fbe <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fe2:	89da                	mv	s3,s6
    80002fe4:	bfe9                	j	80002fbe <readi+0xd8>
    return 0;
    80002fe6:	4501                	li	a0,0
}
    80002fe8:	8082                	ret

0000000080002fea <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fea:	457c                	lw	a5,76(a0)
    80002fec:	10d7ee63          	bltu	a5,a3,80003108 <writei+0x11e>
{
    80002ff0:	7159                	addi	sp,sp,-112
    80002ff2:	f486                	sd	ra,104(sp)
    80002ff4:	f0a2                	sd	s0,96(sp)
    80002ff6:	e8ca                	sd	s2,80(sp)
    80002ff8:	fc56                	sd	s5,56(sp)
    80002ffa:	f85a                	sd	s6,48(sp)
    80002ffc:	f45e                	sd	s7,40(sp)
    80002ffe:	f062                	sd	s8,32(sp)
    80003000:	1880                	addi	s0,sp,112
    80003002:	8b2a                	mv	s6,a0
    80003004:	8c2e                	mv	s8,a1
    80003006:	8ab2                	mv	s5,a2
    80003008:	8936                	mv	s2,a3
    8000300a:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    8000300c:	00e687bb          	addw	a5,a3,a4
    80003010:	0ed7ee63          	bltu	a5,a3,8000310c <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003014:	00043737          	lui	a4,0x43
    80003018:	0ef76c63          	bltu	a4,a5,80003110 <writei+0x126>
    8000301c:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000301e:	0c0b8d63          	beqz	s7,800030f8 <writei+0x10e>
    80003022:	eca6                	sd	s1,88(sp)
    80003024:	e4ce                	sd	s3,72(sp)
    80003026:	ec66                	sd	s9,24(sp)
    80003028:	e86a                	sd	s10,16(sp)
    8000302a:	e46e                	sd	s11,8(sp)
    8000302c:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000302e:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003032:	5cfd                	li	s9,-1
    80003034:	a091                	j	80003078 <writei+0x8e>
    80003036:	02099d93          	slli	s11,s3,0x20
    8000303a:	020ddd93          	srli	s11,s11,0x20
    8000303e:	05848513          	addi	a0,s1,88
    80003042:	86ee                	mv	a3,s11
    80003044:	8656                	mv	a2,s5
    80003046:	85e2                	mv	a1,s8
    80003048:	953a                	add	a0,a0,a4
    8000304a:	fffff097          	auipc	ra,0xfffff
    8000304e:	948080e7          	jalr	-1720(ra) # 80001992 <either_copyin>
    80003052:	07950263          	beq	a0,s9,800030b6 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003056:	8526                	mv	a0,s1
    80003058:	00000097          	auipc	ra,0x0
    8000305c:	780080e7          	jalr	1920(ra) # 800037d8 <log_write>
    brelse(bp);
    80003060:	8526                	mv	a0,s1
    80003062:	fffff097          	auipc	ra,0xfffff
    80003066:	502080e7          	jalr	1282(ra) # 80002564 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000306a:	01498a3b          	addw	s4,s3,s4
    8000306e:	0129893b          	addw	s2,s3,s2
    80003072:	9aee                	add	s5,s5,s11
    80003074:	057a7663          	bgeu	s4,s7,800030c0 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003078:	000b2483          	lw	s1,0(s6)
    8000307c:	00a9559b          	srliw	a1,s2,0xa
    80003080:	855a                	mv	a0,s6
    80003082:	fffff097          	auipc	ra,0xfffff
    80003086:	7a0080e7          	jalr	1952(ra) # 80002822 <bmap>
    8000308a:	0005059b          	sext.w	a1,a0
    8000308e:	8526                	mv	a0,s1
    80003090:	fffff097          	auipc	ra,0xfffff
    80003094:	3a4080e7          	jalr	932(ra) # 80002434 <bread>
    80003098:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000309a:	3ff97713          	andi	a4,s2,1023
    8000309e:	40ed07bb          	subw	a5,s10,a4
    800030a2:	414b86bb          	subw	a3,s7,s4
    800030a6:	89be                	mv	s3,a5
    800030a8:	2781                	sext.w	a5,a5
    800030aa:	0006861b          	sext.w	a2,a3
    800030ae:	f8f674e3          	bgeu	a2,a5,80003036 <writei+0x4c>
    800030b2:	89b6                	mv	s3,a3
    800030b4:	b749                	j	80003036 <writei+0x4c>
      brelse(bp);
    800030b6:	8526                	mv	a0,s1
    800030b8:	fffff097          	auipc	ra,0xfffff
    800030bc:	4ac080e7          	jalr	1196(ra) # 80002564 <brelse>
  }

  if(off > ip->size)
    800030c0:	04cb2783          	lw	a5,76(s6)
    800030c4:	0327fc63          	bgeu	a5,s2,800030fc <writei+0x112>
    ip->size = off;
    800030c8:	052b2623          	sw	s2,76(s6)
    800030cc:	64e6                	ld	s1,88(sp)
    800030ce:	69a6                	ld	s3,72(sp)
    800030d0:	6ce2                	ld	s9,24(sp)
    800030d2:	6d42                	ld	s10,16(sp)
    800030d4:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030d6:	855a                	mv	a0,s6
    800030d8:	00000097          	auipc	ra,0x0
    800030dc:	a8a080e7          	jalr	-1398(ra) # 80002b62 <iupdate>

  return tot;
    800030e0:	000a051b          	sext.w	a0,s4
    800030e4:	6a06                	ld	s4,64(sp)
}
    800030e6:	70a6                	ld	ra,104(sp)
    800030e8:	7406                	ld	s0,96(sp)
    800030ea:	6946                	ld	s2,80(sp)
    800030ec:	7ae2                	ld	s5,56(sp)
    800030ee:	7b42                	ld	s6,48(sp)
    800030f0:	7ba2                	ld	s7,40(sp)
    800030f2:	7c02                	ld	s8,32(sp)
    800030f4:	6165                	addi	sp,sp,112
    800030f6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030f8:	8a5e                	mv	s4,s7
    800030fa:	bff1                	j	800030d6 <writei+0xec>
    800030fc:	64e6                	ld	s1,88(sp)
    800030fe:	69a6                	ld	s3,72(sp)
    80003100:	6ce2                	ld	s9,24(sp)
    80003102:	6d42                	ld	s10,16(sp)
    80003104:	6da2                	ld	s11,8(sp)
    80003106:	bfc1                	j	800030d6 <writei+0xec>
    return -1;
    80003108:	557d                	li	a0,-1
}
    8000310a:	8082                	ret
    return -1;
    8000310c:	557d                	li	a0,-1
    8000310e:	bfe1                	j	800030e6 <writei+0xfc>
    return -1;
    80003110:	557d                	li	a0,-1
    80003112:	bfd1                	j	800030e6 <writei+0xfc>

0000000080003114 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003114:	1141                	addi	sp,sp,-16
    80003116:	e406                	sd	ra,8(sp)
    80003118:	e022                	sd	s0,0(sp)
    8000311a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000311c:	4639                	li	a2,14
    8000311e:	ffffd097          	auipc	ra,0xffffd
    80003122:	176080e7          	jalr	374(ra) # 80000294 <strncmp>
}
    80003126:	60a2                	ld	ra,8(sp)
    80003128:	6402                	ld	s0,0(sp)
    8000312a:	0141                	addi	sp,sp,16
    8000312c:	8082                	ret

000000008000312e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000312e:	7139                	addi	sp,sp,-64
    80003130:	fc06                	sd	ra,56(sp)
    80003132:	f822                	sd	s0,48(sp)
    80003134:	f426                	sd	s1,40(sp)
    80003136:	f04a                	sd	s2,32(sp)
    80003138:	ec4e                	sd	s3,24(sp)
    8000313a:	e852                	sd	s4,16(sp)
    8000313c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000313e:	04451703          	lh	a4,68(a0)
    80003142:	4785                	li	a5,1
    80003144:	00f71a63          	bne	a4,a5,80003158 <dirlookup+0x2a>
    80003148:	892a                	mv	s2,a0
    8000314a:	89ae                	mv	s3,a1
    8000314c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000314e:	457c                	lw	a5,76(a0)
    80003150:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003152:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003154:	e79d                	bnez	a5,80003182 <dirlookup+0x54>
    80003156:	a8a5                	j	800031ce <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003158:	00005517          	auipc	a0,0x5
    8000315c:	3d850513          	addi	a0,a0,984 # 80008530 <etext+0x530>
    80003160:	00003097          	auipc	ra,0x3
    80003164:	c3c080e7          	jalr	-964(ra) # 80005d9c <panic>
      panic("dirlookup read");
    80003168:	00005517          	auipc	a0,0x5
    8000316c:	3e050513          	addi	a0,a0,992 # 80008548 <etext+0x548>
    80003170:	00003097          	auipc	ra,0x3
    80003174:	c2c080e7          	jalr	-980(ra) # 80005d9c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003178:	24c1                	addiw	s1,s1,16
    8000317a:	04c92783          	lw	a5,76(s2)
    8000317e:	04f4f763          	bgeu	s1,a5,800031cc <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003182:	4741                	li	a4,16
    80003184:	86a6                	mv	a3,s1
    80003186:	fc040613          	addi	a2,s0,-64
    8000318a:	4581                	li	a1,0
    8000318c:	854a                	mv	a0,s2
    8000318e:	00000097          	auipc	ra,0x0
    80003192:	d58080e7          	jalr	-680(ra) # 80002ee6 <readi>
    80003196:	47c1                	li	a5,16
    80003198:	fcf518e3          	bne	a0,a5,80003168 <dirlookup+0x3a>
    if(de.inum == 0)
    8000319c:	fc045783          	lhu	a5,-64(s0)
    800031a0:	dfe1                	beqz	a5,80003178 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031a2:	fc240593          	addi	a1,s0,-62
    800031a6:	854e                	mv	a0,s3
    800031a8:	00000097          	auipc	ra,0x0
    800031ac:	f6c080e7          	jalr	-148(ra) # 80003114 <namecmp>
    800031b0:	f561                	bnez	a0,80003178 <dirlookup+0x4a>
      if(poff)
    800031b2:	000a0463          	beqz	s4,800031ba <dirlookup+0x8c>
        *poff = off;
    800031b6:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031ba:	fc045583          	lhu	a1,-64(s0)
    800031be:	00092503          	lw	a0,0(s2)
    800031c2:	fffff097          	auipc	ra,0xfffff
    800031c6:	73c080e7          	jalr	1852(ra) # 800028fe <iget>
    800031ca:	a011                	j	800031ce <dirlookup+0xa0>
  return 0;
    800031cc:	4501                	li	a0,0
}
    800031ce:	70e2                	ld	ra,56(sp)
    800031d0:	7442                	ld	s0,48(sp)
    800031d2:	74a2                	ld	s1,40(sp)
    800031d4:	7902                	ld	s2,32(sp)
    800031d6:	69e2                	ld	s3,24(sp)
    800031d8:	6a42                	ld	s4,16(sp)
    800031da:	6121                	addi	sp,sp,64
    800031dc:	8082                	ret

00000000800031de <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031de:	711d                	addi	sp,sp,-96
    800031e0:	ec86                	sd	ra,88(sp)
    800031e2:	e8a2                	sd	s0,80(sp)
    800031e4:	e4a6                	sd	s1,72(sp)
    800031e6:	e0ca                	sd	s2,64(sp)
    800031e8:	fc4e                	sd	s3,56(sp)
    800031ea:	f852                	sd	s4,48(sp)
    800031ec:	f456                	sd	s5,40(sp)
    800031ee:	f05a                	sd	s6,32(sp)
    800031f0:	ec5e                	sd	s7,24(sp)
    800031f2:	e862                	sd	s8,16(sp)
    800031f4:	e466                	sd	s9,8(sp)
    800031f6:	1080                	addi	s0,sp,96
    800031f8:	84aa                	mv	s1,a0
    800031fa:	8b2e                	mv	s6,a1
    800031fc:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031fe:	00054703          	lbu	a4,0(a0)
    80003202:	02f00793          	li	a5,47
    80003206:	02f70263          	beq	a4,a5,8000322a <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000320a:	ffffe097          	auipc	ra,0xffffe
    8000320e:	cbc080e7          	jalr	-836(ra) # 80000ec6 <myproc>
    80003212:	15053503          	ld	a0,336(a0)
    80003216:	00000097          	auipc	ra,0x0
    8000321a:	9da080e7          	jalr	-1574(ra) # 80002bf0 <idup>
    8000321e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003220:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003224:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003226:	4b85                	li	s7,1
    80003228:	a875                	j	800032e4 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000322a:	4585                	li	a1,1
    8000322c:	4505                	li	a0,1
    8000322e:	fffff097          	auipc	ra,0xfffff
    80003232:	6d0080e7          	jalr	1744(ra) # 800028fe <iget>
    80003236:	8a2a                	mv	s4,a0
    80003238:	b7e5                	j	80003220 <namex+0x42>
      iunlockput(ip);
    8000323a:	8552                	mv	a0,s4
    8000323c:	00000097          	auipc	ra,0x0
    80003240:	c58080e7          	jalr	-936(ra) # 80002e94 <iunlockput>
      return 0;
    80003244:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003246:	8552                	mv	a0,s4
    80003248:	60e6                	ld	ra,88(sp)
    8000324a:	6446                	ld	s0,80(sp)
    8000324c:	64a6                	ld	s1,72(sp)
    8000324e:	6906                	ld	s2,64(sp)
    80003250:	79e2                	ld	s3,56(sp)
    80003252:	7a42                	ld	s4,48(sp)
    80003254:	7aa2                	ld	s5,40(sp)
    80003256:	7b02                	ld	s6,32(sp)
    80003258:	6be2                	ld	s7,24(sp)
    8000325a:	6c42                	ld	s8,16(sp)
    8000325c:	6ca2                	ld	s9,8(sp)
    8000325e:	6125                	addi	sp,sp,96
    80003260:	8082                	ret
      iunlock(ip);
    80003262:	8552                	mv	a0,s4
    80003264:	00000097          	auipc	ra,0x0
    80003268:	a90080e7          	jalr	-1392(ra) # 80002cf4 <iunlock>
      return ip;
    8000326c:	bfe9                	j	80003246 <namex+0x68>
      iunlockput(ip);
    8000326e:	8552                	mv	a0,s4
    80003270:	00000097          	auipc	ra,0x0
    80003274:	c24080e7          	jalr	-988(ra) # 80002e94 <iunlockput>
      return 0;
    80003278:	8a4e                	mv	s4,s3
    8000327a:	b7f1                	j	80003246 <namex+0x68>
  len = path - s;
    8000327c:	40998633          	sub	a2,s3,s1
    80003280:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003284:	099c5863          	bge	s8,s9,80003314 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003288:	4639                	li	a2,14
    8000328a:	85a6                	mv	a1,s1
    8000328c:	8556                	mv	a0,s5
    8000328e:	ffffd097          	auipc	ra,0xffffd
    80003292:	f92080e7          	jalr	-110(ra) # 80000220 <memmove>
    80003296:	84ce                	mv	s1,s3
  while(*path == '/')
    80003298:	0004c783          	lbu	a5,0(s1)
    8000329c:	01279763          	bne	a5,s2,800032aa <namex+0xcc>
    path++;
    800032a0:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032a2:	0004c783          	lbu	a5,0(s1)
    800032a6:	ff278de3          	beq	a5,s2,800032a0 <namex+0xc2>
    ilock(ip);
    800032aa:	8552                	mv	a0,s4
    800032ac:	00000097          	auipc	ra,0x0
    800032b0:	982080e7          	jalr	-1662(ra) # 80002c2e <ilock>
    if(ip->type != T_DIR){
    800032b4:	044a1783          	lh	a5,68(s4)
    800032b8:	f97791e3          	bne	a5,s7,8000323a <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800032bc:	000b0563          	beqz	s6,800032c6 <namex+0xe8>
    800032c0:	0004c783          	lbu	a5,0(s1)
    800032c4:	dfd9                	beqz	a5,80003262 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032c6:	4601                	li	a2,0
    800032c8:	85d6                	mv	a1,s5
    800032ca:	8552                	mv	a0,s4
    800032cc:	00000097          	auipc	ra,0x0
    800032d0:	e62080e7          	jalr	-414(ra) # 8000312e <dirlookup>
    800032d4:	89aa                	mv	s3,a0
    800032d6:	dd41                	beqz	a0,8000326e <namex+0x90>
    iunlockput(ip);
    800032d8:	8552                	mv	a0,s4
    800032da:	00000097          	auipc	ra,0x0
    800032de:	bba080e7          	jalr	-1094(ra) # 80002e94 <iunlockput>
    ip = next;
    800032e2:	8a4e                	mv	s4,s3
  while(*path == '/')
    800032e4:	0004c783          	lbu	a5,0(s1)
    800032e8:	01279763          	bne	a5,s2,800032f6 <namex+0x118>
    path++;
    800032ec:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032ee:	0004c783          	lbu	a5,0(s1)
    800032f2:	ff278de3          	beq	a5,s2,800032ec <namex+0x10e>
  if(*path == 0)
    800032f6:	cb9d                	beqz	a5,8000332c <namex+0x14e>
  while(*path != '/' && *path != 0)
    800032f8:	0004c783          	lbu	a5,0(s1)
    800032fc:	89a6                	mv	s3,s1
  len = path - s;
    800032fe:	4c81                	li	s9,0
    80003300:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003302:	01278963          	beq	a5,s2,80003314 <namex+0x136>
    80003306:	dbbd                	beqz	a5,8000327c <namex+0x9e>
    path++;
    80003308:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000330a:	0009c783          	lbu	a5,0(s3)
    8000330e:	ff279ce3          	bne	a5,s2,80003306 <namex+0x128>
    80003312:	b7ad                	j	8000327c <namex+0x9e>
    memmove(name, s, len);
    80003314:	2601                	sext.w	a2,a2
    80003316:	85a6                	mv	a1,s1
    80003318:	8556                	mv	a0,s5
    8000331a:	ffffd097          	auipc	ra,0xffffd
    8000331e:	f06080e7          	jalr	-250(ra) # 80000220 <memmove>
    name[len] = 0;
    80003322:	9cd6                	add	s9,s9,s5
    80003324:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003328:	84ce                	mv	s1,s3
    8000332a:	b7bd                	j	80003298 <namex+0xba>
  if(nameiparent){
    8000332c:	f00b0de3          	beqz	s6,80003246 <namex+0x68>
    iput(ip);
    80003330:	8552                	mv	a0,s4
    80003332:	00000097          	auipc	ra,0x0
    80003336:	aba080e7          	jalr	-1350(ra) # 80002dec <iput>
    return 0;
    8000333a:	4a01                	li	s4,0
    8000333c:	b729                	j	80003246 <namex+0x68>

000000008000333e <dirlink>:
{
    8000333e:	7139                	addi	sp,sp,-64
    80003340:	fc06                	sd	ra,56(sp)
    80003342:	f822                	sd	s0,48(sp)
    80003344:	f04a                	sd	s2,32(sp)
    80003346:	ec4e                	sd	s3,24(sp)
    80003348:	e852                	sd	s4,16(sp)
    8000334a:	0080                	addi	s0,sp,64
    8000334c:	892a                	mv	s2,a0
    8000334e:	8a2e                	mv	s4,a1
    80003350:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003352:	4601                	li	a2,0
    80003354:	00000097          	auipc	ra,0x0
    80003358:	dda080e7          	jalr	-550(ra) # 8000312e <dirlookup>
    8000335c:	ed25                	bnez	a0,800033d4 <dirlink+0x96>
    8000335e:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003360:	04c92483          	lw	s1,76(s2)
    80003364:	c49d                	beqz	s1,80003392 <dirlink+0x54>
    80003366:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003368:	4741                	li	a4,16
    8000336a:	86a6                	mv	a3,s1
    8000336c:	fc040613          	addi	a2,s0,-64
    80003370:	4581                	li	a1,0
    80003372:	854a                	mv	a0,s2
    80003374:	00000097          	auipc	ra,0x0
    80003378:	b72080e7          	jalr	-1166(ra) # 80002ee6 <readi>
    8000337c:	47c1                	li	a5,16
    8000337e:	06f51163          	bne	a0,a5,800033e0 <dirlink+0xa2>
    if(de.inum == 0)
    80003382:	fc045783          	lhu	a5,-64(s0)
    80003386:	c791                	beqz	a5,80003392 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003388:	24c1                	addiw	s1,s1,16
    8000338a:	04c92783          	lw	a5,76(s2)
    8000338e:	fcf4ede3          	bltu	s1,a5,80003368 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003392:	4639                	li	a2,14
    80003394:	85d2                	mv	a1,s4
    80003396:	fc240513          	addi	a0,s0,-62
    8000339a:	ffffd097          	auipc	ra,0xffffd
    8000339e:	f30080e7          	jalr	-208(ra) # 800002ca <strncpy>
  de.inum = inum;
    800033a2:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033a6:	4741                	li	a4,16
    800033a8:	86a6                	mv	a3,s1
    800033aa:	fc040613          	addi	a2,s0,-64
    800033ae:	4581                	li	a1,0
    800033b0:	854a                	mv	a0,s2
    800033b2:	00000097          	auipc	ra,0x0
    800033b6:	c38080e7          	jalr	-968(ra) # 80002fea <writei>
    800033ba:	872a                	mv	a4,a0
    800033bc:	47c1                	li	a5,16
  return 0;
    800033be:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033c0:	02f71863          	bne	a4,a5,800033f0 <dirlink+0xb2>
    800033c4:	74a2                	ld	s1,40(sp)
}
    800033c6:	70e2                	ld	ra,56(sp)
    800033c8:	7442                	ld	s0,48(sp)
    800033ca:	7902                	ld	s2,32(sp)
    800033cc:	69e2                	ld	s3,24(sp)
    800033ce:	6a42                	ld	s4,16(sp)
    800033d0:	6121                	addi	sp,sp,64
    800033d2:	8082                	ret
    iput(ip);
    800033d4:	00000097          	auipc	ra,0x0
    800033d8:	a18080e7          	jalr	-1512(ra) # 80002dec <iput>
    return -1;
    800033dc:	557d                	li	a0,-1
    800033de:	b7e5                	j	800033c6 <dirlink+0x88>
      panic("dirlink read");
    800033e0:	00005517          	auipc	a0,0x5
    800033e4:	17850513          	addi	a0,a0,376 # 80008558 <etext+0x558>
    800033e8:	00003097          	auipc	ra,0x3
    800033ec:	9b4080e7          	jalr	-1612(ra) # 80005d9c <panic>
    panic("dirlink");
    800033f0:	00005517          	auipc	a0,0x5
    800033f4:	27050513          	addi	a0,a0,624 # 80008660 <etext+0x660>
    800033f8:	00003097          	auipc	ra,0x3
    800033fc:	9a4080e7          	jalr	-1628(ra) # 80005d9c <panic>

0000000080003400 <namei>:

struct inode*
namei(char *path)
{
    80003400:	1101                	addi	sp,sp,-32
    80003402:	ec06                	sd	ra,24(sp)
    80003404:	e822                	sd	s0,16(sp)
    80003406:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003408:	fe040613          	addi	a2,s0,-32
    8000340c:	4581                	li	a1,0
    8000340e:	00000097          	auipc	ra,0x0
    80003412:	dd0080e7          	jalr	-560(ra) # 800031de <namex>
}
    80003416:	60e2                	ld	ra,24(sp)
    80003418:	6442                	ld	s0,16(sp)
    8000341a:	6105                	addi	sp,sp,32
    8000341c:	8082                	ret

000000008000341e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000341e:	1141                	addi	sp,sp,-16
    80003420:	e406                	sd	ra,8(sp)
    80003422:	e022                	sd	s0,0(sp)
    80003424:	0800                	addi	s0,sp,16
    80003426:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003428:	4585                	li	a1,1
    8000342a:	00000097          	auipc	ra,0x0
    8000342e:	db4080e7          	jalr	-588(ra) # 800031de <namex>
}
    80003432:	60a2                	ld	ra,8(sp)
    80003434:	6402                	ld	s0,0(sp)
    80003436:	0141                	addi	sp,sp,16
    80003438:	8082                	ret

000000008000343a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000343a:	1101                	addi	sp,sp,-32
    8000343c:	ec06                	sd	ra,24(sp)
    8000343e:	e822                	sd	s0,16(sp)
    80003440:	e426                	sd	s1,8(sp)
    80003442:	e04a                	sd	s2,0(sp)
    80003444:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003446:	00019917          	auipc	s2,0x19
    8000344a:	dda90913          	addi	s2,s2,-550 # 8001c220 <log>
    8000344e:	01892583          	lw	a1,24(s2)
    80003452:	02892503          	lw	a0,40(s2)
    80003456:	fffff097          	auipc	ra,0xfffff
    8000345a:	fde080e7          	jalr	-34(ra) # 80002434 <bread>
    8000345e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003460:	02c92603          	lw	a2,44(s2)
    80003464:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003466:	00c05f63          	blez	a2,80003484 <write_head+0x4a>
    8000346a:	00019717          	auipc	a4,0x19
    8000346e:	de670713          	addi	a4,a4,-538 # 8001c250 <log+0x30>
    80003472:	87aa                	mv	a5,a0
    80003474:	060a                	slli	a2,a2,0x2
    80003476:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003478:	4314                	lw	a3,0(a4)
    8000347a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000347c:	0711                	addi	a4,a4,4
    8000347e:	0791                	addi	a5,a5,4
    80003480:	fec79ce3          	bne	a5,a2,80003478 <write_head+0x3e>
  }
  bwrite(buf);
    80003484:	8526                	mv	a0,s1
    80003486:	fffff097          	auipc	ra,0xfffff
    8000348a:	0a0080e7          	jalr	160(ra) # 80002526 <bwrite>
  brelse(buf);
    8000348e:	8526                	mv	a0,s1
    80003490:	fffff097          	auipc	ra,0xfffff
    80003494:	0d4080e7          	jalr	212(ra) # 80002564 <brelse>
}
    80003498:	60e2                	ld	ra,24(sp)
    8000349a:	6442                	ld	s0,16(sp)
    8000349c:	64a2                	ld	s1,8(sp)
    8000349e:	6902                	ld	s2,0(sp)
    800034a0:	6105                	addi	sp,sp,32
    800034a2:	8082                	ret

00000000800034a4 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034a4:	00019797          	auipc	a5,0x19
    800034a8:	da87a783          	lw	a5,-600(a5) # 8001c24c <log+0x2c>
    800034ac:	0af05d63          	blez	a5,80003566 <install_trans+0xc2>
{
    800034b0:	7139                	addi	sp,sp,-64
    800034b2:	fc06                	sd	ra,56(sp)
    800034b4:	f822                	sd	s0,48(sp)
    800034b6:	f426                	sd	s1,40(sp)
    800034b8:	f04a                	sd	s2,32(sp)
    800034ba:	ec4e                	sd	s3,24(sp)
    800034bc:	e852                	sd	s4,16(sp)
    800034be:	e456                	sd	s5,8(sp)
    800034c0:	e05a                	sd	s6,0(sp)
    800034c2:	0080                	addi	s0,sp,64
    800034c4:	8b2a                	mv	s6,a0
    800034c6:	00019a97          	auipc	s5,0x19
    800034ca:	d8aa8a93          	addi	s5,s5,-630 # 8001c250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034ce:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034d0:	00019997          	auipc	s3,0x19
    800034d4:	d5098993          	addi	s3,s3,-688 # 8001c220 <log>
    800034d8:	a00d                	j	800034fa <install_trans+0x56>
    brelse(lbuf);
    800034da:	854a                	mv	a0,s2
    800034dc:	fffff097          	auipc	ra,0xfffff
    800034e0:	088080e7          	jalr	136(ra) # 80002564 <brelse>
    brelse(dbuf);
    800034e4:	8526                	mv	a0,s1
    800034e6:	fffff097          	auipc	ra,0xfffff
    800034ea:	07e080e7          	jalr	126(ra) # 80002564 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034ee:	2a05                	addiw	s4,s4,1
    800034f0:	0a91                	addi	s5,s5,4
    800034f2:	02c9a783          	lw	a5,44(s3)
    800034f6:	04fa5e63          	bge	s4,a5,80003552 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034fa:	0189a583          	lw	a1,24(s3)
    800034fe:	014585bb          	addw	a1,a1,s4
    80003502:	2585                	addiw	a1,a1,1
    80003504:	0289a503          	lw	a0,40(s3)
    80003508:	fffff097          	auipc	ra,0xfffff
    8000350c:	f2c080e7          	jalr	-212(ra) # 80002434 <bread>
    80003510:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003512:	000aa583          	lw	a1,0(s5)
    80003516:	0289a503          	lw	a0,40(s3)
    8000351a:	fffff097          	auipc	ra,0xfffff
    8000351e:	f1a080e7          	jalr	-230(ra) # 80002434 <bread>
    80003522:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003524:	40000613          	li	a2,1024
    80003528:	05890593          	addi	a1,s2,88
    8000352c:	05850513          	addi	a0,a0,88
    80003530:	ffffd097          	auipc	ra,0xffffd
    80003534:	cf0080e7          	jalr	-784(ra) # 80000220 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003538:	8526                	mv	a0,s1
    8000353a:	fffff097          	auipc	ra,0xfffff
    8000353e:	fec080e7          	jalr	-20(ra) # 80002526 <bwrite>
    if(recovering == 0)
    80003542:	f80b1ce3          	bnez	s6,800034da <install_trans+0x36>
      bunpin(dbuf);
    80003546:	8526                	mv	a0,s1
    80003548:	fffff097          	auipc	ra,0xfffff
    8000354c:	0f4080e7          	jalr	244(ra) # 8000263c <bunpin>
    80003550:	b769                	j	800034da <install_trans+0x36>
}
    80003552:	70e2                	ld	ra,56(sp)
    80003554:	7442                	ld	s0,48(sp)
    80003556:	74a2                	ld	s1,40(sp)
    80003558:	7902                	ld	s2,32(sp)
    8000355a:	69e2                	ld	s3,24(sp)
    8000355c:	6a42                	ld	s4,16(sp)
    8000355e:	6aa2                	ld	s5,8(sp)
    80003560:	6b02                	ld	s6,0(sp)
    80003562:	6121                	addi	sp,sp,64
    80003564:	8082                	ret
    80003566:	8082                	ret

0000000080003568 <initlog>:
{
    80003568:	7179                	addi	sp,sp,-48
    8000356a:	f406                	sd	ra,40(sp)
    8000356c:	f022                	sd	s0,32(sp)
    8000356e:	ec26                	sd	s1,24(sp)
    80003570:	e84a                	sd	s2,16(sp)
    80003572:	e44e                	sd	s3,8(sp)
    80003574:	1800                	addi	s0,sp,48
    80003576:	892a                	mv	s2,a0
    80003578:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000357a:	00019497          	auipc	s1,0x19
    8000357e:	ca648493          	addi	s1,s1,-858 # 8001c220 <log>
    80003582:	00005597          	auipc	a1,0x5
    80003586:	fe658593          	addi	a1,a1,-26 # 80008568 <etext+0x568>
    8000358a:	8526                	mv	a0,s1
    8000358c:	00003097          	auipc	ra,0x3
    80003590:	cfa080e7          	jalr	-774(ra) # 80006286 <initlock>
  log.start = sb->logstart;
    80003594:	0149a583          	lw	a1,20(s3)
    80003598:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000359a:	0109a783          	lw	a5,16(s3)
    8000359e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035a0:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035a4:	854a                	mv	a0,s2
    800035a6:	fffff097          	auipc	ra,0xfffff
    800035aa:	e8e080e7          	jalr	-370(ra) # 80002434 <bread>
  log.lh.n = lh->n;
    800035ae:	4d30                	lw	a2,88(a0)
    800035b0:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035b2:	00c05f63          	blez	a2,800035d0 <initlog+0x68>
    800035b6:	87aa                	mv	a5,a0
    800035b8:	00019717          	auipc	a4,0x19
    800035bc:	c9870713          	addi	a4,a4,-872 # 8001c250 <log+0x30>
    800035c0:	060a                	slli	a2,a2,0x2
    800035c2:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800035c4:	4ff4                	lw	a3,92(a5)
    800035c6:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035c8:	0791                	addi	a5,a5,4
    800035ca:	0711                	addi	a4,a4,4
    800035cc:	fec79ce3          	bne	a5,a2,800035c4 <initlog+0x5c>
  brelse(buf);
    800035d0:	fffff097          	auipc	ra,0xfffff
    800035d4:	f94080e7          	jalr	-108(ra) # 80002564 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035d8:	4505                	li	a0,1
    800035da:	00000097          	auipc	ra,0x0
    800035de:	eca080e7          	jalr	-310(ra) # 800034a4 <install_trans>
  log.lh.n = 0;
    800035e2:	00019797          	auipc	a5,0x19
    800035e6:	c607a523          	sw	zero,-918(a5) # 8001c24c <log+0x2c>
  write_head(); // clear the log
    800035ea:	00000097          	auipc	ra,0x0
    800035ee:	e50080e7          	jalr	-432(ra) # 8000343a <write_head>
}
    800035f2:	70a2                	ld	ra,40(sp)
    800035f4:	7402                	ld	s0,32(sp)
    800035f6:	64e2                	ld	s1,24(sp)
    800035f8:	6942                	ld	s2,16(sp)
    800035fa:	69a2                	ld	s3,8(sp)
    800035fc:	6145                	addi	sp,sp,48
    800035fe:	8082                	ret

0000000080003600 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003600:	1101                	addi	sp,sp,-32
    80003602:	ec06                	sd	ra,24(sp)
    80003604:	e822                	sd	s0,16(sp)
    80003606:	e426                	sd	s1,8(sp)
    80003608:	e04a                	sd	s2,0(sp)
    8000360a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000360c:	00019517          	auipc	a0,0x19
    80003610:	c1450513          	addi	a0,a0,-1004 # 8001c220 <log>
    80003614:	00003097          	auipc	ra,0x3
    80003618:	d02080e7          	jalr	-766(ra) # 80006316 <acquire>
  while(1){
    if(log.committing){
    8000361c:	00019497          	auipc	s1,0x19
    80003620:	c0448493          	addi	s1,s1,-1020 # 8001c220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003624:	4979                	li	s2,30
    80003626:	a039                	j	80003634 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003628:	85a6                	mv	a1,s1
    8000362a:	8526                	mv	a0,s1
    8000362c:	ffffe097          	auipc	ra,0xffffe
    80003630:	f6c080e7          	jalr	-148(ra) # 80001598 <sleep>
    if(log.committing){
    80003634:	50dc                	lw	a5,36(s1)
    80003636:	fbed                	bnez	a5,80003628 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003638:	5098                	lw	a4,32(s1)
    8000363a:	2705                	addiw	a4,a4,1
    8000363c:	0027179b          	slliw	a5,a4,0x2
    80003640:	9fb9                	addw	a5,a5,a4
    80003642:	0017979b          	slliw	a5,a5,0x1
    80003646:	54d4                	lw	a3,44(s1)
    80003648:	9fb5                	addw	a5,a5,a3
    8000364a:	00f95963          	bge	s2,a5,8000365c <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000364e:	85a6                	mv	a1,s1
    80003650:	8526                	mv	a0,s1
    80003652:	ffffe097          	auipc	ra,0xffffe
    80003656:	f46080e7          	jalr	-186(ra) # 80001598 <sleep>
    8000365a:	bfe9                	j	80003634 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000365c:	00019517          	auipc	a0,0x19
    80003660:	bc450513          	addi	a0,a0,-1084 # 8001c220 <log>
    80003664:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003666:	00003097          	auipc	ra,0x3
    8000366a:	d64080e7          	jalr	-668(ra) # 800063ca <release>
      break;
    }
  }
}
    8000366e:	60e2                	ld	ra,24(sp)
    80003670:	6442                	ld	s0,16(sp)
    80003672:	64a2                	ld	s1,8(sp)
    80003674:	6902                	ld	s2,0(sp)
    80003676:	6105                	addi	sp,sp,32
    80003678:	8082                	ret

000000008000367a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000367a:	7139                	addi	sp,sp,-64
    8000367c:	fc06                	sd	ra,56(sp)
    8000367e:	f822                	sd	s0,48(sp)
    80003680:	f426                	sd	s1,40(sp)
    80003682:	f04a                	sd	s2,32(sp)
    80003684:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003686:	00019497          	auipc	s1,0x19
    8000368a:	b9a48493          	addi	s1,s1,-1126 # 8001c220 <log>
    8000368e:	8526                	mv	a0,s1
    80003690:	00003097          	auipc	ra,0x3
    80003694:	c86080e7          	jalr	-890(ra) # 80006316 <acquire>
  log.outstanding -= 1;
    80003698:	509c                	lw	a5,32(s1)
    8000369a:	37fd                	addiw	a5,a5,-1
    8000369c:	0007891b          	sext.w	s2,a5
    800036a0:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036a2:	50dc                	lw	a5,36(s1)
    800036a4:	e7b9                	bnez	a5,800036f2 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    800036a6:	06091163          	bnez	s2,80003708 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800036aa:	00019497          	auipc	s1,0x19
    800036ae:	b7648493          	addi	s1,s1,-1162 # 8001c220 <log>
    800036b2:	4785                	li	a5,1
    800036b4:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036b6:	8526                	mv	a0,s1
    800036b8:	00003097          	auipc	ra,0x3
    800036bc:	d12080e7          	jalr	-750(ra) # 800063ca <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036c0:	54dc                	lw	a5,44(s1)
    800036c2:	06f04763          	bgtz	a5,80003730 <end_op+0xb6>
    acquire(&log.lock);
    800036c6:	00019497          	auipc	s1,0x19
    800036ca:	b5a48493          	addi	s1,s1,-1190 # 8001c220 <log>
    800036ce:	8526                	mv	a0,s1
    800036d0:	00003097          	auipc	ra,0x3
    800036d4:	c46080e7          	jalr	-954(ra) # 80006316 <acquire>
    log.committing = 0;
    800036d8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036dc:	8526                	mv	a0,s1
    800036de:	ffffe097          	auipc	ra,0xffffe
    800036e2:	046080e7          	jalr	70(ra) # 80001724 <wakeup>
    release(&log.lock);
    800036e6:	8526                	mv	a0,s1
    800036e8:	00003097          	auipc	ra,0x3
    800036ec:	ce2080e7          	jalr	-798(ra) # 800063ca <release>
}
    800036f0:	a815                	j	80003724 <end_op+0xaa>
    800036f2:	ec4e                	sd	s3,24(sp)
    800036f4:	e852                	sd	s4,16(sp)
    800036f6:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800036f8:	00005517          	auipc	a0,0x5
    800036fc:	e7850513          	addi	a0,a0,-392 # 80008570 <etext+0x570>
    80003700:	00002097          	auipc	ra,0x2
    80003704:	69c080e7          	jalr	1692(ra) # 80005d9c <panic>
    wakeup(&log);
    80003708:	00019497          	auipc	s1,0x19
    8000370c:	b1848493          	addi	s1,s1,-1256 # 8001c220 <log>
    80003710:	8526                	mv	a0,s1
    80003712:	ffffe097          	auipc	ra,0xffffe
    80003716:	012080e7          	jalr	18(ra) # 80001724 <wakeup>
  release(&log.lock);
    8000371a:	8526                	mv	a0,s1
    8000371c:	00003097          	auipc	ra,0x3
    80003720:	cae080e7          	jalr	-850(ra) # 800063ca <release>
}
    80003724:	70e2                	ld	ra,56(sp)
    80003726:	7442                	ld	s0,48(sp)
    80003728:	74a2                	ld	s1,40(sp)
    8000372a:	7902                	ld	s2,32(sp)
    8000372c:	6121                	addi	sp,sp,64
    8000372e:	8082                	ret
    80003730:	ec4e                	sd	s3,24(sp)
    80003732:	e852                	sd	s4,16(sp)
    80003734:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003736:	00019a97          	auipc	s5,0x19
    8000373a:	b1aa8a93          	addi	s5,s5,-1254 # 8001c250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000373e:	00019a17          	auipc	s4,0x19
    80003742:	ae2a0a13          	addi	s4,s4,-1310 # 8001c220 <log>
    80003746:	018a2583          	lw	a1,24(s4)
    8000374a:	012585bb          	addw	a1,a1,s2
    8000374e:	2585                	addiw	a1,a1,1
    80003750:	028a2503          	lw	a0,40(s4)
    80003754:	fffff097          	auipc	ra,0xfffff
    80003758:	ce0080e7          	jalr	-800(ra) # 80002434 <bread>
    8000375c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000375e:	000aa583          	lw	a1,0(s5)
    80003762:	028a2503          	lw	a0,40(s4)
    80003766:	fffff097          	auipc	ra,0xfffff
    8000376a:	cce080e7          	jalr	-818(ra) # 80002434 <bread>
    8000376e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003770:	40000613          	li	a2,1024
    80003774:	05850593          	addi	a1,a0,88
    80003778:	05848513          	addi	a0,s1,88
    8000377c:	ffffd097          	auipc	ra,0xffffd
    80003780:	aa4080e7          	jalr	-1372(ra) # 80000220 <memmove>
    bwrite(to);  // write the log
    80003784:	8526                	mv	a0,s1
    80003786:	fffff097          	auipc	ra,0xfffff
    8000378a:	da0080e7          	jalr	-608(ra) # 80002526 <bwrite>
    brelse(from);
    8000378e:	854e                	mv	a0,s3
    80003790:	fffff097          	auipc	ra,0xfffff
    80003794:	dd4080e7          	jalr	-556(ra) # 80002564 <brelse>
    brelse(to);
    80003798:	8526                	mv	a0,s1
    8000379a:	fffff097          	auipc	ra,0xfffff
    8000379e:	dca080e7          	jalr	-566(ra) # 80002564 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037a2:	2905                	addiw	s2,s2,1
    800037a4:	0a91                	addi	s5,s5,4
    800037a6:	02ca2783          	lw	a5,44(s4)
    800037aa:	f8f94ee3          	blt	s2,a5,80003746 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037ae:	00000097          	auipc	ra,0x0
    800037b2:	c8c080e7          	jalr	-884(ra) # 8000343a <write_head>
    install_trans(0); // Now install writes to home locations
    800037b6:	4501                	li	a0,0
    800037b8:	00000097          	auipc	ra,0x0
    800037bc:	cec080e7          	jalr	-788(ra) # 800034a4 <install_trans>
    log.lh.n = 0;
    800037c0:	00019797          	auipc	a5,0x19
    800037c4:	a807a623          	sw	zero,-1396(a5) # 8001c24c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037c8:	00000097          	auipc	ra,0x0
    800037cc:	c72080e7          	jalr	-910(ra) # 8000343a <write_head>
    800037d0:	69e2                	ld	s3,24(sp)
    800037d2:	6a42                	ld	s4,16(sp)
    800037d4:	6aa2                	ld	s5,8(sp)
    800037d6:	bdc5                	j	800036c6 <end_op+0x4c>

00000000800037d8 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037d8:	1101                	addi	sp,sp,-32
    800037da:	ec06                	sd	ra,24(sp)
    800037dc:	e822                	sd	s0,16(sp)
    800037de:	e426                	sd	s1,8(sp)
    800037e0:	e04a                	sd	s2,0(sp)
    800037e2:	1000                	addi	s0,sp,32
    800037e4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037e6:	00019917          	auipc	s2,0x19
    800037ea:	a3a90913          	addi	s2,s2,-1478 # 8001c220 <log>
    800037ee:	854a                	mv	a0,s2
    800037f0:	00003097          	auipc	ra,0x3
    800037f4:	b26080e7          	jalr	-1242(ra) # 80006316 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037f8:	02c92603          	lw	a2,44(s2)
    800037fc:	47f5                	li	a5,29
    800037fe:	06c7c563          	blt	a5,a2,80003868 <log_write+0x90>
    80003802:	00019797          	auipc	a5,0x19
    80003806:	a3a7a783          	lw	a5,-1478(a5) # 8001c23c <log+0x1c>
    8000380a:	37fd                	addiw	a5,a5,-1
    8000380c:	04f65e63          	bge	a2,a5,80003868 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003810:	00019797          	auipc	a5,0x19
    80003814:	a307a783          	lw	a5,-1488(a5) # 8001c240 <log+0x20>
    80003818:	06f05063          	blez	a5,80003878 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000381c:	4781                	li	a5,0
    8000381e:	06c05563          	blez	a2,80003888 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003822:	44cc                	lw	a1,12(s1)
    80003824:	00019717          	auipc	a4,0x19
    80003828:	a2c70713          	addi	a4,a4,-1492 # 8001c250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000382c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000382e:	4314                	lw	a3,0(a4)
    80003830:	04b68c63          	beq	a3,a1,80003888 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003834:	2785                	addiw	a5,a5,1
    80003836:	0711                	addi	a4,a4,4
    80003838:	fef61be3          	bne	a2,a5,8000382e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000383c:	0621                	addi	a2,a2,8
    8000383e:	060a                	slli	a2,a2,0x2
    80003840:	00019797          	auipc	a5,0x19
    80003844:	9e078793          	addi	a5,a5,-1568 # 8001c220 <log>
    80003848:	97b2                	add	a5,a5,a2
    8000384a:	44d8                	lw	a4,12(s1)
    8000384c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000384e:	8526                	mv	a0,s1
    80003850:	fffff097          	auipc	ra,0xfffff
    80003854:	db0080e7          	jalr	-592(ra) # 80002600 <bpin>
    log.lh.n++;
    80003858:	00019717          	auipc	a4,0x19
    8000385c:	9c870713          	addi	a4,a4,-1592 # 8001c220 <log>
    80003860:	575c                	lw	a5,44(a4)
    80003862:	2785                	addiw	a5,a5,1
    80003864:	d75c                	sw	a5,44(a4)
    80003866:	a82d                	j	800038a0 <log_write+0xc8>
    panic("too big a transaction");
    80003868:	00005517          	auipc	a0,0x5
    8000386c:	d1850513          	addi	a0,a0,-744 # 80008580 <etext+0x580>
    80003870:	00002097          	auipc	ra,0x2
    80003874:	52c080e7          	jalr	1324(ra) # 80005d9c <panic>
    panic("log_write outside of trans");
    80003878:	00005517          	auipc	a0,0x5
    8000387c:	d2050513          	addi	a0,a0,-736 # 80008598 <etext+0x598>
    80003880:	00002097          	auipc	ra,0x2
    80003884:	51c080e7          	jalr	1308(ra) # 80005d9c <panic>
  log.lh.block[i] = b->blockno;
    80003888:	00878693          	addi	a3,a5,8
    8000388c:	068a                	slli	a3,a3,0x2
    8000388e:	00019717          	auipc	a4,0x19
    80003892:	99270713          	addi	a4,a4,-1646 # 8001c220 <log>
    80003896:	9736                	add	a4,a4,a3
    80003898:	44d4                	lw	a3,12(s1)
    8000389a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000389c:	faf609e3          	beq	a2,a5,8000384e <log_write+0x76>
  }
  release(&log.lock);
    800038a0:	00019517          	auipc	a0,0x19
    800038a4:	98050513          	addi	a0,a0,-1664 # 8001c220 <log>
    800038a8:	00003097          	auipc	ra,0x3
    800038ac:	b22080e7          	jalr	-1246(ra) # 800063ca <release>
}
    800038b0:	60e2                	ld	ra,24(sp)
    800038b2:	6442                	ld	s0,16(sp)
    800038b4:	64a2                	ld	s1,8(sp)
    800038b6:	6902                	ld	s2,0(sp)
    800038b8:	6105                	addi	sp,sp,32
    800038ba:	8082                	ret

00000000800038bc <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038bc:	1101                	addi	sp,sp,-32
    800038be:	ec06                	sd	ra,24(sp)
    800038c0:	e822                	sd	s0,16(sp)
    800038c2:	e426                	sd	s1,8(sp)
    800038c4:	e04a                	sd	s2,0(sp)
    800038c6:	1000                	addi	s0,sp,32
    800038c8:	84aa                	mv	s1,a0
    800038ca:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038cc:	00005597          	auipc	a1,0x5
    800038d0:	cec58593          	addi	a1,a1,-788 # 800085b8 <etext+0x5b8>
    800038d4:	0521                	addi	a0,a0,8
    800038d6:	00003097          	auipc	ra,0x3
    800038da:	9b0080e7          	jalr	-1616(ra) # 80006286 <initlock>
  lk->name = name;
    800038de:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038e2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038e6:	0204a423          	sw	zero,40(s1)
}
    800038ea:	60e2                	ld	ra,24(sp)
    800038ec:	6442                	ld	s0,16(sp)
    800038ee:	64a2                	ld	s1,8(sp)
    800038f0:	6902                	ld	s2,0(sp)
    800038f2:	6105                	addi	sp,sp,32
    800038f4:	8082                	ret

00000000800038f6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038f6:	1101                	addi	sp,sp,-32
    800038f8:	ec06                	sd	ra,24(sp)
    800038fa:	e822                	sd	s0,16(sp)
    800038fc:	e426                	sd	s1,8(sp)
    800038fe:	e04a                	sd	s2,0(sp)
    80003900:	1000                	addi	s0,sp,32
    80003902:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003904:	00850913          	addi	s2,a0,8
    80003908:	854a                	mv	a0,s2
    8000390a:	00003097          	auipc	ra,0x3
    8000390e:	a0c080e7          	jalr	-1524(ra) # 80006316 <acquire>
  while (lk->locked) {
    80003912:	409c                	lw	a5,0(s1)
    80003914:	cb89                	beqz	a5,80003926 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003916:	85ca                	mv	a1,s2
    80003918:	8526                	mv	a0,s1
    8000391a:	ffffe097          	auipc	ra,0xffffe
    8000391e:	c7e080e7          	jalr	-898(ra) # 80001598 <sleep>
  while (lk->locked) {
    80003922:	409c                	lw	a5,0(s1)
    80003924:	fbed                	bnez	a5,80003916 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003926:	4785                	li	a5,1
    80003928:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000392a:	ffffd097          	auipc	ra,0xffffd
    8000392e:	59c080e7          	jalr	1436(ra) # 80000ec6 <myproc>
    80003932:	591c                	lw	a5,48(a0)
    80003934:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003936:	854a                	mv	a0,s2
    80003938:	00003097          	auipc	ra,0x3
    8000393c:	a92080e7          	jalr	-1390(ra) # 800063ca <release>
}
    80003940:	60e2                	ld	ra,24(sp)
    80003942:	6442                	ld	s0,16(sp)
    80003944:	64a2                	ld	s1,8(sp)
    80003946:	6902                	ld	s2,0(sp)
    80003948:	6105                	addi	sp,sp,32
    8000394a:	8082                	ret

000000008000394c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000394c:	1101                	addi	sp,sp,-32
    8000394e:	ec06                	sd	ra,24(sp)
    80003950:	e822                	sd	s0,16(sp)
    80003952:	e426                	sd	s1,8(sp)
    80003954:	e04a                	sd	s2,0(sp)
    80003956:	1000                	addi	s0,sp,32
    80003958:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000395a:	00850913          	addi	s2,a0,8
    8000395e:	854a                	mv	a0,s2
    80003960:	00003097          	auipc	ra,0x3
    80003964:	9b6080e7          	jalr	-1610(ra) # 80006316 <acquire>
  lk->locked = 0;
    80003968:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000396c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003970:	8526                	mv	a0,s1
    80003972:	ffffe097          	auipc	ra,0xffffe
    80003976:	db2080e7          	jalr	-590(ra) # 80001724 <wakeup>
  release(&lk->lk);
    8000397a:	854a                	mv	a0,s2
    8000397c:	00003097          	auipc	ra,0x3
    80003980:	a4e080e7          	jalr	-1458(ra) # 800063ca <release>
}
    80003984:	60e2                	ld	ra,24(sp)
    80003986:	6442                	ld	s0,16(sp)
    80003988:	64a2                	ld	s1,8(sp)
    8000398a:	6902                	ld	s2,0(sp)
    8000398c:	6105                	addi	sp,sp,32
    8000398e:	8082                	ret

0000000080003990 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003990:	7179                	addi	sp,sp,-48
    80003992:	f406                	sd	ra,40(sp)
    80003994:	f022                	sd	s0,32(sp)
    80003996:	ec26                	sd	s1,24(sp)
    80003998:	e84a                	sd	s2,16(sp)
    8000399a:	1800                	addi	s0,sp,48
    8000399c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000399e:	00850913          	addi	s2,a0,8
    800039a2:	854a                	mv	a0,s2
    800039a4:	00003097          	auipc	ra,0x3
    800039a8:	972080e7          	jalr	-1678(ra) # 80006316 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039ac:	409c                	lw	a5,0(s1)
    800039ae:	ef91                	bnez	a5,800039ca <holdingsleep+0x3a>
    800039b0:	4481                	li	s1,0
  release(&lk->lk);
    800039b2:	854a                	mv	a0,s2
    800039b4:	00003097          	auipc	ra,0x3
    800039b8:	a16080e7          	jalr	-1514(ra) # 800063ca <release>
  return r;
}
    800039bc:	8526                	mv	a0,s1
    800039be:	70a2                	ld	ra,40(sp)
    800039c0:	7402                	ld	s0,32(sp)
    800039c2:	64e2                	ld	s1,24(sp)
    800039c4:	6942                	ld	s2,16(sp)
    800039c6:	6145                	addi	sp,sp,48
    800039c8:	8082                	ret
    800039ca:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800039cc:	0284a983          	lw	s3,40(s1)
    800039d0:	ffffd097          	auipc	ra,0xffffd
    800039d4:	4f6080e7          	jalr	1270(ra) # 80000ec6 <myproc>
    800039d8:	5904                	lw	s1,48(a0)
    800039da:	413484b3          	sub	s1,s1,s3
    800039de:	0014b493          	seqz	s1,s1
    800039e2:	69a2                	ld	s3,8(sp)
    800039e4:	b7f9                	j	800039b2 <holdingsleep+0x22>

00000000800039e6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039e6:	1141                	addi	sp,sp,-16
    800039e8:	e406                	sd	ra,8(sp)
    800039ea:	e022                	sd	s0,0(sp)
    800039ec:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039ee:	00005597          	auipc	a1,0x5
    800039f2:	bda58593          	addi	a1,a1,-1062 # 800085c8 <etext+0x5c8>
    800039f6:	00019517          	auipc	a0,0x19
    800039fa:	97250513          	addi	a0,a0,-1678 # 8001c368 <ftable>
    800039fe:	00003097          	auipc	ra,0x3
    80003a02:	888080e7          	jalr	-1912(ra) # 80006286 <initlock>
}
    80003a06:	60a2                	ld	ra,8(sp)
    80003a08:	6402                	ld	s0,0(sp)
    80003a0a:	0141                	addi	sp,sp,16
    80003a0c:	8082                	ret

0000000080003a0e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a0e:	1101                	addi	sp,sp,-32
    80003a10:	ec06                	sd	ra,24(sp)
    80003a12:	e822                	sd	s0,16(sp)
    80003a14:	e426                	sd	s1,8(sp)
    80003a16:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a18:	00019517          	auipc	a0,0x19
    80003a1c:	95050513          	addi	a0,a0,-1712 # 8001c368 <ftable>
    80003a20:	00003097          	auipc	ra,0x3
    80003a24:	8f6080e7          	jalr	-1802(ra) # 80006316 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a28:	00019497          	auipc	s1,0x19
    80003a2c:	95848493          	addi	s1,s1,-1704 # 8001c380 <ftable+0x18>
    80003a30:	0001a717          	auipc	a4,0x1a
    80003a34:	8f070713          	addi	a4,a4,-1808 # 8001d320 <ftable+0xfb8>
    if(f->ref == 0){
    80003a38:	40dc                	lw	a5,4(s1)
    80003a3a:	cf99                	beqz	a5,80003a58 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a3c:	02848493          	addi	s1,s1,40
    80003a40:	fee49ce3          	bne	s1,a4,80003a38 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a44:	00019517          	auipc	a0,0x19
    80003a48:	92450513          	addi	a0,a0,-1756 # 8001c368 <ftable>
    80003a4c:	00003097          	auipc	ra,0x3
    80003a50:	97e080e7          	jalr	-1666(ra) # 800063ca <release>
  return 0;
    80003a54:	4481                	li	s1,0
    80003a56:	a819                	j	80003a6c <filealloc+0x5e>
      f->ref = 1;
    80003a58:	4785                	li	a5,1
    80003a5a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a5c:	00019517          	auipc	a0,0x19
    80003a60:	90c50513          	addi	a0,a0,-1780 # 8001c368 <ftable>
    80003a64:	00003097          	auipc	ra,0x3
    80003a68:	966080e7          	jalr	-1690(ra) # 800063ca <release>
}
    80003a6c:	8526                	mv	a0,s1
    80003a6e:	60e2                	ld	ra,24(sp)
    80003a70:	6442                	ld	s0,16(sp)
    80003a72:	64a2                	ld	s1,8(sp)
    80003a74:	6105                	addi	sp,sp,32
    80003a76:	8082                	ret

0000000080003a78 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a78:	1101                	addi	sp,sp,-32
    80003a7a:	ec06                	sd	ra,24(sp)
    80003a7c:	e822                	sd	s0,16(sp)
    80003a7e:	e426                	sd	s1,8(sp)
    80003a80:	1000                	addi	s0,sp,32
    80003a82:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a84:	00019517          	auipc	a0,0x19
    80003a88:	8e450513          	addi	a0,a0,-1820 # 8001c368 <ftable>
    80003a8c:	00003097          	auipc	ra,0x3
    80003a90:	88a080e7          	jalr	-1910(ra) # 80006316 <acquire>
  if(f->ref < 1)
    80003a94:	40dc                	lw	a5,4(s1)
    80003a96:	02f05263          	blez	a5,80003aba <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a9a:	2785                	addiw	a5,a5,1
    80003a9c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a9e:	00019517          	auipc	a0,0x19
    80003aa2:	8ca50513          	addi	a0,a0,-1846 # 8001c368 <ftable>
    80003aa6:	00003097          	auipc	ra,0x3
    80003aaa:	924080e7          	jalr	-1756(ra) # 800063ca <release>
  return f;
}
    80003aae:	8526                	mv	a0,s1
    80003ab0:	60e2                	ld	ra,24(sp)
    80003ab2:	6442                	ld	s0,16(sp)
    80003ab4:	64a2                	ld	s1,8(sp)
    80003ab6:	6105                	addi	sp,sp,32
    80003ab8:	8082                	ret
    panic("filedup");
    80003aba:	00005517          	auipc	a0,0x5
    80003abe:	b1650513          	addi	a0,a0,-1258 # 800085d0 <etext+0x5d0>
    80003ac2:	00002097          	auipc	ra,0x2
    80003ac6:	2da080e7          	jalr	730(ra) # 80005d9c <panic>

0000000080003aca <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003aca:	7139                	addi	sp,sp,-64
    80003acc:	fc06                	sd	ra,56(sp)
    80003ace:	f822                	sd	s0,48(sp)
    80003ad0:	f426                	sd	s1,40(sp)
    80003ad2:	0080                	addi	s0,sp,64
    80003ad4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003ad6:	00019517          	auipc	a0,0x19
    80003ada:	89250513          	addi	a0,a0,-1902 # 8001c368 <ftable>
    80003ade:	00003097          	auipc	ra,0x3
    80003ae2:	838080e7          	jalr	-1992(ra) # 80006316 <acquire>
  if(f->ref < 1)
    80003ae6:	40dc                	lw	a5,4(s1)
    80003ae8:	04f05c63          	blez	a5,80003b40 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003aec:	37fd                	addiw	a5,a5,-1
    80003aee:	0007871b          	sext.w	a4,a5
    80003af2:	c0dc                	sw	a5,4(s1)
    80003af4:	06e04263          	bgtz	a4,80003b58 <fileclose+0x8e>
    80003af8:	f04a                	sd	s2,32(sp)
    80003afa:	ec4e                	sd	s3,24(sp)
    80003afc:	e852                	sd	s4,16(sp)
    80003afe:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b00:	0004a903          	lw	s2,0(s1)
    80003b04:	0094ca83          	lbu	s5,9(s1)
    80003b08:	0104ba03          	ld	s4,16(s1)
    80003b0c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b10:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b14:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b18:	00019517          	auipc	a0,0x19
    80003b1c:	85050513          	addi	a0,a0,-1968 # 8001c368 <ftable>
    80003b20:	00003097          	auipc	ra,0x3
    80003b24:	8aa080e7          	jalr	-1878(ra) # 800063ca <release>

  if(ff.type == FD_PIPE){
    80003b28:	4785                	li	a5,1
    80003b2a:	04f90463          	beq	s2,a5,80003b72 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b2e:	3979                	addiw	s2,s2,-2
    80003b30:	4785                	li	a5,1
    80003b32:	0527fb63          	bgeu	a5,s2,80003b88 <fileclose+0xbe>
    80003b36:	7902                	ld	s2,32(sp)
    80003b38:	69e2                	ld	s3,24(sp)
    80003b3a:	6a42                	ld	s4,16(sp)
    80003b3c:	6aa2                	ld	s5,8(sp)
    80003b3e:	a02d                	j	80003b68 <fileclose+0x9e>
    80003b40:	f04a                	sd	s2,32(sp)
    80003b42:	ec4e                	sd	s3,24(sp)
    80003b44:	e852                	sd	s4,16(sp)
    80003b46:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003b48:	00005517          	auipc	a0,0x5
    80003b4c:	a9050513          	addi	a0,a0,-1392 # 800085d8 <etext+0x5d8>
    80003b50:	00002097          	auipc	ra,0x2
    80003b54:	24c080e7          	jalr	588(ra) # 80005d9c <panic>
    release(&ftable.lock);
    80003b58:	00019517          	auipc	a0,0x19
    80003b5c:	81050513          	addi	a0,a0,-2032 # 8001c368 <ftable>
    80003b60:	00003097          	auipc	ra,0x3
    80003b64:	86a080e7          	jalr	-1942(ra) # 800063ca <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003b68:	70e2                	ld	ra,56(sp)
    80003b6a:	7442                	ld	s0,48(sp)
    80003b6c:	74a2                	ld	s1,40(sp)
    80003b6e:	6121                	addi	sp,sp,64
    80003b70:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b72:	85d6                	mv	a1,s5
    80003b74:	8552                	mv	a0,s4
    80003b76:	00000097          	auipc	ra,0x0
    80003b7a:	3a2080e7          	jalr	930(ra) # 80003f18 <pipeclose>
    80003b7e:	7902                	ld	s2,32(sp)
    80003b80:	69e2                	ld	s3,24(sp)
    80003b82:	6a42                	ld	s4,16(sp)
    80003b84:	6aa2                	ld	s5,8(sp)
    80003b86:	b7cd                	j	80003b68 <fileclose+0x9e>
    begin_op();
    80003b88:	00000097          	auipc	ra,0x0
    80003b8c:	a78080e7          	jalr	-1416(ra) # 80003600 <begin_op>
    iput(ff.ip);
    80003b90:	854e                	mv	a0,s3
    80003b92:	fffff097          	auipc	ra,0xfffff
    80003b96:	25a080e7          	jalr	602(ra) # 80002dec <iput>
    end_op();
    80003b9a:	00000097          	auipc	ra,0x0
    80003b9e:	ae0080e7          	jalr	-1312(ra) # 8000367a <end_op>
    80003ba2:	7902                	ld	s2,32(sp)
    80003ba4:	69e2                	ld	s3,24(sp)
    80003ba6:	6a42                	ld	s4,16(sp)
    80003ba8:	6aa2                	ld	s5,8(sp)
    80003baa:	bf7d                	j	80003b68 <fileclose+0x9e>

0000000080003bac <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bac:	715d                	addi	sp,sp,-80
    80003bae:	e486                	sd	ra,72(sp)
    80003bb0:	e0a2                	sd	s0,64(sp)
    80003bb2:	fc26                	sd	s1,56(sp)
    80003bb4:	f44e                	sd	s3,40(sp)
    80003bb6:	0880                	addi	s0,sp,80
    80003bb8:	84aa                	mv	s1,a0
    80003bba:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003bbc:	ffffd097          	auipc	ra,0xffffd
    80003bc0:	30a080e7          	jalr	778(ra) # 80000ec6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bc4:	409c                	lw	a5,0(s1)
    80003bc6:	37f9                	addiw	a5,a5,-2
    80003bc8:	4705                	li	a4,1
    80003bca:	04f76863          	bltu	a4,a5,80003c1a <filestat+0x6e>
    80003bce:	f84a                	sd	s2,48(sp)
    80003bd0:	892a                	mv	s2,a0
    ilock(f->ip);
    80003bd2:	6c88                	ld	a0,24(s1)
    80003bd4:	fffff097          	auipc	ra,0xfffff
    80003bd8:	05a080e7          	jalr	90(ra) # 80002c2e <ilock>
    stati(f->ip, &st);
    80003bdc:	fb840593          	addi	a1,s0,-72
    80003be0:	6c88                	ld	a0,24(s1)
    80003be2:	fffff097          	auipc	ra,0xfffff
    80003be6:	2da080e7          	jalr	730(ra) # 80002ebc <stati>
    iunlock(f->ip);
    80003bea:	6c88                	ld	a0,24(s1)
    80003bec:	fffff097          	auipc	ra,0xfffff
    80003bf0:	108080e7          	jalr	264(ra) # 80002cf4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bf4:	46e1                	li	a3,24
    80003bf6:	fb840613          	addi	a2,s0,-72
    80003bfa:	85ce                	mv	a1,s3
    80003bfc:	05093503          	ld	a0,80(s2)
    80003c00:	ffffd097          	auipc	ra,0xffffd
    80003c04:	f62080e7          	jalr	-158(ra) # 80000b62 <copyout>
    80003c08:	41f5551b          	sraiw	a0,a0,0x1f
    80003c0c:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003c0e:	60a6                	ld	ra,72(sp)
    80003c10:	6406                	ld	s0,64(sp)
    80003c12:	74e2                	ld	s1,56(sp)
    80003c14:	79a2                	ld	s3,40(sp)
    80003c16:	6161                	addi	sp,sp,80
    80003c18:	8082                	ret
  return -1;
    80003c1a:	557d                	li	a0,-1
    80003c1c:	bfcd                	j	80003c0e <filestat+0x62>

0000000080003c1e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c1e:	7179                	addi	sp,sp,-48
    80003c20:	f406                	sd	ra,40(sp)
    80003c22:	f022                	sd	s0,32(sp)
    80003c24:	e84a                	sd	s2,16(sp)
    80003c26:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c28:	00854783          	lbu	a5,8(a0)
    80003c2c:	cbc5                	beqz	a5,80003cdc <fileread+0xbe>
    80003c2e:	ec26                	sd	s1,24(sp)
    80003c30:	e44e                	sd	s3,8(sp)
    80003c32:	84aa                	mv	s1,a0
    80003c34:	89ae                	mv	s3,a1
    80003c36:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c38:	411c                	lw	a5,0(a0)
    80003c3a:	4705                	li	a4,1
    80003c3c:	04e78963          	beq	a5,a4,80003c8e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c40:	470d                	li	a4,3
    80003c42:	04e78f63          	beq	a5,a4,80003ca0 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c46:	4709                	li	a4,2
    80003c48:	08e79263          	bne	a5,a4,80003ccc <fileread+0xae>
    ilock(f->ip);
    80003c4c:	6d08                	ld	a0,24(a0)
    80003c4e:	fffff097          	auipc	ra,0xfffff
    80003c52:	fe0080e7          	jalr	-32(ra) # 80002c2e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c56:	874a                	mv	a4,s2
    80003c58:	5094                	lw	a3,32(s1)
    80003c5a:	864e                	mv	a2,s3
    80003c5c:	4585                	li	a1,1
    80003c5e:	6c88                	ld	a0,24(s1)
    80003c60:	fffff097          	auipc	ra,0xfffff
    80003c64:	286080e7          	jalr	646(ra) # 80002ee6 <readi>
    80003c68:	892a                	mv	s2,a0
    80003c6a:	00a05563          	blez	a0,80003c74 <fileread+0x56>
      f->off += r;
    80003c6e:	509c                	lw	a5,32(s1)
    80003c70:	9fa9                	addw	a5,a5,a0
    80003c72:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c74:	6c88                	ld	a0,24(s1)
    80003c76:	fffff097          	auipc	ra,0xfffff
    80003c7a:	07e080e7          	jalr	126(ra) # 80002cf4 <iunlock>
    80003c7e:	64e2                	ld	s1,24(sp)
    80003c80:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003c82:	854a                	mv	a0,s2
    80003c84:	70a2                	ld	ra,40(sp)
    80003c86:	7402                	ld	s0,32(sp)
    80003c88:	6942                	ld	s2,16(sp)
    80003c8a:	6145                	addi	sp,sp,48
    80003c8c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c8e:	6908                	ld	a0,16(a0)
    80003c90:	00000097          	auipc	ra,0x0
    80003c94:	3fa080e7          	jalr	1018(ra) # 8000408a <piperead>
    80003c98:	892a                	mv	s2,a0
    80003c9a:	64e2                	ld	s1,24(sp)
    80003c9c:	69a2                	ld	s3,8(sp)
    80003c9e:	b7d5                	j	80003c82 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003ca0:	02451783          	lh	a5,36(a0)
    80003ca4:	03079693          	slli	a3,a5,0x30
    80003ca8:	92c1                	srli	a3,a3,0x30
    80003caa:	4725                	li	a4,9
    80003cac:	02d76a63          	bltu	a4,a3,80003ce0 <fileread+0xc2>
    80003cb0:	0792                	slli	a5,a5,0x4
    80003cb2:	00018717          	auipc	a4,0x18
    80003cb6:	61670713          	addi	a4,a4,1558 # 8001c2c8 <devsw>
    80003cba:	97ba                	add	a5,a5,a4
    80003cbc:	639c                	ld	a5,0(a5)
    80003cbe:	c78d                	beqz	a5,80003ce8 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003cc0:	4505                	li	a0,1
    80003cc2:	9782                	jalr	a5
    80003cc4:	892a                	mv	s2,a0
    80003cc6:	64e2                	ld	s1,24(sp)
    80003cc8:	69a2                	ld	s3,8(sp)
    80003cca:	bf65                	j	80003c82 <fileread+0x64>
    panic("fileread");
    80003ccc:	00005517          	auipc	a0,0x5
    80003cd0:	91c50513          	addi	a0,a0,-1764 # 800085e8 <etext+0x5e8>
    80003cd4:	00002097          	auipc	ra,0x2
    80003cd8:	0c8080e7          	jalr	200(ra) # 80005d9c <panic>
    return -1;
    80003cdc:	597d                	li	s2,-1
    80003cde:	b755                	j	80003c82 <fileread+0x64>
      return -1;
    80003ce0:	597d                	li	s2,-1
    80003ce2:	64e2                	ld	s1,24(sp)
    80003ce4:	69a2                	ld	s3,8(sp)
    80003ce6:	bf71                	j	80003c82 <fileread+0x64>
    80003ce8:	597d                	li	s2,-1
    80003cea:	64e2                	ld	s1,24(sp)
    80003cec:	69a2                	ld	s3,8(sp)
    80003cee:	bf51                	j	80003c82 <fileread+0x64>

0000000080003cf0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003cf0:	00954783          	lbu	a5,9(a0)
    80003cf4:	12078963          	beqz	a5,80003e26 <filewrite+0x136>
{
    80003cf8:	715d                	addi	sp,sp,-80
    80003cfa:	e486                	sd	ra,72(sp)
    80003cfc:	e0a2                	sd	s0,64(sp)
    80003cfe:	f84a                	sd	s2,48(sp)
    80003d00:	f052                	sd	s4,32(sp)
    80003d02:	e85a                	sd	s6,16(sp)
    80003d04:	0880                	addi	s0,sp,80
    80003d06:	892a                	mv	s2,a0
    80003d08:	8b2e                	mv	s6,a1
    80003d0a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d0c:	411c                	lw	a5,0(a0)
    80003d0e:	4705                	li	a4,1
    80003d10:	02e78763          	beq	a5,a4,80003d3e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d14:	470d                	li	a4,3
    80003d16:	02e78a63          	beq	a5,a4,80003d4a <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d1a:	4709                	li	a4,2
    80003d1c:	0ee79863          	bne	a5,a4,80003e0c <filewrite+0x11c>
    80003d20:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d22:	0cc05463          	blez	a2,80003dea <filewrite+0xfa>
    80003d26:	fc26                	sd	s1,56(sp)
    80003d28:	ec56                	sd	s5,24(sp)
    80003d2a:	e45e                	sd	s7,8(sp)
    80003d2c:	e062                	sd	s8,0(sp)
    int i = 0;
    80003d2e:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003d30:	6b85                	lui	s7,0x1
    80003d32:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d36:	6c05                	lui	s8,0x1
    80003d38:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d3c:	a851                	j	80003dd0 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003d3e:	6908                	ld	a0,16(a0)
    80003d40:	00000097          	auipc	ra,0x0
    80003d44:	248080e7          	jalr	584(ra) # 80003f88 <pipewrite>
    80003d48:	a85d                	j	80003dfe <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d4a:	02451783          	lh	a5,36(a0)
    80003d4e:	03079693          	slli	a3,a5,0x30
    80003d52:	92c1                	srli	a3,a3,0x30
    80003d54:	4725                	li	a4,9
    80003d56:	0cd76a63          	bltu	a4,a3,80003e2a <filewrite+0x13a>
    80003d5a:	0792                	slli	a5,a5,0x4
    80003d5c:	00018717          	auipc	a4,0x18
    80003d60:	56c70713          	addi	a4,a4,1388 # 8001c2c8 <devsw>
    80003d64:	97ba                	add	a5,a5,a4
    80003d66:	679c                	ld	a5,8(a5)
    80003d68:	c3f9                	beqz	a5,80003e2e <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003d6a:	4505                	li	a0,1
    80003d6c:	9782                	jalr	a5
    80003d6e:	a841                	j	80003dfe <filewrite+0x10e>
      if(n1 > max)
    80003d70:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003d74:	00000097          	auipc	ra,0x0
    80003d78:	88c080e7          	jalr	-1908(ra) # 80003600 <begin_op>
      ilock(f->ip);
    80003d7c:	01893503          	ld	a0,24(s2)
    80003d80:	fffff097          	auipc	ra,0xfffff
    80003d84:	eae080e7          	jalr	-338(ra) # 80002c2e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d88:	8756                	mv	a4,s5
    80003d8a:	02092683          	lw	a3,32(s2)
    80003d8e:	01698633          	add	a2,s3,s6
    80003d92:	4585                	li	a1,1
    80003d94:	01893503          	ld	a0,24(s2)
    80003d98:	fffff097          	auipc	ra,0xfffff
    80003d9c:	252080e7          	jalr	594(ra) # 80002fea <writei>
    80003da0:	84aa                	mv	s1,a0
    80003da2:	00a05763          	blez	a0,80003db0 <filewrite+0xc0>
        f->off += r;
    80003da6:	02092783          	lw	a5,32(s2)
    80003daa:	9fa9                	addw	a5,a5,a0
    80003dac:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003db0:	01893503          	ld	a0,24(s2)
    80003db4:	fffff097          	auipc	ra,0xfffff
    80003db8:	f40080e7          	jalr	-192(ra) # 80002cf4 <iunlock>
      end_op();
    80003dbc:	00000097          	auipc	ra,0x0
    80003dc0:	8be080e7          	jalr	-1858(ra) # 8000367a <end_op>

      if(r != n1){
    80003dc4:	029a9563          	bne	s5,s1,80003dee <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003dc8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003dcc:	0149da63          	bge	s3,s4,80003de0 <filewrite+0xf0>
      int n1 = n - i;
    80003dd0:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003dd4:	0004879b          	sext.w	a5,s1
    80003dd8:	f8fbdce3          	bge	s7,a5,80003d70 <filewrite+0x80>
    80003ddc:	84e2                	mv	s1,s8
    80003dde:	bf49                	j	80003d70 <filewrite+0x80>
    80003de0:	74e2                	ld	s1,56(sp)
    80003de2:	6ae2                	ld	s5,24(sp)
    80003de4:	6ba2                	ld	s7,8(sp)
    80003de6:	6c02                	ld	s8,0(sp)
    80003de8:	a039                	j	80003df6 <filewrite+0x106>
    int i = 0;
    80003dea:	4981                	li	s3,0
    80003dec:	a029                	j	80003df6 <filewrite+0x106>
    80003dee:	74e2                	ld	s1,56(sp)
    80003df0:	6ae2                	ld	s5,24(sp)
    80003df2:	6ba2                	ld	s7,8(sp)
    80003df4:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003df6:	033a1e63          	bne	s4,s3,80003e32 <filewrite+0x142>
    80003dfa:	8552                	mv	a0,s4
    80003dfc:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003dfe:	60a6                	ld	ra,72(sp)
    80003e00:	6406                	ld	s0,64(sp)
    80003e02:	7942                	ld	s2,48(sp)
    80003e04:	7a02                	ld	s4,32(sp)
    80003e06:	6b42                	ld	s6,16(sp)
    80003e08:	6161                	addi	sp,sp,80
    80003e0a:	8082                	ret
    80003e0c:	fc26                	sd	s1,56(sp)
    80003e0e:	f44e                	sd	s3,40(sp)
    80003e10:	ec56                	sd	s5,24(sp)
    80003e12:	e45e                	sd	s7,8(sp)
    80003e14:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003e16:	00004517          	auipc	a0,0x4
    80003e1a:	7e250513          	addi	a0,a0,2018 # 800085f8 <etext+0x5f8>
    80003e1e:	00002097          	auipc	ra,0x2
    80003e22:	f7e080e7          	jalr	-130(ra) # 80005d9c <panic>
    return -1;
    80003e26:	557d                	li	a0,-1
}
    80003e28:	8082                	ret
      return -1;
    80003e2a:	557d                	li	a0,-1
    80003e2c:	bfc9                	j	80003dfe <filewrite+0x10e>
    80003e2e:	557d                	li	a0,-1
    80003e30:	b7f9                	j	80003dfe <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003e32:	557d                	li	a0,-1
    80003e34:	79a2                	ld	s3,40(sp)
    80003e36:	b7e1                	j	80003dfe <filewrite+0x10e>

0000000080003e38 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e38:	7179                	addi	sp,sp,-48
    80003e3a:	f406                	sd	ra,40(sp)
    80003e3c:	f022                	sd	s0,32(sp)
    80003e3e:	ec26                	sd	s1,24(sp)
    80003e40:	e052                	sd	s4,0(sp)
    80003e42:	1800                	addi	s0,sp,48
    80003e44:	84aa                	mv	s1,a0
    80003e46:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e48:	0005b023          	sd	zero,0(a1)
    80003e4c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e50:	00000097          	auipc	ra,0x0
    80003e54:	bbe080e7          	jalr	-1090(ra) # 80003a0e <filealloc>
    80003e58:	e088                	sd	a0,0(s1)
    80003e5a:	cd49                	beqz	a0,80003ef4 <pipealloc+0xbc>
    80003e5c:	00000097          	auipc	ra,0x0
    80003e60:	bb2080e7          	jalr	-1102(ra) # 80003a0e <filealloc>
    80003e64:	00aa3023          	sd	a0,0(s4)
    80003e68:	c141                	beqz	a0,80003ee8 <pipealloc+0xb0>
    80003e6a:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e6c:	ffffc097          	auipc	ra,0xffffc
    80003e70:	2ae080e7          	jalr	686(ra) # 8000011a <kalloc>
    80003e74:	892a                	mv	s2,a0
    80003e76:	c13d                	beqz	a0,80003edc <pipealloc+0xa4>
    80003e78:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003e7a:	4985                	li	s3,1
    80003e7c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e80:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e84:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e88:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e8c:	00004597          	auipc	a1,0x4
    80003e90:	52458593          	addi	a1,a1,1316 # 800083b0 <etext+0x3b0>
    80003e94:	00002097          	auipc	ra,0x2
    80003e98:	3f2080e7          	jalr	1010(ra) # 80006286 <initlock>
  (*f0)->type = FD_PIPE;
    80003e9c:	609c                	ld	a5,0(s1)
    80003e9e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ea2:	609c                	ld	a5,0(s1)
    80003ea4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003ea8:	609c                	ld	a5,0(s1)
    80003eaa:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003eae:	609c                	ld	a5,0(s1)
    80003eb0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003eb4:	000a3783          	ld	a5,0(s4)
    80003eb8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ebc:	000a3783          	ld	a5,0(s4)
    80003ec0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ec4:	000a3783          	ld	a5,0(s4)
    80003ec8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ecc:	000a3783          	ld	a5,0(s4)
    80003ed0:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ed4:	4501                	li	a0,0
    80003ed6:	6942                	ld	s2,16(sp)
    80003ed8:	69a2                	ld	s3,8(sp)
    80003eda:	a03d                	j	80003f08 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003edc:	6088                	ld	a0,0(s1)
    80003ede:	c119                	beqz	a0,80003ee4 <pipealloc+0xac>
    80003ee0:	6942                	ld	s2,16(sp)
    80003ee2:	a029                	j	80003eec <pipealloc+0xb4>
    80003ee4:	6942                	ld	s2,16(sp)
    80003ee6:	a039                	j	80003ef4 <pipealloc+0xbc>
    80003ee8:	6088                	ld	a0,0(s1)
    80003eea:	c50d                	beqz	a0,80003f14 <pipealloc+0xdc>
    fileclose(*f0);
    80003eec:	00000097          	auipc	ra,0x0
    80003ef0:	bde080e7          	jalr	-1058(ra) # 80003aca <fileclose>
  if(*f1)
    80003ef4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ef8:	557d                	li	a0,-1
  if(*f1)
    80003efa:	c799                	beqz	a5,80003f08 <pipealloc+0xd0>
    fileclose(*f1);
    80003efc:	853e                	mv	a0,a5
    80003efe:	00000097          	auipc	ra,0x0
    80003f02:	bcc080e7          	jalr	-1076(ra) # 80003aca <fileclose>
  return -1;
    80003f06:	557d                	li	a0,-1
}
    80003f08:	70a2                	ld	ra,40(sp)
    80003f0a:	7402                	ld	s0,32(sp)
    80003f0c:	64e2                	ld	s1,24(sp)
    80003f0e:	6a02                	ld	s4,0(sp)
    80003f10:	6145                	addi	sp,sp,48
    80003f12:	8082                	ret
  return -1;
    80003f14:	557d                	li	a0,-1
    80003f16:	bfcd                	j	80003f08 <pipealloc+0xd0>

0000000080003f18 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f18:	1101                	addi	sp,sp,-32
    80003f1a:	ec06                	sd	ra,24(sp)
    80003f1c:	e822                	sd	s0,16(sp)
    80003f1e:	e426                	sd	s1,8(sp)
    80003f20:	e04a                	sd	s2,0(sp)
    80003f22:	1000                	addi	s0,sp,32
    80003f24:	84aa                	mv	s1,a0
    80003f26:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f28:	00002097          	auipc	ra,0x2
    80003f2c:	3ee080e7          	jalr	1006(ra) # 80006316 <acquire>
  if(writable){
    80003f30:	02090d63          	beqz	s2,80003f6a <pipeclose+0x52>
    pi->writeopen = 0;
    80003f34:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f38:	21848513          	addi	a0,s1,536
    80003f3c:	ffffd097          	auipc	ra,0xffffd
    80003f40:	7e8080e7          	jalr	2024(ra) # 80001724 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f44:	2204b783          	ld	a5,544(s1)
    80003f48:	eb95                	bnez	a5,80003f7c <pipeclose+0x64>
    release(&pi->lock);
    80003f4a:	8526                	mv	a0,s1
    80003f4c:	00002097          	auipc	ra,0x2
    80003f50:	47e080e7          	jalr	1150(ra) # 800063ca <release>
    kfree((char*)pi);
    80003f54:	8526                	mv	a0,s1
    80003f56:	ffffc097          	auipc	ra,0xffffc
    80003f5a:	0c6080e7          	jalr	198(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f5e:	60e2                	ld	ra,24(sp)
    80003f60:	6442                	ld	s0,16(sp)
    80003f62:	64a2                	ld	s1,8(sp)
    80003f64:	6902                	ld	s2,0(sp)
    80003f66:	6105                	addi	sp,sp,32
    80003f68:	8082                	ret
    pi->readopen = 0;
    80003f6a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f6e:	21c48513          	addi	a0,s1,540
    80003f72:	ffffd097          	auipc	ra,0xffffd
    80003f76:	7b2080e7          	jalr	1970(ra) # 80001724 <wakeup>
    80003f7a:	b7e9                	j	80003f44 <pipeclose+0x2c>
    release(&pi->lock);
    80003f7c:	8526                	mv	a0,s1
    80003f7e:	00002097          	auipc	ra,0x2
    80003f82:	44c080e7          	jalr	1100(ra) # 800063ca <release>
}
    80003f86:	bfe1                	j	80003f5e <pipeclose+0x46>

0000000080003f88 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f88:	711d                	addi	sp,sp,-96
    80003f8a:	ec86                	sd	ra,88(sp)
    80003f8c:	e8a2                	sd	s0,80(sp)
    80003f8e:	e4a6                	sd	s1,72(sp)
    80003f90:	e0ca                	sd	s2,64(sp)
    80003f92:	fc4e                	sd	s3,56(sp)
    80003f94:	f852                	sd	s4,48(sp)
    80003f96:	f456                	sd	s5,40(sp)
    80003f98:	1080                	addi	s0,sp,96
    80003f9a:	84aa                	mv	s1,a0
    80003f9c:	8aae                	mv	s5,a1
    80003f9e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fa0:	ffffd097          	auipc	ra,0xffffd
    80003fa4:	f26080e7          	jalr	-218(ra) # 80000ec6 <myproc>
    80003fa8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003faa:	8526                	mv	a0,s1
    80003fac:	00002097          	auipc	ra,0x2
    80003fb0:	36a080e7          	jalr	874(ra) # 80006316 <acquire>
  while(i < n){
    80003fb4:	0d405563          	blez	s4,8000407e <pipewrite+0xf6>
    80003fb8:	f05a                	sd	s6,32(sp)
    80003fba:	ec5e                	sd	s7,24(sp)
    80003fbc:	e862                	sd	s8,16(sp)
  int i = 0;
    80003fbe:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fc0:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fc2:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fc6:	21c48b93          	addi	s7,s1,540
    80003fca:	a089                	j	8000400c <pipewrite+0x84>
      release(&pi->lock);
    80003fcc:	8526                	mv	a0,s1
    80003fce:	00002097          	auipc	ra,0x2
    80003fd2:	3fc080e7          	jalr	1020(ra) # 800063ca <release>
      return -1;
    80003fd6:	597d                	li	s2,-1
    80003fd8:	7b02                	ld	s6,32(sp)
    80003fda:	6be2                	ld	s7,24(sp)
    80003fdc:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fde:	854a                	mv	a0,s2
    80003fe0:	60e6                	ld	ra,88(sp)
    80003fe2:	6446                	ld	s0,80(sp)
    80003fe4:	64a6                	ld	s1,72(sp)
    80003fe6:	6906                	ld	s2,64(sp)
    80003fe8:	79e2                	ld	s3,56(sp)
    80003fea:	7a42                	ld	s4,48(sp)
    80003fec:	7aa2                	ld	s5,40(sp)
    80003fee:	6125                	addi	sp,sp,96
    80003ff0:	8082                	ret
      wakeup(&pi->nread);
    80003ff2:	8562                	mv	a0,s8
    80003ff4:	ffffd097          	auipc	ra,0xffffd
    80003ff8:	730080e7          	jalr	1840(ra) # 80001724 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003ffc:	85a6                	mv	a1,s1
    80003ffe:	855e                	mv	a0,s7
    80004000:	ffffd097          	auipc	ra,0xffffd
    80004004:	598080e7          	jalr	1432(ra) # 80001598 <sleep>
  while(i < n){
    80004008:	05495c63          	bge	s2,s4,80004060 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    8000400c:	2204a783          	lw	a5,544(s1)
    80004010:	dfd5                	beqz	a5,80003fcc <pipewrite+0x44>
    80004012:	0289a783          	lw	a5,40(s3)
    80004016:	fbdd                	bnez	a5,80003fcc <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004018:	2184a783          	lw	a5,536(s1)
    8000401c:	21c4a703          	lw	a4,540(s1)
    80004020:	2007879b          	addiw	a5,a5,512
    80004024:	fcf707e3          	beq	a4,a5,80003ff2 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004028:	4685                	li	a3,1
    8000402a:	01590633          	add	a2,s2,s5
    8000402e:	faf40593          	addi	a1,s0,-81
    80004032:	0509b503          	ld	a0,80(s3)
    80004036:	ffffd097          	auipc	ra,0xffffd
    8000403a:	bb8080e7          	jalr	-1096(ra) # 80000bee <copyin>
    8000403e:	05650263          	beq	a0,s6,80004082 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004042:	21c4a783          	lw	a5,540(s1)
    80004046:	0017871b          	addiw	a4,a5,1
    8000404a:	20e4ae23          	sw	a4,540(s1)
    8000404e:	1ff7f793          	andi	a5,a5,511
    80004052:	97a6                	add	a5,a5,s1
    80004054:	faf44703          	lbu	a4,-81(s0)
    80004058:	00e78c23          	sb	a4,24(a5)
      i++;
    8000405c:	2905                	addiw	s2,s2,1
    8000405e:	b76d                	j	80004008 <pipewrite+0x80>
    80004060:	7b02                	ld	s6,32(sp)
    80004062:	6be2                	ld	s7,24(sp)
    80004064:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004066:	21848513          	addi	a0,s1,536
    8000406a:	ffffd097          	auipc	ra,0xffffd
    8000406e:	6ba080e7          	jalr	1722(ra) # 80001724 <wakeup>
  release(&pi->lock);
    80004072:	8526                	mv	a0,s1
    80004074:	00002097          	auipc	ra,0x2
    80004078:	356080e7          	jalr	854(ra) # 800063ca <release>
  return i;
    8000407c:	b78d                	j	80003fde <pipewrite+0x56>
  int i = 0;
    8000407e:	4901                	li	s2,0
    80004080:	b7dd                	j	80004066 <pipewrite+0xde>
    80004082:	7b02                	ld	s6,32(sp)
    80004084:	6be2                	ld	s7,24(sp)
    80004086:	6c42                	ld	s8,16(sp)
    80004088:	bff9                	j	80004066 <pipewrite+0xde>

000000008000408a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000408a:	715d                	addi	sp,sp,-80
    8000408c:	e486                	sd	ra,72(sp)
    8000408e:	e0a2                	sd	s0,64(sp)
    80004090:	fc26                	sd	s1,56(sp)
    80004092:	f84a                	sd	s2,48(sp)
    80004094:	f44e                	sd	s3,40(sp)
    80004096:	f052                	sd	s4,32(sp)
    80004098:	ec56                	sd	s5,24(sp)
    8000409a:	0880                	addi	s0,sp,80
    8000409c:	84aa                	mv	s1,a0
    8000409e:	892e                	mv	s2,a1
    800040a0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040a2:	ffffd097          	auipc	ra,0xffffd
    800040a6:	e24080e7          	jalr	-476(ra) # 80000ec6 <myproc>
    800040aa:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040ac:	8526                	mv	a0,s1
    800040ae:	00002097          	auipc	ra,0x2
    800040b2:	268080e7          	jalr	616(ra) # 80006316 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040b6:	2184a703          	lw	a4,536(s1)
    800040ba:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040be:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040c2:	02f71663          	bne	a4,a5,800040ee <piperead+0x64>
    800040c6:	2244a783          	lw	a5,548(s1)
    800040ca:	cb9d                	beqz	a5,80004100 <piperead+0x76>
    if(pr->killed){
    800040cc:	028a2783          	lw	a5,40(s4)
    800040d0:	e38d                	bnez	a5,800040f2 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040d2:	85a6                	mv	a1,s1
    800040d4:	854e                	mv	a0,s3
    800040d6:	ffffd097          	auipc	ra,0xffffd
    800040da:	4c2080e7          	jalr	1218(ra) # 80001598 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040de:	2184a703          	lw	a4,536(s1)
    800040e2:	21c4a783          	lw	a5,540(s1)
    800040e6:	fef700e3          	beq	a4,a5,800040c6 <piperead+0x3c>
    800040ea:	e85a                	sd	s6,16(sp)
    800040ec:	a819                	j	80004102 <piperead+0x78>
    800040ee:	e85a                	sd	s6,16(sp)
    800040f0:	a809                	j	80004102 <piperead+0x78>
      release(&pi->lock);
    800040f2:	8526                	mv	a0,s1
    800040f4:	00002097          	auipc	ra,0x2
    800040f8:	2d6080e7          	jalr	726(ra) # 800063ca <release>
      return -1;
    800040fc:	59fd                	li	s3,-1
    800040fe:	a0a5                	j	80004166 <piperead+0xdc>
    80004100:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004102:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004104:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004106:	05505463          	blez	s5,8000414e <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    8000410a:	2184a783          	lw	a5,536(s1)
    8000410e:	21c4a703          	lw	a4,540(s1)
    80004112:	02f70e63          	beq	a4,a5,8000414e <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004116:	0017871b          	addiw	a4,a5,1
    8000411a:	20e4ac23          	sw	a4,536(s1)
    8000411e:	1ff7f793          	andi	a5,a5,511
    80004122:	97a6                	add	a5,a5,s1
    80004124:	0187c783          	lbu	a5,24(a5)
    80004128:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000412c:	4685                	li	a3,1
    8000412e:	fbf40613          	addi	a2,s0,-65
    80004132:	85ca                	mv	a1,s2
    80004134:	050a3503          	ld	a0,80(s4)
    80004138:	ffffd097          	auipc	ra,0xffffd
    8000413c:	a2a080e7          	jalr	-1494(ra) # 80000b62 <copyout>
    80004140:	01650763          	beq	a0,s6,8000414e <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004144:	2985                	addiw	s3,s3,1
    80004146:	0905                	addi	s2,s2,1
    80004148:	fd3a91e3          	bne	s5,s3,8000410a <piperead+0x80>
    8000414c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000414e:	21c48513          	addi	a0,s1,540
    80004152:	ffffd097          	auipc	ra,0xffffd
    80004156:	5d2080e7          	jalr	1490(ra) # 80001724 <wakeup>
  release(&pi->lock);
    8000415a:	8526                	mv	a0,s1
    8000415c:	00002097          	auipc	ra,0x2
    80004160:	26e080e7          	jalr	622(ra) # 800063ca <release>
    80004164:	6b42                	ld	s6,16(sp)
  return i;
}
    80004166:	854e                	mv	a0,s3
    80004168:	60a6                	ld	ra,72(sp)
    8000416a:	6406                	ld	s0,64(sp)
    8000416c:	74e2                	ld	s1,56(sp)
    8000416e:	7942                	ld	s2,48(sp)
    80004170:	79a2                	ld	s3,40(sp)
    80004172:	7a02                	ld	s4,32(sp)
    80004174:	6ae2                	ld	s5,24(sp)
    80004176:	6161                	addi	sp,sp,80
    80004178:	8082                	ret

000000008000417a <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000417a:	df010113          	addi	sp,sp,-528
    8000417e:	20113423          	sd	ra,520(sp)
    80004182:	20813023          	sd	s0,512(sp)
    80004186:	ffa6                	sd	s1,504(sp)
    80004188:	fbca                	sd	s2,496(sp)
    8000418a:	0c00                	addi	s0,sp,528
    8000418c:	892a                	mv	s2,a0
    8000418e:	dea43c23          	sd	a0,-520(s0)
    80004192:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004196:	ffffd097          	auipc	ra,0xffffd
    8000419a:	d30080e7          	jalr	-720(ra) # 80000ec6 <myproc>
    8000419e:	84aa                	mv	s1,a0

  begin_op();
    800041a0:	fffff097          	auipc	ra,0xfffff
    800041a4:	460080e7          	jalr	1120(ra) # 80003600 <begin_op>

  if((ip = namei(path)) == 0){
    800041a8:	854a                	mv	a0,s2
    800041aa:	fffff097          	auipc	ra,0xfffff
    800041ae:	256080e7          	jalr	598(ra) # 80003400 <namei>
    800041b2:	c135                	beqz	a0,80004216 <exec+0x9c>
    800041b4:	f3d2                	sd	s4,480(sp)
    800041b6:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041b8:	fffff097          	auipc	ra,0xfffff
    800041bc:	a76080e7          	jalr	-1418(ra) # 80002c2e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041c0:	04000713          	li	a4,64
    800041c4:	4681                	li	a3,0
    800041c6:	e5040613          	addi	a2,s0,-432
    800041ca:	4581                	li	a1,0
    800041cc:	8552                	mv	a0,s4
    800041ce:	fffff097          	auipc	ra,0xfffff
    800041d2:	d18080e7          	jalr	-744(ra) # 80002ee6 <readi>
    800041d6:	04000793          	li	a5,64
    800041da:	00f51a63          	bne	a0,a5,800041ee <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800041de:	e5042703          	lw	a4,-432(s0)
    800041e2:	464c47b7          	lui	a5,0x464c4
    800041e6:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041ea:	02f70c63          	beq	a4,a5,80004222 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041ee:	8552                	mv	a0,s4
    800041f0:	fffff097          	auipc	ra,0xfffff
    800041f4:	ca4080e7          	jalr	-860(ra) # 80002e94 <iunlockput>
    end_op();
    800041f8:	fffff097          	auipc	ra,0xfffff
    800041fc:	482080e7          	jalr	1154(ra) # 8000367a <end_op>
  }
  return -1;
    80004200:	557d                	li	a0,-1
    80004202:	7a1e                	ld	s4,480(sp)
}
    80004204:	20813083          	ld	ra,520(sp)
    80004208:	20013403          	ld	s0,512(sp)
    8000420c:	74fe                	ld	s1,504(sp)
    8000420e:	795e                	ld	s2,496(sp)
    80004210:	21010113          	addi	sp,sp,528
    80004214:	8082                	ret
    end_op();
    80004216:	fffff097          	auipc	ra,0xfffff
    8000421a:	464080e7          	jalr	1124(ra) # 8000367a <end_op>
    return -1;
    8000421e:	557d                	li	a0,-1
    80004220:	b7d5                	j	80004204 <exec+0x8a>
    80004222:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004224:	8526                	mv	a0,s1
    80004226:	ffffd097          	auipc	ra,0xffffd
    8000422a:	d64080e7          	jalr	-668(ra) # 80000f8a <proc_pagetable>
    8000422e:	8b2a                	mv	s6,a0
    80004230:	30050563          	beqz	a0,8000453a <exec+0x3c0>
    80004234:	f7ce                	sd	s3,488(sp)
    80004236:	efd6                	sd	s5,472(sp)
    80004238:	e7de                	sd	s7,456(sp)
    8000423a:	e3e2                	sd	s8,448(sp)
    8000423c:	ff66                	sd	s9,440(sp)
    8000423e:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004240:	e7042d03          	lw	s10,-400(s0)
    80004244:	e8845783          	lhu	a5,-376(s0)
    80004248:	14078563          	beqz	a5,80004392 <exec+0x218>
    8000424c:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000424e:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004250:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    80004252:	6c85                	lui	s9,0x1
    80004254:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004258:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000425c:	6a85                	lui	s5,0x1
    8000425e:	a0b5                	j	800042ca <exec+0x150>
      panic("loadseg: address should exist");
    80004260:	00004517          	auipc	a0,0x4
    80004264:	3a850513          	addi	a0,a0,936 # 80008608 <etext+0x608>
    80004268:	00002097          	auipc	ra,0x2
    8000426c:	b34080e7          	jalr	-1228(ra) # 80005d9c <panic>
    if(sz - i < PGSIZE)
    80004270:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004272:	8726                	mv	a4,s1
    80004274:	012c06bb          	addw	a3,s8,s2
    80004278:	4581                	li	a1,0
    8000427a:	8552                	mv	a0,s4
    8000427c:	fffff097          	auipc	ra,0xfffff
    80004280:	c6a080e7          	jalr	-918(ra) # 80002ee6 <readi>
    80004284:	2501                	sext.w	a0,a0
    80004286:	26a49e63          	bne	s1,a0,80004502 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    8000428a:	012a893b          	addw	s2,s5,s2
    8000428e:	03397563          	bgeu	s2,s3,800042b8 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80004292:	02091593          	slli	a1,s2,0x20
    80004296:	9181                	srli	a1,a1,0x20
    80004298:	95de                	add	a1,a1,s7
    8000429a:	855a                	mv	a0,s6
    8000429c:	ffffc097          	auipc	ra,0xffffc
    800042a0:	2a6080e7          	jalr	678(ra) # 80000542 <walkaddr>
    800042a4:	862a                	mv	a2,a0
    if(pa == 0)
    800042a6:	dd4d                	beqz	a0,80004260 <exec+0xe6>
    if(sz - i < PGSIZE)
    800042a8:	412984bb          	subw	s1,s3,s2
    800042ac:	0004879b          	sext.w	a5,s1
    800042b0:	fcfcf0e3          	bgeu	s9,a5,80004270 <exec+0xf6>
    800042b4:	84d6                	mv	s1,s5
    800042b6:	bf6d                	j	80004270 <exec+0xf6>
    sz = sz1;
    800042b8:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042bc:	2d85                	addiw	s11,s11,1
    800042be:	038d0d1b          	addiw	s10,s10,56
    800042c2:	e8845783          	lhu	a5,-376(s0)
    800042c6:	06fddf63          	bge	s11,a5,80004344 <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800042ca:	2d01                	sext.w	s10,s10
    800042cc:	03800713          	li	a4,56
    800042d0:	86ea                	mv	a3,s10
    800042d2:	e1840613          	addi	a2,s0,-488
    800042d6:	4581                	li	a1,0
    800042d8:	8552                	mv	a0,s4
    800042da:	fffff097          	auipc	ra,0xfffff
    800042de:	c0c080e7          	jalr	-1012(ra) # 80002ee6 <readi>
    800042e2:	03800793          	li	a5,56
    800042e6:	1ef51863          	bne	a0,a5,800044d6 <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    800042ea:	e1842783          	lw	a5,-488(s0)
    800042ee:	4705                	li	a4,1
    800042f0:	fce796e3          	bne	a5,a4,800042bc <exec+0x142>
    if(ph.memsz < ph.filesz)
    800042f4:	e4043603          	ld	a2,-448(s0)
    800042f8:	e3843783          	ld	a5,-456(s0)
    800042fc:	1ef66163          	bltu	a2,a5,800044de <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004300:	e2843783          	ld	a5,-472(s0)
    80004304:	963e                	add	a2,a2,a5
    80004306:	1ef66063          	bltu	a2,a5,800044e6 <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000430a:	85a6                	mv	a1,s1
    8000430c:	855a                	mv	a0,s6
    8000430e:	ffffc097          	auipc	ra,0xffffc
    80004312:	5f8080e7          	jalr	1528(ra) # 80000906 <uvmalloc>
    80004316:	e0a43423          	sd	a0,-504(s0)
    8000431a:	1c050a63          	beqz	a0,800044ee <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    8000431e:	e2843b83          	ld	s7,-472(s0)
    80004322:	df043783          	ld	a5,-528(s0)
    80004326:	00fbf7b3          	and	a5,s7,a5
    8000432a:	1c079a63          	bnez	a5,800044fe <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000432e:	e2042c03          	lw	s8,-480(s0)
    80004332:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004336:	00098463          	beqz	s3,8000433e <exec+0x1c4>
    8000433a:	4901                	li	s2,0
    8000433c:	bf99                	j	80004292 <exec+0x118>
    sz = sz1;
    8000433e:	e0843483          	ld	s1,-504(s0)
    80004342:	bfad                	j	800042bc <exec+0x142>
    80004344:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004346:	8552                	mv	a0,s4
    80004348:	fffff097          	auipc	ra,0xfffff
    8000434c:	b4c080e7          	jalr	-1204(ra) # 80002e94 <iunlockput>
  end_op();
    80004350:	fffff097          	auipc	ra,0xfffff
    80004354:	32a080e7          	jalr	810(ra) # 8000367a <end_op>
  p = myproc();
    80004358:	ffffd097          	auipc	ra,0xffffd
    8000435c:	b6e080e7          	jalr	-1170(ra) # 80000ec6 <myproc>
    80004360:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004362:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004366:	6985                	lui	s3,0x1
    80004368:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000436a:	99a6                	add	s3,s3,s1
    8000436c:	77fd                	lui	a5,0xfffff
    8000436e:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004372:	6609                	lui	a2,0x2
    80004374:	964e                	add	a2,a2,s3
    80004376:	85ce                	mv	a1,s3
    80004378:	855a                	mv	a0,s6
    8000437a:	ffffc097          	auipc	ra,0xffffc
    8000437e:	58c080e7          	jalr	1420(ra) # 80000906 <uvmalloc>
    80004382:	892a                	mv	s2,a0
    80004384:	e0a43423          	sd	a0,-504(s0)
    80004388:	e519                	bnez	a0,80004396 <exec+0x21c>
  if(pagetable)
    8000438a:	e1343423          	sd	s3,-504(s0)
    8000438e:	4a01                	li	s4,0
    80004390:	aa95                	j	80004504 <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004392:	4481                	li	s1,0
    80004394:	bf4d                	j	80004346 <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004396:	75f9                	lui	a1,0xffffe
    80004398:	95aa                	add	a1,a1,a0
    8000439a:	855a                	mv	a0,s6
    8000439c:	ffffc097          	auipc	ra,0xffffc
    800043a0:	794080e7          	jalr	1940(ra) # 80000b30 <uvmclear>
  stackbase = sp - PGSIZE;
    800043a4:	7bfd                	lui	s7,0xfffff
    800043a6:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800043a8:	e0043783          	ld	a5,-512(s0)
    800043ac:	6388                	ld	a0,0(a5)
    800043ae:	c52d                	beqz	a0,80004418 <exec+0x29e>
    800043b0:	e9040993          	addi	s3,s0,-368
    800043b4:	f9040c13          	addi	s8,s0,-112
    800043b8:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800043ba:	ffffc097          	auipc	ra,0xffffc
    800043be:	f7e080e7          	jalr	-130(ra) # 80000338 <strlen>
    800043c2:	0015079b          	addiw	a5,a0,1
    800043c6:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043ca:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800043ce:	13796463          	bltu	s2,s7,800044f6 <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043d2:	e0043d03          	ld	s10,-512(s0)
    800043d6:	000d3a03          	ld	s4,0(s10)
    800043da:	8552                	mv	a0,s4
    800043dc:	ffffc097          	auipc	ra,0xffffc
    800043e0:	f5c080e7          	jalr	-164(ra) # 80000338 <strlen>
    800043e4:	0015069b          	addiw	a3,a0,1
    800043e8:	8652                	mv	a2,s4
    800043ea:	85ca                	mv	a1,s2
    800043ec:	855a                	mv	a0,s6
    800043ee:	ffffc097          	auipc	ra,0xffffc
    800043f2:	774080e7          	jalr	1908(ra) # 80000b62 <copyout>
    800043f6:	10054263          	bltz	a0,800044fa <exec+0x380>
    ustack[argc] = sp;
    800043fa:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043fe:	0485                	addi	s1,s1,1
    80004400:	008d0793          	addi	a5,s10,8
    80004404:	e0f43023          	sd	a5,-512(s0)
    80004408:	008d3503          	ld	a0,8(s10)
    8000440c:	c909                	beqz	a0,8000441e <exec+0x2a4>
    if(argc >= MAXARG)
    8000440e:	09a1                	addi	s3,s3,8
    80004410:	fb8995e3          	bne	s3,s8,800043ba <exec+0x240>
  ip = 0;
    80004414:	4a01                	li	s4,0
    80004416:	a0fd                	j	80004504 <exec+0x38a>
  sp = sz;
    80004418:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000441c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000441e:	00349793          	slli	a5,s1,0x3
    80004422:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd5d50>
    80004426:	97a2                	add	a5,a5,s0
    80004428:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000442c:	00148693          	addi	a3,s1,1
    80004430:	068e                	slli	a3,a3,0x3
    80004432:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004436:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000443a:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000443e:	f57966e3          	bltu	s2,s7,8000438a <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004442:	e9040613          	addi	a2,s0,-368
    80004446:	85ca                	mv	a1,s2
    80004448:	855a                	mv	a0,s6
    8000444a:	ffffc097          	auipc	ra,0xffffc
    8000444e:	718080e7          	jalr	1816(ra) # 80000b62 <copyout>
    80004452:	0e054663          	bltz	a0,8000453e <exec+0x3c4>
  p->trapframe->a1 = sp;
    80004456:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000445a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000445e:	df843783          	ld	a5,-520(s0)
    80004462:	0007c703          	lbu	a4,0(a5)
    80004466:	cf11                	beqz	a4,80004482 <exec+0x308>
    80004468:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000446a:	02f00693          	li	a3,47
    8000446e:	a039                	j	8000447c <exec+0x302>
      last = s+1;
    80004470:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004474:	0785                	addi	a5,a5,1
    80004476:	fff7c703          	lbu	a4,-1(a5)
    8000447a:	c701                	beqz	a4,80004482 <exec+0x308>
    if(*s == '/')
    8000447c:	fed71ce3          	bne	a4,a3,80004474 <exec+0x2fa>
    80004480:	bfc5                	j	80004470 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004482:	4641                	li	a2,16
    80004484:	df843583          	ld	a1,-520(s0)
    80004488:	158a8513          	addi	a0,s5,344
    8000448c:	ffffc097          	auipc	ra,0xffffc
    80004490:	e7a080e7          	jalr	-390(ra) # 80000306 <safestrcpy>
  oldpagetable = p->pagetable;
    80004494:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004498:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000449c:	e0843783          	ld	a5,-504(s0)
    800044a0:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044a4:	058ab783          	ld	a5,88(s5)
    800044a8:	e6843703          	ld	a4,-408(s0)
    800044ac:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044ae:	058ab783          	ld	a5,88(s5)
    800044b2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044b6:	85e6                	mv	a1,s9
    800044b8:	ffffd097          	auipc	ra,0xffffd
    800044bc:	b6e080e7          	jalr	-1170(ra) # 80001026 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044c0:	0004851b          	sext.w	a0,s1
    800044c4:	79be                	ld	s3,488(sp)
    800044c6:	7a1e                	ld	s4,480(sp)
    800044c8:	6afe                	ld	s5,472(sp)
    800044ca:	6b5e                	ld	s6,464(sp)
    800044cc:	6bbe                	ld	s7,456(sp)
    800044ce:	6c1e                	ld	s8,448(sp)
    800044d0:	7cfa                	ld	s9,440(sp)
    800044d2:	7d5a                	ld	s10,432(sp)
    800044d4:	bb05                	j	80004204 <exec+0x8a>
    800044d6:	e0943423          	sd	s1,-504(s0)
    800044da:	7dba                	ld	s11,424(sp)
    800044dc:	a025                	j	80004504 <exec+0x38a>
    800044de:	e0943423          	sd	s1,-504(s0)
    800044e2:	7dba                	ld	s11,424(sp)
    800044e4:	a005                	j	80004504 <exec+0x38a>
    800044e6:	e0943423          	sd	s1,-504(s0)
    800044ea:	7dba                	ld	s11,424(sp)
    800044ec:	a821                	j	80004504 <exec+0x38a>
    800044ee:	e0943423          	sd	s1,-504(s0)
    800044f2:	7dba                	ld	s11,424(sp)
    800044f4:	a801                	j	80004504 <exec+0x38a>
  ip = 0;
    800044f6:	4a01                	li	s4,0
    800044f8:	a031                	j	80004504 <exec+0x38a>
    800044fa:	4a01                	li	s4,0
  if(pagetable)
    800044fc:	a021                	j	80004504 <exec+0x38a>
    800044fe:	7dba                	ld	s11,424(sp)
    80004500:	a011                	j	80004504 <exec+0x38a>
    80004502:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004504:	e0843583          	ld	a1,-504(s0)
    80004508:	855a                	mv	a0,s6
    8000450a:	ffffd097          	auipc	ra,0xffffd
    8000450e:	b1c080e7          	jalr	-1252(ra) # 80001026 <proc_freepagetable>
  return -1;
    80004512:	557d                	li	a0,-1
  if(ip){
    80004514:	000a1b63          	bnez	s4,8000452a <exec+0x3b0>
    80004518:	79be                	ld	s3,488(sp)
    8000451a:	7a1e                	ld	s4,480(sp)
    8000451c:	6afe                	ld	s5,472(sp)
    8000451e:	6b5e                	ld	s6,464(sp)
    80004520:	6bbe                	ld	s7,456(sp)
    80004522:	6c1e                	ld	s8,448(sp)
    80004524:	7cfa                	ld	s9,440(sp)
    80004526:	7d5a                	ld	s10,432(sp)
    80004528:	b9f1                	j	80004204 <exec+0x8a>
    8000452a:	79be                	ld	s3,488(sp)
    8000452c:	6afe                	ld	s5,472(sp)
    8000452e:	6b5e                	ld	s6,464(sp)
    80004530:	6bbe                	ld	s7,456(sp)
    80004532:	6c1e                	ld	s8,448(sp)
    80004534:	7cfa                	ld	s9,440(sp)
    80004536:	7d5a                	ld	s10,432(sp)
    80004538:	b95d                	j	800041ee <exec+0x74>
    8000453a:	6b5e                	ld	s6,464(sp)
    8000453c:	b94d                	j	800041ee <exec+0x74>
  sz = sz1;
    8000453e:	e0843983          	ld	s3,-504(s0)
    80004542:	b5a1                	j	8000438a <exec+0x210>

0000000080004544 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004544:	7179                	addi	sp,sp,-48
    80004546:	f406                	sd	ra,40(sp)
    80004548:	f022                	sd	s0,32(sp)
    8000454a:	ec26                	sd	s1,24(sp)
    8000454c:	e84a                	sd	s2,16(sp)
    8000454e:	1800                	addi	s0,sp,48
    80004550:	892e                	mv	s2,a1
    80004552:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004554:	fdc40593          	addi	a1,s0,-36
    80004558:	ffffe097          	auipc	ra,0xffffe
    8000455c:	a90080e7          	jalr	-1392(ra) # 80001fe8 <argint>
    80004560:	04054063          	bltz	a0,800045a0 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004564:	fdc42703          	lw	a4,-36(s0)
    80004568:	47bd                	li	a5,15
    8000456a:	02e7ed63          	bltu	a5,a4,800045a4 <argfd+0x60>
    8000456e:	ffffd097          	auipc	ra,0xffffd
    80004572:	958080e7          	jalr	-1704(ra) # 80000ec6 <myproc>
    80004576:	fdc42703          	lw	a4,-36(s0)
    8000457a:	01a70793          	addi	a5,a4,26
    8000457e:	078e                	slli	a5,a5,0x3
    80004580:	953e                	add	a0,a0,a5
    80004582:	611c                	ld	a5,0(a0)
    80004584:	c395                	beqz	a5,800045a8 <argfd+0x64>
    return -1;
  if(pfd)
    80004586:	00090463          	beqz	s2,8000458e <argfd+0x4a>
    *pfd = fd;
    8000458a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000458e:	4501                	li	a0,0
  if(pf)
    80004590:	c091                	beqz	s1,80004594 <argfd+0x50>
    *pf = f;
    80004592:	e09c                	sd	a5,0(s1)
}
    80004594:	70a2                	ld	ra,40(sp)
    80004596:	7402                	ld	s0,32(sp)
    80004598:	64e2                	ld	s1,24(sp)
    8000459a:	6942                	ld	s2,16(sp)
    8000459c:	6145                	addi	sp,sp,48
    8000459e:	8082                	ret
    return -1;
    800045a0:	557d                	li	a0,-1
    800045a2:	bfcd                	j	80004594 <argfd+0x50>
    return -1;
    800045a4:	557d                	li	a0,-1
    800045a6:	b7fd                	j	80004594 <argfd+0x50>
    800045a8:	557d                	li	a0,-1
    800045aa:	b7ed                	j	80004594 <argfd+0x50>

00000000800045ac <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045ac:	1101                	addi	sp,sp,-32
    800045ae:	ec06                	sd	ra,24(sp)
    800045b0:	e822                	sd	s0,16(sp)
    800045b2:	e426                	sd	s1,8(sp)
    800045b4:	1000                	addi	s0,sp,32
    800045b6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045b8:	ffffd097          	auipc	ra,0xffffd
    800045bc:	90e080e7          	jalr	-1778(ra) # 80000ec6 <myproc>
    800045c0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045c2:	0d050793          	addi	a5,a0,208
    800045c6:	4501                	li	a0,0
    800045c8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045ca:	6398                	ld	a4,0(a5)
    800045cc:	cb19                	beqz	a4,800045e2 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045ce:	2505                	addiw	a0,a0,1
    800045d0:	07a1                	addi	a5,a5,8
    800045d2:	fed51ce3          	bne	a0,a3,800045ca <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045d6:	557d                	li	a0,-1
}
    800045d8:	60e2                	ld	ra,24(sp)
    800045da:	6442                	ld	s0,16(sp)
    800045dc:	64a2                	ld	s1,8(sp)
    800045de:	6105                	addi	sp,sp,32
    800045e0:	8082                	ret
      p->ofile[fd] = f;
    800045e2:	01a50793          	addi	a5,a0,26
    800045e6:	078e                	slli	a5,a5,0x3
    800045e8:	963e                	add	a2,a2,a5
    800045ea:	e204                	sd	s1,0(a2)
      return fd;
    800045ec:	b7f5                	j	800045d8 <fdalloc+0x2c>

00000000800045ee <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045ee:	715d                	addi	sp,sp,-80
    800045f0:	e486                	sd	ra,72(sp)
    800045f2:	e0a2                	sd	s0,64(sp)
    800045f4:	fc26                	sd	s1,56(sp)
    800045f6:	f84a                	sd	s2,48(sp)
    800045f8:	f44e                	sd	s3,40(sp)
    800045fa:	f052                	sd	s4,32(sp)
    800045fc:	ec56                	sd	s5,24(sp)
    800045fe:	0880                	addi	s0,sp,80
    80004600:	8aae                	mv	s5,a1
    80004602:	8a32                	mv	s4,a2
    80004604:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004606:	fb040593          	addi	a1,s0,-80
    8000460a:	fffff097          	auipc	ra,0xfffff
    8000460e:	e14080e7          	jalr	-492(ra) # 8000341e <nameiparent>
    80004612:	892a                	mv	s2,a0
    80004614:	12050c63          	beqz	a0,8000474c <create+0x15e>
    return 0;

  ilock(dp);
    80004618:	ffffe097          	auipc	ra,0xffffe
    8000461c:	616080e7          	jalr	1558(ra) # 80002c2e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004620:	4601                	li	a2,0
    80004622:	fb040593          	addi	a1,s0,-80
    80004626:	854a                	mv	a0,s2
    80004628:	fffff097          	auipc	ra,0xfffff
    8000462c:	b06080e7          	jalr	-1274(ra) # 8000312e <dirlookup>
    80004630:	84aa                	mv	s1,a0
    80004632:	c539                	beqz	a0,80004680 <create+0x92>
    iunlockput(dp);
    80004634:	854a                	mv	a0,s2
    80004636:	fffff097          	auipc	ra,0xfffff
    8000463a:	85e080e7          	jalr	-1954(ra) # 80002e94 <iunlockput>
    ilock(ip);
    8000463e:	8526                	mv	a0,s1
    80004640:	ffffe097          	auipc	ra,0xffffe
    80004644:	5ee080e7          	jalr	1518(ra) # 80002c2e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004648:	4789                	li	a5,2
    8000464a:	02fa9463          	bne	s5,a5,80004672 <create+0x84>
    8000464e:	0444d783          	lhu	a5,68(s1)
    80004652:	37f9                	addiw	a5,a5,-2
    80004654:	17c2                	slli	a5,a5,0x30
    80004656:	93c1                	srli	a5,a5,0x30
    80004658:	4705                	li	a4,1
    8000465a:	00f76c63          	bltu	a4,a5,80004672 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000465e:	8526                	mv	a0,s1
    80004660:	60a6                	ld	ra,72(sp)
    80004662:	6406                	ld	s0,64(sp)
    80004664:	74e2                	ld	s1,56(sp)
    80004666:	7942                	ld	s2,48(sp)
    80004668:	79a2                	ld	s3,40(sp)
    8000466a:	7a02                	ld	s4,32(sp)
    8000466c:	6ae2                	ld	s5,24(sp)
    8000466e:	6161                	addi	sp,sp,80
    80004670:	8082                	ret
    iunlockput(ip);
    80004672:	8526                	mv	a0,s1
    80004674:	fffff097          	auipc	ra,0xfffff
    80004678:	820080e7          	jalr	-2016(ra) # 80002e94 <iunlockput>
    return 0;
    8000467c:	4481                	li	s1,0
    8000467e:	b7c5                	j	8000465e <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004680:	85d6                	mv	a1,s5
    80004682:	00092503          	lw	a0,0(s2)
    80004686:	ffffe097          	auipc	ra,0xffffe
    8000468a:	414080e7          	jalr	1044(ra) # 80002a9a <ialloc>
    8000468e:	84aa                	mv	s1,a0
    80004690:	c139                	beqz	a0,800046d6 <create+0xe8>
  ilock(ip);
    80004692:	ffffe097          	auipc	ra,0xffffe
    80004696:	59c080e7          	jalr	1436(ra) # 80002c2e <ilock>
  ip->major = major;
    8000469a:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    8000469e:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    800046a2:	4985                	li	s3,1
    800046a4:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    800046a8:	8526                	mv	a0,s1
    800046aa:	ffffe097          	auipc	ra,0xffffe
    800046ae:	4b8080e7          	jalr	1208(ra) # 80002b62 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800046b2:	033a8a63          	beq	s5,s3,800046e6 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    800046b6:	40d0                	lw	a2,4(s1)
    800046b8:	fb040593          	addi	a1,s0,-80
    800046bc:	854a                	mv	a0,s2
    800046be:	fffff097          	auipc	ra,0xfffff
    800046c2:	c80080e7          	jalr	-896(ra) # 8000333e <dirlink>
    800046c6:	06054b63          	bltz	a0,8000473c <create+0x14e>
  iunlockput(dp);
    800046ca:	854a                	mv	a0,s2
    800046cc:	ffffe097          	auipc	ra,0xffffe
    800046d0:	7c8080e7          	jalr	1992(ra) # 80002e94 <iunlockput>
  return ip;
    800046d4:	b769                	j	8000465e <create+0x70>
    panic("create: ialloc");
    800046d6:	00004517          	auipc	a0,0x4
    800046da:	f5250513          	addi	a0,a0,-174 # 80008628 <etext+0x628>
    800046de:	00001097          	auipc	ra,0x1
    800046e2:	6be080e7          	jalr	1726(ra) # 80005d9c <panic>
    dp->nlink++;  // for ".."
    800046e6:	04a95783          	lhu	a5,74(s2)
    800046ea:	2785                	addiw	a5,a5,1
    800046ec:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800046f0:	854a                	mv	a0,s2
    800046f2:	ffffe097          	auipc	ra,0xffffe
    800046f6:	470080e7          	jalr	1136(ra) # 80002b62 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046fa:	40d0                	lw	a2,4(s1)
    800046fc:	00004597          	auipc	a1,0x4
    80004700:	f3c58593          	addi	a1,a1,-196 # 80008638 <etext+0x638>
    80004704:	8526                	mv	a0,s1
    80004706:	fffff097          	auipc	ra,0xfffff
    8000470a:	c38080e7          	jalr	-968(ra) # 8000333e <dirlink>
    8000470e:	00054f63          	bltz	a0,8000472c <create+0x13e>
    80004712:	00492603          	lw	a2,4(s2)
    80004716:	00004597          	auipc	a1,0x4
    8000471a:	f2a58593          	addi	a1,a1,-214 # 80008640 <etext+0x640>
    8000471e:	8526                	mv	a0,s1
    80004720:	fffff097          	auipc	ra,0xfffff
    80004724:	c1e080e7          	jalr	-994(ra) # 8000333e <dirlink>
    80004728:	f80557e3          	bgez	a0,800046b6 <create+0xc8>
      panic("create dots");
    8000472c:	00004517          	auipc	a0,0x4
    80004730:	f1c50513          	addi	a0,a0,-228 # 80008648 <etext+0x648>
    80004734:	00001097          	auipc	ra,0x1
    80004738:	668080e7          	jalr	1640(ra) # 80005d9c <panic>
    panic("create: dirlink");
    8000473c:	00004517          	auipc	a0,0x4
    80004740:	f1c50513          	addi	a0,a0,-228 # 80008658 <etext+0x658>
    80004744:	00001097          	auipc	ra,0x1
    80004748:	658080e7          	jalr	1624(ra) # 80005d9c <panic>
    return 0;
    8000474c:	84aa                	mv	s1,a0
    8000474e:	bf01                	j	8000465e <create+0x70>

0000000080004750 <sys_dup>:
{
    80004750:	7179                	addi	sp,sp,-48
    80004752:	f406                	sd	ra,40(sp)
    80004754:	f022                	sd	s0,32(sp)
    80004756:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004758:	fd840613          	addi	a2,s0,-40
    8000475c:	4581                	li	a1,0
    8000475e:	4501                	li	a0,0
    80004760:	00000097          	auipc	ra,0x0
    80004764:	de4080e7          	jalr	-540(ra) # 80004544 <argfd>
    return -1;
    80004768:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000476a:	02054763          	bltz	a0,80004798 <sys_dup+0x48>
    8000476e:	ec26                	sd	s1,24(sp)
    80004770:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004772:	fd843903          	ld	s2,-40(s0)
    80004776:	854a                	mv	a0,s2
    80004778:	00000097          	auipc	ra,0x0
    8000477c:	e34080e7          	jalr	-460(ra) # 800045ac <fdalloc>
    80004780:	84aa                	mv	s1,a0
    return -1;
    80004782:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004784:	00054f63          	bltz	a0,800047a2 <sys_dup+0x52>
  filedup(f);
    80004788:	854a                	mv	a0,s2
    8000478a:	fffff097          	auipc	ra,0xfffff
    8000478e:	2ee080e7          	jalr	750(ra) # 80003a78 <filedup>
  return fd;
    80004792:	87a6                	mv	a5,s1
    80004794:	64e2                	ld	s1,24(sp)
    80004796:	6942                	ld	s2,16(sp)
}
    80004798:	853e                	mv	a0,a5
    8000479a:	70a2                	ld	ra,40(sp)
    8000479c:	7402                	ld	s0,32(sp)
    8000479e:	6145                	addi	sp,sp,48
    800047a0:	8082                	ret
    800047a2:	64e2                	ld	s1,24(sp)
    800047a4:	6942                	ld	s2,16(sp)
    800047a6:	bfcd                	j	80004798 <sys_dup+0x48>

00000000800047a8 <sys_read>:
{
    800047a8:	7179                	addi	sp,sp,-48
    800047aa:	f406                	sd	ra,40(sp)
    800047ac:	f022                	sd	s0,32(sp)
    800047ae:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047b0:	fe840613          	addi	a2,s0,-24
    800047b4:	4581                	li	a1,0
    800047b6:	4501                	li	a0,0
    800047b8:	00000097          	auipc	ra,0x0
    800047bc:	d8c080e7          	jalr	-628(ra) # 80004544 <argfd>
    return -1;
    800047c0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047c2:	04054163          	bltz	a0,80004804 <sys_read+0x5c>
    800047c6:	fe440593          	addi	a1,s0,-28
    800047ca:	4509                	li	a0,2
    800047cc:	ffffe097          	auipc	ra,0xffffe
    800047d0:	81c080e7          	jalr	-2020(ra) # 80001fe8 <argint>
    return -1;
    800047d4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047d6:	02054763          	bltz	a0,80004804 <sys_read+0x5c>
    800047da:	fd840593          	addi	a1,s0,-40
    800047de:	4505                	li	a0,1
    800047e0:	ffffe097          	auipc	ra,0xffffe
    800047e4:	82a080e7          	jalr	-2006(ra) # 8000200a <argaddr>
    return -1;
    800047e8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047ea:	00054d63          	bltz	a0,80004804 <sys_read+0x5c>
  return fileread(f, p, n);
    800047ee:	fe442603          	lw	a2,-28(s0)
    800047f2:	fd843583          	ld	a1,-40(s0)
    800047f6:	fe843503          	ld	a0,-24(s0)
    800047fa:	fffff097          	auipc	ra,0xfffff
    800047fe:	424080e7          	jalr	1060(ra) # 80003c1e <fileread>
    80004802:	87aa                	mv	a5,a0
}
    80004804:	853e                	mv	a0,a5
    80004806:	70a2                	ld	ra,40(sp)
    80004808:	7402                	ld	s0,32(sp)
    8000480a:	6145                	addi	sp,sp,48
    8000480c:	8082                	ret

000000008000480e <sys_write>:
{
    8000480e:	7179                	addi	sp,sp,-48
    80004810:	f406                	sd	ra,40(sp)
    80004812:	f022                	sd	s0,32(sp)
    80004814:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004816:	fe840613          	addi	a2,s0,-24
    8000481a:	4581                	li	a1,0
    8000481c:	4501                	li	a0,0
    8000481e:	00000097          	auipc	ra,0x0
    80004822:	d26080e7          	jalr	-730(ra) # 80004544 <argfd>
    return -1;
    80004826:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004828:	04054163          	bltz	a0,8000486a <sys_write+0x5c>
    8000482c:	fe440593          	addi	a1,s0,-28
    80004830:	4509                	li	a0,2
    80004832:	ffffd097          	auipc	ra,0xffffd
    80004836:	7b6080e7          	jalr	1974(ra) # 80001fe8 <argint>
    return -1;
    8000483a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000483c:	02054763          	bltz	a0,8000486a <sys_write+0x5c>
    80004840:	fd840593          	addi	a1,s0,-40
    80004844:	4505                	li	a0,1
    80004846:	ffffd097          	auipc	ra,0xffffd
    8000484a:	7c4080e7          	jalr	1988(ra) # 8000200a <argaddr>
    return -1;
    8000484e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004850:	00054d63          	bltz	a0,8000486a <sys_write+0x5c>
  return filewrite(f, p, n);
    80004854:	fe442603          	lw	a2,-28(s0)
    80004858:	fd843583          	ld	a1,-40(s0)
    8000485c:	fe843503          	ld	a0,-24(s0)
    80004860:	fffff097          	auipc	ra,0xfffff
    80004864:	490080e7          	jalr	1168(ra) # 80003cf0 <filewrite>
    80004868:	87aa                	mv	a5,a0
}
    8000486a:	853e                	mv	a0,a5
    8000486c:	70a2                	ld	ra,40(sp)
    8000486e:	7402                	ld	s0,32(sp)
    80004870:	6145                	addi	sp,sp,48
    80004872:	8082                	ret

0000000080004874 <sys_close>:
{
    80004874:	1101                	addi	sp,sp,-32
    80004876:	ec06                	sd	ra,24(sp)
    80004878:	e822                	sd	s0,16(sp)
    8000487a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000487c:	fe040613          	addi	a2,s0,-32
    80004880:	fec40593          	addi	a1,s0,-20
    80004884:	4501                	li	a0,0
    80004886:	00000097          	auipc	ra,0x0
    8000488a:	cbe080e7          	jalr	-834(ra) # 80004544 <argfd>
    return -1;
    8000488e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004890:	02054463          	bltz	a0,800048b8 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004894:	ffffc097          	auipc	ra,0xffffc
    80004898:	632080e7          	jalr	1586(ra) # 80000ec6 <myproc>
    8000489c:	fec42783          	lw	a5,-20(s0)
    800048a0:	07e9                	addi	a5,a5,26
    800048a2:	078e                	slli	a5,a5,0x3
    800048a4:	953e                	add	a0,a0,a5
    800048a6:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800048aa:	fe043503          	ld	a0,-32(s0)
    800048ae:	fffff097          	auipc	ra,0xfffff
    800048b2:	21c080e7          	jalr	540(ra) # 80003aca <fileclose>
  return 0;
    800048b6:	4781                	li	a5,0
}
    800048b8:	853e                	mv	a0,a5
    800048ba:	60e2                	ld	ra,24(sp)
    800048bc:	6442                	ld	s0,16(sp)
    800048be:	6105                	addi	sp,sp,32
    800048c0:	8082                	ret

00000000800048c2 <sys_fstat>:
{
    800048c2:	1101                	addi	sp,sp,-32
    800048c4:	ec06                	sd	ra,24(sp)
    800048c6:	e822                	sd	s0,16(sp)
    800048c8:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048ca:	fe840613          	addi	a2,s0,-24
    800048ce:	4581                	li	a1,0
    800048d0:	4501                	li	a0,0
    800048d2:	00000097          	auipc	ra,0x0
    800048d6:	c72080e7          	jalr	-910(ra) # 80004544 <argfd>
    return -1;
    800048da:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048dc:	02054563          	bltz	a0,80004906 <sys_fstat+0x44>
    800048e0:	fe040593          	addi	a1,s0,-32
    800048e4:	4505                	li	a0,1
    800048e6:	ffffd097          	auipc	ra,0xffffd
    800048ea:	724080e7          	jalr	1828(ra) # 8000200a <argaddr>
    return -1;
    800048ee:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048f0:	00054b63          	bltz	a0,80004906 <sys_fstat+0x44>
  return filestat(f, st);
    800048f4:	fe043583          	ld	a1,-32(s0)
    800048f8:	fe843503          	ld	a0,-24(s0)
    800048fc:	fffff097          	auipc	ra,0xfffff
    80004900:	2b0080e7          	jalr	688(ra) # 80003bac <filestat>
    80004904:	87aa                	mv	a5,a0
}
    80004906:	853e                	mv	a0,a5
    80004908:	60e2                	ld	ra,24(sp)
    8000490a:	6442                	ld	s0,16(sp)
    8000490c:	6105                	addi	sp,sp,32
    8000490e:	8082                	ret

0000000080004910 <sys_link>:
{
    80004910:	7169                	addi	sp,sp,-304
    80004912:	f606                	sd	ra,296(sp)
    80004914:	f222                	sd	s0,288(sp)
    80004916:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004918:	08000613          	li	a2,128
    8000491c:	ed040593          	addi	a1,s0,-304
    80004920:	4501                	li	a0,0
    80004922:	ffffd097          	auipc	ra,0xffffd
    80004926:	70a080e7          	jalr	1802(ra) # 8000202c <argstr>
    return -1;
    8000492a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000492c:	12054663          	bltz	a0,80004a58 <sys_link+0x148>
    80004930:	08000613          	li	a2,128
    80004934:	f5040593          	addi	a1,s0,-176
    80004938:	4505                	li	a0,1
    8000493a:	ffffd097          	auipc	ra,0xffffd
    8000493e:	6f2080e7          	jalr	1778(ra) # 8000202c <argstr>
    return -1;
    80004942:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004944:	10054a63          	bltz	a0,80004a58 <sys_link+0x148>
    80004948:	ee26                	sd	s1,280(sp)
  begin_op();
    8000494a:	fffff097          	auipc	ra,0xfffff
    8000494e:	cb6080e7          	jalr	-842(ra) # 80003600 <begin_op>
  if((ip = namei(old)) == 0){
    80004952:	ed040513          	addi	a0,s0,-304
    80004956:	fffff097          	auipc	ra,0xfffff
    8000495a:	aaa080e7          	jalr	-1366(ra) # 80003400 <namei>
    8000495e:	84aa                	mv	s1,a0
    80004960:	c949                	beqz	a0,800049f2 <sys_link+0xe2>
  ilock(ip);
    80004962:	ffffe097          	auipc	ra,0xffffe
    80004966:	2cc080e7          	jalr	716(ra) # 80002c2e <ilock>
  if(ip->type == T_DIR){
    8000496a:	04449703          	lh	a4,68(s1)
    8000496e:	4785                	li	a5,1
    80004970:	08f70863          	beq	a4,a5,80004a00 <sys_link+0xf0>
    80004974:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004976:	04a4d783          	lhu	a5,74(s1)
    8000497a:	2785                	addiw	a5,a5,1
    8000497c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004980:	8526                	mv	a0,s1
    80004982:	ffffe097          	auipc	ra,0xffffe
    80004986:	1e0080e7          	jalr	480(ra) # 80002b62 <iupdate>
  iunlock(ip);
    8000498a:	8526                	mv	a0,s1
    8000498c:	ffffe097          	auipc	ra,0xffffe
    80004990:	368080e7          	jalr	872(ra) # 80002cf4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004994:	fd040593          	addi	a1,s0,-48
    80004998:	f5040513          	addi	a0,s0,-176
    8000499c:	fffff097          	auipc	ra,0xfffff
    800049a0:	a82080e7          	jalr	-1406(ra) # 8000341e <nameiparent>
    800049a4:	892a                	mv	s2,a0
    800049a6:	cd35                	beqz	a0,80004a22 <sys_link+0x112>
  ilock(dp);
    800049a8:	ffffe097          	auipc	ra,0xffffe
    800049ac:	286080e7          	jalr	646(ra) # 80002c2e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800049b0:	00092703          	lw	a4,0(s2)
    800049b4:	409c                	lw	a5,0(s1)
    800049b6:	06f71163          	bne	a4,a5,80004a18 <sys_link+0x108>
    800049ba:	40d0                	lw	a2,4(s1)
    800049bc:	fd040593          	addi	a1,s0,-48
    800049c0:	854a                	mv	a0,s2
    800049c2:	fffff097          	auipc	ra,0xfffff
    800049c6:	97c080e7          	jalr	-1668(ra) # 8000333e <dirlink>
    800049ca:	04054763          	bltz	a0,80004a18 <sys_link+0x108>
  iunlockput(dp);
    800049ce:	854a                	mv	a0,s2
    800049d0:	ffffe097          	auipc	ra,0xffffe
    800049d4:	4c4080e7          	jalr	1220(ra) # 80002e94 <iunlockput>
  iput(ip);
    800049d8:	8526                	mv	a0,s1
    800049da:	ffffe097          	auipc	ra,0xffffe
    800049de:	412080e7          	jalr	1042(ra) # 80002dec <iput>
  end_op();
    800049e2:	fffff097          	auipc	ra,0xfffff
    800049e6:	c98080e7          	jalr	-872(ra) # 8000367a <end_op>
  return 0;
    800049ea:	4781                	li	a5,0
    800049ec:	64f2                	ld	s1,280(sp)
    800049ee:	6952                	ld	s2,272(sp)
    800049f0:	a0a5                	j	80004a58 <sys_link+0x148>
    end_op();
    800049f2:	fffff097          	auipc	ra,0xfffff
    800049f6:	c88080e7          	jalr	-888(ra) # 8000367a <end_op>
    return -1;
    800049fa:	57fd                	li	a5,-1
    800049fc:	64f2                	ld	s1,280(sp)
    800049fe:	a8a9                	j	80004a58 <sys_link+0x148>
    iunlockput(ip);
    80004a00:	8526                	mv	a0,s1
    80004a02:	ffffe097          	auipc	ra,0xffffe
    80004a06:	492080e7          	jalr	1170(ra) # 80002e94 <iunlockput>
    end_op();
    80004a0a:	fffff097          	auipc	ra,0xfffff
    80004a0e:	c70080e7          	jalr	-912(ra) # 8000367a <end_op>
    return -1;
    80004a12:	57fd                	li	a5,-1
    80004a14:	64f2                	ld	s1,280(sp)
    80004a16:	a089                	j	80004a58 <sys_link+0x148>
    iunlockput(dp);
    80004a18:	854a                	mv	a0,s2
    80004a1a:	ffffe097          	auipc	ra,0xffffe
    80004a1e:	47a080e7          	jalr	1146(ra) # 80002e94 <iunlockput>
  ilock(ip);
    80004a22:	8526                	mv	a0,s1
    80004a24:	ffffe097          	auipc	ra,0xffffe
    80004a28:	20a080e7          	jalr	522(ra) # 80002c2e <ilock>
  ip->nlink--;
    80004a2c:	04a4d783          	lhu	a5,74(s1)
    80004a30:	37fd                	addiw	a5,a5,-1
    80004a32:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a36:	8526                	mv	a0,s1
    80004a38:	ffffe097          	auipc	ra,0xffffe
    80004a3c:	12a080e7          	jalr	298(ra) # 80002b62 <iupdate>
  iunlockput(ip);
    80004a40:	8526                	mv	a0,s1
    80004a42:	ffffe097          	auipc	ra,0xffffe
    80004a46:	452080e7          	jalr	1106(ra) # 80002e94 <iunlockput>
  end_op();
    80004a4a:	fffff097          	auipc	ra,0xfffff
    80004a4e:	c30080e7          	jalr	-976(ra) # 8000367a <end_op>
  return -1;
    80004a52:	57fd                	li	a5,-1
    80004a54:	64f2                	ld	s1,280(sp)
    80004a56:	6952                	ld	s2,272(sp)
}
    80004a58:	853e                	mv	a0,a5
    80004a5a:	70b2                	ld	ra,296(sp)
    80004a5c:	7412                	ld	s0,288(sp)
    80004a5e:	6155                	addi	sp,sp,304
    80004a60:	8082                	ret

0000000080004a62 <sys_unlink>:
{
    80004a62:	7151                	addi	sp,sp,-240
    80004a64:	f586                	sd	ra,232(sp)
    80004a66:	f1a2                	sd	s0,224(sp)
    80004a68:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a6a:	08000613          	li	a2,128
    80004a6e:	f3040593          	addi	a1,s0,-208
    80004a72:	4501                	li	a0,0
    80004a74:	ffffd097          	auipc	ra,0xffffd
    80004a78:	5b8080e7          	jalr	1464(ra) # 8000202c <argstr>
    80004a7c:	1a054a63          	bltz	a0,80004c30 <sys_unlink+0x1ce>
    80004a80:	eda6                	sd	s1,216(sp)
  begin_op();
    80004a82:	fffff097          	auipc	ra,0xfffff
    80004a86:	b7e080e7          	jalr	-1154(ra) # 80003600 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a8a:	fb040593          	addi	a1,s0,-80
    80004a8e:	f3040513          	addi	a0,s0,-208
    80004a92:	fffff097          	auipc	ra,0xfffff
    80004a96:	98c080e7          	jalr	-1652(ra) # 8000341e <nameiparent>
    80004a9a:	84aa                	mv	s1,a0
    80004a9c:	cd71                	beqz	a0,80004b78 <sys_unlink+0x116>
  ilock(dp);
    80004a9e:	ffffe097          	auipc	ra,0xffffe
    80004aa2:	190080e7          	jalr	400(ra) # 80002c2e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004aa6:	00004597          	auipc	a1,0x4
    80004aaa:	b9258593          	addi	a1,a1,-1134 # 80008638 <etext+0x638>
    80004aae:	fb040513          	addi	a0,s0,-80
    80004ab2:	ffffe097          	auipc	ra,0xffffe
    80004ab6:	662080e7          	jalr	1634(ra) # 80003114 <namecmp>
    80004aba:	14050c63          	beqz	a0,80004c12 <sys_unlink+0x1b0>
    80004abe:	00004597          	auipc	a1,0x4
    80004ac2:	b8258593          	addi	a1,a1,-1150 # 80008640 <etext+0x640>
    80004ac6:	fb040513          	addi	a0,s0,-80
    80004aca:	ffffe097          	auipc	ra,0xffffe
    80004ace:	64a080e7          	jalr	1610(ra) # 80003114 <namecmp>
    80004ad2:	14050063          	beqz	a0,80004c12 <sys_unlink+0x1b0>
    80004ad6:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004ad8:	f2c40613          	addi	a2,s0,-212
    80004adc:	fb040593          	addi	a1,s0,-80
    80004ae0:	8526                	mv	a0,s1
    80004ae2:	ffffe097          	auipc	ra,0xffffe
    80004ae6:	64c080e7          	jalr	1612(ra) # 8000312e <dirlookup>
    80004aea:	892a                	mv	s2,a0
    80004aec:	12050263          	beqz	a0,80004c10 <sys_unlink+0x1ae>
  ilock(ip);
    80004af0:	ffffe097          	auipc	ra,0xffffe
    80004af4:	13e080e7          	jalr	318(ra) # 80002c2e <ilock>
  if(ip->nlink < 1)
    80004af8:	04a91783          	lh	a5,74(s2)
    80004afc:	08f05563          	blez	a5,80004b86 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b00:	04491703          	lh	a4,68(s2)
    80004b04:	4785                	li	a5,1
    80004b06:	08f70963          	beq	a4,a5,80004b98 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004b0a:	4641                	li	a2,16
    80004b0c:	4581                	li	a1,0
    80004b0e:	fc040513          	addi	a0,s0,-64
    80004b12:	ffffb097          	auipc	ra,0xffffb
    80004b16:	6b2080e7          	jalr	1714(ra) # 800001c4 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b1a:	4741                	li	a4,16
    80004b1c:	f2c42683          	lw	a3,-212(s0)
    80004b20:	fc040613          	addi	a2,s0,-64
    80004b24:	4581                	li	a1,0
    80004b26:	8526                	mv	a0,s1
    80004b28:	ffffe097          	auipc	ra,0xffffe
    80004b2c:	4c2080e7          	jalr	1218(ra) # 80002fea <writei>
    80004b30:	47c1                	li	a5,16
    80004b32:	0af51b63          	bne	a0,a5,80004be8 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004b36:	04491703          	lh	a4,68(s2)
    80004b3a:	4785                	li	a5,1
    80004b3c:	0af70f63          	beq	a4,a5,80004bfa <sys_unlink+0x198>
  iunlockput(dp);
    80004b40:	8526                	mv	a0,s1
    80004b42:	ffffe097          	auipc	ra,0xffffe
    80004b46:	352080e7          	jalr	850(ra) # 80002e94 <iunlockput>
  ip->nlink--;
    80004b4a:	04a95783          	lhu	a5,74(s2)
    80004b4e:	37fd                	addiw	a5,a5,-1
    80004b50:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b54:	854a                	mv	a0,s2
    80004b56:	ffffe097          	auipc	ra,0xffffe
    80004b5a:	00c080e7          	jalr	12(ra) # 80002b62 <iupdate>
  iunlockput(ip);
    80004b5e:	854a                	mv	a0,s2
    80004b60:	ffffe097          	auipc	ra,0xffffe
    80004b64:	334080e7          	jalr	820(ra) # 80002e94 <iunlockput>
  end_op();
    80004b68:	fffff097          	auipc	ra,0xfffff
    80004b6c:	b12080e7          	jalr	-1262(ra) # 8000367a <end_op>
  return 0;
    80004b70:	4501                	li	a0,0
    80004b72:	64ee                	ld	s1,216(sp)
    80004b74:	694e                	ld	s2,208(sp)
    80004b76:	a84d                	j	80004c28 <sys_unlink+0x1c6>
    end_op();
    80004b78:	fffff097          	auipc	ra,0xfffff
    80004b7c:	b02080e7          	jalr	-1278(ra) # 8000367a <end_op>
    return -1;
    80004b80:	557d                	li	a0,-1
    80004b82:	64ee                	ld	s1,216(sp)
    80004b84:	a055                	j	80004c28 <sys_unlink+0x1c6>
    80004b86:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004b88:	00004517          	auipc	a0,0x4
    80004b8c:	ae050513          	addi	a0,a0,-1312 # 80008668 <etext+0x668>
    80004b90:	00001097          	auipc	ra,0x1
    80004b94:	20c080e7          	jalr	524(ra) # 80005d9c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b98:	04c92703          	lw	a4,76(s2)
    80004b9c:	02000793          	li	a5,32
    80004ba0:	f6e7f5e3          	bgeu	a5,a4,80004b0a <sys_unlink+0xa8>
    80004ba4:	e5ce                	sd	s3,200(sp)
    80004ba6:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004baa:	4741                	li	a4,16
    80004bac:	86ce                	mv	a3,s3
    80004bae:	f1840613          	addi	a2,s0,-232
    80004bb2:	4581                	li	a1,0
    80004bb4:	854a                	mv	a0,s2
    80004bb6:	ffffe097          	auipc	ra,0xffffe
    80004bba:	330080e7          	jalr	816(ra) # 80002ee6 <readi>
    80004bbe:	47c1                	li	a5,16
    80004bc0:	00f51c63          	bne	a0,a5,80004bd8 <sys_unlink+0x176>
    if(de.inum != 0)
    80004bc4:	f1845783          	lhu	a5,-232(s0)
    80004bc8:	e7b5                	bnez	a5,80004c34 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bca:	29c1                	addiw	s3,s3,16
    80004bcc:	04c92783          	lw	a5,76(s2)
    80004bd0:	fcf9ede3          	bltu	s3,a5,80004baa <sys_unlink+0x148>
    80004bd4:	69ae                	ld	s3,200(sp)
    80004bd6:	bf15                	j	80004b0a <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004bd8:	00004517          	auipc	a0,0x4
    80004bdc:	aa850513          	addi	a0,a0,-1368 # 80008680 <etext+0x680>
    80004be0:	00001097          	auipc	ra,0x1
    80004be4:	1bc080e7          	jalr	444(ra) # 80005d9c <panic>
    80004be8:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004bea:	00004517          	auipc	a0,0x4
    80004bee:	aae50513          	addi	a0,a0,-1362 # 80008698 <etext+0x698>
    80004bf2:	00001097          	auipc	ra,0x1
    80004bf6:	1aa080e7          	jalr	426(ra) # 80005d9c <panic>
    dp->nlink--;
    80004bfa:	04a4d783          	lhu	a5,74(s1)
    80004bfe:	37fd                	addiw	a5,a5,-1
    80004c00:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c04:	8526                	mv	a0,s1
    80004c06:	ffffe097          	auipc	ra,0xffffe
    80004c0a:	f5c080e7          	jalr	-164(ra) # 80002b62 <iupdate>
    80004c0e:	bf0d                	j	80004b40 <sys_unlink+0xde>
    80004c10:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004c12:	8526                	mv	a0,s1
    80004c14:	ffffe097          	auipc	ra,0xffffe
    80004c18:	280080e7          	jalr	640(ra) # 80002e94 <iunlockput>
  end_op();
    80004c1c:	fffff097          	auipc	ra,0xfffff
    80004c20:	a5e080e7          	jalr	-1442(ra) # 8000367a <end_op>
  return -1;
    80004c24:	557d                	li	a0,-1
    80004c26:	64ee                	ld	s1,216(sp)
}
    80004c28:	70ae                	ld	ra,232(sp)
    80004c2a:	740e                	ld	s0,224(sp)
    80004c2c:	616d                	addi	sp,sp,240
    80004c2e:	8082                	ret
    return -1;
    80004c30:	557d                	li	a0,-1
    80004c32:	bfdd                	j	80004c28 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004c34:	854a                	mv	a0,s2
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	25e080e7          	jalr	606(ra) # 80002e94 <iunlockput>
    goto bad;
    80004c3e:	694e                	ld	s2,208(sp)
    80004c40:	69ae                	ld	s3,200(sp)
    80004c42:	bfc1                	j	80004c12 <sys_unlink+0x1b0>

0000000080004c44 <sys_open>:

uint64
sys_open(void)
{
    80004c44:	7131                	addi	sp,sp,-192
    80004c46:	fd06                	sd	ra,184(sp)
    80004c48:	f922                	sd	s0,176(sp)
    80004c4a:	f526                	sd	s1,168(sp)
    80004c4c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c4e:	08000613          	li	a2,128
    80004c52:	f5040593          	addi	a1,s0,-176
    80004c56:	4501                	li	a0,0
    80004c58:	ffffd097          	auipc	ra,0xffffd
    80004c5c:	3d4080e7          	jalr	980(ra) # 8000202c <argstr>
    return -1;
    80004c60:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c62:	0c054463          	bltz	a0,80004d2a <sys_open+0xe6>
    80004c66:	f4c40593          	addi	a1,s0,-180
    80004c6a:	4505                	li	a0,1
    80004c6c:	ffffd097          	auipc	ra,0xffffd
    80004c70:	37c080e7          	jalr	892(ra) # 80001fe8 <argint>
    80004c74:	0a054b63          	bltz	a0,80004d2a <sys_open+0xe6>
    80004c78:	f14a                	sd	s2,160(sp)

  begin_op();
    80004c7a:	fffff097          	auipc	ra,0xfffff
    80004c7e:	986080e7          	jalr	-1658(ra) # 80003600 <begin_op>

  if(omode & O_CREATE){
    80004c82:	f4c42783          	lw	a5,-180(s0)
    80004c86:	2007f793          	andi	a5,a5,512
    80004c8a:	cfc5                	beqz	a5,80004d42 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c8c:	4681                	li	a3,0
    80004c8e:	4601                	li	a2,0
    80004c90:	4589                	li	a1,2
    80004c92:	f5040513          	addi	a0,s0,-176
    80004c96:	00000097          	auipc	ra,0x0
    80004c9a:	958080e7          	jalr	-1704(ra) # 800045ee <create>
    80004c9e:	892a                	mv	s2,a0
    if(ip == 0){
    80004ca0:	c959                	beqz	a0,80004d36 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ca2:	04491703          	lh	a4,68(s2)
    80004ca6:	478d                	li	a5,3
    80004ca8:	00f71763          	bne	a4,a5,80004cb6 <sys_open+0x72>
    80004cac:	04695703          	lhu	a4,70(s2)
    80004cb0:	47a5                	li	a5,9
    80004cb2:	0ce7ef63          	bltu	a5,a4,80004d90 <sys_open+0x14c>
    80004cb6:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004cb8:	fffff097          	auipc	ra,0xfffff
    80004cbc:	d56080e7          	jalr	-682(ra) # 80003a0e <filealloc>
    80004cc0:	89aa                	mv	s3,a0
    80004cc2:	c965                	beqz	a0,80004db2 <sys_open+0x16e>
    80004cc4:	00000097          	auipc	ra,0x0
    80004cc8:	8e8080e7          	jalr	-1816(ra) # 800045ac <fdalloc>
    80004ccc:	84aa                	mv	s1,a0
    80004cce:	0c054d63          	bltz	a0,80004da8 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004cd2:	04491703          	lh	a4,68(s2)
    80004cd6:	478d                	li	a5,3
    80004cd8:	0ef70a63          	beq	a4,a5,80004dcc <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004cdc:	4789                	li	a5,2
    80004cde:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004ce2:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004ce6:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004cea:	f4c42783          	lw	a5,-180(s0)
    80004cee:	0017c713          	xori	a4,a5,1
    80004cf2:	8b05                	andi	a4,a4,1
    80004cf4:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cf8:	0037f713          	andi	a4,a5,3
    80004cfc:	00e03733          	snez	a4,a4
    80004d00:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d04:	4007f793          	andi	a5,a5,1024
    80004d08:	c791                	beqz	a5,80004d14 <sys_open+0xd0>
    80004d0a:	04491703          	lh	a4,68(s2)
    80004d0e:	4789                	li	a5,2
    80004d10:	0cf70563          	beq	a4,a5,80004dda <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004d14:	854a                	mv	a0,s2
    80004d16:	ffffe097          	auipc	ra,0xffffe
    80004d1a:	fde080e7          	jalr	-34(ra) # 80002cf4 <iunlock>
  end_op();
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	95c080e7          	jalr	-1700(ra) # 8000367a <end_op>
    80004d26:	790a                	ld	s2,160(sp)
    80004d28:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004d2a:	8526                	mv	a0,s1
    80004d2c:	70ea                	ld	ra,184(sp)
    80004d2e:	744a                	ld	s0,176(sp)
    80004d30:	74aa                	ld	s1,168(sp)
    80004d32:	6129                	addi	sp,sp,192
    80004d34:	8082                	ret
      end_op();
    80004d36:	fffff097          	auipc	ra,0xfffff
    80004d3a:	944080e7          	jalr	-1724(ra) # 8000367a <end_op>
      return -1;
    80004d3e:	790a                	ld	s2,160(sp)
    80004d40:	b7ed                	j	80004d2a <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004d42:	f5040513          	addi	a0,s0,-176
    80004d46:	ffffe097          	auipc	ra,0xffffe
    80004d4a:	6ba080e7          	jalr	1722(ra) # 80003400 <namei>
    80004d4e:	892a                	mv	s2,a0
    80004d50:	c90d                	beqz	a0,80004d82 <sys_open+0x13e>
    ilock(ip);
    80004d52:	ffffe097          	auipc	ra,0xffffe
    80004d56:	edc080e7          	jalr	-292(ra) # 80002c2e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d5a:	04491703          	lh	a4,68(s2)
    80004d5e:	4785                	li	a5,1
    80004d60:	f4f711e3          	bne	a4,a5,80004ca2 <sys_open+0x5e>
    80004d64:	f4c42783          	lw	a5,-180(s0)
    80004d68:	d7b9                	beqz	a5,80004cb6 <sys_open+0x72>
      iunlockput(ip);
    80004d6a:	854a                	mv	a0,s2
    80004d6c:	ffffe097          	auipc	ra,0xffffe
    80004d70:	128080e7          	jalr	296(ra) # 80002e94 <iunlockput>
      end_op();
    80004d74:	fffff097          	auipc	ra,0xfffff
    80004d78:	906080e7          	jalr	-1786(ra) # 8000367a <end_op>
      return -1;
    80004d7c:	54fd                	li	s1,-1
    80004d7e:	790a                	ld	s2,160(sp)
    80004d80:	b76d                	j	80004d2a <sys_open+0xe6>
      end_op();
    80004d82:	fffff097          	auipc	ra,0xfffff
    80004d86:	8f8080e7          	jalr	-1800(ra) # 8000367a <end_op>
      return -1;
    80004d8a:	54fd                	li	s1,-1
    80004d8c:	790a                	ld	s2,160(sp)
    80004d8e:	bf71                	j	80004d2a <sys_open+0xe6>
    iunlockput(ip);
    80004d90:	854a                	mv	a0,s2
    80004d92:	ffffe097          	auipc	ra,0xffffe
    80004d96:	102080e7          	jalr	258(ra) # 80002e94 <iunlockput>
    end_op();
    80004d9a:	fffff097          	auipc	ra,0xfffff
    80004d9e:	8e0080e7          	jalr	-1824(ra) # 8000367a <end_op>
    return -1;
    80004da2:	54fd                	li	s1,-1
    80004da4:	790a                	ld	s2,160(sp)
    80004da6:	b751                	j	80004d2a <sys_open+0xe6>
      fileclose(f);
    80004da8:	854e                	mv	a0,s3
    80004daa:	fffff097          	auipc	ra,0xfffff
    80004dae:	d20080e7          	jalr	-736(ra) # 80003aca <fileclose>
    iunlockput(ip);
    80004db2:	854a                	mv	a0,s2
    80004db4:	ffffe097          	auipc	ra,0xffffe
    80004db8:	0e0080e7          	jalr	224(ra) # 80002e94 <iunlockput>
    end_op();
    80004dbc:	fffff097          	auipc	ra,0xfffff
    80004dc0:	8be080e7          	jalr	-1858(ra) # 8000367a <end_op>
    return -1;
    80004dc4:	54fd                	li	s1,-1
    80004dc6:	790a                	ld	s2,160(sp)
    80004dc8:	69ea                	ld	s3,152(sp)
    80004dca:	b785                	j	80004d2a <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004dcc:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004dd0:	04691783          	lh	a5,70(s2)
    80004dd4:	02f99223          	sh	a5,36(s3)
    80004dd8:	b739                	j	80004ce6 <sys_open+0xa2>
    itrunc(ip);
    80004dda:	854a                	mv	a0,s2
    80004ddc:	ffffe097          	auipc	ra,0xffffe
    80004de0:	f64080e7          	jalr	-156(ra) # 80002d40 <itrunc>
    80004de4:	bf05                	j	80004d14 <sys_open+0xd0>

0000000080004de6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004de6:	7175                	addi	sp,sp,-144
    80004de8:	e506                	sd	ra,136(sp)
    80004dea:	e122                	sd	s0,128(sp)
    80004dec:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004dee:	fffff097          	auipc	ra,0xfffff
    80004df2:	812080e7          	jalr	-2030(ra) # 80003600 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004df6:	08000613          	li	a2,128
    80004dfa:	f7040593          	addi	a1,s0,-144
    80004dfe:	4501                	li	a0,0
    80004e00:	ffffd097          	auipc	ra,0xffffd
    80004e04:	22c080e7          	jalr	556(ra) # 8000202c <argstr>
    80004e08:	02054963          	bltz	a0,80004e3a <sys_mkdir+0x54>
    80004e0c:	4681                	li	a3,0
    80004e0e:	4601                	li	a2,0
    80004e10:	4585                	li	a1,1
    80004e12:	f7040513          	addi	a0,s0,-144
    80004e16:	fffff097          	auipc	ra,0xfffff
    80004e1a:	7d8080e7          	jalr	2008(ra) # 800045ee <create>
    80004e1e:	cd11                	beqz	a0,80004e3a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e20:	ffffe097          	auipc	ra,0xffffe
    80004e24:	074080e7          	jalr	116(ra) # 80002e94 <iunlockput>
  end_op();
    80004e28:	fffff097          	auipc	ra,0xfffff
    80004e2c:	852080e7          	jalr	-1966(ra) # 8000367a <end_op>
  return 0;
    80004e30:	4501                	li	a0,0
}
    80004e32:	60aa                	ld	ra,136(sp)
    80004e34:	640a                	ld	s0,128(sp)
    80004e36:	6149                	addi	sp,sp,144
    80004e38:	8082                	ret
    end_op();
    80004e3a:	fffff097          	auipc	ra,0xfffff
    80004e3e:	840080e7          	jalr	-1984(ra) # 8000367a <end_op>
    return -1;
    80004e42:	557d                	li	a0,-1
    80004e44:	b7fd                	j	80004e32 <sys_mkdir+0x4c>

0000000080004e46 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e46:	7135                	addi	sp,sp,-160
    80004e48:	ed06                	sd	ra,152(sp)
    80004e4a:	e922                	sd	s0,144(sp)
    80004e4c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e4e:	ffffe097          	auipc	ra,0xffffe
    80004e52:	7b2080e7          	jalr	1970(ra) # 80003600 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e56:	08000613          	li	a2,128
    80004e5a:	f7040593          	addi	a1,s0,-144
    80004e5e:	4501                	li	a0,0
    80004e60:	ffffd097          	auipc	ra,0xffffd
    80004e64:	1cc080e7          	jalr	460(ra) # 8000202c <argstr>
    80004e68:	04054a63          	bltz	a0,80004ebc <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e6c:	f6c40593          	addi	a1,s0,-148
    80004e70:	4505                	li	a0,1
    80004e72:	ffffd097          	auipc	ra,0xffffd
    80004e76:	176080e7          	jalr	374(ra) # 80001fe8 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e7a:	04054163          	bltz	a0,80004ebc <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e7e:	f6840593          	addi	a1,s0,-152
    80004e82:	4509                	li	a0,2
    80004e84:	ffffd097          	auipc	ra,0xffffd
    80004e88:	164080e7          	jalr	356(ra) # 80001fe8 <argint>
     argint(1, &major) < 0 ||
    80004e8c:	02054863          	bltz	a0,80004ebc <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e90:	f6841683          	lh	a3,-152(s0)
    80004e94:	f6c41603          	lh	a2,-148(s0)
    80004e98:	458d                	li	a1,3
    80004e9a:	f7040513          	addi	a0,s0,-144
    80004e9e:	fffff097          	auipc	ra,0xfffff
    80004ea2:	750080e7          	jalr	1872(ra) # 800045ee <create>
     argint(2, &minor) < 0 ||
    80004ea6:	c919                	beqz	a0,80004ebc <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ea8:	ffffe097          	auipc	ra,0xffffe
    80004eac:	fec080e7          	jalr	-20(ra) # 80002e94 <iunlockput>
  end_op();
    80004eb0:	ffffe097          	auipc	ra,0xffffe
    80004eb4:	7ca080e7          	jalr	1994(ra) # 8000367a <end_op>
  return 0;
    80004eb8:	4501                	li	a0,0
    80004eba:	a031                	j	80004ec6 <sys_mknod+0x80>
    end_op();
    80004ebc:	ffffe097          	auipc	ra,0xffffe
    80004ec0:	7be080e7          	jalr	1982(ra) # 8000367a <end_op>
    return -1;
    80004ec4:	557d                	li	a0,-1
}
    80004ec6:	60ea                	ld	ra,152(sp)
    80004ec8:	644a                	ld	s0,144(sp)
    80004eca:	610d                	addi	sp,sp,160
    80004ecc:	8082                	ret

0000000080004ece <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ece:	7135                	addi	sp,sp,-160
    80004ed0:	ed06                	sd	ra,152(sp)
    80004ed2:	e922                	sd	s0,144(sp)
    80004ed4:	e14a                	sd	s2,128(sp)
    80004ed6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ed8:	ffffc097          	auipc	ra,0xffffc
    80004edc:	fee080e7          	jalr	-18(ra) # 80000ec6 <myproc>
    80004ee0:	892a                	mv	s2,a0
  
  begin_op();
    80004ee2:	ffffe097          	auipc	ra,0xffffe
    80004ee6:	71e080e7          	jalr	1822(ra) # 80003600 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004eea:	08000613          	li	a2,128
    80004eee:	f6040593          	addi	a1,s0,-160
    80004ef2:	4501                	li	a0,0
    80004ef4:	ffffd097          	auipc	ra,0xffffd
    80004ef8:	138080e7          	jalr	312(ra) # 8000202c <argstr>
    80004efc:	04054d63          	bltz	a0,80004f56 <sys_chdir+0x88>
    80004f00:	e526                	sd	s1,136(sp)
    80004f02:	f6040513          	addi	a0,s0,-160
    80004f06:	ffffe097          	auipc	ra,0xffffe
    80004f0a:	4fa080e7          	jalr	1274(ra) # 80003400 <namei>
    80004f0e:	84aa                	mv	s1,a0
    80004f10:	c131                	beqz	a0,80004f54 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f12:	ffffe097          	auipc	ra,0xffffe
    80004f16:	d1c080e7          	jalr	-740(ra) # 80002c2e <ilock>
  if(ip->type != T_DIR){
    80004f1a:	04449703          	lh	a4,68(s1)
    80004f1e:	4785                	li	a5,1
    80004f20:	04f71163          	bne	a4,a5,80004f62 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f24:	8526                	mv	a0,s1
    80004f26:	ffffe097          	auipc	ra,0xffffe
    80004f2a:	dce080e7          	jalr	-562(ra) # 80002cf4 <iunlock>
  iput(p->cwd);
    80004f2e:	15093503          	ld	a0,336(s2)
    80004f32:	ffffe097          	auipc	ra,0xffffe
    80004f36:	eba080e7          	jalr	-326(ra) # 80002dec <iput>
  end_op();
    80004f3a:	ffffe097          	auipc	ra,0xffffe
    80004f3e:	740080e7          	jalr	1856(ra) # 8000367a <end_op>
  p->cwd = ip;
    80004f42:	14993823          	sd	s1,336(s2)
  return 0;
    80004f46:	4501                	li	a0,0
    80004f48:	64aa                	ld	s1,136(sp)
}
    80004f4a:	60ea                	ld	ra,152(sp)
    80004f4c:	644a                	ld	s0,144(sp)
    80004f4e:	690a                	ld	s2,128(sp)
    80004f50:	610d                	addi	sp,sp,160
    80004f52:	8082                	ret
    80004f54:	64aa                	ld	s1,136(sp)
    end_op();
    80004f56:	ffffe097          	auipc	ra,0xffffe
    80004f5a:	724080e7          	jalr	1828(ra) # 8000367a <end_op>
    return -1;
    80004f5e:	557d                	li	a0,-1
    80004f60:	b7ed                	j	80004f4a <sys_chdir+0x7c>
    iunlockput(ip);
    80004f62:	8526                	mv	a0,s1
    80004f64:	ffffe097          	auipc	ra,0xffffe
    80004f68:	f30080e7          	jalr	-208(ra) # 80002e94 <iunlockput>
    end_op();
    80004f6c:	ffffe097          	auipc	ra,0xffffe
    80004f70:	70e080e7          	jalr	1806(ra) # 8000367a <end_op>
    return -1;
    80004f74:	557d                	li	a0,-1
    80004f76:	64aa                	ld	s1,136(sp)
    80004f78:	bfc9                	j	80004f4a <sys_chdir+0x7c>

0000000080004f7a <sys_exec>:

uint64
sys_exec(void)
{
    80004f7a:	7121                	addi	sp,sp,-448
    80004f7c:	ff06                	sd	ra,440(sp)
    80004f7e:	fb22                	sd	s0,432(sp)
    80004f80:	f34a                	sd	s2,416(sp)
    80004f82:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f84:	08000613          	li	a2,128
    80004f88:	f5040593          	addi	a1,s0,-176
    80004f8c:	4501                	li	a0,0
    80004f8e:	ffffd097          	auipc	ra,0xffffd
    80004f92:	09e080e7          	jalr	158(ra) # 8000202c <argstr>
    return -1;
    80004f96:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f98:	0e054a63          	bltz	a0,8000508c <sys_exec+0x112>
    80004f9c:	e4840593          	addi	a1,s0,-440
    80004fa0:	4505                	li	a0,1
    80004fa2:	ffffd097          	auipc	ra,0xffffd
    80004fa6:	068080e7          	jalr	104(ra) # 8000200a <argaddr>
    80004faa:	0e054163          	bltz	a0,8000508c <sys_exec+0x112>
    80004fae:	f726                	sd	s1,424(sp)
    80004fb0:	ef4e                	sd	s3,408(sp)
    80004fb2:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004fb4:	10000613          	li	a2,256
    80004fb8:	4581                	li	a1,0
    80004fba:	e5040513          	addi	a0,s0,-432
    80004fbe:	ffffb097          	auipc	ra,0xffffb
    80004fc2:	206080e7          	jalr	518(ra) # 800001c4 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004fc6:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004fca:	89a6                	mv	s3,s1
    80004fcc:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004fce:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fd2:	00391513          	slli	a0,s2,0x3
    80004fd6:	e4040593          	addi	a1,s0,-448
    80004fda:	e4843783          	ld	a5,-440(s0)
    80004fde:	953e                	add	a0,a0,a5
    80004fe0:	ffffd097          	auipc	ra,0xffffd
    80004fe4:	f6e080e7          	jalr	-146(ra) # 80001f4e <fetchaddr>
    80004fe8:	02054a63          	bltz	a0,8000501c <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80004fec:	e4043783          	ld	a5,-448(s0)
    80004ff0:	c7b1                	beqz	a5,8000503c <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ff2:	ffffb097          	auipc	ra,0xffffb
    80004ff6:	128080e7          	jalr	296(ra) # 8000011a <kalloc>
    80004ffa:	85aa                	mv	a1,a0
    80004ffc:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005000:	cd11                	beqz	a0,8000501c <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005002:	6605                	lui	a2,0x1
    80005004:	e4043503          	ld	a0,-448(s0)
    80005008:	ffffd097          	auipc	ra,0xffffd
    8000500c:	f98080e7          	jalr	-104(ra) # 80001fa0 <fetchstr>
    80005010:	00054663          	bltz	a0,8000501c <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80005014:	0905                	addi	s2,s2,1
    80005016:	09a1                	addi	s3,s3,8
    80005018:	fb491de3          	bne	s2,s4,80004fd2 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000501c:	f5040913          	addi	s2,s0,-176
    80005020:	6088                	ld	a0,0(s1)
    80005022:	c12d                	beqz	a0,80005084 <sys_exec+0x10a>
    kfree(argv[i]);
    80005024:	ffffb097          	auipc	ra,0xffffb
    80005028:	ff8080e7          	jalr	-8(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000502c:	04a1                	addi	s1,s1,8
    8000502e:	ff2499e3          	bne	s1,s2,80005020 <sys_exec+0xa6>
  return -1;
    80005032:	597d                	li	s2,-1
    80005034:	74ba                	ld	s1,424(sp)
    80005036:	69fa                	ld	s3,408(sp)
    80005038:	6a5a                	ld	s4,400(sp)
    8000503a:	a889                	j	8000508c <sys_exec+0x112>
      argv[i] = 0;
    8000503c:	0009079b          	sext.w	a5,s2
    80005040:	078e                	slli	a5,a5,0x3
    80005042:	fd078793          	addi	a5,a5,-48
    80005046:	97a2                	add	a5,a5,s0
    80005048:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000504c:	e5040593          	addi	a1,s0,-432
    80005050:	f5040513          	addi	a0,s0,-176
    80005054:	fffff097          	auipc	ra,0xfffff
    80005058:	126080e7          	jalr	294(ra) # 8000417a <exec>
    8000505c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000505e:	f5040993          	addi	s3,s0,-176
    80005062:	6088                	ld	a0,0(s1)
    80005064:	cd01                	beqz	a0,8000507c <sys_exec+0x102>
    kfree(argv[i]);
    80005066:	ffffb097          	auipc	ra,0xffffb
    8000506a:	fb6080e7          	jalr	-74(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000506e:	04a1                	addi	s1,s1,8
    80005070:	ff3499e3          	bne	s1,s3,80005062 <sys_exec+0xe8>
    80005074:	74ba                	ld	s1,424(sp)
    80005076:	69fa                	ld	s3,408(sp)
    80005078:	6a5a                	ld	s4,400(sp)
    8000507a:	a809                	j	8000508c <sys_exec+0x112>
  return ret;
    8000507c:	74ba                	ld	s1,424(sp)
    8000507e:	69fa                	ld	s3,408(sp)
    80005080:	6a5a                	ld	s4,400(sp)
    80005082:	a029                	j	8000508c <sys_exec+0x112>
  return -1;
    80005084:	597d                	li	s2,-1
    80005086:	74ba                	ld	s1,424(sp)
    80005088:	69fa                	ld	s3,408(sp)
    8000508a:	6a5a                	ld	s4,400(sp)
}
    8000508c:	854a                	mv	a0,s2
    8000508e:	70fa                	ld	ra,440(sp)
    80005090:	745a                	ld	s0,432(sp)
    80005092:	791a                	ld	s2,416(sp)
    80005094:	6139                	addi	sp,sp,448
    80005096:	8082                	ret

0000000080005098 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005098:	7139                	addi	sp,sp,-64
    8000509a:	fc06                	sd	ra,56(sp)
    8000509c:	f822                	sd	s0,48(sp)
    8000509e:	f426                	sd	s1,40(sp)
    800050a0:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050a2:	ffffc097          	auipc	ra,0xffffc
    800050a6:	e24080e7          	jalr	-476(ra) # 80000ec6 <myproc>
    800050aa:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800050ac:	fd840593          	addi	a1,s0,-40
    800050b0:	4501                	li	a0,0
    800050b2:	ffffd097          	auipc	ra,0xffffd
    800050b6:	f58080e7          	jalr	-168(ra) # 8000200a <argaddr>
    return -1;
    800050ba:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800050bc:	0e054063          	bltz	a0,8000519c <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800050c0:	fc840593          	addi	a1,s0,-56
    800050c4:	fd040513          	addi	a0,s0,-48
    800050c8:	fffff097          	auipc	ra,0xfffff
    800050cc:	d70080e7          	jalr	-656(ra) # 80003e38 <pipealloc>
    return -1;
    800050d0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050d2:	0c054563          	bltz	a0,8000519c <sys_pipe+0x104>
  fd0 = -1;
    800050d6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050da:	fd043503          	ld	a0,-48(s0)
    800050de:	fffff097          	auipc	ra,0xfffff
    800050e2:	4ce080e7          	jalr	1230(ra) # 800045ac <fdalloc>
    800050e6:	fca42223          	sw	a0,-60(s0)
    800050ea:	08054c63          	bltz	a0,80005182 <sys_pipe+0xea>
    800050ee:	fc843503          	ld	a0,-56(s0)
    800050f2:	fffff097          	auipc	ra,0xfffff
    800050f6:	4ba080e7          	jalr	1210(ra) # 800045ac <fdalloc>
    800050fa:	fca42023          	sw	a0,-64(s0)
    800050fe:	06054963          	bltz	a0,80005170 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005102:	4691                	li	a3,4
    80005104:	fc440613          	addi	a2,s0,-60
    80005108:	fd843583          	ld	a1,-40(s0)
    8000510c:	68a8                	ld	a0,80(s1)
    8000510e:	ffffc097          	auipc	ra,0xffffc
    80005112:	a54080e7          	jalr	-1452(ra) # 80000b62 <copyout>
    80005116:	02054063          	bltz	a0,80005136 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000511a:	4691                	li	a3,4
    8000511c:	fc040613          	addi	a2,s0,-64
    80005120:	fd843583          	ld	a1,-40(s0)
    80005124:	0591                	addi	a1,a1,4
    80005126:	68a8                	ld	a0,80(s1)
    80005128:	ffffc097          	auipc	ra,0xffffc
    8000512c:	a3a080e7          	jalr	-1478(ra) # 80000b62 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005130:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005132:	06055563          	bgez	a0,8000519c <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005136:	fc442783          	lw	a5,-60(s0)
    8000513a:	07e9                	addi	a5,a5,26
    8000513c:	078e                	slli	a5,a5,0x3
    8000513e:	97a6                	add	a5,a5,s1
    80005140:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005144:	fc042783          	lw	a5,-64(s0)
    80005148:	07e9                	addi	a5,a5,26
    8000514a:	078e                	slli	a5,a5,0x3
    8000514c:	00f48533          	add	a0,s1,a5
    80005150:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005154:	fd043503          	ld	a0,-48(s0)
    80005158:	fffff097          	auipc	ra,0xfffff
    8000515c:	972080e7          	jalr	-1678(ra) # 80003aca <fileclose>
    fileclose(wf);
    80005160:	fc843503          	ld	a0,-56(s0)
    80005164:	fffff097          	auipc	ra,0xfffff
    80005168:	966080e7          	jalr	-1690(ra) # 80003aca <fileclose>
    return -1;
    8000516c:	57fd                	li	a5,-1
    8000516e:	a03d                	j	8000519c <sys_pipe+0x104>
    if(fd0 >= 0)
    80005170:	fc442783          	lw	a5,-60(s0)
    80005174:	0007c763          	bltz	a5,80005182 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005178:	07e9                	addi	a5,a5,26
    8000517a:	078e                	slli	a5,a5,0x3
    8000517c:	97a6                	add	a5,a5,s1
    8000517e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005182:	fd043503          	ld	a0,-48(s0)
    80005186:	fffff097          	auipc	ra,0xfffff
    8000518a:	944080e7          	jalr	-1724(ra) # 80003aca <fileclose>
    fileclose(wf);
    8000518e:	fc843503          	ld	a0,-56(s0)
    80005192:	fffff097          	auipc	ra,0xfffff
    80005196:	938080e7          	jalr	-1736(ra) # 80003aca <fileclose>
    return -1;
    8000519a:	57fd                	li	a5,-1
}
    8000519c:	853e                	mv	a0,a5
    8000519e:	70e2                	ld	ra,56(sp)
    800051a0:	7442                	ld	s0,48(sp)
    800051a2:	74a2                	ld	s1,40(sp)
    800051a4:	6121                	addi	sp,sp,64
    800051a6:	8082                	ret
	...

00000000800051b0 <kernelvec>:
    800051b0:	7111                	addi	sp,sp,-256
    800051b2:	e006                	sd	ra,0(sp)
    800051b4:	e40a                	sd	sp,8(sp)
    800051b6:	e80e                	sd	gp,16(sp)
    800051b8:	ec12                	sd	tp,24(sp)
    800051ba:	f016                	sd	t0,32(sp)
    800051bc:	f41a                	sd	t1,40(sp)
    800051be:	f81e                	sd	t2,48(sp)
    800051c0:	fc22                	sd	s0,56(sp)
    800051c2:	e0a6                	sd	s1,64(sp)
    800051c4:	e4aa                	sd	a0,72(sp)
    800051c6:	e8ae                	sd	a1,80(sp)
    800051c8:	ecb2                	sd	a2,88(sp)
    800051ca:	f0b6                	sd	a3,96(sp)
    800051cc:	f4ba                	sd	a4,104(sp)
    800051ce:	f8be                	sd	a5,112(sp)
    800051d0:	fcc2                	sd	a6,120(sp)
    800051d2:	e146                	sd	a7,128(sp)
    800051d4:	e54a                	sd	s2,136(sp)
    800051d6:	e94e                	sd	s3,144(sp)
    800051d8:	ed52                	sd	s4,152(sp)
    800051da:	f156                	sd	s5,160(sp)
    800051dc:	f55a                	sd	s6,168(sp)
    800051de:	f95e                	sd	s7,176(sp)
    800051e0:	fd62                	sd	s8,184(sp)
    800051e2:	e1e6                	sd	s9,192(sp)
    800051e4:	e5ea                	sd	s10,200(sp)
    800051e6:	e9ee                	sd	s11,208(sp)
    800051e8:	edf2                	sd	t3,216(sp)
    800051ea:	f1f6                	sd	t4,224(sp)
    800051ec:	f5fa                	sd	t5,232(sp)
    800051ee:	f9fe                	sd	t6,240(sp)
    800051f0:	c2bfc0ef          	jal	80001e1a <kerneltrap>
    800051f4:	6082                	ld	ra,0(sp)
    800051f6:	6122                	ld	sp,8(sp)
    800051f8:	61c2                	ld	gp,16(sp)
    800051fa:	7282                	ld	t0,32(sp)
    800051fc:	7322                	ld	t1,40(sp)
    800051fe:	73c2                	ld	t2,48(sp)
    80005200:	7462                	ld	s0,56(sp)
    80005202:	6486                	ld	s1,64(sp)
    80005204:	6526                	ld	a0,72(sp)
    80005206:	65c6                	ld	a1,80(sp)
    80005208:	6666                	ld	a2,88(sp)
    8000520a:	7686                	ld	a3,96(sp)
    8000520c:	7726                	ld	a4,104(sp)
    8000520e:	77c6                	ld	a5,112(sp)
    80005210:	7866                	ld	a6,120(sp)
    80005212:	688a                	ld	a7,128(sp)
    80005214:	692a                	ld	s2,136(sp)
    80005216:	69ca                	ld	s3,144(sp)
    80005218:	6a6a                	ld	s4,152(sp)
    8000521a:	7a8a                	ld	s5,160(sp)
    8000521c:	7b2a                	ld	s6,168(sp)
    8000521e:	7bca                	ld	s7,176(sp)
    80005220:	7c6a                	ld	s8,184(sp)
    80005222:	6c8e                	ld	s9,192(sp)
    80005224:	6d2e                	ld	s10,200(sp)
    80005226:	6dce                	ld	s11,208(sp)
    80005228:	6e6e                	ld	t3,216(sp)
    8000522a:	7e8e                	ld	t4,224(sp)
    8000522c:	7f2e                	ld	t5,232(sp)
    8000522e:	7fce                	ld	t6,240(sp)
    80005230:	6111                	addi	sp,sp,256
    80005232:	10200073          	sret
    80005236:	00000013          	nop
    8000523a:	00000013          	nop
    8000523e:	0001                	nop

0000000080005240 <timervec>:
    80005240:	34051573          	csrrw	a0,mscratch,a0
    80005244:	e10c                	sd	a1,0(a0)
    80005246:	e510                	sd	a2,8(a0)
    80005248:	e914                	sd	a3,16(a0)
    8000524a:	6d0c                	ld	a1,24(a0)
    8000524c:	7110                	ld	a2,32(a0)
    8000524e:	6194                	ld	a3,0(a1)
    80005250:	96b2                	add	a3,a3,a2
    80005252:	e194                	sd	a3,0(a1)
    80005254:	4589                	li	a1,2
    80005256:	14459073          	csrw	sip,a1
    8000525a:	6914                	ld	a3,16(a0)
    8000525c:	6510                	ld	a2,8(a0)
    8000525e:	610c                	ld	a1,0(a0)
    80005260:	34051573          	csrrw	a0,mscratch,a0
    80005264:	30200073          	mret
	...

000000008000526a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000526a:	1141                	addi	sp,sp,-16
    8000526c:	e422                	sd	s0,8(sp)
    8000526e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005270:	0c0007b7          	lui	a5,0xc000
    80005274:	4705                	li	a4,1
    80005276:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005278:	0c0007b7          	lui	a5,0xc000
    8000527c:	c3d8                	sw	a4,4(a5)
}
    8000527e:	6422                	ld	s0,8(sp)
    80005280:	0141                	addi	sp,sp,16
    80005282:	8082                	ret

0000000080005284 <plicinithart>:

void
plicinithart(void)
{
    80005284:	1141                	addi	sp,sp,-16
    80005286:	e406                	sd	ra,8(sp)
    80005288:	e022                	sd	s0,0(sp)
    8000528a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000528c:	ffffc097          	auipc	ra,0xffffc
    80005290:	c0e080e7          	jalr	-1010(ra) # 80000e9a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005294:	0085171b          	slliw	a4,a0,0x8
    80005298:	0c0027b7          	lui	a5,0xc002
    8000529c:	97ba                	add	a5,a5,a4
    8000529e:	40200713          	li	a4,1026
    800052a2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052a6:	00d5151b          	slliw	a0,a0,0xd
    800052aa:	0c2017b7          	lui	a5,0xc201
    800052ae:	97aa                	add	a5,a5,a0
    800052b0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800052b4:	60a2                	ld	ra,8(sp)
    800052b6:	6402                	ld	s0,0(sp)
    800052b8:	0141                	addi	sp,sp,16
    800052ba:	8082                	ret

00000000800052bc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052bc:	1141                	addi	sp,sp,-16
    800052be:	e406                	sd	ra,8(sp)
    800052c0:	e022                	sd	s0,0(sp)
    800052c2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052c4:	ffffc097          	auipc	ra,0xffffc
    800052c8:	bd6080e7          	jalr	-1066(ra) # 80000e9a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052cc:	00d5151b          	slliw	a0,a0,0xd
    800052d0:	0c2017b7          	lui	a5,0xc201
    800052d4:	97aa                	add	a5,a5,a0
  return irq;
}
    800052d6:	43c8                	lw	a0,4(a5)
    800052d8:	60a2                	ld	ra,8(sp)
    800052da:	6402                	ld	s0,0(sp)
    800052dc:	0141                	addi	sp,sp,16
    800052de:	8082                	ret

00000000800052e0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052e0:	1101                	addi	sp,sp,-32
    800052e2:	ec06                	sd	ra,24(sp)
    800052e4:	e822                	sd	s0,16(sp)
    800052e6:	e426                	sd	s1,8(sp)
    800052e8:	1000                	addi	s0,sp,32
    800052ea:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052ec:	ffffc097          	auipc	ra,0xffffc
    800052f0:	bae080e7          	jalr	-1106(ra) # 80000e9a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052f4:	00d5151b          	slliw	a0,a0,0xd
    800052f8:	0c2017b7          	lui	a5,0xc201
    800052fc:	97aa                	add	a5,a5,a0
    800052fe:	c3c4                	sw	s1,4(a5)
}
    80005300:	60e2                	ld	ra,24(sp)
    80005302:	6442                	ld	s0,16(sp)
    80005304:	64a2                	ld	s1,8(sp)
    80005306:	6105                	addi	sp,sp,32
    80005308:	8082                	ret

000000008000530a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000530a:	1141                	addi	sp,sp,-16
    8000530c:	e406                	sd	ra,8(sp)
    8000530e:	e022                	sd	s0,0(sp)
    80005310:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005312:	479d                	li	a5,7
    80005314:	06a7c863          	blt	a5,a0,80005384 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005318:	00019717          	auipc	a4,0x19
    8000531c:	ce870713          	addi	a4,a4,-792 # 8001e000 <disk>
    80005320:	972a                	add	a4,a4,a0
    80005322:	6789                	lui	a5,0x2
    80005324:	97ba                	add	a5,a5,a4
    80005326:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000532a:	e7ad                	bnez	a5,80005394 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000532c:	00451793          	slli	a5,a0,0x4
    80005330:	0001b717          	auipc	a4,0x1b
    80005334:	cd070713          	addi	a4,a4,-816 # 80020000 <disk+0x2000>
    80005338:	6314                	ld	a3,0(a4)
    8000533a:	96be                	add	a3,a3,a5
    8000533c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005340:	6314                	ld	a3,0(a4)
    80005342:	96be                	add	a3,a3,a5
    80005344:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005348:	6314                	ld	a3,0(a4)
    8000534a:	96be                	add	a3,a3,a5
    8000534c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005350:	6318                	ld	a4,0(a4)
    80005352:	97ba                	add	a5,a5,a4
    80005354:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005358:	00019717          	auipc	a4,0x19
    8000535c:	ca870713          	addi	a4,a4,-856 # 8001e000 <disk>
    80005360:	972a                	add	a4,a4,a0
    80005362:	6789                	lui	a5,0x2
    80005364:	97ba                	add	a5,a5,a4
    80005366:	4705                	li	a4,1
    80005368:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000536c:	0001b517          	auipc	a0,0x1b
    80005370:	cac50513          	addi	a0,a0,-852 # 80020018 <disk+0x2018>
    80005374:	ffffc097          	auipc	ra,0xffffc
    80005378:	3b0080e7          	jalr	944(ra) # 80001724 <wakeup>
}
    8000537c:	60a2                	ld	ra,8(sp)
    8000537e:	6402                	ld	s0,0(sp)
    80005380:	0141                	addi	sp,sp,16
    80005382:	8082                	ret
    panic("free_desc 1");
    80005384:	00003517          	auipc	a0,0x3
    80005388:	32450513          	addi	a0,a0,804 # 800086a8 <etext+0x6a8>
    8000538c:	00001097          	auipc	ra,0x1
    80005390:	a10080e7          	jalr	-1520(ra) # 80005d9c <panic>
    panic("free_desc 2");
    80005394:	00003517          	auipc	a0,0x3
    80005398:	32450513          	addi	a0,a0,804 # 800086b8 <etext+0x6b8>
    8000539c:	00001097          	auipc	ra,0x1
    800053a0:	a00080e7          	jalr	-1536(ra) # 80005d9c <panic>

00000000800053a4 <virtio_disk_init>:
{
    800053a4:	1141                	addi	sp,sp,-16
    800053a6:	e406                	sd	ra,8(sp)
    800053a8:	e022                	sd	s0,0(sp)
    800053aa:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053ac:	00003597          	auipc	a1,0x3
    800053b0:	31c58593          	addi	a1,a1,796 # 800086c8 <etext+0x6c8>
    800053b4:	0001b517          	auipc	a0,0x1b
    800053b8:	d7450513          	addi	a0,a0,-652 # 80020128 <disk+0x2128>
    800053bc:	00001097          	auipc	ra,0x1
    800053c0:	eca080e7          	jalr	-310(ra) # 80006286 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053c4:	100017b7          	lui	a5,0x10001
    800053c8:	4398                	lw	a4,0(a5)
    800053ca:	2701                	sext.w	a4,a4
    800053cc:	747277b7          	lui	a5,0x74727
    800053d0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053d4:	0ef71f63          	bne	a4,a5,800054d2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053d8:	100017b7          	lui	a5,0x10001
    800053dc:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800053de:	439c                	lw	a5,0(a5)
    800053e0:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053e2:	4705                	li	a4,1
    800053e4:	0ee79763          	bne	a5,a4,800054d2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053e8:	100017b7          	lui	a5,0x10001
    800053ec:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800053ee:	439c                	lw	a5,0(a5)
    800053f0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053f2:	4709                	li	a4,2
    800053f4:	0ce79f63          	bne	a5,a4,800054d2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053f8:	100017b7          	lui	a5,0x10001
    800053fc:	47d8                	lw	a4,12(a5)
    800053fe:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005400:	554d47b7          	lui	a5,0x554d4
    80005404:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005408:	0cf71563          	bne	a4,a5,800054d2 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000540c:	100017b7          	lui	a5,0x10001
    80005410:	4705                	li	a4,1
    80005412:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005414:	470d                	li	a4,3
    80005416:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005418:	10001737          	lui	a4,0x10001
    8000541c:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000541e:	c7ffe737          	lui	a4,0xc7ffe
    80005422:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd551f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005426:	8ef9                	and	a3,a3,a4
    80005428:	10001737          	lui	a4,0x10001
    8000542c:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000542e:	472d                	li	a4,11
    80005430:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005432:	473d                	li	a4,15
    80005434:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005436:	100017b7          	lui	a5,0x10001
    8000543a:	6705                	lui	a4,0x1
    8000543c:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000543e:	100017b7          	lui	a5,0x10001
    80005442:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005446:	100017b7          	lui	a5,0x10001
    8000544a:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000544e:	439c                	lw	a5,0(a5)
    80005450:	2781                	sext.w	a5,a5
  if(max == 0)
    80005452:	cbc1                	beqz	a5,800054e2 <virtio_disk_init+0x13e>
  if(max < NUM)
    80005454:	471d                	li	a4,7
    80005456:	08f77e63          	bgeu	a4,a5,800054f2 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000545a:	100017b7          	lui	a5,0x10001
    8000545e:	4721                	li	a4,8
    80005460:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005462:	6609                	lui	a2,0x2
    80005464:	4581                	li	a1,0
    80005466:	00019517          	auipc	a0,0x19
    8000546a:	b9a50513          	addi	a0,a0,-1126 # 8001e000 <disk>
    8000546e:	ffffb097          	auipc	ra,0xffffb
    80005472:	d56080e7          	jalr	-682(ra) # 800001c4 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005476:	00019697          	auipc	a3,0x19
    8000547a:	b8a68693          	addi	a3,a3,-1142 # 8001e000 <disk>
    8000547e:	00c6d713          	srli	a4,a3,0xc
    80005482:	2701                	sext.w	a4,a4
    80005484:	100017b7          	lui	a5,0x10001
    80005488:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000548a:	0001b797          	auipc	a5,0x1b
    8000548e:	b7678793          	addi	a5,a5,-1162 # 80020000 <disk+0x2000>
    80005492:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005494:	00019717          	auipc	a4,0x19
    80005498:	bec70713          	addi	a4,a4,-1044 # 8001e080 <disk+0x80>
    8000549c:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000549e:	0001a717          	auipc	a4,0x1a
    800054a2:	b6270713          	addi	a4,a4,-1182 # 8001f000 <disk+0x1000>
    800054a6:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800054a8:	4705                	li	a4,1
    800054aa:	00e78c23          	sb	a4,24(a5)
    800054ae:	00e78ca3          	sb	a4,25(a5)
    800054b2:	00e78d23          	sb	a4,26(a5)
    800054b6:	00e78da3          	sb	a4,27(a5)
    800054ba:	00e78e23          	sb	a4,28(a5)
    800054be:	00e78ea3          	sb	a4,29(a5)
    800054c2:	00e78f23          	sb	a4,30(a5)
    800054c6:	00e78fa3          	sb	a4,31(a5)
}
    800054ca:	60a2                	ld	ra,8(sp)
    800054cc:	6402                	ld	s0,0(sp)
    800054ce:	0141                	addi	sp,sp,16
    800054d0:	8082                	ret
    panic("could not find virtio disk");
    800054d2:	00003517          	auipc	a0,0x3
    800054d6:	20650513          	addi	a0,a0,518 # 800086d8 <etext+0x6d8>
    800054da:	00001097          	auipc	ra,0x1
    800054de:	8c2080e7          	jalr	-1854(ra) # 80005d9c <panic>
    panic("virtio disk has no queue 0");
    800054e2:	00003517          	auipc	a0,0x3
    800054e6:	21650513          	addi	a0,a0,534 # 800086f8 <etext+0x6f8>
    800054ea:	00001097          	auipc	ra,0x1
    800054ee:	8b2080e7          	jalr	-1870(ra) # 80005d9c <panic>
    panic("virtio disk max queue too short");
    800054f2:	00003517          	auipc	a0,0x3
    800054f6:	22650513          	addi	a0,a0,550 # 80008718 <etext+0x718>
    800054fa:	00001097          	auipc	ra,0x1
    800054fe:	8a2080e7          	jalr	-1886(ra) # 80005d9c <panic>

0000000080005502 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005502:	7159                	addi	sp,sp,-112
    80005504:	f486                	sd	ra,104(sp)
    80005506:	f0a2                	sd	s0,96(sp)
    80005508:	eca6                	sd	s1,88(sp)
    8000550a:	e8ca                	sd	s2,80(sp)
    8000550c:	e4ce                	sd	s3,72(sp)
    8000550e:	e0d2                	sd	s4,64(sp)
    80005510:	fc56                	sd	s5,56(sp)
    80005512:	f85a                	sd	s6,48(sp)
    80005514:	f45e                	sd	s7,40(sp)
    80005516:	f062                	sd	s8,32(sp)
    80005518:	ec66                	sd	s9,24(sp)
    8000551a:	1880                	addi	s0,sp,112
    8000551c:	8a2a                	mv	s4,a0
    8000551e:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005520:	00c52c03          	lw	s8,12(a0)
    80005524:	001c1c1b          	slliw	s8,s8,0x1
    80005528:	1c02                	slli	s8,s8,0x20
    8000552a:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    8000552e:	0001b517          	auipc	a0,0x1b
    80005532:	bfa50513          	addi	a0,a0,-1030 # 80020128 <disk+0x2128>
    80005536:	00001097          	auipc	ra,0x1
    8000553a:	de0080e7          	jalr	-544(ra) # 80006316 <acquire>
  for(int i = 0; i < 3; i++){
    8000553e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005540:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005542:	00019b97          	auipc	s7,0x19
    80005546:	abeb8b93          	addi	s7,s7,-1346 # 8001e000 <disk>
    8000554a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000554c:	4a8d                	li	s5,3
    8000554e:	a88d                	j	800055c0 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80005550:	00fb8733          	add	a4,s7,a5
    80005554:	975a                	add	a4,a4,s6
    80005556:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000555a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000555c:	0207c563          	bltz	a5,80005586 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005560:	2905                	addiw	s2,s2,1
    80005562:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005564:	1b590163          	beq	s2,s5,80005706 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    80005568:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000556a:	0001b717          	auipc	a4,0x1b
    8000556e:	aae70713          	addi	a4,a4,-1362 # 80020018 <disk+0x2018>
    80005572:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005574:	00074683          	lbu	a3,0(a4)
    80005578:	fee1                	bnez	a3,80005550 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    8000557a:	2785                	addiw	a5,a5,1
    8000557c:	0705                	addi	a4,a4,1
    8000557e:	fe979be3          	bne	a5,s1,80005574 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005582:	57fd                	li	a5,-1
    80005584:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005586:	03205163          	blez	s2,800055a8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000558a:	f9042503          	lw	a0,-112(s0)
    8000558e:	00000097          	auipc	ra,0x0
    80005592:	d7c080e7          	jalr	-644(ra) # 8000530a <free_desc>
      for(int j = 0; j < i; j++)
    80005596:	4785                	li	a5,1
    80005598:	0127d863          	bge	a5,s2,800055a8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000559c:	f9442503          	lw	a0,-108(s0)
    800055a0:	00000097          	auipc	ra,0x0
    800055a4:	d6a080e7          	jalr	-662(ra) # 8000530a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055a8:	0001b597          	auipc	a1,0x1b
    800055ac:	b8058593          	addi	a1,a1,-1152 # 80020128 <disk+0x2128>
    800055b0:	0001b517          	auipc	a0,0x1b
    800055b4:	a6850513          	addi	a0,a0,-1432 # 80020018 <disk+0x2018>
    800055b8:	ffffc097          	auipc	ra,0xffffc
    800055bc:	fe0080e7          	jalr	-32(ra) # 80001598 <sleep>
  for(int i = 0; i < 3; i++){
    800055c0:	f9040613          	addi	a2,s0,-112
    800055c4:	894e                	mv	s2,s3
    800055c6:	b74d                	j	80005568 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055c8:	0001b717          	auipc	a4,0x1b
    800055cc:	a3873703          	ld	a4,-1480(a4) # 80020000 <disk+0x2000>
    800055d0:	973e                	add	a4,a4,a5
    800055d2:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055d6:	00019897          	auipc	a7,0x19
    800055da:	a2a88893          	addi	a7,a7,-1494 # 8001e000 <disk>
    800055de:	0001b717          	auipc	a4,0x1b
    800055e2:	a2270713          	addi	a4,a4,-1502 # 80020000 <disk+0x2000>
    800055e6:	6314                	ld	a3,0(a4)
    800055e8:	96be                	add	a3,a3,a5
    800055ea:	00c6d583          	lhu	a1,12(a3)
    800055ee:	0015e593          	ori	a1,a1,1
    800055f2:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800055f6:	f9842683          	lw	a3,-104(s0)
    800055fa:	630c                	ld	a1,0(a4)
    800055fc:	97ae                	add	a5,a5,a1
    800055fe:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005602:	20050593          	addi	a1,a0,512
    80005606:	0592                	slli	a1,a1,0x4
    80005608:	95c6                	add	a1,a1,a7
    8000560a:	57fd                	li	a5,-1
    8000560c:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005610:	00469793          	slli	a5,a3,0x4
    80005614:	00073803          	ld	a6,0(a4)
    80005618:	983e                	add	a6,a6,a5
    8000561a:	6689                	lui	a3,0x2
    8000561c:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005620:	96b2                	add	a3,a3,a2
    80005622:	96c6                	add	a3,a3,a7
    80005624:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005628:	6314                	ld	a3,0(a4)
    8000562a:	96be                	add	a3,a3,a5
    8000562c:	4605                	li	a2,1
    8000562e:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005630:	6314                	ld	a3,0(a4)
    80005632:	96be                	add	a3,a3,a5
    80005634:	4809                	li	a6,2
    80005636:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    8000563a:	6314                	ld	a3,0(a4)
    8000563c:	97b6                	add	a5,a5,a3
    8000563e:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005642:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005646:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000564a:	6714                	ld	a3,8(a4)
    8000564c:	0026d783          	lhu	a5,2(a3)
    80005650:	8b9d                	andi	a5,a5,7
    80005652:	0786                	slli	a5,a5,0x1
    80005654:	96be                	add	a3,a3,a5
    80005656:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000565a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000565e:	6718                	ld	a4,8(a4)
    80005660:	00275783          	lhu	a5,2(a4)
    80005664:	2785                	addiw	a5,a5,1
    80005666:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000566a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000566e:	100017b7          	lui	a5,0x10001
    80005672:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005676:	004a2783          	lw	a5,4(s4)
    8000567a:	02c79163          	bne	a5,a2,8000569c <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    8000567e:	0001b917          	auipc	s2,0x1b
    80005682:	aaa90913          	addi	s2,s2,-1366 # 80020128 <disk+0x2128>
  while(b->disk == 1) {
    80005686:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005688:	85ca                	mv	a1,s2
    8000568a:	8552                	mv	a0,s4
    8000568c:	ffffc097          	auipc	ra,0xffffc
    80005690:	f0c080e7          	jalr	-244(ra) # 80001598 <sleep>
  while(b->disk == 1) {
    80005694:	004a2783          	lw	a5,4(s4)
    80005698:	fe9788e3          	beq	a5,s1,80005688 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    8000569c:	f9042903          	lw	s2,-112(s0)
    800056a0:	20090713          	addi	a4,s2,512
    800056a4:	0712                	slli	a4,a4,0x4
    800056a6:	00019797          	auipc	a5,0x19
    800056aa:	95a78793          	addi	a5,a5,-1702 # 8001e000 <disk>
    800056ae:	97ba                	add	a5,a5,a4
    800056b0:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800056b4:	0001b997          	auipc	s3,0x1b
    800056b8:	94c98993          	addi	s3,s3,-1716 # 80020000 <disk+0x2000>
    800056bc:	00491713          	slli	a4,s2,0x4
    800056c0:	0009b783          	ld	a5,0(s3)
    800056c4:	97ba                	add	a5,a5,a4
    800056c6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056ca:	854a                	mv	a0,s2
    800056cc:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056d0:	00000097          	auipc	ra,0x0
    800056d4:	c3a080e7          	jalr	-966(ra) # 8000530a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056d8:	8885                	andi	s1,s1,1
    800056da:	f0ed                	bnez	s1,800056bc <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056dc:	0001b517          	auipc	a0,0x1b
    800056e0:	a4c50513          	addi	a0,a0,-1460 # 80020128 <disk+0x2128>
    800056e4:	00001097          	auipc	ra,0x1
    800056e8:	ce6080e7          	jalr	-794(ra) # 800063ca <release>
}
    800056ec:	70a6                	ld	ra,104(sp)
    800056ee:	7406                	ld	s0,96(sp)
    800056f0:	64e6                	ld	s1,88(sp)
    800056f2:	6946                	ld	s2,80(sp)
    800056f4:	69a6                	ld	s3,72(sp)
    800056f6:	6a06                	ld	s4,64(sp)
    800056f8:	7ae2                	ld	s5,56(sp)
    800056fa:	7b42                	ld	s6,48(sp)
    800056fc:	7ba2                	ld	s7,40(sp)
    800056fe:	7c02                	ld	s8,32(sp)
    80005700:	6ce2                	ld	s9,24(sp)
    80005702:	6165                	addi	sp,sp,112
    80005704:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005706:	f9042503          	lw	a0,-112(s0)
    8000570a:	00451613          	slli	a2,a0,0x4
  if(write)
    8000570e:	00019597          	auipc	a1,0x19
    80005712:	8f258593          	addi	a1,a1,-1806 # 8001e000 <disk>
    80005716:	20050793          	addi	a5,a0,512
    8000571a:	0792                	slli	a5,a5,0x4
    8000571c:	97ae                	add	a5,a5,a1
    8000571e:	01903733          	snez	a4,s9
    80005722:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    80005726:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    8000572a:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000572e:	0001b717          	auipc	a4,0x1b
    80005732:	8d270713          	addi	a4,a4,-1838 # 80020000 <disk+0x2000>
    80005736:	6314                	ld	a3,0(a4)
    80005738:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000573a:	6789                	lui	a5,0x2
    8000573c:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005740:	97b2                	add	a5,a5,a2
    80005742:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005744:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005746:	631c                	ld	a5,0(a4)
    80005748:	97b2                	add	a5,a5,a2
    8000574a:	46c1                	li	a3,16
    8000574c:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000574e:	631c                	ld	a5,0(a4)
    80005750:	97b2                	add	a5,a5,a2
    80005752:	4685                	li	a3,1
    80005754:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005758:	f9442783          	lw	a5,-108(s0)
    8000575c:	6314                	ld	a3,0(a4)
    8000575e:	96b2                	add	a3,a3,a2
    80005760:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005764:	0792                	slli	a5,a5,0x4
    80005766:	6314                	ld	a3,0(a4)
    80005768:	96be                	add	a3,a3,a5
    8000576a:	058a0593          	addi	a1,s4,88
    8000576e:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005770:	6318                	ld	a4,0(a4)
    80005772:	973e                	add	a4,a4,a5
    80005774:	40000693          	li	a3,1024
    80005778:	c714                	sw	a3,8(a4)
  if(write)
    8000577a:	e40c97e3          	bnez	s9,800055c8 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000577e:	0001b717          	auipc	a4,0x1b
    80005782:	88273703          	ld	a4,-1918(a4) # 80020000 <disk+0x2000>
    80005786:	973e                	add	a4,a4,a5
    80005788:	4689                	li	a3,2
    8000578a:	00d71623          	sh	a3,12(a4)
    8000578e:	b5a1                	j	800055d6 <virtio_disk_rw+0xd4>

0000000080005790 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005790:	1101                	addi	sp,sp,-32
    80005792:	ec06                	sd	ra,24(sp)
    80005794:	e822                	sd	s0,16(sp)
    80005796:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005798:	0001b517          	auipc	a0,0x1b
    8000579c:	99050513          	addi	a0,a0,-1648 # 80020128 <disk+0x2128>
    800057a0:	00001097          	auipc	ra,0x1
    800057a4:	b76080e7          	jalr	-1162(ra) # 80006316 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057a8:	100017b7          	lui	a5,0x10001
    800057ac:	53b8                	lw	a4,96(a5)
    800057ae:	8b0d                	andi	a4,a4,3
    800057b0:	100017b7          	lui	a5,0x10001
    800057b4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800057b6:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057ba:	0001b797          	auipc	a5,0x1b
    800057be:	84678793          	addi	a5,a5,-1978 # 80020000 <disk+0x2000>
    800057c2:	6b94                	ld	a3,16(a5)
    800057c4:	0207d703          	lhu	a4,32(a5)
    800057c8:	0026d783          	lhu	a5,2(a3)
    800057cc:	06f70563          	beq	a4,a5,80005836 <virtio_disk_intr+0xa6>
    800057d0:	e426                	sd	s1,8(sp)
    800057d2:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057d4:	00019917          	auipc	s2,0x19
    800057d8:	82c90913          	addi	s2,s2,-2004 # 8001e000 <disk>
    800057dc:	0001b497          	auipc	s1,0x1b
    800057e0:	82448493          	addi	s1,s1,-2012 # 80020000 <disk+0x2000>
    __sync_synchronize();
    800057e4:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057e8:	6898                	ld	a4,16(s1)
    800057ea:	0204d783          	lhu	a5,32(s1)
    800057ee:	8b9d                	andi	a5,a5,7
    800057f0:	078e                	slli	a5,a5,0x3
    800057f2:	97ba                	add	a5,a5,a4
    800057f4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057f6:	20078713          	addi	a4,a5,512
    800057fa:	0712                	slli	a4,a4,0x4
    800057fc:	974a                	add	a4,a4,s2
    800057fe:	03074703          	lbu	a4,48(a4)
    80005802:	e731                	bnez	a4,8000584e <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005804:	20078793          	addi	a5,a5,512
    80005808:	0792                	slli	a5,a5,0x4
    8000580a:	97ca                	add	a5,a5,s2
    8000580c:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    8000580e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005812:	ffffc097          	auipc	ra,0xffffc
    80005816:	f12080e7          	jalr	-238(ra) # 80001724 <wakeup>

    disk.used_idx += 1;
    8000581a:	0204d783          	lhu	a5,32(s1)
    8000581e:	2785                	addiw	a5,a5,1
    80005820:	17c2                	slli	a5,a5,0x30
    80005822:	93c1                	srli	a5,a5,0x30
    80005824:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005828:	6898                	ld	a4,16(s1)
    8000582a:	00275703          	lhu	a4,2(a4)
    8000582e:	faf71be3          	bne	a4,a5,800057e4 <virtio_disk_intr+0x54>
    80005832:	64a2                	ld	s1,8(sp)
    80005834:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005836:	0001b517          	auipc	a0,0x1b
    8000583a:	8f250513          	addi	a0,a0,-1806 # 80020128 <disk+0x2128>
    8000583e:	00001097          	auipc	ra,0x1
    80005842:	b8c080e7          	jalr	-1140(ra) # 800063ca <release>
}
    80005846:	60e2                	ld	ra,24(sp)
    80005848:	6442                	ld	s0,16(sp)
    8000584a:	6105                	addi	sp,sp,32
    8000584c:	8082                	ret
      panic("virtio_disk_intr status");
    8000584e:	00003517          	auipc	a0,0x3
    80005852:	eea50513          	addi	a0,a0,-278 # 80008738 <etext+0x738>
    80005856:	00000097          	auipc	ra,0x0
    8000585a:	546080e7          	jalr	1350(ra) # 80005d9c <panic>

000000008000585e <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000585e:	1141                	addi	sp,sp,-16
    80005860:	e422                	sd	s0,8(sp)
    80005862:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005864:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005868:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000586c:	0037979b          	slliw	a5,a5,0x3
    80005870:	02004737          	lui	a4,0x2004
    80005874:	97ba                	add	a5,a5,a4
    80005876:	0200c737          	lui	a4,0x200c
    8000587a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000587c:	6318                	ld	a4,0(a4)
    8000587e:	000f4637          	lui	a2,0xf4
    80005882:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005886:	9732                	add	a4,a4,a2
    80005888:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000588a:	00259693          	slli	a3,a1,0x2
    8000588e:	96ae                	add	a3,a3,a1
    80005890:	068e                	slli	a3,a3,0x3
    80005892:	0001b717          	auipc	a4,0x1b
    80005896:	76e70713          	addi	a4,a4,1902 # 80021000 <timer_scratch>
    8000589a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000589c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000589e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058a0:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058a4:	00000797          	auipc	a5,0x0
    800058a8:	99c78793          	addi	a5,a5,-1636 # 80005240 <timervec>
    800058ac:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058b0:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058b4:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058b8:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800058bc:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058c0:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058c4:	30479073          	csrw	mie,a5
}
    800058c8:	6422                	ld	s0,8(sp)
    800058ca:	0141                	addi	sp,sp,16
    800058cc:	8082                	ret

00000000800058ce <start>:
{
    800058ce:	1141                	addi	sp,sp,-16
    800058d0:	e406                	sd	ra,8(sp)
    800058d2:	e022                	sd	s0,0(sp)
    800058d4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058d6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058da:	7779                	lui	a4,0xffffe
    800058dc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd55bf>
    800058e0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058e2:	6705                	lui	a4,0x1
    800058e4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058e8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058ea:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058ee:	ffffb797          	auipc	a5,0xffffb
    800058f2:	a7478793          	addi	a5,a5,-1420 # 80000362 <main>
    800058f6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058fa:	4781                	li	a5,0
    800058fc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005900:	67c1                	lui	a5,0x10
    80005902:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005904:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005908:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000590c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005910:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005914:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005918:	57fd                	li	a5,-1
    8000591a:	83a9                	srli	a5,a5,0xa
    8000591c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005920:	47bd                	li	a5,15
    80005922:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005926:	00000097          	auipc	ra,0x0
    8000592a:	f38080e7          	jalr	-200(ra) # 8000585e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000592e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005932:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005934:	823e                	mv	tp,a5
  asm volatile("mret");
    80005936:	30200073          	mret
}
    8000593a:	60a2                	ld	ra,8(sp)
    8000593c:	6402                	ld	s0,0(sp)
    8000593e:	0141                	addi	sp,sp,16
    80005940:	8082                	ret

0000000080005942 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005942:	715d                	addi	sp,sp,-80
    80005944:	e486                	sd	ra,72(sp)
    80005946:	e0a2                	sd	s0,64(sp)
    80005948:	f84a                	sd	s2,48(sp)
    8000594a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000594c:	04c05663          	blez	a2,80005998 <consolewrite+0x56>
    80005950:	fc26                	sd	s1,56(sp)
    80005952:	f44e                	sd	s3,40(sp)
    80005954:	f052                	sd	s4,32(sp)
    80005956:	ec56                	sd	s5,24(sp)
    80005958:	8a2a                	mv	s4,a0
    8000595a:	84ae                	mv	s1,a1
    8000595c:	89b2                	mv	s3,a2
    8000595e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005960:	5afd                	li	s5,-1
    80005962:	4685                	li	a3,1
    80005964:	8626                	mv	a2,s1
    80005966:	85d2                	mv	a1,s4
    80005968:	fbf40513          	addi	a0,s0,-65
    8000596c:	ffffc097          	auipc	ra,0xffffc
    80005970:	026080e7          	jalr	38(ra) # 80001992 <either_copyin>
    80005974:	03550463          	beq	a0,s5,8000599c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005978:	fbf44503          	lbu	a0,-65(s0)
    8000597c:	00000097          	auipc	ra,0x0
    80005980:	7de080e7          	jalr	2014(ra) # 8000615a <uartputc>
  for(i = 0; i < n; i++){
    80005984:	2905                	addiw	s2,s2,1
    80005986:	0485                	addi	s1,s1,1
    80005988:	fd299de3          	bne	s3,s2,80005962 <consolewrite+0x20>
    8000598c:	894e                	mv	s2,s3
    8000598e:	74e2                	ld	s1,56(sp)
    80005990:	79a2                	ld	s3,40(sp)
    80005992:	7a02                	ld	s4,32(sp)
    80005994:	6ae2                	ld	s5,24(sp)
    80005996:	a039                	j	800059a4 <consolewrite+0x62>
    80005998:	4901                	li	s2,0
    8000599a:	a029                	j	800059a4 <consolewrite+0x62>
    8000599c:	74e2                	ld	s1,56(sp)
    8000599e:	79a2                	ld	s3,40(sp)
    800059a0:	7a02                	ld	s4,32(sp)
    800059a2:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    800059a4:	854a                	mv	a0,s2
    800059a6:	60a6                	ld	ra,72(sp)
    800059a8:	6406                	ld	s0,64(sp)
    800059aa:	7942                	ld	s2,48(sp)
    800059ac:	6161                	addi	sp,sp,80
    800059ae:	8082                	ret

00000000800059b0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059b0:	711d                	addi	sp,sp,-96
    800059b2:	ec86                	sd	ra,88(sp)
    800059b4:	e8a2                	sd	s0,80(sp)
    800059b6:	e4a6                	sd	s1,72(sp)
    800059b8:	e0ca                	sd	s2,64(sp)
    800059ba:	fc4e                	sd	s3,56(sp)
    800059bc:	f852                	sd	s4,48(sp)
    800059be:	f456                	sd	s5,40(sp)
    800059c0:	f05a                	sd	s6,32(sp)
    800059c2:	1080                	addi	s0,sp,96
    800059c4:	8aaa                	mv	s5,a0
    800059c6:	8a2e                	mv	s4,a1
    800059c8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059ca:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800059ce:	00023517          	auipc	a0,0x23
    800059d2:	77250513          	addi	a0,a0,1906 # 80029140 <cons>
    800059d6:	00001097          	auipc	ra,0x1
    800059da:	940080e7          	jalr	-1728(ra) # 80006316 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059de:	00023497          	auipc	s1,0x23
    800059e2:	76248493          	addi	s1,s1,1890 # 80029140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059e6:	00023917          	auipc	s2,0x23
    800059ea:	7f290913          	addi	s2,s2,2034 # 800291d8 <cons+0x98>
  while(n > 0){
    800059ee:	0d305463          	blez	s3,80005ab6 <consoleread+0x106>
    while(cons.r == cons.w){
    800059f2:	0984a783          	lw	a5,152(s1)
    800059f6:	09c4a703          	lw	a4,156(s1)
    800059fa:	0af71963          	bne	a4,a5,80005aac <consoleread+0xfc>
      if(myproc()->killed){
    800059fe:	ffffb097          	auipc	ra,0xffffb
    80005a02:	4c8080e7          	jalr	1224(ra) # 80000ec6 <myproc>
    80005a06:	551c                	lw	a5,40(a0)
    80005a08:	e7ad                	bnez	a5,80005a72 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80005a0a:	85a6                	mv	a1,s1
    80005a0c:	854a                	mv	a0,s2
    80005a0e:	ffffc097          	auipc	ra,0xffffc
    80005a12:	b8a080e7          	jalr	-1142(ra) # 80001598 <sleep>
    while(cons.r == cons.w){
    80005a16:	0984a783          	lw	a5,152(s1)
    80005a1a:	09c4a703          	lw	a4,156(s1)
    80005a1e:	fef700e3          	beq	a4,a5,800059fe <consoleread+0x4e>
    80005a22:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a24:	00023717          	auipc	a4,0x23
    80005a28:	71c70713          	addi	a4,a4,1820 # 80029140 <cons>
    80005a2c:	0017869b          	addiw	a3,a5,1
    80005a30:	08d72c23          	sw	a3,152(a4)
    80005a34:	07f7f693          	andi	a3,a5,127
    80005a38:	9736                	add	a4,a4,a3
    80005a3a:	01874703          	lbu	a4,24(a4)
    80005a3e:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005a42:	4691                	li	a3,4
    80005a44:	04db8a63          	beq	s7,a3,80005a98 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005a48:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a4c:	4685                	li	a3,1
    80005a4e:	faf40613          	addi	a2,s0,-81
    80005a52:	85d2                	mv	a1,s4
    80005a54:	8556                	mv	a0,s5
    80005a56:	ffffc097          	auipc	ra,0xffffc
    80005a5a:	ee6080e7          	jalr	-282(ra) # 8000193c <either_copyout>
    80005a5e:	57fd                	li	a5,-1
    80005a60:	04f50a63          	beq	a0,a5,80005ab4 <consoleread+0x104>
      break;

    dst++;
    80005a64:	0a05                	addi	s4,s4,1
    --n;
    80005a66:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005a68:	47a9                	li	a5,10
    80005a6a:	06fb8163          	beq	s7,a5,80005acc <consoleread+0x11c>
    80005a6e:	6be2                	ld	s7,24(sp)
    80005a70:	bfbd                	j	800059ee <consoleread+0x3e>
        release(&cons.lock);
    80005a72:	00023517          	auipc	a0,0x23
    80005a76:	6ce50513          	addi	a0,a0,1742 # 80029140 <cons>
    80005a7a:	00001097          	auipc	ra,0x1
    80005a7e:	950080e7          	jalr	-1712(ra) # 800063ca <release>
        return -1;
    80005a82:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005a84:	60e6                	ld	ra,88(sp)
    80005a86:	6446                	ld	s0,80(sp)
    80005a88:	64a6                	ld	s1,72(sp)
    80005a8a:	6906                	ld	s2,64(sp)
    80005a8c:	79e2                	ld	s3,56(sp)
    80005a8e:	7a42                	ld	s4,48(sp)
    80005a90:	7aa2                	ld	s5,40(sp)
    80005a92:	7b02                	ld	s6,32(sp)
    80005a94:	6125                	addi	sp,sp,96
    80005a96:	8082                	ret
      if(n < target){
    80005a98:	0009871b          	sext.w	a4,s3
    80005a9c:	01677a63          	bgeu	a4,s6,80005ab0 <consoleread+0x100>
        cons.r--;
    80005aa0:	00023717          	auipc	a4,0x23
    80005aa4:	72f72c23          	sw	a5,1848(a4) # 800291d8 <cons+0x98>
    80005aa8:	6be2                	ld	s7,24(sp)
    80005aaa:	a031                	j	80005ab6 <consoleread+0x106>
    80005aac:	ec5e                	sd	s7,24(sp)
    80005aae:	bf9d                	j	80005a24 <consoleread+0x74>
    80005ab0:	6be2                	ld	s7,24(sp)
    80005ab2:	a011                	j	80005ab6 <consoleread+0x106>
    80005ab4:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005ab6:	00023517          	auipc	a0,0x23
    80005aba:	68a50513          	addi	a0,a0,1674 # 80029140 <cons>
    80005abe:	00001097          	auipc	ra,0x1
    80005ac2:	90c080e7          	jalr	-1780(ra) # 800063ca <release>
  return target - n;
    80005ac6:	413b053b          	subw	a0,s6,s3
    80005aca:	bf6d                	j	80005a84 <consoleread+0xd4>
    80005acc:	6be2                	ld	s7,24(sp)
    80005ace:	b7e5                	j	80005ab6 <consoleread+0x106>

0000000080005ad0 <consputc>:
{
    80005ad0:	1141                	addi	sp,sp,-16
    80005ad2:	e406                	sd	ra,8(sp)
    80005ad4:	e022                	sd	s0,0(sp)
    80005ad6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005ad8:	10000793          	li	a5,256
    80005adc:	00f50a63          	beq	a0,a5,80005af0 <consputc+0x20>
    uartputc_sync(c);
    80005ae0:	00000097          	auipc	ra,0x0
    80005ae4:	59c080e7          	jalr	1436(ra) # 8000607c <uartputc_sync>
}
    80005ae8:	60a2                	ld	ra,8(sp)
    80005aea:	6402                	ld	s0,0(sp)
    80005aec:	0141                	addi	sp,sp,16
    80005aee:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005af0:	4521                	li	a0,8
    80005af2:	00000097          	auipc	ra,0x0
    80005af6:	58a080e7          	jalr	1418(ra) # 8000607c <uartputc_sync>
    80005afa:	02000513          	li	a0,32
    80005afe:	00000097          	auipc	ra,0x0
    80005b02:	57e080e7          	jalr	1406(ra) # 8000607c <uartputc_sync>
    80005b06:	4521                	li	a0,8
    80005b08:	00000097          	auipc	ra,0x0
    80005b0c:	574080e7          	jalr	1396(ra) # 8000607c <uartputc_sync>
    80005b10:	bfe1                	j	80005ae8 <consputc+0x18>

0000000080005b12 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b12:	1101                	addi	sp,sp,-32
    80005b14:	ec06                	sd	ra,24(sp)
    80005b16:	e822                	sd	s0,16(sp)
    80005b18:	e426                	sd	s1,8(sp)
    80005b1a:	1000                	addi	s0,sp,32
    80005b1c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b1e:	00023517          	auipc	a0,0x23
    80005b22:	62250513          	addi	a0,a0,1570 # 80029140 <cons>
    80005b26:	00000097          	auipc	ra,0x0
    80005b2a:	7f0080e7          	jalr	2032(ra) # 80006316 <acquire>

  switch(c){
    80005b2e:	47d5                	li	a5,21
    80005b30:	0af48563          	beq	s1,a5,80005bda <consoleintr+0xc8>
    80005b34:	0297c963          	blt	a5,s1,80005b66 <consoleintr+0x54>
    80005b38:	47a1                	li	a5,8
    80005b3a:	0ef48c63          	beq	s1,a5,80005c32 <consoleintr+0x120>
    80005b3e:	47c1                	li	a5,16
    80005b40:	10f49f63          	bne	s1,a5,80005c5e <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005b44:	ffffc097          	auipc	ra,0xffffc
    80005b48:	ea4080e7          	jalr	-348(ra) # 800019e8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b4c:	00023517          	auipc	a0,0x23
    80005b50:	5f450513          	addi	a0,a0,1524 # 80029140 <cons>
    80005b54:	00001097          	auipc	ra,0x1
    80005b58:	876080e7          	jalr	-1930(ra) # 800063ca <release>
}
    80005b5c:	60e2                	ld	ra,24(sp)
    80005b5e:	6442                	ld	s0,16(sp)
    80005b60:	64a2                	ld	s1,8(sp)
    80005b62:	6105                	addi	sp,sp,32
    80005b64:	8082                	ret
  switch(c){
    80005b66:	07f00793          	li	a5,127
    80005b6a:	0cf48463          	beq	s1,a5,80005c32 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b6e:	00023717          	auipc	a4,0x23
    80005b72:	5d270713          	addi	a4,a4,1490 # 80029140 <cons>
    80005b76:	0a072783          	lw	a5,160(a4)
    80005b7a:	09872703          	lw	a4,152(a4)
    80005b7e:	9f99                	subw	a5,a5,a4
    80005b80:	07f00713          	li	a4,127
    80005b84:	fcf764e3          	bltu	a4,a5,80005b4c <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005b88:	47b5                	li	a5,13
    80005b8a:	0cf48d63          	beq	s1,a5,80005c64 <consoleintr+0x152>
      consputc(c);
    80005b8e:	8526                	mv	a0,s1
    80005b90:	00000097          	auipc	ra,0x0
    80005b94:	f40080e7          	jalr	-192(ra) # 80005ad0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b98:	00023797          	auipc	a5,0x23
    80005b9c:	5a878793          	addi	a5,a5,1448 # 80029140 <cons>
    80005ba0:	0a07a703          	lw	a4,160(a5)
    80005ba4:	0017069b          	addiw	a3,a4,1
    80005ba8:	0006861b          	sext.w	a2,a3
    80005bac:	0ad7a023          	sw	a3,160(a5)
    80005bb0:	07f77713          	andi	a4,a4,127
    80005bb4:	97ba                	add	a5,a5,a4
    80005bb6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005bba:	47a9                	li	a5,10
    80005bbc:	0cf48b63          	beq	s1,a5,80005c92 <consoleintr+0x180>
    80005bc0:	4791                	li	a5,4
    80005bc2:	0cf48863          	beq	s1,a5,80005c92 <consoleintr+0x180>
    80005bc6:	00023797          	auipc	a5,0x23
    80005bca:	6127a783          	lw	a5,1554(a5) # 800291d8 <cons+0x98>
    80005bce:	0807879b          	addiw	a5,a5,128
    80005bd2:	f6f61de3          	bne	a2,a5,80005b4c <consoleintr+0x3a>
    80005bd6:	863e                	mv	a2,a5
    80005bd8:	a86d                	j	80005c92 <consoleintr+0x180>
    80005bda:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005bdc:	00023717          	auipc	a4,0x23
    80005be0:	56470713          	addi	a4,a4,1380 # 80029140 <cons>
    80005be4:	0a072783          	lw	a5,160(a4)
    80005be8:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bec:	00023497          	auipc	s1,0x23
    80005bf0:	55448493          	addi	s1,s1,1364 # 80029140 <cons>
    while(cons.e != cons.w &&
    80005bf4:	4929                	li	s2,10
    80005bf6:	02f70a63          	beq	a4,a5,80005c2a <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bfa:	37fd                	addiw	a5,a5,-1
    80005bfc:	07f7f713          	andi	a4,a5,127
    80005c00:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c02:	01874703          	lbu	a4,24(a4)
    80005c06:	03270463          	beq	a4,s2,80005c2e <consoleintr+0x11c>
      cons.e--;
    80005c0a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c0e:	10000513          	li	a0,256
    80005c12:	00000097          	auipc	ra,0x0
    80005c16:	ebe080e7          	jalr	-322(ra) # 80005ad0 <consputc>
    while(cons.e != cons.w &&
    80005c1a:	0a04a783          	lw	a5,160(s1)
    80005c1e:	09c4a703          	lw	a4,156(s1)
    80005c22:	fcf71ce3          	bne	a4,a5,80005bfa <consoleintr+0xe8>
    80005c26:	6902                	ld	s2,0(sp)
    80005c28:	b715                	j	80005b4c <consoleintr+0x3a>
    80005c2a:	6902                	ld	s2,0(sp)
    80005c2c:	b705                	j	80005b4c <consoleintr+0x3a>
    80005c2e:	6902                	ld	s2,0(sp)
    80005c30:	bf31                	j	80005b4c <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005c32:	00023717          	auipc	a4,0x23
    80005c36:	50e70713          	addi	a4,a4,1294 # 80029140 <cons>
    80005c3a:	0a072783          	lw	a5,160(a4)
    80005c3e:	09c72703          	lw	a4,156(a4)
    80005c42:	f0f705e3          	beq	a4,a5,80005b4c <consoleintr+0x3a>
      cons.e--;
    80005c46:	37fd                	addiw	a5,a5,-1
    80005c48:	00023717          	auipc	a4,0x23
    80005c4c:	58f72c23          	sw	a5,1432(a4) # 800291e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c50:	10000513          	li	a0,256
    80005c54:	00000097          	auipc	ra,0x0
    80005c58:	e7c080e7          	jalr	-388(ra) # 80005ad0 <consputc>
    80005c5c:	bdc5                	j	80005b4c <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c5e:	ee0487e3          	beqz	s1,80005b4c <consoleintr+0x3a>
    80005c62:	b731                	j	80005b6e <consoleintr+0x5c>
      consputc(c);
    80005c64:	4529                	li	a0,10
    80005c66:	00000097          	auipc	ra,0x0
    80005c6a:	e6a080e7          	jalr	-406(ra) # 80005ad0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c6e:	00023797          	auipc	a5,0x23
    80005c72:	4d278793          	addi	a5,a5,1234 # 80029140 <cons>
    80005c76:	0a07a703          	lw	a4,160(a5)
    80005c7a:	0017069b          	addiw	a3,a4,1
    80005c7e:	0006861b          	sext.w	a2,a3
    80005c82:	0ad7a023          	sw	a3,160(a5)
    80005c86:	07f77713          	andi	a4,a4,127
    80005c8a:	97ba                	add	a5,a5,a4
    80005c8c:	4729                	li	a4,10
    80005c8e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c92:	00023797          	auipc	a5,0x23
    80005c96:	54c7a523          	sw	a2,1354(a5) # 800291dc <cons+0x9c>
        wakeup(&cons.r);
    80005c9a:	00023517          	auipc	a0,0x23
    80005c9e:	53e50513          	addi	a0,a0,1342 # 800291d8 <cons+0x98>
    80005ca2:	ffffc097          	auipc	ra,0xffffc
    80005ca6:	a82080e7          	jalr	-1406(ra) # 80001724 <wakeup>
    80005caa:	b54d                	j	80005b4c <consoleintr+0x3a>

0000000080005cac <consoleinit>:

void
consoleinit(void)
{
    80005cac:	1141                	addi	sp,sp,-16
    80005cae:	e406                	sd	ra,8(sp)
    80005cb0:	e022                	sd	s0,0(sp)
    80005cb2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005cb4:	00003597          	auipc	a1,0x3
    80005cb8:	a9c58593          	addi	a1,a1,-1380 # 80008750 <etext+0x750>
    80005cbc:	00023517          	auipc	a0,0x23
    80005cc0:	48450513          	addi	a0,a0,1156 # 80029140 <cons>
    80005cc4:	00000097          	auipc	ra,0x0
    80005cc8:	5c2080e7          	jalr	1474(ra) # 80006286 <initlock>

  uartinit();
    80005ccc:	00000097          	auipc	ra,0x0
    80005cd0:	354080e7          	jalr	852(ra) # 80006020 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cd4:	00016797          	auipc	a5,0x16
    80005cd8:	5f478793          	addi	a5,a5,1524 # 8001c2c8 <devsw>
    80005cdc:	00000717          	auipc	a4,0x0
    80005ce0:	cd470713          	addi	a4,a4,-812 # 800059b0 <consoleread>
    80005ce4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005ce6:	00000717          	auipc	a4,0x0
    80005cea:	c5c70713          	addi	a4,a4,-932 # 80005942 <consolewrite>
    80005cee:	ef98                	sd	a4,24(a5)
}
    80005cf0:	60a2                	ld	ra,8(sp)
    80005cf2:	6402                	ld	s0,0(sp)
    80005cf4:	0141                	addi	sp,sp,16
    80005cf6:	8082                	ret

0000000080005cf8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cf8:	7179                	addi	sp,sp,-48
    80005cfa:	f406                	sd	ra,40(sp)
    80005cfc:	f022                	sd	s0,32(sp)
    80005cfe:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d00:	c219                	beqz	a2,80005d06 <printint+0xe>
    80005d02:	08054963          	bltz	a0,80005d94 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005d06:	2501                	sext.w	a0,a0
    80005d08:	4881                	li	a7,0
    80005d0a:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d0e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d10:	2581                	sext.w	a1,a1
    80005d12:	00003617          	auipc	a2,0x3
    80005d16:	c5e60613          	addi	a2,a2,-930 # 80008970 <digits>
    80005d1a:	883a                	mv	a6,a4
    80005d1c:	2705                	addiw	a4,a4,1
    80005d1e:	02b577bb          	remuw	a5,a0,a1
    80005d22:	1782                	slli	a5,a5,0x20
    80005d24:	9381                	srli	a5,a5,0x20
    80005d26:	97b2                	add	a5,a5,a2
    80005d28:	0007c783          	lbu	a5,0(a5)
    80005d2c:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d30:	0005079b          	sext.w	a5,a0
    80005d34:	02b5553b          	divuw	a0,a0,a1
    80005d38:	0685                	addi	a3,a3,1
    80005d3a:	feb7f0e3          	bgeu	a5,a1,80005d1a <printint+0x22>

  if(sign)
    80005d3e:	00088c63          	beqz	a7,80005d56 <printint+0x5e>
    buf[i++] = '-';
    80005d42:	fe070793          	addi	a5,a4,-32
    80005d46:	00878733          	add	a4,a5,s0
    80005d4a:	02d00793          	li	a5,45
    80005d4e:	fef70823          	sb	a5,-16(a4)
    80005d52:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d56:	02e05b63          	blez	a4,80005d8c <printint+0x94>
    80005d5a:	ec26                	sd	s1,24(sp)
    80005d5c:	e84a                	sd	s2,16(sp)
    80005d5e:	fd040793          	addi	a5,s0,-48
    80005d62:	00e784b3          	add	s1,a5,a4
    80005d66:	fff78913          	addi	s2,a5,-1
    80005d6a:	993a                	add	s2,s2,a4
    80005d6c:	377d                	addiw	a4,a4,-1
    80005d6e:	1702                	slli	a4,a4,0x20
    80005d70:	9301                	srli	a4,a4,0x20
    80005d72:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d76:	fff4c503          	lbu	a0,-1(s1)
    80005d7a:	00000097          	auipc	ra,0x0
    80005d7e:	d56080e7          	jalr	-682(ra) # 80005ad0 <consputc>
  while(--i >= 0)
    80005d82:	14fd                	addi	s1,s1,-1
    80005d84:	ff2499e3          	bne	s1,s2,80005d76 <printint+0x7e>
    80005d88:	64e2                	ld	s1,24(sp)
    80005d8a:	6942                	ld	s2,16(sp)
}
    80005d8c:	70a2                	ld	ra,40(sp)
    80005d8e:	7402                	ld	s0,32(sp)
    80005d90:	6145                	addi	sp,sp,48
    80005d92:	8082                	ret
    x = -xx;
    80005d94:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d98:	4885                	li	a7,1
    x = -xx;
    80005d9a:	bf85                	j	80005d0a <printint+0x12>

0000000080005d9c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d9c:	1101                	addi	sp,sp,-32
    80005d9e:	ec06                	sd	ra,24(sp)
    80005da0:	e822                	sd	s0,16(sp)
    80005da2:	e426                	sd	s1,8(sp)
    80005da4:	1000                	addi	s0,sp,32
    80005da6:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005da8:	00023797          	auipc	a5,0x23
    80005dac:	4407ac23          	sw	zero,1112(a5) # 80029200 <pr+0x18>
  printf("panic: ");
    80005db0:	00003517          	auipc	a0,0x3
    80005db4:	9a850513          	addi	a0,a0,-1624 # 80008758 <etext+0x758>
    80005db8:	00000097          	auipc	ra,0x0
    80005dbc:	02e080e7          	jalr	46(ra) # 80005de6 <printf>
  printf(s);
    80005dc0:	8526                	mv	a0,s1
    80005dc2:	00000097          	auipc	ra,0x0
    80005dc6:	024080e7          	jalr	36(ra) # 80005de6 <printf>
  printf("\n");
    80005dca:	00002517          	auipc	a0,0x2
    80005dce:	24e50513          	addi	a0,a0,590 # 80008018 <etext+0x18>
    80005dd2:	00000097          	auipc	ra,0x0
    80005dd6:	014080e7          	jalr	20(ra) # 80005de6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005dda:	4785                	li	a5,1
    80005ddc:	00006717          	auipc	a4,0x6
    80005de0:	24f72023          	sw	a5,576(a4) # 8000c01c <panicked>
  for(;;)
    80005de4:	a001                	j	80005de4 <panic+0x48>

0000000080005de6 <printf>:
{
    80005de6:	7131                	addi	sp,sp,-192
    80005de8:	fc86                	sd	ra,120(sp)
    80005dea:	f8a2                	sd	s0,112(sp)
    80005dec:	e8d2                	sd	s4,80(sp)
    80005dee:	f06a                	sd	s10,32(sp)
    80005df0:	0100                	addi	s0,sp,128
    80005df2:	8a2a                	mv	s4,a0
    80005df4:	e40c                	sd	a1,8(s0)
    80005df6:	e810                	sd	a2,16(s0)
    80005df8:	ec14                	sd	a3,24(s0)
    80005dfa:	f018                	sd	a4,32(s0)
    80005dfc:	f41c                	sd	a5,40(s0)
    80005dfe:	03043823          	sd	a6,48(s0)
    80005e02:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e06:	00023d17          	auipc	s10,0x23
    80005e0a:	3fad2d03          	lw	s10,1018(s10) # 80029200 <pr+0x18>
  if(locking)
    80005e0e:	040d1463          	bnez	s10,80005e56 <printf+0x70>
  if (fmt == 0)
    80005e12:	040a0b63          	beqz	s4,80005e68 <printf+0x82>
  va_start(ap, fmt);
    80005e16:	00840793          	addi	a5,s0,8
    80005e1a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e1e:	000a4503          	lbu	a0,0(s4)
    80005e22:	18050b63          	beqz	a0,80005fb8 <printf+0x1d2>
    80005e26:	f4a6                	sd	s1,104(sp)
    80005e28:	f0ca                	sd	s2,96(sp)
    80005e2a:	ecce                	sd	s3,88(sp)
    80005e2c:	e4d6                	sd	s5,72(sp)
    80005e2e:	e0da                	sd	s6,64(sp)
    80005e30:	fc5e                	sd	s7,56(sp)
    80005e32:	f862                	sd	s8,48(sp)
    80005e34:	f466                	sd	s9,40(sp)
    80005e36:	ec6e                	sd	s11,24(sp)
    80005e38:	4981                	li	s3,0
    if(c != '%'){
    80005e3a:	02500b13          	li	s6,37
    switch(c){
    80005e3e:	07000b93          	li	s7,112
  consputc('x');
    80005e42:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e44:	00003a97          	auipc	s5,0x3
    80005e48:	b2ca8a93          	addi	s5,s5,-1236 # 80008970 <digits>
    switch(c){
    80005e4c:	07300c13          	li	s8,115
    80005e50:	06400d93          	li	s11,100
    80005e54:	a0b1                	j	80005ea0 <printf+0xba>
    acquire(&pr.lock);
    80005e56:	00023517          	auipc	a0,0x23
    80005e5a:	39250513          	addi	a0,a0,914 # 800291e8 <pr>
    80005e5e:	00000097          	auipc	ra,0x0
    80005e62:	4b8080e7          	jalr	1208(ra) # 80006316 <acquire>
    80005e66:	b775                	j	80005e12 <printf+0x2c>
    80005e68:	f4a6                	sd	s1,104(sp)
    80005e6a:	f0ca                	sd	s2,96(sp)
    80005e6c:	ecce                	sd	s3,88(sp)
    80005e6e:	e4d6                	sd	s5,72(sp)
    80005e70:	e0da                	sd	s6,64(sp)
    80005e72:	fc5e                	sd	s7,56(sp)
    80005e74:	f862                	sd	s8,48(sp)
    80005e76:	f466                	sd	s9,40(sp)
    80005e78:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005e7a:	00003517          	auipc	a0,0x3
    80005e7e:	8ee50513          	addi	a0,a0,-1810 # 80008768 <etext+0x768>
    80005e82:	00000097          	auipc	ra,0x0
    80005e86:	f1a080e7          	jalr	-230(ra) # 80005d9c <panic>
      consputc(c);
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	c46080e7          	jalr	-954(ra) # 80005ad0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e92:	2985                	addiw	s3,s3,1
    80005e94:	013a07b3          	add	a5,s4,s3
    80005e98:	0007c503          	lbu	a0,0(a5)
    80005e9c:	10050563          	beqz	a0,80005fa6 <printf+0x1c0>
    if(c != '%'){
    80005ea0:	ff6515e3          	bne	a0,s6,80005e8a <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005ea4:	2985                	addiw	s3,s3,1
    80005ea6:	013a07b3          	add	a5,s4,s3
    80005eaa:	0007c783          	lbu	a5,0(a5)
    80005eae:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005eb2:	10078b63          	beqz	a5,80005fc8 <printf+0x1e2>
    switch(c){
    80005eb6:	05778a63          	beq	a5,s7,80005f0a <printf+0x124>
    80005eba:	02fbf663          	bgeu	s7,a5,80005ee6 <printf+0x100>
    80005ebe:	09878863          	beq	a5,s8,80005f4e <printf+0x168>
    80005ec2:	07800713          	li	a4,120
    80005ec6:	0ce79563          	bne	a5,a4,80005f90 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80005eca:	f8843783          	ld	a5,-120(s0)
    80005ece:	00878713          	addi	a4,a5,8
    80005ed2:	f8e43423          	sd	a4,-120(s0)
    80005ed6:	4605                	li	a2,1
    80005ed8:	85e6                	mv	a1,s9
    80005eda:	4388                	lw	a0,0(a5)
    80005edc:	00000097          	auipc	ra,0x0
    80005ee0:	e1c080e7          	jalr	-484(ra) # 80005cf8 <printint>
      break;
    80005ee4:	b77d                	j	80005e92 <printf+0xac>
    switch(c){
    80005ee6:	09678f63          	beq	a5,s6,80005f84 <printf+0x19e>
    80005eea:	0bb79363          	bne	a5,s11,80005f90 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80005eee:	f8843783          	ld	a5,-120(s0)
    80005ef2:	00878713          	addi	a4,a5,8
    80005ef6:	f8e43423          	sd	a4,-120(s0)
    80005efa:	4605                	li	a2,1
    80005efc:	45a9                	li	a1,10
    80005efe:	4388                	lw	a0,0(a5)
    80005f00:	00000097          	auipc	ra,0x0
    80005f04:	df8080e7          	jalr	-520(ra) # 80005cf8 <printint>
      break;
    80005f08:	b769                	j	80005e92 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005f0a:	f8843783          	ld	a5,-120(s0)
    80005f0e:	00878713          	addi	a4,a5,8
    80005f12:	f8e43423          	sd	a4,-120(s0)
    80005f16:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005f1a:	03000513          	li	a0,48
    80005f1e:	00000097          	auipc	ra,0x0
    80005f22:	bb2080e7          	jalr	-1102(ra) # 80005ad0 <consputc>
  consputc('x');
    80005f26:	07800513          	li	a0,120
    80005f2a:	00000097          	auipc	ra,0x0
    80005f2e:	ba6080e7          	jalr	-1114(ra) # 80005ad0 <consputc>
    80005f32:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f34:	03c95793          	srli	a5,s2,0x3c
    80005f38:	97d6                	add	a5,a5,s5
    80005f3a:	0007c503          	lbu	a0,0(a5)
    80005f3e:	00000097          	auipc	ra,0x0
    80005f42:	b92080e7          	jalr	-1134(ra) # 80005ad0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f46:	0912                	slli	s2,s2,0x4
    80005f48:	34fd                	addiw	s1,s1,-1
    80005f4a:	f4ed                	bnez	s1,80005f34 <printf+0x14e>
    80005f4c:	b799                	j	80005e92 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80005f4e:	f8843783          	ld	a5,-120(s0)
    80005f52:	00878713          	addi	a4,a5,8
    80005f56:	f8e43423          	sd	a4,-120(s0)
    80005f5a:	6384                	ld	s1,0(a5)
    80005f5c:	cc89                	beqz	s1,80005f76 <printf+0x190>
      for(; *s; s++)
    80005f5e:	0004c503          	lbu	a0,0(s1)
    80005f62:	d905                	beqz	a0,80005e92 <printf+0xac>
        consputc(*s);
    80005f64:	00000097          	auipc	ra,0x0
    80005f68:	b6c080e7          	jalr	-1172(ra) # 80005ad0 <consputc>
      for(; *s; s++)
    80005f6c:	0485                	addi	s1,s1,1
    80005f6e:	0004c503          	lbu	a0,0(s1)
    80005f72:	f96d                	bnez	a0,80005f64 <printf+0x17e>
    80005f74:	bf39                	j	80005e92 <printf+0xac>
        s = "(null)";
    80005f76:	00002497          	auipc	s1,0x2
    80005f7a:	7ea48493          	addi	s1,s1,2026 # 80008760 <etext+0x760>
      for(; *s; s++)
    80005f7e:	02800513          	li	a0,40
    80005f82:	b7cd                	j	80005f64 <printf+0x17e>
      consputc('%');
    80005f84:	855a                	mv	a0,s6
    80005f86:	00000097          	auipc	ra,0x0
    80005f8a:	b4a080e7          	jalr	-1206(ra) # 80005ad0 <consputc>
      break;
    80005f8e:	b711                	j	80005e92 <printf+0xac>
      consputc('%');
    80005f90:	855a                	mv	a0,s6
    80005f92:	00000097          	auipc	ra,0x0
    80005f96:	b3e080e7          	jalr	-1218(ra) # 80005ad0 <consputc>
      consputc(c);
    80005f9a:	8526                	mv	a0,s1
    80005f9c:	00000097          	auipc	ra,0x0
    80005fa0:	b34080e7          	jalr	-1228(ra) # 80005ad0 <consputc>
      break;
    80005fa4:	b5fd                	j	80005e92 <printf+0xac>
    80005fa6:	74a6                	ld	s1,104(sp)
    80005fa8:	7906                	ld	s2,96(sp)
    80005faa:	69e6                	ld	s3,88(sp)
    80005fac:	6aa6                	ld	s5,72(sp)
    80005fae:	6b06                	ld	s6,64(sp)
    80005fb0:	7be2                	ld	s7,56(sp)
    80005fb2:	7c42                	ld	s8,48(sp)
    80005fb4:	7ca2                	ld	s9,40(sp)
    80005fb6:	6de2                	ld	s11,24(sp)
  if(locking)
    80005fb8:	020d1263          	bnez	s10,80005fdc <printf+0x1f6>
}
    80005fbc:	70e6                	ld	ra,120(sp)
    80005fbe:	7446                	ld	s0,112(sp)
    80005fc0:	6a46                	ld	s4,80(sp)
    80005fc2:	7d02                	ld	s10,32(sp)
    80005fc4:	6129                	addi	sp,sp,192
    80005fc6:	8082                	ret
    80005fc8:	74a6                	ld	s1,104(sp)
    80005fca:	7906                	ld	s2,96(sp)
    80005fcc:	69e6                	ld	s3,88(sp)
    80005fce:	6aa6                	ld	s5,72(sp)
    80005fd0:	6b06                	ld	s6,64(sp)
    80005fd2:	7be2                	ld	s7,56(sp)
    80005fd4:	7c42                	ld	s8,48(sp)
    80005fd6:	7ca2                	ld	s9,40(sp)
    80005fd8:	6de2                	ld	s11,24(sp)
    80005fda:	bff9                	j	80005fb8 <printf+0x1d2>
    release(&pr.lock);
    80005fdc:	00023517          	auipc	a0,0x23
    80005fe0:	20c50513          	addi	a0,a0,524 # 800291e8 <pr>
    80005fe4:	00000097          	auipc	ra,0x0
    80005fe8:	3e6080e7          	jalr	998(ra) # 800063ca <release>
}
    80005fec:	bfc1                	j	80005fbc <printf+0x1d6>

0000000080005fee <printfinit>:
    ;
}

void
printfinit(void)
{
    80005fee:	1101                	addi	sp,sp,-32
    80005ff0:	ec06                	sd	ra,24(sp)
    80005ff2:	e822                	sd	s0,16(sp)
    80005ff4:	e426                	sd	s1,8(sp)
    80005ff6:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005ff8:	00023497          	auipc	s1,0x23
    80005ffc:	1f048493          	addi	s1,s1,496 # 800291e8 <pr>
    80006000:	00002597          	auipc	a1,0x2
    80006004:	77858593          	addi	a1,a1,1912 # 80008778 <etext+0x778>
    80006008:	8526                	mv	a0,s1
    8000600a:	00000097          	auipc	ra,0x0
    8000600e:	27c080e7          	jalr	636(ra) # 80006286 <initlock>
  pr.locking = 1;
    80006012:	4785                	li	a5,1
    80006014:	cc9c                	sw	a5,24(s1)
}
    80006016:	60e2                	ld	ra,24(sp)
    80006018:	6442                	ld	s0,16(sp)
    8000601a:	64a2                	ld	s1,8(sp)
    8000601c:	6105                	addi	sp,sp,32
    8000601e:	8082                	ret

0000000080006020 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006020:	1141                	addi	sp,sp,-16
    80006022:	e406                	sd	ra,8(sp)
    80006024:	e022                	sd	s0,0(sp)
    80006026:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006028:	100007b7          	lui	a5,0x10000
    8000602c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006030:	10000737          	lui	a4,0x10000
    80006034:	f8000693          	li	a3,-128
    80006038:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000603c:	468d                	li	a3,3
    8000603e:	10000637          	lui	a2,0x10000
    80006042:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006046:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000604a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000604e:	10000737          	lui	a4,0x10000
    80006052:	461d                	li	a2,7
    80006054:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006058:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000605c:	00002597          	auipc	a1,0x2
    80006060:	72458593          	addi	a1,a1,1828 # 80008780 <etext+0x780>
    80006064:	00023517          	auipc	a0,0x23
    80006068:	1a450513          	addi	a0,a0,420 # 80029208 <uart_tx_lock>
    8000606c:	00000097          	auipc	ra,0x0
    80006070:	21a080e7          	jalr	538(ra) # 80006286 <initlock>
}
    80006074:	60a2                	ld	ra,8(sp)
    80006076:	6402                	ld	s0,0(sp)
    80006078:	0141                	addi	sp,sp,16
    8000607a:	8082                	ret

000000008000607c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000607c:	1101                	addi	sp,sp,-32
    8000607e:	ec06                	sd	ra,24(sp)
    80006080:	e822                	sd	s0,16(sp)
    80006082:	e426                	sd	s1,8(sp)
    80006084:	1000                	addi	s0,sp,32
    80006086:	84aa                	mv	s1,a0
  push_off();
    80006088:	00000097          	auipc	ra,0x0
    8000608c:	242080e7          	jalr	578(ra) # 800062ca <push_off>

  if(panicked){
    80006090:	00006797          	auipc	a5,0x6
    80006094:	f8c7a783          	lw	a5,-116(a5) # 8000c01c <panicked>
    80006098:	eb85                	bnez	a5,800060c8 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000609a:	10000737          	lui	a4,0x10000
    8000609e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800060a0:	00074783          	lbu	a5,0(a4)
    800060a4:	0207f793          	andi	a5,a5,32
    800060a8:	dfe5                	beqz	a5,800060a0 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800060aa:	0ff4f513          	zext.b	a0,s1
    800060ae:	100007b7          	lui	a5,0x10000
    800060b2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800060b6:	00000097          	auipc	ra,0x0
    800060ba:	2b4080e7          	jalr	692(ra) # 8000636a <pop_off>
}
    800060be:	60e2                	ld	ra,24(sp)
    800060c0:	6442                	ld	s0,16(sp)
    800060c2:	64a2                	ld	s1,8(sp)
    800060c4:	6105                	addi	sp,sp,32
    800060c6:	8082                	ret
    for(;;)
    800060c8:	a001                	j	800060c8 <uartputc_sync+0x4c>

00000000800060ca <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800060ca:	00006797          	auipc	a5,0x6
    800060ce:	f567b783          	ld	a5,-170(a5) # 8000c020 <uart_tx_r>
    800060d2:	00006717          	auipc	a4,0x6
    800060d6:	f5673703          	ld	a4,-170(a4) # 8000c028 <uart_tx_w>
    800060da:	06f70f63          	beq	a4,a5,80006158 <uartstart+0x8e>
{
    800060de:	7139                	addi	sp,sp,-64
    800060e0:	fc06                	sd	ra,56(sp)
    800060e2:	f822                	sd	s0,48(sp)
    800060e4:	f426                	sd	s1,40(sp)
    800060e6:	f04a                	sd	s2,32(sp)
    800060e8:	ec4e                	sd	s3,24(sp)
    800060ea:	e852                	sd	s4,16(sp)
    800060ec:	e456                	sd	s5,8(sp)
    800060ee:	e05a                	sd	s6,0(sp)
    800060f0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060f2:	10000937          	lui	s2,0x10000
    800060f6:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060f8:	00023a97          	auipc	s5,0x23
    800060fc:	110a8a93          	addi	s5,s5,272 # 80029208 <uart_tx_lock>
    uart_tx_r += 1;
    80006100:	00006497          	auipc	s1,0x6
    80006104:	f2048493          	addi	s1,s1,-224 # 8000c020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80006108:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000610c:	00006997          	auipc	s3,0x6
    80006110:	f1c98993          	addi	s3,s3,-228 # 8000c028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006114:	00094703          	lbu	a4,0(s2)
    80006118:	02077713          	andi	a4,a4,32
    8000611c:	c705                	beqz	a4,80006144 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000611e:	01f7f713          	andi	a4,a5,31
    80006122:	9756                	add	a4,a4,s5
    80006124:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80006128:	0785                	addi	a5,a5,1
    8000612a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000612c:	8526                	mv	a0,s1
    8000612e:	ffffb097          	auipc	ra,0xffffb
    80006132:	5f6080e7          	jalr	1526(ra) # 80001724 <wakeup>
    WriteReg(THR, c);
    80006136:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000613a:	609c                	ld	a5,0(s1)
    8000613c:	0009b703          	ld	a4,0(s3)
    80006140:	fcf71ae3          	bne	a4,a5,80006114 <uartstart+0x4a>
  }
}
    80006144:	70e2                	ld	ra,56(sp)
    80006146:	7442                	ld	s0,48(sp)
    80006148:	74a2                	ld	s1,40(sp)
    8000614a:	7902                	ld	s2,32(sp)
    8000614c:	69e2                	ld	s3,24(sp)
    8000614e:	6a42                	ld	s4,16(sp)
    80006150:	6aa2                	ld	s5,8(sp)
    80006152:	6b02                	ld	s6,0(sp)
    80006154:	6121                	addi	sp,sp,64
    80006156:	8082                	ret
    80006158:	8082                	ret

000000008000615a <uartputc>:
{
    8000615a:	7179                	addi	sp,sp,-48
    8000615c:	f406                	sd	ra,40(sp)
    8000615e:	f022                	sd	s0,32(sp)
    80006160:	e052                	sd	s4,0(sp)
    80006162:	1800                	addi	s0,sp,48
    80006164:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006166:	00023517          	auipc	a0,0x23
    8000616a:	0a250513          	addi	a0,a0,162 # 80029208 <uart_tx_lock>
    8000616e:	00000097          	auipc	ra,0x0
    80006172:	1a8080e7          	jalr	424(ra) # 80006316 <acquire>
  if(panicked){
    80006176:	00006797          	auipc	a5,0x6
    8000617a:	ea67a783          	lw	a5,-346(a5) # 8000c01c <panicked>
    8000617e:	c391                	beqz	a5,80006182 <uartputc+0x28>
    for(;;)
    80006180:	a001                	j	80006180 <uartputc+0x26>
    80006182:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006184:	00006717          	auipc	a4,0x6
    80006188:	ea473703          	ld	a4,-348(a4) # 8000c028 <uart_tx_w>
    8000618c:	00006797          	auipc	a5,0x6
    80006190:	e947b783          	ld	a5,-364(a5) # 8000c020 <uart_tx_r>
    80006194:	02078793          	addi	a5,a5,32
    80006198:	02e79f63          	bne	a5,a4,800061d6 <uartputc+0x7c>
    8000619c:	e84a                	sd	s2,16(sp)
    8000619e:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    800061a0:	00023997          	auipc	s3,0x23
    800061a4:	06898993          	addi	s3,s3,104 # 80029208 <uart_tx_lock>
    800061a8:	00006497          	auipc	s1,0x6
    800061ac:	e7848493          	addi	s1,s1,-392 # 8000c020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061b0:	00006917          	auipc	s2,0x6
    800061b4:	e7890913          	addi	s2,s2,-392 # 8000c028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800061b8:	85ce                	mv	a1,s3
    800061ba:	8526                	mv	a0,s1
    800061bc:	ffffb097          	auipc	ra,0xffffb
    800061c0:	3dc080e7          	jalr	988(ra) # 80001598 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061c4:	00093703          	ld	a4,0(s2)
    800061c8:	609c                	ld	a5,0(s1)
    800061ca:	02078793          	addi	a5,a5,32
    800061ce:	fee785e3          	beq	a5,a4,800061b8 <uartputc+0x5e>
    800061d2:	6942                	ld	s2,16(sp)
    800061d4:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800061d6:	00023497          	auipc	s1,0x23
    800061da:	03248493          	addi	s1,s1,50 # 80029208 <uart_tx_lock>
    800061de:	01f77793          	andi	a5,a4,31
    800061e2:	97a6                	add	a5,a5,s1
    800061e4:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800061e8:	0705                	addi	a4,a4,1
    800061ea:	00006797          	auipc	a5,0x6
    800061ee:	e2e7bf23          	sd	a4,-450(a5) # 8000c028 <uart_tx_w>
      uartstart();
    800061f2:	00000097          	auipc	ra,0x0
    800061f6:	ed8080e7          	jalr	-296(ra) # 800060ca <uartstart>
      release(&uart_tx_lock);
    800061fa:	8526                	mv	a0,s1
    800061fc:	00000097          	auipc	ra,0x0
    80006200:	1ce080e7          	jalr	462(ra) # 800063ca <release>
    80006204:	64e2                	ld	s1,24(sp)
}
    80006206:	70a2                	ld	ra,40(sp)
    80006208:	7402                	ld	s0,32(sp)
    8000620a:	6a02                	ld	s4,0(sp)
    8000620c:	6145                	addi	sp,sp,48
    8000620e:	8082                	ret

0000000080006210 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006210:	1141                	addi	sp,sp,-16
    80006212:	e422                	sd	s0,8(sp)
    80006214:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006216:	100007b7          	lui	a5,0x10000
    8000621a:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000621c:	0007c783          	lbu	a5,0(a5)
    80006220:	8b85                	andi	a5,a5,1
    80006222:	cb81                	beqz	a5,80006232 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80006224:	100007b7          	lui	a5,0x10000
    80006228:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000622c:	6422                	ld	s0,8(sp)
    8000622e:	0141                	addi	sp,sp,16
    80006230:	8082                	ret
    return -1;
    80006232:	557d                	li	a0,-1
    80006234:	bfe5                	j	8000622c <uartgetc+0x1c>

0000000080006236 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006236:	1101                	addi	sp,sp,-32
    80006238:	ec06                	sd	ra,24(sp)
    8000623a:	e822                	sd	s0,16(sp)
    8000623c:	e426                	sd	s1,8(sp)
    8000623e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006240:	54fd                	li	s1,-1
    80006242:	a029                	j	8000624c <uartintr+0x16>
      break;
    consoleintr(c);
    80006244:	00000097          	auipc	ra,0x0
    80006248:	8ce080e7          	jalr	-1842(ra) # 80005b12 <consoleintr>
    int c = uartgetc();
    8000624c:	00000097          	auipc	ra,0x0
    80006250:	fc4080e7          	jalr	-60(ra) # 80006210 <uartgetc>
    if(c == -1)
    80006254:	fe9518e3          	bne	a0,s1,80006244 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006258:	00023497          	auipc	s1,0x23
    8000625c:	fb048493          	addi	s1,s1,-80 # 80029208 <uart_tx_lock>
    80006260:	8526                	mv	a0,s1
    80006262:	00000097          	auipc	ra,0x0
    80006266:	0b4080e7          	jalr	180(ra) # 80006316 <acquire>
  uartstart();
    8000626a:	00000097          	auipc	ra,0x0
    8000626e:	e60080e7          	jalr	-416(ra) # 800060ca <uartstart>
  release(&uart_tx_lock);
    80006272:	8526                	mv	a0,s1
    80006274:	00000097          	auipc	ra,0x0
    80006278:	156080e7          	jalr	342(ra) # 800063ca <release>
}
    8000627c:	60e2                	ld	ra,24(sp)
    8000627e:	6442                	ld	s0,16(sp)
    80006280:	64a2                	ld	s1,8(sp)
    80006282:	6105                	addi	sp,sp,32
    80006284:	8082                	ret

0000000080006286 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006286:	1141                	addi	sp,sp,-16
    80006288:	e422                	sd	s0,8(sp)
    8000628a:	0800                	addi	s0,sp,16
  lk->name = name;
    8000628c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000628e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006292:	00053823          	sd	zero,16(a0)
}
    80006296:	6422                	ld	s0,8(sp)
    80006298:	0141                	addi	sp,sp,16
    8000629a:	8082                	ret

000000008000629c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000629c:	411c                	lw	a5,0(a0)
    8000629e:	e399                	bnez	a5,800062a4 <holding+0x8>
    800062a0:	4501                	li	a0,0
  return r;
}
    800062a2:	8082                	ret
{
    800062a4:	1101                	addi	sp,sp,-32
    800062a6:	ec06                	sd	ra,24(sp)
    800062a8:	e822                	sd	s0,16(sp)
    800062aa:	e426                	sd	s1,8(sp)
    800062ac:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800062ae:	6904                	ld	s1,16(a0)
    800062b0:	ffffb097          	auipc	ra,0xffffb
    800062b4:	bfa080e7          	jalr	-1030(ra) # 80000eaa <mycpu>
    800062b8:	40a48533          	sub	a0,s1,a0
    800062bc:	00153513          	seqz	a0,a0
}
    800062c0:	60e2                	ld	ra,24(sp)
    800062c2:	6442                	ld	s0,16(sp)
    800062c4:	64a2                	ld	s1,8(sp)
    800062c6:	6105                	addi	sp,sp,32
    800062c8:	8082                	ret

00000000800062ca <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800062ca:	1101                	addi	sp,sp,-32
    800062cc:	ec06                	sd	ra,24(sp)
    800062ce:	e822                	sd	s0,16(sp)
    800062d0:	e426                	sd	s1,8(sp)
    800062d2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062d4:	100024f3          	csrr	s1,sstatus
    800062d8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800062dc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062de:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800062e2:	ffffb097          	auipc	ra,0xffffb
    800062e6:	bc8080e7          	jalr	-1080(ra) # 80000eaa <mycpu>
    800062ea:	5d3c                	lw	a5,120(a0)
    800062ec:	cf89                	beqz	a5,80006306 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062ee:	ffffb097          	auipc	ra,0xffffb
    800062f2:	bbc080e7          	jalr	-1092(ra) # 80000eaa <mycpu>
    800062f6:	5d3c                	lw	a5,120(a0)
    800062f8:	2785                	addiw	a5,a5,1
    800062fa:	dd3c                	sw	a5,120(a0)
}
    800062fc:	60e2                	ld	ra,24(sp)
    800062fe:	6442                	ld	s0,16(sp)
    80006300:	64a2                	ld	s1,8(sp)
    80006302:	6105                	addi	sp,sp,32
    80006304:	8082                	ret
    mycpu()->intena = old;
    80006306:	ffffb097          	auipc	ra,0xffffb
    8000630a:	ba4080e7          	jalr	-1116(ra) # 80000eaa <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000630e:	8085                	srli	s1,s1,0x1
    80006310:	8885                	andi	s1,s1,1
    80006312:	dd64                	sw	s1,124(a0)
    80006314:	bfe9                	j	800062ee <push_off+0x24>

0000000080006316 <acquire>:
{
    80006316:	1101                	addi	sp,sp,-32
    80006318:	ec06                	sd	ra,24(sp)
    8000631a:	e822                	sd	s0,16(sp)
    8000631c:	e426                	sd	s1,8(sp)
    8000631e:	1000                	addi	s0,sp,32
    80006320:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006322:	00000097          	auipc	ra,0x0
    80006326:	fa8080e7          	jalr	-88(ra) # 800062ca <push_off>
  if(holding(lk))
    8000632a:	8526                	mv	a0,s1
    8000632c:	00000097          	auipc	ra,0x0
    80006330:	f70080e7          	jalr	-144(ra) # 8000629c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006334:	4705                	li	a4,1
  if(holding(lk))
    80006336:	e115                	bnez	a0,8000635a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006338:	87ba                	mv	a5,a4
    8000633a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000633e:	2781                	sext.w	a5,a5
    80006340:	ffe5                	bnez	a5,80006338 <acquire+0x22>
  __sync_synchronize();
    80006342:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80006346:	ffffb097          	auipc	ra,0xffffb
    8000634a:	b64080e7          	jalr	-1180(ra) # 80000eaa <mycpu>
    8000634e:	e888                	sd	a0,16(s1)
}
    80006350:	60e2                	ld	ra,24(sp)
    80006352:	6442                	ld	s0,16(sp)
    80006354:	64a2                	ld	s1,8(sp)
    80006356:	6105                	addi	sp,sp,32
    80006358:	8082                	ret
    panic("acquire");
    8000635a:	00002517          	auipc	a0,0x2
    8000635e:	42e50513          	addi	a0,a0,1070 # 80008788 <etext+0x788>
    80006362:	00000097          	auipc	ra,0x0
    80006366:	a3a080e7          	jalr	-1478(ra) # 80005d9c <panic>

000000008000636a <pop_off>:

void
pop_off(void)
{
    8000636a:	1141                	addi	sp,sp,-16
    8000636c:	e406                	sd	ra,8(sp)
    8000636e:	e022                	sd	s0,0(sp)
    80006370:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006372:	ffffb097          	auipc	ra,0xffffb
    80006376:	b38080e7          	jalr	-1224(ra) # 80000eaa <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000637a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000637e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006380:	e78d                	bnez	a5,800063aa <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006382:	5d3c                	lw	a5,120(a0)
    80006384:	02f05b63          	blez	a5,800063ba <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006388:	37fd                	addiw	a5,a5,-1
    8000638a:	0007871b          	sext.w	a4,a5
    8000638e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006390:	eb09                	bnez	a4,800063a2 <pop_off+0x38>
    80006392:	5d7c                	lw	a5,124(a0)
    80006394:	c799                	beqz	a5,800063a2 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006396:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000639a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000639e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800063a2:	60a2                	ld	ra,8(sp)
    800063a4:	6402                	ld	s0,0(sp)
    800063a6:	0141                	addi	sp,sp,16
    800063a8:	8082                	ret
    panic("pop_off - interruptible");
    800063aa:	00002517          	auipc	a0,0x2
    800063ae:	3e650513          	addi	a0,a0,998 # 80008790 <etext+0x790>
    800063b2:	00000097          	auipc	ra,0x0
    800063b6:	9ea080e7          	jalr	-1558(ra) # 80005d9c <panic>
    panic("pop_off");
    800063ba:	00002517          	auipc	a0,0x2
    800063be:	3ee50513          	addi	a0,a0,1006 # 800087a8 <etext+0x7a8>
    800063c2:	00000097          	auipc	ra,0x0
    800063c6:	9da080e7          	jalr	-1574(ra) # 80005d9c <panic>

00000000800063ca <release>:
{
    800063ca:	1101                	addi	sp,sp,-32
    800063cc:	ec06                	sd	ra,24(sp)
    800063ce:	e822                	sd	s0,16(sp)
    800063d0:	e426                	sd	s1,8(sp)
    800063d2:	1000                	addi	s0,sp,32
    800063d4:	84aa                	mv	s1,a0
  if(!holding(lk))
    800063d6:	00000097          	auipc	ra,0x0
    800063da:	ec6080e7          	jalr	-314(ra) # 8000629c <holding>
    800063de:	c115                	beqz	a0,80006402 <release+0x38>
  lk->cpu = 0;
    800063e0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063e4:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800063e8:	0310000f          	fence	rw,w
    800063ec:	0004a023          	sw	zero,0(s1)
  pop_off();
    800063f0:	00000097          	auipc	ra,0x0
    800063f4:	f7a080e7          	jalr	-134(ra) # 8000636a <pop_off>
}
    800063f8:	60e2                	ld	ra,24(sp)
    800063fa:	6442                	ld	s0,16(sp)
    800063fc:	64a2                	ld	s1,8(sp)
    800063fe:	6105                	addi	sp,sp,32
    80006400:	8082                	ret
    panic("release");
    80006402:	00002517          	auipc	a0,0x2
    80006406:	3ae50513          	addi	a0,a0,942 # 800087b0 <etext+0x7b0>
    8000640a:	00000097          	auipc	ra,0x0
    8000640e:	992080e7          	jalr	-1646(ra) # 80005d9c <panic>
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
