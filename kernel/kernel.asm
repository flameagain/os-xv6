
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	41013103          	ld	sp,1040(sp) # 8000b410 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	653050ef          	jal	80005e68 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7139                	addi	sp,sp,-64
    8000001e:	fc06                	sd	ra,56(sp)
    80000020:	f822                	sd	s0,48(sp)
    80000022:	f426                	sd	s1,40(sp)
    80000024:	f04a                	sd	s2,32(sp)
    80000026:	ec4e                	sd	s3,24(sp)
    80000028:	e852                	sd	s4,16(sp)
    8000002a:	e456                	sd	s5,8(sp)
    8000002c:	0080                	addi	s0,sp,64
  struct run *r;
  int cpu_id;
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002e:	03451793          	slli	a5,a0,0x34
    80000032:	e3c9                	bnez	a5,800000b4 <kfree+0x98>
    80000034:	84aa                	mv	s1,a0
    80000036:	0002e797          	auipc	a5,0x2e
    8000003a:	21278793          	addi	a5,a5,530 # 8002e248 <end>
    8000003e:	06f56b63          	bltu	a0,a5,800000b4 <kfree+0x98>
    80000042:	47c5                	li	a5,17
    80000044:	07ee                	slli	a5,a5,0x1b
    80000046:	06f57763          	bgeu	a0,a5,800000b4 <kfree+0x98>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000004a:	6605                	lui	a2,0x1
    8000004c:	4585                	li	a1,1
    8000004e:	00000097          	auipc	ra,0x0
    80000052:	226080e7          	jalr	550(ra) # 80000274 <memset>

  r = (struct run*)pa;
  push_off();
    80000056:	00006097          	auipc	ra,0x6
    8000005a:	7f8080e7          	jalr	2040(ra) # 8000684e <push_off>
  cpu_id=cpuid();
    8000005e:	00001097          	auipc	ra,0x1
    80000062:	efc080e7          	jalr	-260(ra) # 80000f5a <cpuid>
    80000066:	8a2a                	mv	s4,a0
  pop_off();
    80000068:	00007097          	auipc	ra,0x7
    8000006c:	89a080e7          	jalr	-1894(ra) # 80006902 <pop_off>

  acquire(&kmem[cpu_id].lock);
    80000070:	0000ca97          	auipc	s5,0xc
    80000074:	fc0a8a93          	addi	s5,s5,-64 # 8000c030 <kmem>
    80000078:	002a1993          	slli	s3,s4,0x2
    8000007c:	01498933          	add	s2,s3,s4
    80000080:	090e                	slli	s2,s2,0x3
    80000082:	9956                	add	s2,s2,s5
    80000084:	854a                	mv	a0,s2
    80000086:	00007097          	auipc	ra,0x7
    8000008a:	814080e7          	jalr	-2028(ra) # 8000689a <acquire>
  r->next = kmem[cpu_id].freelist;
    8000008e:	02093783          	ld	a5,32(s2)
    80000092:	e09c                	sd	a5,0(s1)
  kmem[cpu_id].freelist = r;
    80000094:	02993023          	sd	s1,32(s2)
  release(&kmem[cpu_id].lock);
    80000098:	854a                	mv	a0,s2
    8000009a:	00007097          	auipc	ra,0x7
    8000009e:	8c8080e7          	jalr	-1848(ra) # 80006962 <release>
}
    800000a2:	70e2                	ld	ra,56(sp)
    800000a4:	7442                	ld	s0,48(sp)
    800000a6:	74a2                	ld	s1,40(sp)
    800000a8:	7902                	ld	s2,32(sp)
    800000aa:	69e2                	ld	s3,24(sp)
    800000ac:	6a42                	ld	s4,16(sp)
    800000ae:	6aa2                	ld	s5,8(sp)
    800000b0:	6121                	addi	sp,sp,64
    800000b2:	8082                	ret
    panic("kfree");
    800000b4:	00008517          	auipc	a0,0x8
    800000b8:	f4c50513          	addi	a0,a0,-180 # 80008000 <etext>
    800000bc:	00006097          	auipc	ra,0x6
    800000c0:	27a080e7          	jalr	634(ra) # 80006336 <panic>

00000000800000c4 <freerange>:
{
    800000c4:	7179                	addi	sp,sp,-48
    800000c6:	f406                	sd	ra,40(sp)
    800000c8:	f022                	sd	s0,32(sp)
    800000ca:	ec26                	sd	s1,24(sp)
    800000cc:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000ce:	6785                	lui	a5,0x1
    800000d0:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000d4:	00e504b3          	add	s1,a0,a4
    800000d8:	777d                	lui	a4,0xfffff
    800000da:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000dc:	94be                	add	s1,s1,a5
    800000de:	0295e463          	bltu	a1,s1,80000106 <freerange+0x42>
    800000e2:	e84a                	sd	s2,16(sp)
    800000e4:	e44e                	sd	s3,8(sp)
    800000e6:	e052                	sd	s4,0(sp)
    800000e8:	892e                	mv	s2,a1
    kfree(p);
    800000ea:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ec:	6985                	lui	s3,0x1
    kfree(p);
    800000ee:	01448533          	add	a0,s1,s4
    800000f2:	00000097          	auipc	ra,0x0
    800000f6:	f2a080e7          	jalr	-214(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000fa:	94ce                	add	s1,s1,s3
    800000fc:	fe9979e3          	bgeu	s2,s1,800000ee <freerange+0x2a>
    80000100:	6942                	ld	s2,16(sp)
    80000102:	69a2                	ld	s3,8(sp)
    80000104:	6a02                	ld	s4,0(sp)
}
    80000106:	70a2                	ld	ra,40(sp)
    80000108:	7402                	ld	s0,32(sp)
    8000010a:	64e2                	ld	s1,24(sp)
    8000010c:	6145                	addi	sp,sp,48
    8000010e:	8082                	ret

0000000080000110 <kinit>:
{
    80000110:	7179                	addi	sp,sp,-48
    80000112:	f406                	sd	ra,40(sp)
    80000114:	f022                	sd	s0,32(sp)
    80000116:	ec26                	sd	s1,24(sp)
    80000118:	e84a                	sd	s2,16(sp)
    8000011a:	e44e                	sd	s3,8(sp)
    8000011c:	1800                	addi	s0,sp,48
  for (int i=0;i<NCPU;i++)
    8000011e:	0000c497          	auipc	s1,0xc
    80000122:	f1248493          	addi	s1,s1,-238 # 8000c030 <kmem>
    80000126:	0000c997          	auipc	s3,0xc
    8000012a:	04a98993          	addi	s3,s3,74 # 8000c170 <pid_lock>
    initlock(&kmem[i].lock,"kmem");
    8000012e:	00008917          	auipc	s2,0x8
    80000132:	ee290913          	addi	s2,s2,-286 # 80008010 <etext+0x10>
    80000136:	85ca                	mv	a1,s2
    80000138:	8526                	mv	a0,s1
    8000013a:	00007097          	auipc	ra,0x7
    8000013e:	8d4080e7          	jalr	-1836(ra) # 80006a0e <initlock>
  for (int i=0;i<NCPU;i++)
    80000142:	02848493          	addi	s1,s1,40
    80000146:	ff3498e3          	bne	s1,s3,80000136 <kinit+0x26>
  freerange(end, (void*)PHYSTOP);
    8000014a:	45c5                	li	a1,17
    8000014c:	05ee                	slli	a1,a1,0x1b
    8000014e:	0002e517          	auipc	a0,0x2e
    80000152:	0fa50513          	addi	a0,a0,250 # 8002e248 <end>
    80000156:	00000097          	auipc	ra,0x0
    8000015a:	f6e080e7          	jalr	-146(ra) # 800000c4 <freerange>
}
    8000015e:	70a2                	ld	ra,40(sp)
    80000160:	7402                	ld	s0,32(sp)
    80000162:	64e2                	ld	s1,24(sp)
    80000164:	6942                	ld	s2,16(sp)
    80000166:	69a2                	ld	s3,8(sp)
    80000168:	6145                	addi	sp,sp,48
    8000016a:	8082                	ret

000000008000016c <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000016c:	715d                	addi	sp,sp,-80
    8000016e:	e486                	sd	ra,72(sp)
    80000170:	e0a2                	sd	s0,64(sp)
    80000172:	f84a                	sd	s2,48(sp)
    80000174:	f052                	sd	s4,32(sp)
    80000176:	ec56                	sd	s5,24(sp)
    80000178:	e85a                	sd	s6,16(sp)
    8000017a:	0880                	addi	s0,sp,80
  struct run *r;
  int cpu_id;
  push_off();
    8000017c:	00006097          	auipc	ra,0x6
    80000180:	6d2080e7          	jalr	1746(ra) # 8000684e <push_off>
  cpu_id=cpuid();
    80000184:	00001097          	auipc	ra,0x1
    80000188:	dd6080e7          	jalr	-554(ra) # 80000f5a <cpuid>
    8000018c:	892a                	mv	s2,a0
  pop_off();
    8000018e:	00006097          	auipc	ra,0x6
    80000192:	774080e7          	jalr	1908(ra) # 80006902 <pop_off>

  acquire(&kmem[cpu_id].lock);
    80000196:	00291793          	slli	a5,s2,0x2
    8000019a:	97ca                	add	a5,a5,s2
    8000019c:	078e                	slli	a5,a5,0x3
    8000019e:	0000ca17          	auipc	s4,0xc
    800001a2:	e92a0a13          	addi	s4,s4,-366 # 8000c030 <kmem>
    800001a6:	9a3e                	add	s4,s4,a5
    800001a8:	8552                	mv	a0,s4
    800001aa:	00006097          	auipc	ra,0x6
    800001ae:	6f0080e7          	jalr	1776(ra) # 8000689a <acquire>
  r = kmem[cpu_id].freelist;
    800001b2:	020a3b03          	ld	s6,32(s4)
  if(r)
    800001b6:	000b0d63          	beqz	s6,800001d0 <kalloc+0x64>
    kmem[cpu_id].freelist = r->next;
    800001ba:	000b3683          	ld	a3,0(s6)
    800001be:	02da3023          	sd	a3,32(s4)
      if(r){
        break;
      }
    }
  }
  release(&kmem[cpu_id].lock);
    800001c2:	8552                	mv	a0,s4
    800001c4:	00006097          	auipc	ra,0x6
    800001c8:	79e080e7          	jalr	1950(ra) # 80006962 <release>
  r = kmem[cpu_id].freelist;
    800001cc:	8ada                	mv	s5,s6
    800001ce:	a88d                	j	80000240 <kalloc+0xd4>
    800001d0:	fc26                	sd	s1,56(sp)
    800001d2:	f44e                	sd	s3,40(sp)
    800001d4:	e45e                	sd	s7,8(sp)
    800001d6:	0000c997          	auipc	s3,0xc
    800001da:	e5a98993          	addi	s3,s3,-422 # 8000c030 <kmem>
    for(int i=0;i<NCPU;i++){
    800001de:	4481                	li	s1,0
    800001e0:	4ba1                	li	s7,8
    800001e2:	a819                	j	800001f8 <kalloc+0x8c>
      release(&kmem[i].lock);
    800001e4:	854e                	mv	a0,s3
    800001e6:	00006097          	auipc	ra,0x6
    800001ea:	77c080e7          	jalr	1916(ra) # 80006962 <release>
    for(int i=0;i<NCPU;i++){
    800001ee:	2485                	addiw	s1,s1,1
    800001f0:	02898993          	addi	s3,s3,40
    800001f4:	07748663          	beq	s1,s7,80000260 <kalloc+0xf4>
      if(i==cpu_id){
    800001f8:	fe990be3          	beq	s2,s1,800001ee <kalloc+0x82>
      acquire(&kmem[i].lock);
    800001fc:	854e                	mv	a0,s3
    800001fe:	00006097          	auipc	ra,0x6
    80000202:	69c080e7          	jalr	1692(ra) # 8000689a <acquire>
      r=kmem[i].freelist;
    80000206:	0209ba83          	ld	s5,32(s3)
      if(r){
    8000020a:	fc0a8de3          	beqz	s5,800001e4 <kalloc+0x78>
        kmem[i].freelist = r->next;
    8000020e:	000ab683          	ld	a3,0(s5)
    80000212:	00249793          	slli	a5,s1,0x2
    80000216:	97a6                	add	a5,a5,s1
    80000218:	078e                	slli	a5,a5,0x3
    8000021a:	0000c717          	auipc	a4,0xc
    8000021e:	e1670713          	addi	a4,a4,-490 # 8000c030 <kmem>
    80000222:	97ba                	add	a5,a5,a4
    80000224:	f394                	sd	a3,32(a5)
      release(&kmem[i].lock);
    80000226:	854e                	mv	a0,s3
    80000228:	00006097          	auipc	ra,0x6
    8000022c:	73a080e7          	jalr	1850(ra) # 80006962 <release>
  release(&kmem[cpu_id].lock);
    80000230:	8552                	mv	a0,s4
    80000232:	00006097          	auipc	ra,0x6
    80000236:	730080e7          	jalr	1840(ra) # 80006962 <release>

  if(r)
    8000023a:	74e2                	ld	s1,56(sp)
    8000023c:	79a2                	ld	s3,40(sp)
    8000023e:	6ba2                	ld	s7,8(sp)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000240:	6605                	lui	a2,0x1
    80000242:	4595                	li	a1,5
    80000244:	8556                	mv	a0,s5
    80000246:	00000097          	auipc	ra,0x0
    8000024a:	02e080e7          	jalr	46(ra) # 80000274 <memset>
  return (void*)r;
}
    8000024e:	8556                	mv	a0,s5
    80000250:	60a6                	ld	ra,72(sp)
    80000252:	6406                	ld	s0,64(sp)
    80000254:	7942                	ld	s2,48(sp)
    80000256:	7a02                	ld	s4,32(sp)
    80000258:	6ae2                	ld	s5,24(sp)
    8000025a:	6b42                	ld	s6,16(sp)
    8000025c:	6161                	addi	sp,sp,80
    8000025e:	8082                	ret
  release(&kmem[cpu_id].lock);
    80000260:	8552                	mv	a0,s4
    80000262:	00006097          	auipc	ra,0x6
    80000266:	700080e7          	jalr	1792(ra) # 80006962 <release>
    8000026a:	8ada                	mv	s5,s6
    8000026c:	74e2                	ld	s1,56(sp)
    8000026e:	79a2                	ld	s3,40(sp)
    80000270:	6ba2                	ld	s7,8(sp)
    80000272:	bff1                	j	8000024e <kalloc+0xe2>

0000000080000274 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000274:	1141                	addi	sp,sp,-16
    80000276:	e422                	sd	s0,8(sp)
    80000278:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000027a:	ca19                	beqz	a2,80000290 <memset+0x1c>
    8000027c:	87aa                	mv	a5,a0
    8000027e:	1602                	slli	a2,a2,0x20
    80000280:	9201                	srli	a2,a2,0x20
    80000282:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000286:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000028a:	0785                	addi	a5,a5,1
    8000028c:	fee79de3          	bne	a5,a4,80000286 <memset+0x12>
  }
  return dst;
}
    80000290:	6422                	ld	s0,8(sp)
    80000292:	0141                	addi	sp,sp,16
    80000294:	8082                	ret

0000000080000296 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000296:	1141                	addi	sp,sp,-16
    80000298:	e422                	sd	s0,8(sp)
    8000029a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000029c:	ca05                	beqz	a2,800002cc <memcmp+0x36>
    8000029e:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800002a2:	1682                	slli	a3,a3,0x20
    800002a4:	9281                	srli	a3,a3,0x20
    800002a6:	0685                	addi	a3,a3,1
    800002a8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002aa:	00054783          	lbu	a5,0(a0)
    800002ae:	0005c703          	lbu	a4,0(a1)
    800002b2:	00e79863          	bne	a5,a4,800002c2 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800002b6:	0505                	addi	a0,a0,1
    800002b8:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002ba:	fed518e3          	bne	a0,a3,800002aa <memcmp+0x14>
  }

  return 0;
    800002be:	4501                	li	a0,0
    800002c0:	a019                	j	800002c6 <memcmp+0x30>
      return *s1 - *s2;
    800002c2:	40e7853b          	subw	a0,a5,a4
}
    800002c6:	6422                	ld	s0,8(sp)
    800002c8:	0141                	addi	sp,sp,16
    800002ca:	8082                	ret
  return 0;
    800002cc:	4501                	li	a0,0
    800002ce:	bfe5                	j	800002c6 <memcmp+0x30>

00000000800002d0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002d0:	1141                	addi	sp,sp,-16
    800002d2:	e422                	sd	s0,8(sp)
    800002d4:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800002d6:	c205                	beqz	a2,800002f6 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800002d8:	02a5e263          	bltu	a1,a0,800002fc <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800002dc:	1602                	slli	a2,a2,0x20
    800002de:	9201                	srli	a2,a2,0x20
    800002e0:	00c587b3          	add	a5,a1,a2
{
    800002e4:	872a                	mv	a4,a0
      *d++ = *s++;
    800002e6:	0585                	addi	a1,a1,1
    800002e8:	0705                	addi	a4,a4,1
    800002ea:	fff5c683          	lbu	a3,-1(a1)
    800002ee:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800002f2:	feb79ae3          	bne	a5,a1,800002e6 <memmove+0x16>

  return dst;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret
  if(s < d && s + n > d){
    800002fc:	02061693          	slli	a3,a2,0x20
    80000300:	9281                	srli	a3,a3,0x20
    80000302:	00d58733          	add	a4,a1,a3
    80000306:	fce57be3          	bgeu	a0,a4,800002dc <memmove+0xc>
    d += n;
    8000030a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000030c:	fff6079b          	addiw	a5,a2,-1
    80000310:	1782                	slli	a5,a5,0x20
    80000312:	9381                	srli	a5,a5,0x20
    80000314:	fff7c793          	not	a5,a5
    80000318:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000031a:	177d                	addi	a4,a4,-1
    8000031c:	16fd                	addi	a3,a3,-1
    8000031e:	00074603          	lbu	a2,0(a4)
    80000322:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000326:	fef71ae3          	bne	a4,a5,8000031a <memmove+0x4a>
    8000032a:	b7f1                	j	800002f6 <memmove+0x26>

000000008000032c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000032c:	1141                	addi	sp,sp,-16
    8000032e:	e406                	sd	ra,8(sp)
    80000330:	e022                	sd	s0,0(sp)
    80000332:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000334:	00000097          	auipc	ra,0x0
    80000338:	f9c080e7          	jalr	-100(ra) # 800002d0 <memmove>
}
    8000033c:	60a2                	ld	ra,8(sp)
    8000033e:	6402                	ld	s0,0(sp)
    80000340:	0141                	addi	sp,sp,16
    80000342:	8082                	ret

0000000080000344 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000344:	1141                	addi	sp,sp,-16
    80000346:	e422                	sd	s0,8(sp)
    80000348:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000034a:	ce11                	beqz	a2,80000366 <strncmp+0x22>
    8000034c:	00054783          	lbu	a5,0(a0)
    80000350:	cf89                	beqz	a5,8000036a <strncmp+0x26>
    80000352:	0005c703          	lbu	a4,0(a1)
    80000356:	00f71a63          	bne	a4,a5,8000036a <strncmp+0x26>
    n--, p++, q++;
    8000035a:	367d                	addiw	a2,a2,-1
    8000035c:	0505                	addi	a0,a0,1
    8000035e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000360:	f675                	bnez	a2,8000034c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000362:	4501                	li	a0,0
    80000364:	a801                	j	80000374 <strncmp+0x30>
    80000366:	4501                	li	a0,0
    80000368:	a031                	j	80000374 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    8000036a:	00054503          	lbu	a0,0(a0)
    8000036e:	0005c783          	lbu	a5,0(a1)
    80000372:	9d1d                	subw	a0,a0,a5
}
    80000374:	6422                	ld	s0,8(sp)
    80000376:	0141                	addi	sp,sp,16
    80000378:	8082                	ret

000000008000037a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000037a:	1141                	addi	sp,sp,-16
    8000037c:	e422                	sd	s0,8(sp)
    8000037e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000380:	87aa                	mv	a5,a0
    80000382:	86b2                	mv	a3,a2
    80000384:	367d                	addiw	a2,a2,-1
    80000386:	02d05563          	blez	a3,800003b0 <strncpy+0x36>
    8000038a:	0785                	addi	a5,a5,1
    8000038c:	0005c703          	lbu	a4,0(a1)
    80000390:	fee78fa3          	sb	a4,-1(a5)
    80000394:	0585                	addi	a1,a1,1
    80000396:	f775                	bnez	a4,80000382 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000398:	873e                	mv	a4,a5
    8000039a:	9fb5                	addw	a5,a5,a3
    8000039c:	37fd                	addiw	a5,a5,-1
    8000039e:	00c05963          	blez	a2,800003b0 <strncpy+0x36>
    *s++ = 0;
    800003a2:	0705                	addi	a4,a4,1
    800003a4:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800003a8:	40e786bb          	subw	a3,a5,a4
    800003ac:	fed04be3          	bgtz	a3,800003a2 <strncpy+0x28>
  return os;
}
    800003b0:	6422                	ld	s0,8(sp)
    800003b2:	0141                	addi	sp,sp,16
    800003b4:	8082                	ret

00000000800003b6 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003b6:	1141                	addi	sp,sp,-16
    800003b8:	e422                	sd	s0,8(sp)
    800003ba:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003bc:	02c05363          	blez	a2,800003e2 <safestrcpy+0x2c>
    800003c0:	fff6069b          	addiw	a3,a2,-1
    800003c4:	1682                	slli	a3,a3,0x20
    800003c6:	9281                	srli	a3,a3,0x20
    800003c8:	96ae                	add	a3,a3,a1
    800003ca:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800003cc:	00d58963          	beq	a1,a3,800003de <safestrcpy+0x28>
    800003d0:	0585                	addi	a1,a1,1
    800003d2:	0785                	addi	a5,a5,1
    800003d4:	fff5c703          	lbu	a4,-1(a1)
    800003d8:	fee78fa3          	sb	a4,-1(a5)
    800003dc:	fb65                	bnez	a4,800003cc <safestrcpy+0x16>
    ;
  *s = 0;
    800003de:	00078023          	sb	zero,0(a5)
  return os;
}
    800003e2:	6422                	ld	s0,8(sp)
    800003e4:	0141                	addi	sp,sp,16
    800003e6:	8082                	ret

00000000800003e8 <strlen>:

int
strlen(const char *s)
{
    800003e8:	1141                	addi	sp,sp,-16
    800003ea:	e422                	sd	s0,8(sp)
    800003ec:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800003ee:	00054783          	lbu	a5,0(a0)
    800003f2:	cf91                	beqz	a5,8000040e <strlen+0x26>
    800003f4:	0505                	addi	a0,a0,1
    800003f6:	87aa                	mv	a5,a0
    800003f8:	86be                	mv	a3,a5
    800003fa:	0785                	addi	a5,a5,1
    800003fc:	fff7c703          	lbu	a4,-1(a5)
    80000400:	ff65                	bnez	a4,800003f8 <strlen+0x10>
    80000402:	40a6853b          	subw	a0,a3,a0
    80000406:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000408:	6422                	ld	s0,8(sp)
    8000040a:	0141                	addi	sp,sp,16
    8000040c:	8082                	ret
  for(n = 0; s[n]; n++)
    8000040e:	4501                	li	a0,0
    80000410:	bfe5                	j	80000408 <strlen+0x20>

0000000080000412 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000412:	1101                	addi	sp,sp,-32
    80000414:	ec06                	sd	ra,24(sp)
    80000416:	e822                	sd	s0,16(sp)
    80000418:	e426                	sd	s1,8(sp)
    8000041a:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	b3e080e7          	jalr	-1218(ra) # 80000f5a <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(lockfree_read4((int *) &started) == 0)
    80000424:	0000c497          	auipc	s1,0xc
    80000428:	bdc48493          	addi	s1,s1,-1060 # 8000c000 <started>
  if(cpuid() == 0){
    8000042c:	c531                	beqz	a0,80000478 <main+0x66>
    while(lockfree_read4((int *) &started) == 0)
    8000042e:	8526                	mv	a0,s1
    80000430:	00006097          	auipc	ra,0x6
    80000434:	674080e7          	jalr	1652(ra) # 80006aa4 <lockfree_read4>
    80000438:	d97d                	beqz	a0,8000042e <main+0x1c>
      ;
    __sync_synchronize();
    8000043a:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    8000043e:	00001097          	auipc	ra,0x1
    80000442:	b1c080e7          	jalr	-1252(ra) # 80000f5a <cpuid>
    80000446:	85aa                	mv	a1,a0
    80000448:	00008517          	auipc	a0,0x8
    8000044c:	bf050513          	addi	a0,a0,-1040 # 80008038 <etext+0x38>
    80000450:	00006097          	auipc	ra,0x6
    80000454:	f30080e7          	jalr	-208(ra) # 80006380 <printf>
    kvminithart();    // turn on paging
    80000458:	00000097          	auipc	ra,0x0
    8000045c:	0e0080e7          	jalr	224(ra) # 80000538 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000460:	00001097          	auipc	ra,0x1
    80000464:	77e080e7          	jalr	1918(ra) # 80001bde <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000468:	00005097          	auipc	ra,0x5
    8000046c:	03c080e7          	jalr	60(ra) # 800054a4 <plicinithart>
  }

  scheduler();        
    80000470:	00001097          	auipc	ra,0x1
    80000474:	02a080e7          	jalr	42(ra) # 8000149a <scheduler>
    consoleinit();
    80000478:	00006097          	auipc	ra,0x6
    8000047c:	dce080e7          	jalr	-562(ra) # 80006246 <consoleinit>
    statsinit();
    80000480:	00005097          	auipc	ra,0x5
    80000484:	6e2080e7          	jalr	1762(ra) # 80005b62 <statsinit>
    printfinit();
    80000488:	00006097          	auipc	ra,0x6
    8000048c:	100080e7          	jalr	256(ra) # 80006588 <printfinit>
    printf("\n");
    80000490:	00008517          	auipc	a0,0x8
    80000494:	b8850513          	addi	a0,a0,-1144 # 80008018 <etext+0x18>
    80000498:	00006097          	auipc	ra,0x6
    8000049c:	ee8080e7          	jalr	-280(ra) # 80006380 <printf>
    printf("xv6 kernel is booting\n");
    800004a0:	00008517          	auipc	a0,0x8
    800004a4:	b8050513          	addi	a0,a0,-1152 # 80008020 <etext+0x20>
    800004a8:	00006097          	auipc	ra,0x6
    800004ac:	ed8080e7          	jalr	-296(ra) # 80006380 <printf>
    printf("\n");
    800004b0:	00008517          	auipc	a0,0x8
    800004b4:	b6850513          	addi	a0,a0,-1176 # 80008018 <etext+0x18>
    800004b8:	00006097          	auipc	ra,0x6
    800004bc:	ec8080e7          	jalr	-312(ra) # 80006380 <printf>
    kinit();         // physical page allocator
    800004c0:	00000097          	auipc	ra,0x0
    800004c4:	c50080e7          	jalr	-944(ra) # 80000110 <kinit>
    kvminit();       // create kernel page table
    800004c8:	00000097          	auipc	ra,0x0
    800004cc:	322080e7          	jalr	802(ra) # 800007ea <kvminit>
    kvminithart();   // turn on paging
    800004d0:	00000097          	auipc	ra,0x0
    800004d4:	068080e7          	jalr	104(ra) # 80000538 <kvminithart>
    procinit();      // process table
    800004d8:	00001097          	auipc	ra,0x1
    800004dc:	9c4080e7          	jalr	-1596(ra) # 80000e9c <procinit>
    trapinit();      // trap vectors
    800004e0:	00001097          	auipc	ra,0x1
    800004e4:	6d6080e7          	jalr	1750(ra) # 80001bb6 <trapinit>
    trapinithart();  // install kernel trap vector
    800004e8:	00001097          	auipc	ra,0x1
    800004ec:	6f6080e7          	jalr	1782(ra) # 80001bde <trapinithart>
    plicinit();      // set up interrupt controller
    800004f0:	00005097          	auipc	ra,0x5
    800004f4:	f9a080e7          	jalr	-102(ra) # 8000548a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800004f8:	00005097          	auipc	ra,0x5
    800004fc:	fac080e7          	jalr	-84(ra) # 800054a4 <plicinithart>
    binit();         // buffer cache
    80000500:	00002097          	auipc	ra,0x2
    80000504:	e30080e7          	jalr	-464(ra) # 80002330 <binit>
    iinit();         // inode table
    80000508:	00002097          	auipc	ra,0x2
    8000050c:	74a080e7          	jalr	1866(ra) # 80002c52 <iinit>
    fileinit();      // file table
    80000510:	00003097          	auipc	ra,0x3
    80000514:	6ee080e7          	jalr	1774(ra) # 80003bfe <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000518:	00005097          	auipc	ra,0x5
    8000051c:	0ac080e7          	jalr	172(ra) # 800055c4 <virtio_disk_init>
    userinit();      // first user process
    80000520:	00001097          	auipc	ra,0x1
    80000524:	d3e080e7          	jalr	-706(ra) # 8000125e <userinit>
    __sync_synchronize();
    80000528:	0330000f          	fence	rw,rw
    started = 1;
    8000052c:	4785                	li	a5,1
    8000052e:	0000c717          	auipc	a4,0xc
    80000532:	acf72923          	sw	a5,-1326(a4) # 8000c000 <started>
    80000536:	bf2d                	j	80000470 <main+0x5e>

0000000080000538 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000538:	1141                	addi	sp,sp,-16
    8000053a:	e422                	sd	s0,8(sp)
    8000053c:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000053e:	0000c797          	auipc	a5,0xc
    80000542:	aca7b783          	ld	a5,-1334(a5) # 8000c008 <kernel_pagetable>
    80000546:	83b1                	srli	a5,a5,0xc
    80000548:	577d                	li	a4,-1
    8000054a:	177e                	slli	a4,a4,0x3f
    8000054c:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000054e:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000552:	12000073          	sfence.vma
  sfence_vma();
}
    80000556:	6422                	ld	s0,8(sp)
    80000558:	0141                	addi	sp,sp,16
    8000055a:	8082                	ret

000000008000055c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000055c:	7139                	addi	sp,sp,-64
    8000055e:	fc06                	sd	ra,56(sp)
    80000560:	f822                	sd	s0,48(sp)
    80000562:	f426                	sd	s1,40(sp)
    80000564:	f04a                	sd	s2,32(sp)
    80000566:	ec4e                	sd	s3,24(sp)
    80000568:	e852                	sd	s4,16(sp)
    8000056a:	e456                	sd	s5,8(sp)
    8000056c:	e05a                	sd	s6,0(sp)
    8000056e:	0080                	addi	s0,sp,64
    80000570:	84aa                	mv	s1,a0
    80000572:	89ae                	mv	s3,a1
    80000574:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000576:	57fd                	li	a5,-1
    80000578:	83e9                	srli	a5,a5,0x1a
    8000057a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000057c:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000057e:	04b7f263          	bgeu	a5,a1,800005c2 <walk+0x66>
    panic("walk");
    80000582:	00008517          	auipc	a0,0x8
    80000586:	ace50513          	addi	a0,a0,-1330 # 80008050 <etext+0x50>
    8000058a:	00006097          	auipc	ra,0x6
    8000058e:	dac080e7          	jalr	-596(ra) # 80006336 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000592:	060a8663          	beqz	s5,800005fe <walk+0xa2>
    80000596:	00000097          	auipc	ra,0x0
    8000059a:	bd6080e7          	jalr	-1066(ra) # 8000016c <kalloc>
    8000059e:	84aa                	mv	s1,a0
    800005a0:	c529                	beqz	a0,800005ea <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800005a2:	6605                	lui	a2,0x1
    800005a4:	4581                	li	a1,0
    800005a6:	00000097          	auipc	ra,0x0
    800005aa:	cce080e7          	jalr	-818(ra) # 80000274 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005ae:	00c4d793          	srli	a5,s1,0xc
    800005b2:	07aa                	slli	a5,a5,0xa
    800005b4:	0017e793          	ori	a5,a5,1
    800005b8:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800005bc:	3a5d                	addiw	s4,s4,-9
    800005be:	036a0063          	beq	s4,s6,800005de <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800005c2:	0149d933          	srl	s2,s3,s4
    800005c6:	1ff97913          	andi	s2,s2,511
    800005ca:	090e                	slli	s2,s2,0x3
    800005cc:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800005ce:	00093483          	ld	s1,0(s2)
    800005d2:	0014f793          	andi	a5,s1,1
    800005d6:	dfd5                	beqz	a5,80000592 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800005d8:	80a9                	srli	s1,s1,0xa
    800005da:	04b2                	slli	s1,s1,0xc
    800005dc:	b7c5                	j	800005bc <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800005de:	00c9d513          	srli	a0,s3,0xc
    800005e2:	1ff57513          	andi	a0,a0,511
    800005e6:	050e                	slli	a0,a0,0x3
    800005e8:	9526                	add	a0,a0,s1
}
    800005ea:	70e2                	ld	ra,56(sp)
    800005ec:	7442                	ld	s0,48(sp)
    800005ee:	74a2                	ld	s1,40(sp)
    800005f0:	7902                	ld	s2,32(sp)
    800005f2:	69e2                	ld	s3,24(sp)
    800005f4:	6a42                	ld	s4,16(sp)
    800005f6:	6aa2                	ld	s5,8(sp)
    800005f8:	6b02                	ld	s6,0(sp)
    800005fa:	6121                	addi	sp,sp,64
    800005fc:	8082                	ret
        return 0;
    800005fe:	4501                	li	a0,0
    80000600:	b7ed                	j	800005ea <walk+0x8e>

0000000080000602 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000602:	57fd                	li	a5,-1
    80000604:	83e9                	srli	a5,a5,0x1a
    80000606:	00b7f463          	bgeu	a5,a1,8000060e <walkaddr+0xc>
    return 0;
    8000060a:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000060c:	8082                	ret
{
    8000060e:	1141                	addi	sp,sp,-16
    80000610:	e406                	sd	ra,8(sp)
    80000612:	e022                	sd	s0,0(sp)
    80000614:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000616:	4601                	li	a2,0
    80000618:	00000097          	auipc	ra,0x0
    8000061c:	f44080e7          	jalr	-188(ra) # 8000055c <walk>
  if(pte == 0)
    80000620:	c105                	beqz	a0,80000640 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000622:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000624:	0117f693          	andi	a3,a5,17
    80000628:	4745                	li	a4,17
    return 0;
    8000062a:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000062c:	00e68663          	beq	a3,a4,80000638 <walkaddr+0x36>
}
    80000630:	60a2                	ld	ra,8(sp)
    80000632:	6402                	ld	s0,0(sp)
    80000634:	0141                	addi	sp,sp,16
    80000636:	8082                	ret
  pa = PTE2PA(*pte);
    80000638:	83a9                	srli	a5,a5,0xa
    8000063a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000063e:	bfcd                	j	80000630 <walkaddr+0x2e>
    return 0;
    80000640:	4501                	li	a0,0
    80000642:	b7fd                	j	80000630 <walkaddr+0x2e>

0000000080000644 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000644:	715d                	addi	sp,sp,-80
    80000646:	e486                	sd	ra,72(sp)
    80000648:	e0a2                	sd	s0,64(sp)
    8000064a:	fc26                	sd	s1,56(sp)
    8000064c:	f84a                	sd	s2,48(sp)
    8000064e:	f44e                	sd	s3,40(sp)
    80000650:	f052                	sd	s4,32(sp)
    80000652:	ec56                	sd	s5,24(sp)
    80000654:	e85a                	sd	s6,16(sp)
    80000656:	e45e                	sd	s7,8(sp)
    80000658:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000065a:	c639                	beqz	a2,800006a8 <mappages+0x64>
    8000065c:	8aaa                	mv	s5,a0
    8000065e:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000660:	777d                	lui	a4,0xfffff
    80000662:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000666:	fff58993          	addi	s3,a1,-1
    8000066a:	99b2                	add	s3,s3,a2
    8000066c:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000670:	893e                	mv	s2,a5
    80000672:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000676:	6b85                	lui	s7,0x1
    80000678:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000067c:	4605                	li	a2,1
    8000067e:	85ca                	mv	a1,s2
    80000680:	8556                	mv	a0,s5
    80000682:	00000097          	auipc	ra,0x0
    80000686:	eda080e7          	jalr	-294(ra) # 8000055c <walk>
    8000068a:	cd1d                	beqz	a0,800006c8 <mappages+0x84>
    if(*pte & PTE_V)
    8000068c:	611c                	ld	a5,0(a0)
    8000068e:	8b85                	andi	a5,a5,1
    80000690:	e785                	bnez	a5,800006b8 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000692:	80b1                	srli	s1,s1,0xc
    80000694:	04aa                	slli	s1,s1,0xa
    80000696:	0164e4b3          	or	s1,s1,s6
    8000069a:	0014e493          	ori	s1,s1,1
    8000069e:	e104                	sd	s1,0(a0)
    if(a == last)
    800006a0:	05390063          	beq	s2,s3,800006e0 <mappages+0x9c>
    a += PGSIZE;
    800006a4:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800006a6:	bfc9                	j	80000678 <mappages+0x34>
    panic("mappages: size");
    800006a8:	00008517          	auipc	a0,0x8
    800006ac:	9b050513          	addi	a0,a0,-1616 # 80008058 <etext+0x58>
    800006b0:	00006097          	auipc	ra,0x6
    800006b4:	c86080e7          	jalr	-890(ra) # 80006336 <panic>
      panic("mappages: remap");
    800006b8:	00008517          	auipc	a0,0x8
    800006bc:	9b050513          	addi	a0,a0,-1616 # 80008068 <etext+0x68>
    800006c0:	00006097          	auipc	ra,0x6
    800006c4:	c76080e7          	jalr	-906(ra) # 80006336 <panic>
      return -1;
    800006c8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800006ca:	60a6                	ld	ra,72(sp)
    800006cc:	6406                	ld	s0,64(sp)
    800006ce:	74e2                	ld	s1,56(sp)
    800006d0:	7942                	ld	s2,48(sp)
    800006d2:	79a2                	ld	s3,40(sp)
    800006d4:	7a02                	ld	s4,32(sp)
    800006d6:	6ae2                	ld	s5,24(sp)
    800006d8:	6b42                	ld	s6,16(sp)
    800006da:	6ba2                	ld	s7,8(sp)
    800006dc:	6161                	addi	sp,sp,80
    800006de:	8082                	ret
  return 0;
    800006e0:	4501                	li	a0,0
    800006e2:	b7e5                	j	800006ca <mappages+0x86>

00000000800006e4 <kvmmap>:
{
    800006e4:	1141                	addi	sp,sp,-16
    800006e6:	e406                	sd	ra,8(sp)
    800006e8:	e022                	sd	s0,0(sp)
    800006ea:	0800                	addi	s0,sp,16
    800006ec:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800006ee:	86b2                	mv	a3,a2
    800006f0:	863e                	mv	a2,a5
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	f52080e7          	jalr	-174(ra) # 80000644 <mappages>
    800006fa:	e509                	bnez	a0,80000704 <kvmmap+0x20>
}
    800006fc:	60a2                	ld	ra,8(sp)
    800006fe:	6402                	ld	s0,0(sp)
    80000700:	0141                	addi	sp,sp,16
    80000702:	8082                	ret
    panic("kvmmap");
    80000704:	00008517          	auipc	a0,0x8
    80000708:	97450513          	addi	a0,a0,-1676 # 80008078 <etext+0x78>
    8000070c:	00006097          	auipc	ra,0x6
    80000710:	c2a080e7          	jalr	-982(ra) # 80006336 <panic>

0000000080000714 <kvmmake>:
{
    80000714:	1101                	addi	sp,sp,-32
    80000716:	ec06                	sd	ra,24(sp)
    80000718:	e822                	sd	s0,16(sp)
    8000071a:	e426                	sd	s1,8(sp)
    8000071c:	e04a                	sd	s2,0(sp)
    8000071e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000720:	00000097          	auipc	ra,0x0
    80000724:	a4c080e7          	jalr	-1460(ra) # 8000016c <kalloc>
    80000728:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000072a:	6605                	lui	a2,0x1
    8000072c:	4581                	li	a1,0
    8000072e:	00000097          	auipc	ra,0x0
    80000732:	b46080e7          	jalr	-1210(ra) # 80000274 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000736:	4719                	li	a4,6
    80000738:	6685                	lui	a3,0x1
    8000073a:	10000637          	lui	a2,0x10000
    8000073e:	100005b7          	lui	a1,0x10000
    80000742:	8526                	mv	a0,s1
    80000744:	00000097          	auipc	ra,0x0
    80000748:	fa0080e7          	jalr	-96(ra) # 800006e4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000074c:	4719                	li	a4,6
    8000074e:	6685                	lui	a3,0x1
    80000750:	10001637          	lui	a2,0x10001
    80000754:	100015b7          	lui	a1,0x10001
    80000758:	8526                	mv	a0,s1
    8000075a:	00000097          	auipc	ra,0x0
    8000075e:	f8a080e7          	jalr	-118(ra) # 800006e4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000762:	4719                	li	a4,6
    80000764:	004006b7          	lui	a3,0x400
    80000768:	0c000637          	lui	a2,0xc000
    8000076c:	0c0005b7          	lui	a1,0xc000
    80000770:	8526                	mv	a0,s1
    80000772:	00000097          	auipc	ra,0x0
    80000776:	f72080e7          	jalr	-142(ra) # 800006e4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000077a:	00008917          	auipc	s2,0x8
    8000077e:	88690913          	addi	s2,s2,-1914 # 80008000 <etext>
    80000782:	4729                	li	a4,10
    80000784:	80008697          	auipc	a3,0x80008
    80000788:	87c68693          	addi	a3,a3,-1924 # 8000 <_entry-0x7fff8000>
    8000078c:	4605                	li	a2,1
    8000078e:	067e                	slli	a2,a2,0x1f
    80000790:	85b2                	mv	a1,a2
    80000792:	8526                	mv	a0,s1
    80000794:	00000097          	auipc	ra,0x0
    80000798:	f50080e7          	jalr	-176(ra) # 800006e4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000079c:	46c5                	li	a3,17
    8000079e:	06ee                	slli	a3,a3,0x1b
    800007a0:	4719                	li	a4,6
    800007a2:	412686b3          	sub	a3,a3,s2
    800007a6:	864a                	mv	a2,s2
    800007a8:	85ca                	mv	a1,s2
    800007aa:	8526                	mv	a0,s1
    800007ac:	00000097          	auipc	ra,0x0
    800007b0:	f38080e7          	jalr	-200(ra) # 800006e4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007b4:	4729                	li	a4,10
    800007b6:	6685                	lui	a3,0x1
    800007b8:	00007617          	auipc	a2,0x7
    800007bc:	84860613          	addi	a2,a2,-1976 # 80007000 <_trampoline>
    800007c0:	040005b7          	lui	a1,0x4000
    800007c4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800007c6:	05b2                	slli	a1,a1,0xc
    800007c8:	8526                	mv	a0,s1
    800007ca:	00000097          	auipc	ra,0x0
    800007ce:	f1a080e7          	jalr	-230(ra) # 800006e4 <kvmmap>
  proc_mapstacks(kpgtbl);
    800007d2:	8526                	mv	a0,s1
    800007d4:	00000097          	auipc	ra,0x0
    800007d8:	624080e7          	jalr	1572(ra) # 80000df8 <proc_mapstacks>
}
    800007dc:	8526                	mv	a0,s1
    800007de:	60e2                	ld	ra,24(sp)
    800007e0:	6442                	ld	s0,16(sp)
    800007e2:	64a2                	ld	s1,8(sp)
    800007e4:	6902                	ld	s2,0(sp)
    800007e6:	6105                	addi	sp,sp,32
    800007e8:	8082                	ret

00000000800007ea <kvminit>:
{
    800007ea:	1141                	addi	sp,sp,-16
    800007ec:	e406                	sd	ra,8(sp)
    800007ee:	e022                	sd	s0,0(sp)
    800007f0:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800007f2:	00000097          	auipc	ra,0x0
    800007f6:	f22080e7          	jalr	-222(ra) # 80000714 <kvmmake>
    800007fa:	0000c797          	auipc	a5,0xc
    800007fe:	80a7b723          	sd	a0,-2034(a5) # 8000c008 <kernel_pagetable>
}
    80000802:	60a2                	ld	ra,8(sp)
    80000804:	6402                	ld	s0,0(sp)
    80000806:	0141                	addi	sp,sp,16
    80000808:	8082                	ret

000000008000080a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000080a:	715d                	addi	sp,sp,-80
    8000080c:	e486                	sd	ra,72(sp)
    8000080e:	e0a2                	sd	s0,64(sp)
    80000810:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000812:	03459793          	slli	a5,a1,0x34
    80000816:	e39d                	bnez	a5,8000083c <uvmunmap+0x32>
    80000818:	f84a                	sd	s2,48(sp)
    8000081a:	f44e                	sd	s3,40(sp)
    8000081c:	f052                	sd	s4,32(sp)
    8000081e:	ec56                	sd	s5,24(sp)
    80000820:	e85a                	sd	s6,16(sp)
    80000822:	e45e                	sd	s7,8(sp)
    80000824:	8a2a                	mv	s4,a0
    80000826:	892e                	mv	s2,a1
    80000828:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000082a:	0632                	slli	a2,a2,0xc
    8000082c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000830:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000832:	6b05                	lui	s6,0x1
    80000834:	0935fb63          	bgeu	a1,s3,800008ca <uvmunmap+0xc0>
    80000838:	fc26                	sd	s1,56(sp)
    8000083a:	a8a9                	j	80000894 <uvmunmap+0x8a>
    8000083c:	fc26                	sd	s1,56(sp)
    8000083e:	f84a                	sd	s2,48(sp)
    80000840:	f44e                	sd	s3,40(sp)
    80000842:	f052                	sd	s4,32(sp)
    80000844:	ec56                	sd	s5,24(sp)
    80000846:	e85a                	sd	s6,16(sp)
    80000848:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000084a:	00008517          	auipc	a0,0x8
    8000084e:	83650513          	addi	a0,a0,-1994 # 80008080 <etext+0x80>
    80000852:	00006097          	auipc	ra,0x6
    80000856:	ae4080e7          	jalr	-1308(ra) # 80006336 <panic>
      panic("uvmunmap: walk");
    8000085a:	00008517          	auipc	a0,0x8
    8000085e:	83e50513          	addi	a0,a0,-1986 # 80008098 <etext+0x98>
    80000862:	00006097          	auipc	ra,0x6
    80000866:	ad4080e7          	jalr	-1324(ra) # 80006336 <panic>
      panic("uvmunmap: not mapped");
    8000086a:	00008517          	auipc	a0,0x8
    8000086e:	83e50513          	addi	a0,a0,-1986 # 800080a8 <etext+0xa8>
    80000872:	00006097          	auipc	ra,0x6
    80000876:	ac4080e7          	jalr	-1340(ra) # 80006336 <panic>
      panic("uvmunmap: not a leaf");
    8000087a:	00008517          	auipc	a0,0x8
    8000087e:	84650513          	addi	a0,a0,-1978 # 800080c0 <etext+0xc0>
    80000882:	00006097          	auipc	ra,0x6
    80000886:	ab4080e7          	jalr	-1356(ra) # 80006336 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000088a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000088e:	995a                	add	s2,s2,s6
    80000890:	03397c63          	bgeu	s2,s3,800008c8 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000894:	4601                	li	a2,0
    80000896:	85ca                	mv	a1,s2
    80000898:	8552                	mv	a0,s4
    8000089a:	00000097          	auipc	ra,0x0
    8000089e:	cc2080e7          	jalr	-830(ra) # 8000055c <walk>
    800008a2:	84aa                	mv	s1,a0
    800008a4:	d95d                	beqz	a0,8000085a <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    800008a6:	6108                	ld	a0,0(a0)
    800008a8:	00157793          	andi	a5,a0,1
    800008ac:	dfdd                	beqz	a5,8000086a <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800008ae:	3ff57793          	andi	a5,a0,1023
    800008b2:	fd7784e3          	beq	a5,s7,8000087a <uvmunmap+0x70>
    if(do_free){
    800008b6:	fc0a8ae3          	beqz	s5,8000088a <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800008ba:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800008bc:	0532                	slli	a0,a0,0xc
    800008be:	fffff097          	auipc	ra,0xfffff
    800008c2:	75e080e7          	jalr	1886(ra) # 8000001c <kfree>
    800008c6:	b7d1                	j	8000088a <uvmunmap+0x80>
    800008c8:	74e2                	ld	s1,56(sp)
    800008ca:	7942                	ld	s2,48(sp)
    800008cc:	79a2                	ld	s3,40(sp)
    800008ce:	7a02                	ld	s4,32(sp)
    800008d0:	6ae2                	ld	s5,24(sp)
    800008d2:	6b42                	ld	s6,16(sp)
    800008d4:	6ba2                	ld	s7,8(sp)
  }
}
    800008d6:	60a6                	ld	ra,72(sp)
    800008d8:	6406                	ld	s0,64(sp)
    800008da:	6161                	addi	sp,sp,80
    800008dc:	8082                	ret

00000000800008de <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008de:	1101                	addi	sp,sp,-32
    800008e0:	ec06                	sd	ra,24(sp)
    800008e2:	e822                	sd	s0,16(sp)
    800008e4:	e426                	sd	s1,8(sp)
    800008e6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	884080e7          	jalr	-1916(ra) # 8000016c <kalloc>
    800008f0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800008f2:	c519                	beqz	a0,80000900 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800008f4:	6605                	lui	a2,0x1
    800008f6:	4581                	li	a1,0
    800008f8:	00000097          	auipc	ra,0x0
    800008fc:	97c080e7          	jalr	-1668(ra) # 80000274 <memset>
  return pagetable;
}
    80000900:	8526                	mv	a0,s1
    80000902:	60e2                	ld	ra,24(sp)
    80000904:	6442                	ld	s0,16(sp)
    80000906:	64a2                	ld	s1,8(sp)
    80000908:	6105                	addi	sp,sp,32
    8000090a:	8082                	ret

000000008000090c <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000090c:	7179                	addi	sp,sp,-48
    8000090e:	f406                	sd	ra,40(sp)
    80000910:	f022                	sd	s0,32(sp)
    80000912:	ec26                	sd	s1,24(sp)
    80000914:	e84a                	sd	s2,16(sp)
    80000916:	e44e                	sd	s3,8(sp)
    80000918:	e052                	sd	s4,0(sp)
    8000091a:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000091c:	6785                	lui	a5,0x1
    8000091e:	04f67863          	bgeu	a2,a5,8000096e <uvminit+0x62>
    80000922:	8a2a                	mv	s4,a0
    80000924:	89ae                	mv	s3,a1
    80000926:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000928:	00000097          	auipc	ra,0x0
    8000092c:	844080e7          	jalr	-1980(ra) # 8000016c <kalloc>
    80000930:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000932:	6605                	lui	a2,0x1
    80000934:	4581                	li	a1,0
    80000936:	00000097          	auipc	ra,0x0
    8000093a:	93e080e7          	jalr	-1730(ra) # 80000274 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000093e:	4779                	li	a4,30
    80000940:	86ca                	mv	a3,s2
    80000942:	6605                	lui	a2,0x1
    80000944:	4581                	li	a1,0
    80000946:	8552                	mv	a0,s4
    80000948:	00000097          	auipc	ra,0x0
    8000094c:	cfc080e7          	jalr	-772(ra) # 80000644 <mappages>
  memmove(mem, src, sz);
    80000950:	8626                	mv	a2,s1
    80000952:	85ce                	mv	a1,s3
    80000954:	854a                	mv	a0,s2
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	97a080e7          	jalr	-1670(ra) # 800002d0 <memmove>
}
    8000095e:	70a2                	ld	ra,40(sp)
    80000960:	7402                	ld	s0,32(sp)
    80000962:	64e2                	ld	s1,24(sp)
    80000964:	6942                	ld	s2,16(sp)
    80000966:	69a2                	ld	s3,8(sp)
    80000968:	6a02                	ld	s4,0(sp)
    8000096a:	6145                	addi	sp,sp,48
    8000096c:	8082                	ret
    panic("inituvm: more than a page");
    8000096e:	00007517          	auipc	a0,0x7
    80000972:	76a50513          	addi	a0,a0,1898 # 800080d8 <etext+0xd8>
    80000976:	00006097          	auipc	ra,0x6
    8000097a:	9c0080e7          	jalr	-1600(ra) # 80006336 <panic>

000000008000097e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000097e:	1101                	addi	sp,sp,-32
    80000980:	ec06                	sd	ra,24(sp)
    80000982:	e822                	sd	s0,16(sp)
    80000984:	e426                	sd	s1,8(sp)
    80000986:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000988:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000098a:	00b67d63          	bgeu	a2,a1,800009a4 <uvmdealloc+0x26>
    8000098e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000990:	6785                	lui	a5,0x1
    80000992:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000994:	00f60733          	add	a4,a2,a5
    80000998:	76fd                	lui	a3,0xfffff
    8000099a:	8f75                	and	a4,a4,a3
    8000099c:	97ae                	add	a5,a5,a1
    8000099e:	8ff5                	and	a5,a5,a3
    800009a0:	00f76863          	bltu	a4,a5,800009b0 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800009a4:	8526                	mv	a0,s1
    800009a6:	60e2                	ld	ra,24(sp)
    800009a8:	6442                	ld	s0,16(sp)
    800009aa:	64a2                	ld	s1,8(sp)
    800009ac:	6105                	addi	sp,sp,32
    800009ae:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009b0:	8f99                	sub	a5,a5,a4
    800009b2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800009b4:	4685                	li	a3,1
    800009b6:	0007861b          	sext.w	a2,a5
    800009ba:	85ba                	mv	a1,a4
    800009bc:	00000097          	auipc	ra,0x0
    800009c0:	e4e080e7          	jalr	-434(ra) # 8000080a <uvmunmap>
    800009c4:	b7c5                	j	800009a4 <uvmdealloc+0x26>

00000000800009c6 <uvmalloc>:
  if(newsz < oldsz)
    800009c6:	0ab66563          	bltu	a2,a1,80000a70 <uvmalloc+0xaa>
{
    800009ca:	7139                	addi	sp,sp,-64
    800009cc:	fc06                	sd	ra,56(sp)
    800009ce:	f822                	sd	s0,48(sp)
    800009d0:	ec4e                	sd	s3,24(sp)
    800009d2:	e852                	sd	s4,16(sp)
    800009d4:	e456                	sd	s5,8(sp)
    800009d6:	0080                	addi	s0,sp,64
    800009d8:	8aaa                	mv	s5,a0
    800009da:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800009dc:	6785                	lui	a5,0x1
    800009de:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009e0:	95be                	add	a1,a1,a5
    800009e2:	77fd                	lui	a5,0xfffff
    800009e4:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009e8:	08c9f663          	bgeu	s3,a2,80000a74 <uvmalloc+0xae>
    800009ec:	f426                	sd	s1,40(sp)
    800009ee:	f04a                	sd	s2,32(sp)
    800009f0:	894e                	mv	s2,s3
    mem = kalloc();
    800009f2:	fffff097          	auipc	ra,0xfffff
    800009f6:	77a080e7          	jalr	1914(ra) # 8000016c <kalloc>
    800009fa:	84aa                	mv	s1,a0
    if(mem == 0){
    800009fc:	c90d                	beqz	a0,80000a2e <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800009fe:	6605                	lui	a2,0x1
    80000a00:	4581                	li	a1,0
    80000a02:	00000097          	auipc	ra,0x0
    80000a06:	872080e7          	jalr	-1934(ra) # 80000274 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000a0a:	4779                	li	a4,30
    80000a0c:	86a6                	mv	a3,s1
    80000a0e:	6605                	lui	a2,0x1
    80000a10:	85ca                	mv	a1,s2
    80000a12:	8556                	mv	a0,s5
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	c30080e7          	jalr	-976(ra) # 80000644 <mappages>
    80000a1c:	e915                	bnez	a0,80000a50 <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a1e:	6785                	lui	a5,0x1
    80000a20:	993e                	add	s2,s2,a5
    80000a22:	fd4968e3          	bltu	s2,s4,800009f2 <uvmalloc+0x2c>
  return newsz;
    80000a26:	8552                	mv	a0,s4
    80000a28:	74a2                	ld	s1,40(sp)
    80000a2a:	7902                	ld	s2,32(sp)
    80000a2c:	a819                	j	80000a42 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    80000a2e:	864e                	mv	a2,s3
    80000a30:	85ca                	mv	a1,s2
    80000a32:	8556                	mv	a0,s5
    80000a34:	00000097          	auipc	ra,0x0
    80000a38:	f4a080e7          	jalr	-182(ra) # 8000097e <uvmdealloc>
      return 0;
    80000a3c:	4501                	li	a0,0
    80000a3e:	74a2                	ld	s1,40(sp)
    80000a40:	7902                	ld	s2,32(sp)
}
    80000a42:	70e2                	ld	ra,56(sp)
    80000a44:	7442                	ld	s0,48(sp)
    80000a46:	69e2                	ld	s3,24(sp)
    80000a48:	6a42                	ld	s4,16(sp)
    80000a4a:	6aa2                	ld	s5,8(sp)
    80000a4c:	6121                	addi	sp,sp,64
    80000a4e:	8082                	ret
      kfree(mem);
    80000a50:	8526                	mv	a0,s1
    80000a52:	fffff097          	auipc	ra,0xfffff
    80000a56:	5ca080e7          	jalr	1482(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a5a:	864e                	mv	a2,s3
    80000a5c:	85ca                	mv	a1,s2
    80000a5e:	8556                	mv	a0,s5
    80000a60:	00000097          	auipc	ra,0x0
    80000a64:	f1e080e7          	jalr	-226(ra) # 8000097e <uvmdealloc>
      return 0;
    80000a68:	4501                	li	a0,0
    80000a6a:	74a2                	ld	s1,40(sp)
    80000a6c:	7902                	ld	s2,32(sp)
    80000a6e:	bfd1                	j	80000a42 <uvmalloc+0x7c>
    return oldsz;
    80000a70:	852e                	mv	a0,a1
}
    80000a72:	8082                	ret
  return newsz;
    80000a74:	8532                	mv	a0,a2
    80000a76:	b7f1                	j	80000a42 <uvmalloc+0x7c>

0000000080000a78 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a78:	7179                	addi	sp,sp,-48
    80000a7a:	f406                	sd	ra,40(sp)
    80000a7c:	f022                	sd	s0,32(sp)
    80000a7e:	ec26                	sd	s1,24(sp)
    80000a80:	e84a                	sd	s2,16(sp)
    80000a82:	e44e                	sd	s3,8(sp)
    80000a84:	e052                	sd	s4,0(sp)
    80000a86:	1800                	addi	s0,sp,48
    80000a88:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a8a:	84aa                	mv	s1,a0
    80000a8c:	6905                	lui	s2,0x1
    80000a8e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a90:	4985                	li	s3,1
    80000a92:	a829                	j	80000aac <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a94:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000a96:	00c79513          	slli	a0,a5,0xc
    80000a9a:	00000097          	auipc	ra,0x0
    80000a9e:	fde080e7          	jalr	-34(ra) # 80000a78 <freewalk>
      pagetable[i] = 0;
    80000aa2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000aa6:	04a1                	addi	s1,s1,8
    80000aa8:	03248163          	beq	s1,s2,80000aca <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000aac:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000aae:	00f7f713          	andi	a4,a5,15
    80000ab2:	ff3701e3          	beq	a4,s3,80000a94 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000ab6:	8b85                	andi	a5,a5,1
    80000ab8:	d7fd                	beqz	a5,80000aa6 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000aba:	00007517          	auipc	a0,0x7
    80000abe:	63e50513          	addi	a0,a0,1598 # 800080f8 <etext+0xf8>
    80000ac2:	00006097          	auipc	ra,0x6
    80000ac6:	874080e7          	jalr	-1932(ra) # 80006336 <panic>
    }
  }
  kfree((void*)pagetable);
    80000aca:	8552                	mv	a0,s4
    80000acc:	fffff097          	auipc	ra,0xfffff
    80000ad0:	550080e7          	jalr	1360(ra) # 8000001c <kfree>
}
    80000ad4:	70a2                	ld	ra,40(sp)
    80000ad6:	7402                	ld	s0,32(sp)
    80000ad8:	64e2                	ld	s1,24(sp)
    80000ada:	6942                	ld	s2,16(sp)
    80000adc:	69a2                	ld	s3,8(sp)
    80000ade:	6a02                	ld	s4,0(sp)
    80000ae0:	6145                	addi	sp,sp,48
    80000ae2:	8082                	ret

0000000080000ae4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000ae4:	1101                	addi	sp,sp,-32
    80000ae6:	ec06                	sd	ra,24(sp)
    80000ae8:	e822                	sd	s0,16(sp)
    80000aea:	e426                	sd	s1,8(sp)
    80000aec:	1000                	addi	s0,sp,32
    80000aee:	84aa                	mv	s1,a0
  if(sz > 0)
    80000af0:	e999                	bnez	a1,80000b06 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000af2:	8526                	mv	a0,s1
    80000af4:	00000097          	auipc	ra,0x0
    80000af8:	f84080e7          	jalr	-124(ra) # 80000a78 <freewalk>
}
    80000afc:	60e2                	ld	ra,24(sp)
    80000afe:	6442                	ld	s0,16(sp)
    80000b00:	64a2                	ld	s1,8(sp)
    80000b02:	6105                	addi	sp,sp,32
    80000b04:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000b06:	6785                	lui	a5,0x1
    80000b08:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000b0a:	95be                	add	a1,a1,a5
    80000b0c:	4685                	li	a3,1
    80000b0e:	00c5d613          	srli	a2,a1,0xc
    80000b12:	4581                	li	a1,0
    80000b14:	00000097          	auipc	ra,0x0
    80000b18:	cf6080e7          	jalr	-778(ra) # 8000080a <uvmunmap>
    80000b1c:	bfd9                	j	80000af2 <uvmfree+0xe>

0000000080000b1e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000b1e:	c679                	beqz	a2,80000bec <uvmcopy+0xce>
{
    80000b20:	715d                	addi	sp,sp,-80
    80000b22:	e486                	sd	ra,72(sp)
    80000b24:	e0a2                	sd	s0,64(sp)
    80000b26:	fc26                	sd	s1,56(sp)
    80000b28:	f84a                	sd	s2,48(sp)
    80000b2a:	f44e                	sd	s3,40(sp)
    80000b2c:	f052                	sd	s4,32(sp)
    80000b2e:	ec56                	sd	s5,24(sp)
    80000b30:	e85a                	sd	s6,16(sp)
    80000b32:	e45e                	sd	s7,8(sp)
    80000b34:	0880                	addi	s0,sp,80
    80000b36:	8b2a                	mv	s6,a0
    80000b38:	8aae                	mv	s5,a1
    80000b3a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000b3c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000b3e:	4601                	li	a2,0
    80000b40:	85ce                	mv	a1,s3
    80000b42:	855a                	mv	a0,s6
    80000b44:	00000097          	auipc	ra,0x0
    80000b48:	a18080e7          	jalr	-1512(ra) # 8000055c <walk>
    80000b4c:	c531                	beqz	a0,80000b98 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000b4e:	6118                	ld	a4,0(a0)
    80000b50:	00177793          	andi	a5,a4,1
    80000b54:	cbb1                	beqz	a5,80000ba8 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000b56:	00a75593          	srli	a1,a4,0xa
    80000b5a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000b5e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000b62:	fffff097          	auipc	ra,0xfffff
    80000b66:	60a080e7          	jalr	1546(ra) # 8000016c <kalloc>
    80000b6a:	892a                	mv	s2,a0
    80000b6c:	c939                	beqz	a0,80000bc2 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000b6e:	6605                	lui	a2,0x1
    80000b70:	85de                	mv	a1,s7
    80000b72:	fffff097          	auipc	ra,0xfffff
    80000b76:	75e080e7          	jalr	1886(ra) # 800002d0 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000b7a:	8726                	mv	a4,s1
    80000b7c:	86ca                	mv	a3,s2
    80000b7e:	6605                	lui	a2,0x1
    80000b80:	85ce                	mv	a1,s3
    80000b82:	8556                	mv	a0,s5
    80000b84:	00000097          	auipc	ra,0x0
    80000b88:	ac0080e7          	jalr	-1344(ra) # 80000644 <mappages>
    80000b8c:	e515                	bnez	a0,80000bb8 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000b8e:	6785                	lui	a5,0x1
    80000b90:	99be                	add	s3,s3,a5
    80000b92:	fb49e6e3          	bltu	s3,s4,80000b3e <uvmcopy+0x20>
    80000b96:	a081                	j	80000bd6 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000b98:	00007517          	auipc	a0,0x7
    80000b9c:	57050513          	addi	a0,a0,1392 # 80008108 <etext+0x108>
    80000ba0:	00005097          	auipc	ra,0x5
    80000ba4:	796080e7          	jalr	1942(ra) # 80006336 <panic>
      panic("uvmcopy: page not present");
    80000ba8:	00007517          	auipc	a0,0x7
    80000bac:	58050513          	addi	a0,a0,1408 # 80008128 <etext+0x128>
    80000bb0:	00005097          	auipc	ra,0x5
    80000bb4:	786080e7          	jalr	1926(ra) # 80006336 <panic>
      kfree(mem);
    80000bb8:	854a                	mv	a0,s2
    80000bba:	fffff097          	auipc	ra,0xfffff
    80000bbe:	462080e7          	jalr	1122(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000bc2:	4685                	li	a3,1
    80000bc4:	00c9d613          	srli	a2,s3,0xc
    80000bc8:	4581                	li	a1,0
    80000bca:	8556                	mv	a0,s5
    80000bcc:	00000097          	auipc	ra,0x0
    80000bd0:	c3e080e7          	jalr	-962(ra) # 8000080a <uvmunmap>
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
    80000be8:	6161                	addi	sp,sp,80
    80000bea:	8082                	ret
  return 0;
    80000bec:	4501                	li	a0,0
}
    80000bee:	8082                	ret

0000000080000bf0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000bf0:	1141                	addi	sp,sp,-16
    80000bf2:	e406                	sd	ra,8(sp)
    80000bf4:	e022                	sd	s0,0(sp)
    80000bf6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000bf8:	4601                	li	a2,0
    80000bfa:	00000097          	auipc	ra,0x0
    80000bfe:	962080e7          	jalr	-1694(ra) # 8000055c <walk>
  if(pte == 0)
    80000c02:	c901                	beqz	a0,80000c12 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c04:	611c                	ld	a5,0(a0)
    80000c06:	9bbd                	andi	a5,a5,-17
    80000c08:	e11c                	sd	a5,0(a0)
}
    80000c0a:	60a2                	ld	ra,8(sp)
    80000c0c:	6402                	ld	s0,0(sp)
    80000c0e:	0141                	addi	sp,sp,16
    80000c10:	8082                	ret
    panic("uvmclear");
    80000c12:	00007517          	auipc	a0,0x7
    80000c16:	53650513          	addi	a0,a0,1334 # 80008148 <etext+0x148>
    80000c1a:	00005097          	auipc	ra,0x5
    80000c1e:	71c080e7          	jalr	1820(ra) # 80006336 <panic>

0000000080000c22 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c22:	c6bd                	beqz	a3,80000c90 <copyout+0x6e>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	e062                	sd	s8,0(sp)
    80000c3a:	0880                	addi	s0,sp,80
    80000c3c:	8b2a                	mv	s6,a0
    80000c3e:	8c2e                	mv	s8,a1
    80000c40:	8a32                	mv	s4,a2
    80000c42:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000c44:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000c46:	6a85                	lui	s5,0x1
    80000c48:	a015                	j	80000c6c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c4a:	9562                	add	a0,a0,s8
    80000c4c:	0004861b          	sext.w	a2,s1
    80000c50:	85d2                	mv	a1,s4
    80000c52:	41250533          	sub	a0,a0,s2
    80000c56:	fffff097          	auipc	ra,0xfffff
    80000c5a:	67a080e7          	jalr	1658(ra) # 800002d0 <memmove>

    len -= n;
    80000c5e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000c62:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000c64:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c68:	02098263          	beqz	s3,80000c8c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000c6c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c70:	85ca                	mv	a1,s2
    80000c72:	855a                	mv	a0,s6
    80000c74:	00000097          	auipc	ra,0x0
    80000c78:	98e080e7          	jalr	-1650(ra) # 80000602 <walkaddr>
    if(pa0 == 0)
    80000c7c:	cd01                	beqz	a0,80000c94 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000c7e:	418904b3          	sub	s1,s2,s8
    80000c82:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c84:	fc99f3e3          	bgeu	s3,s1,80000c4a <copyout+0x28>
    80000c88:	84ce                	mv	s1,s3
    80000c8a:	b7c1                	j	80000c4a <copyout+0x28>
  }
  return 0;
    80000c8c:	4501                	li	a0,0
    80000c8e:	a021                	j	80000c96 <copyout+0x74>
    80000c90:	4501                	li	a0,0
}
    80000c92:	8082                	ret
      return -1;
    80000c94:	557d                	li	a0,-1
}
    80000c96:	60a6                	ld	ra,72(sp)
    80000c98:	6406                	ld	s0,64(sp)
    80000c9a:	74e2                	ld	s1,56(sp)
    80000c9c:	7942                	ld	s2,48(sp)
    80000c9e:	79a2                	ld	s3,40(sp)
    80000ca0:	7a02                	ld	s4,32(sp)
    80000ca2:	6ae2                	ld	s5,24(sp)
    80000ca4:	6b42                	ld	s6,16(sp)
    80000ca6:	6ba2                	ld	s7,8(sp)
    80000ca8:	6c02                	ld	s8,0(sp)
    80000caa:	6161                	addi	sp,sp,80
    80000cac:	8082                	ret

0000000080000cae <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000cae:	caa5                	beqz	a3,80000d1e <copyin+0x70>
{
    80000cb0:	715d                	addi	sp,sp,-80
    80000cb2:	e486                	sd	ra,72(sp)
    80000cb4:	e0a2                	sd	s0,64(sp)
    80000cb6:	fc26                	sd	s1,56(sp)
    80000cb8:	f84a                	sd	s2,48(sp)
    80000cba:	f44e                	sd	s3,40(sp)
    80000cbc:	f052                	sd	s4,32(sp)
    80000cbe:	ec56                	sd	s5,24(sp)
    80000cc0:	e85a                	sd	s6,16(sp)
    80000cc2:	e45e                	sd	s7,8(sp)
    80000cc4:	e062                	sd	s8,0(sp)
    80000cc6:	0880                	addi	s0,sp,80
    80000cc8:	8b2a                	mv	s6,a0
    80000cca:	8a2e                	mv	s4,a1
    80000ccc:	8c32                	mv	s8,a2
    80000cce:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000cd0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000cd2:	6a85                	lui	s5,0x1
    80000cd4:	a01d                	j	80000cfa <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000cd6:	018505b3          	add	a1,a0,s8
    80000cda:	0004861b          	sext.w	a2,s1
    80000cde:	412585b3          	sub	a1,a1,s2
    80000ce2:	8552                	mv	a0,s4
    80000ce4:	fffff097          	auipc	ra,0xfffff
    80000ce8:	5ec080e7          	jalr	1516(ra) # 800002d0 <memmove>

    len -= n;
    80000cec:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000cf0:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000cf2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000cf6:	02098263          	beqz	s3,80000d1a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000cfa:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000cfe:	85ca                	mv	a1,s2
    80000d00:	855a                	mv	a0,s6
    80000d02:	00000097          	auipc	ra,0x0
    80000d06:	900080e7          	jalr	-1792(ra) # 80000602 <walkaddr>
    if(pa0 == 0)
    80000d0a:	cd01                	beqz	a0,80000d22 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000d0c:	418904b3          	sub	s1,s2,s8
    80000d10:	94d6                	add	s1,s1,s5
    if(n > len)
    80000d12:	fc99f2e3          	bgeu	s3,s1,80000cd6 <copyin+0x28>
    80000d16:	84ce                	mv	s1,s3
    80000d18:	bf7d                	j	80000cd6 <copyin+0x28>
  }
  return 0;
    80000d1a:	4501                	li	a0,0
    80000d1c:	a021                	j	80000d24 <copyin+0x76>
    80000d1e:	4501                	li	a0,0
}
    80000d20:	8082                	ret
      return -1;
    80000d22:	557d                	li	a0,-1
}
    80000d24:	60a6                	ld	ra,72(sp)
    80000d26:	6406                	ld	s0,64(sp)
    80000d28:	74e2                	ld	s1,56(sp)
    80000d2a:	7942                	ld	s2,48(sp)
    80000d2c:	79a2                	ld	s3,40(sp)
    80000d2e:	7a02                	ld	s4,32(sp)
    80000d30:	6ae2                	ld	s5,24(sp)
    80000d32:	6b42                	ld	s6,16(sp)
    80000d34:	6ba2                	ld	s7,8(sp)
    80000d36:	6c02                	ld	s8,0(sp)
    80000d38:	6161                	addi	sp,sp,80
    80000d3a:	8082                	ret

0000000080000d3c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000d3c:	cacd                	beqz	a3,80000dee <copyinstr+0xb2>
{
    80000d3e:	715d                	addi	sp,sp,-80
    80000d40:	e486                	sd	ra,72(sp)
    80000d42:	e0a2                	sd	s0,64(sp)
    80000d44:	fc26                	sd	s1,56(sp)
    80000d46:	f84a                	sd	s2,48(sp)
    80000d48:	f44e                	sd	s3,40(sp)
    80000d4a:	f052                	sd	s4,32(sp)
    80000d4c:	ec56                	sd	s5,24(sp)
    80000d4e:	e85a                	sd	s6,16(sp)
    80000d50:	e45e                	sd	s7,8(sp)
    80000d52:	0880                	addi	s0,sp,80
    80000d54:	8a2a                	mv	s4,a0
    80000d56:	8b2e                	mv	s6,a1
    80000d58:	8bb2                	mv	s7,a2
    80000d5a:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000d5c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d5e:	6985                	lui	s3,0x1
    80000d60:	a825                	j	80000d98 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000d62:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000d66:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000d68:	37fd                	addiw	a5,a5,-1
    80000d6a:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000d6e:	60a6                	ld	ra,72(sp)
    80000d70:	6406                	ld	s0,64(sp)
    80000d72:	74e2                	ld	s1,56(sp)
    80000d74:	7942                	ld	s2,48(sp)
    80000d76:	79a2                	ld	s3,40(sp)
    80000d78:	7a02                	ld	s4,32(sp)
    80000d7a:	6ae2                	ld	s5,24(sp)
    80000d7c:	6b42                	ld	s6,16(sp)
    80000d7e:	6ba2                	ld	s7,8(sp)
    80000d80:	6161                	addi	sp,sp,80
    80000d82:	8082                	ret
    80000d84:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000d88:	9742                	add	a4,a4,a6
      --max;
    80000d8a:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000d8e:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000d92:	04e58663          	beq	a1,a4,80000dde <copyinstr+0xa2>
{
    80000d96:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000d98:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d9c:	85a6                	mv	a1,s1
    80000d9e:	8552                	mv	a0,s4
    80000da0:	00000097          	auipc	ra,0x0
    80000da4:	862080e7          	jalr	-1950(ra) # 80000602 <walkaddr>
    if(pa0 == 0)
    80000da8:	cd0d                	beqz	a0,80000de2 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000daa:	417486b3          	sub	a3,s1,s7
    80000dae:	96ce                	add	a3,a3,s3
    if(n > max)
    80000db0:	00d97363          	bgeu	s2,a3,80000db6 <copyinstr+0x7a>
    80000db4:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000db6:	955e                	add	a0,a0,s7
    80000db8:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000dba:	c695                	beqz	a3,80000de6 <copyinstr+0xaa>
    80000dbc:	87da                	mv	a5,s6
    80000dbe:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000dc0:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000dc4:	96da                	add	a3,a3,s6
    80000dc6:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000dc8:	00f60733          	add	a4,a2,a5
    80000dcc:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd0db8>
    80000dd0:	db49                	beqz	a4,80000d62 <copyinstr+0x26>
        *dst = *p;
    80000dd2:	00e78023          	sb	a4,0(a5)
      dst++;
    80000dd6:	0785                	addi	a5,a5,1
    while(n > 0){
    80000dd8:	fed797e3          	bne	a5,a3,80000dc6 <copyinstr+0x8a>
    80000ddc:	b765                	j	80000d84 <copyinstr+0x48>
    80000dde:	4781                	li	a5,0
    80000de0:	b761                	j	80000d68 <copyinstr+0x2c>
      return -1;
    80000de2:	557d                	li	a0,-1
    80000de4:	b769                	j	80000d6e <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000de6:	6b85                	lui	s7,0x1
    80000de8:	9ba6                	add	s7,s7,s1
    80000dea:	87da                	mv	a5,s6
    80000dec:	b76d                	j	80000d96 <copyinstr+0x5a>
  int got_null = 0;
    80000dee:	4781                	li	a5,0
  if(got_null){
    80000df0:	37fd                	addiw	a5,a5,-1
    80000df2:	0007851b          	sext.w	a0,a5
}
    80000df6:	8082                	ret

0000000080000df8 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000df8:	7139                	addi	sp,sp,-64
    80000dfa:	fc06                	sd	ra,56(sp)
    80000dfc:	f822                	sd	s0,48(sp)
    80000dfe:	f426                	sd	s1,40(sp)
    80000e00:	f04a                	sd	s2,32(sp)
    80000e02:	ec4e                	sd	s3,24(sp)
    80000e04:	e852                	sd	s4,16(sp)
    80000e06:	e456                	sd	s5,8(sp)
    80000e08:	e05a                	sd	s6,0(sp)
    80000e0a:	0080                	addi	s0,sp,64
    80000e0c:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e0e:	0000b497          	auipc	s1,0xb
    80000e12:	7a248493          	addi	s1,s1,1954 # 8000c5b0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e16:	8b26                	mv	s6,s1
    80000e18:	ff4df937          	lui	s2,0xff4df
    80000e1c:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b0775>
    80000e20:	0936                	slli	s2,s2,0xd
    80000e22:	6f590913          	addi	s2,s2,1781
    80000e26:	0936                	slli	s2,s2,0xd
    80000e28:	bd390913          	addi	s2,s2,-1069
    80000e2c:	0932                	slli	s2,s2,0xc
    80000e2e:	7a790913          	addi	s2,s2,1959
    80000e32:	040009b7          	lui	s3,0x4000
    80000e36:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e38:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e3a:	00011a97          	auipc	s5,0x11
    80000e3e:	376a8a93          	addi	s5,s5,886 # 800121b0 <tickslock>
    char *pa = kalloc();
    80000e42:	fffff097          	auipc	ra,0xfffff
    80000e46:	32a080e7          	jalr	810(ra) # 8000016c <kalloc>
    80000e4a:	862a                	mv	a2,a0
    if(pa == 0)
    80000e4c:	c121                	beqz	a0,80000e8c <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000e4e:	416485b3          	sub	a1,s1,s6
    80000e52:	8591                	srai	a1,a1,0x4
    80000e54:	032585b3          	mul	a1,a1,s2
    80000e58:	2585                	addiw	a1,a1,1
    80000e5a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e5e:	4719                	li	a4,6
    80000e60:	6685                	lui	a3,0x1
    80000e62:	40b985b3          	sub	a1,s3,a1
    80000e66:	8552                	mv	a0,s4
    80000e68:	00000097          	auipc	ra,0x0
    80000e6c:	87c080e7          	jalr	-1924(ra) # 800006e4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e70:	17048493          	addi	s1,s1,368
    80000e74:	fd5497e3          	bne	s1,s5,80000e42 <proc_mapstacks+0x4a>
  }
}
    80000e78:	70e2                	ld	ra,56(sp)
    80000e7a:	7442                	ld	s0,48(sp)
    80000e7c:	74a2                	ld	s1,40(sp)
    80000e7e:	7902                	ld	s2,32(sp)
    80000e80:	69e2                	ld	s3,24(sp)
    80000e82:	6a42                	ld	s4,16(sp)
    80000e84:	6aa2                	ld	s5,8(sp)
    80000e86:	6b02                	ld	s6,0(sp)
    80000e88:	6121                	addi	sp,sp,64
    80000e8a:	8082                	ret
      panic("kalloc");
    80000e8c:	00007517          	auipc	a0,0x7
    80000e90:	2cc50513          	addi	a0,a0,716 # 80008158 <etext+0x158>
    80000e94:	00005097          	auipc	ra,0x5
    80000e98:	4a2080e7          	jalr	1186(ra) # 80006336 <panic>

0000000080000e9c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000e9c:	7139                	addi	sp,sp,-64
    80000e9e:	fc06                	sd	ra,56(sp)
    80000ea0:	f822                	sd	s0,48(sp)
    80000ea2:	f426                	sd	s1,40(sp)
    80000ea4:	f04a                	sd	s2,32(sp)
    80000ea6:	ec4e                	sd	s3,24(sp)
    80000ea8:	e852                	sd	s4,16(sp)
    80000eaa:	e456                	sd	s5,8(sp)
    80000eac:	e05a                	sd	s6,0(sp)
    80000eae:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000eb0:	00007597          	auipc	a1,0x7
    80000eb4:	2b058593          	addi	a1,a1,688 # 80008160 <etext+0x160>
    80000eb8:	0000b517          	auipc	a0,0xb
    80000ebc:	2b850513          	addi	a0,a0,696 # 8000c170 <pid_lock>
    80000ec0:	00006097          	auipc	ra,0x6
    80000ec4:	b4e080e7          	jalr	-1202(ra) # 80006a0e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ec8:	00007597          	auipc	a1,0x7
    80000ecc:	2a058593          	addi	a1,a1,672 # 80008168 <etext+0x168>
    80000ed0:	0000b517          	auipc	a0,0xb
    80000ed4:	2c050513          	addi	a0,a0,704 # 8000c190 <wait_lock>
    80000ed8:	00006097          	auipc	ra,0x6
    80000edc:	b36080e7          	jalr	-1226(ra) # 80006a0e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ee0:	0000b497          	auipc	s1,0xb
    80000ee4:	6d048493          	addi	s1,s1,1744 # 8000c5b0 <proc>
      initlock(&p->lock, "proc");
    80000ee8:	00007b17          	auipc	s6,0x7
    80000eec:	290b0b13          	addi	s6,s6,656 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000ef0:	8aa6                	mv	s5,s1
    80000ef2:	ff4df937          	lui	s2,0xff4df
    80000ef6:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b0775>
    80000efa:	0936                	slli	s2,s2,0xd
    80000efc:	6f590913          	addi	s2,s2,1781
    80000f00:	0936                	slli	s2,s2,0xd
    80000f02:	bd390913          	addi	s2,s2,-1069
    80000f06:	0932                	slli	s2,s2,0xc
    80000f08:	7a790913          	addi	s2,s2,1959
    80000f0c:	040009b7          	lui	s3,0x4000
    80000f10:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000f12:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f14:	00011a17          	auipc	s4,0x11
    80000f18:	29ca0a13          	addi	s4,s4,668 # 800121b0 <tickslock>
      initlock(&p->lock, "proc");
    80000f1c:	85da                	mv	a1,s6
    80000f1e:	8526                	mv	a0,s1
    80000f20:	00006097          	auipc	ra,0x6
    80000f24:	aee080e7          	jalr	-1298(ra) # 80006a0e <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f28:	415487b3          	sub	a5,s1,s5
    80000f2c:	8791                	srai	a5,a5,0x4
    80000f2e:	032787b3          	mul	a5,a5,s2
    80000f32:	2785                	addiw	a5,a5,1
    80000f34:	00d7979b          	slliw	a5,a5,0xd
    80000f38:	40f987b3          	sub	a5,s3,a5
    80000f3c:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f3e:	17048493          	addi	s1,s1,368
    80000f42:	fd449de3          	bne	s1,s4,80000f1c <procinit+0x80>
  }
}
    80000f46:	70e2                	ld	ra,56(sp)
    80000f48:	7442                	ld	s0,48(sp)
    80000f4a:	74a2                	ld	s1,40(sp)
    80000f4c:	7902                	ld	s2,32(sp)
    80000f4e:	69e2                	ld	s3,24(sp)
    80000f50:	6a42                	ld	s4,16(sp)
    80000f52:	6aa2                	ld	s5,8(sp)
    80000f54:	6b02                	ld	s6,0(sp)
    80000f56:	6121                	addi	sp,sp,64
    80000f58:	8082                	ret

0000000080000f5a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f5a:	1141                	addi	sp,sp,-16
    80000f5c:	e422                	sd	s0,8(sp)
    80000f5e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f60:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f62:	2501                	sext.w	a0,a0
    80000f64:	6422                	ld	s0,8(sp)
    80000f66:	0141                	addi	sp,sp,16
    80000f68:	8082                	ret

0000000080000f6a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f6a:	1141                	addi	sp,sp,-16
    80000f6c:	e422                	sd	s0,8(sp)
    80000f6e:	0800                	addi	s0,sp,16
    80000f70:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f72:	2781                	sext.w	a5,a5
    80000f74:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f76:	0000b517          	auipc	a0,0xb
    80000f7a:	23a50513          	addi	a0,a0,570 # 8000c1b0 <cpus>
    80000f7e:	953e                	add	a0,a0,a5
    80000f80:	6422                	ld	s0,8(sp)
    80000f82:	0141                	addi	sp,sp,16
    80000f84:	8082                	ret

0000000080000f86 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f86:	1101                	addi	sp,sp,-32
    80000f88:	ec06                	sd	ra,24(sp)
    80000f8a:	e822                	sd	s0,16(sp)
    80000f8c:	e426                	sd	s1,8(sp)
    80000f8e:	1000                	addi	s0,sp,32
  push_off();
    80000f90:	00006097          	auipc	ra,0x6
    80000f94:	8be080e7          	jalr	-1858(ra) # 8000684e <push_off>
    80000f98:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f9a:	2781                	sext.w	a5,a5
    80000f9c:	079e                	slli	a5,a5,0x7
    80000f9e:	0000b717          	auipc	a4,0xb
    80000fa2:	1d270713          	addi	a4,a4,466 # 8000c170 <pid_lock>
    80000fa6:	97ba                	add	a5,a5,a4
    80000fa8:	63a4                	ld	s1,64(a5)
  pop_off();
    80000faa:	00006097          	auipc	ra,0x6
    80000fae:	958080e7          	jalr	-1704(ra) # 80006902 <pop_off>
  return p;
}
    80000fb2:	8526                	mv	a0,s1
    80000fb4:	60e2                	ld	ra,24(sp)
    80000fb6:	6442                	ld	s0,16(sp)
    80000fb8:	64a2                	ld	s1,8(sp)
    80000fba:	6105                	addi	sp,sp,32
    80000fbc:	8082                	ret

0000000080000fbe <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000fbe:	1141                	addi	sp,sp,-16
    80000fc0:	e406                	sd	ra,8(sp)
    80000fc2:	e022                	sd	s0,0(sp)
    80000fc4:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fc6:	00000097          	auipc	ra,0x0
    80000fca:	fc0080e7          	jalr	-64(ra) # 80000f86 <myproc>
    80000fce:	00006097          	auipc	ra,0x6
    80000fd2:	994080e7          	jalr	-1644(ra) # 80006962 <release>

  if (first) {
    80000fd6:	0000a797          	auipc	a5,0xa
    80000fda:	3ea7a783          	lw	a5,1002(a5) # 8000b3c0 <first.1>
    80000fde:	eb89                	bnez	a5,80000ff0 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fe0:	00001097          	auipc	ra,0x1
    80000fe4:	c16080e7          	jalr	-1002(ra) # 80001bf6 <usertrapret>
}
    80000fe8:	60a2                	ld	ra,8(sp)
    80000fea:	6402                	ld	s0,0(sp)
    80000fec:	0141                	addi	sp,sp,16
    80000fee:	8082                	ret
    first = 0;
    80000ff0:	0000a797          	auipc	a5,0xa
    80000ff4:	3c07a823          	sw	zero,976(a5) # 8000b3c0 <first.1>
    fsinit(ROOTDEV);
    80000ff8:	4505                	li	a0,1
    80000ffa:	00002097          	auipc	ra,0x2
    80000ffe:	bd8080e7          	jalr	-1064(ra) # 80002bd2 <fsinit>
    80001002:	bff9                	j	80000fe0 <forkret+0x22>

0000000080001004 <allocpid>:
allocpid() {
    80001004:	1101                	addi	sp,sp,-32
    80001006:	ec06                	sd	ra,24(sp)
    80001008:	e822                	sd	s0,16(sp)
    8000100a:	e426                	sd	s1,8(sp)
    8000100c:	e04a                	sd	s2,0(sp)
    8000100e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001010:	0000b917          	auipc	s2,0xb
    80001014:	16090913          	addi	s2,s2,352 # 8000c170 <pid_lock>
    80001018:	854a                	mv	a0,s2
    8000101a:	00006097          	auipc	ra,0x6
    8000101e:	880080e7          	jalr	-1920(ra) # 8000689a <acquire>
  pid = nextpid;
    80001022:	0000a797          	auipc	a5,0xa
    80001026:	3a278793          	addi	a5,a5,930 # 8000b3c4 <nextpid>
    8000102a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000102c:	0014871b          	addiw	a4,s1,1
    80001030:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001032:	854a                	mv	a0,s2
    80001034:	00006097          	auipc	ra,0x6
    80001038:	92e080e7          	jalr	-1746(ra) # 80006962 <release>
}
    8000103c:	8526                	mv	a0,s1
    8000103e:	60e2                	ld	ra,24(sp)
    80001040:	6442                	ld	s0,16(sp)
    80001042:	64a2                	ld	s1,8(sp)
    80001044:	6902                	ld	s2,0(sp)
    80001046:	6105                	addi	sp,sp,32
    80001048:	8082                	ret

000000008000104a <proc_pagetable>:
{
    8000104a:	1101                	addi	sp,sp,-32
    8000104c:	ec06                	sd	ra,24(sp)
    8000104e:	e822                	sd	s0,16(sp)
    80001050:	e426                	sd	s1,8(sp)
    80001052:	e04a                	sd	s2,0(sp)
    80001054:	1000                	addi	s0,sp,32
    80001056:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001058:	00000097          	auipc	ra,0x0
    8000105c:	886080e7          	jalr	-1914(ra) # 800008de <uvmcreate>
    80001060:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001062:	c121                	beqz	a0,800010a2 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001064:	4729                	li	a4,10
    80001066:	00006697          	auipc	a3,0x6
    8000106a:	f9a68693          	addi	a3,a3,-102 # 80007000 <_trampoline>
    8000106e:	6605                	lui	a2,0x1
    80001070:	040005b7          	lui	a1,0x4000
    80001074:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001076:	05b2                	slli	a1,a1,0xc
    80001078:	fffff097          	auipc	ra,0xfffff
    8000107c:	5cc080e7          	jalr	1484(ra) # 80000644 <mappages>
    80001080:	02054863          	bltz	a0,800010b0 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001084:	4719                	li	a4,6
    80001086:	06093683          	ld	a3,96(s2)
    8000108a:	6605                	lui	a2,0x1
    8000108c:	020005b7          	lui	a1,0x2000
    80001090:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001092:	05b6                	slli	a1,a1,0xd
    80001094:	8526                	mv	a0,s1
    80001096:	fffff097          	auipc	ra,0xfffff
    8000109a:	5ae080e7          	jalr	1454(ra) # 80000644 <mappages>
    8000109e:	02054163          	bltz	a0,800010c0 <proc_pagetable+0x76>
}
    800010a2:	8526                	mv	a0,s1
    800010a4:	60e2                	ld	ra,24(sp)
    800010a6:	6442                	ld	s0,16(sp)
    800010a8:	64a2                	ld	s1,8(sp)
    800010aa:	6902                	ld	s2,0(sp)
    800010ac:	6105                	addi	sp,sp,32
    800010ae:	8082                	ret
    uvmfree(pagetable, 0);
    800010b0:	4581                	li	a1,0
    800010b2:	8526                	mv	a0,s1
    800010b4:	00000097          	auipc	ra,0x0
    800010b8:	a30080e7          	jalr	-1488(ra) # 80000ae4 <uvmfree>
    return 0;
    800010bc:	4481                	li	s1,0
    800010be:	b7d5                	j	800010a2 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010c0:	4681                	li	a3,0
    800010c2:	4605                	li	a2,1
    800010c4:	040005b7          	lui	a1,0x4000
    800010c8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010ca:	05b2                	slli	a1,a1,0xc
    800010cc:	8526                	mv	a0,s1
    800010ce:	fffff097          	auipc	ra,0xfffff
    800010d2:	73c080e7          	jalr	1852(ra) # 8000080a <uvmunmap>
    uvmfree(pagetable, 0);
    800010d6:	4581                	li	a1,0
    800010d8:	8526                	mv	a0,s1
    800010da:	00000097          	auipc	ra,0x0
    800010de:	a0a080e7          	jalr	-1526(ra) # 80000ae4 <uvmfree>
    return 0;
    800010e2:	4481                	li	s1,0
    800010e4:	bf7d                	j	800010a2 <proc_pagetable+0x58>

00000000800010e6 <proc_freepagetable>:
{
    800010e6:	1101                	addi	sp,sp,-32
    800010e8:	ec06                	sd	ra,24(sp)
    800010ea:	e822                	sd	s0,16(sp)
    800010ec:	e426                	sd	s1,8(sp)
    800010ee:	e04a                	sd	s2,0(sp)
    800010f0:	1000                	addi	s0,sp,32
    800010f2:	84aa                	mv	s1,a0
    800010f4:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010f6:	4681                	li	a3,0
    800010f8:	4605                	li	a2,1
    800010fa:	040005b7          	lui	a1,0x4000
    800010fe:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001100:	05b2                	slli	a1,a1,0xc
    80001102:	fffff097          	auipc	ra,0xfffff
    80001106:	708080e7          	jalr	1800(ra) # 8000080a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000110a:	4681                	li	a3,0
    8000110c:	4605                	li	a2,1
    8000110e:	020005b7          	lui	a1,0x2000
    80001112:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001114:	05b6                	slli	a1,a1,0xd
    80001116:	8526                	mv	a0,s1
    80001118:	fffff097          	auipc	ra,0xfffff
    8000111c:	6f2080e7          	jalr	1778(ra) # 8000080a <uvmunmap>
  uvmfree(pagetable, sz);
    80001120:	85ca                	mv	a1,s2
    80001122:	8526                	mv	a0,s1
    80001124:	00000097          	auipc	ra,0x0
    80001128:	9c0080e7          	jalr	-1600(ra) # 80000ae4 <uvmfree>
}
    8000112c:	60e2                	ld	ra,24(sp)
    8000112e:	6442                	ld	s0,16(sp)
    80001130:	64a2                	ld	s1,8(sp)
    80001132:	6902                	ld	s2,0(sp)
    80001134:	6105                	addi	sp,sp,32
    80001136:	8082                	ret

0000000080001138 <freeproc>:
{
    80001138:	1101                	addi	sp,sp,-32
    8000113a:	ec06                	sd	ra,24(sp)
    8000113c:	e822                	sd	s0,16(sp)
    8000113e:	e426                	sd	s1,8(sp)
    80001140:	1000                	addi	s0,sp,32
    80001142:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001144:	7128                	ld	a0,96(a0)
    80001146:	c509                	beqz	a0,80001150 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001148:	fffff097          	auipc	ra,0xfffff
    8000114c:	ed4080e7          	jalr	-300(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001150:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001154:	6ca8                	ld	a0,88(s1)
    80001156:	c511                	beqz	a0,80001162 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001158:	68ac                	ld	a1,80(s1)
    8000115a:	00000097          	auipc	ra,0x0
    8000115e:	f8c080e7          	jalr	-116(ra) # 800010e6 <proc_freepagetable>
  p->pagetable = 0;
    80001162:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001166:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    8000116a:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    8000116e:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    80001172:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001176:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    8000117a:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    8000117e:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001182:	0204a023          	sw	zero,32(s1)
}
    80001186:	60e2                	ld	ra,24(sp)
    80001188:	6442                	ld	s0,16(sp)
    8000118a:	64a2                	ld	s1,8(sp)
    8000118c:	6105                	addi	sp,sp,32
    8000118e:	8082                	ret

0000000080001190 <allocproc>:
{
    80001190:	1101                	addi	sp,sp,-32
    80001192:	ec06                	sd	ra,24(sp)
    80001194:	e822                	sd	s0,16(sp)
    80001196:	e426                	sd	s1,8(sp)
    80001198:	e04a                	sd	s2,0(sp)
    8000119a:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000119c:	0000b497          	auipc	s1,0xb
    800011a0:	41448493          	addi	s1,s1,1044 # 8000c5b0 <proc>
    800011a4:	00011917          	auipc	s2,0x11
    800011a8:	00c90913          	addi	s2,s2,12 # 800121b0 <tickslock>
    acquire(&p->lock);
    800011ac:	8526                	mv	a0,s1
    800011ae:	00005097          	auipc	ra,0x5
    800011b2:	6ec080e7          	jalr	1772(ra) # 8000689a <acquire>
    if(p->state == UNUSED) {
    800011b6:	509c                	lw	a5,32(s1)
    800011b8:	cf81                	beqz	a5,800011d0 <allocproc+0x40>
      release(&p->lock);
    800011ba:	8526                	mv	a0,s1
    800011bc:	00005097          	auipc	ra,0x5
    800011c0:	7a6080e7          	jalr	1958(ra) # 80006962 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011c4:	17048493          	addi	s1,s1,368
    800011c8:	ff2492e3          	bne	s1,s2,800011ac <allocproc+0x1c>
  return 0;
    800011cc:	4481                	li	s1,0
    800011ce:	a889                	j	80001220 <allocproc+0x90>
  p->pid = allocpid();
    800011d0:	00000097          	auipc	ra,0x0
    800011d4:	e34080e7          	jalr	-460(ra) # 80001004 <allocpid>
    800011d8:	dc88                	sw	a0,56(s1)
  p->state = USED;
    800011da:	4785                	li	a5,1
    800011dc:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011de:	fffff097          	auipc	ra,0xfffff
    800011e2:	f8e080e7          	jalr	-114(ra) # 8000016c <kalloc>
    800011e6:	892a                	mv	s2,a0
    800011e8:	f0a8                	sd	a0,96(s1)
    800011ea:	c131                	beqz	a0,8000122e <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800011ec:	8526                	mv	a0,s1
    800011ee:	00000097          	auipc	ra,0x0
    800011f2:	e5c080e7          	jalr	-420(ra) # 8000104a <proc_pagetable>
    800011f6:	892a                	mv	s2,a0
    800011f8:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    800011fa:	c531                	beqz	a0,80001246 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800011fc:	07000613          	li	a2,112
    80001200:	4581                	li	a1,0
    80001202:	06848513          	addi	a0,s1,104
    80001206:	fffff097          	auipc	ra,0xfffff
    8000120a:	06e080e7          	jalr	110(ra) # 80000274 <memset>
  p->context.ra = (uint64)forkret;
    8000120e:	00000797          	auipc	a5,0x0
    80001212:	db078793          	addi	a5,a5,-592 # 80000fbe <forkret>
    80001216:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001218:	64bc                	ld	a5,72(s1)
    8000121a:	6705                	lui	a4,0x1
    8000121c:	97ba                	add	a5,a5,a4
    8000121e:	f8bc                	sd	a5,112(s1)
}
    80001220:	8526                	mv	a0,s1
    80001222:	60e2                	ld	ra,24(sp)
    80001224:	6442                	ld	s0,16(sp)
    80001226:	64a2                	ld	s1,8(sp)
    80001228:	6902                	ld	s2,0(sp)
    8000122a:	6105                	addi	sp,sp,32
    8000122c:	8082                	ret
    freeproc(p);
    8000122e:	8526                	mv	a0,s1
    80001230:	00000097          	auipc	ra,0x0
    80001234:	f08080e7          	jalr	-248(ra) # 80001138 <freeproc>
    release(&p->lock);
    80001238:	8526                	mv	a0,s1
    8000123a:	00005097          	auipc	ra,0x5
    8000123e:	728080e7          	jalr	1832(ra) # 80006962 <release>
    return 0;
    80001242:	84ca                	mv	s1,s2
    80001244:	bff1                	j	80001220 <allocproc+0x90>
    freeproc(p);
    80001246:	8526                	mv	a0,s1
    80001248:	00000097          	auipc	ra,0x0
    8000124c:	ef0080e7          	jalr	-272(ra) # 80001138 <freeproc>
    release(&p->lock);
    80001250:	8526                	mv	a0,s1
    80001252:	00005097          	auipc	ra,0x5
    80001256:	710080e7          	jalr	1808(ra) # 80006962 <release>
    return 0;
    8000125a:	84ca                	mv	s1,s2
    8000125c:	b7d1                	j	80001220 <allocproc+0x90>

000000008000125e <userinit>:
{
    8000125e:	1101                	addi	sp,sp,-32
    80001260:	ec06                	sd	ra,24(sp)
    80001262:	e822                	sd	s0,16(sp)
    80001264:	e426                	sd	s1,8(sp)
    80001266:	1000                	addi	s0,sp,32
  p = allocproc();
    80001268:	00000097          	auipc	ra,0x0
    8000126c:	f28080e7          	jalr	-216(ra) # 80001190 <allocproc>
    80001270:	84aa                	mv	s1,a0
  initproc = p;
    80001272:	0000b797          	auipc	a5,0xb
    80001276:	d8a7bf23          	sd	a0,-610(a5) # 8000c010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000127a:	03400613          	li	a2,52
    8000127e:	0000a597          	auipc	a1,0xa
    80001282:	15258593          	addi	a1,a1,338 # 8000b3d0 <initcode>
    80001286:	6d28                	ld	a0,88(a0)
    80001288:	fffff097          	auipc	ra,0xfffff
    8000128c:	684080e7          	jalr	1668(ra) # 8000090c <uvminit>
  p->sz = PGSIZE;
    80001290:	6785                	lui	a5,0x1
    80001292:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    80001294:	70b8                	ld	a4,96(s1)
    80001296:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000129a:	70b8                	ld	a4,96(s1)
    8000129c:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000129e:	4641                	li	a2,16
    800012a0:	00007597          	auipc	a1,0x7
    800012a4:	ee058593          	addi	a1,a1,-288 # 80008180 <etext+0x180>
    800012a8:	16048513          	addi	a0,s1,352
    800012ac:	fffff097          	auipc	ra,0xfffff
    800012b0:	10a080e7          	jalr	266(ra) # 800003b6 <safestrcpy>
  p->cwd = namei("/");
    800012b4:	00007517          	auipc	a0,0x7
    800012b8:	edc50513          	addi	a0,a0,-292 # 80008190 <etext+0x190>
    800012bc:	00002097          	auipc	ra,0x2
    800012c0:	35c080e7          	jalr	860(ra) # 80003618 <namei>
    800012c4:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    800012c8:	478d                	li	a5,3
    800012ca:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    800012cc:	8526                	mv	a0,s1
    800012ce:	00005097          	auipc	ra,0x5
    800012d2:	694080e7          	jalr	1684(ra) # 80006962 <release>
}
    800012d6:	60e2                	ld	ra,24(sp)
    800012d8:	6442                	ld	s0,16(sp)
    800012da:	64a2                	ld	s1,8(sp)
    800012dc:	6105                	addi	sp,sp,32
    800012de:	8082                	ret

00000000800012e0 <growproc>:
{
    800012e0:	1101                	addi	sp,sp,-32
    800012e2:	ec06                	sd	ra,24(sp)
    800012e4:	e822                	sd	s0,16(sp)
    800012e6:	e426                	sd	s1,8(sp)
    800012e8:	e04a                	sd	s2,0(sp)
    800012ea:	1000                	addi	s0,sp,32
    800012ec:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800012ee:	00000097          	auipc	ra,0x0
    800012f2:	c98080e7          	jalr	-872(ra) # 80000f86 <myproc>
    800012f6:	892a                	mv	s2,a0
  sz = p->sz;
    800012f8:	692c                	ld	a1,80(a0)
    800012fa:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800012fe:	00904f63          	bgtz	s1,8000131c <growproc+0x3c>
  } else if(n < 0){
    80001302:	0204cd63          	bltz	s1,8000133c <growproc+0x5c>
  p->sz = sz;
    80001306:	1782                	slli	a5,a5,0x20
    80001308:	9381                	srli	a5,a5,0x20
    8000130a:	04f93823          	sd	a5,80(s2)
  return 0;
    8000130e:	4501                	li	a0,0
}
    80001310:	60e2                	ld	ra,24(sp)
    80001312:	6442                	ld	s0,16(sp)
    80001314:	64a2                	ld	s1,8(sp)
    80001316:	6902                	ld	s2,0(sp)
    80001318:	6105                	addi	sp,sp,32
    8000131a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000131c:	00f4863b          	addw	a2,s1,a5
    80001320:	1602                	slli	a2,a2,0x20
    80001322:	9201                	srli	a2,a2,0x20
    80001324:	1582                	slli	a1,a1,0x20
    80001326:	9181                	srli	a1,a1,0x20
    80001328:	6d28                	ld	a0,88(a0)
    8000132a:	fffff097          	auipc	ra,0xfffff
    8000132e:	69c080e7          	jalr	1692(ra) # 800009c6 <uvmalloc>
    80001332:	0005079b          	sext.w	a5,a0
    80001336:	fbe1                	bnez	a5,80001306 <growproc+0x26>
      return -1;
    80001338:	557d                	li	a0,-1
    8000133a:	bfd9                	j	80001310 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000133c:	00f4863b          	addw	a2,s1,a5
    80001340:	1602                	slli	a2,a2,0x20
    80001342:	9201                	srli	a2,a2,0x20
    80001344:	1582                	slli	a1,a1,0x20
    80001346:	9181                	srli	a1,a1,0x20
    80001348:	6d28                	ld	a0,88(a0)
    8000134a:	fffff097          	auipc	ra,0xfffff
    8000134e:	634080e7          	jalr	1588(ra) # 8000097e <uvmdealloc>
    80001352:	0005079b          	sext.w	a5,a0
    80001356:	bf45                	j	80001306 <growproc+0x26>

0000000080001358 <fork>:
{
    80001358:	7139                	addi	sp,sp,-64
    8000135a:	fc06                	sd	ra,56(sp)
    8000135c:	f822                	sd	s0,48(sp)
    8000135e:	f04a                	sd	s2,32(sp)
    80001360:	e456                	sd	s5,8(sp)
    80001362:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001364:	00000097          	auipc	ra,0x0
    80001368:	c22080e7          	jalr	-990(ra) # 80000f86 <myproc>
    8000136c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000136e:	00000097          	auipc	ra,0x0
    80001372:	e22080e7          	jalr	-478(ra) # 80001190 <allocproc>
    80001376:	12050063          	beqz	a0,80001496 <fork+0x13e>
    8000137a:	e852                	sd	s4,16(sp)
    8000137c:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000137e:	050ab603          	ld	a2,80(s5)
    80001382:	6d2c                	ld	a1,88(a0)
    80001384:	058ab503          	ld	a0,88(s5)
    80001388:	fffff097          	auipc	ra,0xfffff
    8000138c:	796080e7          	jalr	1942(ra) # 80000b1e <uvmcopy>
    80001390:	04054a63          	bltz	a0,800013e4 <fork+0x8c>
    80001394:	f426                	sd	s1,40(sp)
    80001396:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001398:	050ab783          	ld	a5,80(s5)
    8000139c:	04fa3823          	sd	a5,80(s4)
  *(np->trapframe) = *(p->trapframe);
    800013a0:	060ab683          	ld	a3,96(s5)
    800013a4:	87b6                	mv	a5,a3
    800013a6:	060a3703          	ld	a4,96(s4)
    800013aa:	12068693          	addi	a3,a3,288
    800013ae:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800013b2:	6788                	ld	a0,8(a5)
    800013b4:	6b8c                	ld	a1,16(a5)
    800013b6:	6f90                	ld	a2,24(a5)
    800013b8:	01073023          	sd	a6,0(a4)
    800013bc:	e708                	sd	a0,8(a4)
    800013be:	eb0c                	sd	a1,16(a4)
    800013c0:	ef10                	sd	a2,24(a4)
    800013c2:	02078793          	addi	a5,a5,32
    800013c6:	02070713          	addi	a4,a4,32
    800013ca:	fed792e3          	bne	a5,a3,800013ae <fork+0x56>
  np->trapframe->a0 = 0;
    800013ce:	060a3783          	ld	a5,96(s4)
    800013d2:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800013d6:	0d8a8493          	addi	s1,s5,216
    800013da:	0d8a0913          	addi	s2,s4,216
    800013de:	158a8993          	addi	s3,s5,344
    800013e2:	a015                	j	80001406 <fork+0xae>
    freeproc(np);
    800013e4:	8552                	mv	a0,s4
    800013e6:	00000097          	auipc	ra,0x0
    800013ea:	d52080e7          	jalr	-686(ra) # 80001138 <freeproc>
    release(&np->lock);
    800013ee:	8552                	mv	a0,s4
    800013f0:	00005097          	auipc	ra,0x5
    800013f4:	572080e7          	jalr	1394(ra) # 80006962 <release>
    return -1;
    800013f8:	597d                	li	s2,-1
    800013fa:	6a42                	ld	s4,16(sp)
    800013fc:	a071                	j	80001488 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    800013fe:	04a1                	addi	s1,s1,8
    80001400:	0921                	addi	s2,s2,8
    80001402:	01348b63          	beq	s1,s3,80001418 <fork+0xc0>
    if(p->ofile[i])
    80001406:	6088                	ld	a0,0(s1)
    80001408:	d97d                	beqz	a0,800013fe <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    8000140a:	00003097          	auipc	ra,0x3
    8000140e:	886080e7          	jalr	-1914(ra) # 80003c90 <filedup>
    80001412:	00a93023          	sd	a0,0(s2)
    80001416:	b7e5                	j	800013fe <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001418:	158ab503          	ld	a0,344(s5)
    8000141c:	00002097          	auipc	ra,0x2
    80001420:	9ec080e7          	jalr	-1556(ra) # 80002e08 <idup>
    80001424:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001428:	4641                	li	a2,16
    8000142a:	160a8593          	addi	a1,s5,352
    8000142e:	160a0513          	addi	a0,s4,352
    80001432:	fffff097          	auipc	ra,0xfffff
    80001436:	f84080e7          	jalr	-124(ra) # 800003b6 <safestrcpy>
  pid = np->pid;
    8000143a:	038a2903          	lw	s2,56(s4)
  release(&np->lock);
    8000143e:	8552                	mv	a0,s4
    80001440:	00005097          	auipc	ra,0x5
    80001444:	522080e7          	jalr	1314(ra) # 80006962 <release>
  acquire(&wait_lock);
    80001448:	0000b497          	auipc	s1,0xb
    8000144c:	d4848493          	addi	s1,s1,-696 # 8000c190 <wait_lock>
    80001450:	8526                	mv	a0,s1
    80001452:	00005097          	auipc	ra,0x5
    80001456:	448080e7          	jalr	1096(ra) # 8000689a <acquire>
  np->parent = p;
    8000145a:	055a3023          	sd	s5,64(s4)
  release(&wait_lock);
    8000145e:	8526                	mv	a0,s1
    80001460:	00005097          	auipc	ra,0x5
    80001464:	502080e7          	jalr	1282(ra) # 80006962 <release>
  acquire(&np->lock);
    80001468:	8552                	mv	a0,s4
    8000146a:	00005097          	auipc	ra,0x5
    8000146e:	430080e7          	jalr	1072(ra) # 8000689a <acquire>
  np->state = RUNNABLE;
    80001472:	478d                	li	a5,3
    80001474:	02fa2023          	sw	a5,32(s4)
  release(&np->lock);
    80001478:	8552                	mv	a0,s4
    8000147a:	00005097          	auipc	ra,0x5
    8000147e:	4e8080e7          	jalr	1256(ra) # 80006962 <release>
  return pid;
    80001482:	74a2                	ld	s1,40(sp)
    80001484:	69e2                	ld	s3,24(sp)
    80001486:	6a42                	ld	s4,16(sp)
}
    80001488:	854a                	mv	a0,s2
    8000148a:	70e2                	ld	ra,56(sp)
    8000148c:	7442                	ld	s0,48(sp)
    8000148e:	7902                	ld	s2,32(sp)
    80001490:	6aa2                	ld	s5,8(sp)
    80001492:	6121                	addi	sp,sp,64
    80001494:	8082                	ret
    return -1;
    80001496:	597d                	li	s2,-1
    80001498:	bfc5                	j	80001488 <fork+0x130>

000000008000149a <scheduler>:
{
    8000149a:	7139                	addi	sp,sp,-64
    8000149c:	fc06                	sd	ra,56(sp)
    8000149e:	f822                	sd	s0,48(sp)
    800014a0:	f426                	sd	s1,40(sp)
    800014a2:	f04a                	sd	s2,32(sp)
    800014a4:	ec4e                	sd	s3,24(sp)
    800014a6:	e852                	sd	s4,16(sp)
    800014a8:	e456                	sd	s5,8(sp)
    800014aa:	e05a                	sd	s6,0(sp)
    800014ac:	0080                	addi	s0,sp,64
    800014ae:	8792                	mv	a5,tp
  int id = r_tp();
    800014b0:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014b2:	00779a93          	slli	s5,a5,0x7
    800014b6:	0000b717          	auipc	a4,0xb
    800014ba:	cba70713          	addi	a4,a4,-838 # 8000c170 <pid_lock>
    800014be:	9756                	add	a4,a4,s5
    800014c0:	04073023          	sd	zero,64(a4)
        swtch(&c->context, &p->context);
    800014c4:	0000b717          	auipc	a4,0xb
    800014c8:	cf470713          	addi	a4,a4,-780 # 8000c1b8 <cpus+0x8>
    800014cc:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800014ce:	498d                	li	s3,3
        p->state = RUNNING;
    800014d0:	4b11                	li	s6,4
        c->proc = p;
    800014d2:	079e                	slli	a5,a5,0x7
    800014d4:	0000ba17          	auipc	s4,0xb
    800014d8:	c9ca0a13          	addi	s4,s4,-868 # 8000c170 <pid_lock>
    800014dc:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800014de:	00011917          	auipc	s2,0x11
    800014e2:	cd290913          	addi	s2,s2,-814 # 800121b0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014e6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800014ea:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800014ee:	10079073          	csrw	sstatus,a5
    800014f2:	0000b497          	auipc	s1,0xb
    800014f6:	0be48493          	addi	s1,s1,190 # 8000c5b0 <proc>
    800014fa:	a811                	j	8000150e <scheduler+0x74>
      release(&p->lock);
    800014fc:	8526                	mv	a0,s1
    800014fe:	00005097          	auipc	ra,0x5
    80001502:	464080e7          	jalr	1124(ra) # 80006962 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001506:	17048493          	addi	s1,s1,368
    8000150a:	fd248ee3          	beq	s1,s2,800014e6 <scheduler+0x4c>
      acquire(&p->lock);
    8000150e:	8526                	mv	a0,s1
    80001510:	00005097          	auipc	ra,0x5
    80001514:	38a080e7          	jalr	906(ra) # 8000689a <acquire>
      if(p->state == RUNNABLE) {
    80001518:	509c                	lw	a5,32(s1)
    8000151a:	ff3791e3          	bne	a5,s3,800014fc <scheduler+0x62>
        p->state = RUNNING;
    8000151e:	0364a023          	sw	s6,32(s1)
        c->proc = p;
    80001522:	049a3023          	sd	s1,64(s4)
        swtch(&c->context, &p->context);
    80001526:	06848593          	addi	a1,s1,104
    8000152a:	8556                	mv	a0,s5
    8000152c:	00000097          	auipc	ra,0x0
    80001530:	620080e7          	jalr	1568(ra) # 80001b4c <swtch>
        c->proc = 0;
    80001534:	040a3023          	sd	zero,64(s4)
    80001538:	b7d1                	j	800014fc <scheduler+0x62>

000000008000153a <sched>:
{
    8000153a:	7179                	addi	sp,sp,-48
    8000153c:	f406                	sd	ra,40(sp)
    8000153e:	f022                	sd	s0,32(sp)
    80001540:	ec26                	sd	s1,24(sp)
    80001542:	e84a                	sd	s2,16(sp)
    80001544:	e44e                	sd	s3,8(sp)
    80001546:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001548:	00000097          	auipc	ra,0x0
    8000154c:	a3e080e7          	jalr	-1474(ra) # 80000f86 <myproc>
    80001550:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001552:	00005097          	auipc	ra,0x5
    80001556:	2ce080e7          	jalr	718(ra) # 80006820 <holding>
    8000155a:	c93d                	beqz	a0,800015d0 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000155c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000155e:	2781                	sext.w	a5,a5
    80001560:	079e                	slli	a5,a5,0x7
    80001562:	0000b717          	auipc	a4,0xb
    80001566:	c0e70713          	addi	a4,a4,-1010 # 8000c170 <pid_lock>
    8000156a:	97ba                	add	a5,a5,a4
    8000156c:	0b87a703          	lw	a4,184(a5)
    80001570:	4785                	li	a5,1
    80001572:	06f71763          	bne	a4,a5,800015e0 <sched+0xa6>
  if(p->state == RUNNING)
    80001576:	5098                	lw	a4,32(s1)
    80001578:	4791                	li	a5,4
    8000157a:	06f70b63          	beq	a4,a5,800015f0 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000157e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001582:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001584:	efb5                	bnez	a5,80001600 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001586:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001588:	0000b917          	auipc	s2,0xb
    8000158c:	be890913          	addi	s2,s2,-1048 # 8000c170 <pid_lock>
    80001590:	2781                	sext.w	a5,a5
    80001592:	079e                	slli	a5,a5,0x7
    80001594:	97ca                	add	a5,a5,s2
    80001596:	0bc7a983          	lw	s3,188(a5)
    8000159a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000159c:	2781                	sext.w	a5,a5
    8000159e:	079e                	slli	a5,a5,0x7
    800015a0:	0000b597          	auipc	a1,0xb
    800015a4:	c1858593          	addi	a1,a1,-1000 # 8000c1b8 <cpus+0x8>
    800015a8:	95be                	add	a1,a1,a5
    800015aa:	06848513          	addi	a0,s1,104
    800015ae:	00000097          	auipc	ra,0x0
    800015b2:	59e080e7          	jalr	1438(ra) # 80001b4c <swtch>
    800015b6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015b8:	2781                	sext.w	a5,a5
    800015ba:	079e                	slli	a5,a5,0x7
    800015bc:	993e                	add	s2,s2,a5
    800015be:	0b392e23          	sw	s3,188(s2)
}
    800015c2:	70a2                	ld	ra,40(sp)
    800015c4:	7402                	ld	s0,32(sp)
    800015c6:	64e2                	ld	s1,24(sp)
    800015c8:	6942                	ld	s2,16(sp)
    800015ca:	69a2                	ld	s3,8(sp)
    800015cc:	6145                	addi	sp,sp,48
    800015ce:	8082                	ret
    panic("sched p->lock");
    800015d0:	00007517          	auipc	a0,0x7
    800015d4:	bc850513          	addi	a0,a0,-1080 # 80008198 <etext+0x198>
    800015d8:	00005097          	auipc	ra,0x5
    800015dc:	d5e080e7          	jalr	-674(ra) # 80006336 <panic>
    panic("sched locks");
    800015e0:	00007517          	auipc	a0,0x7
    800015e4:	bc850513          	addi	a0,a0,-1080 # 800081a8 <etext+0x1a8>
    800015e8:	00005097          	auipc	ra,0x5
    800015ec:	d4e080e7          	jalr	-690(ra) # 80006336 <panic>
    panic("sched running");
    800015f0:	00007517          	auipc	a0,0x7
    800015f4:	bc850513          	addi	a0,a0,-1080 # 800081b8 <etext+0x1b8>
    800015f8:	00005097          	auipc	ra,0x5
    800015fc:	d3e080e7          	jalr	-706(ra) # 80006336 <panic>
    panic("sched interruptible");
    80001600:	00007517          	auipc	a0,0x7
    80001604:	bc850513          	addi	a0,a0,-1080 # 800081c8 <etext+0x1c8>
    80001608:	00005097          	auipc	ra,0x5
    8000160c:	d2e080e7          	jalr	-722(ra) # 80006336 <panic>

0000000080001610 <yield>:
{
    80001610:	1101                	addi	sp,sp,-32
    80001612:	ec06                	sd	ra,24(sp)
    80001614:	e822                	sd	s0,16(sp)
    80001616:	e426                	sd	s1,8(sp)
    80001618:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000161a:	00000097          	auipc	ra,0x0
    8000161e:	96c080e7          	jalr	-1684(ra) # 80000f86 <myproc>
    80001622:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001624:	00005097          	auipc	ra,0x5
    80001628:	276080e7          	jalr	630(ra) # 8000689a <acquire>
  p->state = RUNNABLE;
    8000162c:	478d                	li	a5,3
    8000162e:	d09c                	sw	a5,32(s1)
  sched();
    80001630:	00000097          	auipc	ra,0x0
    80001634:	f0a080e7          	jalr	-246(ra) # 8000153a <sched>
  release(&p->lock);
    80001638:	8526                	mv	a0,s1
    8000163a:	00005097          	auipc	ra,0x5
    8000163e:	328080e7          	jalr	808(ra) # 80006962 <release>
}
    80001642:	60e2                	ld	ra,24(sp)
    80001644:	6442                	ld	s0,16(sp)
    80001646:	64a2                	ld	s1,8(sp)
    80001648:	6105                	addi	sp,sp,32
    8000164a:	8082                	ret

000000008000164c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000164c:	7179                	addi	sp,sp,-48
    8000164e:	f406                	sd	ra,40(sp)
    80001650:	f022                	sd	s0,32(sp)
    80001652:	ec26                	sd	s1,24(sp)
    80001654:	e84a                	sd	s2,16(sp)
    80001656:	e44e                	sd	s3,8(sp)
    80001658:	1800                	addi	s0,sp,48
    8000165a:	89aa                	mv	s3,a0
    8000165c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000165e:	00000097          	auipc	ra,0x0
    80001662:	928080e7          	jalr	-1752(ra) # 80000f86 <myproc>
    80001666:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001668:	00005097          	auipc	ra,0x5
    8000166c:	232080e7          	jalr	562(ra) # 8000689a <acquire>
  release(lk);
    80001670:	854a                	mv	a0,s2
    80001672:	00005097          	auipc	ra,0x5
    80001676:	2f0080e7          	jalr	752(ra) # 80006962 <release>

  // Go to sleep.
  p->chan = chan;
    8000167a:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    8000167e:	4789                	li	a5,2
    80001680:	d09c                	sw	a5,32(s1)

  sched();
    80001682:	00000097          	auipc	ra,0x0
    80001686:	eb8080e7          	jalr	-328(ra) # 8000153a <sched>

  // Tidy up.
  p->chan = 0;
    8000168a:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000168e:	8526                	mv	a0,s1
    80001690:	00005097          	auipc	ra,0x5
    80001694:	2d2080e7          	jalr	722(ra) # 80006962 <release>
  acquire(lk);
    80001698:	854a                	mv	a0,s2
    8000169a:	00005097          	auipc	ra,0x5
    8000169e:	200080e7          	jalr	512(ra) # 8000689a <acquire>
}
    800016a2:	70a2                	ld	ra,40(sp)
    800016a4:	7402                	ld	s0,32(sp)
    800016a6:	64e2                	ld	s1,24(sp)
    800016a8:	6942                	ld	s2,16(sp)
    800016aa:	69a2                	ld	s3,8(sp)
    800016ac:	6145                	addi	sp,sp,48
    800016ae:	8082                	ret

00000000800016b0 <wait>:
{
    800016b0:	715d                	addi	sp,sp,-80
    800016b2:	e486                	sd	ra,72(sp)
    800016b4:	e0a2                	sd	s0,64(sp)
    800016b6:	fc26                	sd	s1,56(sp)
    800016b8:	f84a                	sd	s2,48(sp)
    800016ba:	f44e                	sd	s3,40(sp)
    800016bc:	f052                	sd	s4,32(sp)
    800016be:	ec56                	sd	s5,24(sp)
    800016c0:	e85a                	sd	s6,16(sp)
    800016c2:	e45e                	sd	s7,8(sp)
    800016c4:	e062                	sd	s8,0(sp)
    800016c6:	0880                	addi	s0,sp,80
    800016c8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800016ca:	00000097          	auipc	ra,0x0
    800016ce:	8bc080e7          	jalr	-1860(ra) # 80000f86 <myproc>
    800016d2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016d4:	0000b517          	auipc	a0,0xb
    800016d8:	abc50513          	addi	a0,a0,-1348 # 8000c190 <wait_lock>
    800016dc:	00005097          	auipc	ra,0x5
    800016e0:	1be080e7          	jalr	446(ra) # 8000689a <acquire>
    havekids = 0;
    800016e4:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800016e6:	4a15                	li	s4,5
        havekids = 1;
    800016e8:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800016ea:	00011997          	auipc	s3,0x11
    800016ee:	ac698993          	addi	s3,s3,-1338 # 800121b0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016f2:	0000bc17          	auipc	s8,0xb
    800016f6:	a9ec0c13          	addi	s8,s8,-1378 # 8000c190 <wait_lock>
    800016fa:	a87d                	j	800017b8 <wait+0x108>
          pid = np->pid;
    800016fc:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001700:	000b0e63          	beqz	s6,8000171c <wait+0x6c>
    80001704:	4691                	li	a3,4
    80001706:	03448613          	addi	a2,s1,52
    8000170a:	85da                	mv	a1,s6
    8000170c:	05893503          	ld	a0,88(s2)
    80001710:	fffff097          	auipc	ra,0xfffff
    80001714:	512080e7          	jalr	1298(ra) # 80000c22 <copyout>
    80001718:	04054163          	bltz	a0,8000175a <wait+0xaa>
          freeproc(np);
    8000171c:	8526                	mv	a0,s1
    8000171e:	00000097          	auipc	ra,0x0
    80001722:	a1a080e7          	jalr	-1510(ra) # 80001138 <freeproc>
          release(&np->lock);
    80001726:	8526                	mv	a0,s1
    80001728:	00005097          	auipc	ra,0x5
    8000172c:	23a080e7          	jalr	570(ra) # 80006962 <release>
          release(&wait_lock);
    80001730:	0000b517          	auipc	a0,0xb
    80001734:	a6050513          	addi	a0,a0,-1440 # 8000c190 <wait_lock>
    80001738:	00005097          	auipc	ra,0x5
    8000173c:	22a080e7          	jalr	554(ra) # 80006962 <release>
}
    80001740:	854e                	mv	a0,s3
    80001742:	60a6                	ld	ra,72(sp)
    80001744:	6406                	ld	s0,64(sp)
    80001746:	74e2                	ld	s1,56(sp)
    80001748:	7942                	ld	s2,48(sp)
    8000174a:	79a2                	ld	s3,40(sp)
    8000174c:	7a02                	ld	s4,32(sp)
    8000174e:	6ae2                	ld	s5,24(sp)
    80001750:	6b42                	ld	s6,16(sp)
    80001752:	6ba2                	ld	s7,8(sp)
    80001754:	6c02                	ld	s8,0(sp)
    80001756:	6161                	addi	sp,sp,80
    80001758:	8082                	ret
            release(&np->lock);
    8000175a:	8526                	mv	a0,s1
    8000175c:	00005097          	auipc	ra,0x5
    80001760:	206080e7          	jalr	518(ra) # 80006962 <release>
            release(&wait_lock);
    80001764:	0000b517          	auipc	a0,0xb
    80001768:	a2c50513          	addi	a0,a0,-1492 # 8000c190 <wait_lock>
    8000176c:	00005097          	auipc	ra,0x5
    80001770:	1f6080e7          	jalr	502(ra) # 80006962 <release>
            return -1;
    80001774:	59fd                	li	s3,-1
    80001776:	b7e9                	j	80001740 <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    80001778:	17048493          	addi	s1,s1,368
    8000177c:	03348463          	beq	s1,s3,800017a4 <wait+0xf4>
      if(np->parent == p){
    80001780:	60bc                	ld	a5,64(s1)
    80001782:	ff279be3          	bne	a5,s2,80001778 <wait+0xc8>
        acquire(&np->lock);
    80001786:	8526                	mv	a0,s1
    80001788:	00005097          	auipc	ra,0x5
    8000178c:	112080e7          	jalr	274(ra) # 8000689a <acquire>
        if(np->state == ZOMBIE){
    80001790:	509c                	lw	a5,32(s1)
    80001792:	f74785e3          	beq	a5,s4,800016fc <wait+0x4c>
        release(&np->lock);
    80001796:	8526                	mv	a0,s1
    80001798:	00005097          	auipc	ra,0x5
    8000179c:	1ca080e7          	jalr	458(ra) # 80006962 <release>
        havekids = 1;
    800017a0:	8756                	mv	a4,s5
    800017a2:	bfd9                	j	80001778 <wait+0xc8>
    if(!havekids || p->killed){
    800017a4:	c305                	beqz	a4,800017c4 <wait+0x114>
    800017a6:	03092783          	lw	a5,48(s2)
    800017aa:	ef89                	bnez	a5,800017c4 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017ac:	85e2                	mv	a1,s8
    800017ae:	854a                	mv	a0,s2
    800017b0:	00000097          	auipc	ra,0x0
    800017b4:	e9c080e7          	jalr	-356(ra) # 8000164c <sleep>
    havekids = 0;
    800017b8:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800017ba:	0000b497          	auipc	s1,0xb
    800017be:	df648493          	addi	s1,s1,-522 # 8000c5b0 <proc>
    800017c2:	bf7d                	j	80001780 <wait+0xd0>
      release(&wait_lock);
    800017c4:	0000b517          	auipc	a0,0xb
    800017c8:	9cc50513          	addi	a0,a0,-1588 # 8000c190 <wait_lock>
    800017cc:	00005097          	auipc	ra,0x5
    800017d0:	196080e7          	jalr	406(ra) # 80006962 <release>
      return -1;
    800017d4:	59fd                	li	s3,-1
    800017d6:	b7ad                	j	80001740 <wait+0x90>

00000000800017d8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800017d8:	7139                	addi	sp,sp,-64
    800017da:	fc06                	sd	ra,56(sp)
    800017dc:	f822                	sd	s0,48(sp)
    800017de:	f426                	sd	s1,40(sp)
    800017e0:	f04a                	sd	s2,32(sp)
    800017e2:	ec4e                	sd	s3,24(sp)
    800017e4:	e852                	sd	s4,16(sp)
    800017e6:	e456                	sd	s5,8(sp)
    800017e8:	0080                	addi	s0,sp,64
    800017ea:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800017ec:	0000b497          	auipc	s1,0xb
    800017f0:	dc448493          	addi	s1,s1,-572 # 8000c5b0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800017f4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800017f6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800017f8:	00011917          	auipc	s2,0x11
    800017fc:	9b890913          	addi	s2,s2,-1608 # 800121b0 <tickslock>
    80001800:	a811                	j	80001814 <wakeup+0x3c>
      }
      release(&p->lock);
    80001802:	8526                	mv	a0,s1
    80001804:	00005097          	auipc	ra,0x5
    80001808:	15e080e7          	jalr	350(ra) # 80006962 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000180c:	17048493          	addi	s1,s1,368
    80001810:	03248663          	beq	s1,s2,8000183c <wakeup+0x64>
    if(p != myproc()){
    80001814:	fffff097          	auipc	ra,0xfffff
    80001818:	772080e7          	jalr	1906(ra) # 80000f86 <myproc>
    8000181c:	fea488e3          	beq	s1,a0,8000180c <wakeup+0x34>
      acquire(&p->lock);
    80001820:	8526                	mv	a0,s1
    80001822:	00005097          	auipc	ra,0x5
    80001826:	078080e7          	jalr	120(ra) # 8000689a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000182a:	509c                	lw	a5,32(s1)
    8000182c:	fd379be3          	bne	a5,s3,80001802 <wakeup+0x2a>
    80001830:	749c                	ld	a5,40(s1)
    80001832:	fd4798e3          	bne	a5,s4,80001802 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001836:	0354a023          	sw	s5,32(s1)
    8000183a:	b7e1                	j	80001802 <wakeup+0x2a>
    }
  }
}
    8000183c:	70e2                	ld	ra,56(sp)
    8000183e:	7442                	ld	s0,48(sp)
    80001840:	74a2                	ld	s1,40(sp)
    80001842:	7902                	ld	s2,32(sp)
    80001844:	69e2                	ld	s3,24(sp)
    80001846:	6a42                	ld	s4,16(sp)
    80001848:	6aa2                	ld	s5,8(sp)
    8000184a:	6121                	addi	sp,sp,64
    8000184c:	8082                	ret

000000008000184e <reparent>:
{
    8000184e:	7179                	addi	sp,sp,-48
    80001850:	f406                	sd	ra,40(sp)
    80001852:	f022                	sd	s0,32(sp)
    80001854:	ec26                	sd	s1,24(sp)
    80001856:	e84a                	sd	s2,16(sp)
    80001858:	e44e                	sd	s3,8(sp)
    8000185a:	e052                	sd	s4,0(sp)
    8000185c:	1800                	addi	s0,sp,48
    8000185e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001860:	0000b497          	auipc	s1,0xb
    80001864:	d5048493          	addi	s1,s1,-688 # 8000c5b0 <proc>
      pp->parent = initproc;
    80001868:	0000aa17          	auipc	s4,0xa
    8000186c:	7a8a0a13          	addi	s4,s4,1960 # 8000c010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001870:	00011997          	auipc	s3,0x11
    80001874:	94098993          	addi	s3,s3,-1728 # 800121b0 <tickslock>
    80001878:	a029                	j	80001882 <reparent+0x34>
    8000187a:	17048493          	addi	s1,s1,368
    8000187e:	01348d63          	beq	s1,s3,80001898 <reparent+0x4a>
    if(pp->parent == p){
    80001882:	60bc                	ld	a5,64(s1)
    80001884:	ff279be3          	bne	a5,s2,8000187a <reparent+0x2c>
      pp->parent = initproc;
    80001888:	000a3503          	ld	a0,0(s4)
    8000188c:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    8000188e:	00000097          	auipc	ra,0x0
    80001892:	f4a080e7          	jalr	-182(ra) # 800017d8 <wakeup>
    80001896:	b7d5                	j	8000187a <reparent+0x2c>
}
    80001898:	70a2                	ld	ra,40(sp)
    8000189a:	7402                	ld	s0,32(sp)
    8000189c:	64e2                	ld	s1,24(sp)
    8000189e:	6942                	ld	s2,16(sp)
    800018a0:	69a2                	ld	s3,8(sp)
    800018a2:	6a02                	ld	s4,0(sp)
    800018a4:	6145                	addi	sp,sp,48
    800018a6:	8082                	ret

00000000800018a8 <exit>:
{
    800018a8:	7179                	addi	sp,sp,-48
    800018aa:	f406                	sd	ra,40(sp)
    800018ac:	f022                	sd	s0,32(sp)
    800018ae:	ec26                	sd	s1,24(sp)
    800018b0:	e84a                	sd	s2,16(sp)
    800018b2:	e44e                	sd	s3,8(sp)
    800018b4:	e052                	sd	s4,0(sp)
    800018b6:	1800                	addi	s0,sp,48
    800018b8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800018ba:	fffff097          	auipc	ra,0xfffff
    800018be:	6cc080e7          	jalr	1740(ra) # 80000f86 <myproc>
    800018c2:	89aa                	mv	s3,a0
  if(p == initproc)
    800018c4:	0000a797          	auipc	a5,0xa
    800018c8:	74c7b783          	ld	a5,1868(a5) # 8000c010 <initproc>
    800018cc:	0d850493          	addi	s1,a0,216
    800018d0:	15850913          	addi	s2,a0,344
    800018d4:	02a79363          	bne	a5,a0,800018fa <exit+0x52>
    panic("init exiting");
    800018d8:	00007517          	auipc	a0,0x7
    800018dc:	90850513          	addi	a0,a0,-1784 # 800081e0 <etext+0x1e0>
    800018e0:	00005097          	auipc	ra,0x5
    800018e4:	a56080e7          	jalr	-1450(ra) # 80006336 <panic>
      fileclose(f);
    800018e8:	00002097          	auipc	ra,0x2
    800018ec:	3fa080e7          	jalr	1018(ra) # 80003ce2 <fileclose>
      p->ofile[fd] = 0;
    800018f0:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800018f4:	04a1                	addi	s1,s1,8
    800018f6:	01248563          	beq	s1,s2,80001900 <exit+0x58>
    if(p->ofile[fd]){
    800018fa:	6088                	ld	a0,0(s1)
    800018fc:	f575                	bnez	a0,800018e8 <exit+0x40>
    800018fe:	bfdd                	j	800018f4 <exit+0x4c>
  begin_op();
    80001900:	00002097          	auipc	ra,0x2
    80001904:	f18080e7          	jalr	-232(ra) # 80003818 <begin_op>
  iput(p->cwd);
    80001908:	1589b503          	ld	a0,344(s3)
    8000190c:	00001097          	auipc	ra,0x1
    80001910:	6f8080e7          	jalr	1784(ra) # 80003004 <iput>
  end_op();
    80001914:	00002097          	auipc	ra,0x2
    80001918:	f7e080e7          	jalr	-130(ra) # 80003892 <end_op>
  p->cwd = 0;
    8000191c:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001920:	0000b497          	auipc	s1,0xb
    80001924:	87048493          	addi	s1,s1,-1936 # 8000c190 <wait_lock>
    80001928:	8526                	mv	a0,s1
    8000192a:	00005097          	auipc	ra,0x5
    8000192e:	f70080e7          	jalr	-144(ra) # 8000689a <acquire>
  reparent(p);
    80001932:	854e                	mv	a0,s3
    80001934:	00000097          	auipc	ra,0x0
    80001938:	f1a080e7          	jalr	-230(ra) # 8000184e <reparent>
  wakeup(p->parent);
    8000193c:	0409b503          	ld	a0,64(s3)
    80001940:	00000097          	auipc	ra,0x0
    80001944:	e98080e7          	jalr	-360(ra) # 800017d8 <wakeup>
  acquire(&p->lock);
    80001948:	854e                	mv	a0,s3
    8000194a:	00005097          	auipc	ra,0x5
    8000194e:	f50080e7          	jalr	-176(ra) # 8000689a <acquire>
  p->xstate = status;
    80001952:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80001956:	4795                	li	a5,5
    80001958:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    8000195c:	8526                	mv	a0,s1
    8000195e:	00005097          	auipc	ra,0x5
    80001962:	004080e7          	jalr	4(ra) # 80006962 <release>
  sched();
    80001966:	00000097          	auipc	ra,0x0
    8000196a:	bd4080e7          	jalr	-1068(ra) # 8000153a <sched>
  panic("zombie exit");
    8000196e:	00007517          	auipc	a0,0x7
    80001972:	88250513          	addi	a0,a0,-1918 # 800081f0 <etext+0x1f0>
    80001976:	00005097          	auipc	ra,0x5
    8000197a:	9c0080e7          	jalr	-1600(ra) # 80006336 <panic>

000000008000197e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000197e:	7179                	addi	sp,sp,-48
    80001980:	f406                	sd	ra,40(sp)
    80001982:	f022                	sd	s0,32(sp)
    80001984:	ec26                	sd	s1,24(sp)
    80001986:	e84a                	sd	s2,16(sp)
    80001988:	e44e                	sd	s3,8(sp)
    8000198a:	1800                	addi	s0,sp,48
    8000198c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000198e:	0000b497          	auipc	s1,0xb
    80001992:	c2248493          	addi	s1,s1,-990 # 8000c5b0 <proc>
    80001996:	00011997          	auipc	s3,0x11
    8000199a:	81a98993          	addi	s3,s3,-2022 # 800121b0 <tickslock>
    acquire(&p->lock);
    8000199e:	8526                	mv	a0,s1
    800019a0:	00005097          	auipc	ra,0x5
    800019a4:	efa080e7          	jalr	-262(ra) # 8000689a <acquire>
    if(p->pid == pid){
    800019a8:	5c9c                	lw	a5,56(s1)
    800019aa:	01278d63          	beq	a5,s2,800019c4 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800019ae:	8526                	mv	a0,s1
    800019b0:	00005097          	auipc	ra,0x5
    800019b4:	fb2080e7          	jalr	-78(ra) # 80006962 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800019b8:	17048493          	addi	s1,s1,368
    800019bc:	ff3491e3          	bne	s1,s3,8000199e <kill+0x20>
  }
  return -1;
    800019c0:	557d                	li	a0,-1
    800019c2:	a829                	j	800019dc <kill+0x5e>
      p->killed = 1;
    800019c4:	4785                	li	a5,1
    800019c6:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800019c8:	5098                	lw	a4,32(s1)
    800019ca:	4789                	li	a5,2
    800019cc:	00f70f63          	beq	a4,a5,800019ea <kill+0x6c>
      release(&p->lock);
    800019d0:	8526                	mv	a0,s1
    800019d2:	00005097          	auipc	ra,0x5
    800019d6:	f90080e7          	jalr	-112(ra) # 80006962 <release>
      return 0;
    800019da:	4501                	li	a0,0
}
    800019dc:	70a2                	ld	ra,40(sp)
    800019de:	7402                	ld	s0,32(sp)
    800019e0:	64e2                	ld	s1,24(sp)
    800019e2:	6942                	ld	s2,16(sp)
    800019e4:	69a2                	ld	s3,8(sp)
    800019e6:	6145                	addi	sp,sp,48
    800019e8:	8082                	ret
        p->state = RUNNABLE;
    800019ea:	478d                	li	a5,3
    800019ec:	d09c                	sw	a5,32(s1)
    800019ee:	b7cd                	j	800019d0 <kill+0x52>

00000000800019f0 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019f0:	7179                	addi	sp,sp,-48
    800019f2:	f406                	sd	ra,40(sp)
    800019f4:	f022                	sd	s0,32(sp)
    800019f6:	ec26                	sd	s1,24(sp)
    800019f8:	e84a                	sd	s2,16(sp)
    800019fa:	e44e                	sd	s3,8(sp)
    800019fc:	e052                	sd	s4,0(sp)
    800019fe:	1800                	addi	s0,sp,48
    80001a00:	84aa                	mv	s1,a0
    80001a02:	892e                	mv	s2,a1
    80001a04:	89b2                	mv	s3,a2
    80001a06:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a08:	fffff097          	auipc	ra,0xfffff
    80001a0c:	57e080e7          	jalr	1406(ra) # 80000f86 <myproc>
  if(user_dst){
    80001a10:	c08d                	beqz	s1,80001a32 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a12:	86d2                	mv	a3,s4
    80001a14:	864e                	mv	a2,s3
    80001a16:	85ca                	mv	a1,s2
    80001a18:	6d28                	ld	a0,88(a0)
    80001a1a:	fffff097          	auipc	ra,0xfffff
    80001a1e:	208080e7          	jalr	520(ra) # 80000c22 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a22:	70a2                	ld	ra,40(sp)
    80001a24:	7402                	ld	s0,32(sp)
    80001a26:	64e2                	ld	s1,24(sp)
    80001a28:	6942                	ld	s2,16(sp)
    80001a2a:	69a2                	ld	s3,8(sp)
    80001a2c:	6a02                	ld	s4,0(sp)
    80001a2e:	6145                	addi	sp,sp,48
    80001a30:	8082                	ret
    memmove((char *)dst, src, len);
    80001a32:	000a061b          	sext.w	a2,s4
    80001a36:	85ce                	mv	a1,s3
    80001a38:	854a                	mv	a0,s2
    80001a3a:	fffff097          	auipc	ra,0xfffff
    80001a3e:	896080e7          	jalr	-1898(ra) # 800002d0 <memmove>
    return 0;
    80001a42:	8526                	mv	a0,s1
    80001a44:	bff9                	j	80001a22 <either_copyout+0x32>

0000000080001a46 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a46:	7179                	addi	sp,sp,-48
    80001a48:	f406                	sd	ra,40(sp)
    80001a4a:	f022                	sd	s0,32(sp)
    80001a4c:	ec26                	sd	s1,24(sp)
    80001a4e:	e84a                	sd	s2,16(sp)
    80001a50:	e44e                	sd	s3,8(sp)
    80001a52:	e052                	sd	s4,0(sp)
    80001a54:	1800                	addi	s0,sp,48
    80001a56:	892a                	mv	s2,a0
    80001a58:	84ae                	mv	s1,a1
    80001a5a:	89b2                	mv	s3,a2
    80001a5c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a5e:	fffff097          	auipc	ra,0xfffff
    80001a62:	528080e7          	jalr	1320(ra) # 80000f86 <myproc>
  if(user_src){
    80001a66:	c08d                	beqz	s1,80001a88 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a68:	86d2                	mv	a3,s4
    80001a6a:	864e                	mv	a2,s3
    80001a6c:	85ca                	mv	a1,s2
    80001a6e:	6d28                	ld	a0,88(a0)
    80001a70:	fffff097          	auipc	ra,0xfffff
    80001a74:	23e080e7          	jalr	574(ra) # 80000cae <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a78:	70a2                	ld	ra,40(sp)
    80001a7a:	7402                	ld	s0,32(sp)
    80001a7c:	64e2                	ld	s1,24(sp)
    80001a7e:	6942                	ld	s2,16(sp)
    80001a80:	69a2                	ld	s3,8(sp)
    80001a82:	6a02                	ld	s4,0(sp)
    80001a84:	6145                	addi	sp,sp,48
    80001a86:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a88:	000a061b          	sext.w	a2,s4
    80001a8c:	85ce                	mv	a1,s3
    80001a8e:	854a                	mv	a0,s2
    80001a90:	fffff097          	auipc	ra,0xfffff
    80001a94:	840080e7          	jalr	-1984(ra) # 800002d0 <memmove>
    return 0;
    80001a98:	8526                	mv	a0,s1
    80001a9a:	bff9                	j	80001a78 <either_copyin+0x32>

0000000080001a9c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a9c:	715d                	addi	sp,sp,-80
    80001a9e:	e486                	sd	ra,72(sp)
    80001aa0:	e0a2                	sd	s0,64(sp)
    80001aa2:	fc26                	sd	s1,56(sp)
    80001aa4:	f84a                	sd	s2,48(sp)
    80001aa6:	f44e                	sd	s3,40(sp)
    80001aa8:	f052                	sd	s4,32(sp)
    80001aaa:	ec56                	sd	s5,24(sp)
    80001aac:	e85a                	sd	s6,16(sp)
    80001aae:	e45e                	sd	s7,8(sp)
    80001ab0:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001ab2:	00006517          	auipc	a0,0x6
    80001ab6:	56650513          	addi	a0,a0,1382 # 80008018 <etext+0x18>
    80001aba:	00005097          	auipc	ra,0x5
    80001abe:	8c6080e7          	jalr	-1850(ra) # 80006380 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ac2:	0000b497          	auipc	s1,0xb
    80001ac6:	c4e48493          	addi	s1,s1,-946 # 8000c710 <proc+0x160>
    80001aca:	00011917          	auipc	s2,0x11
    80001ace:	84690913          	addi	s2,s2,-1978 # 80012310 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ad2:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001ad4:	00006997          	auipc	s3,0x6
    80001ad8:	72c98993          	addi	s3,s3,1836 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001adc:	00006a97          	auipc	s5,0x6
    80001ae0:	72ca8a93          	addi	s5,s5,1836 # 80008208 <etext+0x208>
    printf("\n");
    80001ae4:	00006a17          	auipc	s4,0x6
    80001ae8:	534a0a13          	addi	s4,s4,1332 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aec:	00007b97          	auipc	s7,0x7
    80001af0:	cccb8b93          	addi	s7,s7,-820 # 800087b8 <states.0>
    80001af4:	a00d                	j	80001b16 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001af6:	ed86a583          	lw	a1,-296(a3)
    80001afa:	8556                	mv	a0,s5
    80001afc:	00005097          	auipc	ra,0x5
    80001b00:	884080e7          	jalr	-1916(ra) # 80006380 <printf>
    printf("\n");
    80001b04:	8552                	mv	a0,s4
    80001b06:	00005097          	auipc	ra,0x5
    80001b0a:	87a080e7          	jalr	-1926(ra) # 80006380 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b0e:	17048493          	addi	s1,s1,368
    80001b12:	03248263          	beq	s1,s2,80001b36 <procdump+0x9a>
    if(p->state == UNUSED)
    80001b16:	86a6                	mv	a3,s1
    80001b18:	ec04a783          	lw	a5,-320(s1)
    80001b1c:	dbed                	beqz	a5,80001b0e <procdump+0x72>
      state = "???";
    80001b1e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b20:	fcfb6be3          	bltu	s6,a5,80001af6 <procdump+0x5a>
    80001b24:	02079713          	slli	a4,a5,0x20
    80001b28:	01d75793          	srli	a5,a4,0x1d
    80001b2c:	97de                	add	a5,a5,s7
    80001b2e:	6390                	ld	a2,0(a5)
    80001b30:	f279                	bnez	a2,80001af6 <procdump+0x5a>
      state = "???";
    80001b32:	864e                	mv	a2,s3
    80001b34:	b7c9                	j	80001af6 <procdump+0x5a>
  }
}
    80001b36:	60a6                	ld	ra,72(sp)
    80001b38:	6406                	ld	s0,64(sp)
    80001b3a:	74e2                	ld	s1,56(sp)
    80001b3c:	7942                	ld	s2,48(sp)
    80001b3e:	79a2                	ld	s3,40(sp)
    80001b40:	7a02                	ld	s4,32(sp)
    80001b42:	6ae2                	ld	s5,24(sp)
    80001b44:	6b42                	ld	s6,16(sp)
    80001b46:	6ba2                	ld	s7,8(sp)
    80001b48:	6161                	addi	sp,sp,80
    80001b4a:	8082                	ret

0000000080001b4c <swtch>:
    80001b4c:	00153023          	sd	ra,0(a0)
    80001b50:	00253423          	sd	sp,8(a0)
    80001b54:	e900                	sd	s0,16(a0)
    80001b56:	ed04                	sd	s1,24(a0)
    80001b58:	03253023          	sd	s2,32(a0)
    80001b5c:	03353423          	sd	s3,40(a0)
    80001b60:	03453823          	sd	s4,48(a0)
    80001b64:	03553c23          	sd	s5,56(a0)
    80001b68:	05653023          	sd	s6,64(a0)
    80001b6c:	05753423          	sd	s7,72(a0)
    80001b70:	05853823          	sd	s8,80(a0)
    80001b74:	05953c23          	sd	s9,88(a0)
    80001b78:	07a53023          	sd	s10,96(a0)
    80001b7c:	07b53423          	sd	s11,104(a0)
    80001b80:	0005b083          	ld	ra,0(a1)
    80001b84:	0085b103          	ld	sp,8(a1)
    80001b88:	6980                	ld	s0,16(a1)
    80001b8a:	6d84                	ld	s1,24(a1)
    80001b8c:	0205b903          	ld	s2,32(a1)
    80001b90:	0285b983          	ld	s3,40(a1)
    80001b94:	0305ba03          	ld	s4,48(a1)
    80001b98:	0385ba83          	ld	s5,56(a1)
    80001b9c:	0405bb03          	ld	s6,64(a1)
    80001ba0:	0485bb83          	ld	s7,72(a1)
    80001ba4:	0505bc03          	ld	s8,80(a1)
    80001ba8:	0585bc83          	ld	s9,88(a1)
    80001bac:	0605bd03          	ld	s10,96(a1)
    80001bb0:	0685bd83          	ld	s11,104(a1)
    80001bb4:	8082                	ret

0000000080001bb6 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001bb6:	1141                	addi	sp,sp,-16
    80001bb8:	e406                	sd	ra,8(sp)
    80001bba:	e022                	sd	s0,0(sp)
    80001bbc:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001bbe:	00006597          	auipc	a1,0x6
    80001bc2:	68258593          	addi	a1,a1,1666 # 80008240 <etext+0x240>
    80001bc6:	00010517          	auipc	a0,0x10
    80001bca:	5ea50513          	addi	a0,a0,1514 # 800121b0 <tickslock>
    80001bce:	00005097          	auipc	ra,0x5
    80001bd2:	e40080e7          	jalr	-448(ra) # 80006a0e <initlock>
}
    80001bd6:	60a2                	ld	ra,8(sp)
    80001bd8:	6402                	ld	s0,0(sp)
    80001bda:	0141                	addi	sp,sp,16
    80001bdc:	8082                	ret

0000000080001bde <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001bde:	1141                	addi	sp,sp,-16
    80001be0:	e422                	sd	s0,8(sp)
    80001be2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001be4:	00003797          	auipc	a5,0x3
    80001be8:	7ec78793          	addi	a5,a5,2028 # 800053d0 <kernelvec>
    80001bec:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001bf0:	6422                	ld	s0,8(sp)
    80001bf2:	0141                	addi	sp,sp,16
    80001bf4:	8082                	ret

0000000080001bf6 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001bf6:	1141                	addi	sp,sp,-16
    80001bf8:	e406                	sd	ra,8(sp)
    80001bfa:	e022                	sd	s0,0(sp)
    80001bfc:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bfe:	fffff097          	auipc	ra,0xfffff
    80001c02:	388080e7          	jalr	904(ra) # 80000f86 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c06:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c0a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c0c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c10:	00005697          	auipc	a3,0x5
    80001c14:	3f068693          	addi	a3,a3,1008 # 80007000 <_trampoline>
    80001c18:	00005717          	auipc	a4,0x5
    80001c1c:	3e870713          	addi	a4,a4,1000 # 80007000 <_trampoline>
    80001c20:	8f15                	sub	a4,a4,a3
    80001c22:	040007b7          	lui	a5,0x4000
    80001c26:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c28:	07b2                	slli	a5,a5,0xc
    80001c2a:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c2c:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c30:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c32:	18002673          	csrr	a2,satp
    80001c36:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c38:	7130                	ld	a2,96(a0)
    80001c3a:	6538                	ld	a4,72(a0)
    80001c3c:	6585                	lui	a1,0x1
    80001c3e:	972e                	add	a4,a4,a1
    80001c40:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c42:	7138                	ld	a4,96(a0)
    80001c44:	00000617          	auipc	a2,0x0
    80001c48:	14060613          	addi	a2,a2,320 # 80001d84 <usertrap>
    80001c4c:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c4e:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c50:	8612                	mv	a2,tp
    80001c52:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c54:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c58:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c5c:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c60:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c64:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c66:	6f18                	ld	a4,24(a4)
    80001c68:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c6c:	6d2c                	ld	a1,88(a0)
    80001c6e:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001c70:	00005717          	auipc	a4,0x5
    80001c74:	42070713          	addi	a4,a4,1056 # 80007090 <userret>
    80001c78:	8f15                	sub	a4,a4,a3
    80001c7a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001c7c:	577d                	li	a4,-1
    80001c7e:	177e                	slli	a4,a4,0x3f
    80001c80:	8dd9                	or	a1,a1,a4
    80001c82:	02000537          	lui	a0,0x2000
    80001c86:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001c88:	0536                	slli	a0,a0,0xd
    80001c8a:	9782                	jalr	a5
}
    80001c8c:	60a2                	ld	ra,8(sp)
    80001c8e:	6402                	ld	s0,0(sp)
    80001c90:	0141                	addi	sp,sp,16
    80001c92:	8082                	ret

0000000080001c94 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c94:	1101                	addi	sp,sp,-32
    80001c96:	ec06                	sd	ra,24(sp)
    80001c98:	e822                	sd	s0,16(sp)
    80001c9a:	e426                	sd	s1,8(sp)
    80001c9c:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c9e:	00010497          	auipc	s1,0x10
    80001ca2:	51248493          	addi	s1,s1,1298 # 800121b0 <tickslock>
    80001ca6:	8526                	mv	a0,s1
    80001ca8:	00005097          	auipc	ra,0x5
    80001cac:	bf2080e7          	jalr	-1038(ra) # 8000689a <acquire>
  ticks++;
    80001cb0:	0000a517          	auipc	a0,0xa
    80001cb4:	36850513          	addi	a0,a0,872 # 8000c018 <ticks>
    80001cb8:	411c                	lw	a5,0(a0)
    80001cba:	2785                	addiw	a5,a5,1
    80001cbc:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001cbe:	00000097          	auipc	ra,0x0
    80001cc2:	b1a080e7          	jalr	-1254(ra) # 800017d8 <wakeup>
  release(&tickslock);
    80001cc6:	8526                	mv	a0,s1
    80001cc8:	00005097          	auipc	ra,0x5
    80001ccc:	c9a080e7          	jalr	-870(ra) # 80006962 <release>
}
    80001cd0:	60e2                	ld	ra,24(sp)
    80001cd2:	6442                	ld	s0,16(sp)
    80001cd4:	64a2                	ld	s1,8(sp)
    80001cd6:	6105                	addi	sp,sp,32
    80001cd8:	8082                	ret

0000000080001cda <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cda:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001cde:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001ce0:	0a07d163          	bgez	a5,80001d82 <devintr+0xa8>
{
    80001ce4:	1101                	addi	sp,sp,-32
    80001ce6:	ec06                	sd	ra,24(sp)
    80001ce8:	e822                	sd	s0,16(sp)
    80001cea:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001cec:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001cf0:	46a5                	li	a3,9
    80001cf2:	00d70c63          	beq	a4,a3,80001d0a <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001cf6:	577d                	li	a4,-1
    80001cf8:	177e                	slli	a4,a4,0x3f
    80001cfa:	0705                	addi	a4,a4,1
    return 0;
    80001cfc:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001cfe:	06e78163          	beq	a5,a4,80001d60 <devintr+0x86>
  }
}
    80001d02:	60e2                	ld	ra,24(sp)
    80001d04:	6442                	ld	s0,16(sp)
    80001d06:	6105                	addi	sp,sp,32
    80001d08:	8082                	ret
    80001d0a:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001d0c:	00003097          	auipc	ra,0x3
    80001d10:	7d0080e7          	jalr	2000(ra) # 800054dc <plic_claim>
    80001d14:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d16:	47a9                	li	a5,10
    80001d18:	00f50963          	beq	a0,a5,80001d2a <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001d1c:	4785                	li	a5,1
    80001d1e:	00f50b63          	beq	a0,a5,80001d34 <devintr+0x5a>
    return 1;
    80001d22:	4505                	li	a0,1
    } else if(irq){
    80001d24:	ec89                	bnez	s1,80001d3e <devintr+0x64>
    80001d26:	64a2                	ld	s1,8(sp)
    80001d28:	bfe9                	j	80001d02 <devintr+0x28>
      uartintr();
    80001d2a:	00005097          	auipc	ra,0x5
    80001d2e:	aa6080e7          	jalr	-1370(ra) # 800067d0 <uartintr>
    if(irq)
    80001d32:	a839                	j	80001d50 <devintr+0x76>
      virtio_disk_intr();
    80001d34:	00004097          	auipc	ra,0x4
    80001d38:	c7c080e7          	jalr	-900(ra) # 800059b0 <virtio_disk_intr>
    if(irq)
    80001d3c:	a811                	j	80001d50 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d3e:	85a6                	mv	a1,s1
    80001d40:	00006517          	auipc	a0,0x6
    80001d44:	50850513          	addi	a0,a0,1288 # 80008248 <etext+0x248>
    80001d48:	00004097          	auipc	ra,0x4
    80001d4c:	638080e7          	jalr	1592(ra) # 80006380 <printf>
      plic_complete(irq);
    80001d50:	8526                	mv	a0,s1
    80001d52:	00003097          	auipc	ra,0x3
    80001d56:	7ae080e7          	jalr	1966(ra) # 80005500 <plic_complete>
    return 1;
    80001d5a:	4505                	li	a0,1
    80001d5c:	64a2                	ld	s1,8(sp)
    80001d5e:	b755                	j	80001d02 <devintr+0x28>
    if(cpuid() == 0){
    80001d60:	fffff097          	auipc	ra,0xfffff
    80001d64:	1fa080e7          	jalr	506(ra) # 80000f5a <cpuid>
    80001d68:	c901                	beqz	a0,80001d78 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d6a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d6e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d70:	14479073          	csrw	sip,a5
    return 2;
    80001d74:	4509                	li	a0,2
    80001d76:	b771                	j	80001d02 <devintr+0x28>
      clockintr();
    80001d78:	00000097          	auipc	ra,0x0
    80001d7c:	f1c080e7          	jalr	-228(ra) # 80001c94 <clockintr>
    80001d80:	b7ed                	j	80001d6a <devintr+0x90>
}
    80001d82:	8082                	ret

0000000080001d84 <usertrap>:
{
    80001d84:	1101                	addi	sp,sp,-32
    80001d86:	ec06                	sd	ra,24(sp)
    80001d88:	e822                	sd	s0,16(sp)
    80001d8a:	e426                	sd	s1,8(sp)
    80001d8c:	e04a                	sd	s2,0(sp)
    80001d8e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d90:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d94:	1007f793          	andi	a5,a5,256
    80001d98:	e3ad                	bnez	a5,80001dfa <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d9a:	00003797          	auipc	a5,0x3
    80001d9e:	63678793          	addi	a5,a5,1590 # 800053d0 <kernelvec>
    80001da2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001da6:	fffff097          	auipc	ra,0xfffff
    80001daa:	1e0080e7          	jalr	480(ra) # 80000f86 <myproc>
    80001dae:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001db0:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001db2:	14102773          	csrr	a4,sepc
    80001db6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001db8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001dbc:	47a1                	li	a5,8
    80001dbe:	04f71c63          	bne	a4,a5,80001e16 <usertrap+0x92>
    if(p->killed)
    80001dc2:	591c                	lw	a5,48(a0)
    80001dc4:	e3b9                	bnez	a5,80001e0a <usertrap+0x86>
    p->trapframe->epc += 4;
    80001dc6:	70b8                	ld	a4,96(s1)
    80001dc8:	6f1c                	ld	a5,24(a4)
    80001dca:	0791                	addi	a5,a5,4
    80001dcc:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dce:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001dd2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dd6:	10079073          	csrw	sstatus,a5
    syscall();
    80001dda:	00000097          	auipc	ra,0x0
    80001dde:	2e0080e7          	jalr	736(ra) # 800020ba <syscall>
  if(p->killed)
    80001de2:	589c                	lw	a5,48(s1)
    80001de4:	ebc1                	bnez	a5,80001e74 <usertrap+0xf0>
  usertrapret();
    80001de6:	00000097          	auipc	ra,0x0
    80001dea:	e10080e7          	jalr	-496(ra) # 80001bf6 <usertrapret>
}
    80001dee:	60e2                	ld	ra,24(sp)
    80001df0:	6442                	ld	s0,16(sp)
    80001df2:	64a2                	ld	s1,8(sp)
    80001df4:	6902                	ld	s2,0(sp)
    80001df6:	6105                	addi	sp,sp,32
    80001df8:	8082                	ret
    panic("usertrap: not from user mode");
    80001dfa:	00006517          	auipc	a0,0x6
    80001dfe:	46e50513          	addi	a0,a0,1134 # 80008268 <etext+0x268>
    80001e02:	00004097          	auipc	ra,0x4
    80001e06:	534080e7          	jalr	1332(ra) # 80006336 <panic>
      exit(-1);
    80001e0a:	557d                	li	a0,-1
    80001e0c:	00000097          	auipc	ra,0x0
    80001e10:	a9c080e7          	jalr	-1380(ra) # 800018a8 <exit>
    80001e14:	bf4d                	j	80001dc6 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001e16:	00000097          	auipc	ra,0x0
    80001e1a:	ec4080e7          	jalr	-316(ra) # 80001cda <devintr>
    80001e1e:	892a                	mv	s2,a0
    80001e20:	c501                	beqz	a0,80001e28 <usertrap+0xa4>
  if(p->killed)
    80001e22:	589c                	lw	a5,48(s1)
    80001e24:	c3a1                	beqz	a5,80001e64 <usertrap+0xe0>
    80001e26:	a815                	j	80001e5a <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e28:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e2c:	5c90                	lw	a2,56(s1)
    80001e2e:	00006517          	auipc	a0,0x6
    80001e32:	45a50513          	addi	a0,a0,1114 # 80008288 <etext+0x288>
    80001e36:	00004097          	auipc	ra,0x4
    80001e3a:	54a080e7          	jalr	1354(ra) # 80006380 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e3e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e42:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e46:	00006517          	auipc	a0,0x6
    80001e4a:	47250513          	addi	a0,a0,1138 # 800082b8 <etext+0x2b8>
    80001e4e:	00004097          	auipc	ra,0x4
    80001e52:	532080e7          	jalr	1330(ra) # 80006380 <printf>
    p->killed = 1;
    80001e56:	4785                	li	a5,1
    80001e58:	d89c                	sw	a5,48(s1)
    exit(-1);
    80001e5a:	557d                	li	a0,-1
    80001e5c:	00000097          	auipc	ra,0x0
    80001e60:	a4c080e7          	jalr	-1460(ra) # 800018a8 <exit>
  if(which_dev == 2)
    80001e64:	4789                	li	a5,2
    80001e66:	f8f910e3          	bne	s2,a5,80001de6 <usertrap+0x62>
    yield();
    80001e6a:	fffff097          	auipc	ra,0xfffff
    80001e6e:	7a6080e7          	jalr	1958(ra) # 80001610 <yield>
    80001e72:	bf95                	j	80001de6 <usertrap+0x62>
  int which_dev = 0;
    80001e74:	4901                	li	s2,0
    80001e76:	b7d5                	j	80001e5a <usertrap+0xd6>

0000000080001e78 <kerneltrap>:
{
    80001e78:	7179                	addi	sp,sp,-48
    80001e7a:	f406                	sd	ra,40(sp)
    80001e7c:	f022                	sd	s0,32(sp)
    80001e7e:	ec26                	sd	s1,24(sp)
    80001e80:	e84a                	sd	s2,16(sp)
    80001e82:	e44e                	sd	s3,8(sp)
    80001e84:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e86:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e8a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e8e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e92:	1004f793          	andi	a5,s1,256
    80001e96:	cb85                	beqz	a5,80001ec6 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e98:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e9c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e9e:	ef85                	bnez	a5,80001ed6 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001ea0:	00000097          	auipc	ra,0x0
    80001ea4:	e3a080e7          	jalr	-454(ra) # 80001cda <devintr>
    80001ea8:	cd1d                	beqz	a0,80001ee6 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001eaa:	4789                	li	a5,2
    80001eac:	06f50a63          	beq	a0,a5,80001f20 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001eb0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eb4:	10049073          	csrw	sstatus,s1
}
    80001eb8:	70a2                	ld	ra,40(sp)
    80001eba:	7402                	ld	s0,32(sp)
    80001ebc:	64e2                	ld	s1,24(sp)
    80001ebe:	6942                	ld	s2,16(sp)
    80001ec0:	69a2                	ld	s3,8(sp)
    80001ec2:	6145                	addi	sp,sp,48
    80001ec4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ec6:	00006517          	auipc	a0,0x6
    80001eca:	41250513          	addi	a0,a0,1042 # 800082d8 <etext+0x2d8>
    80001ece:	00004097          	auipc	ra,0x4
    80001ed2:	468080e7          	jalr	1128(ra) # 80006336 <panic>
    panic("kerneltrap: interrupts enabled");
    80001ed6:	00006517          	auipc	a0,0x6
    80001eda:	42a50513          	addi	a0,a0,1066 # 80008300 <etext+0x300>
    80001ede:	00004097          	auipc	ra,0x4
    80001ee2:	458080e7          	jalr	1112(ra) # 80006336 <panic>
    printf("scause %p\n", scause);
    80001ee6:	85ce                	mv	a1,s3
    80001ee8:	00006517          	auipc	a0,0x6
    80001eec:	43850513          	addi	a0,a0,1080 # 80008320 <etext+0x320>
    80001ef0:	00004097          	auipc	ra,0x4
    80001ef4:	490080e7          	jalr	1168(ra) # 80006380 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ef8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001efc:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f00:	00006517          	auipc	a0,0x6
    80001f04:	43050513          	addi	a0,a0,1072 # 80008330 <etext+0x330>
    80001f08:	00004097          	auipc	ra,0x4
    80001f0c:	478080e7          	jalr	1144(ra) # 80006380 <printf>
    panic("kerneltrap");
    80001f10:	00006517          	auipc	a0,0x6
    80001f14:	43850513          	addi	a0,a0,1080 # 80008348 <etext+0x348>
    80001f18:	00004097          	auipc	ra,0x4
    80001f1c:	41e080e7          	jalr	1054(ra) # 80006336 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f20:	fffff097          	auipc	ra,0xfffff
    80001f24:	066080e7          	jalr	102(ra) # 80000f86 <myproc>
    80001f28:	d541                	beqz	a0,80001eb0 <kerneltrap+0x38>
    80001f2a:	fffff097          	auipc	ra,0xfffff
    80001f2e:	05c080e7          	jalr	92(ra) # 80000f86 <myproc>
    80001f32:	5118                	lw	a4,32(a0)
    80001f34:	4791                	li	a5,4
    80001f36:	f6f71de3          	bne	a4,a5,80001eb0 <kerneltrap+0x38>
    yield();
    80001f3a:	fffff097          	auipc	ra,0xfffff
    80001f3e:	6d6080e7          	jalr	1750(ra) # 80001610 <yield>
    80001f42:	b7bd                	j	80001eb0 <kerneltrap+0x38>

0000000080001f44 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f44:	1101                	addi	sp,sp,-32
    80001f46:	ec06                	sd	ra,24(sp)
    80001f48:	e822                	sd	s0,16(sp)
    80001f4a:	e426                	sd	s1,8(sp)
    80001f4c:	1000                	addi	s0,sp,32
    80001f4e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f50:	fffff097          	auipc	ra,0xfffff
    80001f54:	036080e7          	jalr	54(ra) # 80000f86 <myproc>
  switch (n) {
    80001f58:	4795                	li	a5,5
    80001f5a:	0497e163          	bltu	a5,s1,80001f9c <argraw+0x58>
    80001f5e:	048a                	slli	s1,s1,0x2
    80001f60:	00007717          	auipc	a4,0x7
    80001f64:	88870713          	addi	a4,a4,-1912 # 800087e8 <states.0+0x30>
    80001f68:	94ba                	add	s1,s1,a4
    80001f6a:	409c                	lw	a5,0(s1)
    80001f6c:	97ba                	add	a5,a5,a4
    80001f6e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f70:	713c                	ld	a5,96(a0)
    80001f72:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f74:	60e2                	ld	ra,24(sp)
    80001f76:	6442                	ld	s0,16(sp)
    80001f78:	64a2                	ld	s1,8(sp)
    80001f7a:	6105                	addi	sp,sp,32
    80001f7c:	8082                	ret
    return p->trapframe->a1;
    80001f7e:	713c                	ld	a5,96(a0)
    80001f80:	7fa8                	ld	a0,120(a5)
    80001f82:	bfcd                	j	80001f74 <argraw+0x30>
    return p->trapframe->a2;
    80001f84:	713c                	ld	a5,96(a0)
    80001f86:	63c8                	ld	a0,128(a5)
    80001f88:	b7f5                	j	80001f74 <argraw+0x30>
    return p->trapframe->a3;
    80001f8a:	713c                	ld	a5,96(a0)
    80001f8c:	67c8                	ld	a0,136(a5)
    80001f8e:	b7dd                	j	80001f74 <argraw+0x30>
    return p->trapframe->a4;
    80001f90:	713c                	ld	a5,96(a0)
    80001f92:	6bc8                	ld	a0,144(a5)
    80001f94:	b7c5                	j	80001f74 <argraw+0x30>
    return p->trapframe->a5;
    80001f96:	713c                	ld	a5,96(a0)
    80001f98:	6fc8                	ld	a0,152(a5)
    80001f9a:	bfe9                	j	80001f74 <argraw+0x30>
  panic("argraw");
    80001f9c:	00006517          	auipc	a0,0x6
    80001fa0:	3bc50513          	addi	a0,a0,956 # 80008358 <etext+0x358>
    80001fa4:	00004097          	auipc	ra,0x4
    80001fa8:	392080e7          	jalr	914(ra) # 80006336 <panic>

0000000080001fac <fetchaddr>:
{
    80001fac:	1101                	addi	sp,sp,-32
    80001fae:	ec06                	sd	ra,24(sp)
    80001fb0:	e822                	sd	s0,16(sp)
    80001fb2:	e426                	sd	s1,8(sp)
    80001fb4:	e04a                	sd	s2,0(sp)
    80001fb6:	1000                	addi	s0,sp,32
    80001fb8:	84aa                	mv	s1,a0
    80001fba:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001fbc:	fffff097          	auipc	ra,0xfffff
    80001fc0:	fca080e7          	jalr	-54(ra) # 80000f86 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001fc4:	693c                	ld	a5,80(a0)
    80001fc6:	02f4f863          	bgeu	s1,a5,80001ff6 <fetchaddr+0x4a>
    80001fca:	00848713          	addi	a4,s1,8
    80001fce:	02e7e663          	bltu	a5,a4,80001ffa <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001fd2:	46a1                	li	a3,8
    80001fd4:	8626                	mv	a2,s1
    80001fd6:	85ca                	mv	a1,s2
    80001fd8:	6d28                	ld	a0,88(a0)
    80001fda:	fffff097          	auipc	ra,0xfffff
    80001fde:	cd4080e7          	jalr	-812(ra) # 80000cae <copyin>
    80001fe2:	00a03533          	snez	a0,a0
    80001fe6:	40a00533          	neg	a0,a0
}
    80001fea:	60e2                	ld	ra,24(sp)
    80001fec:	6442                	ld	s0,16(sp)
    80001fee:	64a2                	ld	s1,8(sp)
    80001ff0:	6902                	ld	s2,0(sp)
    80001ff2:	6105                	addi	sp,sp,32
    80001ff4:	8082                	ret
    return -1;
    80001ff6:	557d                	li	a0,-1
    80001ff8:	bfcd                	j	80001fea <fetchaddr+0x3e>
    80001ffa:	557d                	li	a0,-1
    80001ffc:	b7fd                	j	80001fea <fetchaddr+0x3e>

0000000080001ffe <fetchstr>:
{
    80001ffe:	7179                	addi	sp,sp,-48
    80002000:	f406                	sd	ra,40(sp)
    80002002:	f022                	sd	s0,32(sp)
    80002004:	ec26                	sd	s1,24(sp)
    80002006:	e84a                	sd	s2,16(sp)
    80002008:	e44e                	sd	s3,8(sp)
    8000200a:	1800                	addi	s0,sp,48
    8000200c:	892a                	mv	s2,a0
    8000200e:	84ae                	mv	s1,a1
    80002010:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002012:	fffff097          	auipc	ra,0xfffff
    80002016:	f74080e7          	jalr	-140(ra) # 80000f86 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000201a:	86ce                	mv	a3,s3
    8000201c:	864a                	mv	a2,s2
    8000201e:	85a6                	mv	a1,s1
    80002020:	6d28                	ld	a0,88(a0)
    80002022:	fffff097          	auipc	ra,0xfffff
    80002026:	d1a080e7          	jalr	-742(ra) # 80000d3c <copyinstr>
  if(err < 0)
    8000202a:	00054763          	bltz	a0,80002038 <fetchstr+0x3a>
  return strlen(buf);
    8000202e:	8526                	mv	a0,s1
    80002030:	ffffe097          	auipc	ra,0xffffe
    80002034:	3b8080e7          	jalr	952(ra) # 800003e8 <strlen>
}
    80002038:	70a2                	ld	ra,40(sp)
    8000203a:	7402                	ld	s0,32(sp)
    8000203c:	64e2                	ld	s1,24(sp)
    8000203e:	6942                	ld	s2,16(sp)
    80002040:	69a2                	ld	s3,8(sp)
    80002042:	6145                	addi	sp,sp,48
    80002044:	8082                	ret

0000000080002046 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002046:	1101                	addi	sp,sp,-32
    80002048:	ec06                	sd	ra,24(sp)
    8000204a:	e822                	sd	s0,16(sp)
    8000204c:	e426                	sd	s1,8(sp)
    8000204e:	1000                	addi	s0,sp,32
    80002050:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002052:	00000097          	auipc	ra,0x0
    80002056:	ef2080e7          	jalr	-270(ra) # 80001f44 <argraw>
    8000205a:	c088                	sw	a0,0(s1)
  return 0;
}
    8000205c:	4501                	li	a0,0
    8000205e:	60e2                	ld	ra,24(sp)
    80002060:	6442                	ld	s0,16(sp)
    80002062:	64a2                	ld	s1,8(sp)
    80002064:	6105                	addi	sp,sp,32
    80002066:	8082                	ret

0000000080002068 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002068:	1101                	addi	sp,sp,-32
    8000206a:	ec06                	sd	ra,24(sp)
    8000206c:	e822                	sd	s0,16(sp)
    8000206e:	e426                	sd	s1,8(sp)
    80002070:	1000                	addi	s0,sp,32
    80002072:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002074:	00000097          	auipc	ra,0x0
    80002078:	ed0080e7          	jalr	-304(ra) # 80001f44 <argraw>
    8000207c:	e088                	sd	a0,0(s1)
  return 0;
}
    8000207e:	4501                	li	a0,0
    80002080:	60e2                	ld	ra,24(sp)
    80002082:	6442                	ld	s0,16(sp)
    80002084:	64a2                	ld	s1,8(sp)
    80002086:	6105                	addi	sp,sp,32
    80002088:	8082                	ret

000000008000208a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000208a:	1101                	addi	sp,sp,-32
    8000208c:	ec06                	sd	ra,24(sp)
    8000208e:	e822                	sd	s0,16(sp)
    80002090:	e426                	sd	s1,8(sp)
    80002092:	e04a                	sd	s2,0(sp)
    80002094:	1000                	addi	s0,sp,32
    80002096:	84ae                	mv	s1,a1
    80002098:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000209a:	00000097          	auipc	ra,0x0
    8000209e:	eaa080e7          	jalr	-342(ra) # 80001f44 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800020a2:	864a                	mv	a2,s2
    800020a4:	85a6                	mv	a1,s1
    800020a6:	00000097          	auipc	ra,0x0
    800020aa:	f58080e7          	jalr	-168(ra) # 80001ffe <fetchstr>
}
    800020ae:	60e2                	ld	ra,24(sp)
    800020b0:	6442                	ld	s0,16(sp)
    800020b2:	64a2                	ld	s1,8(sp)
    800020b4:	6902                	ld	s2,0(sp)
    800020b6:	6105                	addi	sp,sp,32
    800020b8:	8082                	ret

00000000800020ba <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800020ba:	1101                	addi	sp,sp,-32
    800020bc:	ec06                	sd	ra,24(sp)
    800020be:	e822                	sd	s0,16(sp)
    800020c0:	e426                	sd	s1,8(sp)
    800020c2:	e04a                	sd	s2,0(sp)
    800020c4:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800020c6:	fffff097          	auipc	ra,0xfffff
    800020ca:	ec0080e7          	jalr	-320(ra) # 80000f86 <myproc>
    800020ce:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020d0:	06053903          	ld	s2,96(a0)
    800020d4:	0a893783          	ld	a5,168(s2)
    800020d8:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020dc:	37fd                	addiw	a5,a5,-1
    800020de:	4751                	li	a4,20
    800020e0:	00f76f63          	bltu	a4,a5,800020fe <syscall+0x44>
    800020e4:	00369713          	slli	a4,a3,0x3
    800020e8:	00006797          	auipc	a5,0x6
    800020ec:	71878793          	addi	a5,a5,1816 # 80008800 <syscalls>
    800020f0:	97ba                	add	a5,a5,a4
    800020f2:	639c                	ld	a5,0(a5)
    800020f4:	c789                	beqz	a5,800020fe <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800020f6:	9782                	jalr	a5
    800020f8:	06a93823          	sd	a0,112(s2)
    800020fc:	a839                	j	8000211a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020fe:	16048613          	addi	a2,s1,352
    80002102:	5c8c                	lw	a1,56(s1)
    80002104:	00006517          	auipc	a0,0x6
    80002108:	25c50513          	addi	a0,a0,604 # 80008360 <etext+0x360>
    8000210c:	00004097          	auipc	ra,0x4
    80002110:	274080e7          	jalr	628(ra) # 80006380 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002114:	70bc                	ld	a5,96(s1)
    80002116:	577d                	li	a4,-1
    80002118:	fbb8                	sd	a4,112(a5)
  }
}
    8000211a:	60e2                	ld	ra,24(sp)
    8000211c:	6442                	ld	s0,16(sp)
    8000211e:	64a2                	ld	s1,8(sp)
    80002120:	6902                	ld	s2,0(sp)
    80002122:	6105                	addi	sp,sp,32
    80002124:	8082                	ret

0000000080002126 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002126:	1101                	addi	sp,sp,-32
    80002128:	ec06                	sd	ra,24(sp)
    8000212a:	e822                	sd	s0,16(sp)
    8000212c:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000212e:	fec40593          	addi	a1,s0,-20
    80002132:	4501                	li	a0,0
    80002134:	00000097          	auipc	ra,0x0
    80002138:	f12080e7          	jalr	-238(ra) # 80002046 <argint>
    return -1;
    8000213c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000213e:	00054963          	bltz	a0,80002150 <sys_exit+0x2a>
  exit(n);
    80002142:	fec42503          	lw	a0,-20(s0)
    80002146:	fffff097          	auipc	ra,0xfffff
    8000214a:	762080e7          	jalr	1890(ra) # 800018a8 <exit>
  return 0;  // not reached
    8000214e:	4781                	li	a5,0
}
    80002150:	853e                	mv	a0,a5
    80002152:	60e2                	ld	ra,24(sp)
    80002154:	6442                	ld	s0,16(sp)
    80002156:	6105                	addi	sp,sp,32
    80002158:	8082                	ret

000000008000215a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000215a:	1141                	addi	sp,sp,-16
    8000215c:	e406                	sd	ra,8(sp)
    8000215e:	e022                	sd	s0,0(sp)
    80002160:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002162:	fffff097          	auipc	ra,0xfffff
    80002166:	e24080e7          	jalr	-476(ra) # 80000f86 <myproc>
}
    8000216a:	5d08                	lw	a0,56(a0)
    8000216c:	60a2                	ld	ra,8(sp)
    8000216e:	6402                	ld	s0,0(sp)
    80002170:	0141                	addi	sp,sp,16
    80002172:	8082                	ret

0000000080002174 <sys_fork>:

uint64
sys_fork(void)
{
    80002174:	1141                	addi	sp,sp,-16
    80002176:	e406                	sd	ra,8(sp)
    80002178:	e022                	sd	s0,0(sp)
    8000217a:	0800                	addi	s0,sp,16
  return fork();
    8000217c:	fffff097          	auipc	ra,0xfffff
    80002180:	1dc080e7          	jalr	476(ra) # 80001358 <fork>
}
    80002184:	60a2                	ld	ra,8(sp)
    80002186:	6402                	ld	s0,0(sp)
    80002188:	0141                	addi	sp,sp,16
    8000218a:	8082                	ret

000000008000218c <sys_wait>:

uint64
sys_wait(void)
{
    8000218c:	1101                	addi	sp,sp,-32
    8000218e:	ec06                	sd	ra,24(sp)
    80002190:	e822                	sd	s0,16(sp)
    80002192:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002194:	fe840593          	addi	a1,s0,-24
    80002198:	4501                	li	a0,0
    8000219a:	00000097          	auipc	ra,0x0
    8000219e:	ece080e7          	jalr	-306(ra) # 80002068 <argaddr>
    800021a2:	87aa                	mv	a5,a0
    return -1;
    800021a4:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800021a6:	0007c863          	bltz	a5,800021b6 <sys_wait+0x2a>
  return wait(p);
    800021aa:	fe843503          	ld	a0,-24(s0)
    800021ae:	fffff097          	auipc	ra,0xfffff
    800021b2:	502080e7          	jalr	1282(ra) # 800016b0 <wait>
}
    800021b6:	60e2                	ld	ra,24(sp)
    800021b8:	6442                	ld	s0,16(sp)
    800021ba:	6105                	addi	sp,sp,32
    800021bc:	8082                	ret

00000000800021be <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021be:	7179                	addi	sp,sp,-48
    800021c0:	f406                	sd	ra,40(sp)
    800021c2:	f022                	sd	s0,32(sp)
    800021c4:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800021c6:	fdc40593          	addi	a1,s0,-36
    800021ca:	4501                	li	a0,0
    800021cc:	00000097          	auipc	ra,0x0
    800021d0:	e7a080e7          	jalr	-390(ra) # 80002046 <argint>
    800021d4:	87aa                	mv	a5,a0
    return -1;
    800021d6:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800021d8:	0207c263          	bltz	a5,800021fc <sys_sbrk+0x3e>
    800021dc:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    800021de:	fffff097          	auipc	ra,0xfffff
    800021e2:	da8080e7          	jalr	-600(ra) # 80000f86 <myproc>
    800021e6:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    800021e8:	fdc42503          	lw	a0,-36(s0)
    800021ec:	fffff097          	auipc	ra,0xfffff
    800021f0:	0f4080e7          	jalr	244(ra) # 800012e0 <growproc>
    800021f4:	00054863          	bltz	a0,80002204 <sys_sbrk+0x46>
    return -1;
  return addr;
    800021f8:	8526                	mv	a0,s1
    800021fa:	64e2                	ld	s1,24(sp)
}
    800021fc:	70a2                	ld	ra,40(sp)
    800021fe:	7402                	ld	s0,32(sp)
    80002200:	6145                	addi	sp,sp,48
    80002202:	8082                	ret
    return -1;
    80002204:	557d                	li	a0,-1
    80002206:	64e2                	ld	s1,24(sp)
    80002208:	bfd5                	j	800021fc <sys_sbrk+0x3e>

000000008000220a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000220a:	7139                	addi	sp,sp,-64
    8000220c:	fc06                	sd	ra,56(sp)
    8000220e:	f822                	sd	s0,48(sp)
    80002210:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002212:	fcc40593          	addi	a1,s0,-52
    80002216:	4501                	li	a0,0
    80002218:	00000097          	auipc	ra,0x0
    8000221c:	e2e080e7          	jalr	-466(ra) # 80002046 <argint>
    return -1;
    80002220:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002222:	06054b63          	bltz	a0,80002298 <sys_sleep+0x8e>
    80002226:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    80002228:	00010517          	auipc	a0,0x10
    8000222c:	f8850513          	addi	a0,a0,-120 # 800121b0 <tickslock>
    80002230:	00004097          	auipc	ra,0x4
    80002234:	66a080e7          	jalr	1642(ra) # 8000689a <acquire>
  ticks0 = ticks;
    80002238:	0000a917          	auipc	s2,0xa
    8000223c:	de092903          	lw	s2,-544(s2) # 8000c018 <ticks>
  while(ticks - ticks0 < n){
    80002240:	fcc42783          	lw	a5,-52(s0)
    80002244:	c3a1                	beqz	a5,80002284 <sys_sleep+0x7a>
    80002246:	f426                	sd	s1,40(sp)
    80002248:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000224a:	00010997          	auipc	s3,0x10
    8000224e:	f6698993          	addi	s3,s3,-154 # 800121b0 <tickslock>
    80002252:	0000a497          	auipc	s1,0xa
    80002256:	dc648493          	addi	s1,s1,-570 # 8000c018 <ticks>
    if(myproc()->killed){
    8000225a:	fffff097          	auipc	ra,0xfffff
    8000225e:	d2c080e7          	jalr	-724(ra) # 80000f86 <myproc>
    80002262:	591c                	lw	a5,48(a0)
    80002264:	ef9d                	bnez	a5,800022a2 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002266:	85ce                	mv	a1,s3
    80002268:	8526                	mv	a0,s1
    8000226a:	fffff097          	auipc	ra,0xfffff
    8000226e:	3e2080e7          	jalr	994(ra) # 8000164c <sleep>
  while(ticks - ticks0 < n){
    80002272:	409c                	lw	a5,0(s1)
    80002274:	412787bb          	subw	a5,a5,s2
    80002278:	fcc42703          	lw	a4,-52(s0)
    8000227c:	fce7efe3          	bltu	a5,a4,8000225a <sys_sleep+0x50>
    80002280:	74a2                	ld	s1,40(sp)
    80002282:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002284:	00010517          	auipc	a0,0x10
    80002288:	f2c50513          	addi	a0,a0,-212 # 800121b0 <tickslock>
    8000228c:	00004097          	auipc	ra,0x4
    80002290:	6d6080e7          	jalr	1750(ra) # 80006962 <release>
  return 0;
    80002294:	4781                	li	a5,0
    80002296:	7902                	ld	s2,32(sp)
}
    80002298:	853e                	mv	a0,a5
    8000229a:	70e2                	ld	ra,56(sp)
    8000229c:	7442                	ld	s0,48(sp)
    8000229e:	6121                	addi	sp,sp,64
    800022a0:	8082                	ret
      release(&tickslock);
    800022a2:	00010517          	auipc	a0,0x10
    800022a6:	f0e50513          	addi	a0,a0,-242 # 800121b0 <tickslock>
    800022aa:	00004097          	auipc	ra,0x4
    800022ae:	6b8080e7          	jalr	1720(ra) # 80006962 <release>
      return -1;
    800022b2:	57fd                	li	a5,-1
    800022b4:	74a2                	ld	s1,40(sp)
    800022b6:	7902                	ld	s2,32(sp)
    800022b8:	69e2                	ld	s3,24(sp)
    800022ba:	bff9                	j	80002298 <sys_sleep+0x8e>

00000000800022bc <sys_kill>:

uint64
sys_kill(void)
{
    800022bc:	1101                	addi	sp,sp,-32
    800022be:	ec06                	sd	ra,24(sp)
    800022c0:	e822                	sd	s0,16(sp)
    800022c2:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800022c4:	fec40593          	addi	a1,s0,-20
    800022c8:	4501                	li	a0,0
    800022ca:	00000097          	auipc	ra,0x0
    800022ce:	d7c080e7          	jalr	-644(ra) # 80002046 <argint>
    800022d2:	87aa                	mv	a5,a0
    return -1;
    800022d4:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800022d6:	0007c863          	bltz	a5,800022e6 <sys_kill+0x2a>
  return kill(pid);
    800022da:	fec42503          	lw	a0,-20(s0)
    800022de:	fffff097          	auipc	ra,0xfffff
    800022e2:	6a0080e7          	jalr	1696(ra) # 8000197e <kill>
}
    800022e6:	60e2                	ld	ra,24(sp)
    800022e8:	6442                	ld	s0,16(sp)
    800022ea:	6105                	addi	sp,sp,32
    800022ec:	8082                	ret

00000000800022ee <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022ee:	1101                	addi	sp,sp,-32
    800022f0:	ec06                	sd	ra,24(sp)
    800022f2:	e822                	sd	s0,16(sp)
    800022f4:	e426                	sd	s1,8(sp)
    800022f6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022f8:	00010517          	auipc	a0,0x10
    800022fc:	eb850513          	addi	a0,a0,-328 # 800121b0 <tickslock>
    80002300:	00004097          	auipc	ra,0x4
    80002304:	59a080e7          	jalr	1434(ra) # 8000689a <acquire>
  xticks = ticks;
    80002308:	0000a497          	auipc	s1,0xa
    8000230c:	d104a483          	lw	s1,-752(s1) # 8000c018 <ticks>
  release(&tickslock);
    80002310:	00010517          	auipc	a0,0x10
    80002314:	ea050513          	addi	a0,a0,-352 # 800121b0 <tickslock>
    80002318:	00004097          	auipc	ra,0x4
    8000231c:	64a080e7          	jalr	1610(ra) # 80006962 <release>
  return xticks;
}
    80002320:	02049513          	slli	a0,s1,0x20
    80002324:	9101                	srli	a0,a0,0x20
    80002326:	60e2                	ld	ra,24(sp)
    80002328:	6442                	ld	s0,16(sp)
    8000232a:	64a2                	ld	s1,8(sp)
    8000232c:	6105                	addi	sp,sp,32
    8000232e:	8082                	ret

0000000080002330 <binit>:
  struct buf head[NBUCKET];
} bcache;

void
binit(void)
{
    80002330:	7139                	addi	sp,sp,-64
    80002332:	fc06                	sd	ra,56(sp)
    80002334:	f822                	sd	s0,48(sp)
    80002336:	f426                	sd	s1,40(sp)
    80002338:	f04a                	sd	s2,32(sp)
    8000233a:	ec4e                	sd	s3,24(sp)
    8000233c:	e852                	sd	s4,16(sp)
    8000233e:	e456                	sd	s5,8(sp)
    80002340:	0080                	addi	s0,sp,64
  struct buf *b;

  initlock(&bcache.bcache_lock, "bcache_lock");
    80002342:	00006597          	auipc	a1,0x6
    80002346:	03e58593          	addi	a1,a1,62 # 80008380 <etext+0x380>
    8000234a:	00018517          	auipc	a0,0x18
    8000234e:	45650513          	addi	a0,a0,1110 # 8001a7a0 <bcache+0x85d0>
    80002352:	00004097          	auipc	ra,0x4
    80002356:	6bc080e7          	jalr	1724(ra) # 80006a0e <initlock>
  for(int i=0;i<NBUCKET;i++){
    8000235a:	00010917          	auipc	s2,0x10
    8000235e:	e7690913          	addi	s2,s2,-394 # 800121d0 <bcache>
    80002362:	00010a17          	auipc	s4,0x10
    80002366:	00ea0a13          	addi	s4,s4,14 # 80012370 <bcache+0x1a0>
  initlock(&bcache.bcache_lock, "bcache_lock");
    8000236a:	84ca                	mv	s1,s2
    initlock(&bcache.lock[i],"bcache_bucket");
    8000236c:	00006997          	auipc	s3,0x6
    80002370:	02498993          	addi	s3,s3,36 # 80008390 <etext+0x390>
    80002374:	85ce                	mv	a1,s3
    80002376:	8526                	mv	a0,s1
    80002378:	00004097          	auipc	ra,0x4
    8000237c:	696080e7          	jalr	1686(ra) # 80006a0e <initlock>
  for(int i=0;i<NBUCKET;i++){
    80002380:	02048493          	addi	s1,s1,32
    80002384:	ff4498e3          	bne	s1,s4,80002374 <binit+0x44>
    80002388:	00018797          	auipc	a5,0x18
    8000238c:	43878793          	addi	a5,a5,1080 # 8001a7c0 <bcache+0x85f0>
    80002390:	6731                	lui	a4,0xc
    80002392:	f3870713          	addi	a4,a4,-200 # bf38 <_entry-0x7fff40c8>
    80002396:	974a                	add	a4,a4,s2
  }

  // Create linked list of buffers
  for(int i=0;i<NBUCKET;i++){
    bcache.head[i].prev = &bcache.head[i];
    80002398:	ebbc                	sd	a5,80(a5)
    bcache.head[i].next = &bcache.head[i];
    8000239a:	efbc                	sd	a5,88(a5)
  for(int i=0;i<NBUCKET;i++){
    8000239c:	46878793          	addi	a5,a5,1128
    800023a0:	fee79ce3          	bne	a5,a4,80002398 <binit+0x68>
  }
  
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023a4:	00010497          	auipc	s1,0x10
    800023a8:	fcc48493          	addi	s1,s1,-52 # 80012370 <bcache+0x1a0>
    b->next = bcache.head[0].next;
    800023ac:	00018917          	auipc	s2,0x18
    800023b0:	e2490913          	addi	s2,s2,-476 # 8001a1d0 <bcache+0x8000>
    b->prev = &bcache.head[0];
    800023b4:	00018a97          	auipc	s5,0x18
    800023b8:	40ca8a93          	addi	s5,s5,1036 # 8001a7c0 <bcache+0x85f0>
    initsleeplock(&b->lock, "buffer");
    800023bc:	00006a17          	auipc	s4,0x6
    800023c0:	fe4a0a13          	addi	s4,s4,-28 # 800083a0 <etext+0x3a0>
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023c4:	00018997          	auipc	s3,0x18
    800023c8:	3dc98993          	addi	s3,s3,988 # 8001a7a0 <bcache+0x85d0>
    b->next = bcache.head[0].next;
    800023cc:	64893783          	ld	a5,1608(s2)
    800023d0:	ecbc                	sd	a5,88(s1)
    b->prev = &bcache.head[0];
    800023d2:	0554b823          	sd	s5,80(s1)
    initsleeplock(&b->lock, "buffer");
    800023d6:	85d2                	mv	a1,s4
    800023d8:	01048513          	addi	a0,s1,16
    800023dc:	00001097          	auipc	ra,0x1
    800023e0:	6f8080e7          	jalr	1784(ra) # 80003ad4 <initsleeplock>
    bcache.head[0].next->prev = b;
    800023e4:	64893783          	ld	a5,1608(s2)
    800023e8:	eba4                	sd	s1,80(a5)
    bcache.head[0].next = b;
    800023ea:	64993423          	sd	s1,1608(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023ee:	46848493          	addi	s1,s1,1128
    800023f2:	fd349de3          	bne	s1,s3,800023cc <binit+0x9c>
  }
}
    800023f6:	70e2                	ld	ra,56(sp)
    800023f8:	7442                	ld	s0,48(sp)
    800023fa:	74a2                	ld	s1,40(sp)
    800023fc:	7902                	ld	s2,32(sp)
    800023fe:	69e2                	ld	s3,24(sp)
    80002400:	6a42                	ld	s4,16(sp)
    80002402:	6aa2                	ld	s5,8(sp)
    80002404:	6121                	addi	sp,sp,64
    80002406:	8082                	ret

0000000080002408 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002408:	7119                	addi	sp,sp,-128
    8000240a:	fc86                	sd	ra,120(sp)
    8000240c:	f8a2                	sd	s0,112(sp)
    8000240e:	f4a6                	sd	s1,104(sp)
    80002410:	f0ca                	sd	s2,96(sp)
    80002412:	ecce                	sd	s3,88(sp)
    80002414:	e8d2                	sd	s4,80(sp)
    80002416:	e0da                	sd	s6,64(sp)
    80002418:	f862                	sd	s8,48(sp)
    8000241a:	f466                	sd	s9,40(sp)
    8000241c:	0100                	addi	s0,sp,128
    8000241e:	8b2a                	mv	s6,a0
    80002420:	8c2e                	mv	s8,a1
  int index = blockno % NBUCKET;
    80002422:	4935                	li	s2,13
    80002424:	0325f93b          	remuw	s2,a1,s2
    80002428:	00090c9b          	sext.w	s9,s2
  acquire(&bcache.lock[index]);
    8000242c:	005c9793          	slli	a5,s9,0x5
    80002430:	00010997          	auipc	s3,0x10
    80002434:	da098993          	addi	s3,s3,-608 # 800121d0 <bcache>
    80002438:	97ce                	add	a5,a5,s3
    8000243a:	f8f43423          	sd	a5,-120(s0)
    8000243e:	853e                	mv	a0,a5
    80002440:	00004097          	auipc	ra,0x4
    80002444:	45a080e7          	jalr	1114(ra) # 8000689a <acquire>
  for(b = bcache.head[index].next; b != &bcache.head[index]; b = b->next){
    80002448:	46800a13          	li	s4,1128
    8000244c:	034c8a33          	mul	s4,s9,s4
    80002450:	01498733          	add	a4,s3,s4
    80002454:	67a1                	lui	a5,0x8
    80002456:	97ba                	add	a5,a5,a4
    80002458:	6487b483          	ld	s1,1608(a5) # 8648 <_entry-0x7fff79b8>
    8000245c:	67a1                	lui	a5,0x8
    8000245e:	5f078793          	addi	a5,a5,1520 # 85f0 <_entry-0x7fff7a10>
    80002462:	9a3e                	add	s4,s4,a5
    80002464:	9a4e                	add	s4,s4,s3
    80002466:	05449a63          	bne	s1,s4,800024ba <bread+0xb2>
  release(&bcache.lock[index]);
    8000246a:	f8843483          	ld	s1,-120(s0)
    8000246e:	8526                	mv	a0,s1
    80002470:	00004097          	auipc	ra,0x4
    80002474:	4f2080e7          	jalr	1266(ra) # 80006962 <release>
  acquire(&bcache.bcache_lock);
    80002478:	00018517          	auipc	a0,0x18
    8000247c:	32850513          	addi	a0,a0,808 # 8001a7a0 <bcache+0x85d0>
    80002480:	00004097          	auipc	ra,0x4
    80002484:	41a080e7          	jalr	1050(ra) # 8000689a <acquire>
  acquire(&bcache.lock[index]);
    80002488:	8526                	mv	a0,s1
    8000248a:	00004097          	auipc	ra,0x4
    8000248e:	410080e7          	jalr	1040(ra) # 8000689a <acquire>
  for(b = bcache.head[index].next; b != &bcache.head[index]; b = b->next){
    80002492:	46800793          	li	a5,1128
    80002496:	02fc87b3          	mul	a5,s9,a5
    8000249a:	00010717          	auipc	a4,0x10
    8000249e:	d3670713          	addi	a4,a4,-714 # 800121d0 <bcache>
    800024a2:	973e                	add	a4,a4,a5
    800024a4:	67a1                	lui	a5,0x8
    800024a6:	97ba                	add	a5,a5,a4
    800024a8:	6487b783          	ld	a5,1608(a5) # 8648 <_entry-0x7fff79b8>
    800024ac:	11478363          	beq	a5,s4,800025b2 <bread+0x1aa>
    800024b0:	84be                	mv	s1,a5
    800024b2:	a82d                	j	800024ec <bread+0xe4>
  for(b = bcache.head[index].next; b != &bcache.head[index]; b = b->next){
    800024b4:	6ca4                	ld	s1,88(s1)
    800024b6:	fb448ae3          	beq	s1,s4,8000246a <bread+0x62>
    if(b->dev == dev && b->blockno == blockno){
    800024ba:	449c                	lw	a5,8(s1)
    800024bc:	ff679ce3          	bne	a5,s6,800024b4 <bread+0xac>
    800024c0:	44dc                	lw	a5,12(s1)
    800024c2:	ff8799e3          	bne	a5,s8,800024b4 <bread+0xac>
      b->refcnt++;
    800024c6:	44bc                	lw	a5,72(s1)
    800024c8:	2785                	addiw	a5,a5,1
    800024ca:	c4bc                	sw	a5,72(s1)
      release(&bcache.lock[index]);
    800024cc:	f8843503          	ld	a0,-120(s0)
    800024d0:	00004097          	auipc	ra,0x4
    800024d4:	492080e7          	jalr	1170(ra) # 80006962 <release>
      acquiresleep(&b->lock);
    800024d8:	01048513          	addi	a0,s1,16
    800024dc:	00001097          	auipc	ra,0x1
    800024e0:	632080e7          	jalr	1586(ra) # 80003b0e <acquiresleep>
      return b;
    800024e4:	a2c1                	j	800026a4 <bread+0x29c>
  for(b = bcache.head[index].next; b != &bcache.head[index]; b = b->next){
    800024e6:	6ca4                	ld	s1,88(s1)
    800024e8:	05448063          	beq	s1,s4,80002528 <bread+0x120>
    if(b->dev == dev && b->blockno == blockno){
    800024ec:	4498                	lw	a4,8(s1)
    800024ee:	ff671ce3          	bne	a4,s6,800024e6 <bread+0xde>
    800024f2:	44d8                	lw	a4,12(s1)
    800024f4:	ff8719e3          	bne	a4,s8,800024e6 <bread+0xde>
      b->refcnt++;
    800024f8:	44bc                	lw	a5,72(s1)
    800024fa:	2785                	addiw	a5,a5,1
    800024fc:	c4bc                	sw	a5,72(s1)
      release(&bcache.lock[index]);
    800024fe:	f8843503          	ld	a0,-120(s0)
    80002502:	00004097          	auipc	ra,0x4
    80002506:	460080e7          	jalr	1120(ra) # 80006962 <release>
      release(&bcache.bcache_lock); 
    8000250a:	00018517          	auipc	a0,0x18
    8000250e:	29650513          	addi	a0,a0,662 # 8001a7a0 <bcache+0x85d0>
    80002512:	00004097          	auipc	ra,0x4
    80002516:	450080e7          	jalr	1104(ra) # 80006962 <release>
      acquiresleep(&b->lock);
    8000251a:	01048513          	addi	a0,s1,16
    8000251e:	00001097          	auipc	ra,0x1
    80002522:	5f0080e7          	jalr	1520(ra) # 80003b0e <acquiresleep>
      return b;
    80002526:	aabd                	j	800026a4 <bread+0x29c>
  int min_tick=0;
    80002528:	4981                	li	s3,0
  struct buf *lru_block = 0;
    8000252a:	4481                	li	s1,0
    8000252c:	a039                	j	8000253a <bread+0x132>
      min_tick = b->lastuse_tick;
    8000252e:	4607a983          	lw	s3,1120(a5)
      lru_block = b;
    80002532:	84be                	mv	s1,a5
  for (b = bcache.head[index].next; b != &bcache.head[index]; b = b->next) {
    80002534:	6fbc                	ld	a5,88(a5)
    80002536:	01478a63          	beq	a5,s4,8000254a <bread+0x142>
    if (b->refcnt == 0 && (lru_block==0||b->lastuse_tick < min_tick)) {
    8000253a:	47b8                	lw	a4,72(a5)
    8000253c:	ff65                	bnez	a4,80002534 <bread+0x12c>
    8000253e:	d8e5                	beqz	s1,8000252e <bread+0x126>
    80002540:	4607a703          	lw	a4,1120(a5)
    80002544:	ff3778e3          	bgeu	a4,s3,80002534 <bread+0x12c>
    80002548:	b7dd                	j	8000252e <bread+0x126>
  if(lru_block!=0){
    8000254a:	e495                	bnez	s1,80002576 <bread+0x16e>
    8000254c:	e4d6                	sd	s5,72(sp)
    8000254e:	fc5e                	sd	s7,56(sp)
    80002550:	f06a                	sd	s10,32(sp)
    80002552:	ec6e                	sd	s11,24(sp)
  for (int other_index = (index + 1) % NBUCKET; other_index != index; other_index = (other_index + 1) % NBUCKET) {
    80002554:	2905                	addiw	s2,s2,1
    80002556:	47b5                	li	a5,13
    80002558:	02f9693b          	remw	s2,s2,a5
    8000255c:	2901                	sext.w	s2,s2
    8000255e:	172c8163          	beq	s9,s2,800026c0 <bread+0x2b8>
    acquire(&bcache.lock[other_index]);
    80002562:	00010b97          	auipc	s7,0x10
    80002566:	c6eb8b93          	addi	s7,s7,-914 # 800121d0 <bcache>
    for (b = bcache.head[other_index].next; b != &bcache.head[other_index]; b = b->next) {
    8000256a:	46800d93          	li	s11,1128
    8000256e:	6d21                	lui	s10,0x8
    80002570:	5f0d0d13          	addi	s10,s10,1520 # 85f0 <_entry-0x7fff7a10>
    80002574:	a051                	j	800025f8 <bread+0x1f0>
    lru_block->dev = dev;
    80002576:	0164a423          	sw	s6,8(s1)
    lru_block->blockno = blockno;
    8000257a:	0184a623          	sw	s8,12(s1)
    lru_block->refcnt++;
    8000257e:	44bc                	lw	a5,72(s1)
    80002580:	2785                	addiw	a5,a5,1
    80002582:	c4bc                	sw	a5,72(s1)
    lru_block->valid = 0;
    80002584:	0004a023          	sw	zero,0(s1)
    release(&bcache.lock[index]);
    80002588:	f8843503          	ld	a0,-120(s0)
    8000258c:	00004097          	auipc	ra,0x4
    80002590:	3d6080e7          	jalr	982(ra) # 80006962 <release>
    release(&bcache.bcache_lock);
    80002594:	00018517          	auipc	a0,0x18
    80002598:	20c50513          	addi	a0,a0,524 # 8001a7a0 <bcache+0x85d0>
    8000259c:	00004097          	auipc	ra,0x4
    800025a0:	3c6080e7          	jalr	966(ra) # 80006962 <release>
    acquiresleep(&lru_block->lock);
    800025a4:	01048513          	addi	a0,s1,16
    800025a8:	00001097          	auipc	ra,0x1
    800025ac:	566080e7          	jalr	1382(ra) # 80003b0e <acquiresleep>
    return lru_block;
    800025b0:	a8d5                	j	800026a4 <bread+0x29c>
    800025b2:	e4d6                	sd	s5,72(sp)
    800025b4:	fc5e                	sd	s7,56(sp)
    800025b6:	f06a                	sd	s10,32(sp)
    800025b8:	ec6e                	sd	s11,24(sp)
  for(b = bcache.head[index].next; b != &bcache.head[index]; b = b->next){
    800025ba:	4981                	li	s3,0
    800025bc:	bf61                	j	80002554 <bread+0x14c>
      min_tick = b->lastuse_tick;
    800025be:	4607a983          	lw	s3,1120(a5)
      lru_block = b;
    800025c2:	84be                	mv	s1,a5
    for (b = bcache.head[other_index].next; b != &bcache.head[other_index]; b = b->next) {
    800025c4:	6fbc                	ld	a5,88(a5)
    800025c6:	04d78f63          	beq	a5,a3,80002624 <bread+0x21c>
      if (b->refcnt == 0 && (lru_block==0||b->lastuse_tick < min_tick)) {
    800025ca:	47b8                	lw	a4,72(a5)
    800025cc:	e719                	bnez	a4,800025da <bread+0x1d2>
    800025ce:	d8e5                	beqz	s1,800025be <bread+0x1b6>
    800025d0:	4607a703          	lw	a4,1120(a5)
    800025d4:	ff3778e3          	bgeu	a4,s3,800025c4 <bread+0x1bc>
    800025d8:	b7dd                	j	800025be <bread+0x1b6>
    for (b = bcache.head[other_index].next; b != &bcache.head[other_index]; b = b->next) {
    800025da:	6fbc                	ld	a5,88(a5)
    800025dc:	fed797e3          	bne	a5,a3,800025ca <bread+0x1c2>
    if(lru_block) {
    800025e0:	e0b1                	bnez	s1,80002624 <bread+0x21c>
    release(&bcache.lock[other_index]); 
    800025e2:	8556                	mv	a0,s5
    800025e4:	00004097          	auipc	ra,0x4
    800025e8:	37e080e7          	jalr	894(ra) # 80006962 <release>
  for (int other_index = (index + 1) % NBUCKET; other_index != index; other_index = (other_index + 1) % NBUCKET) {
    800025ec:	2905                	addiw	s2,s2,1
    800025ee:	47b5                	li	a5,13
    800025f0:	02f9693b          	remw	s2,s2,a5
    800025f4:	0d2c8663          	beq	s9,s2,800026c0 <bread+0x2b8>
    acquire(&bcache.lock[other_index]);
    800025f8:	00591a93          	slli	s5,s2,0x5
    800025fc:	9ade                	add	s5,s5,s7
    800025fe:	8556                	mv	a0,s5
    80002600:	00004097          	auipc	ra,0x4
    80002604:	29a080e7          	jalr	666(ra) # 8000689a <acquire>
    for (b = bcache.head[other_index].next; b != &bcache.head[other_index]; b = b->next) {
    80002608:	03b906b3          	mul	a3,s2,s11
    8000260c:	00db87b3          	add	a5,s7,a3
    80002610:	6721                	lui	a4,0x8
    80002612:	97ba                	add	a5,a5,a4
    80002614:	6487b783          	ld	a5,1608(a5)
    80002618:	96ea                	add	a3,a3,s10
    8000261a:	96de                	add	a3,a3,s7
    8000261c:	fcd783e3          	beq	a5,a3,800025e2 <bread+0x1da>
    80002620:	4481                	li	s1,0
    80002622:	b765                	j	800025ca <bread+0x1c2>
      lru_block->dev = dev;
    80002624:	0164a423          	sw	s6,8(s1)
      lru_block->refcnt++;
    80002628:	44bc                	lw	a5,72(s1)
    8000262a:	2785                	addiw	a5,a5,1
    8000262c:	c4bc                	sw	a5,72(s1)
      lru_block->valid = 0;
    8000262e:	0004a023          	sw	zero,0(s1)
      lru_block->blockno = blockno;
    80002632:	0184a623          	sw	s8,12(s1)
      lru_block->next->prev = lru_block->prev;
    80002636:	6cb8                	ld	a4,88(s1)
    80002638:	68bc                	ld	a5,80(s1)
    8000263a:	eb3c                	sd	a5,80(a4)
      lru_block->prev->next = lru_block->next;
    8000263c:	6cb8                	ld	a4,88(s1)
    8000263e:	efb8                	sd	a4,88(a5)
      release(&bcache.lock[other_index]);
    80002640:	8556                	mv	a0,s5
    80002642:	00004097          	auipc	ra,0x4
    80002646:	320080e7          	jalr	800(ra) # 80006962 <release>
      lru_block->next = bcache.head[index].next;
    8000264a:	46800793          	li	a5,1128
    8000264e:	02fc87b3          	mul	a5,s9,a5
    80002652:	00010717          	auipc	a4,0x10
    80002656:	b7e70713          	addi	a4,a4,-1154 # 800121d0 <bcache>
    8000265a:	973e                	add	a4,a4,a5
    8000265c:	67a1                	lui	a5,0x8
    8000265e:	97ba                	add	a5,a5,a4
    80002660:	6487b703          	ld	a4,1608(a5) # 8648 <_entry-0x7fff79b8>
    80002664:	ecb8                	sd	a4,88(s1)
      lru_block->prev = &bcache.head[index];
    80002666:	0544b823          	sd	s4,80(s1)
      bcache.head[index].next->prev = lru_block;
    8000266a:	6487b703          	ld	a4,1608(a5)
    8000266e:	eb24                	sd	s1,80(a4)
      bcache.head[index].next = lru_block;
    80002670:	6497b423          	sd	s1,1608(a5)
      release(&bcache.lock[index]);
    80002674:	f8843503          	ld	a0,-120(s0)
    80002678:	00004097          	auipc	ra,0x4
    8000267c:	2ea080e7          	jalr	746(ra) # 80006962 <release>
      release(&bcache.bcache_lock);
    80002680:	00018517          	auipc	a0,0x18
    80002684:	12050513          	addi	a0,a0,288 # 8001a7a0 <bcache+0x85d0>
    80002688:	00004097          	auipc	ra,0x4
    8000268c:	2da080e7          	jalr	730(ra) # 80006962 <release>
      acquiresleep(&lru_block->lock);
    80002690:	01048513          	addi	a0,s1,16
    80002694:	00001097          	auipc	ra,0x1
    80002698:	47a080e7          	jalr	1146(ra) # 80003b0e <acquiresleep>
      return lru_block;
    8000269c:	6aa6                	ld	s5,72(sp)
    8000269e:	7be2                	ld	s7,56(sp)
    800026a0:	7d02                	ld	s10,32(sp)
    800026a2:	6de2                	ld	s11,24(sp)
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800026a4:	409c                	lw	a5,0(s1)
    800026a6:	c3b9                	beqz	a5,800026ec <bread+0x2e4>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800026a8:	8526                	mv	a0,s1
    800026aa:	70e6                	ld	ra,120(sp)
    800026ac:	7446                	ld	s0,112(sp)
    800026ae:	74a6                	ld	s1,104(sp)
    800026b0:	7906                	ld	s2,96(sp)
    800026b2:	69e6                	ld	s3,88(sp)
    800026b4:	6a46                	ld	s4,80(sp)
    800026b6:	6b06                	ld	s6,64(sp)
    800026b8:	7c42                	ld	s8,48(sp)
    800026ba:	7ca2                	ld	s9,40(sp)
    800026bc:	6109                	addi	sp,sp,128
    800026be:	8082                	ret
  release(&bcache.lock[index]);
    800026c0:	f8843503          	ld	a0,-120(s0)
    800026c4:	00004097          	auipc	ra,0x4
    800026c8:	29e080e7          	jalr	670(ra) # 80006962 <release>
  release(&bcache.bcache_lock);
    800026cc:	00018517          	auipc	a0,0x18
    800026d0:	0d450513          	addi	a0,a0,212 # 8001a7a0 <bcache+0x85d0>
    800026d4:	00004097          	auipc	ra,0x4
    800026d8:	28e080e7          	jalr	654(ra) # 80006962 <release>
  panic("bget: no buffers");
    800026dc:	00006517          	auipc	a0,0x6
    800026e0:	ccc50513          	addi	a0,a0,-820 # 800083a8 <etext+0x3a8>
    800026e4:	00004097          	auipc	ra,0x4
    800026e8:	c52080e7          	jalr	-942(ra) # 80006336 <panic>
    virtio_disk_rw(b, 0);
    800026ec:	4581                	li	a1,0
    800026ee:	8526                	mv	a0,s1
    800026f0:	00003097          	auipc	ra,0x3
    800026f4:	032080e7          	jalr	50(ra) # 80005722 <virtio_disk_rw>
    b->valid = 1;
    800026f8:	4785                	li	a5,1
    800026fa:	c09c                	sw	a5,0(s1)
  return b;
    800026fc:	b775                	j	800026a8 <bread+0x2a0>

00000000800026fe <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800026fe:	1101                	addi	sp,sp,-32
    80002700:	ec06                	sd	ra,24(sp)
    80002702:	e822                	sd	s0,16(sp)
    80002704:	e426                	sd	s1,8(sp)
    80002706:	1000                	addi	s0,sp,32
    80002708:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000270a:	0541                	addi	a0,a0,16
    8000270c:	00001097          	auipc	ra,0x1
    80002710:	49c080e7          	jalr	1180(ra) # 80003ba8 <holdingsleep>
    80002714:	cd01                	beqz	a0,8000272c <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002716:	4585                	li	a1,1
    80002718:	8526                	mv	a0,s1
    8000271a:	00003097          	auipc	ra,0x3
    8000271e:	008080e7          	jalr	8(ra) # 80005722 <virtio_disk_rw>
}
    80002722:	60e2                	ld	ra,24(sp)
    80002724:	6442                	ld	s0,16(sp)
    80002726:	64a2                	ld	s1,8(sp)
    80002728:	6105                	addi	sp,sp,32
    8000272a:	8082                	ret
    panic("bwrite");
    8000272c:	00006517          	auipc	a0,0x6
    80002730:	c9450513          	addi	a0,a0,-876 # 800083c0 <etext+0x3c0>
    80002734:	00004097          	auipc	ra,0x4
    80002738:	c02080e7          	jalr	-1022(ra) # 80006336 <panic>

000000008000273c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{ 
    8000273c:	1101                	addi	sp,sp,-32
    8000273e:	ec06                	sd	ra,24(sp)
    80002740:	e822                	sd	s0,16(sp)
    80002742:	e426                	sd	s1,8(sp)
    80002744:	e04a                	sd	s2,0(sp)
    80002746:	1000                	addi	s0,sp,32
    80002748:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000274a:	01050913          	addi	s2,a0,16
    8000274e:	854a                	mv	a0,s2
    80002750:	00001097          	auipc	ra,0x1
    80002754:	458080e7          	jalr	1112(ra) # 80003ba8 <holdingsleep>
    80002758:	c925                	beqz	a0,800027c8 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    8000275a:	854a                	mv	a0,s2
    8000275c:	00001097          	auipc	ra,0x1
    80002760:	408080e7          	jalr	1032(ra) # 80003b64 <releasesleep>

  acquire(&bcache.lock[b->blockno % NBUCKET]);
    80002764:	44dc                	lw	a5,12(s1)
    80002766:	4735                	li	a4,13
    80002768:	02e7f7bb          	remuw	a5,a5,a4
    8000276c:	1782                	slli	a5,a5,0x20
    8000276e:	9381                	srli	a5,a5,0x20
    80002770:	0796                	slli	a5,a5,0x5
    80002772:	00010517          	auipc	a0,0x10
    80002776:	a5e50513          	addi	a0,a0,-1442 # 800121d0 <bcache>
    8000277a:	953e                	add	a0,a0,a5
    8000277c:	00004097          	auipc	ra,0x4
    80002780:	11e080e7          	jalr	286(ra) # 8000689a <acquire>
  b->refcnt--;
    80002784:	44bc                	lw	a5,72(s1)
    80002786:	37fd                	addiw	a5,a5,-1
    80002788:	0007871b          	sext.w	a4,a5
    8000278c:	c4bc                	sw	a5,72(s1)
  if (b->refcnt == 0) {
    8000278e:	e719                	bnez	a4,8000279c <brelse+0x60>
    // b->next = bcache.head.next;
    // b->prev = &bcache.head;
    // bcache.head.next->prev = b;
    // bcache.head.next = b;
    // 改用 ticks
    b->lastuse_tick=ticks;
    80002790:	0000a797          	auipc	a5,0xa
    80002794:	8887a783          	lw	a5,-1912(a5) # 8000c018 <ticks>
    80002798:	46f4a023          	sw	a5,1120(s1)
  }
  
  release(&bcache.lock[b->blockno % NBUCKET]);
    8000279c:	44dc                	lw	a5,12(s1)
    8000279e:	4735                	li	a4,13
    800027a0:	02e7f7bb          	remuw	a5,a5,a4
    800027a4:	1782                	slli	a5,a5,0x20
    800027a6:	9381                	srli	a5,a5,0x20
    800027a8:	0796                	slli	a5,a5,0x5
    800027aa:	00010517          	auipc	a0,0x10
    800027ae:	a2650513          	addi	a0,a0,-1498 # 800121d0 <bcache>
    800027b2:	953e                	add	a0,a0,a5
    800027b4:	00004097          	auipc	ra,0x4
    800027b8:	1ae080e7          	jalr	430(ra) # 80006962 <release>
}
    800027bc:	60e2                	ld	ra,24(sp)
    800027be:	6442                	ld	s0,16(sp)
    800027c0:	64a2                	ld	s1,8(sp)
    800027c2:	6902                	ld	s2,0(sp)
    800027c4:	6105                	addi	sp,sp,32
    800027c6:	8082                	ret
    panic("brelse");
    800027c8:	00006517          	auipc	a0,0x6
    800027cc:	c0050513          	addi	a0,a0,-1024 # 800083c8 <etext+0x3c8>
    800027d0:	00004097          	auipc	ra,0x4
    800027d4:	b66080e7          	jalr	-1178(ra) # 80006336 <panic>

00000000800027d8 <bpin>:

void
bpin(struct buf *b) {
    800027d8:	7179                	addi	sp,sp,-48
    800027da:	f406                	sd	ra,40(sp)
    800027dc:	f022                	sd	s0,32(sp)
    800027de:	ec26                	sd	s1,24(sp)
    800027e0:	e84a                	sd	s2,16(sp)
    800027e2:	e44e                	sd	s3,8(sp)
    800027e4:	1800                	addi	s0,sp,48
    800027e6:	84aa                	mv	s1,a0
  acquire(&bcache.lock[b->blockno%NBUCKET]);
    800027e8:	455c                	lw	a5,12(a0)
    800027ea:	49b5                	li	s3,13
    800027ec:	0337f7bb          	remuw	a5,a5,s3
    800027f0:	1782                	slli	a5,a5,0x20
    800027f2:	9381                	srli	a5,a5,0x20
    800027f4:	0796                	slli	a5,a5,0x5
    800027f6:	00010917          	auipc	s2,0x10
    800027fa:	9da90913          	addi	s2,s2,-1574 # 800121d0 <bcache>
    800027fe:	00f90533          	add	a0,s2,a5
    80002802:	00004097          	auipc	ra,0x4
    80002806:	098080e7          	jalr	152(ra) # 8000689a <acquire>
  b->refcnt++;
    8000280a:	44bc                	lw	a5,72(s1)
    8000280c:	2785                	addiw	a5,a5,1
    8000280e:	c4bc                	sw	a5,72(s1)
  release(&bcache.lock[b->blockno%NBUCKET]);
    80002810:	44c8                	lw	a0,12(s1)
    80002812:	0335753b          	remuw	a0,a0,s3
    80002816:	1502                	slli	a0,a0,0x20
    80002818:	9101                	srli	a0,a0,0x20
    8000281a:	0516                	slli	a0,a0,0x5
    8000281c:	954a                	add	a0,a0,s2
    8000281e:	00004097          	auipc	ra,0x4
    80002822:	144080e7          	jalr	324(ra) # 80006962 <release>
}
    80002826:	70a2                	ld	ra,40(sp)
    80002828:	7402                	ld	s0,32(sp)
    8000282a:	64e2                	ld	s1,24(sp)
    8000282c:	6942                	ld	s2,16(sp)
    8000282e:	69a2                	ld	s3,8(sp)
    80002830:	6145                	addi	sp,sp,48
    80002832:	8082                	ret

0000000080002834 <bunpin>:

void
bunpin(struct buf *b) {
    80002834:	7179                	addi	sp,sp,-48
    80002836:	f406                	sd	ra,40(sp)
    80002838:	f022                	sd	s0,32(sp)
    8000283a:	ec26                	sd	s1,24(sp)
    8000283c:	e84a                	sd	s2,16(sp)
    8000283e:	e44e                	sd	s3,8(sp)
    80002840:	1800                	addi	s0,sp,48
    80002842:	84aa                	mv	s1,a0
  acquire(&bcache.lock[b->blockno%NBUCKET]);
    80002844:	455c                	lw	a5,12(a0)
    80002846:	49b5                	li	s3,13
    80002848:	0337f7bb          	remuw	a5,a5,s3
    8000284c:	1782                	slli	a5,a5,0x20
    8000284e:	9381                	srli	a5,a5,0x20
    80002850:	0796                	slli	a5,a5,0x5
    80002852:	00010917          	auipc	s2,0x10
    80002856:	97e90913          	addi	s2,s2,-1666 # 800121d0 <bcache>
    8000285a:	00f90533          	add	a0,s2,a5
    8000285e:	00004097          	auipc	ra,0x4
    80002862:	03c080e7          	jalr	60(ra) # 8000689a <acquire>
  b->refcnt--;
    80002866:	44bc                	lw	a5,72(s1)
    80002868:	37fd                	addiw	a5,a5,-1
    8000286a:	c4bc                	sw	a5,72(s1)
  release(&bcache.lock[b->blockno%NBUCKET]);
    8000286c:	44c8                	lw	a0,12(s1)
    8000286e:	0335753b          	remuw	a0,a0,s3
    80002872:	1502                	slli	a0,a0,0x20
    80002874:	9101                	srli	a0,a0,0x20
    80002876:	0516                	slli	a0,a0,0x5
    80002878:	954a                	add	a0,a0,s2
    8000287a:	00004097          	auipc	ra,0x4
    8000287e:	0e8080e7          	jalr	232(ra) # 80006962 <release>
}
    80002882:	70a2                	ld	ra,40(sp)
    80002884:	7402                	ld	s0,32(sp)
    80002886:	64e2                	ld	s1,24(sp)
    80002888:	6942                	ld	s2,16(sp)
    8000288a:	69a2                	ld	s3,8(sp)
    8000288c:	6145                	addi	sp,sp,48
    8000288e:	8082                	ret

0000000080002890 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002890:	1101                	addi	sp,sp,-32
    80002892:	ec06                	sd	ra,24(sp)
    80002894:	e822                	sd	s0,16(sp)
    80002896:	e426                	sd	s1,8(sp)
    80002898:	e04a                	sd	s2,0(sp)
    8000289a:	1000                	addi	s0,sp,32
    8000289c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000289e:	00d5d59b          	srliw	a1,a1,0xd
    800028a2:	0001c797          	auipc	a5,0x1c
    800028a6:	8827a783          	lw	a5,-1918(a5) # 8001e124 <sb+0x1c>
    800028aa:	9dbd                	addw	a1,a1,a5
    800028ac:	00000097          	auipc	ra,0x0
    800028b0:	b5c080e7          	jalr	-1188(ra) # 80002408 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800028b4:	0074f713          	andi	a4,s1,7
    800028b8:	4785                	li	a5,1
    800028ba:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800028be:	14ce                	slli	s1,s1,0x33
    800028c0:	90d9                	srli	s1,s1,0x36
    800028c2:	00950733          	add	a4,a0,s1
    800028c6:	06074703          	lbu	a4,96(a4)
    800028ca:	00e7f6b3          	and	a3,a5,a4
    800028ce:	c69d                	beqz	a3,800028fc <bfree+0x6c>
    800028d0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800028d2:	94aa                	add	s1,s1,a0
    800028d4:	fff7c793          	not	a5,a5
    800028d8:	8f7d                	and	a4,a4,a5
    800028da:	06e48023          	sb	a4,96(s1)
  log_write(bp);
    800028de:	00001097          	auipc	ra,0x1
    800028e2:	112080e7          	jalr	274(ra) # 800039f0 <log_write>
  brelse(bp);
    800028e6:	854a                	mv	a0,s2
    800028e8:	00000097          	auipc	ra,0x0
    800028ec:	e54080e7          	jalr	-428(ra) # 8000273c <brelse>
}
    800028f0:	60e2                	ld	ra,24(sp)
    800028f2:	6442                	ld	s0,16(sp)
    800028f4:	64a2                	ld	s1,8(sp)
    800028f6:	6902                	ld	s2,0(sp)
    800028f8:	6105                	addi	sp,sp,32
    800028fa:	8082                	ret
    panic("freeing free block");
    800028fc:	00006517          	auipc	a0,0x6
    80002900:	ad450513          	addi	a0,a0,-1324 # 800083d0 <etext+0x3d0>
    80002904:	00004097          	auipc	ra,0x4
    80002908:	a32080e7          	jalr	-1486(ra) # 80006336 <panic>

000000008000290c <balloc>:
{
    8000290c:	711d                	addi	sp,sp,-96
    8000290e:	ec86                	sd	ra,88(sp)
    80002910:	e8a2                	sd	s0,80(sp)
    80002912:	e4a6                	sd	s1,72(sp)
    80002914:	e0ca                	sd	s2,64(sp)
    80002916:	fc4e                	sd	s3,56(sp)
    80002918:	f852                	sd	s4,48(sp)
    8000291a:	f456                	sd	s5,40(sp)
    8000291c:	f05a                	sd	s6,32(sp)
    8000291e:	ec5e                	sd	s7,24(sp)
    80002920:	e862                	sd	s8,16(sp)
    80002922:	e466                	sd	s9,8(sp)
    80002924:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002926:	0001b797          	auipc	a5,0x1b
    8000292a:	7e67a783          	lw	a5,2022(a5) # 8001e10c <sb+0x4>
    8000292e:	cbc1                	beqz	a5,800029be <balloc+0xb2>
    80002930:	8baa                	mv	s7,a0
    80002932:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002934:	0001bb17          	auipc	s6,0x1b
    80002938:	7d4b0b13          	addi	s6,s6,2004 # 8001e108 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000293c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000293e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002940:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002942:	6c89                	lui	s9,0x2
    80002944:	a831                	j	80002960 <balloc+0x54>
    brelse(bp);
    80002946:	854a                	mv	a0,s2
    80002948:	00000097          	auipc	ra,0x0
    8000294c:	df4080e7          	jalr	-524(ra) # 8000273c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002950:	015c87bb          	addw	a5,s9,s5
    80002954:	00078a9b          	sext.w	s5,a5
    80002958:	004b2703          	lw	a4,4(s6)
    8000295c:	06eaf163          	bgeu	s5,a4,800029be <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002960:	41fad79b          	sraiw	a5,s5,0x1f
    80002964:	0137d79b          	srliw	a5,a5,0x13
    80002968:	015787bb          	addw	a5,a5,s5
    8000296c:	40d7d79b          	sraiw	a5,a5,0xd
    80002970:	01cb2583          	lw	a1,28(s6)
    80002974:	9dbd                	addw	a1,a1,a5
    80002976:	855e                	mv	a0,s7
    80002978:	00000097          	auipc	ra,0x0
    8000297c:	a90080e7          	jalr	-1392(ra) # 80002408 <bread>
    80002980:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002982:	004b2503          	lw	a0,4(s6)
    80002986:	000a849b          	sext.w	s1,s5
    8000298a:	8762                	mv	a4,s8
    8000298c:	faa4fde3          	bgeu	s1,a0,80002946 <balloc+0x3a>
      m = 1 << (bi % 8);
    80002990:	00777693          	andi	a3,a4,7
    80002994:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002998:	41f7579b          	sraiw	a5,a4,0x1f
    8000299c:	01d7d79b          	srliw	a5,a5,0x1d
    800029a0:	9fb9                	addw	a5,a5,a4
    800029a2:	4037d79b          	sraiw	a5,a5,0x3
    800029a6:	00f90633          	add	a2,s2,a5
    800029aa:	06064603          	lbu	a2,96(a2)
    800029ae:	00c6f5b3          	and	a1,a3,a2
    800029b2:	cd91                	beqz	a1,800029ce <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029b4:	2705                	addiw	a4,a4,1
    800029b6:	2485                	addiw	s1,s1,1
    800029b8:	fd471ae3          	bne	a4,s4,8000298c <balloc+0x80>
    800029bc:	b769                	j	80002946 <balloc+0x3a>
  panic("balloc: out of blocks");
    800029be:	00006517          	auipc	a0,0x6
    800029c2:	a2a50513          	addi	a0,a0,-1494 # 800083e8 <etext+0x3e8>
    800029c6:	00004097          	auipc	ra,0x4
    800029ca:	970080e7          	jalr	-1680(ra) # 80006336 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800029ce:	97ca                	add	a5,a5,s2
    800029d0:	8e55                	or	a2,a2,a3
    800029d2:	06c78023          	sb	a2,96(a5)
        log_write(bp);
    800029d6:	854a                	mv	a0,s2
    800029d8:	00001097          	auipc	ra,0x1
    800029dc:	018080e7          	jalr	24(ra) # 800039f0 <log_write>
        brelse(bp);
    800029e0:	854a                	mv	a0,s2
    800029e2:	00000097          	auipc	ra,0x0
    800029e6:	d5a080e7          	jalr	-678(ra) # 8000273c <brelse>
  bp = bread(dev, bno);
    800029ea:	85a6                	mv	a1,s1
    800029ec:	855e                	mv	a0,s7
    800029ee:	00000097          	auipc	ra,0x0
    800029f2:	a1a080e7          	jalr	-1510(ra) # 80002408 <bread>
    800029f6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800029f8:	40000613          	li	a2,1024
    800029fc:	4581                	li	a1,0
    800029fe:	06050513          	addi	a0,a0,96
    80002a02:	ffffe097          	auipc	ra,0xffffe
    80002a06:	872080e7          	jalr	-1934(ra) # 80000274 <memset>
  log_write(bp);
    80002a0a:	854a                	mv	a0,s2
    80002a0c:	00001097          	auipc	ra,0x1
    80002a10:	fe4080e7          	jalr	-28(ra) # 800039f0 <log_write>
  brelse(bp);
    80002a14:	854a                	mv	a0,s2
    80002a16:	00000097          	auipc	ra,0x0
    80002a1a:	d26080e7          	jalr	-730(ra) # 8000273c <brelse>
}
    80002a1e:	8526                	mv	a0,s1
    80002a20:	60e6                	ld	ra,88(sp)
    80002a22:	6446                	ld	s0,80(sp)
    80002a24:	64a6                	ld	s1,72(sp)
    80002a26:	6906                	ld	s2,64(sp)
    80002a28:	79e2                	ld	s3,56(sp)
    80002a2a:	7a42                	ld	s4,48(sp)
    80002a2c:	7aa2                	ld	s5,40(sp)
    80002a2e:	7b02                	ld	s6,32(sp)
    80002a30:	6be2                	ld	s7,24(sp)
    80002a32:	6c42                	ld	s8,16(sp)
    80002a34:	6ca2                	ld	s9,8(sp)
    80002a36:	6125                	addi	sp,sp,96
    80002a38:	8082                	ret

0000000080002a3a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002a3a:	7179                	addi	sp,sp,-48
    80002a3c:	f406                	sd	ra,40(sp)
    80002a3e:	f022                	sd	s0,32(sp)
    80002a40:	ec26                	sd	s1,24(sp)
    80002a42:	e84a                	sd	s2,16(sp)
    80002a44:	e44e                	sd	s3,8(sp)
    80002a46:	1800                	addi	s0,sp,48
    80002a48:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002a4a:	47ad                	li	a5,11
    80002a4c:	04b7ff63          	bgeu	a5,a1,80002aaa <bmap+0x70>
    80002a50:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002a52:	ff45849b          	addiw	s1,a1,-12
    80002a56:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002a5a:	0ff00793          	li	a5,255
    80002a5e:	0ae7e463          	bltu	a5,a4,80002b06 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002a62:	08852583          	lw	a1,136(a0)
    80002a66:	c5b5                	beqz	a1,80002ad2 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002a68:	00092503          	lw	a0,0(s2)
    80002a6c:	00000097          	auipc	ra,0x0
    80002a70:	99c080e7          	jalr	-1636(ra) # 80002408 <bread>
    80002a74:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a76:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    80002a7a:	02049713          	slli	a4,s1,0x20
    80002a7e:	01e75593          	srli	a1,a4,0x1e
    80002a82:	00b784b3          	add	s1,a5,a1
    80002a86:	0004a983          	lw	s3,0(s1)
    80002a8a:	04098e63          	beqz	s3,80002ae6 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002a8e:	8552                	mv	a0,s4
    80002a90:	00000097          	auipc	ra,0x0
    80002a94:	cac080e7          	jalr	-852(ra) # 8000273c <brelse>
    return addr;
    80002a98:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002a9a:	854e                	mv	a0,s3
    80002a9c:	70a2                	ld	ra,40(sp)
    80002a9e:	7402                	ld	s0,32(sp)
    80002aa0:	64e2                	ld	s1,24(sp)
    80002aa2:	6942                	ld	s2,16(sp)
    80002aa4:	69a2                	ld	s3,8(sp)
    80002aa6:	6145                	addi	sp,sp,48
    80002aa8:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002aaa:	02059793          	slli	a5,a1,0x20
    80002aae:	01e7d593          	srli	a1,a5,0x1e
    80002ab2:	00b504b3          	add	s1,a0,a1
    80002ab6:	0584a983          	lw	s3,88(s1)
    80002aba:	fe0990e3          	bnez	s3,80002a9a <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002abe:	4108                	lw	a0,0(a0)
    80002ac0:	00000097          	auipc	ra,0x0
    80002ac4:	e4c080e7          	jalr	-436(ra) # 8000290c <balloc>
    80002ac8:	0005099b          	sext.w	s3,a0
    80002acc:	0534ac23          	sw	s3,88(s1)
    80002ad0:	b7e9                	j	80002a9a <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002ad2:	4108                	lw	a0,0(a0)
    80002ad4:	00000097          	auipc	ra,0x0
    80002ad8:	e38080e7          	jalr	-456(ra) # 8000290c <balloc>
    80002adc:	0005059b          	sext.w	a1,a0
    80002ae0:	08b92423          	sw	a1,136(s2)
    80002ae4:	b751                	j	80002a68 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002ae6:	00092503          	lw	a0,0(s2)
    80002aea:	00000097          	auipc	ra,0x0
    80002aee:	e22080e7          	jalr	-478(ra) # 8000290c <balloc>
    80002af2:	0005099b          	sext.w	s3,a0
    80002af6:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002afa:	8552                	mv	a0,s4
    80002afc:	00001097          	auipc	ra,0x1
    80002b00:	ef4080e7          	jalr	-268(ra) # 800039f0 <log_write>
    80002b04:	b769                	j	80002a8e <bmap+0x54>
  panic("bmap: out of range");
    80002b06:	00006517          	auipc	a0,0x6
    80002b0a:	8fa50513          	addi	a0,a0,-1798 # 80008400 <etext+0x400>
    80002b0e:	00004097          	auipc	ra,0x4
    80002b12:	828080e7          	jalr	-2008(ra) # 80006336 <panic>

0000000080002b16 <iget>:
{
    80002b16:	7179                	addi	sp,sp,-48
    80002b18:	f406                	sd	ra,40(sp)
    80002b1a:	f022                	sd	s0,32(sp)
    80002b1c:	ec26                	sd	s1,24(sp)
    80002b1e:	e84a                	sd	s2,16(sp)
    80002b20:	e44e                	sd	s3,8(sp)
    80002b22:	e052                	sd	s4,0(sp)
    80002b24:	1800                	addi	s0,sp,48
    80002b26:	89aa                	mv	s3,a0
    80002b28:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002b2a:	0001b517          	auipc	a0,0x1b
    80002b2e:	5fe50513          	addi	a0,a0,1534 # 8001e128 <itable>
    80002b32:	00004097          	auipc	ra,0x4
    80002b36:	d68080e7          	jalr	-664(ra) # 8000689a <acquire>
  empty = 0;
    80002b3a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b3c:	0001b497          	auipc	s1,0x1b
    80002b40:	60c48493          	addi	s1,s1,1548 # 8001e148 <itable+0x20>
    80002b44:	0001d697          	auipc	a3,0x1d
    80002b48:	22468693          	addi	a3,a3,548 # 8001fd68 <log>
    80002b4c:	a039                	j	80002b5a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b4e:	02090b63          	beqz	s2,80002b84 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b52:	09048493          	addi	s1,s1,144
    80002b56:	02d48a63          	beq	s1,a3,80002b8a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002b5a:	449c                	lw	a5,8(s1)
    80002b5c:	fef059e3          	blez	a5,80002b4e <iget+0x38>
    80002b60:	4098                	lw	a4,0(s1)
    80002b62:	ff3716e3          	bne	a4,s3,80002b4e <iget+0x38>
    80002b66:	40d8                	lw	a4,4(s1)
    80002b68:	ff4713e3          	bne	a4,s4,80002b4e <iget+0x38>
      ip->ref++;
    80002b6c:	2785                	addiw	a5,a5,1
    80002b6e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b70:	0001b517          	auipc	a0,0x1b
    80002b74:	5b850513          	addi	a0,a0,1464 # 8001e128 <itable>
    80002b78:	00004097          	auipc	ra,0x4
    80002b7c:	dea080e7          	jalr	-534(ra) # 80006962 <release>
      return ip;
    80002b80:	8926                	mv	s2,s1
    80002b82:	a03d                	j	80002bb0 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b84:	f7f9                	bnez	a5,80002b52 <iget+0x3c>
      empty = ip;
    80002b86:	8926                	mv	s2,s1
    80002b88:	b7e9                	j	80002b52 <iget+0x3c>
  if(empty == 0)
    80002b8a:	02090c63          	beqz	s2,80002bc2 <iget+0xac>
  ip->dev = dev;
    80002b8e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002b92:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002b96:	4785                	li	a5,1
    80002b98:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002b9c:	04092423          	sw	zero,72(s2)
  release(&itable.lock);
    80002ba0:	0001b517          	auipc	a0,0x1b
    80002ba4:	58850513          	addi	a0,a0,1416 # 8001e128 <itable>
    80002ba8:	00004097          	auipc	ra,0x4
    80002bac:	dba080e7          	jalr	-582(ra) # 80006962 <release>
}
    80002bb0:	854a                	mv	a0,s2
    80002bb2:	70a2                	ld	ra,40(sp)
    80002bb4:	7402                	ld	s0,32(sp)
    80002bb6:	64e2                	ld	s1,24(sp)
    80002bb8:	6942                	ld	s2,16(sp)
    80002bba:	69a2                	ld	s3,8(sp)
    80002bbc:	6a02                	ld	s4,0(sp)
    80002bbe:	6145                	addi	sp,sp,48
    80002bc0:	8082                	ret
    panic("iget: no inodes");
    80002bc2:	00006517          	auipc	a0,0x6
    80002bc6:	85650513          	addi	a0,a0,-1962 # 80008418 <etext+0x418>
    80002bca:	00003097          	auipc	ra,0x3
    80002bce:	76c080e7          	jalr	1900(ra) # 80006336 <panic>

0000000080002bd2 <fsinit>:
fsinit(int dev) {
    80002bd2:	7179                	addi	sp,sp,-48
    80002bd4:	f406                	sd	ra,40(sp)
    80002bd6:	f022                	sd	s0,32(sp)
    80002bd8:	ec26                	sd	s1,24(sp)
    80002bda:	e84a                	sd	s2,16(sp)
    80002bdc:	e44e                	sd	s3,8(sp)
    80002bde:	1800                	addi	s0,sp,48
    80002be0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002be2:	4585                	li	a1,1
    80002be4:	00000097          	auipc	ra,0x0
    80002be8:	824080e7          	jalr	-2012(ra) # 80002408 <bread>
    80002bec:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002bee:	0001b997          	auipc	s3,0x1b
    80002bf2:	51a98993          	addi	s3,s3,1306 # 8001e108 <sb>
    80002bf6:	02000613          	li	a2,32
    80002bfa:	06050593          	addi	a1,a0,96
    80002bfe:	854e                	mv	a0,s3
    80002c00:	ffffd097          	auipc	ra,0xffffd
    80002c04:	6d0080e7          	jalr	1744(ra) # 800002d0 <memmove>
  brelse(bp);
    80002c08:	8526                	mv	a0,s1
    80002c0a:	00000097          	auipc	ra,0x0
    80002c0e:	b32080e7          	jalr	-1230(ra) # 8000273c <brelse>
  if(sb.magic != FSMAGIC)
    80002c12:	0009a703          	lw	a4,0(s3)
    80002c16:	102037b7          	lui	a5,0x10203
    80002c1a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002c1e:	02f71263          	bne	a4,a5,80002c42 <fsinit+0x70>
  initlog(dev, &sb);
    80002c22:	0001b597          	auipc	a1,0x1b
    80002c26:	4e658593          	addi	a1,a1,1254 # 8001e108 <sb>
    80002c2a:	854a                	mv	a0,s2
    80002c2c:	00001097          	auipc	ra,0x1
    80002c30:	b54080e7          	jalr	-1196(ra) # 80003780 <initlog>
}
    80002c34:	70a2                	ld	ra,40(sp)
    80002c36:	7402                	ld	s0,32(sp)
    80002c38:	64e2                	ld	s1,24(sp)
    80002c3a:	6942                	ld	s2,16(sp)
    80002c3c:	69a2                	ld	s3,8(sp)
    80002c3e:	6145                	addi	sp,sp,48
    80002c40:	8082                	ret
    panic("invalid file system");
    80002c42:	00005517          	auipc	a0,0x5
    80002c46:	7e650513          	addi	a0,a0,2022 # 80008428 <etext+0x428>
    80002c4a:	00003097          	auipc	ra,0x3
    80002c4e:	6ec080e7          	jalr	1772(ra) # 80006336 <panic>

0000000080002c52 <iinit>:
{
    80002c52:	7179                	addi	sp,sp,-48
    80002c54:	f406                	sd	ra,40(sp)
    80002c56:	f022                	sd	s0,32(sp)
    80002c58:	ec26                	sd	s1,24(sp)
    80002c5a:	e84a                	sd	s2,16(sp)
    80002c5c:	e44e                	sd	s3,8(sp)
    80002c5e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002c60:	00005597          	auipc	a1,0x5
    80002c64:	7e058593          	addi	a1,a1,2016 # 80008440 <etext+0x440>
    80002c68:	0001b517          	auipc	a0,0x1b
    80002c6c:	4c050513          	addi	a0,a0,1216 # 8001e128 <itable>
    80002c70:	00004097          	auipc	ra,0x4
    80002c74:	d9e080e7          	jalr	-610(ra) # 80006a0e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002c78:	0001b497          	auipc	s1,0x1b
    80002c7c:	4e048493          	addi	s1,s1,1248 # 8001e158 <itable+0x30>
    80002c80:	0001d997          	auipc	s3,0x1d
    80002c84:	0f898993          	addi	s3,s3,248 # 8001fd78 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c88:	00005917          	auipc	s2,0x5
    80002c8c:	7c090913          	addi	s2,s2,1984 # 80008448 <etext+0x448>
    80002c90:	85ca                	mv	a1,s2
    80002c92:	8526                	mv	a0,s1
    80002c94:	00001097          	auipc	ra,0x1
    80002c98:	e40080e7          	jalr	-448(ra) # 80003ad4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002c9c:	09048493          	addi	s1,s1,144
    80002ca0:	ff3498e3          	bne	s1,s3,80002c90 <iinit+0x3e>
}
    80002ca4:	70a2                	ld	ra,40(sp)
    80002ca6:	7402                	ld	s0,32(sp)
    80002ca8:	64e2                	ld	s1,24(sp)
    80002caa:	6942                	ld	s2,16(sp)
    80002cac:	69a2                	ld	s3,8(sp)
    80002cae:	6145                	addi	sp,sp,48
    80002cb0:	8082                	ret

0000000080002cb2 <ialloc>:
{
    80002cb2:	7139                	addi	sp,sp,-64
    80002cb4:	fc06                	sd	ra,56(sp)
    80002cb6:	f822                	sd	s0,48(sp)
    80002cb8:	f426                	sd	s1,40(sp)
    80002cba:	f04a                	sd	s2,32(sp)
    80002cbc:	ec4e                	sd	s3,24(sp)
    80002cbe:	e852                	sd	s4,16(sp)
    80002cc0:	e456                	sd	s5,8(sp)
    80002cc2:	e05a                	sd	s6,0(sp)
    80002cc4:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002cc6:	0001b717          	auipc	a4,0x1b
    80002cca:	44e72703          	lw	a4,1102(a4) # 8001e114 <sb+0xc>
    80002cce:	4785                	li	a5,1
    80002cd0:	04e7f863          	bgeu	a5,a4,80002d20 <ialloc+0x6e>
    80002cd4:	8aaa                	mv	s5,a0
    80002cd6:	8b2e                	mv	s6,a1
    80002cd8:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002cda:	0001ba17          	auipc	s4,0x1b
    80002cde:	42ea0a13          	addi	s4,s4,1070 # 8001e108 <sb>
    80002ce2:	00495593          	srli	a1,s2,0x4
    80002ce6:	018a2783          	lw	a5,24(s4)
    80002cea:	9dbd                	addw	a1,a1,a5
    80002cec:	8556                	mv	a0,s5
    80002cee:	fffff097          	auipc	ra,0xfffff
    80002cf2:	71a080e7          	jalr	1818(ra) # 80002408 <bread>
    80002cf6:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002cf8:	06050993          	addi	s3,a0,96
    80002cfc:	00f97793          	andi	a5,s2,15
    80002d00:	079a                	slli	a5,a5,0x6
    80002d02:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002d04:	00099783          	lh	a5,0(s3)
    80002d08:	c785                	beqz	a5,80002d30 <ialloc+0x7e>
    brelse(bp);
    80002d0a:	00000097          	auipc	ra,0x0
    80002d0e:	a32080e7          	jalr	-1486(ra) # 8000273c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002d12:	0905                	addi	s2,s2,1
    80002d14:	00ca2703          	lw	a4,12(s4)
    80002d18:	0009079b          	sext.w	a5,s2
    80002d1c:	fce7e3e3          	bltu	a5,a4,80002ce2 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002d20:	00005517          	auipc	a0,0x5
    80002d24:	73050513          	addi	a0,a0,1840 # 80008450 <etext+0x450>
    80002d28:	00003097          	auipc	ra,0x3
    80002d2c:	60e080e7          	jalr	1550(ra) # 80006336 <panic>
      memset(dip, 0, sizeof(*dip));
    80002d30:	04000613          	li	a2,64
    80002d34:	4581                	li	a1,0
    80002d36:	854e                	mv	a0,s3
    80002d38:	ffffd097          	auipc	ra,0xffffd
    80002d3c:	53c080e7          	jalr	1340(ra) # 80000274 <memset>
      dip->type = type;
    80002d40:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002d44:	8526                	mv	a0,s1
    80002d46:	00001097          	auipc	ra,0x1
    80002d4a:	caa080e7          	jalr	-854(ra) # 800039f0 <log_write>
      brelse(bp);
    80002d4e:	8526                	mv	a0,s1
    80002d50:	00000097          	auipc	ra,0x0
    80002d54:	9ec080e7          	jalr	-1556(ra) # 8000273c <brelse>
      return iget(dev, inum);
    80002d58:	0009059b          	sext.w	a1,s2
    80002d5c:	8556                	mv	a0,s5
    80002d5e:	00000097          	auipc	ra,0x0
    80002d62:	db8080e7          	jalr	-584(ra) # 80002b16 <iget>
}
    80002d66:	70e2                	ld	ra,56(sp)
    80002d68:	7442                	ld	s0,48(sp)
    80002d6a:	74a2                	ld	s1,40(sp)
    80002d6c:	7902                	ld	s2,32(sp)
    80002d6e:	69e2                	ld	s3,24(sp)
    80002d70:	6a42                	ld	s4,16(sp)
    80002d72:	6aa2                	ld	s5,8(sp)
    80002d74:	6b02                	ld	s6,0(sp)
    80002d76:	6121                	addi	sp,sp,64
    80002d78:	8082                	ret

0000000080002d7a <iupdate>:
{
    80002d7a:	1101                	addi	sp,sp,-32
    80002d7c:	ec06                	sd	ra,24(sp)
    80002d7e:	e822                	sd	s0,16(sp)
    80002d80:	e426                	sd	s1,8(sp)
    80002d82:	e04a                	sd	s2,0(sp)
    80002d84:	1000                	addi	s0,sp,32
    80002d86:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d88:	415c                	lw	a5,4(a0)
    80002d8a:	0047d79b          	srliw	a5,a5,0x4
    80002d8e:	0001b597          	auipc	a1,0x1b
    80002d92:	3925a583          	lw	a1,914(a1) # 8001e120 <sb+0x18>
    80002d96:	9dbd                	addw	a1,a1,a5
    80002d98:	4108                	lw	a0,0(a0)
    80002d9a:	fffff097          	auipc	ra,0xfffff
    80002d9e:	66e080e7          	jalr	1646(ra) # 80002408 <bread>
    80002da2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002da4:	06050793          	addi	a5,a0,96
    80002da8:	40d8                	lw	a4,4(s1)
    80002daa:	8b3d                	andi	a4,a4,15
    80002dac:	071a                	slli	a4,a4,0x6
    80002dae:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002db0:	04c49703          	lh	a4,76(s1)
    80002db4:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002db8:	04e49703          	lh	a4,78(s1)
    80002dbc:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002dc0:	05049703          	lh	a4,80(s1)
    80002dc4:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002dc8:	05249703          	lh	a4,82(s1)
    80002dcc:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002dd0:	48f8                	lw	a4,84(s1)
    80002dd2:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002dd4:	03400613          	li	a2,52
    80002dd8:	05848593          	addi	a1,s1,88
    80002ddc:	00c78513          	addi	a0,a5,12
    80002de0:	ffffd097          	auipc	ra,0xffffd
    80002de4:	4f0080e7          	jalr	1264(ra) # 800002d0 <memmove>
  log_write(bp);
    80002de8:	854a                	mv	a0,s2
    80002dea:	00001097          	auipc	ra,0x1
    80002dee:	c06080e7          	jalr	-1018(ra) # 800039f0 <log_write>
  brelse(bp);
    80002df2:	854a                	mv	a0,s2
    80002df4:	00000097          	auipc	ra,0x0
    80002df8:	948080e7          	jalr	-1720(ra) # 8000273c <brelse>
}
    80002dfc:	60e2                	ld	ra,24(sp)
    80002dfe:	6442                	ld	s0,16(sp)
    80002e00:	64a2                	ld	s1,8(sp)
    80002e02:	6902                	ld	s2,0(sp)
    80002e04:	6105                	addi	sp,sp,32
    80002e06:	8082                	ret

0000000080002e08 <idup>:
{
    80002e08:	1101                	addi	sp,sp,-32
    80002e0a:	ec06                	sd	ra,24(sp)
    80002e0c:	e822                	sd	s0,16(sp)
    80002e0e:	e426                	sd	s1,8(sp)
    80002e10:	1000                	addi	s0,sp,32
    80002e12:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e14:	0001b517          	auipc	a0,0x1b
    80002e18:	31450513          	addi	a0,a0,788 # 8001e128 <itable>
    80002e1c:	00004097          	auipc	ra,0x4
    80002e20:	a7e080e7          	jalr	-1410(ra) # 8000689a <acquire>
  ip->ref++;
    80002e24:	449c                	lw	a5,8(s1)
    80002e26:	2785                	addiw	a5,a5,1
    80002e28:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e2a:	0001b517          	auipc	a0,0x1b
    80002e2e:	2fe50513          	addi	a0,a0,766 # 8001e128 <itable>
    80002e32:	00004097          	auipc	ra,0x4
    80002e36:	b30080e7          	jalr	-1232(ra) # 80006962 <release>
}
    80002e3a:	8526                	mv	a0,s1
    80002e3c:	60e2                	ld	ra,24(sp)
    80002e3e:	6442                	ld	s0,16(sp)
    80002e40:	64a2                	ld	s1,8(sp)
    80002e42:	6105                	addi	sp,sp,32
    80002e44:	8082                	ret

0000000080002e46 <ilock>:
{
    80002e46:	1101                	addi	sp,sp,-32
    80002e48:	ec06                	sd	ra,24(sp)
    80002e4a:	e822                	sd	s0,16(sp)
    80002e4c:	e426                	sd	s1,8(sp)
    80002e4e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002e50:	c10d                	beqz	a0,80002e72 <ilock+0x2c>
    80002e52:	84aa                	mv	s1,a0
    80002e54:	451c                	lw	a5,8(a0)
    80002e56:	00f05e63          	blez	a5,80002e72 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002e5a:	0541                	addi	a0,a0,16
    80002e5c:	00001097          	auipc	ra,0x1
    80002e60:	cb2080e7          	jalr	-846(ra) # 80003b0e <acquiresleep>
  if(ip->valid == 0){
    80002e64:	44bc                	lw	a5,72(s1)
    80002e66:	cf99                	beqz	a5,80002e84 <ilock+0x3e>
}
    80002e68:	60e2                	ld	ra,24(sp)
    80002e6a:	6442                	ld	s0,16(sp)
    80002e6c:	64a2                	ld	s1,8(sp)
    80002e6e:	6105                	addi	sp,sp,32
    80002e70:	8082                	ret
    80002e72:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002e74:	00005517          	auipc	a0,0x5
    80002e78:	5f450513          	addi	a0,a0,1524 # 80008468 <etext+0x468>
    80002e7c:	00003097          	auipc	ra,0x3
    80002e80:	4ba080e7          	jalr	1210(ra) # 80006336 <panic>
    80002e84:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e86:	40dc                	lw	a5,4(s1)
    80002e88:	0047d79b          	srliw	a5,a5,0x4
    80002e8c:	0001b597          	auipc	a1,0x1b
    80002e90:	2945a583          	lw	a1,660(a1) # 8001e120 <sb+0x18>
    80002e94:	9dbd                	addw	a1,a1,a5
    80002e96:	4088                	lw	a0,0(s1)
    80002e98:	fffff097          	auipc	ra,0xfffff
    80002e9c:	570080e7          	jalr	1392(ra) # 80002408 <bread>
    80002ea0:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ea2:	06050593          	addi	a1,a0,96
    80002ea6:	40dc                	lw	a5,4(s1)
    80002ea8:	8bbd                	andi	a5,a5,15
    80002eaa:	079a                	slli	a5,a5,0x6
    80002eac:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002eae:	00059783          	lh	a5,0(a1)
    80002eb2:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    80002eb6:	00259783          	lh	a5,2(a1)
    80002eba:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    80002ebe:	00459783          	lh	a5,4(a1)
    80002ec2:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    80002ec6:	00659783          	lh	a5,6(a1)
    80002eca:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    80002ece:	459c                	lw	a5,8(a1)
    80002ed0:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002ed2:	03400613          	li	a2,52
    80002ed6:	05b1                	addi	a1,a1,12
    80002ed8:	05848513          	addi	a0,s1,88
    80002edc:	ffffd097          	auipc	ra,0xffffd
    80002ee0:	3f4080e7          	jalr	1012(ra) # 800002d0 <memmove>
    brelse(bp);
    80002ee4:	854a                	mv	a0,s2
    80002ee6:	00000097          	auipc	ra,0x0
    80002eea:	856080e7          	jalr	-1962(ra) # 8000273c <brelse>
    ip->valid = 1;
    80002eee:	4785                	li	a5,1
    80002ef0:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    80002ef2:	04c49783          	lh	a5,76(s1)
    80002ef6:	c399                	beqz	a5,80002efc <ilock+0xb6>
    80002ef8:	6902                	ld	s2,0(sp)
    80002efa:	b7bd                	j	80002e68 <ilock+0x22>
      panic("ilock: no type");
    80002efc:	00005517          	auipc	a0,0x5
    80002f00:	57450513          	addi	a0,a0,1396 # 80008470 <etext+0x470>
    80002f04:	00003097          	auipc	ra,0x3
    80002f08:	432080e7          	jalr	1074(ra) # 80006336 <panic>

0000000080002f0c <iunlock>:
{
    80002f0c:	1101                	addi	sp,sp,-32
    80002f0e:	ec06                	sd	ra,24(sp)
    80002f10:	e822                	sd	s0,16(sp)
    80002f12:	e426                	sd	s1,8(sp)
    80002f14:	e04a                	sd	s2,0(sp)
    80002f16:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002f18:	c905                	beqz	a0,80002f48 <iunlock+0x3c>
    80002f1a:	84aa                	mv	s1,a0
    80002f1c:	01050913          	addi	s2,a0,16
    80002f20:	854a                	mv	a0,s2
    80002f22:	00001097          	auipc	ra,0x1
    80002f26:	c86080e7          	jalr	-890(ra) # 80003ba8 <holdingsleep>
    80002f2a:	cd19                	beqz	a0,80002f48 <iunlock+0x3c>
    80002f2c:	449c                	lw	a5,8(s1)
    80002f2e:	00f05d63          	blez	a5,80002f48 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002f32:	854a                	mv	a0,s2
    80002f34:	00001097          	auipc	ra,0x1
    80002f38:	c30080e7          	jalr	-976(ra) # 80003b64 <releasesleep>
}
    80002f3c:	60e2                	ld	ra,24(sp)
    80002f3e:	6442                	ld	s0,16(sp)
    80002f40:	64a2                	ld	s1,8(sp)
    80002f42:	6902                	ld	s2,0(sp)
    80002f44:	6105                	addi	sp,sp,32
    80002f46:	8082                	ret
    panic("iunlock");
    80002f48:	00005517          	auipc	a0,0x5
    80002f4c:	53850513          	addi	a0,a0,1336 # 80008480 <etext+0x480>
    80002f50:	00003097          	auipc	ra,0x3
    80002f54:	3e6080e7          	jalr	998(ra) # 80006336 <panic>

0000000080002f58 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002f58:	7179                	addi	sp,sp,-48
    80002f5a:	f406                	sd	ra,40(sp)
    80002f5c:	f022                	sd	s0,32(sp)
    80002f5e:	ec26                	sd	s1,24(sp)
    80002f60:	e84a                	sd	s2,16(sp)
    80002f62:	e44e                	sd	s3,8(sp)
    80002f64:	1800                	addi	s0,sp,48
    80002f66:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002f68:	05850493          	addi	s1,a0,88
    80002f6c:	08850913          	addi	s2,a0,136
    80002f70:	a021                	j	80002f78 <itrunc+0x20>
    80002f72:	0491                	addi	s1,s1,4
    80002f74:	01248d63          	beq	s1,s2,80002f8e <itrunc+0x36>
    if(ip->addrs[i]){
    80002f78:	408c                	lw	a1,0(s1)
    80002f7a:	dde5                	beqz	a1,80002f72 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002f7c:	0009a503          	lw	a0,0(s3)
    80002f80:	00000097          	auipc	ra,0x0
    80002f84:	910080e7          	jalr	-1776(ra) # 80002890 <bfree>
      ip->addrs[i] = 0;
    80002f88:	0004a023          	sw	zero,0(s1)
    80002f8c:	b7dd                	j	80002f72 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002f8e:	0889a583          	lw	a1,136(s3)
    80002f92:	ed99                	bnez	a1,80002fb0 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002f94:	0409aa23          	sw	zero,84(s3)
  iupdate(ip);
    80002f98:	854e                	mv	a0,s3
    80002f9a:	00000097          	auipc	ra,0x0
    80002f9e:	de0080e7          	jalr	-544(ra) # 80002d7a <iupdate>
}
    80002fa2:	70a2                	ld	ra,40(sp)
    80002fa4:	7402                	ld	s0,32(sp)
    80002fa6:	64e2                	ld	s1,24(sp)
    80002fa8:	6942                	ld	s2,16(sp)
    80002faa:	69a2                	ld	s3,8(sp)
    80002fac:	6145                	addi	sp,sp,48
    80002fae:	8082                	ret
    80002fb0:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002fb2:	0009a503          	lw	a0,0(s3)
    80002fb6:	fffff097          	auipc	ra,0xfffff
    80002fba:	452080e7          	jalr	1106(ra) # 80002408 <bread>
    80002fbe:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002fc0:	06050493          	addi	s1,a0,96
    80002fc4:	46050913          	addi	s2,a0,1120
    80002fc8:	a021                	j	80002fd0 <itrunc+0x78>
    80002fca:	0491                	addi	s1,s1,4
    80002fcc:	01248b63          	beq	s1,s2,80002fe2 <itrunc+0x8a>
      if(a[j])
    80002fd0:	408c                	lw	a1,0(s1)
    80002fd2:	dde5                	beqz	a1,80002fca <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002fd4:	0009a503          	lw	a0,0(s3)
    80002fd8:	00000097          	auipc	ra,0x0
    80002fdc:	8b8080e7          	jalr	-1864(ra) # 80002890 <bfree>
    80002fe0:	b7ed                	j	80002fca <itrunc+0x72>
    brelse(bp);
    80002fe2:	8552                	mv	a0,s4
    80002fe4:	fffff097          	auipc	ra,0xfffff
    80002fe8:	758080e7          	jalr	1880(ra) # 8000273c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002fec:	0889a583          	lw	a1,136(s3)
    80002ff0:	0009a503          	lw	a0,0(s3)
    80002ff4:	00000097          	auipc	ra,0x0
    80002ff8:	89c080e7          	jalr	-1892(ra) # 80002890 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ffc:	0809a423          	sw	zero,136(s3)
    80003000:	6a02                	ld	s4,0(sp)
    80003002:	bf49                	j	80002f94 <itrunc+0x3c>

0000000080003004 <iput>:
{
    80003004:	1101                	addi	sp,sp,-32
    80003006:	ec06                	sd	ra,24(sp)
    80003008:	e822                	sd	s0,16(sp)
    8000300a:	e426                	sd	s1,8(sp)
    8000300c:	1000                	addi	s0,sp,32
    8000300e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003010:	0001b517          	auipc	a0,0x1b
    80003014:	11850513          	addi	a0,a0,280 # 8001e128 <itable>
    80003018:	00004097          	auipc	ra,0x4
    8000301c:	882080e7          	jalr	-1918(ra) # 8000689a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003020:	4498                	lw	a4,8(s1)
    80003022:	4785                	li	a5,1
    80003024:	02f70263          	beq	a4,a5,80003048 <iput+0x44>
  ip->ref--;
    80003028:	449c                	lw	a5,8(s1)
    8000302a:	37fd                	addiw	a5,a5,-1
    8000302c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000302e:	0001b517          	auipc	a0,0x1b
    80003032:	0fa50513          	addi	a0,a0,250 # 8001e128 <itable>
    80003036:	00004097          	auipc	ra,0x4
    8000303a:	92c080e7          	jalr	-1748(ra) # 80006962 <release>
}
    8000303e:	60e2                	ld	ra,24(sp)
    80003040:	6442                	ld	s0,16(sp)
    80003042:	64a2                	ld	s1,8(sp)
    80003044:	6105                	addi	sp,sp,32
    80003046:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003048:	44bc                	lw	a5,72(s1)
    8000304a:	dff9                	beqz	a5,80003028 <iput+0x24>
    8000304c:	05249783          	lh	a5,82(s1)
    80003050:	ffe1                	bnez	a5,80003028 <iput+0x24>
    80003052:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003054:	01048913          	addi	s2,s1,16
    80003058:	854a                	mv	a0,s2
    8000305a:	00001097          	auipc	ra,0x1
    8000305e:	ab4080e7          	jalr	-1356(ra) # 80003b0e <acquiresleep>
    release(&itable.lock);
    80003062:	0001b517          	auipc	a0,0x1b
    80003066:	0c650513          	addi	a0,a0,198 # 8001e128 <itable>
    8000306a:	00004097          	auipc	ra,0x4
    8000306e:	8f8080e7          	jalr	-1800(ra) # 80006962 <release>
    itrunc(ip);
    80003072:	8526                	mv	a0,s1
    80003074:	00000097          	auipc	ra,0x0
    80003078:	ee4080e7          	jalr	-284(ra) # 80002f58 <itrunc>
    ip->type = 0;
    8000307c:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    80003080:	8526                	mv	a0,s1
    80003082:	00000097          	auipc	ra,0x0
    80003086:	cf8080e7          	jalr	-776(ra) # 80002d7a <iupdate>
    ip->valid = 0;
    8000308a:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    8000308e:	854a                	mv	a0,s2
    80003090:	00001097          	auipc	ra,0x1
    80003094:	ad4080e7          	jalr	-1324(ra) # 80003b64 <releasesleep>
    acquire(&itable.lock);
    80003098:	0001b517          	auipc	a0,0x1b
    8000309c:	09050513          	addi	a0,a0,144 # 8001e128 <itable>
    800030a0:	00003097          	auipc	ra,0x3
    800030a4:	7fa080e7          	jalr	2042(ra) # 8000689a <acquire>
    800030a8:	6902                	ld	s2,0(sp)
    800030aa:	bfbd                	j	80003028 <iput+0x24>

00000000800030ac <iunlockput>:
{
    800030ac:	1101                	addi	sp,sp,-32
    800030ae:	ec06                	sd	ra,24(sp)
    800030b0:	e822                	sd	s0,16(sp)
    800030b2:	e426                	sd	s1,8(sp)
    800030b4:	1000                	addi	s0,sp,32
    800030b6:	84aa                	mv	s1,a0
  iunlock(ip);
    800030b8:	00000097          	auipc	ra,0x0
    800030bc:	e54080e7          	jalr	-428(ra) # 80002f0c <iunlock>
  iput(ip);
    800030c0:	8526                	mv	a0,s1
    800030c2:	00000097          	auipc	ra,0x0
    800030c6:	f42080e7          	jalr	-190(ra) # 80003004 <iput>
}
    800030ca:	60e2                	ld	ra,24(sp)
    800030cc:	6442                	ld	s0,16(sp)
    800030ce:	64a2                	ld	s1,8(sp)
    800030d0:	6105                	addi	sp,sp,32
    800030d2:	8082                	ret

00000000800030d4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800030d4:	1141                	addi	sp,sp,-16
    800030d6:	e422                	sd	s0,8(sp)
    800030d8:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800030da:	411c                	lw	a5,0(a0)
    800030dc:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800030de:	415c                	lw	a5,4(a0)
    800030e0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800030e2:	04c51783          	lh	a5,76(a0)
    800030e6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800030ea:	05251783          	lh	a5,82(a0)
    800030ee:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800030f2:	05456783          	lwu	a5,84(a0)
    800030f6:	e99c                	sd	a5,16(a1)
}
    800030f8:	6422                	ld	s0,8(sp)
    800030fa:	0141                	addi	sp,sp,16
    800030fc:	8082                	ret

00000000800030fe <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030fe:	497c                	lw	a5,84(a0)
    80003100:	0ed7ef63          	bltu	a5,a3,800031fe <readi+0x100>
{
    80003104:	7159                	addi	sp,sp,-112
    80003106:	f486                	sd	ra,104(sp)
    80003108:	f0a2                	sd	s0,96(sp)
    8000310a:	eca6                	sd	s1,88(sp)
    8000310c:	fc56                	sd	s5,56(sp)
    8000310e:	f85a                	sd	s6,48(sp)
    80003110:	f45e                	sd	s7,40(sp)
    80003112:	f062                	sd	s8,32(sp)
    80003114:	1880                	addi	s0,sp,112
    80003116:	8baa                	mv	s7,a0
    80003118:	8c2e                	mv	s8,a1
    8000311a:	8ab2                	mv	s5,a2
    8000311c:	84b6                	mv	s1,a3
    8000311e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003120:	9f35                	addw	a4,a4,a3
    return 0;
    80003122:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003124:	0ad76c63          	bltu	a4,a3,800031dc <readi+0xde>
    80003128:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000312a:	00e7f463          	bgeu	a5,a4,80003132 <readi+0x34>
    n = ip->size - off;
    8000312e:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003132:	0c0b0463          	beqz	s6,800031fa <readi+0xfc>
    80003136:	e8ca                	sd	s2,80(sp)
    80003138:	e0d2                	sd	s4,64(sp)
    8000313a:	ec66                	sd	s9,24(sp)
    8000313c:	e86a                	sd	s10,16(sp)
    8000313e:	e46e                	sd	s11,8(sp)
    80003140:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003142:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003146:	5cfd                	li	s9,-1
    80003148:	a82d                	j	80003182 <readi+0x84>
    8000314a:	020a1d93          	slli	s11,s4,0x20
    8000314e:	020ddd93          	srli	s11,s11,0x20
    80003152:	06090613          	addi	a2,s2,96
    80003156:	86ee                	mv	a3,s11
    80003158:	963a                	add	a2,a2,a4
    8000315a:	85d6                	mv	a1,s5
    8000315c:	8562                	mv	a0,s8
    8000315e:	fffff097          	auipc	ra,0xfffff
    80003162:	892080e7          	jalr	-1902(ra) # 800019f0 <either_copyout>
    80003166:	05950d63          	beq	a0,s9,800031c0 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000316a:	854a                	mv	a0,s2
    8000316c:	fffff097          	auipc	ra,0xfffff
    80003170:	5d0080e7          	jalr	1488(ra) # 8000273c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003174:	013a09bb          	addw	s3,s4,s3
    80003178:	009a04bb          	addw	s1,s4,s1
    8000317c:	9aee                	add	s5,s5,s11
    8000317e:	0769f863          	bgeu	s3,s6,800031ee <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003182:	000ba903          	lw	s2,0(s7)
    80003186:	00a4d59b          	srliw	a1,s1,0xa
    8000318a:	855e                	mv	a0,s7
    8000318c:	00000097          	auipc	ra,0x0
    80003190:	8ae080e7          	jalr	-1874(ra) # 80002a3a <bmap>
    80003194:	0005059b          	sext.w	a1,a0
    80003198:	854a                	mv	a0,s2
    8000319a:	fffff097          	auipc	ra,0xfffff
    8000319e:	26e080e7          	jalr	622(ra) # 80002408 <bread>
    800031a2:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031a4:	3ff4f713          	andi	a4,s1,1023
    800031a8:	40ed07bb          	subw	a5,s10,a4
    800031ac:	413b06bb          	subw	a3,s6,s3
    800031b0:	8a3e                	mv	s4,a5
    800031b2:	2781                	sext.w	a5,a5
    800031b4:	0006861b          	sext.w	a2,a3
    800031b8:	f8f679e3          	bgeu	a2,a5,8000314a <readi+0x4c>
    800031bc:	8a36                	mv	s4,a3
    800031be:	b771                	j	8000314a <readi+0x4c>
      brelse(bp);
    800031c0:	854a                	mv	a0,s2
    800031c2:	fffff097          	auipc	ra,0xfffff
    800031c6:	57a080e7          	jalr	1402(ra) # 8000273c <brelse>
      tot = -1;
    800031ca:	59fd                	li	s3,-1
      break;
    800031cc:	6946                	ld	s2,80(sp)
    800031ce:	6a06                	ld	s4,64(sp)
    800031d0:	6ce2                	ld	s9,24(sp)
    800031d2:	6d42                	ld	s10,16(sp)
    800031d4:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800031d6:	0009851b          	sext.w	a0,s3
    800031da:	69a6                	ld	s3,72(sp)
}
    800031dc:	70a6                	ld	ra,104(sp)
    800031de:	7406                	ld	s0,96(sp)
    800031e0:	64e6                	ld	s1,88(sp)
    800031e2:	7ae2                	ld	s5,56(sp)
    800031e4:	7b42                	ld	s6,48(sp)
    800031e6:	7ba2                	ld	s7,40(sp)
    800031e8:	7c02                	ld	s8,32(sp)
    800031ea:	6165                	addi	sp,sp,112
    800031ec:	8082                	ret
    800031ee:	6946                	ld	s2,80(sp)
    800031f0:	6a06                	ld	s4,64(sp)
    800031f2:	6ce2                	ld	s9,24(sp)
    800031f4:	6d42                	ld	s10,16(sp)
    800031f6:	6da2                	ld	s11,8(sp)
    800031f8:	bff9                	j	800031d6 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800031fa:	89da                	mv	s3,s6
    800031fc:	bfe9                	j	800031d6 <readi+0xd8>
    return 0;
    800031fe:	4501                	li	a0,0
}
    80003200:	8082                	ret

0000000080003202 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003202:	497c                	lw	a5,84(a0)
    80003204:	10d7ee63          	bltu	a5,a3,80003320 <writei+0x11e>
{
    80003208:	7159                	addi	sp,sp,-112
    8000320a:	f486                	sd	ra,104(sp)
    8000320c:	f0a2                	sd	s0,96(sp)
    8000320e:	e8ca                	sd	s2,80(sp)
    80003210:	fc56                	sd	s5,56(sp)
    80003212:	f85a                	sd	s6,48(sp)
    80003214:	f45e                	sd	s7,40(sp)
    80003216:	f062                	sd	s8,32(sp)
    80003218:	1880                	addi	s0,sp,112
    8000321a:	8b2a                	mv	s6,a0
    8000321c:	8c2e                	mv	s8,a1
    8000321e:	8ab2                	mv	s5,a2
    80003220:	8936                	mv	s2,a3
    80003222:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003224:	00e687bb          	addw	a5,a3,a4
    80003228:	0ed7ee63          	bltu	a5,a3,80003324 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000322c:	00043737          	lui	a4,0x43
    80003230:	0ef76c63          	bltu	a4,a5,80003328 <writei+0x126>
    80003234:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003236:	0c0b8d63          	beqz	s7,80003310 <writei+0x10e>
    8000323a:	eca6                	sd	s1,88(sp)
    8000323c:	e4ce                	sd	s3,72(sp)
    8000323e:	ec66                	sd	s9,24(sp)
    80003240:	e86a                	sd	s10,16(sp)
    80003242:	e46e                	sd	s11,8(sp)
    80003244:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003246:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000324a:	5cfd                	li	s9,-1
    8000324c:	a091                	j	80003290 <writei+0x8e>
    8000324e:	02099d93          	slli	s11,s3,0x20
    80003252:	020ddd93          	srli	s11,s11,0x20
    80003256:	06048513          	addi	a0,s1,96
    8000325a:	86ee                	mv	a3,s11
    8000325c:	8656                	mv	a2,s5
    8000325e:	85e2                	mv	a1,s8
    80003260:	953a                	add	a0,a0,a4
    80003262:	ffffe097          	auipc	ra,0xffffe
    80003266:	7e4080e7          	jalr	2020(ra) # 80001a46 <either_copyin>
    8000326a:	07950263          	beq	a0,s9,800032ce <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000326e:	8526                	mv	a0,s1
    80003270:	00000097          	auipc	ra,0x0
    80003274:	780080e7          	jalr	1920(ra) # 800039f0 <log_write>
    brelse(bp);
    80003278:	8526                	mv	a0,s1
    8000327a:	fffff097          	auipc	ra,0xfffff
    8000327e:	4c2080e7          	jalr	1218(ra) # 8000273c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003282:	01498a3b          	addw	s4,s3,s4
    80003286:	0129893b          	addw	s2,s3,s2
    8000328a:	9aee                	add	s5,s5,s11
    8000328c:	057a7663          	bgeu	s4,s7,800032d8 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003290:	000b2483          	lw	s1,0(s6)
    80003294:	00a9559b          	srliw	a1,s2,0xa
    80003298:	855a                	mv	a0,s6
    8000329a:	fffff097          	auipc	ra,0xfffff
    8000329e:	7a0080e7          	jalr	1952(ra) # 80002a3a <bmap>
    800032a2:	0005059b          	sext.w	a1,a0
    800032a6:	8526                	mv	a0,s1
    800032a8:	fffff097          	auipc	ra,0xfffff
    800032ac:	160080e7          	jalr	352(ra) # 80002408 <bread>
    800032b0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800032b2:	3ff97713          	andi	a4,s2,1023
    800032b6:	40ed07bb          	subw	a5,s10,a4
    800032ba:	414b86bb          	subw	a3,s7,s4
    800032be:	89be                	mv	s3,a5
    800032c0:	2781                	sext.w	a5,a5
    800032c2:	0006861b          	sext.w	a2,a3
    800032c6:	f8f674e3          	bgeu	a2,a5,8000324e <writei+0x4c>
    800032ca:	89b6                	mv	s3,a3
    800032cc:	b749                	j	8000324e <writei+0x4c>
      brelse(bp);
    800032ce:	8526                	mv	a0,s1
    800032d0:	fffff097          	auipc	ra,0xfffff
    800032d4:	46c080e7          	jalr	1132(ra) # 8000273c <brelse>
  }

  if(off > ip->size)
    800032d8:	054b2783          	lw	a5,84(s6)
    800032dc:	0327fc63          	bgeu	a5,s2,80003314 <writei+0x112>
    ip->size = off;
    800032e0:	052b2a23          	sw	s2,84(s6)
    800032e4:	64e6                	ld	s1,88(sp)
    800032e6:	69a6                	ld	s3,72(sp)
    800032e8:	6ce2                	ld	s9,24(sp)
    800032ea:	6d42                	ld	s10,16(sp)
    800032ec:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800032ee:	855a                	mv	a0,s6
    800032f0:	00000097          	auipc	ra,0x0
    800032f4:	a8a080e7          	jalr	-1398(ra) # 80002d7a <iupdate>

  return tot;
    800032f8:	000a051b          	sext.w	a0,s4
    800032fc:	6a06                	ld	s4,64(sp)
}
    800032fe:	70a6                	ld	ra,104(sp)
    80003300:	7406                	ld	s0,96(sp)
    80003302:	6946                	ld	s2,80(sp)
    80003304:	7ae2                	ld	s5,56(sp)
    80003306:	7b42                	ld	s6,48(sp)
    80003308:	7ba2                	ld	s7,40(sp)
    8000330a:	7c02                	ld	s8,32(sp)
    8000330c:	6165                	addi	sp,sp,112
    8000330e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003310:	8a5e                	mv	s4,s7
    80003312:	bff1                	j	800032ee <writei+0xec>
    80003314:	64e6                	ld	s1,88(sp)
    80003316:	69a6                	ld	s3,72(sp)
    80003318:	6ce2                	ld	s9,24(sp)
    8000331a:	6d42                	ld	s10,16(sp)
    8000331c:	6da2                	ld	s11,8(sp)
    8000331e:	bfc1                	j	800032ee <writei+0xec>
    return -1;
    80003320:	557d                	li	a0,-1
}
    80003322:	8082                	ret
    return -1;
    80003324:	557d                	li	a0,-1
    80003326:	bfe1                	j	800032fe <writei+0xfc>
    return -1;
    80003328:	557d                	li	a0,-1
    8000332a:	bfd1                	j	800032fe <writei+0xfc>

000000008000332c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000332c:	1141                	addi	sp,sp,-16
    8000332e:	e406                	sd	ra,8(sp)
    80003330:	e022                	sd	s0,0(sp)
    80003332:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003334:	4639                	li	a2,14
    80003336:	ffffd097          	auipc	ra,0xffffd
    8000333a:	00e080e7          	jalr	14(ra) # 80000344 <strncmp>
}
    8000333e:	60a2                	ld	ra,8(sp)
    80003340:	6402                	ld	s0,0(sp)
    80003342:	0141                	addi	sp,sp,16
    80003344:	8082                	ret

0000000080003346 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003346:	7139                	addi	sp,sp,-64
    80003348:	fc06                	sd	ra,56(sp)
    8000334a:	f822                	sd	s0,48(sp)
    8000334c:	f426                	sd	s1,40(sp)
    8000334e:	f04a                	sd	s2,32(sp)
    80003350:	ec4e                	sd	s3,24(sp)
    80003352:	e852                	sd	s4,16(sp)
    80003354:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003356:	04c51703          	lh	a4,76(a0)
    8000335a:	4785                	li	a5,1
    8000335c:	00f71a63          	bne	a4,a5,80003370 <dirlookup+0x2a>
    80003360:	892a                	mv	s2,a0
    80003362:	89ae                	mv	s3,a1
    80003364:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003366:	497c                	lw	a5,84(a0)
    80003368:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000336a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000336c:	e79d                	bnez	a5,8000339a <dirlookup+0x54>
    8000336e:	a8a5                	j	800033e6 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003370:	00005517          	auipc	a0,0x5
    80003374:	11850513          	addi	a0,a0,280 # 80008488 <etext+0x488>
    80003378:	00003097          	auipc	ra,0x3
    8000337c:	fbe080e7          	jalr	-66(ra) # 80006336 <panic>
      panic("dirlookup read");
    80003380:	00005517          	auipc	a0,0x5
    80003384:	12050513          	addi	a0,a0,288 # 800084a0 <etext+0x4a0>
    80003388:	00003097          	auipc	ra,0x3
    8000338c:	fae080e7          	jalr	-82(ra) # 80006336 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003390:	24c1                	addiw	s1,s1,16
    80003392:	05492783          	lw	a5,84(s2)
    80003396:	04f4f763          	bgeu	s1,a5,800033e4 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000339a:	4741                	li	a4,16
    8000339c:	86a6                	mv	a3,s1
    8000339e:	fc040613          	addi	a2,s0,-64
    800033a2:	4581                	li	a1,0
    800033a4:	854a                	mv	a0,s2
    800033a6:	00000097          	auipc	ra,0x0
    800033aa:	d58080e7          	jalr	-680(ra) # 800030fe <readi>
    800033ae:	47c1                	li	a5,16
    800033b0:	fcf518e3          	bne	a0,a5,80003380 <dirlookup+0x3a>
    if(de.inum == 0)
    800033b4:	fc045783          	lhu	a5,-64(s0)
    800033b8:	dfe1                	beqz	a5,80003390 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800033ba:	fc240593          	addi	a1,s0,-62
    800033be:	854e                	mv	a0,s3
    800033c0:	00000097          	auipc	ra,0x0
    800033c4:	f6c080e7          	jalr	-148(ra) # 8000332c <namecmp>
    800033c8:	f561                	bnez	a0,80003390 <dirlookup+0x4a>
      if(poff)
    800033ca:	000a0463          	beqz	s4,800033d2 <dirlookup+0x8c>
        *poff = off;
    800033ce:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800033d2:	fc045583          	lhu	a1,-64(s0)
    800033d6:	00092503          	lw	a0,0(s2)
    800033da:	fffff097          	auipc	ra,0xfffff
    800033de:	73c080e7          	jalr	1852(ra) # 80002b16 <iget>
    800033e2:	a011                	j	800033e6 <dirlookup+0xa0>
  return 0;
    800033e4:	4501                	li	a0,0
}
    800033e6:	70e2                	ld	ra,56(sp)
    800033e8:	7442                	ld	s0,48(sp)
    800033ea:	74a2                	ld	s1,40(sp)
    800033ec:	7902                	ld	s2,32(sp)
    800033ee:	69e2                	ld	s3,24(sp)
    800033f0:	6a42                	ld	s4,16(sp)
    800033f2:	6121                	addi	sp,sp,64
    800033f4:	8082                	ret

00000000800033f6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800033f6:	711d                	addi	sp,sp,-96
    800033f8:	ec86                	sd	ra,88(sp)
    800033fa:	e8a2                	sd	s0,80(sp)
    800033fc:	e4a6                	sd	s1,72(sp)
    800033fe:	e0ca                	sd	s2,64(sp)
    80003400:	fc4e                	sd	s3,56(sp)
    80003402:	f852                	sd	s4,48(sp)
    80003404:	f456                	sd	s5,40(sp)
    80003406:	f05a                	sd	s6,32(sp)
    80003408:	ec5e                	sd	s7,24(sp)
    8000340a:	e862                	sd	s8,16(sp)
    8000340c:	e466                	sd	s9,8(sp)
    8000340e:	1080                	addi	s0,sp,96
    80003410:	84aa                	mv	s1,a0
    80003412:	8b2e                	mv	s6,a1
    80003414:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003416:	00054703          	lbu	a4,0(a0)
    8000341a:	02f00793          	li	a5,47
    8000341e:	02f70263          	beq	a4,a5,80003442 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003422:	ffffe097          	auipc	ra,0xffffe
    80003426:	b64080e7          	jalr	-1180(ra) # 80000f86 <myproc>
    8000342a:	15853503          	ld	a0,344(a0)
    8000342e:	00000097          	auipc	ra,0x0
    80003432:	9da080e7          	jalr	-1574(ra) # 80002e08 <idup>
    80003436:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003438:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000343c:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000343e:	4b85                	li	s7,1
    80003440:	a875                	j	800034fc <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003442:	4585                	li	a1,1
    80003444:	4505                	li	a0,1
    80003446:	fffff097          	auipc	ra,0xfffff
    8000344a:	6d0080e7          	jalr	1744(ra) # 80002b16 <iget>
    8000344e:	8a2a                	mv	s4,a0
    80003450:	b7e5                	j	80003438 <namex+0x42>
      iunlockput(ip);
    80003452:	8552                	mv	a0,s4
    80003454:	00000097          	auipc	ra,0x0
    80003458:	c58080e7          	jalr	-936(ra) # 800030ac <iunlockput>
      return 0;
    8000345c:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000345e:	8552                	mv	a0,s4
    80003460:	60e6                	ld	ra,88(sp)
    80003462:	6446                	ld	s0,80(sp)
    80003464:	64a6                	ld	s1,72(sp)
    80003466:	6906                	ld	s2,64(sp)
    80003468:	79e2                	ld	s3,56(sp)
    8000346a:	7a42                	ld	s4,48(sp)
    8000346c:	7aa2                	ld	s5,40(sp)
    8000346e:	7b02                	ld	s6,32(sp)
    80003470:	6be2                	ld	s7,24(sp)
    80003472:	6c42                	ld	s8,16(sp)
    80003474:	6ca2                	ld	s9,8(sp)
    80003476:	6125                	addi	sp,sp,96
    80003478:	8082                	ret
      iunlock(ip);
    8000347a:	8552                	mv	a0,s4
    8000347c:	00000097          	auipc	ra,0x0
    80003480:	a90080e7          	jalr	-1392(ra) # 80002f0c <iunlock>
      return ip;
    80003484:	bfe9                	j	8000345e <namex+0x68>
      iunlockput(ip);
    80003486:	8552                	mv	a0,s4
    80003488:	00000097          	auipc	ra,0x0
    8000348c:	c24080e7          	jalr	-988(ra) # 800030ac <iunlockput>
      return 0;
    80003490:	8a4e                	mv	s4,s3
    80003492:	b7f1                	j	8000345e <namex+0x68>
  len = path - s;
    80003494:	40998633          	sub	a2,s3,s1
    80003498:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000349c:	099c5863          	bge	s8,s9,8000352c <namex+0x136>
    memmove(name, s, DIRSIZ);
    800034a0:	4639                	li	a2,14
    800034a2:	85a6                	mv	a1,s1
    800034a4:	8556                	mv	a0,s5
    800034a6:	ffffd097          	auipc	ra,0xffffd
    800034aa:	e2a080e7          	jalr	-470(ra) # 800002d0 <memmove>
    800034ae:	84ce                	mv	s1,s3
  while(*path == '/')
    800034b0:	0004c783          	lbu	a5,0(s1)
    800034b4:	01279763          	bne	a5,s2,800034c2 <namex+0xcc>
    path++;
    800034b8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800034ba:	0004c783          	lbu	a5,0(s1)
    800034be:	ff278de3          	beq	a5,s2,800034b8 <namex+0xc2>
    ilock(ip);
    800034c2:	8552                	mv	a0,s4
    800034c4:	00000097          	auipc	ra,0x0
    800034c8:	982080e7          	jalr	-1662(ra) # 80002e46 <ilock>
    if(ip->type != T_DIR){
    800034cc:	04ca1783          	lh	a5,76(s4)
    800034d0:	f97791e3          	bne	a5,s7,80003452 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800034d4:	000b0563          	beqz	s6,800034de <namex+0xe8>
    800034d8:	0004c783          	lbu	a5,0(s1)
    800034dc:	dfd9                	beqz	a5,8000347a <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800034de:	4601                	li	a2,0
    800034e0:	85d6                	mv	a1,s5
    800034e2:	8552                	mv	a0,s4
    800034e4:	00000097          	auipc	ra,0x0
    800034e8:	e62080e7          	jalr	-414(ra) # 80003346 <dirlookup>
    800034ec:	89aa                	mv	s3,a0
    800034ee:	dd41                	beqz	a0,80003486 <namex+0x90>
    iunlockput(ip);
    800034f0:	8552                	mv	a0,s4
    800034f2:	00000097          	auipc	ra,0x0
    800034f6:	bba080e7          	jalr	-1094(ra) # 800030ac <iunlockput>
    ip = next;
    800034fa:	8a4e                	mv	s4,s3
  while(*path == '/')
    800034fc:	0004c783          	lbu	a5,0(s1)
    80003500:	01279763          	bne	a5,s2,8000350e <namex+0x118>
    path++;
    80003504:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003506:	0004c783          	lbu	a5,0(s1)
    8000350a:	ff278de3          	beq	a5,s2,80003504 <namex+0x10e>
  if(*path == 0)
    8000350e:	cb9d                	beqz	a5,80003544 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003510:	0004c783          	lbu	a5,0(s1)
    80003514:	89a6                	mv	s3,s1
  len = path - s;
    80003516:	4c81                	li	s9,0
    80003518:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000351a:	01278963          	beq	a5,s2,8000352c <namex+0x136>
    8000351e:	dbbd                	beqz	a5,80003494 <namex+0x9e>
    path++;
    80003520:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003522:	0009c783          	lbu	a5,0(s3)
    80003526:	ff279ce3          	bne	a5,s2,8000351e <namex+0x128>
    8000352a:	b7ad                	j	80003494 <namex+0x9e>
    memmove(name, s, len);
    8000352c:	2601                	sext.w	a2,a2
    8000352e:	85a6                	mv	a1,s1
    80003530:	8556                	mv	a0,s5
    80003532:	ffffd097          	auipc	ra,0xffffd
    80003536:	d9e080e7          	jalr	-610(ra) # 800002d0 <memmove>
    name[len] = 0;
    8000353a:	9cd6                	add	s9,s9,s5
    8000353c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003540:	84ce                	mv	s1,s3
    80003542:	b7bd                	j	800034b0 <namex+0xba>
  if(nameiparent){
    80003544:	f00b0de3          	beqz	s6,8000345e <namex+0x68>
    iput(ip);
    80003548:	8552                	mv	a0,s4
    8000354a:	00000097          	auipc	ra,0x0
    8000354e:	aba080e7          	jalr	-1350(ra) # 80003004 <iput>
    return 0;
    80003552:	4a01                	li	s4,0
    80003554:	b729                	j	8000345e <namex+0x68>

0000000080003556 <dirlink>:
{
    80003556:	7139                	addi	sp,sp,-64
    80003558:	fc06                	sd	ra,56(sp)
    8000355a:	f822                	sd	s0,48(sp)
    8000355c:	f04a                	sd	s2,32(sp)
    8000355e:	ec4e                	sd	s3,24(sp)
    80003560:	e852                	sd	s4,16(sp)
    80003562:	0080                	addi	s0,sp,64
    80003564:	892a                	mv	s2,a0
    80003566:	8a2e                	mv	s4,a1
    80003568:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000356a:	4601                	li	a2,0
    8000356c:	00000097          	auipc	ra,0x0
    80003570:	dda080e7          	jalr	-550(ra) # 80003346 <dirlookup>
    80003574:	ed25                	bnez	a0,800035ec <dirlink+0x96>
    80003576:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003578:	05492483          	lw	s1,84(s2)
    8000357c:	c49d                	beqz	s1,800035aa <dirlink+0x54>
    8000357e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003580:	4741                	li	a4,16
    80003582:	86a6                	mv	a3,s1
    80003584:	fc040613          	addi	a2,s0,-64
    80003588:	4581                	li	a1,0
    8000358a:	854a                	mv	a0,s2
    8000358c:	00000097          	auipc	ra,0x0
    80003590:	b72080e7          	jalr	-1166(ra) # 800030fe <readi>
    80003594:	47c1                	li	a5,16
    80003596:	06f51163          	bne	a0,a5,800035f8 <dirlink+0xa2>
    if(de.inum == 0)
    8000359a:	fc045783          	lhu	a5,-64(s0)
    8000359e:	c791                	beqz	a5,800035aa <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800035a0:	24c1                	addiw	s1,s1,16
    800035a2:	05492783          	lw	a5,84(s2)
    800035a6:	fcf4ede3          	bltu	s1,a5,80003580 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800035aa:	4639                	li	a2,14
    800035ac:	85d2                	mv	a1,s4
    800035ae:	fc240513          	addi	a0,s0,-62
    800035b2:	ffffd097          	auipc	ra,0xffffd
    800035b6:	dc8080e7          	jalr	-568(ra) # 8000037a <strncpy>
  de.inum = inum;
    800035ba:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035be:	4741                	li	a4,16
    800035c0:	86a6                	mv	a3,s1
    800035c2:	fc040613          	addi	a2,s0,-64
    800035c6:	4581                	li	a1,0
    800035c8:	854a                	mv	a0,s2
    800035ca:	00000097          	auipc	ra,0x0
    800035ce:	c38080e7          	jalr	-968(ra) # 80003202 <writei>
    800035d2:	872a                	mv	a4,a0
    800035d4:	47c1                	li	a5,16
  return 0;
    800035d6:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035d8:	02f71863          	bne	a4,a5,80003608 <dirlink+0xb2>
    800035dc:	74a2                	ld	s1,40(sp)
}
    800035de:	70e2                	ld	ra,56(sp)
    800035e0:	7442                	ld	s0,48(sp)
    800035e2:	7902                	ld	s2,32(sp)
    800035e4:	69e2                	ld	s3,24(sp)
    800035e6:	6a42                	ld	s4,16(sp)
    800035e8:	6121                	addi	sp,sp,64
    800035ea:	8082                	ret
    iput(ip);
    800035ec:	00000097          	auipc	ra,0x0
    800035f0:	a18080e7          	jalr	-1512(ra) # 80003004 <iput>
    return -1;
    800035f4:	557d                	li	a0,-1
    800035f6:	b7e5                	j	800035de <dirlink+0x88>
      panic("dirlink read");
    800035f8:	00005517          	auipc	a0,0x5
    800035fc:	eb850513          	addi	a0,a0,-328 # 800084b0 <etext+0x4b0>
    80003600:	00003097          	auipc	ra,0x3
    80003604:	d36080e7          	jalr	-714(ra) # 80006336 <panic>
    panic("dirlink");
    80003608:	00005517          	auipc	a0,0x5
    8000360c:	fb850513          	addi	a0,a0,-72 # 800085c0 <etext+0x5c0>
    80003610:	00003097          	auipc	ra,0x3
    80003614:	d26080e7          	jalr	-730(ra) # 80006336 <panic>

0000000080003618 <namei>:

struct inode*
namei(char *path)
{
    80003618:	1101                	addi	sp,sp,-32
    8000361a:	ec06                	sd	ra,24(sp)
    8000361c:	e822                	sd	s0,16(sp)
    8000361e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003620:	fe040613          	addi	a2,s0,-32
    80003624:	4581                	li	a1,0
    80003626:	00000097          	auipc	ra,0x0
    8000362a:	dd0080e7          	jalr	-560(ra) # 800033f6 <namex>
}
    8000362e:	60e2                	ld	ra,24(sp)
    80003630:	6442                	ld	s0,16(sp)
    80003632:	6105                	addi	sp,sp,32
    80003634:	8082                	ret

0000000080003636 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003636:	1141                	addi	sp,sp,-16
    80003638:	e406                	sd	ra,8(sp)
    8000363a:	e022                	sd	s0,0(sp)
    8000363c:	0800                	addi	s0,sp,16
    8000363e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003640:	4585                	li	a1,1
    80003642:	00000097          	auipc	ra,0x0
    80003646:	db4080e7          	jalr	-588(ra) # 800033f6 <namex>
}
    8000364a:	60a2                	ld	ra,8(sp)
    8000364c:	6402                	ld	s0,0(sp)
    8000364e:	0141                	addi	sp,sp,16
    80003650:	8082                	ret

0000000080003652 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003652:	1101                	addi	sp,sp,-32
    80003654:	ec06                	sd	ra,24(sp)
    80003656:	e822                	sd	s0,16(sp)
    80003658:	e426                	sd	s1,8(sp)
    8000365a:	e04a                	sd	s2,0(sp)
    8000365c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000365e:	0001c917          	auipc	s2,0x1c
    80003662:	70a90913          	addi	s2,s2,1802 # 8001fd68 <log>
    80003666:	02092583          	lw	a1,32(s2)
    8000366a:	03092503          	lw	a0,48(s2)
    8000366e:	fffff097          	auipc	ra,0xfffff
    80003672:	d9a080e7          	jalr	-614(ra) # 80002408 <bread>
    80003676:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003678:	03492603          	lw	a2,52(s2)
    8000367c:	d130                	sw	a2,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000367e:	00c05f63          	blez	a2,8000369c <write_head+0x4a>
    80003682:	0001c717          	auipc	a4,0x1c
    80003686:	71e70713          	addi	a4,a4,1822 # 8001fda0 <log+0x38>
    8000368a:	87aa                	mv	a5,a0
    8000368c:	060a                	slli	a2,a2,0x2
    8000368e:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003690:	4314                	lw	a3,0(a4)
    80003692:	d3f4                	sw	a3,100(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003694:	0711                	addi	a4,a4,4
    80003696:	0791                	addi	a5,a5,4
    80003698:	fec79ce3          	bne	a5,a2,80003690 <write_head+0x3e>
  }
  bwrite(buf);
    8000369c:	8526                	mv	a0,s1
    8000369e:	fffff097          	auipc	ra,0xfffff
    800036a2:	060080e7          	jalr	96(ra) # 800026fe <bwrite>
  brelse(buf);
    800036a6:	8526                	mv	a0,s1
    800036a8:	fffff097          	auipc	ra,0xfffff
    800036ac:	094080e7          	jalr	148(ra) # 8000273c <brelse>
}
    800036b0:	60e2                	ld	ra,24(sp)
    800036b2:	6442                	ld	s0,16(sp)
    800036b4:	64a2                	ld	s1,8(sp)
    800036b6:	6902                	ld	s2,0(sp)
    800036b8:	6105                	addi	sp,sp,32
    800036ba:	8082                	ret

00000000800036bc <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800036bc:	0001c797          	auipc	a5,0x1c
    800036c0:	6e07a783          	lw	a5,1760(a5) # 8001fd9c <log+0x34>
    800036c4:	0af05d63          	blez	a5,8000377e <install_trans+0xc2>
{
    800036c8:	7139                	addi	sp,sp,-64
    800036ca:	fc06                	sd	ra,56(sp)
    800036cc:	f822                	sd	s0,48(sp)
    800036ce:	f426                	sd	s1,40(sp)
    800036d0:	f04a                	sd	s2,32(sp)
    800036d2:	ec4e                	sd	s3,24(sp)
    800036d4:	e852                	sd	s4,16(sp)
    800036d6:	e456                	sd	s5,8(sp)
    800036d8:	e05a                	sd	s6,0(sp)
    800036da:	0080                	addi	s0,sp,64
    800036dc:	8b2a                	mv	s6,a0
    800036de:	0001ca97          	auipc	s5,0x1c
    800036e2:	6c2a8a93          	addi	s5,s5,1730 # 8001fda0 <log+0x38>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036e6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036e8:	0001c997          	auipc	s3,0x1c
    800036ec:	68098993          	addi	s3,s3,1664 # 8001fd68 <log>
    800036f0:	a00d                	j	80003712 <install_trans+0x56>
    brelse(lbuf);
    800036f2:	854a                	mv	a0,s2
    800036f4:	fffff097          	auipc	ra,0xfffff
    800036f8:	048080e7          	jalr	72(ra) # 8000273c <brelse>
    brelse(dbuf);
    800036fc:	8526                	mv	a0,s1
    800036fe:	fffff097          	auipc	ra,0xfffff
    80003702:	03e080e7          	jalr	62(ra) # 8000273c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003706:	2a05                	addiw	s4,s4,1
    80003708:	0a91                	addi	s5,s5,4
    8000370a:	0349a783          	lw	a5,52(s3)
    8000370e:	04fa5e63          	bge	s4,a5,8000376a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003712:	0209a583          	lw	a1,32(s3)
    80003716:	014585bb          	addw	a1,a1,s4
    8000371a:	2585                	addiw	a1,a1,1
    8000371c:	0309a503          	lw	a0,48(s3)
    80003720:	fffff097          	auipc	ra,0xfffff
    80003724:	ce8080e7          	jalr	-792(ra) # 80002408 <bread>
    80003728:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000372a:	000aa583          	lw	a1,0(s5)
    8000372e:	0309a503          	lw	a0,48(s3)
    80003732:	fffff097          	auipc	ra,0xfffff
    80003736:	cd6080e7          	jalr	-810(ra) # 80002408 <bread>
    8000373a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000373c:	40000613          	li	a2,1024
    80003740:	06090593          	addi	a1,s2,96
    80003744:	06050513          	addi	a0,a0,96
    80003748:	ffffd097          	auipc	ra,0xffffd
    8000374c:	b88080e7          	jalr	-1144(ra) # 800002d0 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003750:	8526                	mv	a0,s1
    80003752:	fffff097          	auipc	ra,0xfffff
    80003756:	fac080e7          	jalr	-84(ra) # 800026fe <bwrite>
    if(recovering == 0)
    8000375a:	f80b1ce3          	bnez	s6,800036f2 <install_trans+0x36>
      bunpin(dbuf);
    8000375e:	8526                	mv	a0,s1
    80003760:	fffff097          	auipc	ra,0xfffff
    80003764:	0d4080e7          	jalr	212(ra) # 80002834 <bunpin>
    80003768:	b769                	j	800036f2 <install_trans+0x36>
}
    8000376a:	70e2                	ld	ra,56(sp)
    8000376c:	7442                	ld	s0,48(sp)
    8000376e:	74a2                	ld	s1,40(sp)
    80003770:	7902                	ld	s2,32(sp)
    80003772:	69e2                	ld	s3,24(sp)
    80003774:	6a42                	ld	s4,16(sp)
    80003776:	6aa2                	ld	s5,8(sp)
    80003778:	6b02                	ld	s6,0(sp)
    8000377a:	6121                	addi	sp,sp,64
    8000377c:	8082                	ret
    8000377e:	8082                	ret

0000000080003780 <initlog>:
{
    80003780:	7179                	addi	sp,sp,-48
    80003782:	f406                	sd	ra,40(sp)
    80003784:	f022                	sd	s0,32(sp)
    80003786:	ec26                	sd	s1,24(sp)
    80003788:	e84a                	sd	s2,16(sp)
    8000378a:	e44e                	sd	s3,8(sp)
    8000378c:	1800                	addi	s0,sp,48
    8000378e:	892a                	mv	s2,a0
    80003790:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003792:	0001c497          	auipc	s1,0x1c
    80003796:	5d648493          	addi	s1,s1,1494 # 8001fd68 <log>
    8000379a:	00005597          	auipc	a1,0x5
    8000379e:	d2658593          	addi	a1,a1,-730 # 800084c0 <etext+0x4c0>
    800037a2:	8526                	mv	a0,s1
    800037a4:	00003097          	auipc	ra,0x3
    800037a8:	26a080e7          	jalr	618(ra) # 80006a0e <initlock>
  log.start = sb->logstart;
    800037ac:	0149a583          	lw	a1,20(s3)
    800037b0:	d08c                	sw	a1,32(s1)
  log.size = sb->nlog;
    800037b2:	0109a783          	lw	a5,16(s3)
    800037b6:	d0dc                	sw	a5,36(s1)
  log.dev = dev;
    800037b8:	0324a823          	sw	s2,48(s1)
  struct buf *buf = bread(log.dev, log.start);
    800037bc:	854a                	mv	a0,s2
    800037be:	fffff097          	auipc	ra,0xfffff
    800037c2:	c4a080e7          	jalr	-950(ra) # 80002408 <bread>
  log.lh.n = lh->n;
    800037c6:	5130                	lw	a2,96(a0)
    800037c8:	d8d0                	sw	a2,52(s1)
  for (i = 0; i < log.lh.n; i++) {
    800037ca:	00c05f63          	blez	a2,800037e8 <initlog+0x68>
    800037ce:	87aa                	mv	a5,a0
    800037d0:	0001c717          	auipc	a4,0x1c
    800037d4:	5d070713          	addi	a4,a4,1488 # 8001fda0 <log+0x38>
    800037d8:	060a                	slli	a2,a2,0x2
    800037da:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800037dc:	53f4                	lw	a3,100(a5)
    800037de:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800037e0:	0791                	addi	a5,a5,4
    800037e2:	0711                	addi	a4,a4,4
    800037e4:	fec79ce3          	bne	a5,a2,800037dc <initlog+0x5c>
  brelse(buf);
    800037e8:	fffff097          	auipc	ra,0xfffff
    800037ec:	f54080e7          	jalr	-172(ra) # 8000273c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800037f0:	4505                	li	a0,1
    800037f2:	00000097          	auipc	ra,0x0
    800037f6:	eca080e7          	jalr	-310(ra) # 800036bc <install_trans>
  log.lh.n = 0;
    800037fa:	0001c797          	auipc	a5,0x1c
    800037fe:	5a07a123          	sw	zero,1442(a5) # 8001fd9c <log+0x34>
  write_head(); // clear the log
    80003802:	00000097          	auipc	ra,0x0
    80003806:	e50080e7          	jalr	-432(ra) # 80003652 <write_head>
}
    8000380a:	70a2                	ld	ra,40(sp)
    8000380c:	7402                	ld	s0,32(sp)
    8000380e:	64e2                	ld	s1,24(sp)
    80003810:	6942                	ld	s2,16(sp)
    80003812:	69a2                	ld	s3,8(sp)
    80003814:	6145                	addi	sp,sp,48
    80003816:	8082                	ret

0000000080003818 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003818:	1101                	addi	sp,sp,-32
    8000381a:	ec06                	sd	ra,24(sp)
    8000381c:	e822                	sd	s0,16(sp)
    8000381e:	e426                	sd	s1,8(sp)
    80003820:	e04a                	sd	s2,0(sp)
    80003822:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003824:	0001c517          	auipc	a0,0x1c
    80003828:	54450513          	addi	a0,a0,1348 # 8001fd68 <log>
    8000382c:	00003097          	auipc	ra,0x3
    80003830:	06e080e7          	jalr	110(ra) # 8000689a <acquire>
  while(1){
    if(log.committing){
    80003834:	0001c497          	auipc	s1,0x1c
    80003838:	53448493          	addi	s1,s1,1332 # 8001fd68 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000383c:	4979                	li	s2,30
    8000383e:	a039                	j	8000384c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003840:	85a6                	mv	a1,s1
    80003842:	8526                	mv	a0,s1
    80003844:	ffffe097          	auipc	ra,0xffffe
    80003848:	e08080e7          	jalr	-504(ra) # 8000164c <sleep>
    if(log.committing){
    8000384c:	54dc                	lw	a5,44(s1)
    8000384e:	fbed                	bnez	a5,80003840 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003850:	5498                	lw	a4,40(s1)
    80003852:	2705                	addiw	a4,a4,1
    80003854:	0027179b          	slliw	a5,a4,0x2
    80003858:	9fb9                	addw	a5,a5,a4
    8000385a:	0017979b          	slliw	a5,a5,0x1
    8000385e:	58d4                	lw	a3,52(s1)
    80003860:	9fb5                	addw	a5,a5,a3
    80003862:	00f95963          	bge	s2,a5,80003874 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003866:	85a6                	mv	a1,s1
    80003868:	8526                	mv	a0,s1
    8000386a:	ffffe097          	auipc	ra,0xffffe
    8000386e:	de2080e7          	jalr	-542(ra) # 8000164c <sleep>
    80003872:	bfe9                	j	8000384c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003874:	0001c517          	auipc	a0,0x1c
    80003878:	4f450513          	addi	a0,a0,1268 # 8001fd68 <log>
    8000387c:	d518                	sw	a4,40(a0)
      release(&log.lock);
    8000387e:	00003097          	auipc	ra,0x3
    80003882:	0e4080e7          	jalr	228(ra) # 80006962 <release>
      break;
    }
  }
}
    80003886:	60e2                	ld	ra,24(sp)
    80003888:	6442                	ld	s0,16(sp)
    8000388a:	64a2                	ld	s1,8(sp)
    8000388c:	6902                	ld	s2,0(sp)
    8000388e:	6105                	addi	sp,sp,32
    80003890:	8082                	ret

0000000080003892 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003892:	7139                	addi	sp,sp,-64
    80003894:	fc06                	sd	ra,56(sp)
    80003896:	f822                	sd	s0,48(sp)
    80003898:	f426                	sd	s1,40(sp)
    8000389a:	f04a                	sd	s2,32(sp)
    8000389c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000389e:	0001c497          	auipc	s1,0x1c
    800038a2:	4ca48493          	addi	s1,s1,1226 # 8001fd68 <log>
    800038a6:	8526                	mv	a0,s1
    800038a8:	00003097          	auipc	ra,0x3
    800038ac:	ff2080e7          	jalr	-14(ra) # 8000689a <acquire>
  log.outstanding -= 1;
    800038b0:	549c                	lw	a5,40(s1)
    800038b2:	37fd                	addiw	a5,a5,-1
    800038b4:	0007891b          	sext.w	s2,a5
    800038b8:	d49c                	sw	a5,40(s1)
  if(log.committing)
    800038ba:	54dc                	lw	a5,44(s1)
    800038bc:	e7b9                	bnez	a5,8000390a <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    800038be:	06091163          	bnez	s2,80003920 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800038c2:	0001c497          	auipc	s1,0x1c
    800038c6:	4a648493          	addi	s1,s1,1190 # 8001fd68 <log>
    800038ca:	4785                	li	a5,1
    800038cc:	d4dc                	sw	a5,44(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800038ce:	8526                	mv	a0,s1
    800038d0:	00003097          	auipc	ra,0x3
    800038d4:	092080e7          	jalr	146(ra) # 80006962 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800038d8:	58dc                	lw	a5,52(s1)
    800038da:	06f04763          	bgtz	a5,80003948 <end_op+0xb6>
    acquire(&log.lock);
    800038de:	0001c497          	auipc	s1,0x1c
    800038e2:	48a48493          	addi	s1,s1,1162 # 8001fd68 <log>
    800038e6:	8526                	mv	a0,s1
    800038e8:	00003097          	auipc	ra,0x3
    800038ec:	fb2080e7          	jalr	-78(ra) # 8000689a <acquire>
    log.committing = 0;
    800038f0:	0204a623          	sw	zero,44(s1)
    wakeup(&log);
    800038f4:	8526                	mv	a0,s1
    800038f6:	ffffe097          	auipc	ra,0xffffe
    800038fa:	ee2080e7          	jalr	-286(ra) # 800017d8 <wakeup>
    release(&log.lock);
    800038fe:	8526                	mv	a0,s1
    80003900:	00003097          	auipc	ra,0x3
    80003904:	062080e7          	jalr	98(ra) # 80006962 <release>
}
    80003908:	a815                	j	8000393c <end_op+0xaa>
    8000390a:	ec4e                	sd	s3,24(sp)
    8000390c:	e852                	sd	s4,16(sp)
    8000390e:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003910:	00005517          	auipc	a0,0x5
    80003914:	bb850513          	addi	a0,a0,-1096 # 800084c8 <etext+0x4c8>
    80003918:	00003097          	auipc	ra,0x3
    8000391c:	a1e080e7          	jalr	-1506(ra) # 80006336 <panic>
    wakeup(&log);
    80003920:	0001c497          	auipc	s1,0x1c
    80003924:	44848493          	addi	s1,s1,1096 # 8001fd68 <log>
    80003928:	8526                	mv	a0,s1
    8000392a:	ffffe097          	auipc	ra,0xffffe
    8000392e:	eae080e7          	jalr	-338(ra) # 800017d8 <wakeup>
  release(&log.lock);
    80003932:	8526                	mv	a0,s1
    80003934:	00003097          	auipc	ra,0x3
    80003938:	02e080e7          	jalr	46(ra) # 80006962 <release>
}
    8000393c:	70e2                	ld	ra,56(sp)
    8000393e:	7442                	ld	s0,48(sp)
    80003940:	74a2                	ld	s1,40(sp)
    80003942:	7902                	ld	s2,32(sp)
    80003944:	6121                	addi	sp,sp,64
    80003946:	8082                	ret
    80003948:	ec4e                	sd	s3,24(sp)
    8000394a:	e852                	sd	s4,16(sp)
    8000394c:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000394e:	0001ca97          	auipc	s5,0x1c
    80003952:	452a8a93          	addi	s5,s5,1106 # 8001fda0 <log+0x38>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003956:	0001ca17          	auipc	s4,0x1c
    8000395a:	412a0a13          	addi	s4,s4,1042 # 8001fd68 <log>
    8000395e:	020a2583          	lw	a1,32(s4)
    80003962:	012585bb          	addw	a1,a1,s2
    80003966:	2585                	addiw	a1,a1,1
    80003968:	030a2503          	lw	a0,48(s4)
    8000396c:	fffff097          	auipc	ra,0xfffff
    80003970:	a9c080e7          	jalr	-1380(ra) # 80002408 <bread>
    80003974:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003976:	000aa583          	lw	a1,0(s5)
    8000397a:	030a2503          	lw	a0,48(s4)
    8000397e:	fffff097          	auipc	ra,0xfffff
    80003982:	a8a080e7          	jalr	-1398(ra) # 80002408 <bread>
    80003986:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003988:	40000613          	li	a2,1024
    8000398c:	06050593          	addi	a1,a0,96
    80003990:	06048513          	addi	a0,s1,96
    80003994:	ffffd097          	auipc	ra,0xffffd
    80003998:	93c080e7          	jalr	-1732(ra) # 800002d0 <memmove>
    bwrite(to);  // write the log
    8000399c:	8526                	mv	a0,s1
    8000399e:	fffff097          	auipc	ra,0xfffff
    800039a2:	d60080e7          	jalr	-672(ra) # 800026fe <bwrite>
    brelse(from);
    800039a6:	854e                	mv	a0,s3
    800039a8:	fffff097          	auipc	ra,0xfffff
    800039ac:	d94080e7          	jalr	-620(ra) # 8000273c <brelse>
    brelse(to);
    800039b0:	8526                	mv	a0,s1
    800039b2:	fffff097          	auipc	ra,0xfffff
    800039b6:	d8a080e7          	jalr	-630(ra) # 8000273c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800039ba:	2905                	addiw	s2,s2,1
    800039bc:	0a91                	addi	s5,s5,4
    800039be:	034a2783          	lw	a5,52(s4)
    800039c2:	f8f94ee3          	blt	s2,a5,8000395e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800039c6:	00000097          	auipc	ra,0x0
    800039ca:	c8c080e7          	jalr	-884(ra) # 80003652 <write_head>
    install_trans(0); // Now install writes to home locations
    800039ce:	4501                	li	a0,0
    800039d0:	00000097          	auipc	ra,0x0
    800039d4:	cec080e7          	jalr	-788(ra) # 800036bc <install_trans>
    log.lh.n = 0;
    800039d8:	0001c797          	auipc	a5,0x1c
    800039dc:	3c07a223          	sw	zero,964(a5) # 8001fd9c <log+0x34>
    write_head();    // Erase the transaction from the log
    800039e0:	00000097          	auipc	ra,0x0
    800039e4:	c72080e7          	jalr	-910(ra) # 80003652 <write_head>
    800039e8:	69e2                	ld	s3,24(sp)
    800039ea:	6a42                	ld	s4,16(sp)
    800039ec:	6aa2                	ld	s5,8(sp)
    800039ee:	bdc5                	j	800038de <end_op+0x4c>

00000000800039f0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800039f0:	1101                	addi	sp,sp,-32
    800039f2:	ec06                	sd	ra,24(sp)
    800039f4:	e822                	sd	s0,16(sp)
    800039f6:	e426                	sd	s1,8(sp)
    800039f8:	e04a                	sd	s2,0(sp)
    800039fa:	1000                	addi	s0,sp,32
    800039fc:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800039fe:	0001c917          	auipc	s2,0x1c
    80003a02:	36a90913          	addi	s2,s2,874 # 8001fd68 <log>
    80003a06:	854a                	mv	a0,s2
    80003a08:	00003097          	auipc	ra,0x3
    80003a0c:	e92080e7          	jalr	-366(ra) # 8000689a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003a10:	03492603          	lw	a2,52(s2)
    80003a14:	47f5                	li	a5,29
    80003a16:	06c7c563          	blt	a5,a2,80003a80 <log_write+0x90>
    80003a1a:	0001c797          	auipc	a5,0x1c
    80003a1e:	3727a783          	lw	a5,882(a5) # 8001fd8c <log+0x24>
    80003a22:	37fd                	addiw	a5,a5,-1
    80003a24:	04f65e63          	bge	a2,a5,80003a80 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003a28:	0001c797          	auipc	a5,0x1c
    80003a2c:	3687a783          	lw	a5,872(a5) # 8001fd90 <log+0x28>
    80003a30:	06f05063          	blez	a5,80003a90 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003a34:	4781                	li	a5,0
    80003a36:	06c05563          	blez	a2,80003aa0 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a3a:	44cc                	lw	a1,12(s1)
    80003a3c:	0001c717          	auipc	a4,0x1c
    80003a40:	36470713          	addi	a4,a4,868 # 8001fda0 <log+0x38>
  for (i = 0; i < log.lh.n; i++) {
    80003a44:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a46:	4314                	lw	a3,0(a4)
    80003a48:	04b68c63          	beq	a3,a1,80003aa0 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003a4c:	2785                	addiw	a5,a5,1
    80003a4e:	0711                	addi	a4,a4,4
    80003a50:	fef61be3          	bne	a2,a5,80003a46 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003a54:	0631                	addi	a2,a2,12
    80003a56:	060a                	slli	a2,a2,0x2
    80003a58:	0001c797          	auipc	a5,0x1c
    80003a5c:	31078793          	addi	a5,a5,784 # 8001fd68 <log>
    80003a60:	97b2                	add	a5,a5,a2
    80003a62:	44d8                	lw	a4,12(s1)
    80003a64:	c798                	sw	a4,8(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003a66:	8526                	mv	a0,s1
    80003a68:	fffff097          	auipc	ra,0xfffff
    80003a6c:	d70080e7          	jalr	-656(ra) # 800027d8 <bpin>
    log.lh.n++;
    80003a70:	0001c717          	auipc	a4,0x1c
    80003a74:	2f870713          	addi	a4,a4,760 # 8001fd68 <log>
    80003a78:	5b5c                	lw	a5,52(a4)
    80003a7a:	2785                	addiw	a5,a5,1
    80003a7c:	db5c                	sw	a5,52(a4)
    80003a7e:	a82d                	j	80003ab8 <log_write+0xc8>
    panic("too big a transaction");
    80003a80:	00005517          	auipc	a0,0x5
    80003a84:	a5850513          	addi	a0,a0,-1448 # 800084d8 <etext+0x4d8>
    80003a88:	00003097          	auipc	ra,0x3
    80003a8c:	8ae080e7          	jalr	-1874(ra) # 80006336 <panic>
    panic("log_write outside of trans");
    80003a90:	00005517          	auipc	a0,0x5
    80003a94:	a6050513          	addi	a0,a0,-1440 # 800084f0 <etext+0x4f0>
    80003a98:	00003097          	auipc	ra,0x3
    80003a9c:	89e080e7          	jalr	-1890(ra) # 80006336 <panic>
  log.lh.block[i] = b->blockno;
    80003aa0:	00c78693          	addi	a3,a5,12
    80003aa4:	068a                	slli	a3,a3,0x2
    80003aa6:	0001c717          	auipc	a4,0x1c
    80003aaa:	2c270713          	addi	a4,a4,706 # 8001fd68 <log>
    80003aae:	9736                	add	a4,a4,a3
    80003ab0:	44d4                	lw	a3,12(s1)
    80003ab2:	c714                	sw	a3,8(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003ab4:	faf609e3          	beq	a2,a5,80003a66 <log_write+0x76>
  }
  release(&log.lock);
    80003ab8:	0001c517          	auipc	a0,0x1c
    80003abc:	2b050513          	addi	a0,a0,688 # 8001fd68 <log>
    80003ac0:	00003097          	auipc	ra,0x3
    80003ac4:	ea2080e7          	jalr	-350(ra) # 80006962 <release>
}
    80003ac8:	60e2                	ld	ra,24(sp)
    80003aca:	6442                	ld	s0,16(sp)
    80003acc:	64a2                	ld	s1,8(sp)
    80003ace:	6902                	ld	s2,0(sp)
    80003ad0:	6105                	addi	sp,sp,32
    80003ad2:	8082                	ret

0000000080003ad4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003ad4:	1101                	addi	sp,sp,-32
    80003ad6:	ec06                	sd	ra,24(sp)
    80003ad8:	e822                	sd	s0,16(sp)
    80003ada:	e426                	sd	s1,8(sp)
    80003adc:	e04a                	sd	s2,0(sp)
    80003ade:	1000                	addi	s0,sp,32
    80003ae0:	84aa                	mv	s1,a0
    80003ae2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003ae4:	00005597          	auipc	a1,0x5
    80003ae8:	a2c58593          	addi	a1,a1,-1492 # 80008510 <etext+0x510>
    80003aec:	0521                	addi	a0,a0,8
    80003aee:	00003097          	auipc	ra,0x3
    80003af2:	f20080e7          	jalr	-224(ra) # 80006a0e <initlock>
  lk->name = name;
    80003af6:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    80003afa:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003afe:	0204a823          	sw	zero,48(s1)
}
    80003b02:	60e2                	ld	ra,24(sp)
    80003b04:	6442                	ld	s0,16(sp)
    80003b06:	64a2                	ld	s1,8(sp)
    80003b08:	6902                	ld	s2,0(sp)
    80003b0a:	6105                	addi	sp,sp,32
    80003b0c:	8082                	ret

0000000080003b0e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003b0e:	1101                	addi	sp,sp,-32
    80003b10:	ec06                	sd	ra,24(sp)
    80003b12:	e822                	sd	s0,16(sp)
    80003b14:	e426                	sd	s1,8(sp)
    80003b16:	e04a                	sd	s2,0(sp)
    80003b18:	1000                	addi	s0,sp,32
    80003b1a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b1c:	00850913          	addi	s2,a0,8
    80003b20:	854a                	mv	a0,s2
    80003b22:	00003097          	auipc	ra,0x3
    80003b26:	d78080e7          	jalr	-648(ra) # 8000689a <acquire>
  while (lk->locked) {
    80003b2a:	409c                	lw	a5,0(s1)
    80003b2c:	cb89                	beqz	a5,80003b3e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003b2e:	85ca                	mv	a1,s2
    80003b30:	8526                	mv	a0,s1
    80003b32:	ffffe097          	auipc	ra,0xffffe
    80003b36:	b1a080e7          	jalr	-1254(ra) # 8000164c <sleep>
  while (lk->locked) {
    80003b3a:	409c                	lw	a5,0(s1)
    80003b3c:	fbed                	bnez	a5,80003b2e <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003b3e:	4785                	li	a5,1
    80003b40:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003b42:	ffffd097          	auipc	ra,0xffffd
    80003b46:	444080e7          	jalr	1092(ra) # 80000f86 <myproc>
    80003b4a:	5d1c                	lw	a5,56(a0)
    80003b4c:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    80003b4e:	854a                	mv	a0,s2
    80003b50:	00003097          	auipc	ra,0x3
    80003b54:	e12080e7          	jalr	-494(ra) # 80006962 <release>
}
    80003b58:	60e2                	ld	ra,24(sp)
    80003b5a:	6442                	ld	s0,16(sp)
    80003b5c:	64a2                	ld	s1,8(sp)
    80003b5e:	6902                	ld	s2,0(sp)
    80003b60:	6105                	addi	sp,sp,32
    80003b62:	8082                	ret

0000000080003b64 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003b64:	1101                	addi	sp,sp,-32
    80003b66:	ec06                	sd	ra,24(sp)
    80003b68:	e822                	sd	s0,16(sp)
    80003b6a:	e426                	sd	s1,8(sp)
    80003b6c:	e04a                	sd	s2,0(sp)
    80003b6e:	1000                	addi	s0,sp,32
    80003b70:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b72:	00850913          	addi	s2,a0,8
    80003b76:	854a                	mv	a0,s2
    80003b78:	00003097          	auipc	ra,0x3
    80003b7c:	d22080e7          	jalr	-734(ra) # 8000689a <acquire>
  lk->locked = 0;
    80003b80:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b84:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    80003b88:	8526                	mv	a0,s1
    80003b8a:	ffffe097          	auipc	ra,0xffffe
    80003b8e:	c4e080e7          	jalr	-946(ra) # 800017d8 <wakeup>
  release(&lk->lk);
    80003b92:	854a                	mv	a0,s2
    80003b94:	00003097          	auipc	ra,0x3
    80003b98:	dce080e7          	jalr	-562(ra) # 80006962 <release>
}
    80003b9c:	60e2                	ld	ra,24(sp)
    80003b9e:	6442                	ld	s0,16(sp)
    80003ba0:	64a2                	ld	s1,8(sp)
    80003ba2:	6902                	ld	s2,0(sp)
    80003ba4:	6105                	addi	sp,sp,32
    80003ba6:	8082                	ret

0000000080003ba8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003ba8:	7179                	addi	sp,sp,-48
    80003baa:	f406                	sd	ra,40(sp)
    80003bac:	f022                	sd	s0,32(sp)
    80003bae:	ec26                	sd	s1,24(sp)
    80003bb0:	e84a                	sd	s2,16(sp)
    80003bb2:	1800                	addi	s0,sp,48
    80003bb4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003bb6:	00850913          	addi	s2,a0,8
    80003bba:	854a                	mv	a0,s2
    80003bbc:	00003097          	auipc	ra,0x3
    80003bc0:	cde080e7          	jalr	-802(ra) # 8000689a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003bc4:	409c                	lw	a5,0(s1)
    80003bc6:	ef91                	bnez	a5,80003be2 <holdingsleep+0x3a>
    80003bc8:	4481                	li	s1,0
  release(&lk->lk);
    80003bca:	854a                	mv	a0,s2
    80003bcc:	00003097          	auipc	ra,0x3
    80003bd0:	d96080e7          	jalr	-618(ra) # 80006962 <release>
  return r;
}
    80003bd4:	8526                	mv	a0,s1
    80003bd6:	70a2                	ld	ra,40(sp)
    80003bd8:	7402                	ld	s0,32(sp)
    80003bda:	64e2                	ld	s1,24(sp)
    80003bdc:	6942                	ld	s2,16(sp)
    80003bde:	6145                	addi	sp,sp,48
    80003be0:	8082                	ret
    80003be2:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003be4:	0304a983          	lw	s3,48(s1)
    80003be8:	ffffd097          	auipc	ra,0xffffd
    80003bec:	39e080e7          	jalr	926(ra) # 80000f86 <myproc>
    80003bf0:	5d04                	lw	s1,56(a0)
    80003bf2:	413484b3          	sub	s1,s1,s3
    80003bf6:	0014b493          	seqz	s1,s1
    80003bfa:	69a2                	ld	s3,8(sp)
    80003bfc:	b7f9                	j	80003bca <holdingsleep+0x22>

0000000080003bfe <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003bfe:	1141                	addi	sp,sp,-16
    80003c00:	e406                	sd	ra,8(sp)
    80003c02:	e022                	sd	s0,0(sp)
    80003c04:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003c06:	00005597          	auipc	a1,0x5
    80003c0a:	91a58593          	addi	a1,a1,-1766 # 80008520 <etext+0x520>
    80003c0e:	0001c517          	auipc	a0,0x1c
    80003c12:	2aa50513          	addi	a0,a0,682 # 8001feb8 <ftable>
    80003c16:	00003097          	auipc	ra,0x3
    80003c1a:	df8080e7          	jalr	-520(ra) # 80006a0e <initlock>
}
    80003c1e:	60a2                	ld	ra,8(sp)
    80003c20:	6402                	ld	s0,0(sp)
    80003c22:	0141                	addi	sp,sp,16
    80003c24:	8082                	ret

0000000080003c26 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003c26:	1101                	addi	sp,sp,-32
    80003c28:	ec06                	sd	ra,24(sp)
    80003c2a:	e822                	sd	s0,16(sp)
    80003c2c:	e426                	sd	s1,8(sp)
    80003c2e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003c30:	0001c517          	auipc	a0,0x1c
    80003c34:	28850513          	addi	a0,a0,648 # 8001feb8 <ftable>
    80003c38:	00003097          	auipc	ra,0x3
    80003c3c:	c62080e7          	jalr	-926(ra) # 8000689a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c40:	0001c497          	auipc	s1,0x1c
    80003c44:	29848493          	addi	s1,s1,664 # 8001fed8 <ftable+0x20>
    80003c48:	0001d717          	auipc	a4,0x1d
    80003c4c:	23070713          	addi	a4,a4,560 # 80020e78 <ftable+0xfc0>
    if(f->ref == 0){
    80003c50:	40dc                	lw	a5,4(s1)
    80003c52:	cf99                	beqz	a5,80003c70 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c54:	02848493          	addi	s1,s1,40
    80003c58:	fee49ce3          	bne	s1,a4,80003c50 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003c5c:	0001c517          	auipc	a0,0x1c
    80003c60:	25c50513          	addi	a0,a0,604 # 8001feb8 <ftable>
    80003c64:	00003097          	auipc	ra,0x3
    80003c68:	cfe080e7          	jalr	-770(ra) # 80006962 <release>
  return 0;
    80003c6c:	4481                	li	s1,0
    80003c6e:	a819                	j	80003c84 <filealloc+0x5e>
      f->ref = 1;
    80003c70:	4785                	li	a5,1
    80003c72:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c74:	0001c517          	auipc	a0,0x1c
    80003c78:	24450513          	addi	a0,a0,580 # 8001feb8 <ftable>
    80003c7c:	00003097          	auipc	ra,0x3
    80003c80:	ce6080e7          	jalr	-794(ra) # 80006962 <release>
}
    80003c84:	8526                	mv	a0,s1
    80003c86:	60e2                	ld	ra,24(sp)
    80003c88:	6442                	ld	s0,16(sp)
    80003c8a:	64a2                	ld	s1,8(sp)
    80003c8c:	6105                	addi	sp,sp,32
    80003c8e:	8082                	ret

0000000080003c90 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003c90:	1101                	addi	sp,sp,-32
    80003c92:	ec06                	sd	ra,24(sp)
    80003c94:	e822                	sd	s0,16(sp)
    80003c96:	e426                	sd	s1,8(sp)
    80003c98:	1000                	addi	s0,sp,32
    80003c9a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003c9c:	0001c517          	auipc	a0,0x1c
    80003ca0:	21c50513          	addi	a0,a0,540 # 8001feb8 <ftable>
    80003ca4:	00003097          	auipc	ra,0x3
    80003ca8:	bf6080e7          	jalr	-1034(ra) # 8000689a <acquire>
  if(f->ref < 1)
    80003cac:	40dc                	lw	a5,4(s1)
    80003cae:	02f05263          	blez	a5,80003cd2 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003cb2:	2785                	addiw	a5,a5,1
    80003cb4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003cb6:	0001c517          	auipc	a0,0x1c
    80003cba:	20250513          	addi	a0,a0,514 # 8001feb8 <ftable>
    80003cbe:	00003097          	auipc	ra,0x3
    80003cc2:	ca4080e7          	jalr	-860(ra) # 80006962 <release>
  return f;
}
    80003cc6:	8526                	mv	a0,s1
    80003cc8:	60e2                	ld	ra,24(sp)
    80003cca:	6442                	ld	s0,16(sp)
    80003ccc:	64a2                	ld	s1,8(sp)
    80003cce:	6105                	addi	sp,sp,32
    80003cd0:	8082                	ret
    panic("filedup");
    80003cd2:	00005517          	auipc	a0,0x5
    80003cd6:	85650513          	addi	a0,a0,-1962 # 80008528 <etext+0x528>
    80003cda:	00002097          	auipc	ra,0x2
    80003cde:	65c080e7          	jalr	1628(ra) # 80006336 <panic>

0000000080003ce2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003ce2:	7139                	addi	sp,sp,-64
    80003ce4:	fc06                	sd	ra,56(sp)
    80003ce6:	f822                	sd	s0,48(sp)
    80003ce8:	f426                	sd	s1,40(sp)
    80003cea:	0080                	addi	s0,sp,64
    80003cec:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003cee:	0001c517          	auipc	a0,0x1c
    80003cf2:	1ca50513          	addi	a0,a0,458 # 8001feb8 <ftable>
    80003cf6:	00003097          	auipc	ra,0x3
    80003cfa:	ba4080e7          	jalr	-1116(ra) # 8000689a <acquire>
  if(f->ref < 1)
    80003cfe:	40dc                	lw	a5,4(s1)
    80003d00:	04f05c63          	blez	a5,80003d58 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003d04:	37fd                	addiw	a5,a5,-1
    80003d06:	0007871b          	sext.w	a4,a5
    80003d0a:	c0dc                	sw	a5,4(s1)
    80003d0c:	06e04263          	bgtz	a4,80003d70 <fileclose+0x8e>
    80003d10:	f04a                	sd	s2,32(sp)
    80003d12:	ec4e                	sd	s3,24(sp)
    80003d14:	e852                	sd	s4,16(sp)
    80003d16:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003d18:	0004a903          	lw	s2,0(s1)
    80003d1c:	0094ca83          	lbu	s5,9(s1)
    80003d20:	0104ba03          	ld	s4,16(s1)
    80003d24:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003d28:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003d2c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003d30:	0001c517          	auipc	a0,0x1c
    80003d34:	18850513          	addi	a0,a0,392 # 8001feb8 <ftable>
    80003d38:	00003097          	auipc	ra,0x3
    80003d3c:	c2a080e7          	jalr	-982(ra) # 80006962 <release>

  if(ff.type == FD_PIPE){
    80003d40:	4785                	li	a5,1
    80003d42:	04f90463          	beq	s2,a5,80003d8a <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003d46:	3979                	addiw	s2,s2,-2
    80003d48:	4785                	li	a5,1
    80003d4a:	0527fb63          	bgeu	a5,s2,80003da0 <fileclose+0xbe>
    80003d4e:	7902                	ld	s2,32(sp)
    80003d50:	69e2                	ld	s3,24(sp)
    80003d52:	6a42                	ld	s4,16(sp)
    80003d54:	6aa2                	ld	s5,8(sp)
    80003d56:	a02d                	j	80003d80 <fileclose+0x9e>
    80003d58:	f04a                	sd	s2,32(sp)
    80003d5a:	ec4e                	sd	s3,24(sp)
    80003d5c:	e852                	sd	s4,16(sp)
    80003d5e:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003d60:	00004517          	auipc	a0,0x4
    80003d64:	7d050513          	addi	a0,a0,2000 # 80008530 <etext+0x530>
    80003d68:	00002097          	auipc	ra,0x2
    80003d6c:	5ce080e7          	jalr	1486(ra) # 80006336 <panic>
    release(&ftable.lock);
    80003d70:	0001c517          	auipc	a0,0x1c
    80003d74:	14850513          	addi	a0,a0,328 # 8001feb8 <ftable>
    80003d78:	00003097          	auipc	ra,0x3
    80003d7c:	bea080e7          	jalr	-1046(ra) # 80006962 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003d80:	70e2                	ld	ra,56(sp)
    80003d82:	7442                	ld	s0,48(sp)
    80003d84:	74a2                	ld	s1,40(sp)
    80003d86:	6121                	addi	sp,sp,64
    80003d88:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d8a:	85d6                	mv	a1,s5
    80003d8c:	8552                	mv	a0,s4
    80003d8e:	00000097          	auipc	ra,0x0
    80003d92:	3a2080e7          	jalr	930(ra) # 80004130 <pipeclose>
    80003d96:	7902                	ld	s2,32(sp)
    80003d98:	69e2                	ld	s3,24(sp)
    80003d9a:	6a42                	ld	s4,16(sp)
    80003d9c:	6aa2                	ld	s5,8(sp)
    80003d9e:	b7cd                	j	80003d80 <fileclose+0x9e>
    begin_op();
    80003da0:	00000097          	auipc	ra,0x0
    80003da4:	a78080e7          	jalr	-1416(ra) # 80003818 <begin_op>
    iput(ff.ip);
    80003da8:	854e                	mv	a0,s3
    80003daa:	fffff097          	auipc	ra,0xfffff
    80003dae:	25a080e7          	jalr	602(ra) # 80003004 <iput>
    end_op();
    80003db2:	00000097          	auipc	ra,0x0
    80003db6:	ae0080e7          	jalr	-1312(ra) # 80003892 <end_op>
    80003dba:	7902                	ld	s2,32(sp)
    80003dbc:	69e2                	ld	s3,24(sp)
    80003dbe:	6a42                	ld	s4,16(sp)
    80003dc0:	6aa2                	ld	s5,8(sp)
    80003dc2:	bf7d                	j	80003d80 <fileclose+0x9e>

0000000080003dc4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003dc4:	715d                	addi	sp,sp,-80
    80003dc6:	e486                	sd	ra,72(sp)
    80003dc8:	e0a2                	sd	s0,64(sp)
    80003dca:	fc26                	sd	s1,56(sp)
    80003dcc:	f44e                	sd	s3,40(sp)
    80003dce:	0880                	addi	s0,sp,80
    80003dd0:	84aa                	mv	s1,a0
    80003dd2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003dd4:	ffffd097          	auipc	ra,0xffffd
    80003dd8:	1b2080e7          	jalr	434(ra) # 80000f86 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003ddc:	409c                	lw	a5,0(s1)
    80003dde:	37f9                	addiw	a5,a5,-2
    80003de0:	4705                	li	a4,1
    80003de2:	04f76863          	bltu	a4,a5,80003e32 <filestat+0x6e>
    80003de6:	f84a                	sd	s2,48(sp)
    80003de8:	892a                	mv	s2,a0
    ilock(f->ip);
    80003dea:	6c88                	ld	a0,24(s1)
    80003dec:	fffff097          	auipc	ra,0xfffff
    80003df0:	05a080e7          	jalr	90(ra) # 80002e46 <ilock>
    stati(f->ip, &st);
    80003df4:	fb840593          	addi	a1,s0,-72
    80003df8:	6c88                	ld	a0,24(s1)
    80003dfa:	fffff097          	auipc	ra,0xfffff
    80003dfe:	2da080e7          	jalr	730(ra) # 800030d4 <stati>
    iunlock(f->ip);
    80003e02:	6c88                	ld	a0,24(s1)
    80003e04:	fffff097          	auipc	ra,0xfffff
    80003e08:	108080e7          	jalr	264(ra) # 80002f0c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003e0c:	46e1                	li	a3,24
    80003e0e:	fb840613          	addi	a2,s0,-72
    80003e12:	85ce                	mv	a1,s3
    80003e14:	05893503          	ld	a0,88(s2)
    80003e18:	ffffd097          	auipc	ra,0xffffd
    80003e1c:	e0a080e7          	jalr	-502(ra) # 80000c22 <copyout>
    80003e20:	41f5551b          	sraiw	a0,a0,0x1f
    80003e24:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003e26:	60a6                	ld	ra,72(sp)
    80003e28:	6406                	ld	s0,64(sp)
    80003e2a:	74e2                	ld	s1,56(sp)
    80003e2c:	79a2                	ld	s3,40(sp)
    80003e2e:	6161                	addi	sp,sp,80
    80003e30:	8082                	ret
  return -1;
    80003e32:	557d                	li	a0,-1
    80003e34:	bfcd                	j	80003e26 <filestat+0x62>

0000000080003e36 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003e36:	7179                	addi	sp,sp,-48
    80003e38:	f406                	sd	ra,40(sp)
    80003e3a:	f022                	sd	s0,32(sp)
    80003e3c:	e84a                	sd	s2,16(sp)
    80003e3e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003e40:	00854783          	lbu	a5,8(a0)
    80003e44:	cbc5                	beqz	a5,80003ef4 <fileread+0xbe>
    80003e46:	ec26                	sd	s1,24(sp)
    80003e48:	e44e                	sd	s3,8(sp)
    80003e4a:	84aa                	mv	s1,a0
    80003e4c:	89ae                	mv	s3,a1
    80003e4e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e50:	411c                	lw	a5,0(a0)
    80003e52:	4705                	li	a4,1
    80003e54:	04e78963          	beq	a5,a4,80003ea6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e58:	470d                	li	a4,3
    80003e5a:	04e78f63          	beq	a5,a4,80003eb8 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e5e:	4709                	li	a4,2
    80003e60:	08e79263          	bne	a5,a4,80003ee4 <fileread+0xae>
    ilock(f->ip);
    80003e64:	6d08                	ld	a0,24(a0)
    80003e66:	fffff097          	auipc	ra,0xfffff
    80003e6a:	fe0080e7          	jalr	-32(ra) # 80002e46 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003e6e:	874a                	mv	a4,s2
    80003e70:	5094                	lw	a3,32(s1)
    80003e72:	864e                	mv	a2,s3
    80003e74:	4585                	li	a1,1
    80003e76:	6c88                	ld	a0,24(s1)
    80003e78:	fffff097          	auipc	ra,0xfffff
    80003e7c:	286080e7          	jalr	646(ra) # 800030fe <readi>
    80003e80:	892a                	mv	s2,a0
    80003e82:	00a05563          	blez	a0,80003e8c <fileread+0x56>
      f->off += r;
    80003e86:	509c                	lw	a5,32(s1)
    80003e88:	9fa9                	addw	a5,a5,a0
    80003e8a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e8c:	6c88                	ld	a0,24(s1)
    80003e8e:	fffff097          	auipc	ra,0xfffff
    80003e92:	07e080e7          	jalr	126(ra) # 80002f0c <iunlock>
    80003e96:	64e2                	ld	s1,24(sp)
    80003e98:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003e9a:	854a                	mv	a0,s2
    80003e9c:	70a2                	ld	ra,40(sp)
    80003e9e:	7402                	ld	s0,32(sp)
    80003ea0:	6942                	ld	s2,16(sp)
    80003ea2:	6145                	addi	sp,sp,48
    80003ea4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003ea6:	6908                	ld	a0,16(a0)
    80003ea8:	00000097          	auipc	ra,0x0
    80003eac:	404080e7          	jalr	1028(ra) # 800042ac <piperead>
    80003eb0:	892a                	mv	s2,a0
    80003eb2:	64e2                	ld	s1,24(sp)
    80003eb4:	69a2                	ld	s3,8(sp)
    80003eb6:	b7d5                	j	80003e9a <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003eb8:	02451783          	lh	a5,36(a0)
    80003ebc:	03079693          	slli	a3,a5,0x30
    80003ec0:	92c1                	srli	a3,a3,0x30
    80003ec2:	4725                	li	a4,9
    80003ec4:	02d76a63          	bltu	a4,a3,80003ef8 <fileread+0xc2>
    80003ec8:	0792                	slli	a5,a5,0x4
    80003eca:	0001c717          	auipc	a4,0x1c
    80003ece:	f4e70713          	addi	a4,a4,-178 # 8001fe18 <devsw>
    80003ed2:	97ba                	add	a5,a5,a4
    80003ed4:	639c                	ld	a5,0(a5)
    80003ed6:	c78d                	beqz	a5,80003f00 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003ed8:	4505                	li	a0,1
    80003eda:	9782                	jalr	a5
    80003edc:	892a                	mv	s2,a0
    80003ede:	64e2                	ld	s1,24(sp)
    80003ee0:	69a2                	ld	s3,8(sp)
    80003ee2:	bf65                	j	80003e9a <fileread+0x64>
    panic("fileread");
    80003ee4:	00004517          	auipc	a0,0x4
    80003ee8:	65c50513          	addi	a0,a0,1628 # 80008540 <etext+0x540>
    80003eec:	00002097          	auipc	ra,0x2
    80003ef0:	44a080e7          	jalr	1098(ra) # 80006336 <panic>
    return -1;
    80003ef4:	597d                	li	s2,-1
    80003ef6:	b755                	j	80003e9a <fileread+0x64>
      return -1;
    80003ef8:	597d                	li	s2,-1
    80003efa:	64e2                	ld	s1,24(sp)
    80003efc:	69a2                	ld	s3,8(sp)
    80003efe:	bf71                	j	80003e9a <fileread+0x64>
    80003f00:	597d                	li	s2,-1
    80003f02:	64e2                	ld	s1,24(sp)
    80003f04:	69a2                	ld	s3,8(sp)
    80003f06:	bf51                	j	80003e9a <fileread+0x64>

0000000080003f08 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003f08:	00954783          	lbu	a5,9(a0)
    80003f0c:	12078963          	beqz	a5,8000403e <filewrite+0x136>
{
    80003f10:	715d                	addi	sp,sp,-80
    80003f12:	e486                	sd	ra,72(sp)
    80003f14:	e0a2                	sd	s0,64(sp)
    80003f16:	f84a                	sd	s2,48(sp)
    80003f18:	f052                	sd	s4,32(sp)
    80003f1a:	e85a                	sd	s6,16(sp)
    80003f1c:	0880                	addi	s0,sp,80
    80003f1e:	892a                	mv	s2,a0
    80003f20:	8b2e                	mv	s6,a1
    80003f22:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003f24:	411c                	lw	a5,0(a0)
    80003f26:	4705                	li	a4,1
    80003f28:	02e78763          	beq	a5,a4,80003f56 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003f2c:	470d                	li	a4,3
    80003f2e:	02e78a63          	beq	a5,a4,80003f62 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003f32:	4709                	li	a4,2
    80003f34:	0ee79863          	bne	a5,a4,80004024 <filewrite+0x11c>
    80003f38:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003f3a:	0cc05463          	blez	a2,80004002 <filewrite+0xfa>
    80003f3e:	fc26                	sd	s1,56(sp)
    80003f40:	ec56                	sd	s5,24(sp)
    80003f42:	e45e                	sd	s7,8(sp)
    80003f44:	e062                	sd	s8,0(sp)
    int i = 0;
    80003f46:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003f48:	6b85                	lui	s7,0x1
    80003f4a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003f4e:	6c05                	lui	s8,0x1
    80003f50:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003f54:	a851                	j	80003fe8 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003f56:	6908                	ld	a0,16(a0)
    80003f58:	00000097          	auipc	ra,0x0
    80003f5c:	252080e7          	jalr	594(ra) # 800041aa <pipewrite>
    80003f60:	a85d                	j	80004016 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003f62:	02451783          	lh	a5,36(a0)
    80003f66:	03079693          	slli	a3,a5,0x30
    80003f6a:	92c1                	srli	a3,a3,0x30
    80003f6c:	4725                	li	a4,9
    80003f6e:	0cd76a63          	bltu	a4,a3,80004042 <filewrite+0x13a>
    80003f72:	0792                	slli	a5,a5,0x4
    80003f74:	0001c717          	auipc	a4,0x1c
    80003f78:	ea470713          	addi	a4,a4,-348 # 8001fe18 <devsw>
    80003f7c:	97ba                	add	a5,a5,a4
    80003f7e:	679c                	ld	a5,8(a5)
    80003f80:	c3f9                	beqz	a5,80004046 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003f82:	4505                	li	a0,1
    80003f84:	9782                	jalr	a5
    80003f86:	a841                	j	80004016 <filewrite+0x10e>
      if(n1 > max)
    80003f88:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003f8c:	00000097          	auipc	ra,0x0
    80003f90:	88c080e7          	jalr	-1908(ra) # 80003818 <begin_op>
      ilock(f->ip);
    80003f94:	01893503          	ld	a0,24(s2)
    80003f98:	fffff097          	auipc	ra,0xfffff
    80003f9c:	eae080e7          	jalr	-338(ra) # 80002e46 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003fa0:	8756                	mv	a4,s5
    80003fa2:	02092683          	lw	a3,32(s2)
    80003fa6:	01698633          	add	a2,s3,s6
    80003faa:	4585                	li	a1,1
    80003fac:	01893503          	ld	a0,24(s2)
    80003fb0:	fffff097          	auipc	ra,0xfffff
    80003fb4:	252080e7          	jalr	594(ra) # 80003202 <writei>
    80003fb8:	84aa                	mv	s1,a0
    80003fba:	00a05763          	blez	a0,80003fc8 <filewrite+0xc0>
        f->off += r;
    80003fbe:	02092783          	lw	a5,32(s2)
    80003fc2:	9fa9                	addw	a5,a5,a0
    80003fc4:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003fc8:	01893503          	ld	a0,24(s2)
    80003fcc:	fffff097          	auipc	ra,0xfffff
    80003fd0:	f40080e7          	jalr	-192(ra) # 80002f0c <iunlock>
      end_op();
    80003fd4:	00000097          	auipc	ra,0x0
    80003fd8:	8be080e7          	jalr	-1858(ra) # 80003892 <end_op>

      if(r != n1){
    80003fdc:	029a9563          	bne	s5,s1,80004006 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003fe0:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003fe4:	0149da63          	bge	s3,s4,80003ff8 <filewrite+0xf0>
      int n1 = n - i;
    80003fe8:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003fec:	0004879b          	sext.w	a5,s1
    80003ff0:	f8fbdce3          	bge	s7,a5,80003f88 <filewrite+0x80>
    80003ff4:	84e2                	mv	s1,s8
    80003ff6:	bf49                	j	80003f88 <filewrite+0x80>
    80003ff8:	74e2                	ld	s1,56(sp)
    80003ffa:	6ae2                	ld	s5,24(sp)
    80003ffc:	6ba2                	ld	s7,8(sp)
    80003ffe:	6c02                	ld	s8,0(sp)
    80004000:	a039                	j	8000400e <filewrite+0x106>
    int i = 0;
    80004002:	4981                	li	s3,0
    80004004:	a029                	j	8000400e <filewrite+0x106>
    80004006:	74e2                	ld	s1,56(sp)
    80004008:	6ae2                	ld	s5,24(sp)
    8000400a:	6ba2                	ld	s7,8(sp)
    8000400c:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000400e:	033a1e63          	bne	s4,s3,8000404a <filewrite+0x142>
    80004012:	8552                	mv	a0,s4
    80004014:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004016:	60a6                	ld	ra,72(sp)
    80004018:	6406                	ld	s0,64(sp)
    8000401a:	7942                	ld	s2,48(sp)
    8000401c:	7a02                	ld	s4,32(sp)
    8000401e:	6b42                	ld	s6,16(sp)
    80004020:	6161                	addi	sp,sp,80
    80004022:	8082                	ret
    80004024:	fc26                	sd	s1,56(sp)
    80004026:	f44e                	sd	s3,40(sp)
    80004028:	ec56                	sd	s5,24(sp)
    8000402a:	e45e                	sd	s7,8(sp)
    8000402c:	e062                	sd	s8,0(sp)
    panic("filewrite");
    8000402e:	00004517          	auipc	a0,0x4
    80004032:	52250513          	addi	a0,a0,1314 # 80008550 <etext+0x550>
    80004036:	00002097          	auipc	ra,0x2
    8000403a:	300080e7          	jalr	768(ra) # 80006336 <panic>
    return -1;
    8000403e:	557d                	li	a0,-1
}
    80004040:	8082                	ret
      return -1;
    80004042:	557d                	li	a0,-1
    80004044:	bfc9                	j	80004016 <filewrite+0x10e>
    80004046:	557d                	li	a0,-1
    80004048:	b7f9                	j	80004016 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    8000404a:	557d                	li	a0,-1
    8000404c:	79a2                	ld	s3,40(sp)
    8000404e:	b7e1                	j	80004016 <filewrite+0x10e>

0000000080004050 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004050:	7179                	addi	sp,sp,-48
    80004052:	f406                	sd	ra,40(sp)
    80004054:	f022                	sd	s0,32(sp)
    80004056:	ec26                	sd	s1,24(sp)
    80004058:	e052                	sd	s4,0(sp)
    8000405a:	1800                	addi	s0,sp,48
    8000405c:	84aa                	mv	s1,a0
    8000405e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004060:	0005b023          	sd	zero,0(a1)
    80004064:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004068:	00000097          	auipc	ra,0x0
    8000406c:	bbe080e7          	jalr	-1090(ra) # 80003c26 <filealloc>
    80004070:	e088                	sd	a0,0(s1)
    80004072:	cd49                	beqz	a0,8000410c <pipealloc+0xbc>
    80004074:	00000097          	auipc	ra,0x0
    80004078:	bb2080e7          	jalr	-1102(ra) # 80003c26 <filealloc>
    8000407c:	00aa3023          	sd	a0,0(s4)
    80004080:	c141                	beqz	a0,80004100 <pipealloc+0xb0>
    80004082:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004084:	ffffc097          	auipc	ra,0xffffc
    80004088:	0e8080e7          	jalr	232(ra) # 8000016c <kalloc>
    8000408c:	892a                	mv	s2,a0
    8000408e:	c13d                	beqz	a0,800040f4 <pipealloc+0xa4>
    80004090:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004092:	4985                	li	s3,1
    80004094:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    80004098:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    8000409c:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    800040a0:	22052023          	sw	zero,544(a0)
  initlock(&pi->lock, "pipe");
    800040a4:	00004597          	auipc	a1,0x4
    800040a8:	4bc58593          	addi	a1,a1,1212 # 80008560 <etext+0x560>
    800040ac:	00003097          	auipc	ra,0x3
    800040b0:	962080e7          	jalr	-1694(ra) # 80006a0e <initlock>
  (*f0)->type = FD_PIPE;
    800040b4:	609c                	ld	a5,0(s1)
    800040b6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800040ba:	609c                	ld	a5,0(s1)
    800040bc:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800040c0:	609c                	ld	a5,0(s1)
    800040c2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800040c6:	609c                	ld	a5,0(s1)
    800040c8:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800040cc:	000a3783          	ld	a5,0(s4)
    800040d0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800040d4:	000a3783          	ld	a5,0(s4)
    800040d8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800040dc:	000a3783          	ld	a5,0(s4)
    800040e0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800040e4:	000a3783          	ld	a5,0(s4)
    800040e8:	0127b823          	sd	s2,16(a5)
  return 0;
    800040ec:	4501                	li	a0,0
    800040ee:	6942                	ld	s2,16(sp)
    800040f0:	69a2                	ld	s3,8(sp)
    800040f2:	a03d                	j	80004120 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800040f4:	6088                	ld	a0,0(s1)
    800040f6:	c119                	beqz	a0,800040fc <pipealloc+0xac>
    800040f8:	6942                	ld	s2,16(sp)
    800040fa:	a029                	j	80004104 <pipealloc+0xb4>
    800040fc:	6942                	ld	s2,16(sp)
    800040fe:	a039                	j	8000410c <pipealloc+0xbc>
    80004100:	6088                	ld	a0,0(s1)
    80004102:	c50d                	beqz	a0,8000412c <pipealloc+0xdc>
    fileclose(*f0);
    80004104:	00000097          	auipc	ra,0x0
    80004108:	bde080e7          	jalr	-1058(ra) # 80003ce2 <fileclose>
  if(*f1)
    8000410c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004110:	557d                	li	a0,-1
  if(*f1)
    80004112:	c799                	beqz	a5,80004120 <pipealloc+0xd0>
    fileclose(*f1);
    80004114:	853e                	mv	a0,a5
    80004116:	00000097          	auipc	ra,0x0
    8000411a:	bcc080e7          	jalr	-1076(ra) # 80003ce2 <fileclose>
  return -1;
    8000411e:	557d                	li	a0,-1
}
    80004120:	70a2                	ld	ra,40(sp)
    80004122:	7402                	ld	s0,32(sp)
    80004124:	64e2                	ld	s1,24(sp)
    80004126:	6a02                	ld	s4,0(sp)
    80004128:	6145                	addi	sp,sp,48
    8000412a:	8082                	ret
  return -1;
    8000412c:	557d                	li	a0,-1
    8000412e:	bfcd                	j	80004120 <pipealloc+0xd0>

0000000080004130 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004130:	1101                	addi	sp,sp,-32
    80004132:	ec06                	sd	ra,24(sp)
    80004134:	e822                	sd	s0,16(sp)
    80004136:	e426                	sd	s1,8(sp)
    80004138:	e04a                	sd	s2,0(sp)
    8000413a:	1000                	addi	s0,sp,32
    8000413c:	84aa                	mv	s1,a0
    8000413e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004140:	00002097          	auipc	ra,0x2
    80004144:	75a080e7          	jalr	1882(ra) # 8000689a <acquire>
  if(writable){
    80004148:	04090263          	beqz	s2,8000418c <pipeclose+0x5c>
    pi->writeopen = 0;
    8000414c:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    80004150:	22048513          	addi	a0,s1,544
    80004154:	ffffd097          	auipc	ra,0xffffd
    80004158:	684080e7          	jalr	1668(ra) # 800017d8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000415c:	2284b783          	ld	a5,552(s1)
    80004160:	ef9d                	bnez	a5,8000419e <pipeclose+0x6e>
    release(&pi->lock);
    80004162:	8526                	mv	a0,s1
    80004164:	00002097          	auipc	ra,0x2
    80004168:	7fe080e7          	jalr	2046(ra) # 80006962 <release>
#ifdef LAB_LOCK
    freelock(&pi->lock);
    8000416c:	8526                	mv	a0,s1
    8000416e:	00003097          	auipc	ra,0x3
    80004172:	83c080e7          	jalr	-1988(ra) # 800069aa <freelock>
#endif    
    kfree((char*)pi);
    80004176:	8526                	mv	a0,s1
    80004178:	ffffc097          	auipc	ra,0xffffc
    8000417c:	ea4080e7          	jalr	-348(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004180:	60e2                	ld	ra,24(sp)
    80004182:	6442                	ld	s0,16(sp)
    80004184:	64a2                	ld	s1,8(sp)
    80004186:	6902                	ld	s2,0(sp)
    80004188:	6105                	addi	sp,sp,32
    8000418a:	8082                	ret
    pi->readopen = 0;
    8000418c:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    80004190:	22448513          	addi	a0,s1,548
    80004194:	ffffd097          	auipc	ra,0xffffd
    80004198:	644080e7          	jalr	1604(ra) # 800017d8 <wakeup>
    8000419c:	b7c1                	j	8000415c <pipeclose+0x2c>
    release(&pi->lock);
    8000419e:	8526                	mv	a0,s1
    800041a0:	00002097          	auipc	ra,0x2
    800041a4:	7c2080e7          	jalr	1986(ra) # 80006962 <release>
}
    800041a8:	bfe1                	j	80004180 <pipeclose+0x50>

00000000800041aa <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800041aa:	711d                	addi	sp,sp,-96
    800041ac:	ec86                	sd	ra,88(sp)
    800041ae:	e8a2                	sd	s0,80(sp)
    800041b0:	e4a6                	sd	s1,72(sp)
    800041b2:	e0ca                	sd	s2,64(sp)
    800041b4:	fc4e                	sd	s3,56(sp)
    800041b6:	f852                	sd	s4,48(sp)
    800041b8:	f456                	sd	s5,40(sp)
    800041ba:	1080                	addi	s0,sp,96
    800041bc:	84aa                	mv	s1,a0
    800041be:	8aae                	mv	s5,a1
    800041c0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800041c2:	ffffd097          	auipc	ra,0xffffd
    800041c6:	dc4080e7          	jalr	-572(ra) # 80000f86 <myproc>
    800041ca:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800041cc:	8526                	mv	a0,s1
    800041ce:	00002097          	auipc	ra,0x2
    800041d2:	6cc080e7          	jalr	1740(ra) # 8000689a <acquire>
  while(i < n){
    800041d6:	0d405563          	blez	s4,800042a0 <pipewrite+0xf6>
    800041da:	f05a                	sd	s6,32(sp)
    800041dc:	ec5e                	sd	s7,24(sp)
    800041de:	e862                	sd	s8,16(sp)
  int i = 0;
    800041e0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041e2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800041e4:	22048c13          	addi	s8,s1,544
      sleep(&pi->nwrite, &pi->lock);
    800041e8:	22448b93          	addi	s7,s1,548
    800041ec:	a089                	j	8000422e <pipewrite+0x84>
      release(&pi->lock);
    800041ee:	8526                	mv	a0,s1
    800041f0:	00002097          	auipc	ra,0x2
    800041f4:	772080e7          	jalr	1906(ra) # 80006962 <release>
      return -1;
    800041f8:	597d                	li	s2,-1
    800041fa:	7b02                	ld	s6,32(sp)
    800041fc:	6be2                	ld	s7,24(sp)
    800041fe:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004200:	854a                	mv	a0,s2
    80004202:	60e6                	ld	ra,88(sp)
    80004204:	6446                	ld	s0,80(sp)
    80004206:	64a6                	ld	s1,72(sp)
    80004208:	6906                	ld	s2,64(sp)
    8000420a:	79e2                	ld	s3,56(sp)
    8000420c:	7a42                	ld	s4,48(sp)
    8000420e:	7aa2                	ld	s5,40(sp)
    80004210:	6125                	addi	sp,sp,96
    80004212:	8082                	ret
      wakeup(&pi->nread);
    80004214:	8562                	mv	a0,s8
    80004216:	ffffd097          	auipc	ra,0xffffd
    8000421a:	5c2080e7          	jalr	1474(ra) # 800017d8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000421e:	85a6                	mv	a1,s1
    80004220:	855e                	mv	a0,s7
    80004222:	ffffd097          	auipc	ra,0xffffd
    80004226:	42a080e7          	jalr	1066(ra) # 8000164c <sleep>
  while(i < n){
    8000422a:	05495c63          	bge	s2,s4,80004282 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    8000422e:	2284a783          	lw	a5,552(s1)
    80004232:	dfd5                	beqz	a5,800041ee <pipewrite+0x44>
    80004234:	0309a783          	lw	a5,48(s3)
    80004238:	fbdd                	bnez	a5,800041ee <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000423a:	2204a783          	lw	a5,544(s1)
    8000423e:	2244a703          	lw	a4,548(s1)
    80004242:	2007879b          	addiw	a5,a5,512
    80004246:	fcf707e3          	beq	a4,a5,80004214 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000424a:	4685                	li	a3,1
    8000424c:	01590633          	add	a2,s2,s5
    80004250:	faf40593          	addi	a1,s0,-81
    80004254:	0589b503          	ld	a0,88(s3)
    80004258:	ffffd097          	auipc	ra,0xffffd
    8000425c:	a56080e7          	jalr	-1450(ra) # 80000cae <copyin>
    80004260:	05650263          	beq	a0,s6,800042a4 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004264:	2244a783          	lw	a5,548(s1)
    80004268:	0017871b          	addiw	a4,a5,1
    8000426c:	22e4a223          	sw	a4,548(s1)
    80004270:	1ff7f793          	andi	a5,a5,511
    80004274:	97a6                	add	a5,a5,s1
    80004276:	faf44703          	lbu	a4,-81(s0)
    8000427a:	02e78023          	sb	a4,32(a5)
      i++;
    8000427e:	2905                	addiw	s2,s2,1
    80004280:	b76d                	j	8000422a <pipewrite+0x80>
    80004282:	7b02                	ld	s6,32(sp)
    80004284:	6be2                	ld	s7,24(sp)
    80004286:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004288:	22048513          	addi	a0,s1,544
    8000428c:	ffffd097          	auipc	ra,0xffffd
    80004290:	54c080e7          	jalr	1356(ra) # 800017d8 <wakeup>
  release(&pi->lock);
    80004294:	8526                	mv	a0,s1
    80004296:	00002097          	auipc	ra,0x2
    8000429a:	6cc080e7          	jalr	1740(ra) # 80006962 <release>
  return i;
    8000429e:	b78d                	j	80004200 <pipewrite+0x56>
  int i = 0;
    800042a0:	4901                	li	s2,0
    800042a2:	b7dd                	j	80004288 <pipewrite+0xde>
    800042a4:	7b02                	ld	s6,32(sp)
    800042a6:	6be2                	ld	s7,24(sp)
    800042a8:	6c42                	ld	s8,16(sp)
    800042aa:	bff9                	j	80004288 <pipewrite+0xde>

00000000800042ac <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800042ac:	715d                	addi	sp,sp,-80
    800042ae:	e486                	sd	ra,72(sp)
    800042b0:	e0a2                	sd	s0,64(sp)
    800042b2:	fc26                	sd	s1,56(sp)
    800042b4:	f84a                	sd	s2,48(sp)
    800042b6:	f44e                	sd	s3,40(sp)
    800042b8:	f052                	sd	s4,32(sp)
    800042ba:	ec56                	sd	s5,24(sp)
    800042bc:	0880                	addi	s0,sp,80
    800042be:	84aa                	mv	s1,a0
    800042c0:	892e                	mv	s2,a1
    800042c2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800042c4:	ffffd097          	auipc	ra,0xffffd
    800042c8:	cc2080e7          	jalr	-830(ra) # 80000f86 <myproc>
    800042cc:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800042ce:	8526                	mv	a0,s1
    800042d0:	00002097          	auipc	ra,0x2
    800042d4:	5ca080e7          	jalr	1482(ra) # 8000689a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042d8:	2204a703          	lw	a4,544(s1)
    800042dc:	2244a783          	lw	a5,548(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800042e0:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042e4:	02f71663          	bne	a4,a5,80004310 <piperead+0x64>
    800042e8:	22c4a783          	lw	a5,556(s1)
    800042ec:	cb9d                	beqz	a5,80004322 <piperead+0x76>
    if(pr->killed){
    800042ee:	030a2783          	lw	a5,48(s4)
    800042f2:	e38d                	bnez	a5,80004314 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800042f4:	85a6                	mv	a1,s1
    800042f6:	854e                	mv	a0,s3
    800042f8:	ffffd097          	auipc	ra,0xffffd
    800042fc:	354080e7          	jalr	852(ra) # 8000164c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004300:	2204a703          	lw	a4,544(s1)
    80004304:	2244a783          	lw	a5,548(s1)
    80004308:	fef700e3          	beq	a4,a5,800042e8 <piperead+0x3c>
    8000430c:	e85a                	sd	s6,16(sp)
    8000430e:	a819                	j	80004324 <piperead+0x78>
    80004310:	e85a                	sd	s6,16(sp)
    80004312:	a809                	j	80004324 <piperead+0x78>
      release(&pi->lock);
    80004314:	8526                	mv	a0,s1
    80004316:	00002097          	auipc	ra,0x2
    8000431a:	64c080e7          	jalr	1612(ra) # 80006962 <release>
      return -1;
    8000431e:	59fd                	li	s3,-1
    80004320:	a0a5                	j	80004388 <piperead+0xdc>
    80004322:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004324:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004326:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004328:	05505463          	blez	s5,80004370 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    8000432c:	2204a783          	lw	a5,544(s1)
    80004330:	2244a703          	lw	a4,548(s1)
    80004334:	02f70e63          	beq	a4,a5,80004370 <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004338:	0017871b          	addiw	a4,a5,1
    8000433c:	22e4a023          	sw	a4,544(s1)
    80004340:	1ff7f793          	andi	a5,a5,511
    80004344:	97a6                	add	a5,a5,s1
    80004346:	0207c783          	lbu	a5,32(a5)
    8000434a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000434e:	4685                	li	a3,1
    80004350:	fbf40613          	addi	a2,s0,-65
    80004354:	85ca                	mv	a1,s2
    80004356:	058a3503          	ld	a0,88(s4)
    8000435a:	ffffd097          	auipc	ra,0xffffd
    8000435e:	8c8080e7          	jalr	-1848(ra) # 80000c22 <copyout>
    80004362:	01650763          	beq	a0,s6,80004370 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004366:	2985                	addiw	s3,s3,1
    80004368:	0905                	addi	s2,s2,1
    8000436a:	fd3a91e3          	bne	s5,s3,8000432c <piperead+0x80>
    8000436e:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004370:	22448513          	addi	a0,s1,548
    80004374:	ffffd097          	auipc	ra,0xffffd
    80004378:	464080e7          	jalr	1124(ra) # 800017d8 <wakeup>
  release(&pi->lock);
    8000437c:	8526                	mv	a0,s1
    8000437e:	00002097          	auipc	ra,0x2
    80004382:	5e4080e7          	jalr	1508(ra) # 80006962 <release>
    80004386:	6b42                	ld	s6,16(sp)
  return i;
}
    80004388:	854e                	mv	a0,s3
    8000438a:	60a6                	ld	ra,72(sp)
    8000438c:	6406                	ld	s0,64(sp)
    8000438e:	74e2                	ld	s1,56(sp)
    80004390:	7942                	ld	s2,48(sp)
    80004392:	79a2                	ld	s3,40(sp)
    80004394:	7a02                	ld	s4,32(sp)
    80004396:	6ae2                	ld	s5,24(sp)
    80004398:	6161                	addi	sp,sp,80
    8000439a:	8082                	ret

000000008000439c <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000439c:	df010113          	addi	sp,sp,-528
    800043a0:	20113423          	sd	ra,520(sp)
    800043a4:	20813023          	sd	s0,512(sp)
    800043a8:	ffa6                	sd	s1,504(sp)
    800043aa:	fbca                	sd	s2,496(sp)
    800043ac:	0c00                	addi	s0,sp,528
    800043ae:	892a                	mv	s2,a0
    800043b0:	dea43c23          	sd	a0,-520(s0)
    800043b4:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800043b8:	ffffd097          	auipc	ra,0xffffd
    800043bc:	bce080e7          	jalr	-1074(ra) # 80000f86 <myproc>
    800043c0:	84aa                	mv	s1,a0

  begin_op();
    800043c2:	fffff097          	auipc	ra,0xfffff
    800043c6:	456080e7          	jalr	1110(ra) # 80003818 <begin_op>

  if((ip = namei(path)) == 0){
    800043ca:	854a                	mv	a0,s2
    800043cc:	fffff097          	auipc	ra,0xfffff
    800043d0:	24c080e7          	jalr	588(ra) # 80003618 <namei>
    800043d4:	c135                	beqz	a0,80004438 <exec+0x9c>
    800043d6:	f3d2                	sd	s4,480(sp)
    800043d8:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800043da:	fffff097          	auipc	ra,0xfffff
    800043de:	a6c080e7          	jalr	-1428(ra) # 80002e46 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800043e2:	04000713          	li	a4,64
    800043e6:	4681                	li	a3,0
    800043e8:	e5040613          	addi	a2,s0,-432
    800043ec:	4581                	li	a1,0
    800043ee:	8552                	mv	a0,s4
    800043f0:	fffff097          	auipc	ra,0xfffff
    800043f4:	d0e080e7          	jalr	-754(ra) # 800030fe <readi>
    800043f8:	04000793          	li	a5,64
    800043fc:	00f51a63          	bne	a0,a5,80004410 <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004400:	e5042703          	lw	a4,-432(s0)
    80004404:	464c47b7          	lui	a5,0x464c4
    80004408:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000440c:	02f70c63          	beq	a4,a5,80004444 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004410:	8552                	mv	a0,s4
    80004412:	fffff097          	auipc	ra,0xfffff
    80004416:	c9a080e7          	jalr	-870(ra) # 800030ac <iunlockput>
    end_op();
    8000441a:	fffff097          	auipc	ra,0xfffff
    8000441e:	478080e7          	jalr	1144(ra) # 80003892 <end_op>
  }
  return -1;
    80004422:	557d                	li	a0,-1
    80004424:	7a1e                	ld	s4,480(sp)
}
    80004426:	20813083          	ld	ra,520(sp)
    8000442a:	20013403          	ld	s0,512(sp)
    8000442e:	74fe                	ld	s1,504(sp)
    80004430:	795e                	ld	s2,496(sp)
    80004432:	21010113          	addi	sp,sp,528
    80004436:	8082                	ret
    end_op();
    80004438:	fffff097          	auipc	ra,0xfffff
    8000443c:	45a080e7          	jalr	1114(ra) # 80003892 <end_op>
    return -1;
    80004440:	557d                	li	a0,-1
    80004442:	b7d5                	j	80004426 <exec+0x8a>
    80004444:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004446:	8526                	mv	a0,s1
    80004448:	ffffd097          	auipc	ra,0xffffd
    8000444c:	c02080e7          	jalr	-1022(ra) # 8000104a <proc_pagetable>
    80004450:	8b2a                	mv	s6,a0
    80004452:	30050563          	beqz	a0,8000475c <exec+0x3c0>
    80004456:	f7ce                	sd	s3,488(sp)
    80004458:	efd6                	sd	s5,472(sp)
    8000445a:	e7de                	sd	s7,456(sp)
    8000445c:	e3e2                	sd	s8,448(sp)
    8000445e:	ff66                	sd	s9,440(sp)
    80004460:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004462:	e7042d03          	lw	s10,-400(s0)
    80004466:	e8845783          	lhu	a5,-376(s0)
    8000446a:	14078563          	beqz	a5,800045b4 <exec+0x218>
    8000446e:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004470:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004472:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    80004474:	6c85                	lui	s9,0x1
    80004476:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000447a:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000447e:	6a85                	lui	s5,0x1
    80004480:	a0b5                	j	800044ec <exec+0x150>
      panic("loadseg: address should exist");
    80004482:	00004517          	auipc	a0,0x4
    80004486:	0e650513          	addi	a0,a0,230 # 80008568 <etext+0x568>
    8000448a:	00002097          	auipc	ra,0x2
    8000448e:	eac080e7          	jalr	-340(ra) # 80006336 <panic>
    if(sz - i < PGSIZE)
    80004492:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004494:	8726                	mv	a4,s1
    80004496:	012c06bb          	addw	a3,s8,s2
    8000449a:	4581                	li	a1,0
    8000449c:	8552                	mv	a0,s4
    8000449e:	fffff097          	auipc	ra,0xfffff
    800044a2:	c60080e7          	jalr	-928(ra) # 800030fe <readi>
    800044a6:	2501                	sext.w	a0,a0
    800044a8:	26a49e63          	bne	s1,a0,80004724 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    800044ac:	012a893b          	addw	s2,s5,s2
    800044b0:	03397563          	bgeu	s2,s3,800044da <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    800044b4:	02091593          	slli	a1,s2,0x20
    800044b8:	9181                	srli	a1,a1,0x20
    800044ba:	95de                	add	a1,a1,s7
    800044bc:	855a                	mv	a0,s6
    800044be:	ffffc097          	auipc	ra,0xffffc
    800044c2:	144080e7          	jalr	324(ra) # 80000602 <walkaddr>
    800044c6:	862a                	mv	a2,a0
    if(pa == 0)
    800044c8:	dd4d                	beqz	a0,80004482 <exec+0xe6>
    if(sz - i < PGSIZE)
    800044ca:	412984bb          	subw	s1,s3,s2
    800044ce:	0004879b          	sext.w	a5,s1
    800044d2:	fcfcf0e3          	bgeu	s9,a5,80004492 <exec+0xf6>
    800044d6:	84d6                	mv	s1,s5
    800044d8:	bf6d                	j	80004492 <exec+0xf6>
    sz = sz1;
    800044da:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044de:	2d85                	addiw	s11,s11,1
    800044e0:	038d0d1b          	addiw	s10,s10,56
    800044e4:	e8845783          	lhu	a5,-376(s0)
    800044e8:	06fddf63          	bge	s11,a5,80004566 <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044ec:	2d01                	sext.w	s10,s10
    800044ee:	03800713          	li	a4,56
    800044f2:	86ea                	mv	a3,s10
    800044f4:	e1840613          	addi	a2,s0,-488
    800044f8:	4581                	li	a1,0
    800044fa:	8552                	mv	a0,s4
    800044fc:	fffff097          	auipc	ra,0xfffff
    80004500:	c02080e7          	jalr	-1022(ra) # 800030fe <readi>
    80004504:	03800793          	li	a5,56
    80004508:	1ef51863          	bne	a0,a5,800046f8 <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    8000450c:	e1842783          	lw	a5,-488(s0)
    80004510:	4705                	li	a4,1
    80004512:	fce796e3          	bne	a5,a4,800044de <exec+0x142>
    if(ph.memsz < ph.filesz)
    80004516:	e4043603          	ld	a2,-448(s0)
    8000451a:	e3843783          	ld	a5,-456(s0)
    8000451e:	1ef66163          	bltu	a2,a5,80004700 <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004522:	e2843783          	ld	a5,-472(s0)
    80004526:	963e                	add	a2,a2,a5
    80004528:	1ef66063          	bltu	a2,a5,80004708 <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000452c:	85a6                	mv	a1,s1
    8000452e:	855a                	mv	a0,s6
    80004530:	ffffc097          	auipc	ra,0xffffc
    80004534:	496080e7          	jalr	1174(ra) # 800009c6 <uvmalloc>
    80004538:	e0a43423          	sd	a0,-504(s0)
    8000453c:	1c050a63          	beqz	a0,80004710 <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    80004540:	e2843b83          	ld	s7,-472(s0)
    80004544:	df043783          	ld	a5,-528(s0)
    80004548:	00fbf7b3          	and	a5,s7,a5
    8000454c:	1c079a63          	bnez	a5,80004720 <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004550:	e2042c03          	lw	s8,-480(s0)
    80004554:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004558:	00098463          	beqz	s3,80004560 <exec+0x1c4>
    8000455c:	4901                	li	s2,0
    8000455e:	bf99                	j	800044b4 <exec+0x118>
    sz = sz1;
    80004560:	e0843483          	ld	s1,-504(s0)
    80004564:	bfad                	j	800044de <exec+0x142>
    80004566:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004568:	8552                	mv	a0,s4
    8000456a:	fffff097          	auipc	ra,0xfffff
    8000456e:	b42080e7          	jalr	-1214(ra) # 800030ac <iunlockput>
  end_op();
    80004572:	fffff097          	auipc	ra,0xfffff
    80004576:	320080e7          	jalr	800(ra) # 80003892 <end_op>
  p = myproc();
    8000457a:	ffffd097          	auipc	ra,0xffffd
    8000457e:	a0c080e7          	jalr	-1524(ra) # 80000f86 <myproc>
    80004582:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004584:	05053c83          	ld	s9,80(a0)
  sz = PGROUNDUP(sz);
    80004588:	6985                	lui	s3,0x1
    8000458a:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000458c:	99a6                	add	s3,s3,s1
    8000458e:	77fd                	lui	a5,0xfffff
    80004590:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004594:	6609                	lui	a2,0x2
    80004596:	964e                	add	a2,a2,s3
    80004598:	85ce                	mv	a1,s3
    8000459a:	855a                	mv	a0,s6
    8000459c:	ffffc097          	auipc	ra,0xffffc
    800045a0:	42a080e7          	jalr	1066(ra) # 800009c6 <uvmalloc>
    800045a4:	892a                	mv	s2,a0
    800045a6:	e0a43423          	sd	a0,-504(s0)
    800045aa:	e519                	bnez	a0,800045b8 <exec+0x21c>
  if(pagetable)
    800045ac:	e1343423          	sd	s3,-504(s0)
    800045b0:	4a01                	li	s4,0
    800045b2:	aa95                	j	80004726 <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800045b4:	4481                	li	s1,0
    800045b6:	bf4d                	j	80004568 <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    800045b8:	75f9                	lui	a1,0xffffe
    800045ba:	95aa                	add	a1,a1,a0
    800045bc:	855a                	mv	a0,s6
    800045be:	ffffc097          	auipc	ra,0xffffc
    800045c2:	632080e7          	jalr	1586(ra) # 80000bf0 <uvmclear>
  stackbase = sp - PGSIZE;
    800045c6:	7bfd                	lui	s7,0xfffff
    800045c8:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800045ca:	e0043783          	ld	a5,-512(s0)
    800045ce:	6388                	ld	a0,0(a5)
    800045d0:	c52d                	beqz	a0,8000463a <exec+0x29e>
    800045d2:	e9040993          	addi	s3,s0,-368
    800045d6:	f9040c13          	addi	s8,s0,-112
    800045da:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800045dc:	ffffc097          	auipc	ra,0xffffc
    800045e0:	e0c080e7          	jalr	-500(ra) # 800003e8 <strlen>
    800045e4:	0015079b          	addiw	a5,a0,1
    800045e8:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800045ec:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800045f0:	13796463          	bltu	s2,s7,80004718 <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800045f4:	e0043d03          	ld	s10,-512(s0)
    800045f8:	000d3a03          	ld	s4,0(s10)
    800045fc:	8552                	mv	a0,s4
    800045fe:	ffffc097          	auipc	ra,0xffffc
    80004602:	dea080e7          	jalr	-534(ra) # 800003e8 <strlen>
    80004606:	0015069b          	addiw	a3,a0,1
    8000460a:	8652                	mv	a2,s4
    8000460c:	85ca                	mv	a1,s2
    8000460e:	855a                	mv	a0,s6
    80004610:	ffffc097          	auipc	ra,0xffffc
    80004614:	612080e7          	jalr	1554(ra) # 80000c22 <copyout>
    80004618:	10054263          	bltz	a0,8000471c <exec+0x380>
    ustack[argc] = sp;
    8000461c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004620:	0485                	addi	s1,s1,1
    80004622:	008d0793          	addi	a5,s10,8
    80004626:	e0f43023          	sd	a5,-512(s0)
    8000462a:	008d3503          	ld	a0,8(s10)
    8000462e:	c909                	beqz	a0,80004640 <exec+0x2a4>
    if(argc >= MAXARG)
    80004630:	09a1                	addi	s3,s3,8
    80004632:	fb8995e3          	bne	s3,s8,800045dc <exec+0x240>
  ip = 0;
    80004636:	4a01                	li	s4,0
    80004638:	a0fd                	j	80004726 <exec+0x38a>
  sp = sz;
    8000463a:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000463e:	4481                	li	s1,0
  ustack[argc] = 0;
    80004640:	00349793          	slli	a5,s1,0x3
    80004644:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd0d48>
    80004648:	97a2                	add	a5,a5,s0
    8000464a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000464e:	00148693          	addi	a3,s1,1
    80004652:	068e                	slli	a3,a3,0x3
    80004654:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004658:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000465c:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004660:	f57966e3          	bltu	s2,s7,800045ac <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004664:	e9040613          	addi	a2,s0,-368
    80004668:	85ca                	mv	a1,s2
    8000466a:	855a                	mv	a0,s6
    8000466c:	ffffc097          	auipc	ra,0xffffc
    80004670:	5b6080e7          	jalr	1462(ra) # 80000c22 <copyout>
    80004674:	0e054663          	bltz	a0,80004760 <exec+0x3c4>
  p->trapframe->a1 = sp;
    80004678:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    8000467c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004680:	df843783          	ld	a5,-520(s0)
    80004684:	0007c703          	lbu	a4,0(a5)
    80004688:	cf11                	beqz	a4,800046a4 <exec+0x308>
    8000468a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000468c:	02f00693          	li	a3,47
    80004690:	a039                	j	8000469e <exec+0x302>
      last = s+1;
    80004692:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004696:	0785                	addi	a5,a5,1
    80004698:	fff7c703          	lbu	a4,-1(a5)
    8000469c:	c701                	beqz	a4,800046a4 <exec+0x308>
    if(*s == '/')
    8000469e:	fed71ce3          	bne	a4,a3,80004696 <exec+0x2fa>
    800046a2:	bfc5                	j	80004692 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    800046a4:	4641                	li	a2,16
    800046a6:	df843583          	ld	a1,-520(s0)
    800046aa:	160a8513          	addi	a0,s5,352
    800046ae:	ffffc097          	auipc	ra,0xffffc
    800046b2:	d08080e7          	jalr	-760(ra) # 800003b6 <safestrcpy>
  oldpagetable = p->pagetable;
    800046b6:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    800046ba:	056abc23          	sd	s6,88(s5)
  p->sz = sz;
    800046be:	e0843783          	ld	a5,-504(s0)
    800046c2:	04fab823          	sd	a5,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800046c6:	060ab783          	ld	a5,96(s5)
    800046ca:	e6843703          	ld	a4,-408(s0)
    800046ce:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800046d0:	060ab783          	ld	a5,96(s5)
    800046d4:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800046d8:	85e6                	mv	a1,s9
    800046da:	ffffd097          	auipc	ra,0xffffd
    800046de:	a0c080e7          	jalr	-1524(ra) # 800010e6 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800046e2:	0004851b          	sext.w	a0,s1
    800046e6:	79be                	ld	s3,488(sp)
    800046e8:	7a1e                	ld	s4,480(sp)
    800046ea:	6afe                	ld	s5,472(sp)
    800046ec:	6b5e                	ld	s6,464(sp)
    800046ee:	6bbe                	ld	s7,456(sp)
    800046f0:	6c1e                	ld	s8,448(sp)
    800046f2:	7cfa                	ld	s9,440(sp)
    800046f4:	7d5a                	ld	s10,432(sp)
    800046f6:	bb05                	j	80004426 <exec+0x8a>
    800046f8:	e0943423          	sd	s1,-504(s0)
    800046fc:	7dba                	ld	s11,424(sp)
    800046fe:	a025                	j	80004726 <exec+0x38a>
    80004700:	e0943423          	sd	s1,-504(s0)
    80004704:	7dba                	ld	s11,424(sp)
    80004706:	a005                	j	80004726 <exec+0x38a>
    80004708:	e0943423          	sd	s1,-504(s0)
    8000470c:	7dba                	ld	s11,424(sp)
    8000470e:	a821                	j	80004726 <exec+0x38a>
    80004710:	e0943423          	sd	s1,-504(s0)
    80004714:	7dba                	ld	s11,424(sp)
    80004716:	a801                	j	80004726 <exec+0x38a>
  ip = 0;
    80004718:	4a01                	li	s4,0
    8000471a:	a031                	j	80004726 <exec+0x38a>
    8000471c:	4a01                	li	s4,0
  if(pagetable)
    8000471e:	a021                	j	80004726 <exec+0x38a>
    80004720:	7dba                	ld	s11,424(sp)
    80004722:	a011                	j	80004726 <exec+0x38a>
    80004724:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004726:	e0843583          	ld	a1,-504(s0)
    8000472a:	855a                	mv	a0,s6
    8000472c:	ffffd097          	auipc	ra,0xffffd
    80004730:	9ba080e7          	jalr	-1606(ra) # 800010e6 <proc_freepagetable>
  return -1;
    80004734:	557d                	li	a0,-1
  if(ip){
    80004736:	000a1b63          	bnez	s4,8000474c <exec+0x3b0>
    8000473a:	79be                	ld	s3,488(sp)
    8000473c:	7a1e                	ld	s4,480(sp)
    8000473e:	6afe                	ld	s5,472(sp)
    80004740:	6b5e                	ld	s6,464(sp)
    80004742:	6bbe                	ld	s7,456(sp)
    80004744:	6c1e                	ld	s8,448(sp)
    80004746:	7cfa                	ld	s9,440(sp)
    80004748:	7d5a                	ld	s10,432(sp)
    8000474a:	b9f1                	j	80004426 <exec+0x8a>
    8000474c:	79be                	ld	s3,488(sp)
    8000474e:	6afe                	ld	s5,472(sp)
    80004750:	6b5e                	ld	s6,464(sp)
    80004752:	6bbe                	ld	s7,456(sp)
    80004754:	6c1e                	ld	s8,448(sp)
    80004756:	7cfa                	ld	s9,440(sp)
    80004758:	7d5a                	ld	s10,432(sp)
    8000475a:	b95d                	j	80004410 <exec+0x74>
    8000475c:	6b5e                	ld	s6,464(sp)
    8000475e:	b94d                	j	80004410 <exec+0x74>
  sz = sz1;
    80004760:	e0843983          	ld	s3,-504(s0)
    80004764:	b5a1                	j	800045ac <exec+0x210>

0000000080004766 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004766:	7179                	addi	sp,sp,-48
    80004768:	f406                	sd	ra,40(sp)
    8000476a:	f022                	sd	s0,32(sp)
    8000476c:	ec26                	sd	s1,24(sp)
    8000476e:	e84a                	sd	s2,16(sp)
    80004770:	1800                	addi	s0,sp,48
    80004772:	892e                	mv	s2,a1
    80004774:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004776:	fdc40593          	addi	a1,s0,-36
    8000477a:	ffffe097          	auipc	ra,0xffffe
    8000477e:	8cc080e7          	jalr	-1844(ra) # 80002046 <argint>
    80004782:	04054063          	bltz	a0,800047c2 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004786:	fdc42703          	lw	a4,-36(s0)
    8000478a:	47bd                	li	a5,15
    8000478c:	02e7ed63          	bltu	a5,a4,800047c6 <argfd+0x60>
    80004790:	ffffc097          	auipc	ra,0xffffc
    80004794:	7f6080e7          	jalr	2038(ra) # 80000f86 <myproc>
    80004798:	fdc42703          	lw	a4,-36(s0)
    8000479c:	01a70793          	addi	a5,a4,26
    800047a0:	078e                	slli	a5,a5,0x3
    800047a2:	953e                	add	a0,a0,a5
    800047a4:	651c                	ld	a5,8(a0)
    800047a6:	c395                	beqz	a5,800047ca <argfd+0x64>
    return -1;
  if(pfd)
    800047a8:	00090463          	beqz	s2,800047b0 <argfd+0x4a>
    *pfd = fd;
    800047ac:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800047b0:	4501                	li	a0,0
  if(pf)
    800047b2:	c091                	beqz	s1,800047b6 <argfd+0x50>
    *pf = f;
    800047b4:	e09c                	sd	a5,0(s1)
}
    800047b6:	70a2                	ld	ra,40(sp)
    800047b8:	7402                	ld	s0,32(sp)
    800047ba:	64e2                	ld	s1,24(sp)
    800047bc:	6942                	ld	s2,16(sp)
    800047be:	6145                	addi	sp,sp,48
    800047c0:	8082                	ret
    return -1;
    800047c2:	557d                	li	a0,-1
    800047c4:	bfcd                	j	800047b6 <argfd+0x50>
    return -1;
    800047c6:	557d                	li	a0,-1
    800047c8:	b7fd                	j	800047b6 <argfd+0x50>
    800047ca:	557d                	li	a0,-1
    800047cc:	b7ed                	j	800047b6 <argfd+0x50>

00000000800047ce <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800047ce:	1101                	addi	sp,sp,-32
    800047d0:	ec06                	sd	ra,24(sp)
    800047d2:	e822                	sd	s0,16(sp)
    800047d4:	e426                	sd	s1,8(sp)
    800047d6:	1000                	addi	s0,sp,32
    800047d8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800047da:	ffffc097          	auipc	ra,0xffffc
    800047de:	7ac080e7          	jalr	1964(ra) # 80000f86 <myproc>
    800047e2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800047e4:	0d850793          	addi	a5,a0,216
    800047e8:	4501                	li	a0,0
    800047ea:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800047ec:	6398                	ld	a4,0(a5)
    800047ee:	cb19                	beqz	a4,80004804 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800047f0:	2505                	addiw	a0,a0,1
    800047f2:	07a1                	addi	a5,a5,8
    800047f4:	fed51ce3          	bne	a0,a3,800047ec <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800047f8:	557d                	li	a0,-1
}
    800047fa:	60e2                	ld	ra,24(sp)
    800047fc:	6442                	ld	s0,16(sp)
    800047fe:	64a2                	ld	s1,8(sp)
    80004800:	6105                	addi	sp,sp,32
    80004802:	8082                	ret
      p->ofile[fd] = f;
    80004804:	01a50793          	addi	a5,a0,26
    80004808:	078e                	slli	a5,a5,0x3
    8000480a:	963e                	add	a2,a2,a5
    8000480c:	e604                	sd	s1,8(a2)
      return fd;
    8000480e:	b7f5                	j	800047fa <fdalloc+0x2c>

0000000080004810 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004810:	715d                	addi	sp,sp,-80
    80004812:	e486                	sd	ra,72(sp)
    80004814:	e0a2                	sd	s0,64(sp)
    80004816:	fc26                	sd	s1,56(sp)
    80004818:	f84a                	sd	s2,48(sp)
    8000481a:	f44e                	sd	s3,40(sp)
    8000481c:	f052                	sd	s4,32(sp)
    8000481e:	ec56                	sd	s5,24(sp)
    80004820:	0880                	addi	s0,sp,80
    80004822:	8aae                	mv	s5,a1
    80004824:	8a32                	mv	s4,a2
    80004826:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004828:	fb040593          	addi	a1,s0,-80
    8000482c:	fffff097          	auipc	ra,0xfffff
    80004830:	e0a080e7          	jalr	-502(ra) # 80003636 <nameiparent>
    80004834:	892a                	mv	s2,a0
    80004836:	12050c63          	beqz	a0,8000496e <create+0x15e>
    return 0;

  ilock(dp);
    8000483a:	ffffe097          	auipc	ra,0xffffe
    8000483e:	60c080e7          	jalr	1548(ra) # 80002e46 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004842:	4601                	li	a2,0
    80004844:	fb040593          	addi	a1,s0,-80
    80004848:	854a                	mv	a0,s2
    8000484a:	fffff097          	auipc	ra,0xfffff
    8000484e:	afc080e7          	jalr	-1284(ra) # 80003346 <dirlookup>
    80004852:	84aa                	mv	s1,a0
    80004854:	c539                	beqz	a0,800048a2 <create+0x92>
    iunlockput(dp);
    80004856:	854a                	mv	a0,s2
    80004858:	fffff097          	auipc	ra,0xfffff
    8000485c:	854080e7          	jalr	-1964(ra) # 800030ac <iunlockput>
    ilock(ip);
    80004860:	8526                	mv	a0,s1
    80004862:	ffffe097          	auipc	ra,0xffffe
    80004866:	5e4080e7          	jalr	1508(ra) # 80002e46 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000486a:	4789                	li	a5,2
    8000486c:	02fa9463          	bne	s5,a5,80004894 <create+0x84>
    80004870:	04c4d783          	lhu	a5,76(s1)
    80004874:	37f9                	addiw	a5,a5,-2
    80004876:	17c2                	slli	a5,a5,0x30
    80004878:	93c1                	srli	a5,a5,0x30
    8000487a:	4705                	li	a4,1
    8000487c:	00f76c63          	bltu	a4,a5,80004894 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004880:	8526                	mv	a0,s1
    80004882:	60a6                	ld	ra,72(sp)
    80004884:	6406                	ld	s0,64(sp)
    80004886:	74e2                	ld	s1,56(sp)
    80004888:	7942                	ld	s2,48(sp)
    8000488a:	79a2                	ld	s3,40(sp)
    8000488c:	7a02                	ld	s4,32(sp)
    8000488e:	6ae2                	ld	s5,24(sp)
    80004890:	6161                	addi	sp,sp,80
    80004892:	8082                	ret
    iunlockput(ip);
    80004894:	8526                	mv	a0,s1
    80004896:	fffff097          	auipc	ra,0xfffff
    8000489a:	816080e7          	jalr	-2026(ra) # 800030ac <iunlockput>
    return 0;
    8000489e:	4481                	li	s1,0
    800048a0:	b7c5                	j	80004880 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    800048a2:	85d6                	mv	a1,s5
    800048a4:	00092503          	lw	a0,0(s2)
    800048a8:	ffffe097          	auipc	ra,0xffffe
    800048ac:	40a080e7          	jalr	1034(ra) # 80002cb2 <ialloc>
    800048b0:	84aa                	mv	s1,a0
    800048b2:	c139                	beqz	a0,800048f8 <create+0xe8>
  ilock(ip);
    800048b4:	ffffe097          	auipc	ra,0xffffe
    800048b8:	592080e7          	jalr	1426(ra) # 80002e46 <ilock>
  ip->major = major;
    800048bc:	05449723          	sh	s4,78(s1)
  ip->minor = minor;
    800048c0:	05349823          	sh	s3,80(s1)
  ip->nlink = 1;
    800048c4:	4985                	li	s3,1
    800048c6:	05349923          	sh	s3,82(s1)
  iupdate(ip);
    800048ca:	8526                	mv	a0,s1
    800048cc:	ffffe097          	auipc	ra,0xffffe
    800048d0:	4ae080e7          	jalr	1198(ra) # 80002d7a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800048d4:	033a8a63          	beq	s5,s3,80004908 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    800048d8:	40d0                	lw	a2,4(s1)
    800048da:	fb040593          	addi	a1,s0,-80
    800048de:	854a                	mv	a0,s2
    800048e0:	fffff097          	auipc	ra,0xfffff
    800048e4:	c76080e7          	jalr	-906(ra) # 80003556 <dirlink>
    800048e8:	06054b63          	bltz	a0,8000495e <create+0x14e>
  iunlockput(dp);
    800048ec:	854a                	mv	a0,s2
    800048ee:	ffffe097          	auipc	ra,0xffffe
    800048f2:	7be080e7          	jalr	1982(ra) # 800030ac <iunlockput>
  return ip;
    800048f6:	b769                	j	80004880 <create+0x70>
    panic("create: ialloc");
    800048f8:	00004517          	auipc	a0,0x4
    800048fc:	c9050513          	addi	a0,a0,-880 # 80008588 <etext+0x588>
    80004900:	00002097          	auipc	ra,0x2
    80004904:	a36080e7          	jalr	-1482(ra) # 80006336 <panic>
    dp->nlink++;  // for ".."
    80004908:	05295783          	lhu	a5,82(s2)
    8000490c:	2785                	addiw	a5,a5,1
    8000490e:	04f91923          	sh	a5,82(s2)
    iupdate(dp);
    80004912:	854a                	mv	a0,s2
    80004914:	ffffe097          	auipc	ra,0xffffe
    80004918:	466080e7          	jalr	1126(ra) # 80002d7a <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000491c:	40d0                	lw	a2,4(s1)
    8000491e:	00004597          	auipc	a1,0x4
    80004922:	c7a58593          	addi	a1,a1,-902 # 80008598 <etext+0x598>
    80004926:	8526                	mv	a0,s1
    80004928:	fffff097          	auipc	ra,0xfffff
    8000492c:	c2e080e7          	jalr	-978(ra) # 80003556 <dirlink>
    80004930:	00054f63          	bltz	a0,8000494e <create+0x13e>
    80004934:	00492603          	lw	a2,4(s2)
    80004938:	00004597          	auipc	a1,0x4
    8000493c:	c6858593          	addi	a1,a1,-920 # 800085a0 <etext+0x5a0>
    80004940:	8526                	mv	a0,s1
    80004942:	fffff097          	auipc	ra,0xfffff
    80004946:	c14080e7          	jalr	-1004(ra) # 80003556 <dirlink>
    8000494a:	f80557e3          	bgez	a0,800048d8 <create+0xc8>
      panic("create dots");
    8000494e:	00004517          	auipc	a0,0x4
    80004952:	c5a50513          	addi	a0,a0,-934 # 800085a8 <etext+0x5a8>
    80004956:	00002097          	auipc	ra,0x2
    8000495a:	9e0080e7          	jalr	-1568(ra) # 80006336 <panic>
    panic("create: dirlink");
    8000495e:	00004517          	auipc	a0,0x4
    80004962:	c5a50513          	addi	a0,a0,-934 # 800085b8 <etext+0x5b8>
    80004966:	00002097          	auipc	ra,0x2
    8000496a:	9d0080e7          	jalr	-1584(ra) # 80006336 <panic>
    return 0;
    8000496e:	84aa                	mv	s1,a0
    80004970:	bf01                	j	80004880 <create+0x70>

0000000080004972 <sys_dup>:
{
    80004972:	7179                	addi	sp,sp,-48
    80004974:	f406                	sd	ra,40(sp)
    80004976:	f022                	sd	s0,32(sp)
    80004978:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000497a:	fd840613          	addi	a2,s0,-40
    8000497e:	4581                	li	a1,0
    80004980:	4501                	li	a0,0
    80004982:	00000097          	auipc	ra,0x0
    80004986:	de4080e7          	jalr	-540(ra) # 80004766 <argfd>
    return -1;
    8000498a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000498c:	02054763          	bltz	a0,800049ba <sys_dup+0x48>
    80004990:	ec26                	sd	s1,24(sp)
    80004992:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004994:	fd843903          	ld	s2,-40(s0)
    80004998:	854a                	mv	a0,s2
    8000499a:	00000097          	auipc	ra,0x0
    8000499e:	e34080e7          	jalr	-460(ra) # 800047ce <fdalloc>
    800049a2:	84aa                	mv	s1,a0
    return -1;
    800049a4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800049a6:	00054f63          	bltz	a0,800049c4 <sys_dup+0x52>
  filedup(f);
    800049aa:	854a                	mv	a0,s2
    800049ac:	fffff097          	auipc	ra,0xfffff
    800049b0:	2e4080e7          	jalr	740(ra) # 80003c90 <filedup>
  return fd;
    800049b4:	87a6                	mv	a5,s1
    800049b6:	64e2                	ld	s1,24(sp)
    800049b8:	6942                	ld	s2,16(sp)
}
    800049ba:	853e                	mv	a0,a5
    800049bc:	70a2                	ld	ra,40(sp)
    800049be:	7402                	ld	s0,32(sp)
    800049c0:	6145                	addi	sp,sp,48
    800049c2:	8082                	ret
    800049c4:	64e2                	ld	s1,24(sp)
    800049c6:	6942                	ld	s2,16(sp)
    800049c8:	bfcd                	j	800049ba <sys_dup+0x48>

00000000800049ca <sys_read>:
{
    800049ca:	7179                	addi	sp,sp,-48
    800049cc:	f406                	sd	ra,40(sp)
    800049ce:	f022                	sd	s0,32(sp)
    800049d0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049d2:	fe840613          	addi	a2,s0,-24
    800049d6:	4581                	li	a1,0
    800049d8:	4501                	li	a0,0
    800049da:	00000097          	auipc	ra,0x0
    800049de:	d8c080e7          	jalr	-628(ra) # 80004766 <argfd>
    return -1;
    800049e2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049e4:	04054163          	bltz	a0,80004a26 <sys_read+0x5c>
    800049e8:	fe440593          	addi	a1,s0,-28
    800049ec:	4509                	li	a0,2
    800049ee:	ffffd097          	auipc	ra,0xffffd
    800049f2:	658080e7          	jalr	1624(ra) # 80002046 <argint>
    return -1;
    800049f6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049f8:	02054763          	bltz	a0,80004a26 <sys_read+0x5c>
    800049fc:	fd840593          	addi	a1,s0,-40
    80004a00:	4505                	li	a0,1
    80004a02:	ffffd097          	auipc	ra,0xffffd
    80004a06:	666080e7          	jalr	1638(ra) # 80002068 <argaddr>
    return -1;
    80004a0a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a0c:	00054d63          	bltz	a0,80004a26 <sys_read+0x5c>
  return fileread(f, p, n);
    80004a10:	fe442603          	lw	a2,-28(s0)
    80004a14:	fd843583          	ld	a1,-40(s0)
    80004a18:	fe843503          	ld	a0,-24(s0)
    80004a1c:	fffff097          	auipc	ra,0xfffff
    80004a20:	41a080e7          	jalr	1050(ra) # 80003e36 <fileread>
    80004a24:	87aa                	mv	a5,a0
}
    80004a26:	853e                	mv	a0,a5
    80004a28:	70a2                	ld	ra,40(sp)
    80004a2a:	7402                	ld	s0,32(sp)
    80004a2c:	6145                	addi	sp,sp,48
    80004a2e:	8082                	ret

0000000080004a30 <sys_write>:
{
    80004a30:	7179                	addi	sp,sp,-48
    80004a32:	f406                	sd	ra,40(sp)
    80004a34:	f022                	sd	s0,32(sp)
    80004a36:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a38:	fe840613          	addi	a2,s0,-24
    80004a3c:	4581                	li	a1,0
    80004a3e:	4501                	li	a0,0
    80004a40:	00000097          	auipc	ra,0x0
    80004a44:	d26080e7          	jalr	-730(ra) # 80004766 <argfd>
    return -1;
    80004a48:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a4a:	04054163          	bltz	a0,80004a8c <sys_write+0x5c>
    80004a4e:	fe440593          	addi	a1,s0,-28
    80004a52:	4509                	li	a0,2
    80004a54:	ffffd097          	auipc	ra,0xffffd
    80004a58:	5f2080e7          	jalr	1522(ra) # 80002046 <argint>
    return -1;
    80004a5c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a5e:	02054763          	bltz	a0,80004a8c <sys_write+0x5c>
    80004a62:	fd840593          	addi	a1,s0,-40
    80004a66:	4505                	li	a0,1
    80004a68:	ffffd097          	auipc	ra,0xffffd
    80004a6c:	600080e7          	jalr	1536(ra) # 80002068 <argaddr>
    return -1;
    80004a70:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a72:	00054d63          	bltz	a0,80004a8c <sys_write+0x5c>
  return filewrite(f, p, n);
    80004a76:	fe442603          	lw	a2,-28(s0)
    80004a7a:	fd843583          	ld	a1,-40(s0)
    80004a7e:	fe843503          	ld	a0,-24(s0)
    80004a82:	fffff097          	auipc	ra,0xfffff
    80004a86:	486080e7          	jalr	1158(ra) # 80003f08 <filewrite>
    80004a8a:	87aa                	mv	a5,a0
}
    80004a8c:	853e                	mv	a0,a5
    80004a8e:	70a2                	ld	ra,40(sp)
    80004a90:	7402                	ld	s0,32(sp)
    80004a92:	6145                	addi	sp,sp,48
    80004a94:	8082                	ret

0000000080004a96 <sys_close>:
{
    80004a96:	1101                	addi	sp,sp,-32
    80004a98:	ec06                	sd	ra,24(sp)
    80004a9a:	e822                	sd	s0,16(sp)
    80004a9c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004a9e:	fe040613          	addi	a2,s0,-32
    80004aa2:	fec40593          	addi	a1,s0,-20
    80004aa6:	4501                	li	a0,0
    80004aa8:	00000097          	auipc	ra,0x0
    80004aac:	cbe080e7          	jalr	-834(ra) # 80004766 <argfd>
    return -1;
    80004ab0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004ab2:	02054463          	bltz	a0,80004ada <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004ab6:	ffffc097          	auipc	ra,0xffffc
    80004aba:	4d0080e7          	jalr	1232(ra) # 80000f86 <myproc>
    80004abe:	fec42783          	lw	a5,-20(s0)
    80004ac2:	07e9                	addi	a5,a5,26
    80004ac4:	078e                	slli	a5,a5,0x3
    80004ac6:	953e                	add	a0,a0,a5
    80004ac8:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004acc:	fe043503          	ld	a0,-32(s0)
    80004ad0:	fffff097          	auipc	ra,0xfffff
    80004ad4:	212080e7          	jalr	530(ra) # 80003ce2 <fileclose>
  return 0;
    80004ad8:	4781                	li	a5,0
}
    80004ada:	853e                	mv	a0,a5
    80004adc:	60e2                	ld	ra,24(sp)
    80004ade:	6442                	ld	s0,16(sp)
    80004ae0:	6105                	addi	sp,sp,32
    80004ae2:	8082                	ret

0000000080004ae4 <sys_fstat>:
{
    80004ae4:	1101                	addi	sp,sp,-32
    80004ae6:	ec06                	sd	ra,24(sp)
    80004ae8:	e822                	sd	s0,16(sp)
    80004aea:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004aec:	fe840613          	addi	a2,s0,-24
    80004af0:	4581                	li	a1,0
    80004af2:	4501                	li	a0,0
    80004af4:	00000097          	auipc	ra,0x0
    80004af8:	c72080e7          	jalr	-910(ra) # 80004766 <argfd>
    return -1;
    80004afc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004afe:	02054563          	bltz	a0,80004b28 <sys_fstat+0x44>
    80004b02:	fe040593          	addi	a1,s0,-32
    80004b06:	4505                	li	a0,1
    80004b08:	ffffd097          	auipc	ra,0xffffd
    80004b0c:	560080e7          	jalr	1376(ra) # 80002068 <argaddr>
    return -1;
    80004b10:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004b12:	00054b63          	bltz	a0,80004b28 <sys_fstat+0x44>
  return filestat(f, st);
    80004b16:	fe043583          	ld	a1,-32(s0)
    80004b1a:	fe843503          	ld	a0,-24(s0)
    80004b1e:	fffff097          	auipc	ra,0xfffff
    80004b22:	2a6080e7          	jalr	678(ra) # 80003dc4 <filestat>
    80004b26:	87aa                	mv	a5,a0
}
    80004b28:	853e                	mv	a0,a5
    80004b2a:	60e2                	ld	ra,24(sp)
    80004b2c:	6442                	ld	s0,16(sp)
    80004b2e:	6105                	addi	sp,sp,32
    80004b30:	8082                	ret

0000000080004b32 <sys_link>:
{
    80004b32:	7169                	addi	sp,sp,-304
    80004b34:	f606                	sd	ra,296(sp)
    80004b36:	f222                	sd	s0,288(sp)
    80004b38:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b3a:	08000613          	li	a2,128
    80004b3e:	ed040593          	addi	a1,s0,-304
    80004b42:	4501                	li	a0,0
    80004b44:	ffffd097          	auipc	ra,0xffffd
    80004b48:	546080e7          	jalr	1350(ra) # 8000208a <argstr>
    return -1;
    80004b4c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b4e:	12054663          	bltz	a0,80004c7a <sys_link+0x148>
    80004b52:	08000613          	li	a2,128
    80004b56:	f5040593          	addi	a1,s0,-176
    80004b5a:	4505                	li	a0,1
    80004b5c:	ffffd097          	auipc	ra,0xffffd
    80004b60:	52e080e7          	jalr	1326(ra) # 8000208a <argstr>
    return -1;
    80004b64:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b66:	10054a63          	bltz	a0,80004c7a <sys_link+0x148>
    80004b6a:	ee26                	sd	s1,280(sp)
  begin_op();
    80004b6c:	fffff097          	auipc	ra,0xfffff
    80004b70:	cac080e7          	jalr	-852(ra) # 80003818 <begin_op>
  if((ip = namei(old)) == 0){
    80004b74:	ed040513          	addi	a0,s0,-304
    80004b78:	fffff097          	auipc	ra,0xfffff
    80004b7c:	aa0080e7          	jalr	-1376(ra) # 80003618 <namei>
    80004b80:	84aa                	mv	s1,a0
    80004b82:	c949                	beqz	a0,80004c14 <sys_link+0xe2>
  ilock(ip);
    80004b84:	ffffe097          	auipc	ra,0xffffe
    80004b88:	2c2080e7          	jalr	706(ra) # 80002e46 <ilock>
  if(ip->type == T_DIR){
    80004b8c:	04c49703          	lh	a4,76(s1)
    80004b90:	4785                	li	a5,1
    80004b92:	08f70863          	beq	a4,a5,80004c22 <sys_link+0xf0>
    80004b96:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004b98:	0524d783          	lhu	a5,82(s1)
    80004b9c:	2785                	addiw	a5,a5,1
    80004b9e:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004ba2:	8526                	mv	a0,s1
    80004ba4:	ffffe097          	auipc	ra,0xffffe
    80004ba8:	1d6080e7          	jalr	470(ra) # 80002d7a <iupdate>
  iunlock(ip);
    80004bac:	8526                	mv	a0,s1
    80004bae:	ffffe097          	auipc	ra,0xffffe
    80004bb2:	35e080e7          	jalr	862(ra) # 80002f0c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004bb6:	fd040593          	addi	a1,s0,-48
    80004bba:	f5040513          	addi	a0,s0,-176
    80004bbe:	fffff097          	auipc	ra,0xfffff
    80004bc2:	a78080e7          	jalr	-1416(ra) # 80003636 <nameiparent>
    80004bc6:	892a                	mv	s2,a0
    80004bc8:	cd35                	beqz	a0,80004c44 <sys_link+0x112>
  ilock(dp);
    80004bca:	ffffe097          	auipc	ra,0xffffe
    80004bce:	27c080e7          	jalr	636(ra) # 80002e46 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004bd2:	00092703          	lw	a4,0(s2)
    80004bd6:	409c                	lw	a5,0(s1)
    80004bd8:	06f71163          	bne	a4,a5,80004c3a <sys_link+0x108>
    80004bdc:	40d0                	lw	a2,4(s1)
    80004bde:	fd040593          	addi	a1,s0,-48
    80004be2:	854a                	mv	a0,s2
    80004be4:	fffff097          	auipc	ra,0xfffff
    80004be8:	972080e7          	jalr	-1678(ra) # 80003556 <dirlink>
    80004bec:	04054763          	bltz	a0,80004c3a <sys_link+0x108>
  iunlockput(dp);
    80004bf0:	854a                	mv	a0,s2
    80004bf2:	ffffe097          	auipc	ra,0xffffe
    80004bf6:	4ba080e7          	jalr	1210(ra) # 800030ac <iunlockput>
  iput(ip);
    80004bfa:	8526                	mv	a0,s1
    80004bfc:	ffffe097          	auipc	ra,0xffffe
    80004c00:	408080e7          	jalr	1032(ra) # 80003004 <iput>
  end_op();
    80004c04:	fffff097          	auipc	ra,0xfffff
    80004c08:	c8e080e7          	jalr	-882(ra) # 80003892 <end_op>
  return 0;
    80004c0c:	4781                	li	a5,0
    80004c0e:	64f2                	ld	s1,280(sp)
    80004c10:	6952                	ld	s2,272(sp)
    80004c12:	a0a5                	j	80004c7a <sys_link+0x148>
    end_op();
    80004c14:	fffff097          	auipc	ra,0xfffff
    80004c18:	c7e080e7          	jalr	-898(ra) # 80003892 <end_op>
    return -1;
    80004c1c:	57fd                	li	a5,-1
    80004c1e:	64f2                	ld	s1,280(sp)
    80004c20:	a8a9                	j	80004c7a <sys_link+0x148>
    iunlockput(ip);
    80004c22:	8526                	mv	a0,s1
    80004c24:	ffffe097          	auipc	ra,0xffffe
    80004c28:	488080e7          	jalr	1160(ra) # 800030ac <iunlockput>
    end_op();
    80004c2c:	fffff097          	auipc	ra,0xfffff
    80004c30:	c66080e7          	jalr	-922(ra) # 80003892 <end_op>
    return -1;
    80004c34:	57fd                	li	a5,-1
    80004c36:	64f2                	ld	s1,280(sp)
    80004c38:	a089                	j	80004c7a <sys_link+0x148>
    iunlockput(dp);
    80004c3a:	854a                	mv	a0,s2
    80004c3c:	ffffe097          	auipc	ra,0xffffe
    80004c40:	470080e7          	jalr	1136(ra) # 800030ac <iunlockput>
  ilock(ip);
    80004c44:	8526                	mv	a0,s1
    80004c46:	ffffe097          	auipc	ra,0xffffe
    80004c4a:	200080e7          	jalr	512(ra) # 80002e46 <ilock>
  ip->nlink--;
    80004c4e:	0524d783          	lhu	a5,82(s1)
    80004c52:	37fd                	addiw	a5,a5,-1
    80004c54:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004c58:	8526                	mv	a0,s1
    80004c5a:	ffffe097          	auipc	ra,0xffffe
    80004c5e:	120080e7          	jalr	288(ra) # 80002d7a <iupdate>
  iunlockput(ip);
    80004c62:	8526                	mv	a0,s1
    80004c64:	ffffe097          	auipc	ra,0xffffe
    80004c68:	448080e7          	jalr	1096(ra) # 800030ac <iunlockput>
  end_op();
    80004c6c:	fffff097          	auipc	ra,0xfffff
    80004c70:	c26080e7          	jalr	-986(ra) # 80003892 <end_op>
  return -1;
    80004c74:	57fd                	li	a5,-1
    80004c76:	64f2                	ld	s1,280(sp)
    80004c78:	6952                	ld	s2,272(sp)
}
    80004c7a:	853e                	mv	a0,a5
    80004c7c:	70b2                	ld	ra,296(sp)
    80004c7e:	7412                	ld	s0,288(sp)
    80004c80:	6155                	addi	sp,sp,304
    80004c82:	8082                	ret

0000000080004c84 <sys_unlink>:
{
    80004c84:	7151                	addi	sp,sp,-240
    80004c86:	f586                	sd	ra,232(sp)
    80004c88:	f1a2                	sd	s0,224(sp)
    80004c8a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004c8c:	08000613          	li	a2,128
    80004c90:	f3040593          	addi	a1,s0,-208
    80004c94:	4501                	li	a0,0
    80004c96:	ffffd097          	auipc	ra,0xffffd
    80004c9a:	3f4080e7          	jalr	1012(ra) # 8000208a <argstr>
    80004c9e:	1a054a63          	bltz	a0,80004e52 <sys_unlink+0x1ce>
    80004ca2:	eda6                	sd	s1,216(sp)
  begin_op();
    80004ca4:	fffff097          	auipc	ra,0xfffff
    80004ca8:	b74080e7          	jalr	-1164(ra) # 80003818 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004cac:	fb040593          	addi	a1,s0,-80
    80004cb0:	f3040513          	addi	a0,s0,-208
    80004cb4:	fffff097          	auipc	ra,0xfffff
    80004cb8:	982080e7          	jalr	-1662(ra) # 80003636 <nameiparent>
    80004cbc:	84aa                	mv	s1,a0
    80004cbe:	cd71                	beqz	a0,80004d9a <sys_unlink+0x116>
  ilock(dp);
    80004cc0:	ffffe097          	auipc	ra,0xffffe
    80004cc4:	186080e7          	jalr	390(ra) # 80002e46 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004cc8:	00004597          	auipc	a1,0x4
    80004ccc:	8d058593          	addi	a1,a1,-1840 # 80008598 <etext+0x598>
    80004cd0:	fb040513          	addi	a0,s0,-80
    80004cd4:	ffffe097          	auipc	ra,0xffffe
    80004cd8:	658080e7          	jalr	1624(ra) # 8000332c <namecmp>
    80004cdc:	14050c63          	beqz	a0,80004e34 <sys_unlink+0x1b0>
    80004ce0:	00004597          	auipc	a1,0x4
    80004ce4:	8c058593          	addi	a1,a1,-1856 # 800085a0 <etext+0x5a0>
    80004ce8:	fb040513          	addi	a0,s0,-80
    80004cec:	ffffe097          	auipc	ra,0xffffe
    80004cf0:	640080e7          	jalr	1600(ra) # 8000332c <namecmp>
    80004cf4:	14050063          	beqz	a0,80004e34 <sys_unlink+0x1b0>
    80004cf8:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004cfa:	f2c40613          	addi	a2,s0,-212
    80004cfe:	fb040593          	addi	a1,s0,-80
    80004d02:	8526                	mv	a0,s1
    80004d04:	ffffe097          	auipc	ra,0xffffe
    80004d08:	642080e7          	jalr	1602(ra) # 80003346 <dirlookup>
    80004d0c:	892a                	mv	s2,a0
    80004d0e:	12050263          	beqz	a0,80004e32 <sys_unlink+0x1ae>
  ilock(ip);
    80004d12:	ffffe097          	auipc	ra,0xffffe
    80004d16:	134080e7          	jalr	308(ra) # 80002e46 <ilock>
  if(ip->nlink < 1)
    80004d1a:	05291783          	lh	a5,82(s2)
    80004d1e:	08f05563          	blez	a5,80004da8 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004d22:	04c91703          	lh	a4,76(s2)
    80004d26:	4785                	li	a5,1
    80004d28:	08f70963          	beq	a4,a5,80004dba <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004d2c:	4641                	li	a2,16
    80004d2e:	4581                	li	a1,0
    80004d30:	fc040513          	addi	a0,s0,-64
    80004d34:	ffffb097          	auipc	ra,0xffffb
    80004d38:	540080e7          	jalr	1344(ra) # 80000274 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d3c:	4741                	li	a4,16
    80004d3e:	f2c42683          	lw	a3,-212(s0)
    80004d42:	fc040613          	addi	a2,s0,-64
    80004d46:	4581                	li	a1,0
    80004d48:	8526                	mv	a0,s1
    80004d4a:	ffffe097          	auipc	ra,0xffffe
    80004d4e:	4b8080e7          	jalr	1208(ra) # 80003202 <writei>
    80004d52:	47c1                	li	a5,16
    80004d54:	0af51b63          	bne	a0,a5,80004e0a <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004d58:	04c91703          	lh	a4,76(s2)
    80004d5c:	4785                	li	a5,1
    80004d5e:	0af70f63          	beq	a4,a5,80004e1c <sys_unlink+0x198>
  iunlockput(dp);
    80004d62:	8526                	mv	a0,s1
    80004d64:	ffffe097          	auipc	ra,0xffffe
    80004d68:	348080e7          	jalr	840(ra) # 800030ac <iunlockput>
  ip->nlink--;
    80004d6c:	05295783          	lhu	a5,82(s2)
    80004d70:	37fd                	addiw	a5,a5,-1
    80004d72:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    80004d76:	854a                	mv	a0,s2
    80004d78:	ffffe097          	auipc	ra,0xffffe
    80004d7c:	002080e7          	jalr	2(ra) # 80002d7a <iupdate>
  iunlockput(ip);
    80004d80:	854a                	mv	a0,s2
    80004d82:	ffffe097          	auipc	ra,0xffffe
    80004d86:	32a080e7          	jalr	810(ra) # 800030ac <iunlockput>
  end_op();
    80004d8a:	fffff097          	auipc	ra,0xfffff
    80004d8e:	b08080e7          	jalr	-1272(ra) # 80003892 <end_op>
  return 0;
    80004d92:	4501                	li	a0,0
    80004d94:	64ee                	ld	s1,216(sp)
    80004d96:	694e                	ld	s2,208(sp)
    80004d98:	a84d                	j	80004e4a <sys_unlink+0x1c6>
    end_op();
    80004d9a:	fffff097          	auipc	ra,0xfffff
    80004d9e:	af8080e7          	jalr	-1288(ra) # 80003892 <end_op>
    return -1;
    80004da2:	557d                	li	a0,-1
    80004da4:	64ee                	ld	s1,216(sp)
    80004da6:	a055                	j	80004e4a <sys_unlink+0x1c6>
    80004da8:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004daa:	00004517          	auipc	a0,0x4
    80004dae:	81e50513          	addi	a0,a0,-2018 # 800085c8 <etext+0x5c8>
    80004db2:	00001097          	auipc	ra,0x1
    80004db6:	584080e7          	jalr	1412(ra) # 80006336 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004dba:	05492703          	lw	a4,84(s2)
    80004dbe:	02000793          	li	a5,32
    80004dc2:	f6e7f5e3          	bgeu	a5,a4,80004d2c <sys_unlink+0xa8>
    80004dc6:	e5ce                	sd	s3,200(sp)
    80004dc8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004dcc:	4741                	li	a4,16
    80004dce:	86ce                	mv	a3,s3
    80004dd0:	f1840613          	addi	a2,s0,-232
    80004dd4:	4581                	li	a1,0
    80004dd6:	854a                	mv	a0,s2
    80004dd8:	ffffe097          	auipc	ra,0xffffe
    80004ddc:	326080e7          	jalr	806(ra) # 800030fe <readi>
    80004de0:	47c1                	li	a5,16
    80004de2:	00f51c63          	bne	a0,a5,80004dfa <sys_unlink+0x176>
    if(de.inum != 0)
    80004de6:	f1845783          	lhu	a5,-232(s0)
    80004dea:	e7b5                	bnez	a5,80004e56 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004dec:	29c1                	addiw	s3,s3,16
    80004dee:	05492783          	lw	a5,84(s2)
    80004df2:	fcf9ede3          	bltu	s3,a5,80004dcc <sys_unlink+0x148>
    80004df6:	69ae                	ld	s3,200(sp)
    80004df8:	bf15                	j	80004d2c <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004dfa:	00003517          	auipc	a0,0x3
    80004dfe:	7e650513          	addi	a0,a0,2022 # 800085e0 <etext+0x5e0>
    80004e02:	00001097          	auipc	ra,0x1
    80004e06:	534080e7          	jalr	1332(ra) # 80006336 <panic>
    80004e0a:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004e0c:	00003517          	auipc	a0,0x3
    80004e10:	7ec50513          	addi	a0,a0,2028 # 800085f8 <etext+0x5f8>
    80004e14:	00001097          	auipc	ra,0x1
    80004e18:	522080e7          	jalr	1314(ra) # 80006336 <panic>
    dp->nlink--;
    80004e1c:	0524d783          	lhu	a5,82(s1)
    80004e20:	37fd                	addiw	a5,a5,-1
    80004e22:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    80004e26:	8526                	mv	a0,s1
    80004e28:	ffffe097          	auipc	ra,0xffffe
    80004e2c:	f52080e7          	jalr	-174(ra) # 80002d7a <iupdate>
    80004e30:	bf0d                	j	80004d62 <sys_unlink+0xde>
    80004e32:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004e34:	8526                	mv	a0,s1
    80004e36:	ffffe097          	auipc	ra,0xffffe
    80004e3a:	276080e7          	jalr	630(ra) # 800030ac <iunlockput>
  end_op();
    80004e3e:	fffff097          	auipc	ra,0xfffff
    80004e42:	a54080e7          	jalr	-1452(ra) # 80003892 <end_op>
  return -1;
    80004e46:	557d                	li	a0,-1
    80004e48:	64ee                	ld	s1,216(sp)
}
    80004e4a:	70ae                	ld	ra,232(sp)
    80004e4c:	740e                	ld	s0,224(sp)
    80004e4e:	616d                	addi	sp,sp,240
    80004e50:	8082                	ret
    return -1;
    80004e52:	557d                	li	a0,-1
    80004e54:	bfdd                	j	80004e4a <sys_unlink+0x1c6>
    iunlockput(ip);
    80004e56:	854a                	mv	a0,s2
    80004e58:	ffffe097          	auipc	ra,0xffffe
    80004e5c:	254080e7          	jalr	596(ra) # 800030ac <iunlockput>
    goto bad;
    80004e60:	694e                	ld	s2,208(sp)
    80004e62:	69ae                	ld	s3,200(sp)
    80004e64:	bfc1                	j	80004e34 <sys_unlink+0x1b0>

0000000080004e66 <sys_open>:

uint64
sys_open(void)
{
    80004e66:	7131                	addi	sp,sp,-192
    80004e68:	fd06                	sd	ra,184(sp)
    80004e6a:	f922                	sd	s0,176(sp)
    80004e6c:	f526                	sd	s1,168(sp)
    80004e6e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004e70:	08000613          	li	a2,128
    80004e74:	f5040593          	addi	a1,s0,-176
    80004e78:	4501                	li	a0,0
    80004e7a:	ffffd097          	auipc	ra,0xffffd
    80004e7e:	210080e7          	jalr	528(ra) # 8000208a <argstr>
    return -1;
    80004e82:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004e84:	0c054463          	bltz	a0,80004f4c <sys_open+0xe6>
    80004e88:	f4c40593          	addi	a1,s0,-180
    80004e8c:	4505                	li	a0,1
    80004e8e:	ffffd097          	auipc	ra,0xffffd
    80004e92:	1b8080e7          	jalr	440(ra) # 80002046 <argint>
    80004e96:	0a054b63          	bltz	a0,80004f4c <sys_open+0xe6>
    80004e9a:	f14a                	sd	s2,160(sp)

  begin_op();
    80004e9c:	fffff097          	auipc	ra,0xfffff
    80004ea0:	97c080e7          	jalr	-1668(ra) # 80003818 <begin_op>

  if(omode & O_CREATE){
    80004ea4:	f4c42783          	lw	a5,-180(s0)
    80004ea8:	2007f793          	andi	a5,a5,512
    80004eac:	cfc5                	beqz	a5,80004f64 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004eae:	4681                	li	a3,0
    80004eb0:	4601                	li	a2,0
    80004eb2:	4589                	li	a1,2
    80004eb4:	f5040513          	addi	a0,s0,-176
    80004eb8:	00000097          	auipc	ra,0x0
    80004ebc:	958080e7          	jalr	-1704(ra) # 80004810 <create>
    80004ec0:	892a                	mv	s2,a0
    if(ip == 0){
    80004ec2:	c959                	beqz	a0,80004f58 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ec4:	04c91703          	lh	a4,76(s2)
    80004ec8:	478d                	li	a5,3
    80004eca:	00f71763          	bne	a4,a5,80004ed8 <sys_open+0x72>
    80004ece:	04e95703          	lhu	a4,78(s2)
    80004ed2:	47a5                	li	a5,9
    80004ed4:	0ce7ef63          	bltu	a5,a4,80004fb2 <sys_open+0x14c>
    80004ed8:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004eda:	fffff097          	auipc	ra,0xfffff
    80004ede:	d4c080e7          	jalr	-692(ra) # 80003c26 <filealloc>
    80004ee2:	89aa                	mv	s3,a0
    80004ee4:	c965                	beqz	a0,80004fd4 <sys_open+0x16e>
    80004ee6:	00000097          	auipc	ra,0x0
    80004eea:	8e8080e7          	jalr	-1816(ra) # 800047ce <fdalloc>
    80004eee:	84aa                	mv	s1,a0
    80004ef0:	0c054d63          	bltz	a0,80004fca <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ef4:	04c91703          	lh	a4,76(s2)
    80004ef8:	478d                	li	a5,3
    80004efa:	0ef70a63          	beq	a4,a5,80004fee <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004efe:	4789                	li	a5,2
    80004f00:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004f04:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004f08:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004f0c:	f4c42783          	lw	a5,-180(s0)
    80004f10:	0017c713          	xori	a4,a5,1
    80004f14:	8b05                	andi	a4,a4,1
    80004f16:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f1a:	0037f713          	andi	a4,a5,3
    80004f1e:	00e03733          	snez	a4,a4
    80004f22:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004f26:	4007f793          	andi	a5,a5,1024
    80004f2a:	c791                	beqz	a5,80004f36 <sys_open+0xd0>
    80004f2c:	04c91703          	lh	a4,76(s2)
    80004f30:	4789                	li	a5,2
    80004f32:	0cf70563          	beq	a4,a5,80004ffc <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004f36:	854a                	mv	a0,s2
    80004f38:	ffffe097          	auipc	ra,0xffffe
    80004f3c:	fd4080e7          	jalr	-44(ra) # 80002f0c <iunlock>
  end_op();
    80004f40:	fffff097          	auipc	ra,0xfffff
    80004f44:	952080e7          	jalr	-1710(ra) # 80003892 <end_op>
    80004f48:	790a                	ld	s2,160(sp)
    80004f4a:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004f4c:	8526                	mv	a0,s1
    80004f4e:	70ea                	ld	ra,184(sp)
    80004f50:	744a                	ld	s0,176(sp)
    80004f52:	74aa                	ld	s1,168(sp)
    80004f54:	6129                	addi	sp,sp,192
    80004f56:	8082                	ret
      end_op();
    80004f58:	fffff097          	auipc	ra,0xfffff
    80004f5c:	93a080e7          	jalr	-1734(ra) # 80003892 <end_op>
      return -1;
    80004f60:	790a                	ld	s2,160(sp)
    80004f62:	b7ed                	j	80004f4c <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004f64:	f5040513          	addi	a0,s0,-176
    80004f68:	ffffe097          	auipc	ra,0xffffe
    80004f6c:	6b0080e7          	jalr	1712(ra) # 80003618 <namei>
    80004f70:	892a                	mv	s2,a0
    80004f72:	c90d                	beqz	a0,80004fa4 <sys_open+0x13e>
    ilock(ip);
    80004f74:	ffffe097          	auipc	ra,0xffffe
    80004f78:	ed2080e7          	jalr	-302(ra) # 80002e46 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004f7c:	04c91703          	lh	a4,76(s2)
    80004f80:	4785                	li	a5,1
    80004f82:	f4f711e3          	bne	a4,a5,80004ec4 <sys_open+0x5e>
    80004f86:	f4c42783          	lw	a5,-180(s0)
    80004f8a:	d7b9                	beqz	a5,80004ed8 <sys_open+0x72>
      iunlockput(ip);
    80004f8c:	854a                	mv	a0,s2
    80004f8e:	ffffe097          	auipc	ra,0xffffe
    80004f92:	11e080e7          	jalr	286(ra) # 800030ac <iunlockput>
      end_op();
    80004f96:	fffff097          	auipc	ra,0xfffff
    80004f9a:	8fc080e7          	jalr	-1796(ra) # 80003892 <end_op>
      return -1;
    80004f9e:	54fd                	li	s1,-1
    80004fa0:	790a                	ld	s2,160(sp)
    80004fa2:	b76d                	j	80004f4c <sys_open+0xe6>
      end_op();
    80004fa4:	fffff097          	auipc	ra,0xfffff
    80004fa8:	8ee080e7          	jalr	-1810(ra) # 80003892 <end_op>
      return -1;
    80004fac:	54fd                	li	s1,-1
    80004fae:	790a                	ld	s2,160(sp)
    80004fb0:	bf71                	j	80004f4c <sys_open+0xe6>
    iunlockput(ip);
    80004fb2:	854a                	mv	a0,s2
    80004fb4:	ffffe097          	auipc	ra,0xffffe
    80004fb8:	0f8080e7          	jalr	248(ra) # 800030ac <iunlockput>
    end_op();
    80004fbc:	fffff097          	auipc	ra,0xfffff
    80004fc0:	8d6080e7          	jalr	-1834(ra) # 80003892 <end_op>
    return -1;
    80004fc4:	54fd                	li	s1,-1
    80004fc6:	790a                	ld	s2,160(sp)
    80004fc8:	b751                	j	80004f4c <sys_open+0xe6>
      fileclose(f);
    80004fca:	854e                	mv	a0,s3
    80004fcc:	fffff097          	auipc	ra,0xfffff
    80004fd0:	d16080e7          	jalr	-746(ra) # 80003ce2 <fileclose>
    iunlockput(ip);
    80004fd4:	854a                	mv	a0,s2
    80004fd6:	ffffe097          	auipc	ra,0xffffe
    80004fda:	0d6080e7          	jalr	214(ra) # 800030ac <iunlockput>
    end_op();
    80004fde:	fffff097          	auipc	ra,0xfffff
    80004fe2:	8b4080e7          	jalr	-1868(ra) # 80003892 <end_op>
    return -1;
    80004fe6:	54fd                	li	s1,-1
    80004fe8:	790a                	ld	s2,160(sp)
    80004fea:	69ea                	ld	s3,152(sp)
    80004fec:	b785                	j	80004f4c <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004fee:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004ff2:	04e91783          	lh	a5,78(s2)
    80004ff6:	02f99223          	sh	a5,36(s3)
    80004ffa:	b739                	j	80004f08 <sys_open+0xa2>
    itrunc(ip);
    80004ffc:	854a                	mv	a0,s2
    80004ffe:	ffffe097          	auipc	ra,0xffffe
    80005002:	f5a080e7          	jalr	-166(ra) # 80002f58 <itrunc>
    80005006:	bf05                	j	80004f36 <sys_open+0xd0>

0000000080005008 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005008:	7175                	addi	sp,sp,-144
    8000500a:	e506                	sd	ra,136(sp)
    8000500c:	e122                	sd	s0,128(sp)
    8000500e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005010:	fffff097          	auipc	ra,0xfffff
    80005014:	808080e7          	jalr	-2040(ra) # 80003818 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005018:	08000613          	li	a2,128
    8000501c:	f7040593          	addi	a1,s0,-144
    80005020:	4501                	li	a0,0
    80005022:	ffffd097          	auipc	ra,0xffffd
    80005026:	068080e7          	jalr	104(ra) # 8000208a <argstr>
    8000502a:	02054963          	bltz	a0,8000505c <sys_mkdir+0x54>
    8000502e:	4681                	li	a3,0
    80005030:	4601                	li	a2,0
    80005032:	4585                	li	a1,1
    80005034:	f7040513          	addi	a0,s0,-144
    80005038:	fffff097          	auipc	ra,0xfffff
    8000503c:	7d8080e7          	jalr	2008(ra) # 80004810 <create>
    80005040:	cd11                	beqz	a0,8000505c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005042:	ffffe097          	auipc	ra,0xffffe
    80005046:	06a080e7          	jalr	106(ra) # 800030ac <iunlockput>
  end_op();
    8000504a:	fffff097          	auipc	ra,0xfffff
    8000504e:	848080e7          	jalr	-1976(ra) # 80003892 <end_op>
  return 0;
    80005052:	4501                	li	a0,0
}
    80005054:	60aa                	ld	ra,136(sp)
    80005056:	640a                	ld	s0,128(sp)
    80005058:	6149                	addi	sp,sp,144
    8000505a:	8082                	ret
    end_op();
    8000505c:	fffff097          	auipc	ra,0xfffff
    80005060:	836080e7          	jalr	-1994(ra) # 80003892 <end_op>
    return -1;
    80005064:	557d                	li	a0,-1
    80005066:	b7fd                	j	80005054 <sys_mkdir+0x4c>

0000000080005068 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005068:	7135                	addi	sp,sp,-160
    8000506a:	ed06                	sd	ra,152(sp)
    8000506c:	e922                	sd	s0,144(sp)
    8000506e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005070:	ffffe097          	auipc	ra,0xffffe
    80005074:	7a8080e7          	jalr	1960(ra) # 80003818 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005078:	08000613          	li	a2,128
    8000507c:	f7040593          	addi	a1,s0,-144
    80005080:	4501                	li	a0,0
    80005082:	ffffd097          	auipc	ra,0xffffd
    80005086:	008080e7          	jalr	8(ra) # 8000208a <argstr>
    8000508a:	04054a63          	bltz	a0,800050de <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    8000508e:	f6c40593          	addi	a1,s0,-148
    80005092:	4505                	li	a0,1
    80005094:	ffffd097          	auipc	ra,0xffffd
    80005098:	fb2080e7          	jalr	-78(ra) # 80002046 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000509c:	04054163          	bltz	a0,800050de <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    800050a0:	f6840593          	addi	a1,s0,-152
    800050a4:	4509                	li	a0,2
    800050a6:	ffffd097          	auipc	ra,0xffffd
    800050aa:	fa0080e7          	jalr	-96(ra) # 80002046 <argint>
     argint(1, &major) < 0 ||
    800050ae:	02054863          	bltz	a0,800050de <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800050b2:	f6841683          	lh	a3,-152(s0)
    800050b6:	f6c41603          	lh	a2,-148(s0)
    800050ba:	458d                	li	a1,3
    800050bc:	f7040513          	addi	a0,s0,-144
    800050c0:	fffff097          	auipc	ra,0xfffff
    800050c4:	750080e7          	jalr	1872(ra) # 80004810 <create>
     argint(2, &minor) < 0 ||
    800050c8:	c919                	beqz	a0,800050de <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050ca:	ffffe097          	auipc	ra,0xffffe
    800050ce:	fe2080e7          	jalr	-30(ra) # 800030ac <iunlockput>
  end_op();
    800050d2:	ffffe097          	auipc	ra,0xffffe
    800050d6:	7c0080e7          	jalr	1984(ra) # 80003892 <end_op>
  return 0;
    800050da:	4501                	li	a0,0
    800050dc:	a031                	j	800050e8 <sys_mknod+0x80>
    end_op();
    800050de:	ffffe097          	auipc	ra,0xffffe
    800050e2:	7b4080e7          	jalr	1972(ra) # 80003892 <end_op>
    return -1;
    800050e6:	557d                	li	a0,-1
}
    800050e8:	60ea                	ld	ra,152(sp)
    800050ea:	644a                	ld	s0,144(sp)
    800050ec:	610d                	addi	sp,sp,160
    800050ee:	8082                	ret

00000000800050f0 <sys_chdir>:

uint64
sys_chdir(void)
{
    800050f0:	7135                	addi	sp,sp,-160
    800050f2:	ed06                	sd	ra,152(sp)
    800050f4:	e922                	sd	s0,144(sp)
    800050f6:	e14a                	sd	s2,128(sp)
    800050f8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800050fa:	ffffc097          	auipc	ra,0xffffc
    800050fe:	e8c080e7          	jalr	-372(ra) # 80000f86 <myproc>
    80005102:	892a                	mv	s2,a0
  
  begin_op();
    80005104:	ffffe097          	auipc	ra,0xffffe
    80005108:	714080e7          	jalr	1812(ra) # 80003818 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000510c:	08000613          	li	a2,128
    80005110:	f6040593          	addi	a1,s0,-160
    80005114:	4501                	li	a0,0
    80005116:	ffffd097          	auipc	ra,0xffffd
    8000511a:	f74080e7          	jalr	-140(ra) # 8000208a <argstr>
    8000511e:	04054d63          	bltz	a0,80005178 <sys_chdir+0x88>
    80005122:	e526                	sd	s1,136(sp)
    80005124:	f6040513          	addi	a0,s0,-160
    80005128:	ffffe097          	auipc	ra,0xffffe
    8000512c:	4f0080e7          	jalr	1264(ra) # 80003618 <namei>
    80005130:	84aa                	mv	s1,a0
    80005132:	c131                	beqz	a0,80005176 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005134:	ffffe097          	auipc	ra,0xffffe
    80005138:	d12080e7          	jalr	-750(ra) # 80002e46 <ilock>
  if(ip->type != T_DIR){
    8000513c:	04c49703          	lh	a4,76(s1)
    80005140:	4785                	li	a5,1
    80005142:	04f71163          	bne	a4,a5,80005184 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005146:	8526                	mv	a0,s1
    80005148:	ffffe097          	auipc	ra,0xffffe
    8000514c:	dc4080e7          	jalr	-572(ra) # 80002f0c <iunlock>
  iput(p->cwd);
    80005150:	15893503          	ld	a0,344(s2)
    80005154:	ffffe097          	auipc	ra,0xffffe
    80005158:	eb0080e7          	jalr	-336(ra) # 80003004 <iput>
  end_op();
    8000515c:	ffffe097          	auipc	ra,0xffffe
    80005160:	736080e7          	jalr	1846(ra) # 80003892 <end_op>
  p->cwd = ip;
    80005164:	14993c23          	sd	s1,344(s2)
  return 0;
    80005168:	4501                	li	a0,0
    8000516a:	64aa                	ld	s1,136(sp)
}
    8000516c:	60ea                	ld	ra,152(sp)
    8000516e:	644a                	ld	s0,144(sp)
    80005170:	690a                	ld	s2,128(sp)
    80005172:	610d                	addi	sp,sp,160
    80005174:	8082                	ret
    80005176:	64aa                	ld	s1,136(sp)
    end_op();
    80005178:	ffffe097          	auipc	ra,0xffffe
    8000517c:	71a080e7          	jalr	1818(ra) # 80003892 <end_op>
    return -1;
    80005180:	557d                	li	a0,-1
    80005182:	b7ed                	j	8000516c <sys_chdir+0x7c>
    iunlockput(ip);
    80005184:	8526                	mv	a0,s1
    80005186:	ffffe097          	auipc	ra,0xffffe
    8000518a:	f26080e7          	jalr	-218(ra) # 800030ac <iunlockput>
    end_op();
    8000518e:	ffffe097          	auipc	ra,0xffffe
    80005192:	704080e7          	jalr	1796(ra) # 80003892 <end_op>
    return -1;
    80005196:	557d                	li	a0,-1
    80005198:	64aa                	ld	s1,136(sp)
    8000519a:	bfc9                	j	8000516c <sys_chdir+0x7c>

000000008000519c <sys_exec>:

uint64
sys_exec(void)
{
    8000519c:	7121                	addi	sp,sp,-448
    8000519e:	ff06                	sd	ra,440(sp)
    800051a0:	fb22                	sd	s0,432(sp)
    800051a2:	f34a                	sd	s2,416(sp)
    800051a4:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800051a6:	08000613          	li	a2,128
    800051aa:	f5040593          	addi	a1,s0,-176
    800051ae:	4501                	li	a0,0
    800051b0:	ffffd097          	auipc	ra,0xffffd
    800051b4:	eda080e7          	jalr	-294(ra) # 8000208a <argstr>
    return -1;
    800051b8:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800051ba:	0e054a63          	bltz	a0,800052ae <sys_exec+0x112>
    800051be:	e4840593          	addi	a1,s0,-440
    800051c2:	4505                	li	a0,1
    800051c4:	ffffd097          	auipc	ra,0xffffd
    800051c8:	ea4080e7          	jalr	-348(ra) # 80002068 <argaddr>
    800051cc:	0e054163          	bltz	a0,800052ae <sys_exec+0x112>
    800051d0:	f726                	sd	s1,424(sp)
    800051d2:	ef4e                	sd	s3,408(sp)
    800051d4:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800051d6:	10000613          	li	a2,256
    800051da:	4581                	li	a1,0
    800051dc:	e5040513          	addi	a0,s0,-432
    800051e0:	ffffb097          	auipc	ra,0xffffb
    800051e4:	094080e7          	jalr	148(ra) # 80000274 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800051e8:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800051ec:	89a6                	mv	s3,s1
    800051ee:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800051f0:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800051f4:	00391513          	slli	a0,s2,0x3
    800051f8:	e4040593          	addi	a1,s0,-448
    800051fc:	e4843783          	ld	a5,-440(s0)
    80005200:	953e                	add	a0,a0,a5
    80005202:	ffffd097          	auipc	ra,0xffffd
    80005206:	daa080e7          	jalr	-598(ra) # 80001fac <fetchaddr>
    8000520a:	02054a63          	bltz	a0,8000523e <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    8000520e:	e4043783          	ld	a5,-448(s0)
    80005212:	c7b1                	beqz	a5,8000525e <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005214:	ffffb097          	auipc	ra,0xffffb
    80005218:	f58080e7          	jalr	-168(ra) # 8000016c <kalloc>
    8000521c:	85aa                	mv	a1,a0
    8000521e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005222:	cd11                	beqz	a0,8000523e <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005224:	6605                	lui	a2,0x1
    80005226:	e4043503          	ld	a0,-448(s0)
    8000522a:	ffffd097          	auipc	ra,0xffffd
    8000522e:	dd4080e7          	jalr	-556(ra) # 80001ffe <fetchstr>
    80005232:	00054663          	bltz	a0,8000523e <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80005236:	0905                	addi	s2,s2,1
    80005238:	09a1                	addi	s3,s3,8
    8000523a:	fb491de3          	bne	s2,s4,800051f4 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000523e:	f5040913          	addi	s2,s0,-176
    80005242:	6088                	ld	a0,0(s1)
    80005244:	c12d                	beqz	a0,800052a6 <sys_exec+0x10a>
    kfree(argv[i]);
    80005246:	ffffb097          	auipc	ra,0xffffb
    8000524a:	dd6080e7          	jalr	-554(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000524e:	04a1                	addi	s1,s1,8
    80005250:	ff2499e3          	bne	s1,s2,80005242 <sys_exec+0xa6>
  return -1;
    80005254:	597d                	li	s2,-1
    80005256:	74ba                	ld	s1,424(sp)
    80005258:	69fa                	ld	s3,408(sp)
    8000525a:	6a5a                	ld	s4,400(sp)
    8000525c:	a889                	j	800052ae <sys_exec+0x112>
      argv[i] = 0;
    8000525e:	0009079b          	sext.w	a5,s2
    80005262:	078e                	slli	a5,a5,0x3
    80005264:	fd078793          	addi	a5,a5,-48
    80005268:	97a2                	add	a5,a5,s0
    8000526a:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000526e:	e5040593          	addi	a1,s0,-432
    80005272:	f5040513          	addi	a0,s0,-176
    80005276:	fffff097          	auipc	ra,0xfffff
    8000527a:	126080e7          	jalr	294(ra) # 8000439c <exec>
    8000527e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005280:	f5040993          	addi	s3,s0,-176
    80005284:	6088                	ld	a0,0(s1)
    80005286:	cd01                	beqz	a0,8000529e <sys_exec+0x102>
    kfree(argv[i]);
    80005288:	ffffb097          	auipc	ra,0xffffb
    8000528c:	d94080e7          	jalr	-620(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005290:	04a1                	addi	s1,s1,8
    80005292:	ff3499e3          	bne	s1,s3,80005284 <sys_exec+0xe8>
    80005296:	74ba                	ld	s1,424(sp)
    80005298:	69fa                	ld	s3,408(sp)
    8000529a:	6a5a                	ld	s4,400(sp)
    8000529c:	a809                	j	800052ae <sys_exec+0x112>
  return ret;
    8000529e:	74ba                	ld	s1,424(sp)
    800052a0:	69fa                	ld	s3,408(sp)
    800052a2:	6a5a                	ld	s4,400(sp)
    800052a4:	a029                	j	800052ae <sys_exec+0x112>
  return -1;
    800052a6:	597d                	li	s2,-1
    800052a8:	74ba                	ld	s1,424(sp)
    800052aa:	69fa                	ld	s3,408(sp)
    800052ac:	6a5a                	ld	s4,400(sp)
}
    800052ae:	854a                	mv	a0,s2
    800052b0:	70fa                	ld	ra,440(sp)
    800052b2:	745a                	ld	s0,432(sp)
    800052b4:	791a                	ld	s2,416(sp)
    800052b6:	6139                	addi	sp,sp,448
    800052b8:	8082                	ret

00000000800052ba <sys_pipe>:

uint64
sys_pipe(void)
{
    800052ba:	7139                	addi	sp,sp,-64
    800052bc:	fc06                	sd	ra,56(sp)
    800052be:	f822                	sd	s0,48(sp)
    800052c0:	f426                	sd	s1,40(sp)
    800052c2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800052c4:	ffffc097          	auipc	ra,0xffffc
    800052c8:	cc2080e7          	jalr	-830(ra) # 80000f86 <myproc>
    800052cc:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800052ce:	fd840593          	addi	a1,s0,-40
    800052d2:	4501                	li	a0,0
    800052d4:	ffffd097          	auipc	ra,0xffffd
    800052d8:	d94080e7          	jalr	-620(ra) # 80002068 <argaddr>
    return -1;
    800052dc:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800052de:	0e054063          	bltz	a0,800053be <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800052e2:	fc840593          	addi	a1,s0,-56
    800052e6:	fd040513          	addi	a0,s0,-48
    800052ea:	fffff097          	auipc	ra,0xfffff
    800052ee:	d66080e7          	jalr	-666(ra) # 80004050 <pipealloc>
    return -1;
    800052f2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800052f4:	0c054563          	bltz	a0,800053be <sys_pipe+0x104>
  fd0 = -1;
    800052f8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800052fc:	fd043503          	ld	a0,-48(s0)
    80005300:	fffff097          	auipc	ra,0xfffff
    80005304:	4ce080e7          	jalr	1230(ra) # 800047ce <fdalloc>
    80005308:	fca42223          	sw	a0,-60(s0)
    8000530c:	08054c63          	bltz	a0,800053a4 <sys_pipe+0xea>
    80005310:	fc843503          	ld	a0,-56(s0)
    80005314:	fffff097          	auipc	ra,0xfffff
    80005318:	4ba080e7          	jalr	1210(ra) # 800047ce <fdalloc>
    8000531c:	fca42023          	sw	a0,-64(s0)
    80005320:	06054963          	bltz	a0,80005392 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005324:	4691                	li	a3,4
    80005326:	fc440613          	addi	a2,s0,-60
    8000532a:	fd843583          	ld	a1,-40(s0)
    8000532e:	6ca8                	ld	a0,88(s1)
    80005330:	ffffc097          	auipc	ra,0xffffc
    80005334:	8f2080e7          	jalr	-1806(ra) # 80000c22 <copyout>
    80005338:	02054063          	bltz	a0,80005358 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000533c:	4691                	li	a3,4
    8000533e:	fc040613          	addi	a2,s0,-64
    80005342:	fd843583          	ld	a1,-40(s0)
    80005346:	0591                	addi	a1,a1,4
    80005348:	6ca8                	ld	a0,88(s1)
    8000534a:	ffffc097          	auipc	ra,0xffffc
    8000534e:	8d8080e7          	jalr	-1832(ra) # 80000c22 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005352:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005354:	06055563          	bgez	a0,800053be <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005358:	fc442783          	lw	a5,-60(s0)
    8000535c:	07e9                	addi	a5,a5,26
    8000535e:	078e                	slli	a5,a5,0x3
    80005360:	97a6                	add	a5,a5,s1
    80005362:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005366:	fc042783          	lw	a5,-64(s0)
    8000536a:	07e9                	addi	a5,a5,26
    8000536c:	078e                	slli	a5,a5,0x3
    8000536e:	00f48533          	add	a0,s1,a5
    80005372:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005376:	fd043503          	ld	a0,-48(s0)
    8000537a:	fffff097          	auipc	ra,0xfffff
    8000537e:	968080e7          	jalr	-1688(ra) # 80003ce2 <fileclose>
    fileclose(wf);
    80005382:	fc843503          	ld	a0,-56(s0)
    80005386:	fffff097          	auipc	ra,0xfffff
    8000538a:	95c080e7          	jalr	-1700(ra) # 80003ce2 <fileclose>
    return -1;
    8000538e:	57fd                	li	a5,-1
    80005390:	a03d                	j	800053be <sys_pipe+0x104>
    if(fd0 >= 0)
    80005392:	fc442783          	lw	a5,-60(s0)
    80005396:	0007c763          	bltz	a5,800053a4 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000539a:	07e9                	addi	a5,a5,26
    8000539c:	078e                	slli	a5,a5,0x3
    8000539e:	97a6                	add	a5,a5,s1
    800053a0:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    800053a4:	fd043503          	ld	a0,-48(s0)
    800053a8:	fffff097          	auipc	ra,0xfffff
    800053ac:	93a080e7          	jalr	-1734(ra) # 80003ce2 <fileclose>
    fileclose(wf);
    800053b0:	fc843503          	ld	a0,-56(s0)
    800053b4:	fffff097          	auipc	ra,0xfffff
    800053b8:	92e080e7          	jalr	-1746(ra) # 80003ce2 <fileclose>
    return -1;
    800053bc:	57fd                	li	a5,-1
}
    800053be:	853e                	mv	a0,a5
    800053c0:	70e2                	ld	ra,56(sp)
    800053c2:	7442                	ld	s0,48(sp)
    800053c4:	74a2                	ld	s1,40(sp)
    800053c6:	6121                	addi	sp,sp,64
    800053c8:	8082                	ret
    800053ca:	0000                	unimp
    800053cc:	0000                	unimp
	...

00000000800053d0 <kernelvec>:
    800053d0:	7111                	addi	sp,sp,-256
    800053d2:	e006                	sd	ra,0(sp)
    800053d4:	e40a                	sd	sp,8(sp)
    800053d6:	e80e                	sd	gp,16(sp)
    800053d8:	ec12                	sd	tp,24(sp)
    800053da:	f016                	sd	t0,32(sp)
    800053dc:	f41a                	sd	t1,40(sp)
    800053de:	f81e                	sd	t2,48(sp)
    800053e0:	fc22                	sd	s0,56(sp)
    800053e2:	e0a6                	sd	s1,64(sp)
    800053e4:	e4aa                	sd	a0,72(sp)
    800053e6:	e8ae                	sd	a1,80(sp)
    800053e8:	ecb2                	sd	a2,88(sp)
    800053ea:	f0b6                	sd	a3,96(sp)
    800053ec:	f4ba                	sd	a4,104(sp)
    800053ee:	f8be                	sd	a5,112(sp)
    800053f0:	fcc2                	sd	a6,120(sp)
    800053f2:	e146                	sd	a7,128(sp)
    800053f4:	e54a                	sd	s2,136(sp)
    800053f6:	e94e                	sd	s3,144(sp)
    800053f8:	ed52                	sd	s4,152(sp)
    800053fa:	f156                	sd	s5,160(sp)
    800053fc:	f55a                	sd	s6,168(sp)
    800053fe:	f95e                	sd	s7,176(sp)
    80005400:	fd62                	sd	s8,184(sp)
    80005402:	e1e6                	sd	s9,192(sp)
    80005404:	e5ea                	sd	s10,200(sp)
    80005406:	e9ee                	sd	s11,208(sp)
    80005408:	edf2                	sd	t3,216(sp)
    8000540a:	f1f6                	sd	t4,224(sp)
    8000540c:	f5fa                	sd	t5,232(sp)
    8000540e:	f9fe                	sd	t6,240(sp)
    80005410:	a69fc0ef          	jal	80001e78 <kerneltrap>
    80005414:	6082                	ld	ra,0(sp)
    80005416:	6122                	ld	sp,8(sp)
    80005418:	61c2                	ld	gp,16(sp)
    8000541a:	7282                	ld	t0,32(sp)
    8000541c:	7322                	ld	t1,40(sp)
    8000541e:	73c2                	ld	t2,48(sp)
    80005420:	7462                	ld	s0,56(sp)
    80005422:	6486                	ld	s1,64(sp)
    80005424:	6526                	ld	a0,72(sp)
    80005426:	65c6                	ld	a1,80(sp)
    80005428:	6666                	ld	a2,88(sp)
    8000542a:	7686                	ld	a3,96(sp)
    8000542c:	7726                	ld	a4,104(sp)
    8000542e:	77c6                	ld	a5,112(sp)
    80005430:	7866                	ld	a6,120(sp)
    80005432:	688a                	ld	a7,128(sp)
    80005434:	692a                	ld	s2,136(sp)
    80005436:	69ca                	ld	s3,144(sp)
    80005438:	6a6a                	ld	s4,152(sp)
    8000543a:	7a8a                	ld	s5,160(sp)
    8000543c:	7b2a                	ld	s6,168(sp)
    8000543e:	7bca                	ld	s7,176(sp)
    80005440:	7c6a                	ld	s8,184(sp)
    80005442:	6c8e                	ld	s9,192(sp)
    80005444:	6d2e                	ld	s10,200(sp)
    80005446:	6dce                	ld	s11,208(sp)
    80005448:	6e6e                	ld	t3,216(sp)
    8000544a:	7e8e                	ld	t4,224(sp)
    8000544c:	7f2e                	ld	t5,232(sp)
    8000544e:	7fce                	ld	t6,240(sp)
    80005450:	6111                	addi	sp,sp,256
    80005452:	10200073          	sret
    80005456:	00000013          	nop
    8000545a:	00000013          	nop
    8000545e:	0001                	nop

0000000080005460 <timervec>:
    80005460:	34051573          	csrrw	a0,mscratch,a0
    80005464:	e10c                	sd	a1,0(a0)
    80005466:	e510                	sd	a2,8(a0)
    80005468:	e914                	sd	a3,16(a0)
    8000546a:	6d0c                	ld	a1,24(a0)
    8000546c:	7110                	ld	a2,32(a0)
    8000546e:	6194                	ld	a3,0(a1)
    80005470:	96b2                	add	a3,a3,a2
    80005472:	e194                	sd	a3,0(a1)
    80005474:	4589                	li	a1,2
    80005476:	14459073          	csrw	sip,a1
    8000547a:	6914                	ld	a3,16(a0)
    8000547c:	6510                	ld	a2,8(a0)
    8000547e:	610c                	ld	a1,0(a0)
    80005480:	34051573          	csrrw	a0,mscratch,a0
    80005484:	30200073          	mret
	...

000000008000548a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000548a:	1141                	addi	sp,sp,-16
    8000548c:	e422                	sd	s0,8(sp)
    8000548e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005490:	0c0007b7          	lui	a5,0xc000
    80005494:	4705                	li	a4,1
    80005496:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005498:	0c0007b7          	lui	a5,0xc000
    8000549c:	c3d8                	sw	a4,4(a5)
}
    8000549e:	6422                	ld	s0,8(sp)
    800054a0:	0141                	addi	sp,sp,16
    800054a2:	8082                	ret

00000000800054a4 <plicinithart>:

void
plicinithart(void)
{
    800054a4:	1141                	addi	sp,sp,-16
    800054a6:	e406                	sd	ra,8(sp)
    800054a8:	e022                	sd	s0,0(sp)
    800054aa:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054ac:	ffffc097          	auipc	ra,0xffffc
    800054b0:	aae080e7          	jalr	-1362(ra) # 80000f5a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800054b4:	0085171b          	slliw	a4,a0,0x8
    800054b8:	0c0027b7          	lui	a5,0xc002
    800054bc:	97ba                	add	a5,a5,a4
    800054be:	40200713          	li	a4,1026
    800054c2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800054c6:	00d5151b          	slliw	a0,a0,0xd
    800054ca:	0c2017b7          	lui	a5,0xc201
    800054ce:	97aa                	add	a5,a5,a0
    800054d0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800054d4:	60a2                	ld	ra,8(sp)
    800054d6:	6402                	ld	s0,0(sp)
    800054d8:	0141                	addi	sp,sp,16
    800054da:	8082                	ret

00000000800054dc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800054dc:	1141                	addi	sp,sp,-16
    800054de:	e406                	sd	ra,8(sp)
    800054e0:	e022                	sd	s0,0(sp)
    800054e2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054e4:	ffffc097          	auipc	ra,0xffffc
    800054e8:	a76080e7          	jalr	-1418(ra) # 80000f5a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800054ec:	00d5151b          	slliw	a0,a0,0xd
    800054f0:	0c2017b7          	lui	a5,0xc201
    800054f4:	97aa                	add	a5,a5,a0
  return irq;
}
    800054f6:	43c8                	lw	a0,4(a5)
    800054f8:	60a2                	ld	ra,8(sp)
    800054fa:	6402                	ld	s0,0(sp)
    800054fc:	0141                	addi	sp,sp,16
    800054fe:	8082                	ret

0000000080005500 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005500:	1101                	addi	sp,sp,-32
    80005502:	ec06                	sd	ra,24(sp)
    80005504:	e822                	sd	s0,16(sp)
    80005506:	e426                	sd	s1,8(sp)
    80005508:	1000                	addi	s0,sp,32
    8000550a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000550c:	ffffc097          	auipc	ra,0xffffc
    80005510:	a4e080e7          	jalr	-1458(ra) # 80000f5a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005514:	00d5151b          	slliw	a0,a0,0xd
    80005518:	0c2017b7          	lui	a5,0xc201
    8000551c:	97aa                	add	a5,a5,a0
    8000551e:	c3c4                	sw	s1,4(a5)
}
    80005520:	60e2                	ld	ra,24(sp)
    80005522:	6442                	ld	s0,16(sp)
    80005524:	64a2                	ld	s1,8(sp)
    80005526:	6105                	addi	sp,sp,32
    80005528:	8082                	ret

000000008000552a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000552a:	1141                	addi	sp,sp,-16
    8000552c:	e406                	sd	ra,8(sp)
    8000552e:	e022                	sd	s0,0(sp)
    80005530:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005532:	479d                	li	a5,7
    80005534:	06a7c863          	blt	a5,a0,800055a4 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005538:	0001c717          	auipc	a4,0x1c
    8000553c:	ac870713          	addi	a4,a4,-1336 # 80021000 <disk>
    80005540:	972a                	add	a4,a4,a0
    80005542:	6789                	lui	a5,0x2
    80005544:	97ba                	add	a5,a5,a4
    80005546:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000554a:	e7ad                	bnez	a5,800055b4 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000554c:	00451793          	slli	a5,a0,0x4
    80005550:	0001e717          	auipc	a4,0x1e
    80005554:	ab070713          	addi	a4,a4,-1360 # 80023000 <disk+0x2000>
    80005558:	6314                	ld	a3,0(a4)
    8000555a:	96be                	add	a3,a3,a5
    8000555c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005560:	6314                	ld	a3,0(a4)
    80005562:	96be                	add	a3,a3,a5
    80005564:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005568:	6314                	ld	a3,0(a4)
    8000556a:	96be                	add	a3,a3,a5
    8000556c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005570:	6318                	ld	a4,0(a4)
    80005572:	97ba                	add	a5,a5,a4
    80005574:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005578:	0001c717          	auipc	a4,0x1c
    8000557c:	a8870713          	addi	a4,a4,-1400 # 80021000 <disk>
    80005580:	972a                	add	a4,a4,a0
    80005582:	6789                	lui	a5,0x2
    80005584:	97ba                	add	a5,a5,a4
    80005586:	4705                	li	a4,1
    80005588:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000558c:	0001e517          	auipc	a0,0x1e
    80005590:	a8c50513          	addi	a0,a0,-1396 # 80023018 <disk+0x2018>
    80005594:	ffffc097          	auipc	ra,0xffffc
    80005598:	244080e7          	jalr	580(ra) # 800017d8 <wakeup>
}
    8000559c:	60a2                	ld	ra,8(sp)
    8000559e:	6402                	ld	s0,0(sp)
    800055a0:	0141                	addi	sp,sp,16
    800055a2:	8082                	ret
    panic("free_desc 1");
    800055a4:	00003517          	auipc	a0,0x3
    800055a8:	06450513          	addi	a0,a0,100 # 80008608 <etext+0x608>
    800055ac:	00001097          	auipc	ra,0x1
    800055b0:	d8a080e7          	jalr	-630(ra) # 80006336 <panic>
    panic("free_desc 2");
    800055b4:	00003517          	auipc	a0,0x3
    800055b8:	06450513          	addi	a0,a0,100 # 80008618 <etext+0x618>
    800055bc:	00001097          	auipc	ra,0x1
    800055c0:	d7a080e7          	jalr	-646(ra) # 80006336 <panic>

00000000800055c4 <virtio_disk_init>:
{
    800055c4:	1141                	addi	sp,sp,-16
    800055c6:	e406                	sd	ra,8(sp)
    800055c8:	e022                	sd	s0,0(sp)
    800055ca:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    800055cc:	00003597          	auipc	a1,0x3
    800055d0:	05c58593          	addi	a1,a1,92 # 80008628 <etext+0x628>
    800055d4:	0001e517          	auipc	a0,0x1e
    800055d8:	b5450513          	addi	a0,a0,-1196 # 80023128 <disk+0x2128>
    800055dc:	00001097          	auipc	ra,0x1
    800055e0:	432080e7          	jalr	1074(ra) # 80006a0e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055e4:	100017b7          	lui	a5,0x10001
    800055e8:	4398                	lw	a4,0(a5)
    800055ea:	2701                	sext.w	a4,a4
    800055ec:	747277b7          	lui	a5,0x74727
    800055f0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800055f4:	0ef71f63          	bne	a4,a5,800056f2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800055f8:	100017b7          	lui	a5,0x10001
    800055fc:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800055fe:	439c                	lw	a5,0(a5)
    80005600:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005602:	4705                	li	a4,1
    80005604:	0ee79763          	bne	a5,a4,800056f2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005608:	100017b7          	lui	a5,0x10001
    8000560c:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000560e:	439c                	lw	a5,0(a5)
    80005610:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005612:	4709                	li	a4,2
    80005614:	0ce79f63          	bne	a5,a4,800056f2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005618:	100017b7          	lui	a5,0x10001
    8000561c:	47d8                	lw	a4,12(a5)
    8000561e:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005620:	554d47b7          	lui	a5,0x554d4
    80005624:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005628:	0cf71563          	bne	a4,a5,800056f2 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000562c:	100017b7          	lui	a5,0x10001
    80005630:	4705                	li	a4,1
    80005632:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005634:	470d                	li	a4,3
    80005636:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005638:	10001737          	lui	a4,0x10001
    8000563c:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000563e:	c7ffe737          	lui	a4,0xc7ffe
    80005642:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd0517>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005646:	8ef9                	and	a3,a3,a4
    80005648:	10001737          	lui	a4,0x10001
    8000564c:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000564e:	472d                	li	a4,11
    80005650:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005652:	473d                	li	a4,15
    80005654:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005656:	100017b7          	lui	a5,0x10001
    8000565a:	6705                	lui	a4,0x1
    8000565c:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000565e:	100017b7          	lui	a5,0x10001
    80005662:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005666:	100017b7          	lui	a5,0x10001
    8000566a:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000566e:	439c                	lw	a5,0(a5)
    80005670:	2781                	sext.w	a5,a5
  if(max == 0)
    80005672:	cbc1                	beqz	a5,80005702 <virtio_disk_init+0x13e>
  if(max < NUM)
    80005674:	471d                	li	a4,7
    80005676:	08f77e63          	bgeu	a4,a5,80005712 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000567a:	100017b7          	lui	a5,0x10001
    8000567e:	4721                	li	a4,8
    80005680:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005682:	6609                	lui	a2,0x2
    80005684:	4581                	li	a1,0
    80005686:	0001c517          	auipc	a0,0x1c
    8000568a:	97a50513          	addi	a0,a0,-1670 # 80021000 <disk>
    8000568e:	ffffb097          	auipc	ra,0xffffb
    80005692:	be6080e7          	jalr	-1050(ra) # 80000274 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005696:	0001c697          	auipc	a3,0x1c
    8000569a:	96a68693          	addi	a3,a3,-1686 # 80021000 <disk>
    8000569e:	00c6d713          	srli	a4,a3,0xc
    800056a2:	2701                	sext.w	a4,a4
    800056a4:	100017b7          	lui	a5,0x10001
    800056a8:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    800056aa:	0001e797          	auipc	a5,0x1e
    800056ae:	95678793          	addi	a5,a5,-1706 # 80023000 <disk+0x2000>
    800056b2:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800056b4:	0001c717          	auipc	a4,0x1c
    800056b8:	9cc70713          	addi	a4,a4,-1588 # 80021080 <disk+0x80>
    800056bc:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800056be:	0001d717          	auipc	a4,0x1d
    800056c2:	94270713          	addi	a4,a4,-1726 # 80022000 <disk+0x1000>
    800056c6:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800056c8:	4705                	li	a4,1
    800056ca:	00e78c23          	sb	a4,24(a5)
    800056ce:	00e78ca3          	sb	a4,25(a5)
    800056d2:	00e78d23          	sb	a4,26(a5)
    800056d6:	00e78da3          	sb	a4,27(a5)
    800056da:	00e78e23          	sb	a4,28(a5)
    800056de:	00e78ea3          	sb	a4,29(a5)
    800056e2:	00e78f23          	sb	a4,30(a5)
    800056e6:	00e78fa3          	sb	a4,31(a5)
}
    800056ea:	60a2                	ld	ra,8(sp)
    800056ec:	6402                	ld	s0,0(sp)
    800056ee:	0141                	addi	sp,sp,16
    800056f0:	8082                	ret
    panic("could not find virtio disk");
    800056f2:	00003517          	auipc	a0,0x3
    800056f6:	f4650513          	addi	a0,a0,-186 # 80008638 <etext+0x638>
    800056fa:	00001097          	auipc	ra,0x1
    800056fe:	c3c080e7          	jalr	-964(ra) # 80006336 <panic>
    panic("virtio disk has no queue 0");
    80005702:	00003517          	auipc	a0,0x3
    80005706:	f5650513          	addi	a0,a0,-170 # 80008658 <etext+0x658>
    8000570a:	00001097          	auipc	ra,0x1
    8000570e:	c2c080e7          	jalr	-980(ra) # 80006336 <panic>
    panic("virtio disk max queue too short");
    80005712:	00003517          	auipc	a0,0x3
    80005716:	f6650513          	addi	a0,a0,-154 # 80008678 <etext+0x678>
    8000571a:	00001097          	auipc	ra,0x1
    8000571e:	c1c080e7          	jalr	-996(ra) # 80006336 <panic>

0000000080005722 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005722:	7159                	addi	sp,sp,-112
    80005724:	f486                	sd	ra,104(sp)
    80005726:	f0a2                	sd	s0,96(sp)
    80005728:	eca6                	sd	s1,88(sp)
    8000572a:	e8ca                	sd	s2,80(sp)
    8000572c:	e4ce                	sd	s3,72(sp)
    8000572e:	e0d2                	sd	s4,64(sp)
    80005730:	fc56                	sd	s5,56(sp)
    80005732:	f85a                	sd	s6,48(sp)
    80005734:	f45e                	sd	s7,40(sp)
    80005736:	f062                	sd	s8,32(sp)
    80005738:	ec66                	sd	s9,24(sp)
    8000573a:	1880                	addi	s0,sp,112
    8000573c:	8a2a                	mv	s4,a0
    8000573e:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005740:	00c52c03          	lw	s8,12(a0)
    80005744:	001c1c1b          	slliw	s8,s8,0x1
    80005748:	1c02                	slli	s8,s8,0x20
    8000574a:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    8000574e:	0001e517          	auipc	a0,0x1e
    80005752:	9da50513          	addi	a0,a0,-1574 # 80023128 <disk+0x2128>
    80005756:	00001097          	auipc	ra,0x1
    8000575a:	144080e7          	jalr	324(ra) # 8000689a <acquire>
  for(int i = 0; i < 3; i++){
    8000575e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005760:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005762:	0001cb97          	auipc	s7,0x1c
    80005766:	89eb8b93          	addi	s7,s7,-1890 # 80021000 <disk>
    8000576a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000576c:	4a8d                	li	s5,3
    8000576e:	a88d                	j	800057e0 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80005770:	00fb8733          	add	a4,s7,a5
    80005774:	975a                	add	a4,a4,s6
    80005776:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000577a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000577c:	0207c563          	bltz	a5,800057a6 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005780:	2905                	addiw	s2,s2,1
    80005782:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005784:	1b590163          	beq	s2,s5,80005926 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    80005788:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000578a:	0001e717          	auipc	a4,0x1e
    8000578e:	88e70713          	addi	a4,a4,-1906 # 80023018 <disk+0x2018>
    80005792:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005794:	00074683          	lbu	a3,0(a4)
    80005798:	fee1                	bnez	a3,80005770 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    8000579a:	2785                	addiw	a5,a5,1
    8000579c:	0705                	addi	a4,a4,1
    8000579e:	fe979be3          	bne	a5,s1,80005794 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    800057a2:	57fd                	li	a5,-1
    800057a4:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800057a6:	03205163          	blez	s2,800057c8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    800057aa:	f9042503          	lw	a0,-112(s0)
    800057ae:	00000097          	auipc	ra,0x0
    800057b2:	d7c080e7          	jalr	-644(ra) # 8000552a <free_desc>
      for(int j = 0; j < i; j++)
    800057b6:	4785                	li	a5,1
    800057b8:	0127d863          	bge	a5,s2,800057c8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    800057bc:	f9442503          	lw	a0,-108(s0)
    800057c0:	00000097          	auipc	ra,0x0
    800057c4:	d6a080e7          	jalr	-662(ra) # 8000552a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800057c8:	0001e597          	auipc	a1,0x1e
    800057cc:	96058593          	addi	a1,a1,-1696 # 80023128 <disk+0x2128>
    800057d0:	0001e517          	auipc	a0,0x1e
    800057d4:	84850513          	addi	a0,a0,-1976 # 80023018 <disk+0x2018>
    800057d8:	ffffc097          	auipc	ra,0xffffc
    800057dc:	e74080e7          	jalr	-396(ra) # 8000164c <sleep>
  for(int i = 0; i < 3; i++){
    800057e0:	f9040613          	addi	a2,s0,-112
    800057e4:	894e                	mv	s2,s3
    800057e6:	b74d                	j	80005788 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800057e8:	0001e717          	auipc	a4,0x1e
    800057ec:	81873703          	ld	a4,-2024(a4) # 80023000 <disk+0x2000>
    800057f0:	973e                	add	a4,a4,a5
    800057f2:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800057f6:	0001c897          	auipc	a7,0x1c
    800057fa:	80a88893          	addi	a7,a7,-2038 # 80021000 <disk>
    800057fe:	0001e717          	auipc	a4,0x1e
    80005802:	80270713          	addi	a4,a4,-2046 # 80023000 <disk+0x2000>
    80005806:	6314                	ld	a3,0(a4)
    80005808:	96be                	add	a3,a3,a5
    8000580a:	00c6d583          	lhu	a1,12(a3)
    8000580e:	0015e593          	ori	a1,a1,1
    80005812:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005816:	f9842683          	lw	a3,-104(s0)
    8000581a:	630c                	ld	a1,0(a4)
    8000581c:	97ae                	add	a5,a5,a1
    8000581e:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005822:	20050593          	addi	a1,a0,512
    80005826:	0592                	slli	a1,a1,0x4
    80005828:	95c6                	add	a1,a1,a7
    8000582a:	57fd                	li	a5,-1
    8000582c:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005830:	00469793          	slli	a5,a3,0x4
    80005834:	00073803          	ld	a6,0(a4)
    80005838:	983e                	add	a6,a6,a5
    8000583a:	6689                	lui	a3,0x2
    8000583c:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005840:	96b2                	add	a3,a3,a2
    80005842:	96c6                	add	a3,a3,a7
    80005844:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005848:	6314                	ld	a3,0(a4)
    8000584a:	96be                	add	a3,a3,a5
    8000584c:	4605                	li	a2,1
    8000584e:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005850:	6314                	ld	a3,0(a4)
    80005852:	96be                	add	a3,a3,a5
    80005854:	4809                	li	a6,2
    80005856:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    8000585a:	6314                	ld	a3,0(a4)
    8000585c:	97b6                	add	a5,a5,a3
    8000585e:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005862:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005866:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000586a:	6714                	ld	a3,8(a4)
    8000586c:	0026d783          	lhu	a5,2(a3)
    80005870:	8b9d                	andi	a5,a5,7
    80005872:	0786                	slli	a5,a5,0x1
    80005874:	96be                	add	a3,a3,a5
    80005876:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000587a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000587e:	6718                	ld	a4,8(a4)
    80005880:	00275783          	lhu	a5,2(a4)
    80005884:	2785                	addiw	a5,a5,1
    80005886:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000588a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000588e:	100017b7          	lui	a5,0x10001
    80005892:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005896:	004a2783          	lw	a5,4(s4)
    8000589a:	02c79163          	bne	a5,a2,800058bc <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    8000589e:	0001e917          	auipc	s2,0x1e
    800058a2:	88a90913          	addi	s2,s2,-1910 # 80023128 <disk+0x2128>
  while(b->disk == 1) {
    800058a6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800058a8:	85ca                	mv	a1,s2
    800058aa:	8552                	mv	a0,s4
    800058ac:	ffffc097          	auipc	ra,0xffffc
    800058b0:	da0080e7          	jalr	-608(ra) # 8000164c <sleep>
  while(b->disk == 1) {
    800058b4:	004a2783          	lw	a5,4(s4)
    800058b8:	fe9788e3          	beq	a5,s1,800058a8 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    800058bc:	f9042903          	lw	s2,-112(s0)
    800058c0:	20090713          	addi	a4,s2,512
    800058c4:	0712                	slli	a4,a4,0x4
    800058c6:	0001b797          	auipc	a5,0x1b
    800058ca:	73a78793          	addi	a5,a5,1850 # 80021000 <disk>
    800058ce:	97ba                	add	a5,a5,a4
    800058d0:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800058d4:	0001d997          	auipc	s3,0x1d
    800058d8:	72c98993          	addi	s3,s3,1836 # 80023000 <disk+0x2000>
    800058dc:	00491713          	slli	a4,s2,0x4
    800058e0:	0009b783          	ld	a5,0(s3)
    800058e4:	97ba                	add	a5,a5,a4
    800058e6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800058ea:	854a                	mv	a0,s2
    800058ec:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800058f0:	00000097          	auipc	ra,0x0
    800058f4:	c3a080e7          	jalr	-966(ra) # 8000552a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800058f8:	8885                	andi	s1,s1,1
    800058fa:	f0ed                	bnez	s1,800058dc <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800058fc:	0001e517          	auipc	a0,0x1e
    80005900:	82c50513          	addi	a0,a0,-2004 # 80023128 <disk+0x2128>
    80005904:	00001097          	auipc	ra,0x1
    80005908:	05e080e7          	jalr	94(ra) # 80006962 <release>
}
    8000590c:	70a6                	ld	ra,104(sp)
    8000590e:	7406                	ld	s0,96(sp)
    80005910:	64e6                	ld	s1,88(sp)
    80005912:	6946                	ld	s2,80(sp)
    80005914:	69a6                	ld	s3,72(sp)
    80005916:	6a06                	ld	s4,64(sp)
    80005918:	7ae2                	ld	s5,56(sp)
    8000591a:	7b42                	ld	s6,48(sp)
    8000591c:	7ba2                	ld	s7,40(sp)
    8000591e:	7c02                	ld	s8,32(sp)
    80005920:	6ce2                	ld	s9,24(sp)
    80005922:	6165                	addi	sp,sp,112
    80005924:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005926:	f9042503          	lw	a0,-112(s0)
    8000592a:	00451613          	slli	a2,a0,0x4
  if(write)
    8000592e:	0001b597          	auipc	a1,0x1b
    80005932:	6d258593          	addi	a1,a1,1746 # 80021000 <disk>
    80005936:	20050793          	addi	a5,a0,512
    8000593a:	0792                	slli	a5,a5,0x4
    8000593c:	97ae                	add	a5,a5,a1
    8000593e:	01903733          	snez	a4,s9
    80005942:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    80005946:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    8000594a:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000594e:	0001d717          	auipc	a4,0x1d
    80005952:	6b270713          	addi	a4,a4,1714 # 80023000 <disk+0x2000>
    80005956:	6314                	ld	a3,0(a4)
    80005958:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000595a:	6789                	lui	a5,0x2
    8000595c:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005960:	97b2                	add	a5,a5,a2
    80005962:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005964:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005966:	631c                	ld	a5,0(a4)
    80005968:	97b2                	add	a5,a5,a2
    8000596a:	46c1                	li	a3,16
    8000596c:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000596e:	631c                	ld	a5,0(a4)
    80005970:	97b2                	add	a5,a5,a2
    80005972:	4685                	li	a3,1
    80005974:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005978:	f9442783          	lw	a5,-108(s0)
    8000597c:	6314                	ld	a3,0(a4)
    8000597e:	96b2                	add	a3,a3,a2
    80005980:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005984:	0792                	slli	a5,a5,0x4
    80005986:	6314                	ld	a3,0(a4)
    80005988:	96be                	add	a3,a3,a5
    8000598a:	060a0593          	addi	a1,s4,96
    8000598e:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005990:	6318                	ld	a4,0(a4)
    80005992:	973e                	add	a4,a4,a5
    80005994:	40000693          	li	a3,1024
    80005998:	c714                	sw	a3,8(a4)
  if(write)
    8000599a:	e40c97e3          	bnez	s9,800057e8 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000599e:	0001d717          	auipc	a4,0x1d
    800059a2:	66273703          	ld	a4,1634(a4) # 80023000 <disk+0x2000>
    800059a6:	973e                	add	a4,a4,a5
    800059a8:	4689                	li	a3,2
    800059aa:	00d71623          	sh	a3,12(a4)
    800059ae:	b5a1                	j	800057f6 <virtio_disk_rw+0xd4>

00000000800059b0 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800059b0:	1101                	addi	sp,sp,-32
    800059b2:	ec06                	sd	ra,24(sp)
    800059b4:	e822                	sd	s0,16(sp)
    800059b6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800059b8:	0001d517          	auipc	a0,0x1d
    800059bc:	77050513          	addi	a0,a0,1904 # 80023128 <disk+0x2128>
    800059c0:	00001097          	auipc	ra,0x1
    800059c4:	eda080e7          	jalr	-294(ra) # 8000689a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800059c8:	100017b7          	lui	a5,0x10001
    800059cc:	53b8                	lw	a4,96(a5)
    800059ce:	8b0d                	andi	a4,a4,3
    800059d0:	100017b7          	lui	a5,0x10001
    800059d4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800059d6:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800059da:	0001d797          	auipc	a5,0x1d
    800059de:	62678793          	addi	a5,a5,1574 # 80023000 <disk+0x2000>
    800059e2:	6b94                	ld	a3,16(a5)
    800059e4:	0207d703          	lhu	a4,32(a5)
    800059e8:	0026d783          	lhu	a5,2(a3)
    800059ec:	06f70563          	beq	a4,a5,80005a56 <virtio_disk_intr+0xa6>
    800059f0:	e426                	sd	s1,8(sp)
    800059f2:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800059f4:	0001b917          	auipc	s2,0x1b
    800059f8:	60c90913          	addi	s2,s2,1548 # 80021000 <disk>
    800059fc:	0001d497          	auipc	s1,0x1d
    80005a00:	60448493          	addi	s1,s1,1540 # 80023000 <disk+0x2000>
    __sync_synchronize();
    80005a04:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a08:	6898                	ld	a4,16(s1)
    80005a0a:	0204d783          	lhu	a5,32(s1)
    80005a0e:	8b9d                	andi	a5,a5,7
    80005a10:	078e                	slli	a5,a5,0x3
    80005a12:	97ba                	add	a5,a5,a4
    80005a14:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005a16:	20078713          	addi	a4,a5,512
    80005a1a:	0712                	slli	a4,a4,0x4
    80005a1c:	974a                	add	a4,a4,s2
    80005a1e:	03074703          	lbu	a4,48(a4)
    80005a22:	e731                	bnez	a4,80005a6e <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005a24:	20078793          	addi	a5,a5,512
    80005a28:	0792                	slli	a5,a5,0x4
    80005a2a:	97ca                	add	a5,a5,s2
    80005a2c:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005a2e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005a32:	ffffc097          	auipc	ra,0xffffc
    80005a36:	da6080e7          	jalr	-602(ra) # 800017d8 <wakeup>

    disk.used_idx += 1;
    80005a3a:	0204d783          	lhu	a5,32(s1)
    80005a3e:	2785                	addiw	a5,a5,1
    80005a40:	17c2                	slli	a5,a5,0x30
    80005a42:	93c1                	srli	a5,a5,0x30
    80005a44:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005a48:	6898                	ld	a4,16(s1)
    80005a4a:	00275703          	lhu	a4,2(a4)
    80005a4e:	faf71be3          	bne	a4,a5,80005a04 <virtio_disk_intr+0x54>
    80005a52:	64a2                	ld	s1,8(sp)
    80005a54:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005a56:	0001d517          	auipc	a0,0x1d
    80005a5a:	6d250513          	addi	a0,a0,1746 # 80023128 <disk+0x2128>
    80005a5e:	00001097          	auipc	ra,0x1
    80005a62:	f04080e7          	jalr	-252(ra) # 80006962 <release>
}
    80005a66:	60e2                	ld	ra,24(sp)
    80005a68:	6442                	ld	s0,16(sp)
    80005a6a:	6105                	addi	sp,sp,32
    80005a6c:	8082                	ret
      panic("virtio_disk_intr status");
    80005a6e:	00003517          	auipc	a0,0x3
    80005a72:	c2a50513          	addi	a0,a0,-982 # 80008698 <etext+0x698>
    80005a76:	00001097          	auipc	ra,0x1
    80005a7a:	8c0080e7          	jalr	-1856(ra) # 80006336 <panic>

0000000080005a7e <statswrite>:
int statscopyin(char*, int);
int statslock(char*, int);
  
int
statswrite(int user_src, uint64 src, int n)
{
    80005a7e:	1141                	addi	sp,sp,-16
    80005a80:	e422                	sd	s0,8(sp)
    80005a82:	0800                	addi	s0,sp,16
  return -1;
}
    80005a84:	557d                	li	a0,-1
    80005a86:	6422                	ld	s0,8(sp)
    80005a88:	0141                	addi	sp,sp,16
    80005a8a:	8082                	ret

0000000080005a8c <statsread>:

int
statsread(int user_dst, uint64 dst, int n)
{
    80005a8c:	7179                	addi	sp,sp,-48
    80005a8e:	f406                	sd	ra,40(sp)
    80005a90:	f022                	sd	s0,32(sp)
    80005a92:	ec26                	sd	s1,24(sp)
    80005a94:	e84a                	sd	s2,16(sp)
    80005a96:	e44e                	sd	s3,8(sp)
    80005a98:	1800                	addi	s0,sp,48
    80005a9a:	892a                	mv	s2,a0
    80005a9c:	89ae                	mv	s3,a1
    80005a9e:	84b2                	mv	s1,a2
  int m;

  acquire(&stats.lock);
    80005aa0:	0001e517          	auipc	a0,0x1e
    80005aa4:	56050513          	addi	a0,a0,1376 # 80024000 <stats>
    80005aa8:	00001097          	auipc	ra,0x1
    80005aac:	df2080e7          	jalr	-526(ra) # 8000689a <acquire>

  if(stats.sz == 0) {
    80005ab0:	0001f797          	auipc	a5,0x1f
    80005ab4:	5707a783          	lw	a5,1392(a5) # 80025020 <stats+0x1020>
    80005ab8:	cbbd                	beqz	a5,80005b2e <statsread+0xa2>
#endif
#ifdef LAB_LOCK
    stats.sz = statslock(stats.buf, BUFSZ);
#endif
  }
  m = stats.sz - stats.off;
    80005aba:	0001f797          	auipc	a5,0x1f
    80005abe:	54678793          	addi	a5,a5,1350 # 80025000 <stats+0x1000>
    80005ac2:	53d8                	lw	a4,36(a5)
    80005ac4:	539c                	lw	a5,32(a5)
    80005ac6:	9f99                	subw	a5,a5,a4
    80005ac8:	0007869b          	sext.w	a3,a5

  if (m > 0) {
    80005acc:	06d05f63          	blez	a3,80005b4a <statsread+0xbe>
    80005ad0:	e052                	sd	s4,0(sp)
    if(m > n)
    80005ad2:	8a3e                	mv	s4,a5
    80005ad4:	00d4d363          	bge	s1,a3,80005ada <statsread+0x4e>
    80005ad8:	8a26                	mv	s4,s1
    80005ada:	000a049b          	sext.w	s1,s4
      m  = n;
    if(either_copyout(user_dst, dst, stats.buf+stats.off, m) != -1) {
    80005ade:	86a6                	mv	a3,s1
    80005ae0:	0001e617          	auipc	a2,0x1e
    80005ae4:	54060613          	addi	a2,a2,1344 # 80024020 <stats+0x20>
    80005ae8:	963a                	add	a2,a2,a4
    80005aea:	85ce                	mv	a1,s3
    80005aec:	854a                	mv	a0,s2
    80005aee:	ffffc097          	auipc	ra,0xffffc
    80005af2:	f02080e7          	jalr	-254(ra) # 800019f0 <either_copyout>
    80005af6:	57fd                	li	a5,-1
    80005af8:	06f50363          	beq	a0,a5,80005b5e <statsread+0xd2>
      stats.off += m;
    80005afc:	0001f717          	auipc	a4,0x1f
    80005b00:	50470713          	addi	a4,a4,1284 # 80025000 <stats+0x1000>
    80005b04:	535c                	lw	a5,36(a4)
    80005b06:	00fa07bb          	addw	a5,s4,a5
    80005b0a:	d35c                	sw	a5,36(a4)
    80005b0c:	6a02                	ld	s4,0(sp)
  } else {
    m = -1;
    stats.sz = 0;
    stats.off = 0;
  }
  release(&stats.lock);
    80005b0e:	0001e517          	auipc	a0,0x1e
    80005b12:	4f250513          	addi	a0,a0,1266 # 80024000 <stats>
    80005b16:	00001097          	auipc	ra,0x1
    80005b1a:	e4c080e7          	jalr	-436(ra) # 80006962 <release>
  return m;
}
    80005b1e:	8526                	mv	a0,s1
    80005b20:	70a2                	ld	ra,40(sp)
    80005b22:	7402                	ld	s0,32(sp)
    80005b24:	64e2                	ld	s1,24(sp)
    80005b26:	6942                	ld	s2,16(sp)
    80005b28:	69a2                	ld	s3,8(sp)
    80005b2a:	6145                	addi	sp,sp,48
    80005b2c:	8082                	ret
    stats.sz = statslock(stats.buf, BUFSZ);
    80005b2e:	6585                	lui	a1,0x1
    80005b30:	0001e517          	auipc	a0,0x1e
    80005b34:	4f050513          	addi	a0,a0,1264 # 80024020 <stats+0x20>
    80005b38:	00001097          	auipc	ra,0x1
    80005b3c:	fb2080e7          	jalr	-78(ra) # 80006aea <statslock>
    80005b40:	0001f797          	auipc	a5,0x1f
    80005b44:	4ea7a023          	sw	a0,1248(a5) # 80025020 <stats+0x1020>
    80005b48:	bf8d                	j	80005aba <statsread+0x2e>
    stats.sz = 0;
    80005b4a:	0001f797          	auipc	a5,0x1f
    80005b4e:	4b678793          	addi	a5,a5,1206 # 80025000 <stats+0x1000>
    80005b52:	0207a023          	sw	zero,32(a5)
    stats.off = 0;
    80005b56:	0207a223          	sw	zero,36(a5)
    m = -1;
    80005b5a:	54fd                	li	s1,-1
    80005b5c:	bf4d                	j	80005b0e <statsread+0x82>
    80005b5e:	6a02                	ld	s4,0(sp)
    80005b60:	b77d                	j	80005b0e <statsread+0x82>

0000000080005b62 <statsinit>:

void
statsinit(void)
{
    80005b62:	1141                	addi	sp,sp,-16
    80005b64:	e406                	sd	ra,8(sp)
    80005b66:	e022                	sd	s0,0(sp)
    80005b68:	0800                	addi	s0,sp,16
  initlock(&stats.lock, "stats");
    80005b6a:	00003597          	auipc	a1,0x3
    80005b6e:	b4658593          	addi	a1,a1,-1210 # 800086b0 <etext+0x6b0>
    80005b72:	0001e517          	auipc	a0,0x1e
    80005b76:	48e50513          	addi	a0,a0,1166 # 80024000 <stats>
    80005b7a:	00001097          	auipc	ra,0x1
    80005b7e:	e94080e7          	jalr	-364(ra) # 80006a0e <initlock>

  devsw[STATS].read = statsread;
    80005b82:	0001a797          	auipc	a5,0x1a
    80005b86:	29678793          	addi	a5,a5,662 # 8001fe18 <devsw>
    80005b8a:	00000717          	auipc	a4,0x0
    80005b8e:	f0270713          	addi	a4,a4,-254 # 80005a8c <statsread>
    80005b92:	f398                	sd	a4,32(a5)
  devsw[STATS].write = statswrite;
    80005b94:	00000717          	auipc	a4,0x0
    80005b98:	eea70713          	addi	a4,a4,-278 # 80005a7e <statswrite>
    80005b9c:	f798                	sd	a4,40(a5)
}
    80005b9e:	60a2                	ld	ra,8(sp)
    80005ba0:	6402                	ld	s0,0(sp)
    80005ba2:	0141                	addi	sp,sp,16
    80005ba4:	8082                	ret

0000000080005ba6 <sprintint>:
  return 1;
}

static int
sprintint(char *s, int xx, int base, int sign)
{
    80005ba6:	1101                	addi	sp,sp,-32
    80005ba8:	ec22                	sd	s0,24(sp)
    80005baa:	1000                	addi	s0,sp,32
    80005bac:	882a                	mv	a6,a0
  char buf[16];
  int i, n;
  uint x;

  if(sign && (sign = xx < 0))
    80005bae:	c299                	beqz	a3,80005bb4 <sprintint+0xe>
    80005bb0:	0805c263          	bltz	a1,80005c34 <sprintint+0x8e>
    x = -xx;
  else
    x = xx;
    80005bb4:	2581                	sext.w	a1,a1
    80005bb6:	4301                	li	t1,0

  i = 0;
    80005bb8:	fe040713          	addi	a4,s0,-32
    80005bbc:	4501                	li	a0,0
  do {
    buf[i++] = digits[x % base];
    80005bbe:	2601                	sext.w	a2,a2
    80005bc0:	00003697          	auipc	a3,0x3
    80005bc4:	cf068693          	addi	a3,a3,-784 # 800088b0 <digits>
    80005bc8:	88aa                	mv	a7,a0
    80005bca:	2505                	addiw	a0,a0,1
    80005bcc:	02c5f7bb          	remuw	a5,a1,a2
    80005bd0:	1782                	slli	a5,a5,0x20
    80005bd2:	9381                	srli	a5,a5,0x20
    80005bd4:	97b6                	add	a5,a5,a3
    80005bd6:	0007c783          	lbu	a5,0(a5)
    80005bda:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    80005bde:	0005879b          	sext.w	a5,a1
    80005be2:	02c5d5bb          	divuw	a1,a1,a2
    80005be6:	0705                	addi	a4,a4,1
    80005be8:	fec7f0e3          	bgeu	a5,a2,80005bc8 <sprintint+0x22>

  if(sign)
    80005bec:	00030b63          	beqz	t1,80005c02 <sprintint+0x5c>
    buf[i++] = '-';
    80005bf0:	ff050793          	addi	a5,a0,-16
    80005bf4:	97a2                	add	a5,a5,s0
    80005bf6:	02d00713          	li	a4,45
    80005bfa:	fee78823          	sb	a4,-16(a5)
    80005bfe:	0028851b          	addiw	a0,a7,2

  n = 0;
  while(--i >= 0)
    80005c02:	02a05d63          	blez	a0,80005c3c <sprintint+0x96>
    80005c06:	fe040793          	addi	a5,s0,-32
    80005c0a:	00a78733          	add	a4,a5,a0
    80005c0e:	87c2                	mv	a5,a6
    80005c10:	00180613          	addi	a2,a6,1
    80005c14:	fff5069b          	addiw	a3,a0,-1
    80005c18:	1682                	slli	a3,a3,0x20
    80005c1a:	9281                	srli	a3,a3,0x20
    80005c1c:	9636                	add	a2,a2,a3
  *s = c;
    80005c1e:	fff74683          	lbu	a3,-1(a4)
    80005c22:	00d78023          	sb	a3,0(a5)
  while(--i >= 0)
    80005c26:	177d                	addi	a4,a4,-1
    80005c28:	0785                	addi	a5,a5,1
    80005c2a:	fec79ae3          	bne	a5,a2,80005c1e <sprintint+0x78>
    n += sputc(s+n, buf[i]);
  return n;
}
    80005c2e:	6462                	ld	s0,24(sp)
    80005c30:	6105                	addi	sp,sp,32
    80005c32:	8082                	ret
    x = -xx;
    80005c34:	40b005bb          	negw	a1,a1
  if(sign && (sign = xx < 0))
    80005c38:	4305                	li	t1,1
    x = -xx;
    80005c3a:	bfbd                	j	80005bb8 <sprintint+0x12>
  while(--i >= 0)
    80005c3c:	4501                	li	a0,0
    80005c3e:	bfc5                	j	80005c2e <sprintint+0x88>

0000000080005c40 <snprintf>:

int
snprintf(char *buf, int sz, char *fmt, ...)
{
    80005c40:	7135                	addi	sp,sp,-160
    80005c42:	f486                	sd	ra,104(sp)
    80005c44:	f0a2                	sd	s0,96(sp)
    80005c46:	1880                	addi	s0,sp,112
    80005c48:	e414                	sd	a3,8(s0)
    80005c4a:	e818                	sd	a4,16(s0)
    80005c4c:	ec1c                	sd	a5,24(s0)
    80005c4e:	03043023          	sd	a6,32(s0)
    80005c52:	03143423          	sd	a7,40(s0)
  va_list ap;
  int i, c;
  int off = 0;
  char *s;

  if (fmt == 0)
    80005c56:	ce15                	beqz	a2,80005c92 <snprintf+0x52>
    80005c58:	eca6                	sd	s1,88(sp)
    80005c5a:	e8ca                	sd	s2,80(sp)
    80005c5c:	e4ce                	sd	s3,72(sp)
    80005c5e:	fc56                	sd	s5,56(sp)
    80005c60:	f85a                	sd	s6,48(sp)
    80005c62:	8b2a                	mv	s6,a0
    80005c64:	8aae                	mv	s5,a1
    80005c66:	89b2                	mv	s3,a2
    panic("null fmt");

  va_start(ap, fmt);
    80005c68:	00840793          	addi	a5,s0,8
    80005c6c:	f8f43c23          	sd	a5,-104(s0)
  int off = 0;
    80005c70:	4481                	li	s1,0
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005c72:	4901                	li	s2,0
    80005c74:	04b05063          	blez	a1,80005cb4 <snprintf+0x74>
    80005c78:	e0d2                	sd	s4,64(sp)
    80005c7a:	f45e                	sd	s7,40(sp)
    80005c7c:	f062                	sd	s8,32(sp)
    80005c7e:	ec66                	sd	s9,24(sp)
    if(c != '%'){
    80005c80:	02500a13          	li	s4,37
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    80005c84:	07300b93          	li	s7,115
    80005c88:	07800c93          	li	s9,120
    80005c8c:	06400c13          	li	s8,100
    80005c90:	a825                	j	80005cc8 <snprintf+0x88>
    80005c92:	eca6                	sd	s1,88(sp)
    80005c94:	e8ca                	sd	s2,80(sp)
    80005c96:	e4ce                	sd	s3,72(sp)
    80005c98:	e0d2                	sd	s4,64(sp)
    80005c9a:	fc56                	sd	s5,56(sp)
    80005c9c:	f85a                	sd	s6,48(sp)
    80005c9e:	f45e                	sd	s7,40(sp)
    80005ca0:	f062                	sd	s8,32(sp)
    80005ca2:	ec66                	sd	s9,24(sp)
    panic("null fmt");
    80005ca4:	00003517          	auipc	a0,0x3
    80005ca8:	a1c50513          	addi	a0,a0,-1508 # 800086c0 <etext+0x6c0>
    80005cac:	00000097          	auipc	ra,0x0
    80005cb0:	68a080e7          	jalr	1674(ra) # 80006336 <panic>
  int off = 0;
    80005cb4:	4481                	li	s1,0
    80005cb6:	a8d9                	j	80005d8c <snprintf+0x14c>
  *s = c;
    80005cb8:	009b0733          	add	a4,s6,s1
    80005cbc:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005cc0:	2485                	addiw	s1,s1,1
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005cc2:	2905                	addiw	s2,s2,1
    80005cc4:	1354d563          	bge	s1,s5,80005dee <snprintf+0x1ae>
    80005cc8:	012987b3          	add	a5,s3,s2
    80005ccc:	0007c783          	lbu	a5,0(a5)
    80005cd0:	0007871b          	sext.w	a4,a5
    80005cd4:	cff5                	beqz	a5,80005dd0 <snprintf+0x190>
    if(c != '%'){
    80005cd6:	ff4711e3          	bne	a4,s4,80005cb8 <snprintf+0x78>
    c = fmt[++i] & 0xff;
    80005cda:	2905                	addiw	s2,s2,1
    80005cdc:	012987b3          	add	a5,s3,s2
    80005ce0:	0007c783          	lbu	a5,0(a5)
    if(c == 0)
    80005ce4:	cbfd                	beqz	a5,80005dda <snprintf+0x19a>
    switch(c){
    80005ce6:	05778c63          	beq	a5,s7,80005d3e <snprintf+0xfe>
    80005cea:	02fbe763          	bltu	s7,a5,80005d18 <snprintf+0xd8>
    80005cee:	0d478063          	beq	a5,s4,80005dae <snprintf+0x16e>
    80005cf2:	0d879463          	bne	a5,s8,80005dba <snprintf+0x17a>
    case 'd':
      off += sprintint(buf+off, va_arg(ap, int), 10, 1);
    80005cf6:	f9843783          	ld	a5,-104(s0)
    80005cfa:	00878713          	addi	a4,a5,8
    80005cfe:	f8e43c23          	sd	a4,-104(s0)
    80005d02:	4685                	li	a3,1
    80005d04:	4629                	li	a2,10
    80005d06:	438c                	lw	a1,0(a5)
    80005d08:	009b0533          	add	a0,s6,s1
    80005d0c:	00000097          	auipc	ra,0x0
    80005d10:	e9a080e7          	jalr	-358(ra) # 80005ba6 <sprintint>
    80005d14:	9ca9                	addw	s1,s1,a0
      break;
    80005d16:	b775                	j	80005cc2 <snprintf+0x82>
    switch(c){
    80005d18:	0b979163          	bne	a5,s9,80005dba <snprintf+0x17a>
    case 'x':
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
    80005d1c:	f9843783          	ld	a5,-104(s0)
    80005d20:	00878713          	addi	a4,a5,8
    80005d24:	f8e43c23          	sd	a4,-104(s0)
    80005d28:	4685                	li	a3,1
    80005d2a:	4641                	li	a2,16
    80005d2c:	438c                	lw	a1,0(a5)
    80005d2e:	009b0533          	add	a0,s6,s1
    80005d32:	00000097          	auipc	ra,0x0
    80005d36:	e74080e7          	jalr	-396(ra) # 80005ba6 <sprintint>
    80005d3a:	9ca9                	addw	s1,s1,a0
      break;
    80005d3c:	b759                	j	80005cc2 <snprintf+0x82>
    case 's':
      if((s = va_arg(ap, char*)) == 0)
    80005d3e:	f9843783          	ld	a5,-104(s0)
    80005d42:	00878713          	addi	a4,a5,8
    80005d46:	f8e43c23          	sd	a4,-104(s0)
    80005d4a:	6388                	ld	a0,0(a5)
    80005d4c:	c931                	beqz	a0,80005da0 <snprintf+0x160>
        s = "(null)";
      for(; *s && off < sz; s++)
    80005d4e:	00054703          	lbu	a4,0(a0)
    80005d52:	db25                	beqz	a4,80005cc2 <snprintf+0x82>
    80005d54:	0954d863          	bge	s1,s5,80005de4 <snprintf+0x1a4>
    80005d58:	009b06b3          	add	a3,s6,s1
    80005d5c:	409a863b          	subw	a2,s5,s1
    80005d60:	1602                	slli	a2,a2,0x20
    80005d62:	9201                	srli	a2,a2,0x20
    80005d64:	962a                	add	a2,a2,a0
    80005d66:	87aa                	mv	a5,a0
        off += sputc(buf+off, *s);
    80005d68:	0014859b          	addiw	a1,s1,1
    80005d6c:	9d89                	subw	a1,a1,a0
  *s = c;
    80005d6e:	00e68023          	sb	a4,0(a3)
        off += sputc(buf+off, *s);
    80005d72:	00f584bb          	addw	s1,a1,a5
      for(; *s && off < sz; s++)
    80005d76:	0785                	addi	a5,a5,1
    80005d78:	0007c703          	lbu	a4,0(a5)
    80005d7c:	d339                	beqz	a4,80005cc2 <snprintf+0x82>
    80005d7e:	0685                	addi	a3,a3,1
    80005d80:	fec797e3          	bne	a5,a2,80005d6e <snprintf+0x12e>
    80005d84:	6a06                	ld	s4,64(sp)
    80005d86:	7ba2                	ld	s7,40(sp)
    80005d88:	7c02                	ld	s8,32(sp)
    80005d8a:	6ce2                	ld	s9,24(sp)
      off += sputc(buf+off, c);
      break;
    }
  }
  return off;
}
    80005d8c:	8526                	mv	a0,s1
    80005d8e:	64e6                	ld	s1,88(sp)
    80005d90:	6946                	ld	s2,80(sp)
    80005d92:	69a6                	ld	s3,72(sp)
    80005d94:	7ae2                	ld	s5,56(sp)
    80005d96:	7b42                	ld	s6,48(sp)
    80005d98:	70a6                	ld	ra,104(sp)
    80005d9a:	7406                	ld	s0,96(sp)
    80005d9c:	610d                	addi	sp,sp,160
    80005d9e:	8082                	ret
      for(; *s && off < sz; s++)
    80005da0:	02800713          	li	a4,40
        s = "(null)";
    80005da4:	00003517          	auipc	a0,0x3
    80005da8:	91450513          	addi	a0,a0,-1772 # 800086b8 <etext+0x6b8>
    80005dac:	b765                	j	80005d54 <snprintf+0x114>
  *s = c;
    80005dae:	009b07b3          	add	a5,s6,s1
    80005db2:	01478023          	sb	s4,0(a5)
      off += sputc(buf+off, '%');
    80005db6:	2485                	addiw	s1,s1,1
      break;
    80005db8:	b729                	j	80005cc2 <snprintf+0x82>
  *s = c;
    80005dba:	009b0733          	add	a4,s6,s1
    80005dbe:	01470023          	sb	s4,0(a4)
      off += sputc(buf+off, c);
    80005dc2:	0014871b          	addiw	a4,s1,1
  *s = c;
    80005dc6:	975a                	add	a4,a4,s6
    80005dc8:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005dcc:	2489                	addiw	s1,s1,2
      break;
    80005dce:	bdd5                	j	80005cc2 <snprintf+0x82>
    80005dd0:	6a06                	ld	s4,64(sp)
    80005dd2:	7ba2                	ld	s7,40(sp)
    80005dd4:	7c02                	ld	s8,32(sp)
    80005dd6:	6ce2                	ld	s9,24(sp)
    80005dd8:	bf55                	j	80005d8c <snprintf+0x14c>
    80005dda:	6a06                	ld	s4,64(sp)
    80005ddc:	7ba2                	ld	s7,40(sp)
    80005dde:	7c02                	ld	s8,32(sp)
    80005de0:	6ce2                	ld	s9,24(sp)
    80005de2:	b76d                	j	80005d8c <snprintf+0x14c>
    80005de4:	6a06                	ld	s4,64(sp)
    80005de6:	7ba2                	ld	s7,40(sp)
    80005de8:	7c02                	ld	s8,32(sp)
    80005dea:	6ce2                	ld	s9,24(sp)
    80005dec:	b745                	j	80005d8c <snprintf+0x14c>
    80005dee:	6a06                	ld	s4,64(sp)
    80005df0:	7ba2                	ld	s7,40(sp)
    80005df2:	7c02                	ld	s8,32(sp)
    80005df4:	6ce2                	ld	s9,24(sp)
    80005df6:	bf59                	j	80005d8c <snprintf+0x14c>

0000000080005df8 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005df8:	1141                	addi	sp,sp,-16
    80005dfa:	e422                	sd	s0,8(sp)
    80005dfc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005dfe:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005e02:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005e06:	0037979b          	slliw	a5,a5,0x3
    80005e0a:	02004737          	lui	a4,0x2004
    80005e0e:	97ba                	add	a5,a5,a4
    80005e10:	0200c737          	lui	a4,0x200c
    80005e14:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    80005e16:	6318                	ld	a4,0(a4)
    80005e18:	000f4637          	lui	a2,0xf4
    80005e1c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005e20:	9732                	add	a4,a4,a2
    80005e22:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005e24:	00259693          	slli	a3,a1,0x2
    80005e28:	96ae                	add	a3,a3,a1
    80005e2a:	068e                	slli	a3,a3,0x3
    80005e2c:	0001f717          	auipc	a4,0x1f
    80005e30:	20470713          	addi	a4,a4,516 # 80025030 <timer_scratch>
    80005e34:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005e36:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005e38:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005e3a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005e3e:	fffff797          	auipc	a5,0xfffff
    80005e42:	62278793          	addi	a5,a5,1570 # 80005460 <timervec>
    80005e46:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005e4a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005e4e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005e52:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005e56:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005e5a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005e5e:	30479073          	csrw	mie,a5
}
    80005e62:	6422                	ld	s0,8(sp)
    80005e64:	0141                	addi	sp,sp,16
    80005e66:	8082                	ret

0000000080005e68 <start>:
{
    80005e68:	1141                	addi	sp,sp,-16
    80005e6a:	e406                	sd	ra,8(sp)
    80005e6c:	e022                	sd	s0,0(sp)
    80005e6e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005e70:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005e74:	7779                	lui	a4,0xffffe
    80005e76:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd05b7>
    80005e7a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005e7c:	6705                	lui	a4,0x1
    80005e7e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005e82:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005e84:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005e88:	ffffa797          	auipc	a5,0xffffa
    80005e8c:	58a78793          	addi	a5,a5,1418 # 80000412 <main>
    80005e90:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005e94:	4781                	li	a5,0
    80005e96:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005e9a:	67c1                	lui	a5,0x10
    80005e9c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005e9e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005ea2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005ea6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005eaa:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005eae:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005eb2:	57fd                	li	a5,-1
    80005eb4:	83a9                	srli	a5,a5,0xa
    80005eb6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005eba:	47bd                	li	a5,15
    80005ebc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005ec0:	00000097          	auipc	ra,0x0
    80005ec4:	f38080e7          	jalr	-200(ra) # 80005df8 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005ec8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005ecc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005ece:	823e                	mv	tp,a5
  asm volatile("mret");
    80005ed0:	30200073          	mret
}
    80005ed4:	60a2                	ld	ra,8(sp)
    80005ed6:	6402                	ld	s0,0(sp)
    80005ed8:	0141                	addi	sp,sp,16
    80005eda:	8082                	ret

0000000080005edc <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005edc:	715d                	addi	sp,sp,-80
    80005ede:	e486                	sd	ra,72(sp)
    80005ee0:	e0a2                	sd	s0,64(sp)
    80005ee2:	f84a                	sd	s2,48(sp)
    80005ee4:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005ee6:	04c05663          	blez	a2,80005f32 <consolewrite+0x56>
    80005eea:	fc26                	sd	s1,56(sp)
    80005eec:	f44e                	sd	s3,40(sp)
    80005eee:	f052                	sd	s4,32(sp)
    80005ef0:	ec56                	sd	s5,24(sp)
    80005ef2:	8a2a                	mv	s4,a0
    80005ef4:	84ae                	mv	s1,a1
    80005ef6:	89b2                	mv	s3,a2
    80005ef8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005efa:	5afd                	li	s5,-1
    80005efc:	4685                	li	a3,1
    80005efe:	8626                	mv	a2,s1
    80005f00:	85d2                	mv	a1,s4
    80005f02:	fbf40513          	addi	a0,s0,-65
    80005f06:	ffffc097          	auipc	ra,0xffffc
    80005f0a:	b40080e7          	jalr	-1216(ra) # 80001a46 <either_copyin>
    80005f0e:	03550463          	beq	a0,s5,80005f36 <consolewrite+0x5a>
      break;
    uartputc(c);
    80005f12:	fbf44503          	lbu	a0,-65(s0)
    80005f16:	00000097          	auipc	ra,0x0
    80005f1a:	7de080e7          	jalr	2014(ra) # 800066f4 <uartputc>
  for(i = 0; i < n; i++){
    80005f1e:	2905                	addiw	s2,s2,1
    80005f20:	0485                	addi	s1,s1,1
    80005f22:	fd299de3          	bne	s3,s2,80005efc <consolewrite+0x20>
    80005f26:	894e                	mv	s2,s3
    80005f28:	74e2                	ld	s1,56(sp)
    80005f2a:	79a2                	ld	s3,40(sp)
    80005f2c:	7a02                	ld	s4,32(sp)
    80005f2e:	6ae2                	ld	s5,24(sp)
    80005f30:	a039                	j	80005f3e <consolewrite+0x62>
    80005f32:	4901                	li	s2,0
    80005f34:	a029                	j	80005f3e <consolewrite+0x62>
    80005f36:	74e2                	ld	s1,56(sp)
    80005f38:	79a2                	ld	s3,40(sp)
    80005f3a:	7a02                	ld	s4,32(sp)
    80005f3c:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005f3e:	854a                	mv	a0,s2
    80005f40:	60a6                	ld	ra,72(sp)
    80005f42:	6406                	ld	s0,64(sp)
    80005f44:	7942                	ld	s2,48(sp)
    80005f46:	6161                	addi	sp,sp,80
    80005f48:	8082                	ret

0000000080005f4a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005f4a:	711d                	addi	sp,sp,-96
    80005f4c:	ec86                	sd	ra,88(sp)
    80005f4e:	e8a2                	sd	s0,80(sp)
    80005f50:	e4a6                	sd	s1,72(sp)
    80005f52:	e0ca                	sd	s2,64(sp)
    80005f54:	fc4e                	sd	s3,56(sp)
    80005f56:	f852                	sd	s4,48(sp)
    80005f58:	f456                	sd	s5,40(sp)
    80005f5a:	f05a                	sd	s6,32(sp)
    80005f5c:	1080                	addi	s0,sp,96
    80005f5e:	8aaa                	mv	s5,a0
    80005f60:	8a2e                	mv	s4,a1
    80005f62:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005f64:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005f68:	00027517          	auipc	a0,0x27
    80005f6c:	20850513          	addi	a0,a0,520 # 8002d170 <cons>
    80005f70:	00001097          	auipc	ra,0x1
    80005f74:	92a080e7          	jalr	-1750(ra) # 8000689a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005f78:	00027497          	auipc	s1,0x27
    80005f7c:	1f848493          	addi	s1,s1,504 # 8002d170 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005f80:	00027917          	auipc	s2,0x27
    80005f84:	29090913          	addi	s2,s2,656 # 8002d210 <cons+0xa0>
  while(n > 0){
    80005f88:	0d305463          	blez	s3,80006050 <consoleread+0x106>
    while(cons.r == cons.w){
    80005f8c:	0a04a783          	lw	a5,160(s1)
    80005f90:	0a44a703          	lw	a4,164(s1)
    80005f94:	0af71963          	bne	a4,a5,80006046 <consoleread+0xfc>
      if(myproc()->killed){
    80005f98:	ffffb097          	auipc	ra,0xffffb
    80005f9c:	fee080e7          	jalr	-18(ra) # 80000f86 <myproc>
    80005fa0:	591c                	lw	a5,48(a0)
    80005fa2:	e7ad                	bnez	a5,8000600c <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80005fa4:	85a6                	mv	a1,s1
    80005fa6:	854a                	mv	a0,s2
    80005fa8:	ffffb097          	auipc	ra,0xffffb
    80005fac:	6a4080e7          	jalr	1700(ra) # 8000164c <sleep>
    while(cons.r == cons.w){
    80005fb0:	0a04a783          	lw	a5,160(s1)
    80005fb4:	0a44a703          	lw	a4,164(s1)
    80005fb8:	fef700e3          	beq	a4,a5,80005f98 <consoleread+0x4e>
    80005fbc:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005fbe:	00027717          	auipc	a4,0x27
    80005fc2:	1b270713          	addi	a4,a4,434 # 8002d170 <cons>
    80005fc6:	0017869b          	addiw	a3,a5,1
    80005fca:	0ad72023          	sw	a3,160(a4)
    80005fce:	07f7f693          	andi	a3,a5,127
    80005fd2:	9736                	add	a4,a4,a3
    80005fd4:	02074703          	lbu	a4,32(a4)
    80005fd8:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005fdc:	4691                	li	a3,4
    80005fde:	04db8a63          	beq	s7,a3,80006032 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005fe2:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005fe6:	4685                	li	a3,1
    80005fe8:	faf40613          	addi	a2,s0,-81
    80005fec:	85d2                	mv	a1,s4
    80005fee:	8556                	mv	a0,s5
    80005ff0:	ffffc097          	auipc	ra,0xffffc
    80005ff4:	a00080e7          	jalr	-1536(ra) # 800019f0 <either_copyout>
    80005ff8:	57fd                	li	a5,-1
    80005ffa:	04f50a63          	beq	a0,a5,8000604e <consoleread+0x104>
      break;

    dst++;
    80005ffe:	0a05                	addi	s4,s4,1
    --n;
    80006000:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80006002:	47a9                	li	a5,10
    80006004:	06fb8163          	beq	s7,a5,80006066 <consoleread+0x11c>
    80006008:	6be2                	ld	s7,24(sp)
    8000600a:	bfbd                	j	80005f88 <consoleread+0x3e>
        release(&cons.lock);
    8000600c:	00027517          	auipc	a0,0x27
    80006010:	16450513          	addi	a0,a0,356 # 8002d170 <cons>
    80006014:	00001097          	auipc	ra,0x1
    80006018:	94e080e7          	jalr	-1714(ra) # 80006962 <release>
        return -1;
    8000601c:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    8000601e:	60e6                	ld	ra,88(sp)
    80006020:	6446                	ld	s0,80(sp)
    80006022:	64a6                	ld	s1,72(sp)
    80006024:	6906                	ld	s2,64(sp)
    80006026:	79e2                	ld	s3,56(sp)
    80006028:	7a42                	ld	s4,48(sp)
    8000602a:	7aa2                	ld	s5,40(sp)
    8000602c:	7b02                	ld	s6,32(sp)
    8000602e:	6125                	addi	sp,sp,96
    80006030:	8082                	ret
      if(n < target){
    80006032:	0009871b          	sext.w	a4,s3
    80006036:	01677a63          	bgeu	a4,s6,8000604a <consoleread+0x100>
        cons.r--;
    8000603a:	00027717          	auipc	a4,0x27
    8000603e:	1cf72b23          	sw	a5,470(a4) # 8002d210 <cons+0xa0>
    80006042:	6be2                	ld	s7,24(sp)
    80006044:	a031                	j	80006050 <consoleread+0x106>
    80006046:	ec5e                	sd	s7,24(sp)
    80006048:	bf9d                	j	80005fbe <consoleread+0x74>
    8000604a:	6be2                	ld	s7,24(sp)
    8000604c:	a011                	j	80006050 <consoleread+0x106>
    8000604e:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80006050:	00027517          	auipc	a0,0x27
    80006054:	12050513          	addi	a0,a0,288 # 8002d170 <cons>
    80006058:	00001097          	auipc	ra,0x1
    8000605c:	90a080e7          	jalr	-1782(ra) # 80006962 <release>
  return target - n;
    80006060:	413b053b          	subw	a0,s6,s3
    80006064:	bf6d                	j	8000601e <consoleread+0xd4>
    80006066:	6be2                	ld	s7,24(sp)
    80006068:	b7e5                	j	80006050 <consoleread+0x106>

000000008000606a <consputc>:
{
    8000606a:	1141                	addi	sp,sp,-16
    8000606c:	e406                	sd	ra,8(sp)
    8000606e:	e022                	sd	s0,0(sp)
    80006070:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80006072:	10000793          	li	a5,256
    80006076:	00f50a63          	beq	a0,a5,8000608a <consputc+0x20>
    uartputc_sync(c);
    8000607a:	00000097          	auipc	ra,0x0
    8000607e:	59c080e7          	jalr	1436(ra) # 80006616 <uartputc_sync>
}
    80006082:	60a2                	ld	ra,8(sp)
    80006084:	6402                	ld	s0,0(sp)
    80006086:	0141                	addi	sp,sp,16
    80006088:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000608a:	4521                	li	a0,8
    8000608c:	00000097          	auipc	ra,0x0
    80006090:	58a080e7          	jalr	1418(ra) # 80006616 <uartputc_sync>
    80006094:	02000513          	li	a0,32
    80006098:	00000097          	auipc	ra,0x0
    8000609c:	57e080e7          	jalr	1406(ra) # 80006616 <uartputc_sync>
    800060a0:	4521                	li	a0,8
    800060a2:	00000097          	auipc	ra,0x0
    800060a6:	574080e7          	jalr	1396(ra) # 80006616 <uartputc_sync>
    800060aa:	bfe1                	j	80006082 <consputc+0x18>

00000000800060ac <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800060ac:	1101                	addi	sp,sp,-32
    800060ae:	ec06                	sd	ra,24(sp)
    800060b0:	e822                	sd	s0,16(sp)
    800060b2:	e426                	sd	s1,8(sp)
    800060b4:	1000                	addi	s0,sp,32
    800060b6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800060b8:	00027517          	auipc	a0,0x27
    800060bc:	0b850513          	addi	a0,a0,184 # 8002d170 <cons>
    800060c0:	00000097          	auipc	ra,0x0
    800060c4:	7da080e7          	jalr	2010(ra) # 8000689a <acquire>

  switch(c){
    800060c8:	47d5                	li	a5,21
    800060ca:	0af48563          	beq	s1,a5,80006174 <consoleintr+0xc8>
    800060ce:	0297c963          	blt	a5,s1,80006100 <consoleintr+0x54>
    800060d2:	47a1                	li	a5,8
    800060d4:	0ef48c63          	beq	s1,a5,800061cc <consoleintr+0x120>
    800060d8:	47c1                	li	a5,16
    800060da:	10f49f63          	bne	s1,a5,800061f8 <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    800060de:	ffffc097          	auipc	ra,0xffffc
    800060e2:	9be080e7          	jalr	-1602(ra) # 80001a9c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800060e6:	00027517          	auipc	a0,0x27
    800060ea:	08a50513          	addi	a0,a0,138 # 8002d170 <cons>
    800060ee:	00001097          	auipc	ra,0x1
    800060f2:	874080e7          	jalr	-1932(ra) # 80006962 <release>
}
    800060f6:	60e2                	ld	ra,24(sp)
    800060f8:	6442                	ld	s0,16(sp)
    800060fa:	64a2                	ld	s1,8(sp)
    800060fc:	6105                	addi	sp,sp,32
    800060fe:	8082                	ret
  switch(c){
    80006100:	07f00793          	li	a5,127
    80006104:	0cf48463          	beq	s1,a5,800061cc <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80006108:	00027717          	auipc	a4,0x27
    8000610c:	06870713          	addi	a4,a4,104 # 8002d170 <cons>
    80006110:	0a872783          	lw	a5,168(a4)
    80006114:	0a072703          	lw	a4,160(a4)
    80006118:	9f99                	subw	a5,a5,a4
    8000611a:	07f00713          	li	a4,127
    8000611e:	fcf764e3          	bltu	a4,a5,800060e6 <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80006122:	47b5                	li	a5,13
    80006124:	0cf48d63          	beq	s1,a5,800061fe <consoleintr+0x152>
      consputc(c);
    80006128:	8526                	mv	a0,s1
    8000612a:	00000097          	auipc	ra,0x0
    8000612e:	f40080e7          	jalr	-192(ra) # 8000606a <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006132:	00027797          	auipc	a5,0x27
    80006136:	03e78793          	addi	a5,a5,62 # 8002d170 <cons>
    8000613a:	0a87a703          	lw	a4,168(a5)
    8000613e:	0017069b          	addiw	a3,a4,1
    80006142:	0006861b          	sext.w	a2,a3
    80006146:	0ad7a423          	sw	a3,168(a5)
    8000614a:	07f77713          	andi	a4,a4,127
    8000614e:	97ba                	add	a5,a5,a4
    80006150:	02978023          	sb	s1,32(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80006154:	47a9                	li	a5,10
    80006156:	0cf48b63          	beq	s1,a5,8000622c <consoleintr+0x180>
    8000615a:	4791                	li	a5,4
    8000615c:	0cf48863          	beq	s1,a5,8000622c <consoleintr+0x180>
    80006160:	00027797          	auipc	a5,0x27
    80006164:	0b07a783          	lw	a5,176(a5) # 8002d210 <cons+0xa0>
    80006168:	0807879b          	addiw	a5,a5,128
    8000616c:	f6f61de3          	bne	a2,a5,800060e6 <consoleintr+0x3a>
    80006170:	863e                	mv	a2,a5
    80006172:	a86d                	j	8000622c <consoleintr+0x180>
    80006174:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80006176:	00027717          	auipc	a4,0x27
    8000617a:	ffa70713          	addi	a4,a4,-6 # 8002d170 <cons>
    8000617e:	0a872783          	lw	a5,168(a4)
    80006182:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80006186:	00027497          	auipc	s1,0x27
    8000618a:	fea48493          	addi	s1,s1,-22 # 8002d170 <cons>
    while(cons.e != cons.w &&
    8000618e:	4929                	li	s2,10
    80006190:	02f70a63          	beq	a4,a5,800061c4 <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80006194:	37fd                	addiw	a5,a5,-1
    80006196:	07f7f713          	andi	a4,a5,127
    8000619a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000619c:	02074703          	lbu	a4,32(a4)
    800061a0:	03270463          	beq	a4,s2,800061c8 <consoleintr+0x11c>
      cons.e--;
    800061a4:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    800061a8:	10000513          	li	a0,256
    800061ac:	00000097          	auipc	ra,0x0
    800061b0:	ebe080e7          	jalr	-322(ra) # 8000606a <consputc>
    while(cons.e != cons.w &&
    800061b4:	0a84a783          	lw	a5,168(s1)
    800061b8:	0a44a703          	lw	a4,164(s1)
    800061bc:	fcf71ce3          	bne	a4,a5,80006194 <consoleintr+0xe8>
    800061c0:	6902                	ld	s2,0(sp)
    800061c2:	b715                	j	800060e6 <consoleintr+0x3a>
    800061c4:	6902                	ld	s2,0(sp)
    800061c6:	b705                	j	800060e6 <consoleintr+0x3a>
    800061c8:	6902                	ld	s2,0(sp)
    800061ca:	bf31                	j	800060e6 <consoleintr+0x3a>
    if(cons.e != cons.w){
    800061cc:	00027717          	auipc	a4,0x27
    800061d0:	fa470713          	addi	a4,a4,-92 # 8002d170 <cons>
    800061d4:	0a872783          	lw	a5,168(a4)
    800061d8:	0a472703          	lw	a4,164(a4)
    800061dc:	f0f705e3          	beq	a4,a5,800060e6 <consoleintr+0x3a>
      cons.e--;
    800061e0:	37fd                	addiw	a5,a5,-1
    800061e2:	00027717          	auipc	a4,0x27
    800061e6:	02f72b23          	sw	a5,54(a4) # 8002d218 <cons+0xa8>
      consputc(BACKSPACE);
    800061ea:	10000513          	li	a0,256
    800061ee:	00000097          	auipc	ra,0x0
    800061f2:	e7c080e7          	jalr	-388(ra) # 8000606a <consputc>
    800061f6:	bdc5                	j	800060e6 <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800061f8:	ee0487e3          	beqz	s1,800060e6 <consoleintr+0x3a>
    800061fc:	b731                	j	80006108 <consoleintr+0x5c>
      consputc(c);
    800061fe:	4529                	li	a0,10
    80006200:	00000097          	auipc	ra,0x0
    80006204:	e6a080e7          	jalr	-406(ra) # 8000606a <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006208:	00027797          	auipc	a5,0x27
    8000620c:	f6878793          	addi	a5,a5,-152 # 8002d170 <cons>
    80006210:	0a87a703          	lw	a4,168(a5)
    80006214:	0017069b          	addiw	a3,a4,1
    80006218:	0006861b          	sext.w	a2,a3
    8000621c:	0ad7a423          	sw	a3,168(a5)
    80006220:	07f77713          	andi	a4,a4,127
    80006224:	97ba                	add	a5,a5,a4
    80006226:	4729                	li	a4,10
    80006228:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    8000622c:	00027797          	auipc	a5,0x27
    80006230:	fec7a423          	sw	a2,-24(a5) # 8002d214 <cons+0xa4>
        wakeup(&cons.r);
    80006234:	00027517          	auipc	a0,0x27
    80006238:	fdc50513          	addi	a0,a0,-36 # 8002d210 <cons+0xa0>
    8000623c:	ffffb097          	auipc	ra,0xffffb
    80006240:	59c080e7          	jalr	1436(ra) # 800017d8 <wakeup>
    80006244:	b54d                	j	800060e6 <consoleintr+0x3a>

0000000080006246 <consoleinit>:

void
consoleinit(void)
{
    80006246:	1141                	addi	sp,sp,-16
    80006248:	e406                	sd	ra,8(sp)
    8000624a:	e022                	sd	s0,0(sp)
    8000624c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000624e:	00002597          	auipc	a1,0x2
    80006252:	48258593          	addi	a1,a1,1154 # 800086d0 <etext+0x6d0>
    80006256:	00027517          	auipc	a0,0x27
    8000625a:	f1a50513          	addi	a0,a0,-230 # 8002d170 <cons>
    8000625e:	00000097          	auipc	ra,0x0
    80006262:	7b0080e7          	jalr	1968(ra) # 80006a0e <initlock>

  uartinit();
    80006266:	00000097          	auipc	ra,0x0
    8000626a:	354080e7          	jalr	852(ra) # 800065ba <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000626e:	0001a797          	auipc	a5,0x1a
    80006272:	baa78793          	addi	a5,a5,-1110 # 8001fe18 <devsw>
    80006276:	00000717          	auipc	a4,0x0
    8000627a:	cd470713          	addi	a4,a4,-812 # 80005f4a <consoleread>
    8000627e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006280:	00000717          	auipc	a4,0x0
    80006284:	c5c70713          	addi	a4,a4,-932 # 80005edc <consolewrite>
    80006288:	ef98                	sd	a4,24(a5)
}
    8000628a:	60a2                	ld	ra,8(sp)
    8000628c:	6402                	ld	s0,0(sp)
    8000628e:	0141                	addi	sp,sp,16
    80006290:	8082                	ret

0000000080006292 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80006292:	7179                	addi	sp,sp,-48
    80006294:	f406                	sd	ra,40(sp)
    80006296:	f022                	sd	s0,32(sp)
    80006298:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    8000629a:	c219                	beqz	a2,800062a0 <printint+0xe>
    8000629c:	08054963          	bltz	a0,8000632e <printint+0x9c>
    x = -xx;
  else
    x = xx;
    800062a0:	2501                	sext.w	a0,a0
    800062a2:	4881                	li	a7,0
    800062a4:	fd040693          	addi	a3,s0,-48

  i = 0;
    800062a8:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800062aa:	2581                	sext.w	a1,a1
    800062ac:	00002617          	auipc	a2,0x2
    800062b0:	61c60613          	addi	a2,a2,1564 # 800088c8 <digits>
    800062b4:	883a                	mv	a6,a4
    800062b6:	2705                	addiw	a4,a4,1
    800062b8:	02b577bb          	remuw	a5,a0,a1
    800062bc:	1782                	slli	a5,a5,0x20
    800062be:	9381                	srli	a5,a5,0x20
    800062c0:	97b2                	add	a5,a5,a2
    800062c2:	0007c783          	lbu	a5,0(a5)
    800062c6:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800062ca:	0005079b          	sext.w	a5,a0
    800062ce:	02b5553b          	divuw	a0,a0,a1
    800062d2:	0685                	addi	a3,a3,1
    800062d4:	feb7f0e3          	bgeu	a5,a1,800062b4 <printint+0x22>

  if(sign)
    800062d8:	00088c63          	beqz	a7,800062f0 <printint+0x5e>
    buf[i++] = '-';
    800062dc:	fe070793          	addi	a5,a4,-32
    800062e0:	00878733          	add	a4,a5,s0
    800062e4:	02d00793          	li	a5,45
    800062e8:	fef70823          	sb	a5,-16(a4)
    800062ec:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800062f0:	02e05b63          	blez	a4,80006326 <printint+0x94>
    800062f4:	ec26                	sd	s1,24(sp)
    800062f6:	e84a                	sd	s2,16(sp)
    800062f8:	fd040793          	addi	a5,s0,-48
    800062fc:	00e784b3          	add	s1,a5,a4
    80006300:	fff78913          	addi	s2,a5,-1
    80006304:	993a                	add	s2,s2,a4
    80006306:	377d                	addiw	a4,a4,-1
    80006308:	1702                	slli	a4,a4,0x20
    8000630a:	9301                	srli	a4,a4,0x20
    8000630c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006310:	fff4c503          	lbu	a0,-1(s1)
    80006314:	00000097          	auipc	ra,0x0
    80006318:	d56080e7          	jalr	-682(ra) # 8000606a <consputc>
  while(--i >= 0)
    8000631c:	14fd                	addi	s1,s1,-1
    8000631e:	ff2499e3          	bne	s1,s2,80006310 <printint+0x7e>
    80006322:	64e2                	ld	s1,24(sp)
    80006324:	6942                	ld	s2,16(sp)
}
    80006326:	70a2                	ld	ra,40(sp)
    80006328:	7402                	ld	s0,32(sp)
    8000632a:	6145                	addi	sp,sp,48
    8000632c:	8082                	ret
    x = -xx;
    8000632e:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006332:	4885                	li	a7,1
    x = -xx;
    80006334:	bf85                	j	800062a4 <printint+0x12>

0000000080006336 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006336:	1101                	addi	sp,sp,-32
    80006338:	ec06                	sd	ra,24(sp)
    8000633a:	e822                	sd	s0,16(sp)
    8000633c:	e426                	sd	s1,8(sp)
    8000633e:	1000                	addi	s0,sp,32
    80006340:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006342:	00027797          	auipc	a5,0x27
    80006346:	ee07af23          	sw	zero,-258(a5) # 8002d240 <pr+0x20>
  printf("panic: ");
    8000634a:	00002517          	auipc	a0,0x2
    8000634e:	38e50513          	addi	a0,a0,910 # 800086d8 <etext+0x6d8>
    80006352:	00000097          	auipc	ra,0x0
    80006356:	02e080e7          	jalr	46(ra) # 80006380 <printf>
  printf(s);
    8000635a:	8526                	mv	a0,s1
    8000635c:	00000097          	auipc	ra,0x0
    80006360:	024080e7          	jalr	36(ra) # 80006380 <printf>
  printf("\n");
    80006364:	00002517          	auipc	a0,0x2
    80006368:	cb450513          	addi	a0,a0,-844 # 80008018 <etext+0x18>
    8000636c:	00000097          	auipc	ra,0x0
    80006370:	014080e7          	jalr	20(ra) # 80006380 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006374:	4785                	li	a5,1
    80006376:	00006717          	auipc	a4,0x6
    8000637a:	caf72323          	sw	a5,-858(a4) # 8000c01c <panicked>
  for(;;)
    8000637e:	a001                	j	8000637e <panic+0x48>

0000000080006380 <printf>:
{
    80006380:	7131                	addi	sp,sp,-192
    80006382:	fc86                	sd	ra,120(sp)
    80006384:	f8a2                	sd	s0,112(sp)
    80006386:	e8d2                	sd	s4,80(sp)
    80006388:	f06a                	sd	s10,32(sp)
    8000638a:	0100                	addi	s0,sp,128
    8000638c:	8a2a                	mv	s4,a0
    8000638e:	e40c                	sd	a1,8(s0)
    80006390:	e810                	sd	a2,16(s0)
    80006392:	ec14                	sd	a3,24(s0)
    80006394:	f018                	sd	a4,32(s0)
    80006396:	f41c                	sd	a5,40(s0)
    80006398:	03043823          	sd	a6,48(s0)
    8000639c:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800063a0:	00027d17          	auipc	s10,0x27
    800063a4:	ea0d2d03          	lw	s10,-352(s10) # 8002d240 <pr+0x20>
  if(locking)
    800063a8:	040d1463          	bnez	s10,800063f0 <printf+0x70>
  if (fmt == 0)
    800063ac:	040a0b63          	beqz	s4,80006402 <printf+0x82>
  va_start(ap, fmt);
    800063b0:	00840793          	addi	a5,s0,8
    800063b4:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800063b8:	000a4503          	lbu	a0,0(s4)
    800063bc:	18050b63          	beqz	a0,80006552 <printf+0x1d2>
    800063c0:	f4a6                	sd	s1,104(sp)
    800063c2:	f0ca                	sd	s2,96(sp)
    800063c4:	ecce                	sd	s3,88(sp)
    800063c6:	e4d6                	sd	s5,72(sp)
    800063c8:	e0da                	sd	s6,64(sp)
    800063ca:	fc5e                	sd	s7,56(sp)
    800063cc:	f862                	sd	s8,48(sp)
    800063ce:	f466                	sd	s9,40(sp)
    800063d0:	ec6e                	sd	s11,24(sp)
    800063d2:	4981                	li	s3,0
    if(c != '%'){
    800063d4:	02500b13          	li	s6,37
    switch(c){
    800063d8:	07000b93          	li	s7,112
  consputc('x');
    800063dc:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800063de:	00002a97          	auipc	s5,0x2
    800063e2:	4eaa8a93          	addi	s5,s5,1258 # 800088c8 <digits>
    switch(c){
    800063e6:	07300c13          	li	s8,115
    800063ea:	06400d93          	li	s11,100
    800063ee:	a0b1                	j	8000643a <printf+0xba>
    acquire(&pr.lock);
    800063f0:	00027517          	auipc	a0,0x27
    800063f4:	e3050513          	addi	a0,a0,-464 # 8002d220 <pr>
    800063f8:	00000097          	auipc	ra,0x0
    800063fc:	4a2080e7          	jalr	1186(ra) # 8000689a <acquire>
    80006400:	b775                	j	800063ac <printf+0x2c>
    80006402:	f4a6                	sd	s1,104(sp)
    80006404:	f0ca                	sd	s2,96(sp)
    80006406:	ecce                	sd	s3,88(sp)
    80006408:	e4d6                	sd	s5,72(sp)
    8000640a:	e0da                	sd	s6,64(sp)
    8000640c:	fc5e                	sd	s7,56(sp)
    8000640e:	f862                	sd	s8,48(sp)
    80006410:	f466                	sd	s9,40(sp)
    80006412:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80006414:	00002517          	auipc	a0,0x2
    80006418:	2ac50513          	addi	a0,a0,684 # 800086c0 <etext+0x6c0>
    8000641c:	00000097          	auipc	ra,0x0
    80006420:	f1a080e7          	jalr	-230(ra) # 80006336 <panic>
      consputc(c);
    80006424:	00000097          	auipc	ra,0x0
    80006428:	c46080e7          	jalr	-954(ra) # 8000606a <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000642c:	2985                	addiw	s3,s3,1
    8000642e:	013a07b3          	add	a5,s4,s3
    80006432:	0007c503          	lbu	a0,0(a5)
    80006436:	10050563          	beqz	a0,80006540 <printf+0x1c0>
    if(c != '%'){
    8000643a:	ff6515e3          	bne	a0,s6,80006424 <printf+0xa4>
    c = fmt[++i] & 0xff;
    8000643e:	2985                	addiw	s3,s3,1
    80006440:	013a07b3          	add	a5,s4,s3
    80006444:	0007c783          	lbu	a5,0(a5)
    80006448:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000644c:	10078b63          	beqz	a5,80006562 <printf+0x1e2>
    switch(c){
    80006450:	05778a63          	beq	a5,s7,800064a4 <printf+0x124>
    80006454:	02fbf663          	bgeu	s7,a5,80006480 <printf+0x100>
    80006458:	09878863          	beq	a5,s8,800064e8 <printf+0x168>
    8000645c:	07800713          	li	a4,120
    80006460:	0ce79563          	bne	a5,a4,8000652a <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80006464:	f8843783          	ld	a5,-120(s0)
    80006468:	00878713          	addi	a4,a5,8
    8000646c:	f8e43423          	sd	a4,-120(s0)
    80006470:	4605                	li	a2,1
    80006472:	85e6                	mv	a1,s9
    80006474:	4388                	lw	a0,0(a5)
    80006476:	00000097          	auipc	ra,0x0
    8000647a:	e1c080e7          	jalr	-484(ra) # 80006292 <printint>
      break;
    8000647e:	b77d                	j	8000642c <printf+0xac>
    switch(c){
    80006480:	09678f63          	beq	a5,s6,8000651e <printf+0x19e>
    80006484:	0bb79363          	bne	a5,s11,8000652a <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80006488:	f8843783          	ld	a5,-120(s0)
    8000648c:	00878713          	addi	a4,a5,8
    80006490:	f8e43423          	sd	a4,-120(s0)
    80006494:	4605                	li	a2,1
    80006496:	45a9                	li	a1,10
    80006498:	4388                	lw	a0,0(a5)
    8000649a:	00000097          	auipc	ra,0x0
    8000649e:	df8080e7          	jalr	-520(ra) # 80006292 <printint>
      break;
    800064a2:	b769                	j	8000642c <printf+0xac>
      printptr(va_arg(ap, uint64));
    800064a4:	f8843783          	ld	a5,-120(s0)
    800064a8:	00878713          	addi	a4,a5,8
    800064ac:	f8e43423          	sd	a4,-120(s0)
    800064b0:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800064b4:	03000513          	li	a0,48
    800064b8:	00000097          	auipc	ra,0x0
    800064bc:	bb2080e7          	jalr	-1102(ra) # 8000606a <consputc>
  consputc('x');
    800064c0:	07800513          	li	a0,120
    800064c4:	00000097          	auipc	ra,0x0
    800064c8:	ba6080e7          	jalr	-1114(ra) # 8000606a <consputc>
    800064cc:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800064ce:	03c95793          	srli	a5,s2,0x3c
    800064d2:	97d6                	add	a5,a5,s5
    800064d4:	0007c503          	lbu	a0,0(a5)
    800064d8:	00000097          	auipc	ra,0x0
    800064dc:	b92080e7          	jalr	-1134(ra) # 8000606a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800064e0:	0912                	slli	s2,s2,0x4
    800064e2:	34fd                	addiw	s1,s1,-1
    800064e4:	f4ed                	bnez	s1,800064ce <printf+0x14e>
    800064e6:	b799                	j	8000642c <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    800064e8:	f8843783          	ld	a5,-120(s0)
    800064ec:	00878713          	addi	a4,a5,8
    800064f0:	f8e43423          	sd	a4,-120(s0)
    800064f4:	6384                	ld	s1,0(a5)
    800064f6:	cc89                	beqz	s1,80006510 <printf+0x190>
      for(; *s; s++)
    800064f8:	0004c503          	lbu	a0,0(s1)
    800064fc:	d905                	beqz	a0,8000642c <printf+0xac>
        consputc(*s);
    800064fe:	00000097          	auipc	ra,0x0
    80006502:	b6c080e7          	jalr	-1172(ra) # 8000606a <consputc>
      for(; *s; s++)
    80006506:	0485                	addi	s1,s1,1
    80006508:	0004c503          	lbu	a0,0(s1)
    8000650c:	f96d                	bnez	a0,800064fe <printf+0x17e>
    8000650e:	bf39                	j	8000642c <printf+0xac>
        s = "(null)";
    80006510:	00002497          	auipc	s1,0x2
    80006514:	1a848493          	addi	s1,s1,424 # 800086b8 <etext+0x6b8>
      for(; *s; s++)
    80006518:	02800513          	li	a0,40
    8000651c:	b7cd                	j	800064fe <printf+0x17e>
      consputc('%');
    8000651e:	855a                	mv	a0,s6
    80006520:	00000097          	auipc	ra,0x0
    80006524:	b4a080e7          	jalr	-1206(ra) # 8000606a <consputc>
      break;
    80006528:	b711                	j	8000642c <printf+0xac>
      consputc('%');
    8000652a:	855a                	mv	a0,s6
    8000652c:	00000097          	auipc	ra,0x0
    80006530:	b3e080e7          	jalr	-1218(ra) # 8000606a <consputc>
      consputc(c);
    80006534:	8526                	mv	a0,s1
    80006536:	00000097          	auipc	ra,0x0
    8000653a:	b34080e7          	jalr	-1228(ra) # 8000606a <consputc>
      break;
    8000653e:	b5fd                	j	8000642c <printf+0xac>
    80006540:	74a6                	ld	s1,104(sp)
    80006542:	7906                	ld	s2,96(sp)
    80006544:	69e6                	ld	s3,88(sp)
    80006546:	6aa6                	ld	s5,72(sp)
    80006548:	6b06                	ld	s6,64(sp)
    8000654a:	7be2                	ld	s7,56(sp)
    8000654c:	7c42                	ld	s8,48(sp)
    8000654e:	7ca2                	ld	s9,40(sp)
    80006550:	6de2                	ld	s11,24(sp)
  if(locking)
    80006552:	020d1263          	bnez	s10,80006576 <printf+0x1f6>
}
    80006556:	70e6                	ld	ra,120(sp)
    80006558:	7446                	ld	s0,112(sp)
    8000655a:	6a46                	ld	s4,80(sp)
    8000655c:	7d02                	ld	s10,32(sp)
    8000655e:	6129                	addi	sp,sp,192
    80006560:	8082                	ret
    80006562:	74a6                	ld	s1,104(sp)
    80006564:	7906                	ld	s2,96(sp)
    80006566:	69e6                	ld	s3,88(sp)
    80006568:	6aa6                	ld	s5,72(sp)
    8000656a:	6b06                	ld	s6,64(sp)
    8000656c:	7be2                	ld	s7,56(sp)
    8000656e:	7c42                	ld	s8,48(sp)
    80006570:	7ca2                	ld	s9,40(sp)
    80006572:	6de2                	ld	s11,24(sp)
    80006574:	bff9                	j	80006552 <printf+0x1d2>
    release(&pr.lock);
    80006576:	00027517          	auipc	a0,0x27
    8000657a:	caa50513          	addi	a0,a0,-854 # 8002d220 <pr>
    8000657e:	00000097          	auipc	ra,0x0
    80006582:	3e4080e7          	jalr	996(ra) # 80006962 <release>
}
    80006586:	bfc1                	j	80006556 <printf+0x1d6>

0000000080006588 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006588:	1101                	addi	sp,sp,-32
    8000658a:	ec06                	sd	ra,24(sp)
    8000658c:	e822                	sd	s0,16(sp)
    8000658e:	e426                	sd	s1,8(sp)
    80006590:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006592:	00027497          	auipc	s1,0x27
    80006596:	c8e48493          	addi	s1,s1,-882 # 8002d220 <pr>
    8000659a:	00002597          	auipc	a1,0x2
    8000659e:	14658593          	addi	a1,a1,326 # 800086e0 <etext+0x6e0>
    800065a2:	8526                	mv	a0,s1
    800065a4:	00000097          	auipc	ra,0x0
    800065a8:	46a080e7          	jalr	1130(ra) # 80006a0e <initlock>
  pr.locking = 1;
    800065ac:	4785                	li	a5,1
    800065ae:	d09c                	sw	a5,32(s1)
}
    800065b0:	60e2                	ld	ra,24(sp)
    800065b2:	6442                	ld	s0,16(sp)
    800065b4:	64a2                	ld	s1,8(sp)
    800065b6:	6105                	addi	sp,sp,32
    800065b8:	8082                	ret

00000000800065ba <uartinit>:

void uartstart();

void
uartinit(void)
{
    800065ba:	1141                	addi	sp,sp,-16
    800065bc:	e406                	sd	ra,8(sp)
    800065be:	e022                	sd	s0,0(sp)
    800065c0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800065c2:	100007b7          	lui	a5,0x10000
    800065c6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800065ca:	10000737          	lui	a4,0x10000
    800065ce:	f8000693          	li	a3,-128
    800065d2:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800065d6:	468d                	li	a3,3
    800065d8:	10000637          	lui	a2,0x10000
    800065dc:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800065e0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800065e4:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800065e8:	10000737          	lui	a4,0x10000
    800065ec:	461d                	li	a2,7
    800065ee:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800065f2:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800065f6:	00002597          	auipc	a1,0x2
    800065fa:	0f258593          	addi	a1,a1,242 # 800086e8 <etext+0x6e8>
    800065fe:	00027517          	auipc	a0,0x27
    80006602:	c4a50513          	addi	a0,a0,-950 # 8002d248 <uart_tx_lock>
    80006606:	00000097          	auipc	ra,0x0
    8000660a:	408080e7          	jalr	1032(ra) # 80006a0e <initlock>
}
    8000660e:	60a2                	ld	ra,8(sp)
    80006610:	6402                	ld	s0,0(sp)
    80006612:	0141                	addi	sp,sp,16
    80006614:	8082                	ret

0000000080006616 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006616:	1101                	addi	sp,sp,-32
    80006618:	ec06                	sd	ra,24(sp)
    8000661a:	e822                	sd	s0,16(sp)
    8000661c:	e426                	sd	s1,8(sp)
    8000661e:	1000                	addi	s0,sp,32
    80006620:	84aa                	mv	s1,a0
  push_off();
    80006622:	00000097          	auipc	ra,0x0
    80006626:	22c080e7          	jalr	556(ra) # 8000684e <push_off>

  if(panicked){
    8000662a:	00006797          	auipc	a5,0x6
    8000662e:	9f27a783          	lw	a5,-1550(a5) # 8000c01c <panicked>
    80006632:	eb85                	bnez	a5,80006662 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006634:	10000737          	lui	a4,0x10000
    80006638:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    8000663a:	00074783          	lbu	a5,0(a4)
    8000663e:	0207f793          	andi	a5,a5,32
    80006642:	dfe5                	beqz	a5,8000663a <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006644:	0ff4f513          	zext.b	a0,s1
    80006648:	100007b7          	lui	a5,0x10000
    8000664c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006650:	00000097          	auipc	ra,0x0
    80006654:	2b2080e7          	jalr	690(ra) # 80006902 <pop_off>
}
    80006658:	60e2                	ld	ra,24(sp)
    8000665a:	6442                	ld	s0,16(sp)
    8000665c:	64a2                	ld	s1,8(sp)
    8000665e:	6105                	addi	sp,sp,32
    80006660:	8082                	ret
    for(;;)
    80006662:	a001                	j	80006662 <uartputc_sync+0x4c>

0000000080006664 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006664:	00006797          	auipc	a5,0x6
    80006668:	9bc7b783          	ld	a5,-1604(a5) # 8000c020 <uart_tx_r>
    8000666c:	00006717          	auipc	a4,0x6
    80006670:	9bc73703          	ld	a4,-1604(a4) # 8000c028 <uart_tx_w>
    80006674:	06f70f63          	beq	a4,a5,800066f2 <uartstart+0x8e>
{
    80006678:	7139                	addi	sp,sp,-64
    8000667a:	fc06                	sd	ra,56(sp)
    8000667c:	f822                	sd	s0,48(sp)
    8000667e:	f426                	sd	s1,40(sp)
    80006680:	f04a                	sd	s2,32(sp)
    80006682:	ec4e                	sd	s3,24(sp)
    80006684:	e852                	sd	s4,16(sp)
    80006686:	e456                	sd	s5,8(sp)
    80006688:	e05a                	sd	s6,0(sp)
    8000668a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000668c:	10000937          	lui	s2,0x10000
    80006690:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006692:	00027a97          	auipc	s5,0x27
    80006696:	bb6a8a93          	addi	s5,s5,-1098 # 8002d248 <uart_tx_lock>
    uart_tx_r += 1;
    8000669a:	00006497          	auipc	s1,0x6
    8000669e:	98648493          	addi	s1,s1,-1658 # 8000c020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800066a2:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800066a6:	00006997          	auipc	s3,0x6
    800066aa:	98298993          	addi	s3,s3,-1662 # 8000c028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800066ae:	00094703          	lbu	a4,0(s2)
    800066b2:	02077713          	andi	a4,a4,32
    800066b6:	c705                	beqz	a4,800066de <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800066b8:	01f7f713          	andi	a4,a5,31
    800066bc:	9756                	add	a4,a4,s5
    800066be:	02074b03          	lbu	s6,32(a4)
    uart_tx_r += 1;
    800066c2:	0785                	addi	a5,a5,1
    800066c4:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800066c6:	8526                	mv	a0,s1
    800066c8:	ffffb097          	auipc	ra,0xffffb
    800066cc:	110080e7          	jalr	272(ra) # 800017d8 <wakeup>
    WriteReg(THR, c);
    800066d0:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800066d4:	609c                	ld	a5,0(s1)
    800066d6:	0009b703          	ld	a4,0(s3)
    800066da:	fcf71ae3          	bne	a4,a5,800066ae <uartstart+0x4a>
  }
}
    800066de:	70e2                	ld	ra,56(sp)
    800066e0:	7442                	ld	s0,48(sp)
    800066e2:	74a2                	ld	s1,40(sp)
    800066e4:	7902                	ld	s2,32(sp)
    800066e6:	69e2                	ld	s3,24(sp)
    800066e8:	6a42                	ld	s4,16(sp)
    800066ea:	6aa2                	ld	s5,8(sp)
    800066ec:	6b02                	ld	s6,0(sp)
    800066ee:	6121                	addi	sp,sp,64
    800066f0:	8082                	ret
    800066f2:	8082                	ret

00000000800066f4 <uartputc>:
{
    800066f4:	7179                	addi	sp,sp,-48
    800066f6:	f406                	sd	ra,40(sp)
    800066f8:	f022                	sd	s0,32(sp)
    800066fa:	e052                	sd	s4,0(sp)
    800066fc:	1800                	addi	s0,sp,48
    800066fe:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006700:	00027517          	auipc	a0,0x27
    80006704:	b4850513          	addi	a0,a0,-1208 # 8002d248 <uart_tx_lock>
    80006708:	00000097          	auipc	ra,0x0
    8000670c:	192080e7          	jalr	402(ra) # 8000689a <acquire>
  if(panicked){
    80006710:	00006797          	auipc	a5,0x6
    80006714:	90c7a783          	lw	a5,-1780(a5) # 8000c01c <panicked>
    80006718:	c391                	beqz	a5,8000671c <uartputc+0x28>
    for(;;)
    8000671a:	a001                	j	8000671a <uartputc+0x26>
    8000671c:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000671e:	00006717          	auipc	a4,0x6
    80006722:	90a73703          	ld	a4,-1782(a4) # 8000c028 <uart_tx_w>
    80006726:	00006797          	auipc	a5,0x6
    8000672a:	8fa7b783          	ld	a5,-1798(a5) # 8000c020 <uart_tx_r>
    8000672e:	02078793          	addi	a5,a5,32
    80006732:	02e79f63          	bne	a5,a4,80006770 <uartputc+0x7c>
    80006736:	e84a                	sd	s2,16(sp)
    80006738:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    8000673a:	00027997          	auipc	s3,0x27
    8000673e:	b0e98993          	addi	s3,s3,-1266 # 8002d248 <uart_tx_lock>
    80006742:	00006497          	auipc	s1,0x6
    80006746:	8de48493          	addi	s1,s1,-1826 # 8000c020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000674a:	00006917          	auipc	s2,0x6
    8000674e:	8de90913          	addi	s2,s2,-1826 # 8000c028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006752:	85ce                	mv	a1,s3
    80006754:	8526                	mv	a0,s1
    80006756:	ffffb097          	auipc	ra,0xffffb
    8000675a:	ef6080e7          	jalr	-266(ra) # 8000164c <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000675e:	00093703          	ld	a4,0(s2)
    80006762:	609c                	ld	a5,0(s1)
    80006764:	02078793          	addi	a5,a5,32
    80006768:	fee785e3          	beq	a5,a4,80006752 <uartputc+0x5e>
    8000676c:	6942                	ld	s2,16(sp)
    8000676e:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006770:	00027497          	auipc	s1,0x27
    80006774:	ad848493          	addi	s1,s1,-1320 # 8002d248 <uart_tx_lock>
    80006778:	01f77793          	andi	a5,a4,31
    8000677c:	97a6                	add	a5,a5,s1
    8000677e:	03478023          	sb	s4,32(a5)
      uart_tx_w += 1;
    80006782:	0705                	addi	a4,a4,1
    80006784:	00006797          	auipc	a5,0x6
    80006788:	8ae7b223          	sd	a4,-1884(a5) # 8000c028 <uart_tx_w>
      uartstart();
    8000678c:	00000097          	auipc	ra,0x0
    80006790:	ed8080e7          	jalr	-296(ra) # 80006664 <uartstart>
      release(&uart_tx_lock);
    80006794:	8526                	mv	a0,s1
    80006796:	00000097          	auipc	ra,0x0
    8000679a:	1cc080e7          	jalr	460(ra) # 80006962 <release>
    8000679e:	64e2                	ld	s1,24(sp)
}
    800067a0:	70a2                	ld	ra,40(sp)
    800067a2:	7402                	ld	s0,32(sp)
    800067a4:	6a02                	ld	s4,0(sp)
    800067a6:	6145                	addi	sp,sp,48
    800067a8:	8082                	ret

00000000800067aa <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800067aa:	1141                	addi	sp,sp,-16
    800067ac:	e422                	sd	s0,8(sp)
    800067ae:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800067b0:	100007b7          	lui	a5,0x10000
    800067b4:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800067b6:	0007c783          	lbu	a5,0(a5)
    800067ba:	8b85                	andi	a5,a5,1
    800067bc:	cb81                	beqz	a5,800067cc <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800067be:	100007b7          	lui	a5,0x10000
    800067c2:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800067c6:	6422                	ld	s0,8(sp)
    800067c8:	0141                	addi	sp,sp,16
    800067ca:	8082                	ret
    return -1;
    800067cc:	557d                	li	a0,-1
    800067ce:	bfe5                	j	800067c6 <uartgetc+0x1c>

00000000800067d0 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800067d0:	1101                	addi	sp,sp,-32
    800067d2:	ec06                	sd	ra,24(sp)
    800067d4:	e822                	sd	s0,16(sp)
    800067d6:	e426                	sd	s1,8(sp)
    800067d8:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800067da:	54fd                	li	s1,-1
    800067dc:	a029                	j	800067e6 <uartintr+0x16>
      break;
    consoleintr(c);
    800067de:	00000097          	auipc	ra,0x0
    800067e2:	8ce080e7          	jalr	-1842(ra) # 800060ac <consoleintr>
    int c = uartgetc();
    800067e6:	00000097          	auipc	ra,0x0
    800067ea:	fc4080e7          	jalr	-60(ra) # 800067aa <uartgetc>
    if(c == -1)
    800067ee:	fe9518e3          	bne	a0,s1,800067de <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800067f2:	00027497          	auipc	s1,0x27
    800067f6:	a5648493          	addi	s1,s1,-1450 # 8002d248 <uart_tx_lock>
    800067fa:	8526                	mv	a0,s1
    800067fc:	00000097          	auipc	ra,0x0
    80006800:	09e080e7          	jalr	158(ra) # 8000689a <acquire>
  uartstart();
    80006804:	00000097          	auipc	ra,0x0
    80006808:	e60080e7          	jalr	-416(ra) # 80006664 <uartstart>
  release(&uart_tx_lock);
    8000680c:	8526                	mv	a0,s1
    8000680e:	00000097          	auipc	ra,0x0
    80006812:	154080e7          	jalr	340(ra) # 80006962 <release>
}
    80006816:	60e2                	ld	ra,24(sp)
    80006818:	6442                	ld	s0,16(sp)
    8000681a:	64a2                	ld	s1,8(sp)
    8000681c:	6105                	addi	sp,sp,32
    8000681e:	8082                	ret

0000000080006820 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006820:	411c                	lw	a5,0(a0)
    80006822:	e399                	bnez	a5,80006828 <holding+0x8>
    80006824:	4501                	li	a0,0
  return r;
}
    80006826:	8082                	ret
{
    80006828:	1101                	addi	sp,sp,-32
    8000682a:	ec06                	sd	ra,24(sp)
    8000682c:	e822                	sd	s0,16(sp)
    8000682e:	e426                	sd	s1,8(sp)
    80006830:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006832:	6904                	ld	s1,16(a0)
    80006834:	ffffa097          	auipc	ra,0xffffa
    80006838:	736080e7          	jalr	1846(ra) # 80000f6a <mycpu>
    8000683c:	40a48533          	sub	a0,s1,a0
    80006840:	00153513          	seqz	a0,a0
}
    80006844:	60e2                	ld	ra,24(sp)
    80006846:	6442                	ld	s0,16(sp)
    80006848:	64a2                	ld	s1,8(sp)
    8000684a:	6105                	addi	sp,sp,32
    8000684c:	8082                	ret

000000008000684e <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000684e:	1101                	addi	sp,sp,-32
    80006850:	ec06                	sd	ra,24(sp)
    80006852:	e822                	sd	s0,16(sp)
    80006854:	e426                	sd	s1,8(sp)
    80006856:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006858:	100024f3          	csrr	s1,sstatus
    8000685c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006860:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006862:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006866:	ffffa097          	auipc	ra,0xffffa
    8000686a:	704080e7          	jalr	1796(ra) # 80000f6a <mycpu>
    8000686e:	5d3c                	lw	a5,120(a0)
    80006870:	cf89                	beqz	a5,8000688a <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006872:	ffffa097          	auipc	ra,0xffffa
    80006876:	6f8080e7          	jalr	1784(ra) # 80000f6a <mycpu>
    8000687a:	5d3c                	lw	a5,120(a0)
    8000687c:	2785                	addiw	a5,a5,1
    8000687e:	dd3c                	sw	a5,120(a0)
}
    80006880:	60e2                	ld	ra,24(sp)
    80006882:	6442                	ld	s0,16(sp)
    80006884:	64a2                	ld	s1,8(sp)
    80006886:	6105                	addi	sp,sp,32
    80006888:	8082                	ret
    mycpu()->intena = old;
    8000688a:	ffffa097          	auipc	ra,0xffffa
    8000688e:	6e0080e7          	jalr	1760(ra) # 80000f6a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006892:	8085                	srli	s1,s1,0x1
    80006894:	8885                	andi	s1,s1,1
    80006896:	dd64                	sw	s1,124(a0)
    80006898:	bfe9                	j	80006872 <push_off+0x24>

000000008000689a <acquire>:
{
    8000689a:	1101                	addi	sp,sp,-32
    8000689c:	ec06                	sd	ra,24(sp)
    8000689e:	e822                	sd	s0,16(sp)
    800068a0:	e426                	sd	s1,8(sp)
    800068a2:	1000                	addi	s0,sp,32
    800068a4:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800068a6:	00000097          	auipc	ra,0x0
    800068aa:	fa8080e7          	jalr	-88(ra) # 8000684e <push_off>
  if(holding(lk))
    800068ae:	8526                	mv	a0,s1
    800068b0:	00000097          	auipc	ra,0x0
    800068b4:	f70080e7          	jalr	-144(ra) # 80006820 <holding>
    800068b8:	e901                	bnez	a0,800068c8 <acquire+0x2e>
    __sync_fetch_and_add(&(lk->n), 1);
    800068ba:	4785                	li	a5,1
    800068bc:	01c48713          	addi	a4,s1,28
    800068c0:	06f7202f          	amoadd.w.aqrl	zero,a5,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    800068c4:	4705                	li	a4,1
    800068c6:	a829                	j	800068e0 <acquire+0x46>
    panic("acquire");
    800068c8:	00002517          	auipc	a0,0x2
    800068cc:	e2850513          	addi	a0,a0,-472 # 800086f0 <etext+0x6f0>
    800068d0:	00000097          	auipc	ra,0x0
    800068d4:	a66080e7          	jalr	-1434(ra) # 80006336 <panic>
    __sync_fetch_and_add(&(lk->nts), 1);
    800068d8:	01848793          	addi	a5,s1,24
    800068dc:	06e7a02f          	amoadd.w.aqrl	zero,a4,(a5)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    800068e0:	87ba                	mv	a5,a4
    800068e2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800068e6:	2781                	sext.w	a5,a5
    800068e8:	fbe5                	bnez	a5,800068d8 <acquire+0x3e>
  __sync_synchronize();
    800068ea:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800068ee:	ffffa097          	auipc	ra,0xffffa
    800068f2:	67c080e7          	jalr	1660(ra) # 80000f6a <mycpu>
    800068f6:	e888                	sd	a0,16(s1)
}
    800068f8:	60e2                	ld	ra,24(sp)
    800068fa:	6442                	ld	s0,16(sp)
    800068fc:	64a2                	ld	s1,8(sp)
    800068fe:	6105                	addi	sp,sp,32
    80006900:	8082                	ret

0000000080006902 <pop_off>:

void
pop_off(void)
{
    80006902:	1141                	addi	sp,sp,-16
    80006904:	e406                	sd	ra,8(sp)
    80006906:	e022                	sd	s0,0(sp)
    80006908:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000690a:	ffffa097          	auipc	ra,0xffffa
    8000690e:	660080e7          	jalr	1632(ra) # 80000f6a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006912:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006916:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006918:	e78d                	bnez	a5,80006942 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000691a:	5d3c                	lw	a5,120(a0)
    8000691c:	02f05b63          	blez	a5,80006952 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006920:	37fd                	addiw	a5,a5,-1
    80006922:	0007871b          	sext.w	a4,a5
    80006926:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006928:	eb09                	bnez	a4,8000693a <pop_off+0x38>
    8000692a:	5d7c                	lw	a5,124(a0)
    8000692c:	c799                	beqz	a5,8000693a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000692e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006932:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006936:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000693a:	60a2                	ld	ra,8(sp)
    8000693c:	6402                	ld	s0,0(sp)
    8000693e:	0141                	addi	sp,sp,16
    80006940:	8082                	ret
    panic("pop_off - interruptible");
    80006942:	00002517          	auipc	a0,0x2
    80006946:	db650513          	addi	a0,a0,-586 # 800086f8 <etext+0x6f8>
    8000694a:	00000097          	auipc	ra,0x0
    8000694e:	9ec080e7          	jalr	-1556(ra) # 80006336 <panic>
    panic("pop_off");
    80006952:	00002517          	auipc	a0,0x2
    80006956:	dbe50513          	addi	a0,a0,-578 # 80008710 <etext+0x710>
    8000695a:	00000097          	auipc	ra,0x0
    8000695e:	9dc080e7          	jalr	-1572(ra) # 80006336 <panic>

0000000080006962 <release>:
{
    80006962:	1101                	addi	sp,sp,-32
    80006964:	ec06                	sd	ra,24(sp)
    80006966:	e822                	sd	s0,16(sp)
    80006968:	e426                	sd	s1,8(sp)
    8000696a:	1000                	addi	s0,sp,32
    8000696c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000696e:	00000097          	auipc	ra,0x0
    80006972:	eb2080e7          	jalr	-334(ra) # 80006820 <holding>
    80006976:	c115                	beqz	a0,8000699a <release+0x38>
  lk->cpu = 0;
    80006978:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000697c:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80006980:	0310000f          	fence	rw,w
    80006984:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006988:	00000097          	auipc	ra,0x0
    8000698c:	f7a080e7          	jalr	-134(ra) # 80006902 <pop_off>
}
    80006990:	60e2                	ld	ra,24(sp)
    80006992:	6442                	ld	s0,16(sp)
    80006994:	64a2                	ld	s1,8(sp)
    80006996:	6105                	addi	sp,sp,32
    80006998:	8082                	ret
    panic("release");
    8000699a:	00002517          	auipc	a0,0x2
    8000699e:	d7e50513          	addi	a0,a0,-642 # 80008718 <etext+0x718>
    800069a2:	00000097          	auipc	ra,0x0
    800069a6:	994080e7          	jalr	-1644(ra) # 80006336 <panic>

00000000800069aa <freelock>:
{
    800069aa:	1101                	addi	sp,sp,-32
    800069ac:	ec06                	sd	ra,24(sp)
    800069ae:	e822                	sd	s0,16(sp)
    800069b0:	e426                	sd	s1,8(sp)
    800069b2:	1000                	addi	s0,sp,32
    800069b4:	84aa                	mv	s1,a0
  acquire(&lock_locks);
    800069b6:	00027517          	auipc	a0,0x27
    800069ba:	8d250513          	addi	a0,a0,-1838 # 8002d288 <lock_locks>
    800069be:	00000097          	auipc	ra,0x0
    800069c2:	edc080e7          	jalr	-292(ra) # 8000689a <acquire>
  for (i = 0; i < NLOCK; i++) {
    800069c6:	00027717          	auipc	a4,0x27
    800069ca:	8e270713          	addi	a4,a4,-1822 # 8002d2a8 <locks>
    800069ce:	4781                	li	a5,0
    800069d0:	1f400613          	li	a2,500
    if(locks[i] == lk) {
    800069d4:	6314                	ld	a3,0(a4)
    800069d6:	00968763          	beq	a3,s1,800069e4 <freelock+0x3a>
  for (i = 0; i < NLOCK; i++) {
    800069da:	2785                	addiw	a5,a5,1
    800069dc:	0721                	addi	a4,a4,8
    800069de:	fec79be3          	bne	a5,a2,800069d4 <freelock+0x2a>
    800069e2:	a809                	j	800069f4 <freelock+0x4a>
      locks[i] = 0;
    800069e4:	078e                	slli	a5,a5,0x3
    800069e6:	00027717          	auipc	a4,0x27
    800069ea:	8c270713          	addi	a4,a4,-1854 # 8002d2a8 <locks>
    800069ee:	97ba                	add	a5,a5,a4
    800069f0:	0007b023          	sd	zero,0(a5)
  release(&lock_locks);
    800069f4:	00027517          	auipc	a0,0x27
    800069f8:	89450513          	addi	a0,a0,-1900 # 8002d288 <lock_locks>
    800069fc:	00000097          	auipc	ra,0x0
    80006a00:	f66080e7          	jalr	-154(ra) # 80006962 <release>
}
    80006a04:	60e2                	ld	ra,24(sp)
    80006a06:	6442                	ld	s0,16(sp)
    80006a08:	64a2                	ld	s1,8(sp)
    80006a0a:	6105                	addi	sp,sp,32
    80006a0c:	8082                	ret

0000000080006a0e <initlock>:
{
    80006a0e:	1101                	addi	sp,sp,-32
    80006a10:	ec06                	sd	ra,24(sp)
    80006a12:	e822                	sd	s0,16(sp)
    80006a14:	e426                	sd	s1,8(sp)
    80006a16:	1000                	addi	s0,sp,32
    80006a18:	84aa                	mv	s1,a0
  lk->name = name;
    80006a1a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006a1c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006a20:	00053823          	sd	zero,16(a0)
  lk->nts = 0;
    80006a24:	00052c23          	sw	zero,24(a0)
  lk->n = 0;
    80006a28:	00052e23          	sw	zero,28(a0)
  acquire(&lock_locks);
    80006a2c:	00027517          	auipc	a0,0x27
    80006a30:	85c50513          	addi	a0,a0,-1956 # 8002d288 <lock_locks>
    80006a34:	00000097          	auipc	ra,0x0
    80006a38:	e66080e7          	jalr	-410(ra) # 8000689a <acquire>
  for (i = 0; i < NLOCK; i++) {
    80006a3c:	00027717          	auipc	a4,0x27
    80006a40:	86c70713          	addi	a4,a4,-1940 # 8002d2a8 <locks>
    80006a44:	4781                	li	a5,0
    80006a46:	1f400613          	li	a2,500
    if(locks[i] == 0) {
    80006a4a:	6314                	ld	a3,0(a4)
    80006a4c:	ce89                	beqz	a3,80006a66 <initlock+0x58>
  for (i = 0; i < NLOCK; i++) {
    80006a4e:	2785                	addiw	a5,a5,1
    80006a50:	0721                	addi	a4,a4,8
    80006a52:	fec79ce3          	bne	a5,a2,80006a4a <initlock+0x3c>
  panic("findslot");
    80006a56:	00002517          	auipc	a0,0x2
    80006a5a:	cca50513          	addi	a0,a0,-822 # 80008720 <etext+0x720>
    80006a5e:	00000097          	auipc	ra,0x0
    80006a62:	8d8080e7          	jalr	-1832(ra) # 80006336 <panic>
      locks[i] = lk;
    80006a66:	078e                	slli	a5,a5,0x3
    80006a68:	00027717          	auipc	a4,0x27
    80006a6c:	84070713          	addi	a4,a4,-1984 # 8002d2a8 <locks>
    80006a70:	97ba                	add	a5,a5,a4
    80006a72:	e384                	sd	s1,0(a5)
      release(&lock_locks);
    80006a74:	00027517          	auipc	a0,0x27
    80006a78:	81450513          	addi	a0,a0,-2028 # 8002d288 <lock_locks>
    80006a7c:	00000097          	auipc	ra,0x0
    80006a80:	ee6080e7          	jalr	-282(ra) # 80006962 <release>
}
    80006a84:	60e2                	ld	ra,24(sp)
    80006a86:	6442                	ld	s0,16(sp)
    80006a88:	64a2                	ld	s1,8(sp)
    80006a8a:	6105                	addi	sp,sp,32
    80006a8c:	8082                	ret

0000000080006a8e <lockfree_read8>:

// Read a shared 64-bit value without holding a lock
uint64
lockfree_read8(uint64 *addr) {
    80006a8e:	1141                	addi	sp,sp,-16
    80006a90:	e422                	sd	s0,8(sp)
    80006a92:	0800                	addi	s0,sp,16
  uint64 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80006a94:	0330000f          	fence	rw,rw
    80006a98:	6108                	ld	a0,0(a0)
    80006a9a:	0230000f          	fence	r,rw
  return val;
}
    80006a9e:	6422                	ld	s0,8(sp)
    80006aa0:	0141                	addi	sp,sp,16
    80006aa2:	8082                	ret

0000000080006aa4 <lockfree_read4>:

// Read a shared 32-bit value without holding a lock
int
lockfree_read4(int *addr) {
    80006aa4:	1141                	addi	sp,sp,-16
    80006aa6:	e422                	sd	s0,8(sp)
    80006aa8:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80006aaa:	0330000f          	fence	rw,rw
    80006aae:	4108                	lw	a0,0(a0)
    80006ab0:	0230000f          	fence	r,rw
  return val;
}
    80006ab4:	2501                	sext.w	a0,a0
    80006ab6:	6422                	ld	s0,8(sp)
    80006ab8:	0141                	addi	sp,sp,16
    80006aba:	8082                	ret

0000000080006abc <snprint_lock>:
#ifdef LAB_LOCK
int
snprint_lock(char *buf, int sz, struct spinlock *lk)
{
  int n = 0;
  if(lk->n > 0) {
    80006abc:	4e5c                	lw	a5,28(a2)
    80006abe:	00f04463          	bgtz	a5,80006ac6 <snprint_lock+0xa>
  int n = 0;
    80006ac2:	4501                	li	a0,0
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
                 lk->name, lk->nts, lk->n);
  }
  return n;
}
    80006ac4:	8082                	ret
{
    80006ac6:	1141                	addi	sp,sp,-16
    80006ac8:	e406                	sd	ra,8(sp)
    80006aca:	e022                	sd	s0,0(sp)
    80006acc:	0800                	addi	s0,sp,16
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
    80006ace:	4e18                	lw	a4,24(a2)
    80006ad0:	6614                	ld	a3,8(a2)
    80006ad2:	00002617          	auipc	a2,0x2
    80006ad6:	c5e60613          	addi	a2,a2,-930 # 80008730 <etext+0x730>
    80006ada:	fffff097          	auipc	ra,0xfffff
    80006ade:	166080e7          	jalr	358(ra) # 80005c40 <snprintf>
}
    80006ae2:	60a2                	ld	ra,8(sp)
    80006ae4:	6402                	ld	s0,0(sp)
    80006ae6:	0141                	addi	sp,sp,16
    80006ae8:	8082                	ret

0000000080006aea <statslock>:

int
statslock(char *buf, int sz) {
    80006aea:	7159                	addi	sp,sp,-112
    80006aec:	f486                	sd	ra,104(sp)
    80006aee:	f0a2                	sd	s0,96(sp)
    80006af0:	eca6                	sd	s1,88(sp)
    80006af2:	e8ca                	sd	s2,80(sp)
    80006af4:	e4ce                	sd	s3,72(sp)
    80006af6:	e0d2                	sd	s4,64(sp)
    80006af8:	fc56                	sd	s5,56(sp)
    80006afa:	f85a                	sd	s6,48(sp)
    80006afc:	f45e                	sd	s7,40(sp)
    80006afe:	f062                	sd	s8,32(sp)
    80006b00:	ec66                	sd	s9,24(sp)
    80006b02:	e86a                	sd	s10,16(sp)
    80006b04:	e46e                	sd	s11,8(sp)
    80006b06:	1880                	addi	s0,sp,112
    80006b08:	8aaa                	mv	s5,a0
    80006b0a:	8b2e                	mv	s6,a1
  int n;
  int tot = 0;

  acquire(&lock_locks);
    80006b0c:	00026517          	auipc	a0,0x26
    80006b10:	77c50513          	addi	a0,a0,1916 # 8002d288 <lock_locks>
    80006b14:	00000097          	auipc	ra,0x0
    80006b18:	d86080e7          	jalr	-634(ra) # 8000689a <acquire>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    80006b1c:	00002617          	auipc	a2,0x2
    80006b20:	c4460613          	addi	a2,a2,-956 # 80008760 <etext+0x760>
    80006b24:	85da                	mv	a1,s6
    80006b26:	8556                	mv	a0,s5
    80006b28:	fffff097          	auipc	ra,0xfffff
    80006b2c:	118080e7          	jalr	280(ra) # 80005c40 <snprintf>
    80006b30:	892a                	mv	s2,a0
  for(int i = 0; i < NLOCK; i++) {
    80006b32:	00026c97          	auipc	s9,0x26
    80006b36:	776c8c93          	addi	s9,s9,1910 # 8002d2a8 <locks>
    80006b3a:	00027c17          	auipc	s8,0x27
    80006b3e:	70ec0c13          	addi	s8,s8,1806 # 8002e248 <end>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    80006b42:	84e6                	mv	s1,s9
  int tot = 0;
    80006b44:	4a01                	li	s4,0
    if(locks[i] == 0)
      break;
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006b46:	00002b97          	auipc	s7,0x2
    80006b4a:	c3ab8b93          	addi	s7,s7,-966 # 80008780 <etext+0x780>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80006b4e:	00001d17          	auipc	s10,0x1
    80006b52:	4c2d0d13          	addi	s10,s10,1218 # 80008010 <etext+0x10>
    80006b56:	a01d                	j	80006b7c <statslock+0x92>
      tot += locks[i]->nts;
    80006b58:	0009b603          	ld	a2,0(s3)
    80006b5c:	4e1c                	lw	a5,24(a2)
    80006b5e:	01478a3b          	addw	s4,a5,s4
      n += snprint_lock(buf +n, sz-n, locks[i]);
    80006b62:	412b05bb          	subw	a1,s6,s2
    80006b66:	012a8533          	add	a0,s5,s2
    80006b6a:	00000097          	auipc	ra,0x0
    80006b6e:	f52080e7          	jalr	-174(ra) # 80006abc <snprint_lock>
    80006b72:	0125093b          	addw	s2,a0,s2
  for(int i = 0; i < NLOCK; i++) {
    80006b76:	04a1                	addi	s1,s1,8
    80006b78:	05848763          	beq	s1,s8,80006bc6 <statslock+0xdc>
    if(locks[i] == 0)
    80006b7c:	89a6                	mv	s3,s1
    80006b7e:	609c                	ld	a5,0(s1)
    80006b80:	c3b9                	beqz	a5,80006bc6 <statslock+0xdc>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006b82:	0087bd83          	ld	s11,8(a5)
    80006b86:	855e                	mv	a0,s7
    80006b88:	ffffa097          	auipc	ra,0xffffa
    80006b8c:	860080e7          	jalr	-1952(ra) # 800003e8 <strlen>
    80006b90:	0005061b          	sext.w	a2,a0
    80006b94:	85de                	mv	a1,s7
    80006b96:	856e                	mv	a0,s11
    80006b98:	ffff9097          	auipc	ra,0xffff9
    80006b9c:	7ac080e7          	jalr	1964(ra) # 80000344 <strncmp>
    80006ba0:	dd45                	beqz	a0,80006b58 <statslock+0x6e>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80006ba2:	609c                	ld	a5,0(s1)
    80006ba4:	0087bd83          	ld	s11,8(a5)
    80006ba8:	856a                	mv	a0,s10
    80006baa:	ffffa097          	auipc	ra,0xffffa
    80006bae:	83e080e7          	jalr	-1986(ra) # 800003e8 <strlen>
    80006bb2:	0005061b          	sext.w	a2,a0
    80006bb6:	85ea                	mv	a1,s10
    80006bb8:	856e                	mv	a0,s11
    80006bba:	ffff9097          	auipc	ra,0xffff9
    80006bbe:	78a080e7          	jalr	1930(ra) # 80000344 <strncmp>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006bc2:	f955                	bnez	a0,80006b76 <statslock+0x8c>
    80006bc4:	bf51                	j	80006b58 <statslock+0x6e>
    }
  }
  
  n += snprintf(buf+n, sz-n, "--- top 5 contended locks:\n");
    80006bc6:	00002617          	auipc	a2,0x2
    80006bca:	bc260613          	addi	a2,a2,-1086 # 80008788 <etext+0x788>
    80006bce:	412b05bb          	subw	a1,s6,s2
    80006bd2:	012a8533          	add	a0,s5,s2
    80006bd6:	fffff097          	auipc	ra,0xfffff
    80006bda:	06a080e7          	jalr	106(ra) # 80005c40 <snprintf>
    80006bde:	012509bb          	addw	s3,a0,s2
    80006be2:	4b95                	li	s7,5
  int last = 100000000;
    80006be4:	05f5e537          	lui	a0,0x5f5e
    80006be8:	10050513          	addi	a0,a0,256 # 5f5e100 <_entry-0x7a0a1f00>
  // stupid way to compute top 5 contended locks
  for(int t = 0; t < 5; t++) {
    int top = 0;
    for(int i = 0; i < NLOCK; i++) {
    80006bec:	4c01                	li	s8,0
      if(locks[i] == 0)
        break;
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006bee:	00026497          	auipc	s1,0x26
    80006bf2:	6ba48493          	addi	s1,s1,1722 # 8002d2a8 <locks>
    for(int i = 0; i < NLOCK; i++) {
    80006bf6:	1f400913          	li	s2,500
    80006bfa:	a891                	j	80006c4e <statslock+0x164>
    80006bfc:	2705                	addiw	a4,a4,1
    80006bfe:	06a1                	addi	a3,a3,8
    80006c00:	03270063          	beq	a4,s2,80006c20 <statslock+0x136>
      if(locks[i] == 0)
    80006c04:	629c                	ld	a5,0(a3)
    80006c06:	cf89                	beqz	a5,80006c20 <statslock+0x136>
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006c08:	4f90                	lw	a2,24(a5)
    80006c0a:	00359793          	slli	a5,a1,0x3
    80006c0e:	97a6                	add	a5,a5,s1
    80006c10:	639c                	ld	a5,0(a5)
    80006c12:	4f9c                	lw	a5,24(a5)
    80006c14:	fec7d4e3          	bge	a5,a2,80006bfc <statslock+0x112>
    80006c18:	fea652e3          	bge	a2,a0,80006bfc <statslock+0x112>
        top = i;
    80006c1c:	85ba                	mv	a1,a4
    80006c1e:	bff9                	j	80006bfc <statslock+0x112>
      }
    }
    n += snprint_lock(buf+n, sz-n, locks[top]);
    80006c20:	058e                	slli	a1,a1,0x3
    80006c22:	00b48d33          	add	s10,s1,a1
    80006c26:	000d3603          	ld	a2,0(s10)
    80006c2a:	413b05bb          	subw	a1,s6,s3
    80006c2e:	013a8533          	add	a0,s5,s3
    80006c32:	00000097          	auipc	ra,0x0
    80006c36:	e8a080e7          	jalr	-374(ra) # 80006abc <snprint_lock>
    80006c3a:	01350dbb          	addw	s11,a0,s3
    80006c3e:	000d899b          	sext.w	s3,s11
    last = locks[top]->nts;
    80006c42:	000d3783          	ld	a5,0(s10)
    80006c46:	4f88                	lw	a0,24(a5)
  for(int t = 0; t < 5; t++) {
    80006c48:	3bfd                	addiw	s7,s7,-1
    80006c4a:	000b8663          	beqz	s7,80006c56 <statslock+0x16c>
  int tot = 0;
    80006c4e:	86e6                	mv	a3,s9
    for(int i = 0; i < NLOCK; i++) {
    80006c50:	8762                	mv	a4,s8
    int top = 0;
    80006c52:	85e2                	mv	a1,s8
    80006c54:	bf45                	j	80006c04 <statslock+0x11a>
  }
  n += snprintf(buf+n, sz-n, "tot= %d\n", tot);
    80006c56:	86d2                	mv	a3,s4
    80006c58:	00002617          	auipc	a2,0x2
    80006c5c:	b5060613          	addi	a2,a2,-1200 # 800087a8 <etext+0x7a8>
    80006c60:	41bb05bb          	subw	a1,s6,s11
    80006c64:	013a8533          	add	a0,s5,s3
    80006c68:	fffff097          	auipc	ra,0xfffff
    80006c6c:	fd8080e7          	jalr	-40(ra) # 80005c40 <snprintf>
    80006c70:	00ad8dbb          	addw	s11,s11,a0
  release(&lock_locks);  
    80006c74:	00026517          	auipc	a0,0x26
    80006c78:	61450513          	addi	a0,a0,1556 # 8002d288 <lock_locks>
    80006c7c:	00000097          	auipc	ra,0x0
    80006c80:	ce6080e7          	jalr	-794(ra) # 80006962 <release>
  return n;
}
    80006c84:	856e                	mv	a0,s11
    80006c86:	70a6                	ld	ra,104(sp)
    80006c88:	7406                	ld	s0,96(sp)
    80006c8a:	64e6                	ld	s1,88(sp)
    80006c8c:	6946                	ld	s2,80(sp)
    80006c8e:	69a6                	ld	s3,72(sp)
    80006c90:	6a06                	ld	s4,64(sp)
    80006c92:	7ae2                	ld	s5,56(sp)
    80006c94:	7b42                	ld	s6,48(sp)
    80006c96:	7ba2                	ld	s7,40(sp)
    80006c98:	7c02                	ld	s8,32(sp)
    80006c9a:	6ce2                	ld	s9,24(sp)
    80006c9c:	6d42                	ld	s10,16(sp)
    80006c9e:	6da2                	ld	s11,8(sp)
    80006ca0:	6165                	addi	sp,sp,112
    80006ca2:	8082                	ret
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
