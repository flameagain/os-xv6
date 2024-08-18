
user/_nettests：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <decode_qname>:

// Decode a DNS name
static void
decode_qname(char *qn, int max)
{
  char *qnMax = qn + max;
       0:	95aa                	add	a1,a1,a0
      break;
    for(int i = 0; i < l; i++) {
      *qn = *(qn+1);
      qn++;
    }
    *qn++ = '.';
       2:	02e00813          	li	a6,46
    if(qn >= qnMax){
       6:	02b56a63          	bltu	a0,a1,3a <decode_qname+0x3a>
{
       a:	1141                	addi	sp,sp,-16
       c:	e406                	sd	ra,8(sp)
       e:	e022                	sd	s0,0(sp)
      10:	0800                	addi	s0,sp,16
      printf("invalid DNS reply\n");
      12:	00001517          	auipc	a0,0x1
      16:	08e50513          	addi	a0,a0,142 # 10a0 <malloc+0x104>
      1a:	00001097          	auipc	ra,0x1
      1e:	eca080e7          	jalr	-310(ra) # ee4 <printf>
      exit(1);
      22:	4505                	li	a0,1
      24:	00001097          	auipc	ra,0x1
      28:	b48080e7          	jalr	-1208(ra) # b6c <exit>
    *qn++ = '.';
      2c:	00160793          	addi	a5,a2,1
      30:	953e                	add	a0,a0,a5
      32:	01068023          	sb	a6,0(a3)
    if(qn >= qnMax){
      36:	fcb57ae3          	bgeu	a0,a1,a <decode_qname+0xa>
    int l = *qn;
      3a:	00054683          	lbu	a3,0(a0)
    if(l == 0)
      3e:	ce89                	beqz	a3,58 <decode_qname+0x58>
    for(int i = 0; i < l; i++) {
      40:	0006861b          	sext.w	a2,a3
      44:	96aa                	add	a3,a3,a0
    if(l == 0)
      46:	87aa                	mv	a5,a0
      *qn = *(qn+1);
      48:	0017c703          	lbu	a4,1(a5)
      4c:	00e78023          	sb	a4,0(a5)
      qn++;
      50:	0785                	addi	a5,a5,1
    for(int i = 0; i < l; i++) {
      52:	fed79be3          	bne	a5,a3,48 <decode_qname+0x48>
      56:	bfd9                	j	2c <decode_qname+0x2c>
      58:	8082                	ret

000000000000005a <ping>:
{
      5a:	7171                	addi	sp,sp,-176
      5c:	f506                	sd	ra,168(sp)
      5e:	f122                	sd	s0,160(sp)
      60:	ed26                	sd	s1,152(sp)
      62:	e94a                	sd	s2,144(sp)
      64:	e54e                	sd	s3,136(sp)
      66:	e152                	sd	s4,128(sp)
      68:	1900                	addi	s0,sp,176
      6a:	8a32                	mv	s4,a2
  if((fd = connect(dst, sport, dport)) < 0){
      6c:	862e                	mv	a2,a1
      6e:	85aa                	mv	a1,a0
      70:	0a000537          	lui	a0,0xa000
      74:	20250513          	addi	a0,a0,514 # a000202 <__global_pointer$+0x9ffe13e>
      78:	00001097          	auipc	ra,0x1
      7c:	b94080e7          	jalr	-1132(ra) # c0c <connect>
      80:	08054663          	bltz	a0,10c <ping+0xb2>
      84:	89aa                	mv	s3,a0
  for(int i = 0; i < attempts; i++) {
      86:	4481                	li	s1,0
    if(write(fd, obuf, strlen(obuf)) < 0){
      88:	00001917          	auipc	s2,0x1
      8c:	04890913          	addi	s2,s2,72 # 10d0 <malloc+0x134>
  for(int i = 0; i < attempts; i++) {
      90:	03405463          	blez	s4,b8 <ping+0x5e>
    if(write(fd, obuf, strlen(obuf)) < 0){
      94:	854a                	mv	a0,s2
      96:	00001097          	auipc	ra,0x1
      9a:	8b2080e7          	jalr	-1870(ra) # 948 <strlen>
      9e:	0005061b          	sext.w	a2,a0
      a2:	85ca                	mv	a1,s2
      a4:	854e                	mv	a0,s3
      a6:	00001097          	auipc	ra,0x1
      aa:	ae6080e7          	jalr	-1306(ra) # b8c <write>
      ae:	06054d63          	bltz	a0,128 <ping+0xce>
  for(int i = 0; i < attempts; i++) {
      b2:	2485                	addiw	s1,s1,1
      b4:	fe9a10e3          	bne	s4,s1,94 <ping+0x3a>
  int cc = read(fd, ibuf, sizeof(ibuf)-1);
      b8:	07f00613          	li	a2,127
      bc:	f5040593          	addi	a1,s0,-176
      c0:	854e                	mv	a0,s3
      c2:	00001097          	auipc	ra,0x1
      c6:	ac2080e7          	jalr	-1342(ra) # b84 <read>
      ca:	84aa                	mv	s1,a0
  if(cc < 0){
      cc:	06054c63          	bltz	a0,144 <ping+0xea>
  close(fd);
      d0:	854e                	mv	a0,s3
      d2:	00001097          	auipc	ra,0x1
      d6:	ac2080e7          	jalr	-1342(ra) # b94 <close>
  ibuf[cc] = '\0';
      da:	fd048793          	addi	a5,s1,-48
      de:	008784b3          	add	s1,a5,s0
      e2:	f8048023          	sb	zero,-128(s1)
  if(strcmp(ibuf, "this is the host!") != 0){
      e6:	00001597          	auipc	a1,0x1
      ea:	03258593          	addi	a1,a1,50 # 1118 <malloc+0x17c>
      ee:	f5040513          	addi	a0,s0,-176
      f2:	00001097          	auipc	ra,0x1
      f6:	82a080e7          	jalr	-2006(ra) # 91c <strcmp>
      fa:	e13d                	bnez	a0,160 <ping+0x106>
}
      fc:	70aa                	ld	ra,168(sp)
      fe:	740a                	ld	s0,160(sp)
     100:	64ea                	ld	s1,152(sp)
     102:	694a                	ld	s2,144(sp)
     104:	69aa                	ld	s3,136(sp)
     106:	6a0a                	ld	s4,128(sp)
     108:	614d                	addi	sp,sp,176
     10a:	8082                	ret
    fprintf(2, "ping: connect() failed\n");
     10c:	00001597          	auipc	a1,0x1
     110:	fac58593          	addi	a1,a1,-84 # 10b8 <malloc+0x11c>
     114:	4509                	li	a0,2
     116:	00001097          	auipc	ra,0x1
     11a:	da0080e7          	jalr	-608(ra) # eb6 <fprintf>
    exit(1);
     11e:	4505                	li	a0,1
     120:	00001097          	auipc	ra,0x1
     124:	a4c080e7          	jalr	-1460(ra) # b6c <exit>
      fprintf(2, "ping: send() failed\n");
     128:	00001597          	auipc	a1,0x1
     12c:	fc058593          	addi	a1,a1,-64 # 10e8 <malloc+0x14c>
     130:	4509                	li	a0,2
     132:	00001097          	auipc	ra,0x1
     136:	d84080e7          	jalr	-636(ra) # eb6 <fprintf>
      exit(1);
     13a:	4505                	li	a0,1
     13c:	00001097          	auipc	ra,0x1
     140:	a30080e7          	jalr	-1488(ra) # b6c <exit>
    fprintf(2, "ping: recv() failed\n");
     144:	00001597          	auipc	a1,0x1
     148:	fbc58593          	addi	a1,a1,-68 # 1100 <malloc+0x164>
     14c:	4509                	li	a0,2
     14e:	00001097          	auipc	ra,0x1
     152:	d68080e7          	jalr	-664(ra) # eb6 <fprintf>
    exit(1);
     156:	4505                	li	a0,1
     158:	00001097          	auipc	ra,0x1
     15c:	a14080e7          	jalr	-1516(ra) # b6c <exit>
    fprintf(2, "ping didn't receive correct payload\n");
     160:	00001597          	auipc	a1,0x1
     164:	fd058593          	addi	a1,a1,-48 # 1130 <malloc+0x194>
     168:	4509                	li	a0,2
     16a:	00001097          	auipc	ra,0x1
     16e:	d4c080e7          	jalr	-692(ra) # eb6 <fprintf>
    exit(1);
     172:	4505                	li	a0,1
     174:	00001097          	auipc	ra,0x1
     178:	9f8080e7          	jalr	-1544(ra) # b6c <exit>

000000000000017c <dns>:
  }
}

static void
dns()
{
     17c:	7159                	addi	sp,sp,-112
     17e:	f486                	sd	ra,104(sp)
     180:	f0a2                	sd	s0,96(sp)
     182:	eca6                	sd	s1,88(sp)
     184:	e8ca                	sd	s2,80(sp)
     186:	e4ce                	sd	s3,72(sp)
     188:	e0d2                	sd	s4,64(sp)
     18a:	fc56                	sd	s5,56(sp)
     18c:	f85a                	sd	s6,48(sp)
     18e:	f45e                	sd	s7,40(sp)
     190:	f062                	sd	s8,32(sp)
     192:	1880                	addi	s0,sp,112
     194:	82010113          	addi	sp,sp,-2016
  uint8 ibuf[N];
  uint32 dst;
  int fd;
  int len;

  memset(obuf, 0, N);
     198:	3e800613          	li	a2,1000
     19c:	4581                	li	a1,0
     19e:	ba840513          	addi	a0,s0,-1112
     1a2:	00000097          	auipc	ra,0x0
     1a6:	7d0080e7          	jalr	2000(ra) # 972 <memset>
  memset(ibuf, 0, N);
     1aa:	3e800613          	li	a2,1000
     1ae:	4581                	li	a1,0
     1b0:	77fd                	lui	a5,0xfffff
     1b2:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffd6fc>
     1b6:	00f40533          	add	a0,s0,a5
     1ba:	00000097          	auipc	ra,0x0
     1be:	7b8080e7          	jalr	1976(ra) # 972 <memset>
  
  // 8.8.8.8: google's name server
  dst = (8 << 24) | (8 << 16) | (8 << 8) | (8 << 0);

  if((fd = connect(dst, 10000, 53)) < 0){
     1c2:	03500613          	li	a2,53
     1c6:	6589                	lui	a1,0x2
     1c8:	71058593          	addi	a1,a1,1808 # 2710 <__global_pointer$+0x64c>
     1cc:	08081537          	lui	a0,0x8081
     1d0:	80850513          	addi	a0,a0,-2040 # 8080808 <__global_pointer$+0x807e744>
     1d4:	00001097          	auipc	ra,0x1
     1d8:	a38080e7          	jalr	-1480(ra) # c0c <connect>
     1dc:	777d                	lui	a4,0xfffff
     1de:	7b070713          	addi	a4,a4,1968 # fffffffffffff7b0 <__global_pointer$+0xffffffffffffd6ec>
     1e2:	9722                	add	a4,a4,s0
     1e4:	e308                	sd	a0,0(a4)
     1e6:	02054c63          	bltz	a0,21e <dns+0xa2>
  hdr->id = htons(6828);
     1ea:	77ed                	lui	a5,0xffffb
     1ec:	c1a78793          	addi	a5,a5,-998 # ffffffffffffac1a <__global_pointer$+0xffffffffffff8b56>
     1f0:	baf41423          	sh	a5,-1112(s0)
  hdr->rd = 1;
     1f4:	baa45783          	lhu	a5,-1110(s0)
     1f8:	0017e793          	ori	a5,a5,1
     1fc:	baf41523          	sh	a5,-1110(s0)
  hdr->qdcount = htons(1);
     200:	10000793          	li	a5,256
     204:	baf41623          	sh	a5,-1108(s0)
  for(char *c = host; c < host+strlen(host)+1; c++) {
     208:	00001497          	auipc	s1,0x1
     20c:	f5048493          	addi	s1,s1,-176 # 1158 <malloc+0x1bc>
  char *l = host; 
     210:	8a26                	mv	s4,s1
  for(char *c = host; c < host+strlen(host)+1; c++) {
     212:	bb440a93          	addi	s5,s0,-1100
     216:	8926                	mv	s2,s1
    if(*c == '.') {
     218:	02e00993          	li	s3,46
  for(char *c = host; c < host+strlen(host)+1; c++) {
     21c:	a099                	j	262 <dns+0xe6>
     21e:	7f913c23          	sd	s9,2040(sp)
     222:	7fa13823          	sd	s10,2032(sp)
     226:	7fb13423          	sd	s11,2024(sp)
    fprintf(2, "ping: connect() failed\n");
     22a:	00001597          	auipc	a1,0x1
     22e:	e8e58593          	addi	a1,a1,-370 # 10b8 <malloc+0x11c>
     232:	4509                	li	a0,2
     234:	00001097          	auipc	ra,0x1
     238:	c82080e7          	jalr	-894(ra) # eb6 <fprintf>
    exit(1);
     23c:	4505                	li	a0,1
     23e:	00001097          	auipc	ra,0x1
     242:	92e080e7          	jalr	-1746(ra) # b6c <exit>
        *qn++ = *d;
     246:	0705                	addi	a4,a4,1
     248:	0007c683          	lbu	a3,0(a5)
     24c:	fed70fa3          	sb	a3,-1(a4)
      for(char *d = l; d < c; d++) {
     250:	0785                	addi	a5,a5,1
     252:	fef49ae3          	bne	s1,a5,246 <dns+0xca>
     256:	41448ab3          	sub	s5,s1,s4
     25a:	9ab2                	add	s5,s5,a2
      l = c+1; // skip .
     25c:	00148a13          	addi	s4,s1,1
  for(char *c = host; c < host+strlen(host)+1; c++) {
     260:	0485                	addi	s1,s1,1
     262:	854a                	mv	a0,s2
     264:	00000097          	auipc	ra,0x0
     268:	6e4080e7          	jalr	1764(ra) # 948 <strlen>
     26c:	02051793          	slli	a5,a0,0x20
     270:	9381                	srli	a5,a5,0x20
     272:	0785                	addi	a5,a5,1
     274:	97ca                	add	a5,a5,s2
     276:	02f4f363          	bgeu	s1,a5,29c <dns+0x120>
    if(*c == '.') {
     27a:	0004c783          	lbu	a5,0(s1)
     27e:	ff3791e3          	bne	a5,s3,260 <dns+0xe4>
      *qn++ = (char) (c-l);
     282:	001a8613          	addi	a2,s5,1
     286:	414487b3          	sub	a5,s1,s4
     28a:	00fa8023          	sb	a5,0(s5)
      for(char *d = l; d < c; d++) {
     28e:	009a7563          	bgeu	s4,s1,298 <dns+0x11c>
     292:	87d2                	mv	a5,s4
      *qn++ = (char) (c-l);
     294:	8732                	mv	a4,a2
     296:	bf45                	j	246 <dns+0xca>
     298:	8ab2                	mv	s5,a2
     29a:	b7c9                	j	25c <dns+0xe0>
  *qn = '\0';
     29c:	000a8023          	sb	zero,0(s5)
  len += strlen(qname) + 1;
     2a0:	bb440513          	addi	a0,s0,-1100
     2a4:	00000097          	auipc	ra,0x0
     2a8:	6a4080e7          	jalr	1700(ra) # 948 <strlen>
     2ac:	0005049b          	sext.w	s1,a0
  struct dns_question *h = (struct dns_question *) (qname+strlen(qname)+1);
     2b0:	bb440513          	addi	a0,s0,-1100
     2b4:	00000097          	auipc	ra,0x0
     2b8:	694080e7          	jalr	1684(ra) # 948 <strlen>
     2bc:	02051793          	slli	a5,a0,0x20
     2c0:	9381                	srli	a5,a5,0x20
     2c2:	0785                	addi	a5,a5,1
     2c4:	bb440713          	addi	a4,s0,-1100
     2c8:	97ba                	add	a5,a5,a4
  h->qtype = htons(0x1);
     2ca:	00078023          	sb	zero,0(a5)
     2ce:	4705                	li	a4,1
     2d0:	00e780a3          	sb	a4,1(a5)
  h->qclass = htons(0x1);
     2d4:	00078123          	sb	zero,2(a5)
     2d8:	00e781a3          	sb	a4,3(a5)
  }

  len = dns_req(obuf);
  
  if(write(fd, obuf, len) < 0){
     2dc:	0114861b          	addiw	a2,s1,17
     2e0:	ba840593          	addi	a1,s0,-1112
     2e4:	77fd                	lui	a5,0xfffff
     2e6:	7b078793          	addi	a5,a5,1968 # fffffffffffff7b0 <__global_pointer$+0xffffffffffffd6ec>
     2ea:	97a2                	add	a5,a5,s0
     2ec:	6388                	ld	a0,0(a5)
     2ee:	00001097          	auipc	ra,0x1
     2f2:	89e080e7          	jalr	-1890(ra) # b8c <write>
     2f6:	12054063          	bltz	a0,416 <dns+0x29a>
    fprintf(2, "dns: send() failed\n");
    exit(1);
  }
  int cc = read(fd, ibuf, sizeof(ibuf));
     2fa:	3e800613          	li	a2,1000
     2fe:	77fd                	lui	a5,0xfffff
     300:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffd6fc>
     304:	00f405b3          	add	a1,s0,a5
     308:	77fd                	lui	a5,0xfffff
     30a:	7b078793          	addi	a5,a5,1968 # fffffffffffff7b0 <__global_pointer$+0xffffffffffffd6ec>
     30e:	97a2                	add	a5,a5,s0
     310:	6388                	ld	a0,0(a5)
     312:	00001097          	auipc	ra,0x1
     316:	872080e7          	jalr	-1934(ra) # b84 <read>
     31a:	8a2a                	mv	s4,a0
  if(cc < 0){
     31c:	12054163          	bltz	a0,43e <dns+0x2c2>
  if(cc < sizeof(struct dns)){
     320:	0005079b          	sext.w	a5,a0
     324:	472d                	li	a4,11
     326:	14f77063          	bgeu	a4,a5,466 <dns+0x2ea>
  if(!hdr->qr) {
     32a:	77fd                	lui	a5,0xfffff
     32c:	7c278793          	addi	a5,a5,1986 # fffffffffffff7c2 <__global_pointer$+0xffffffffffffd6fe>
     330:	97a2                	add	a5,a5,s0
     332:	00078783          	lb	a5,0(a5)
     336:	1407db63          	bgez	a5,48c <dns+0x310>
  if(hdr->id != htons(6828)){
     33a:	77fd                	lui	a5,0xfffff
     33c:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffd6fc>
     340:	97a2                	add	a5,a5,s0
     342:	0007d703          	lhu	a4,0(a5)
     346:	0007069b          	sext.w	a3,a4
     34a:	67ad                	lui	a5,0xb
     34c:	c1a78793          	addi	a5,a5,-998 # ac1a <__global_pointer$+0x8b56>
     350:	16f69e63          	bne	a3,a5,4cc <dns+0x350>
  if(hdr->rcode != 0) {
     354:	777d                	lui	a4,0xfffff
     356:	7c370793          	addi	a5,a4,1987 # fffffffffffff7c3 <__global_pointer$+0xffffffffffffd6ff>
     35a:	97a2                	add	a5,a5,s0
     35c:	0007c783          	lbu	a5,0(a5)
     360:	8bbd                	andi	a5,a5,15
     362:	18079f63          	bnez	a5,500 <dns+0x384>
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
     366:	7c470793          	addi	a5,a4,1988
     36a:	97a2                	add	a5,a5,s0
     36c:	0007d783          	lhu	a5,0(a5)
     370:	4981                	li	s3,0
  len = sizeof(struct dns);
     372:	44b1                	li	s1,12
  char *qname = 0;
     374:	4901                	li	s2,0
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
     376:	c3b9                	beqz	a5,3bc <dns+0x240>
    char *qn = (char *) (ibuf+len);
     378:	7afd                	lui	s5,0xfffff
     37a:	7c0a8793          	addi	a5,s5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffd6fc>
     37e:	97a2                	add	a5,a5,s0
     380:	00978933          	add	s2,a5,s1
    decode_qname(qn, cc - len);
     384:	409a05bb          	subw	a1,s4,s1
     388:	854a                	mv	a0,s2
     38a:	00000097          	auipc	ra,0x0
     38e:	c76080e7          	jalr	-906(ra) # 0 <decode_qname>
    len += strlen(qn)+1;
     392:	854a                	mv	a0,s2
     394:	00000097          	auipc	ra,0x0
     398:	5b4080e7          	jalr	1460(ra) # 948 <strlen>
    len += sizeof(struct dns_question);
     39c:	2515                	addiw	a0,a0,5
     39e:	9ca9                	addw	s1,s1,a0
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
     3a0:	2985                	addiw	s3,s3,1
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
     3a2:	7c4a8793          	addi	a5,s5,1988
     3a6:	97a2                	add	a5,a5,s0
     3a8:	0007d783          	lhu	a5,0(a5)
     3ac:	0087971b          	slliw	a4,a5,0x8
     3b0:	83a1                	srli	a5,a5,0x8
     3b2:	8fd9                	or	a5,a5,a4
     3b4:	17c2                	slli	a5,a5,0x30
     3b6:	93c1                	srli	a5,a5,0x30
     3b8:	fcf9c0e3          	blt	s3,a5,378 <dns+0x1fc>
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
     3bc:	77fd                	lui	a5,0xfffff
     3be:	7c678793          	addi	a5,a5,1990 # fffffffffffff7c6 <__global_pointer$+0xffffffffffffd702>
     3c2:	97a2                	add	a5,a5,s0
     3c4:	0007d783          	lhu	a5,0(a5)
     3c8:	34078663          	beqz	a5,714 <dns+0x598>
     3cc:	7f913c23          	sd	s9,2040(sp)
     3d0:	7fa13823          	sd	s10,2032(sp)
     3d4:	7fb13423          	sd	s11,2024(sp)
    if(len >= cc){
     3d8:	1544de63          	bge	s1,s4,534 <dns+0x3b8>
     3dc:	00001797          	auipc	a5,0x1
     3e0:	ebc78793          	addi	a5,a5,-324 # 1298 <malloc+0x2fc>
     3e4:	00090363          	beqz	s2,3ea <dns+0x26e>
     3e8:	87ca                	mv	a5,s2
     3ea:	777d                	lui	a4,0xfffff
     3ec:	7b870713          	addi	a4,a4,1976 # fffffffffffff7b8 <__global_pointer$+0xffffffffffffd6f4>
     3f0:	9722                	add	a4,a4,s0
     3f2:	e31c                	sd	a5,0(a4)
  int record = 0;
     3f4:	4c01                	li	s8,0
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
     3f6:	4901                	li	s2,0
    if((int) qn[0] > 63) {  // compression?
     3f8:	03f00b13          	li	s6,63
    if(ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
     3fc:	10000a93          	li	s5,256
     400:	40000b93          	li	s7,1024
      printf("%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
     404:	00001c97          	auipc	s9,0x1
     408:	e14c8c93          	addi	s9,s9,-492 # 1218 <malloc+0x27c>
      if(ip[0] != 128 || ip[1] != 52 || ip[2] != 129 || ip[3] != 126) {
     40c:	08000d93          	li	s11,128
     410:	03400d13          	li	s10,52
     414:	aa51                	j	5a8 <dns+0x42c>
     416:	7f913c23          	sd	s9,2040(sp)
     41a:	7fa13823          	sd	s10,2032(sp)
     41e:	7fb13423          	sd	s11,2024(sp)
    fprintf(2, "dns: send() failed\n");
     422:	00001597          	auipc	a1,0x1
     426:	d4e58593          	addi	a1,a1,-690 # 1170 <malloc+0x1d4>
     42a:	4509                	li	a0,2
     42c:	00001097          	auipc	ra,0x1
     430:	a8a080e7          	jalr	-1398(ra) # eb6 <fprintf>
    exit(1);
     434:	4505                	li	a0,1
     436:	00000097          	auipc	ra,0x0
     43a:	736080e7          	jalr	1846(ra) # b6c <exit>
     43e:	7f913c23          	sd	s9,2040(sp)
     442:	7fa13823          	sd	s10,2032(sp)
     446:	7fb13423          	sd	s11,2024(sp)
    fprintf(2, "dns: recv() failed\n");
     44a:	00001597          	auipc	a1,0x1
     44e:	d3e58593          	addi	a1,a1,-706 # 1188 <malloc+0x1ec>
     452:	4509                	li	a0,2
     454:	00001097          	auipc	ra,0x1
     458:	a62080e7          	jalr	-1438(ra) # eb6 <fprintf>
    exit(1);
     45c:	4505                	li	a0,1
     45e:	00000097          	auipc	ra,0x0
     462:	70e080e7          	jalr	1806(ra) # b6c <exit>
     466:	7f913c23          	sd	s9,2040(sp)
     46a:	7fa13823          	sd	s10,2032(sp)
     46e:	7fb13423          	sd	s11,2024(sp)
    printf("DNS reply too short\n");
     472:	00001517          	auipc	a0,0x1
     476:	d2e50513          	addi	a0,a0,-722 # 11a0 <malloc+0x204>
     47a:	00001097          	auipc	ra,0x1
     47e:	a6a080e7          	jalr	-1430(ra) # ee4 <printf>
    exit(1);
     482:	4505                	li	a0,1
     484:	00000097          	auipc	ra,0x0
     488:	6e8080e7          	jalr	1768(ra) # b6c <exit>
     48c:	7f913c23          	sd	s9,2040(sp)
     490:	7fa13823          	sd	s10,2032(sp)
     494:	7fb13423          	sd	s11,2024(sp)
     498:	77fd                	lui	a5,0xfffff
     49a:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffd6fc>
     49e:	97a2                	add	a5,a5,s0
     4a0:	0007d783          	lhu	a5,0(a5)
     4a4:	0087971b          	slliw	a4,a5,0x8
     4a8:	83a1                	srli	a5,a5,0x8
     4aa:	00e7e5b3          	or	a1,a5,a4
    printf("Not a DNS reply for %d\n", ntohs(hdr->id));
     4ae:	15c2                	slli	a1,a1,0x30
     4b0:	91c1                	srli	a1,a1,0x30
     4b2:	00001517          	auipc	a0,0x1
     4b6:	d0650513          	addi	a0,a0,-762 # 11b8 <malloc+0x21c>
     4ba:	00001097          	auipc	ra,0x1
     4be:	a2a080e7          	jalr	-1494(ra) # ee4 <printf>
    exit(1);
     4c2:	4505                	li	a0,1
     4c4:	00000097          	auipc	ra,0x0
     4c8:	6a8080e7          	jalr	1704(ra) # b6c <exit>
     4cc:	7f913c23          	sd	s9,2040(sp)
     4d0:	7fa13823          	sd	s10,2032(sp)
     4d4:	7fb13423          	sd	s11,2024(sp)
     4d8:	0087159b          	slliw	a1,a4,0x8
     4dc:	0087571b          	srliw	a4,a4,0x8
     4e0:	8dd9                	or	a1,a1,a4
    printf("DNS wrong id: %d\n", ntohs(hdr->id));
     4e2:	15c2                	slli	a1,a1,0x30
     4e4:	91c1                	srli	a1,a1,0x30
     4e6:	00001517          	auipc	a0,0x1
     4ea:	cea50513          	addi	a0,a0,-790 # 11d0 <malloc+0x234>
     4ee:	00001097          	auipc	ra,0x1
     4f2:	9f6080e7          	jalr	-1546(ra) # ee4 <printf>
    exit(1);
     4f6:	4505                	li	a0,1
     4f8:	00000097          	auipc	ra,0x0
     4fc:	674080e7          	jalr	1652(ra) # b6c <exit>
     500:	7f913c23          	sd	s9,2040(sp)
     504:	7fa13823          	sd	s10,2032(sp)
     508:	7fb13423          	sd	s11,2024(sp)
    printf("DNS rcode error: %x\n", hdr->rcode);
     50c:	77fd                	lui	a5,0xfffff
     50e:	7c378793          	addi	a5,a5,1987 # fffffffffffff7c3 <__global_pointer$+0xffffffffffffd6ff>
     512:	97a2                	add	a5,a5,s0
     514:	0007c583          	lbu	a1,0(a5)
     518:	89bd                	andi	a1,a1,15
     51a:	00001517          	auipc	a0,0x1
     51e:	cce50513          	addi	a0,a0,-818 # 11e8 <malloc+0x24c>
     522:	00001097          	auipc	ra,0x1
     526:	9c2080e7          	jalr	-1598(ra) # ee4 <printf>
    exit(1);
     52a:	4505                	li	a0,1
     52c:	00000097          	auipc	ra,0x0
     530:	640080e7          	jalr	1600(ra) # b6c <exit>
      printf("invalid DNS reply\n");
     534:	00001517          	auipc	a0,0x1
     538:	b6c50513          	addi	a0,a0,-1172 # 10a0 <malloc+0x104>
     53c:	00001097          	auipc	ra,0x1
     540:	9a8080e7          	jalr	-1624(ra) # ee4 <printf>
      exit(1);
     544:	4505                	li	a0,1
     546:	00000097          	auipc	ra,0x0
     54a:	626080e7          	jalr	1574(ra) # b6c <exit>
      decode_qname(qn, cc - len);
     54e:	409a05bb          	subw	a1,s4,s1
     552:	854e                	mv	a0,s3
     554:	00000097          	auipc	ra,0x0
     558:	aac080e7          	jalr	-1364(ra) # 0 <decode_qname>
      len += strlen(qn)+1;
     55c:	854e                	mv	a0,s3
     55e:	00000097          	auipc	ra,0x0
     562:	3ea080e7          	jalr	1002(ra) # 948 <strlen>
     566:	2485                	addiw	s1,s1,1
     568:	9ca9                	addw	s1,s1,a0
     56a:	a891                	j	5be <dns+0x442>
        printf("wrong ip address");
     56c:	00001517          	auipc	a0,0x1
     570:	cbc50513          	addi	a0,a0,-836 # 1228 <malloc+0x28c>
     574:	00001097          	auipc	ra,0x1
     578:	970080e7          	jalr	-1680(ra) # ee4 <printf>
        exit(1);
     57c:	4505                	li	a0,1
     57e:	00000097          	auipc	ra,0x0
     582:	5ee080e7          	jalr	1518(ra) # b6c <exit>
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
     586:	2905                	addiw	s2,s2,1
     588:	77fd                	lui	a5,0xfffff
     58a:	7c678793          	addi	a5,a5,1990 # fffffffffffff7c6 <__global_pointer$+0xffffffffffffd702>
     58e:	97a2                	add	a5,a5,s0
     590:	0007d783          	lhu	a5,0(a5)
     594:	0087971b          	slliw	a4,a5,0x8
     598:	83a1                	srli	a5,a5,0x8
     59a:	8fd9                	or	a5,a5,a4
     59c:	17c2                	slli	a5,a5,0x30
     59e:	93c1                	srli	a5,a5,0x30
     5a0:	0af95f63          	bge	s2,a5,65e <dns+0x4e2>
    if(len >= cc){
     5a4:	f944d8e3          	bge	s1,s4,534 <dns+0x3b8>
    char *qn = (char *) (ibuf+len);
     5a8:	77fd                	lui	a5,0xfffff
     5aa:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffd6fc>
     5ae:	97a2                	add	a5,a5,s0
     5b0:	009789b3          	add	s3,a5,s1
    if((int) qn[0] > 63) {  // compression?
     5b4:	0009c783          	lbu	a5,0(s3)
     5b8:	f8fb7be3          	bgeu	s6,a5,54e <dns+0x3d2>
      len += 2;
     5bc:	2489                	addiw	s1,s1,2
    struct dns_data *d = (struct dns_data *) (ibuf+len);
     5be:	77fd                	lui	a5,0xfffff
     5c0:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffd6fc>
     5c4:	97a2                	add	a5,a5,s0
     5c6:	00978733          	add	a4,a5,s1
    len += sizeof(struct dns_data);
     5ca:	0004899b          	sext.w	s3,s1
     5ce:	24a9                	addiw	s1,s1,10
    if(ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
     5d0:	00074683          	lbu	a3,0(a4)
     5d4:	00174783          	lbu	a5,1(a4)
     5d8:	07a2                	slli	a5,a5,0x8
     5da:	8fd5                	or	a5,a5,a3
     5dc:	fb5795e3          	bne	a5,s5,586 <dns+0x40a>
     5e0:	00874683          	lbu	a3,8(a4)
     5e4:	00974783          	lbu	a5,9(a4)
     5e8:	07a2                	slli	a5,a5,0x8
     5ea:	8fd5                	or	a5,a5,a3
     5ec:	f9779de3          	bne	a5,s7,586 <dns+0x40a>
      printf("DNS arecord for %s is ", qname ? qname : "" );
     5f0:	77fd                	lui	a5,0xfffff
     5f2:	7b878793          	addi	a5,a5,1976 # fffffffffffff7b8 <__global_pointer$+0xffffffffffffd6f4>
     5f6:	97a2                	add	a5,a5,s0
     5f8:	638c                	ld	a1,0(a5)
     5fa:	00001517          	auipc	a0,0x1
     5fe:	c0650513          	addi	a0,a0,-1018 # 1200 <malloc+0x264>
     602:	00001097          	auipc	ra,0x1
     606:	8e2080e7          	jalr	-1822(ra) # ee4 <printf>
      uint8 *ip = (ibuf+len);
     60a:	77fd                	lui	a5,0xfffff
     60c:	7c078793          	addi	a5,a5,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffd6fc>
     610:	97a2                	add	a5,a5,s0
     612:	94be                	add	s1,s1,a5
      printf("%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
     614:	0034c703          	lbu	a4,3(s1)
     618:	0024c683          	lbu	a3,2(s1)
     61c:	0014c603          	lbu	a2,1(s1)
     620:	0004c583          	lbu	a1,0(s1)
     624:	8566                	mv	a0,s9
     626:	00001097          	auipc	ra,0x1
     62a:	8be080e7          	jalr	-1858(ra) # ee4 <printf>
      if(ip[0] != 128 || ip[1] != 52 || ip[2] != 129 || ip[3] != 126) {
     62e:	0004c783          	lbu	a5,0(s1)
     632:	f3b79de3          	bne	a5,s11,56c <dns+0x3f0>
     636:	0014c783          	lbu	a5,1(s1)
     63a:	f3a799e3          	bne	a5,s10,56c <dns+0x3f0>
     63e:	0024c703          	lbu	a4,2(s1)
     642:	08100793          	li	a5,129
     646:	f2f713e3          	bne	a4,a5,56c <dns+0x3f0>
     64a:	0034c703          	lbu	a4,3(s1)
     64e:	07e00793          	li	a5,126
     652:	f0f71de3          	bne	a4,a5,56c <dns+0x3f0>
      len += 4;
     656:	00e9849b          	addiw	s1,s3,14
      record = 1;
     65a:	4c05                	li	s8,1
     65c:	b72d                	j	586 <dns+0x40a>
     65e:	7f813c83          	ld	s9,2040(sp)
     662:	7f013d03          	ld	s10,2032(sp)
     666:	7e813d83          	ld	s11,2024(sp)
  for(int i = 0; i < ntohs(hdr->arcount); i++) {
     66a:	77fd                	lui	a5,0xfffff
     66c:	7ca78793          	addi	a5,a5,1994 # fffffffffffff7ca <__global_pointer$+0xffffffffffffd706>
     670:	97a2                	add	a5,a5,s0
     672:	0007d783          	lhu	a5,0(a5)
     676:	0087959b          	slliw	a1,a5,0x8
     67a:	0087d71b          	srliw	a4,a5,0x8
     67e:	8dd9                	or	a1,a1,a4
     680:	15c2                	slli	a1,a1,0x30
     682:	91c1                	srli	a1,a1,0x30
     684:	cfa9                	beqz	a5,6de <dns+0x562>
     686:	4681                	li	a3,0
    if(ntohs(d->type) != 41) {
     688:	650d                	lui	a0,0x3
     68a:	90050513          	addi	a0,a0,-1792 # 2900 <__global_pointer$+0x83c>
    if(*qn != 0) {
     68e:	f9048793          	addi	a5,s1,-112
     692:	97a2                	add	a5,a5,s0
     694:	8307c783          	lbu	a5,-2000(a5)
     698:	e3c1                	bnez	a5,718 <dns+0x59c>
    struct dns_data *d = (struct dns_data *) (ibuf+len);
     69a:	0014879b          	addiw	a5,s1,1
     69e:	777d                	lui	a4,0xfffff
     6a0:	7c070713          	addi	a4,a4,1984 # fffffffffffff7c0 <__global_pointer$+0xffffffffffffd6fc>
     6a4:	9722                	add	a4,a4,s0
     6a6:	97ba                	add	a5,a5,a4
    len += sizeof(struct dns_data);
     6a8:	24ad                	addiw	s1,s1,11
    if(ntohs(d->type) != 41) {
     6aa:	0007c603          	lbu	a2,0(a5)
     6ae:	0017c703          	lbu	a4,1(a5)
     6b2:	0722                	slli	a4,a4,0x8
     6b4:	8f51                	or	a4,a4,a2
     6b6:	08a71463          	bne	a4,a0,73e <dns+0x5c2>
    len += ntohs(d->len);
     6ba:	0087c703          	lbu	a4,8(a5)
     6be:	0097c783          	lbu	a5,9(a5)
     6c2:	07a2                	slli	a5,a5,0x8
     6c4:	8fd9                	or	a5,a5,a4
     6c6:	0087971b          	slliw	a4,a5,0x8
     6ca:	83a1                	srli	a5,a5,0x8
     6cc:	8fd9                	or	a5,a5,a4
     6ce:	0107979b          	slliw	a5,a5,0x10
     6d2:	0107d79b          	srliw	a5,a5,0x10
     6d6:	9cbd                	addw	s1,s1,a5
  for(int i = 0; i < ntohs(hdr->arcount); i++) {
     6d8:	2685                	addiw	a3,a3,1
     6da:	fab6cae3          	blt	a3,a1,68e <dns+0x512>
  if(len != cc) {
     6de:	089a1363          	bne	s4,s1,764 <dns+0x5e8>
  if(!record) {
     6e2:	0a0c0663          	beqz	s8,78e <dns+0x612>
  }
  dns_rep(ibuf, cc);

  close(fd);
     6e6:	77fd                	lui	a5,0xfffff
     6e8:	7b078793          	addi	a5,a5,1968 # fffffffffffff7b0 <__global_pointer$+0xffffffffffffd6ec>
     6ec:	97a2                	add	a5,a5,s0
     6ee:	6388                	ld	a0,0(a5)
     6f0:	00000097          	auipc	ra,0x0
     6f4:	4a4080e7          	jalr	1188(ra) # b94 <close>
}  
     6f8:	7e010113          	addi	sp,sp,2016
     6fc:	70a6                	ld	ra,104(sp)
     6fe:	7406                	ld	s0,96(sp)
     700:	64e6                	ld	s1,88(sp)
     702:	6946                	ld	s2,80(sp)
     704:	69a6                	ld	s3,72(sp)
     706:	6a06                	ld	s4,64(sp)
     708:	7ae2                	ld	s5,56(sp)
     70a:	7b42                	ld	s6,48(sp)
     70c:	7ba2                	ld	s7,40(sp)
     70e:	7c02                	ld	s8,32(sp)
     710:	6165                	addi	sp,sp,112
     712:	8082                	ret
  int record = 0;
     714:	4c01                	li	s8,0
     716:	bf91                	j	66a <dns+0x4ee>
     718:	7f913c23          	sd	s9,2040(sp)
     71c:	7fa13823          	sd	s10,2032(sp)
     720:	7fb13423          	sd	s11,2024(sp)
      printf("invalid name for EDNS\n");
     724:	00001517          	auipc	a0,0x1
     728:	b1c50513          	addi	a0,a0,-1252 # 1240 <malloc+0x2a4>
     72c:	00000097          	auipc	ra,0x0
     730:	7b8080e7          	jalr	1976(ra) # ee4 <printf>
      exit(1);
     734:	4505                	li	a0,1
     736:	00000097          	auipc	ra,0x0
     73a:	436080e7          	jalr	1078(ra) # b6c <exit>
     73e:	7f913c23          	sd	s9,2040(sp)
     742:	7fa13823          	sd	s10,2032(sp)
     746:	7fb13423          	sd	s11,2024(sp)
      printf("invalid type for EDNS\n");
     74a:	00001517          	auipc	a0,0x1
     74e:	b0e50513          	addi	a0,a0,-1266 # 1258 <malloc+0x2bc>
     752:	00000097          	auipc	ra,0x0
     756:	792080e7          	jalr	1938(ra) # ee4 <printf>
      exit(1);
     75a:	4505                	li	a0,1
     75c:	00000097          	auipc	ra,0x0
     760:	410080e7          	jalr	1040(ra) # b6c <exit>
     764:	7f913c23          	sd	s9,2040(sp)
     768:	7fa13823          	sd	s10,2032(sp)
     76c:	7fb13423          	sd	s11,2024(sp)
    printf("Processed %d data bytes but received %d\n", len, cc);
     770:	8652                	mv	a2,s4
     772:	85a6                	mv	a1,s1
     774:	00001517          	auipc	a0,0x1
     778:	afc50513          	addi	a0,a0,-1284 # 1270 <malloc+0x2d4>
     77c:	00000097          	auipc	ra,0x0
     780:	768080e7          	jalr	1896(ra) # ee4 <printf>
    exit(1);
     784:	4505                	li	a0,1
     786:	00000097          	auipc	ra,0x0
     78a:	3e6080e7          	jalr	998(ra) # b6c <exit>
     78e:	7f913c23          	sd	s9,2040(sp)
     792:	7fa13823          	sd	s10,2032(sp)
     796:	7fb13423          	sd	s11,2024(sp)
    printf("Didn't receive an arecord\n");
     79a:	00001517          	auipc	a0,0x1
     79e:	b0650513          	addi	a0,a0,-1274 # 12a0 <malloc+0x304>
     7a2:	00000097          	auipc	ra,0x0
     7a6:	742080e7          	jalr	1858(ra) # ee4 <printf>
    exit(1);
     7aa:	4505                	li	a0,1
     7ac:	00000097          	auipc	ra,0x0
     7b0:	3c0080e7          	jalr	960(ra) # b6c <exit>

00000000000007b4 <main>:

int
main(int argc, char *argv[])
{
     7b4:	7179                	addi	sp,sp,-48
     7b6:	f406                	sd	ra,40(sp)
     7b8:	f022                	sd	s0,32(sp)
     7ba:	ec26                	sd	s1,24(sp)
     7bc:	e84a                	sd	s2,16(sp)
     7be:	1800                	addi	s0,sp,48
  int i, ret;
  uint16 dport = NET_TESTS_PORT;

  printf("nettests running on port %d\n", dport);
     7c0:	6599                	lui	a1,0x6
     7c2:	5f358593          	addi	a1,a1,1523 # 65f3 <__global_pointer$+0x452f>
     7c6:	00001517          	auipc	a0,0x1
     7ca:	afa50513          	addi	a0,a0,-1286 # 12c0 <malloc+0x324>
     7ce:	00000097          	auipc	ra,0x0
     7d2:	716080e7          	jalr	1814(ra) # ee4 <printf>
  
  printf("testing ping: ");
     7d6:	00001517          	auipc	a0,0x1
     7da:	b0a50513          	addi	a0,a0,-1270 # 12e0 <malloc+0x344>
     7de:	00000097          	auipc	ra,0x0
     7e2:	706080e7          	jalr	1798(ra) # ee4 <printf>
  ping(2000, dport, 1);
     7e6:	4605                	li	a2,1
     7e8:	6599                	lui	a1,0x6
     7ea:	5f358593          	addi	a1,a1,1523 # 65f3 <__global_pointer$+0x452f>
     7ee:	7d000513          	li	a0,2000
     7f2:	00000097          	auipc	ra,0x0
     7f6:	868080e7          	jalr	-1944(ra) # 5a <ping>
  printf("OK\n");
     7fa:	00001517          	auipc	a0,0x1
     7fe:	af650513          	addi	a0,a0,-1290 # 12f0 <malloc+0x354>
     802:	00000097          	auipc	ra,0x0
     806:	6e2080e7          	jalr	1762(ra) # ee4 <printf>
  
  printf("testing single-process pings: ");
     80a:	00001517          	auipc	a0,0x1
     80e:	aee50513          	addi	a0,a0,-1298 # 12f8 <malloc+0x35c>
     812:	00000097          	auipc	ra,0x0
     816:	6d2080e7          	jalr	1746(ra) # ee4 <printf>
     81a:	06400493          	li	s1,100
  for (i = 0; i < 100; i++)
    ping(2000, dport, 1);
     81e:	6919                	lui	s2,0x6
     820:	5f390913          	addi	s2,s2,1523 # 65f3 <__global_pointer$+0x452f>
     824:	4605                	li	a2,1
     826:	85ca                	mv	a1,s2
     828:	7d000513          	li	a0,2000
     82c:	00000097          	auipc	ra,0x0
     830:	82e080e7          	jalr	-2002(ra) # 5a <ping>
  for (i = 0; i < 100; i++)
     834:	34fd                	addiw	s1,s1,-1
     836:	f4fd                	bnez	s1,824 <main+0x70>
  printf("OK\n");
     838:	00001517          	auipc	a0,0x1
     83c:	ab850513          	addi	a0,a0,-1352 # 12f0 <malloc+0x354>
     840:	00000097          	auipc	ra,0x0
     844:	6a4080e7          	jalr	1700(ra) # ee4 <printf>
  
  printf("testing multi-process pings: ");
     848:	00001517          	auipc	a0,0x1
     84c:	ad050513          	addi	a0,a0,-1328 # 1318 <malloc+0x37c>
     850:	00000097          	auipc	ra,0x0
     854:	694080e7          	jalr	1684(ra) # ee4 <printf>
  for (i = 0; i < 10; i++){
     858:	4929                	li	s2,10
    int pid = fork();
     85a:	00000097          	auipc	ra,0x0
     85e:	30a080e7          	jalr	778(ra) # b64 <fork>
    if (pid == 0){
     862:	c92d                	beqz	a0,8d4 <main+0x120>
  for (i = 0; i < 10; i++){
     864:	2485                	addiw	s1,s1,1
     866:	ff249ae3          	bne	s1,s2,85a <main+0xa6>
     86a:	44a9                	li	s1,10
      ping(2000 + i + 1, dport, 1);
      exit(0);
    }
  }
  for (i = 0; i < 10; i++){
    wait(&ret);
     86c:	fdc40513          	addi	a0,s0,-36
     870:	00000097          	auipc	ra,0x0
     874:	304080e7          	jalr	772(ra) # b74 <wait>
    if (ret != 0)
     878:	fdc42783          	lw	a5,-36(s0)
     87c:	efad                	bnez	a5,8f6 <main+0x142>
  for (i = 0; i < 10; i++){
     87e:	34fd                	addiw	s1,s1,-1
     880:	f4f5                	bnez	s1,86c <main+0xb8>
      exit(1);
  }
  printf("OK\n");
     882:	00001517          	auipc	a0,0x1
     886:	a6e50513          	addi	a0,a0,-1426 # 12f0 <malloc+0x354>
     88a:	00000097          	auipc	ra,0x0
     88e:	65a080e7          	jalr	1626(ra) # ee4 <printf>
  
  printf("testing DNS\n");
     892:	00001517          	auipc	a0,0x1
     896:	aa650513          	addi	a0,a0,-1370 # 1338 <malloc+0x39c>
     89a:	00000097          	auipc	ra,0x0
     89e:	64a080e7          	jalr	1610(ra) # ee4 <printf>
  dns();
     8a2:	00000097          	auipc	ra,0x0
     8a6:	8da080e7          	jalr	-1830(ra) # 17c <dns>
  printf("DNS OK\n");
     8aa:	00001517          	auipc	a0,0x1
     8ae:	a9e50513          	addi	a0,a0,-1378 # 1348 <malloc+0x3ac>
     8b2:	00000097          	auipc	ra,0x0
     8b6:	632080e7          	jalr	1586(ra) # ee4 <printf>
  
  printf("all tests passed.\n");
     8ba:	00001517          	auipc	a0,0x1
     8be:	a9650513          	addi	a0,a0,-1386 # 1350 <malloc+0x3b4>
     8c2:	00000097          	auipc	ra,0x0
     8c6:	622080e7          	jalr	1570(ra) # ee4 <printf>
  exit(0);
     8ca:	4501                	li	a0,0
     8cc:	00000097          	auipc	ra,0x0
     8d0:	2a0080e7          	jalr	672(ra) # b6c <exit>
      ping(2000 + i + 1, dport, 1);
     8d4:	7d14851b          	addiw	a0,s1,2001
     8d8:	4605                	li	a2,1
     8da:	6599                	lui	a1,0x6
     8dc:	5f358593          	addi	a1,a1,1523 # 65f3 <__global_pointer$+0x452f>
     8e0:	1542                	slli	a0,a0,0x30
     8e2:	9141                	srli	a0,a0,0x30
     8e4:	fffff097          	auipc	ra,0xfffff
     8e8:	776080e7          	jalr	1910(ra) # 5a <ping>
      exit(0);
     8ec:	4501                	li	a0,0
     8ee:	00000097          	auipc	ra,0x0
     8f2:	27e080e7          	jalr	638(ra) # b6c <exit>
      exit(1);
     8f6:	4505                	li	a0,1
     8f8:	00000097          	auipc	ra,0x0
     8fc:	274080e7          	jalr	628(ra) # b6c <exit>

0000000000000900 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     900:	1141                	addi	sp,sp,-16
     902:	e422                	sd	s0,8(sp)
     904:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     906:	87aa                	mv	a5,a0
     908:	0585                	addi	a1,a1,1
     90a:	0785                	addi	a5,a5,1
     90c:	fff5c703          	lbu	a4,-1(a1)
     910:	fee78fa3          	sb	a4,-1(a5)
     914:	fb75                	bnez	a4,908 <strcpy+0x8>
    ;
  return os;
}
     916:	6422                	ld	s0,8(sp)
     918:	0141                	addi	sp,sp,16
     91a:	8082                	ret

000000000000091c <strcmp>:

int
strcmp(const char *p, const char *q)
{
     91c:	1141                	addi	sp,sp,-16
     91e:	e422                	sd	s0,8(sp)
     920:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     922:	00054783          	lbu	a5,0(a0)
     926:	cb91                	beqz	a5,93a <strcmp+0x1e>
     928:	0005c703          	lbu	a4,0(a1)
     92c:	00f71763          	bne	a4,a5,93a <strcmp+0x1e>
    p++, q++;
     930:	0505                	addi	a0,a0,1
     932:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     934:	00054783          	lbu	a5,0(a0)
     938:	fbe5                	bnez	a5,928 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     93a:	0005c503          	lbu	a0,0(a1)
}
     93e:	40a7853b          	subw	a0,a5,a0
     942:	6422                	ld	s0,8(sp)
     944:	0141                	addi	sp,sp,16
     946:	8082                	ret

0000000000000948 <strlen>:

uint
strlen(const char *s)
{
     948:	1141                	addi	sp,sp,-16
     94a:	e422                	sd	s0,8(sp)
     94c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     94e:	00054783          	lbu	a5,0(a0)
     952:	cf91                	beqz	a5,96e <strlen+0x26>
     954:	0505                	addi	a0,a0,1
     956:	87aa                	mv	a5,a0
     958:	86be                	mv	a3,a5
     95a:	0785                	addi	a5,a5,1
     95c:	fff7c703          	lbu	a4,-1(a5)
     960:	ff65                	bnez	a4,958 <strlen+0x10>
     962:	40a6853b          	subw	a0,a3,a0
     966:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     968:	6422                	ld	s0,8(sp)
     96a:	0141                	addi	sp,sp,16
     96c:	8082                	ret
  for(n = 0; s[n]; n++)
     96e:	4501                	li	a0,0
     970:	bfe5                	j	968 <strlen+0x20>

0000000000000972 <memset>:

void*
memset(void *dst, int c, uint n)
{
     972:	1141                	addi	sp,sp,-16
     974:	e422                	sd	s0,8(sp)
     976:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     978:	ca19                	beqz	a2,98e <memset+0x1c>
     97a:	87aa                	mv	a5,a0
     97c:	1602                	slli	a2,a2,0x20
     97e:	9201                	srli	a2,a2,0x20
     980:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     984:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     988:	0785                	addi	a5,a5,1
     98a:	fee79de3          	bne	a5,a4,984 <memset+0x12>
  }
  return dst;
}
     98e:	6422                	ld	s0,8(sp)
     990:	0141                	addi	sp,sp,16
     992:	8082                	ret

0000000000000994 <strchr>:

char*
strchr(const char *s, char c)
{
     994:	1141                	addi	sp,sp,-16
     996:	e422                	sd	s0,8(sp)
     998:	0800                	addi	s0,sp,16
  for(; *s; s++)
     99a:	00054783          	lbu	a5,0(a0)
     99e:	cb99                	beqz	a5,9b4 <strchr+0x20>
    if(*s == c)
     9a0:	00f58763          	beq	a1,a5,9ae <strchr+0x1a>
  for(; *s; s++)
     9a4:	0505                	addi	a0,a0,1
     9a6:	00054783          	lbu	a5,0(a0)
     9aa:	fbfd                	bnez	a5,9a0 <strchr+0xc>
      return (char*)s;
  return 0;
     9ac:	4501                	li	a0,0
}
     9ae:	6422                	ld	s0,8(sp)
     9b0:	0141                	addi	sp,sp,16
     9b2:	8082                	ret
  return 0;
     9b4:	4501                	li	a0,0
     9b6:	bfe5                	j	9ae <strchr+0x1a>

00000000000009b8 <gets>:

char*
gets(char *buf, int max)
{
     9b8:	711d                	addi	sp,sp,-96
     9ba:	ec86                	sd	ra,88(sp)
     9bc:	e8a2                	sd	s0,80(sp)
     9be:	e4a6                	sd	s1,72(sp)
     9c0:	e0ca                	sd	s2,64(sp)
     9c2:	fc4e                	sd	s3,56(sp)
     9c4:	f852                	sd	s4,48(sp)
     9c6:	f456                	sd	s5,40(sp)
     9c8:	f05a                	sd	s6,32(sp)
     9ca:	ec5e                	sd	s7,24(sp)
     9cc:	1080                	addi	s0,sp,96
     9ce:	8baa                	mv	s7,a0
     9d0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     9d2:	892a                	mv	s2,a0
     9d4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     9d6:	4aa9                	li	s5,10
     9d8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     9da:	89a6                	mv	s3,s1
     9dc:	2485                	addiw	s1,s1,1
     9de:	0344d863          	bge	s1,s4,a0e <gets+0x56>
    cc = read(0, &c, 1);
     9e2:	4605                	li	a2,1
     9e4:	faf40593          	addi	a1,s0,-81
     9e8:	4501                	li	a0,0
     9ea:	00000097          	auipc	ra,0x0
     9ee:	19a080e7          	jalr	410(ra) # b84 <read>
    if(cc < 1)
     9f2:	00a05e63          	blez	a0,a0e <gets+0x56>
    buf[i++] = c;
     9f6:	faf44783          	lbu	a5,-81(s0)
     9fa:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     9fe:	01578763          	beq	a5,s5,a0c <gets+0x54>
     a02:	0905                	addi	s2,s2,1
     a04:	fd679be3          	bne	a5,s6,9da <gets+0x22>
    buf[i++] = c;
     a08:	89a6                	mv	s3,s1
     a0a:	a011                	j	a0e <gets+0x56>
     a0c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     a0e:	99de                	add	s3,s3,s7
     a10:	00098023          	sb	zero,0(s3)
  return buf;
}
     a14:	855e                	mv	a0,s7
     a16:	60e6                	ld	ra,88(sp)
     a18:	6446                	ld	s0,80(sp)
     a1a:	64a6                	ld	s1,72(sp)
     a1c:	6906                	ld	s2,64(sp)
     a1e:	79e2                	ld	s3,56(sp)
     a20:	7a42                	ld	s4,48(sp)
     a22:	7aa2                	ld	s5,40(sp)
     a24:	7b02                	ld	s6,32(sp)
     a26:	6be2                	ld	s7,24(sp)
     a28:	6125                	addi	sp,sp,96
     a2a:	8082                	ret

0000000000000a2c <stat>:

int
stat(const char *n, struct stat *st)
{
     a2c:	1101                	addi	sp,sp,-32
     a2e:	ec06                	sd	ra,24(sp)
     a30:	e822                	sd	s0,16(sp)
     a32:	e04a                	sd	s2,0(sp)
     a34:	1000                	addi	s0,sp,32
     a36:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a38:	4581                	li	a1,0
     a3a:	00000097          	auipc	ra,0x0
     a3e:	172080e7          	jalr	370(ra) # bac <open>
  if(fd < 0)
     a42:	02054663          	bltz	a0,a6e <stat+0x42>
     a46:	e426                	sd	s1,8(sp)
     a48:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a4a:	85ca                	mv	a1,s2
     a4c:	00000097          	auipc	ra,0x0
     a50:	178080e7          	jalr	376(ra) # bc4 <fstat>
     a54:	892a                	mv	s2,a0
  close(fd);
     a56:	8526                	mv	a0,s1
     a58:	00000097          	auipc	ra,0x0
     a5c:	13c080e7          	jalr	316(ra) # b94 <close>
  return r;
     a60:	64a2                	ld	s1,8(sp)
}
     a62:	854a                	mv	a0,s2
     a64:	60e2                	ld	ra,24(sp)
     a66:	6442                	ld	s0,16(sp)
     a68:	6902                	ld	s2,0(sp)
     a6a:	6105                	addi	sp,sp,32
     a6c:	8082                	ret
    return -1;
     a6e:	597d                	li	s2,-1
     a70:	bfcd                	j	a62 <stat+0x36>

0000000000000a72 <atoi>:

int
atoi(const char *s)
{
     a72:	1141                	addi	sp,sp,-16
     a74:	e422                	sd	s0,8(sp)
     a76:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     a78:	00054683          	lbu	a3,0(a0)
     a7c:	fd06879b          	addiw	a5,a3,-48
     a80:	0ff7f793          	zext.b	a5,a5
     a84:	4625                	li	a2,9
     a86:	02f66863          	bltu	a2,a5,ab6 <atoi+0x44>
     a8a:	872a                	mv	a4,a0
  n = 0;
     a8c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     a8e:	0705                	addi	a4,a4,1
     a90:	0025179b          	slliw	a5,a0,0x2
     a94:	9fa9                	addw	a5,a5,a0
     a96:	0017979b          	slliw	a5,a5,0x1
     a9a:	9fb5                	addw	a5,a5,a3
     a9c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     aa0:	00074683          	lbu	a3,0(a4)
     aa4:	fd06879b          	addiw	a5,a3,-48
     aa8:	0ff7f793          	zext.b	a5,a5
     aac:	fef671e3          	bgeu	a2,a5,a8e <atoi+0x1c>
  return n;
}
     ab0:	6422                	ld	s0,8(sp)
     ab2:	0141                	addi	sp,sp,16
     ab4:	8082                	ret
  n = 0;
     ab6:	4501                	li	a0,0
     ab8:	bfe5                	j	ab0 <atoi+0x3e>

0000000000000aba <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     aba:	1141                	addi	sp,sp,-16
     abc:	e422                	sd	s0,8(sp)
     abe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     ac0:	02b57463          	bgeu	a0,a1,ae8 <memmove+0x2e>
    while(n-- > 0)
     ac4:	00c05f63          	blez	a2,ae2 <memmove+0x28>
     ac8:	1602                	slli	a2,a2,0x20
     aca:	9201                	srli	a2,a2,0x20
     acc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     ad0:	872a                	mv	a4,a0
      *dst++ = *src++;
     ad2:	0585                	addi	a1,a1,1
     ad4:	0705                	addi	a4,a4,1
     ad6:	fff5c683          	lbu	a3,-1(a1)
     ada:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     ade:	fef71ae3          	bne	a4,a5,ad2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     ae2:	6422                	ld	s0,8(sp)
     ae4:	0141                	addi	sp,sp,16
     ae6:	8082                	ret
    dst += n;
     ae8:	00c50733          	add	a4,a0,a2
    src += n;
     aec:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     aee:	fec05ae3          	blez	a2,ae2 <memmove+0x28>
     af2:	fff6079b          	addiw	a5,a2,-1
     af6:	1782                	slli	a5,a5,0x20
     af8:	9381                	srli	a5,a5,0x20
     afa:	fff7c793          	not	a5,a5
     afe:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b00:	15fd                	addi	a1,a1,-1
     b02:	177d                	addi	a4,a4,-1
     b04:	0005c683          	lbu	a3,0(a1)
     b08:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     b0c:	fee79ae3          	bne	a5,a4,b00 <memmove+0x46>
     b10:	bfc9                	j	ae2 <memmove+0x28>

0000000000000b12 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     b12:	1141                	addi	sp,sp,-16
     b14:	e422                	sd	s0,8(sp)
     b16:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     b18:	ca05                	beqz	a2,b48 <memcmp+0x36>
     b1a:	fff6069b          	addiw	a3,a2,-1
     b1e:	1682                	slli	a3,a3,0x20
     b20:	9281                	srli	a3,a3,0x20
     b22:	0685                	addi	a3,a3,1
     b24:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     b26:	00054783          	lbu	a5,0(a0)
     b2a:	0005c703          	lbu	a4,0(a1)
     b2e:	00e79863          	bne	a5,a4,b3e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     b32:	0505                	addi	a0,a0,1
    p2++;
     b34:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b36:	fed518e3          	bne	a0,a3,b26 <memcmp+0x14>
  }
  return 0;
     b3a:	4501                	li	a0,0
     b3c:	a019                	j	b42 <memcmp+0x30>
      return *p1 - *p2;
     b3e:	40e7853b          	subw	a0,a5,a4
}
     b42:	6422                	ld	s0,8(sp)
     b44:	0141                	addi	sp,sp,16
     b46:	8082                	ret
  return 0;
     b48:	4501                	li	a0,0
     b4a:	bfe5                	j	b42 <memcmp+0x30>

0000000000000b4c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b4c:	1141                	addi	sp,sp,-16
     b4e:	e406                	sd	ra,8(sp)
     b50:	e022                	sd	s0,0(sp)
     b52:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b54:	00000097          	auipc	ra,0x0
     b58:	f66080e7          	jalr	-154(ra) # aba <memmove>
}
     b5c:	60a2                	ld	ra,8(sp)
     b5e:	6402                	ld	s0,0(sp)
     b60:	0141                	addi	sp,sp,16
     b62:	8082                	ret

0000000000000b64 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b64:	4885                	li	a7,1
 ecall
     b66:	00000073          	ecall
 ret
     b6a:	8082                	ret

0000000000000b6c <exit>:
.global exit
exit:
 li a7, SYS_exit
     b6c:	4889                	li	a7,2
 ecall
     b6e:	00000073          	ecall
 ret
     b72:	8082                	ret

0000000000000b74 <wait>:
.global wait
wait:
 li a7, SYS_wait
     b74:	488d                	li	a7,3
 ecall
     b76:	00000073          	ecall
 ret
     b7a:	8082                	ret

0000000000000b7c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b7c:	4891                	li	a7,4
 ecall
     b7e:	00000073          	ecall
 ret
     b82:	8082                	ret

0000000000000b84 <read>:
.global read
read:
 li a7, SYS_read
     b84:	4895                	li	a7,5
 ecall
     b86:	00000073          	ecall
 ret
     b8a:	8082                	ret

0000000000000b8c <write>:
.global write
write:
 li a7, SYS_write
     b8c:	48c1                	li	a7,16
 ecall
     b8e:	00000073          	ecall
 ret
     b92:	8082                	ret

0000000000000b94 <close>:
.global close
close:
 li a7, SYS_close
     b94:	48d5                	li	a7,21
 ecall
     b96:	00000073          	ecall
 ret
     b9a:	8082                	ret

0000000000000b9c <kill>:
.global kill
kill:
 li a7, SYS_kill
     b9c:	4899                	li	a7,6
 ecall
     b9e:	00000073          	ecall
 ret
     ba2:	8082                	ret

0000000000000ba4 <exec>:
.global exec
exec:
 li a7, SYS_exec
     ba4:	489d                	li	a7,7
 ecall
     ba6:	00000073          	ecall
 ret
     baa:	8082                	ret

0000000000000bac <open>:
.global open
open:
 li a7, SYS_open
     bac:	48bd                	li	a7,15
 ecall
     bae:	00000073          	ecall
 ret
     bb2:	8082                	ret

0000000000000bb4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     bb4:	48c5                	li	a7,17
 ecall
     bb6:	00000073          	ecall
 ret
     bba:	8082                	ret

0000000000000bbc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     bbc:	48c9                	li	a7,18
 ecall
     bbe:	00000073          	ecall
 ret
     bc2:	8082                	ret

0000000000000bc4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     bc4:	48a1                	li	a7,8
 ecall
     bc6:	00000073          	ecall
 ret
     bca:	8082                	ret

0000000000000bcc <link>:
.global link
link:
 li a7, SYS_link
     bcc:	48cd                	li	a7,19
 ecall
     bce:	00000073          	ecall
 ret
     bd2:	8082                	ret

0000000000000bd4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     bd4:	48d1                	li	a7,20
 ecall
     bd6:	00000073          	ecall
 ret
     bda:	8082                	ret

0000000000000bdc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     bdc:	48a5                	li	a7,9
 ecall
     bde:	00000073          	ecall
 ret
     be2:	8082                	ret

0000000000000be4 <dup>:
.global dup
dup:
 li a7, SYS_dup
     be4:	48a9                	li	a7,10
 ecall
     be6:	00000073          	ecall
 ret
     bea:	8082                	ret

0000000000000bec <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     bec:	48ad                	li	a7,11
 ecall
     bee:	00000073          	ecall
 ret
     bf2:	8082                	ret

0000000000000bf4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     bf4:	48b1                	li	a7,12
 ecall
     bf6:	00000073          	ecall
 ret
     bfa:	8082                	ret

0000000000000bfc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     bfc:	48b5                	li	a7,13
 ecall
     bfe:	00000073          	ecall
 ret
     c02:	8082                	ret

0000000000000c04 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c04:	48b9                	li	a7,14
 ecall
     c06:	00000073          	ecall
 ret
     c0a:	8082                	ret

0000000000000c0c <connect>:
.global connect
connect:
 li a7, SYS_connect
     c0c:	48f5                	li	a7,29
 ecall
     c0e:	00000073          	ecall
 ret
     c12:	8082                	ret

0000000000000c14 <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
     c14:	48f9                	li	a7,30
 ecall
     c16:	00000073          	ecall
 ret
     c1a:	8082                	ret

0000000000000c1c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c1c:	1101                	addi	sp,sp,-32
     c1e:	ec06                	sd	ra,24(sp)
     c20:	e822                	sd	s0,16(sp)
     c22:	1000                	addi	s0,sp,32
     c24:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c28:	4605                	li	a2,1
     c2a:	fef40593          	addi	a1,s0,-17
     c2e:	00000097          	auipc	ra,0x0
     c32:	f5e080e7          	jalr	-162(ra) # b8c <write>
}
     c36:	60e2                	ld	ra,24(sp)
     c38:	6442                	ld	s0,16(sp)
     c3a:	6105                	addi	sp,sp,32
     c3c:	8082                	ret

0000000000000c3e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c3e:	7139                	addi	sp,sp,-64
     c40:	fc06                	sd	ra,56(sp)
     c42:	f822                	sd	s0,48(sp)
     c44:	f426                	sd	s1,40(sp)
     c46:	0080                	addi	s0,sp,64
     c48:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c4a:	c299                	beqz	a3,c50 <printint+0x12>
     c4c:	0805cb63          	bltz	a1,ce2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     c50:	2581                	sext.w	a1,a1
  neg = 0;
     c52:	4881                	li	a7,0
     c54:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     c58:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c5a:	2601                	sext.w	a2,a2
     c5c:	00000517          	auipc	a0,0x0
     c60:	76c50513          	addi	a0,a0,1900 # 13c8 <digits>
     c64:	883a                	mv	a6,a4
     c66:	2705                	addiw	a4,a4,1
     c68:	02c5f7bb          	remuw	a5,a1,a2
     c6c:	1782                	slli	a5,a5,0x20
     c6e:	9381                	srli	a5,a5,0x20
     c70:	97aa                	add	a5,a5,a0
     c72:	0007c783          	lbu	a5,0(a5)
     c76:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c7a:	0005879b          	sext.w	a5,a1
     c7e:	02c5d5bb          	divuw	a1,a1,a2
     c82:	0685                	addi	a3,a3,1
     c84:	fec7f0e3          	bgeu	a5,a2,c64 <printint+0x26>
  if(neg)
     c88:	00088c63          	beqz	a7,ca0 <printint+0x62>
    buf[i++] = '-';
     c8c:	fd070793          	addi	a5,a4,-48
     c90:	00878733          	add	a4,a5,s0
     c94:	02d00793          	li	a5,45
     c98:	fef70823          	sb	a5,-16(a4)
     c9c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     ca0:	02e05c63          	blez	a4,cd8 <printint+0x9a>
     ca4:	f04a                	sd	s2,32(sp)
     ca6:	ec4e                	sd	s3,24(sp)
     ca8:	fc040793          	addi	a5,s0,-64
     cac:	00e78933          	add	s2,a5,a4
     cb0:	fff78993          	addi	s3,a5,-1
     cb4:	99ba                	add	s3,s3,a4
     cb6:	377d                	addiw	a4,a4,-1
     cb8:	1702                	slli	a4,a4,0x20
     cba:	9301                	srli	a4,a4,0x20
     cbc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     cc0:	fff94583          	lbu	a1,-1(s2)
     cc4:	8526                	mv	a0,s1
     cc6:	00000097          	auipc	ra,0x0
     cca:	f56080e7          	jalr	-170(ra) # c1c <putc>
  while(--i >= 0)
     cce:	197d                	addi	s2,s2,-1
     cd0:	ff3918e3          	bne	s2,s3,cc0 <printint+0x82>
     cd4:	7902                	ld	s2,32(sp)
     cd6:	69e2                	ld	s3,24(sp)
}
     cd8:	70e2                	ld	ra,56(sp)
     cda:	7442                	ld	s0,48(sp)
     cdc:	74a2                	ld	s1,40(sp)
     cde:	6121                	addi	sp,sp,64
     ce0:	8082                	ret
    x = -xx;
     ce2:	40b005bb          	negw	a1,a1
    neg = 1;
     ce6:	4885                	li	a7,1
    x = -xx;
     ce8:	b7b5                	j	c54 <printint+0x16>

0000000000000cea <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     cea:	715d                	addi	sp,sp,-80
     cec:	e486                	sd	ra,72(sp)
     cee:	e0a2                	sd	s0,64(sp)
     cf0:	f84a                	sd	s2,48(sp)
     cf2:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     cf4:	0005c903          	lbu	s2,0(a1)
     cf8:	1a090a63          	beqz	s2,eac <vprintf+0x1c2>
     cfc:	fc26                	sd	s1,56(sp)
     cfe:	f44e                	sd	s3,40(sp)
     d00:	f052                	sd	s4,32(sp)
     d02:	ec56                	sd	s5,24(sp)
     d04:	e85a                	sd	s6,16(sp)
     d06:	e45e                	sd	s7,8(sp)
     d08:	8aaa                	mv	s5,a0
     d0a:	8bb2                	mv	s7,a2
     d0c:	00158493          	addi	s1,a1,1
  state = 0;
     d10:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     d12:	02500a13          	li	s4,37
     d16:	4b55                	li	s6,21
     d18:	a839                	j	d36 <vprintf+0x4c>
        putc(fd, c);
     d1a:	85ca                	mv	a1,s2
     d1c:	8556                	mv	a0,s5
     d1e:	00000097          	auipc	ra,0x0
     d22:	efe080e7          	jalr	-258(ra) # c1c <putc>
     d26:	a019                	j	d2c <vprintf+0x42>
    } else if(state == '%'){
     d28:	01498d63          	beq	s3,s4,d42 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     d2c:	0485                	addi	s1,s1,1
     d2e:	fff4c903          	lbu	s2,-1(s1)
     d32:	16090763          	beqz	s2,ea0 <vprintf+0x1b6>
    if(state == 0){
     d36:	fe0999e3          	bnez	s3,d28 <vprintf+0x3e>
      if(c == '%'){
     d3a:	ff4910e3          	bne	s2,s4,d1a <vprintf+0x30>
        state = '%';
     d3e:	89d2                	mv	s3,s4
     d40:	b7f5                	j	d2c <vprintf+0x42>
      if(c == 'd'){
     d42:	13490463          	beq	s2,s4,e6a <vprintf+0x180>
     d46:	f9d9079b          	addiw	a5,s2,-99
     d4a:	0ff7f793          	zext.b	a5,a5
     d4e:	12fb6763          	bltu	s6,a5,e7c <vprintf+0x192>
     d52:	f9d9079b          	addiw	a5,s2,-99
     d56:	0ff7f713          	zext.b	a4,a5
     d5a:	12eb6163          	bltu	s6,a4,e7c <vprintf+0x192>
     d5e:	00271793          	slli	a5,a4,0x2
     d62:	00000717          	auipc	a4,0x0
     d66:	60e70713          	addi	a4,a4,1550 # 1370 <malloc+0x3d4>
     d6a:	97ba                	add	a5,a5,a4
     d6c:	439c                	lw	a5,0(a5)
     d6e:	97ba                	add	a5,a5,a4
     d70:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     d72:	008b8913          	addi	s2,s7,8
     d76:	4685                	li	a3,1
     d78:	4629                	li	a2,10
     d7a:	000ba583          	lw	a1,0(s7)
     d7e:	8556                	mv	a0,s5
     d80:	00000097          	auipc	ra,0x0
     d84:	ebe080e7          	jalr	-322(ra) # c3e <printint>
     d88:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     d8a:	4981                	li	s3,0
     d8c:	b745                	j	d2c <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     d8e:	008b8913          	addi	s2,s7,8
     d92:	4681                	li	a3,0
     d94:	4629                	li	a2,10
     d96:	000ba583          	lw	a1,0(s7)
     d9a:	8556                	mv	a0,s5
     d9c:	00000097          	auipc	ra,0x0
     da0:	ea2080e7          	jalr	-350(ra) # c3e <printint>
     da4:	8bca                	mv	s7,s2
      state = 0;
     da6:	4981                	li	s3,0
     da8:	b751                	j	d2c <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     daa:	008b8913          	addi	s2,s7,8
     dae:	4681                	li	a3,0
     db0:	4641                	li	a2,16
     db2:	000ba583          	lw	a1,0(s7)
     db6:	8556                	mv	a0,s5
     db8:	00000097          	auipc	ra,0x0
     dbc:	e86080e7          	jalr	-378(ra) # c3e <printint>
     dc0:	8bca                	mv	s7,s2
      state = 0;
     dc2:	4981                	li	s3,0
     dc4:	b7a5                	j	d2c <vprintf+0x42>
     dc6:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     dc8:	008b8c13          	addi	s8,s7,8
     dcc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     dd0:	03000593          	li	a1,48
     dd4:	8556                	mv	a0,s5
     dd6:	00000097          	auipc	ra,0x0
     dda:	e46080e7          	jalr	-442(ra) # c1c <putc>
  putc(fd, 'x');
     dde:	07800593          	li	a1,120
     de2:	8556                	mv	a0,s5
     de4:	00000097          	auipc	ra,0x0
     de8:	e38080e7          	jalr	-456(ra) # c1c <putc>
     dec:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     dee:	00000b97          	auipc	s7,0x0
     df2:	5dab8b93          	addi	s7,s7,1498 # 13c8 <digits>
     df6:	03c9d793          	srli	a5,s3,0x3c
     dfa:	97de                	add	a5,a5,s7
     dfc:	0007c583          	lbu	a1,0(a5)
     e00:	8556                	mv	a0,s5
     e02:	00000097          	auipc	ra,0x0
     e06:	e1a080e7          	jalr	-486(ra) # c1c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     e0a:	0992                	slli	s3,s3,0x4
     e0c:	397d                	addiw	s2,s2,-1
     e0e:	fe0914e3          	bnez	s2,df6 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
     e12:	8be2                	mv	s7,s8
      state = 0;
     e14:	4981                	li	s3,0
     e16:	6c02                	ld	s8,0(sp)
     e18:	bf11                	j	d2c <vprintf+0x42>
        s = va_arg(ap, char*);
     e1a:	008b8993          	addi	s3,s7,8
     e1e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     e22:	02090163          	beqz	s2,e44 <vprintf+0x15a>
        while(*s != 0){
     e26:	00094583          	lbu	a1,0(s2)
     e2a:	c9a5                	beqz	a1,e9a <vprintf+0x1b0>
          putc(fd, *s);
     e2c:	8556                	mv	a0,s5
     e2e:	00000097          	auipc	ra,0x0
     e32:	dee080e7          	jalr	-530(ra) # c1c <putc>
          s++;
     e36:	0905                	addi	s2,s2,1
        while(*s != 0){
     e38:	00094583          	lbu	a1,0(s2)
     e3c:	f9e5                	bnez	a1,e2c <vprintf+0x142>
        s = va_arg(ap, char*);
     e3e:	8bce                	mv	s7,s3
      state = 0;
     e40:	4981                	li	s3,0
     e42:	b5ed                	j	d2c <vprintf+0x42>
          s = "(null)";
     e44:	00000917          	auipc	s2,0x0
     e48:	52490913          	addi	s2,s2,1316 # 1368 <malloc+0x3cc>
        while(*s != 0){
     e4c:	02800593          	li	a1,40
     e50:	bff1                	j	e2c <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
     e52:	008b8913          	addi	s2,s7,8
     e56:	000bc583          	lbu	a1,0(s7)
     e5a:	8556                	mv	a0,s5
     e5c:	00000097          	auipc	ra,0x0
     e60:	dc0080e7          	jalr	-576(ra) # c1c <putc>
     e64:	8bca                	mv	s7,s2
      state = 0;
     e66:	4981                	li	s3,0
     e68:	b5d1                	j	d2c <vprintf+0x42>
        putc(fd, c);
     e6a:	02500593          	li	a1,37
     e6e:	8556                	mv	a0,s5
     e70:	00000097          	auipc	ra,0x0
     e74:	dac080e7          	jalr	-596(ra) # c1c <putc>
      state = 0;
     e78:	4981                	li	s3,0
     e7a:	bd4d                	j	d2c <vprintf+0x42>
        putc(fd, '%');
     e7c:	02500593          	li	a1,37
     e80:	8556                	mv	a0,s5
     e82:	00000097          	auipc	ra,0x0
     e86:	d9a080e7          	jalr	-614(ra) # c1c <putc>
        putc(fd, c);
     e8a:	85ca                	mv	a1,s2
     e8c:	8556                	mv	a0,s5
     e8e:	00000097          	auipc	ra,0x0
     e92:	d8e080e7          	jalr	-626(ra) # c1c <putc>
      state = 0;
     e96:	4981                	li	s3,0
     e98:	bd51                	j	d2c <vprintf+0x42>
        s = va_arg(ap, char*);
     e9a:	8bce                	mv	s7,s3
      state = 0;
     e9c:	4981                	li	s3,0
     e9e:	b579                	j	d2c <vprintf+0x42>
     ea0:	74e2                	ld	s1,56(sp)
     ea2:	79a2                	ld	s3,40(sp)
     ea4:	7a02                	ld	s4,32(sp)
     ea6:	6ae2                	ld	s5,24(sp)
     ea8:	6b42                	ld	s6,16(sp)
     eaa:	6ba2                	ld	s7,8(sp)
    }
  }
}
     eac:	60a6                	ld	ra,72(sp)
     eae:	6406                	ld	s0,64(sp)
     eb0:	7942                	ld	s2,48(sp)
     eb2:	6161                	addi	sp,sp,80
     eb4:	8082                	ret

0000000000000eb6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     eb6:	715d                	addi	sp,sp,-80
     eb8:	ec06                	sd	ra,24(sp)
     eba:	e822                	sd	s0,16(sp)
     ebc:	1000                	addi	s0,sp,32
     ebe:	e010                	sd	a2,0(s0)
     ec0:	e414                	sd	a3,8(s0)
     ec2:	e818                	sd	a4,16(s0)
     ec4:	ec1c                	sd	a5,24(s0)
     ec6:	03043023          	sd	a6,32(s0)
     eca:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     ece:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     ed2:	8622                	mv	a2,s0
     ed4:	00000097          	auipc	ra,0x0
     ed8:	e16080e7          	jalr	-490(ra) # cea <vprintf>
}
     edc:	60e2                	ld	ra,24(sp)
     ede:	6442                	ld	s0,16(sp)
     ee0:	6161                	addi	sp,sp,80
     ee2:	8082                	ret

0000000000000ee4 <printf>:

void
printf(const char *fmt, ...)
{
     ee4:	711d                	addi	sp,sp,-96
     ee6:	ec06                	sd	ra,24(sp)
     ee8:	e822                	sd	s0,16(sp)
     eea:	1000                	addi	s0,sp,32
     eec:	e40c                	sd	a1,8(s0)
     eee:	e810                	sd	a2,16(s0)
     ef0:	ec14                	sd	a3,24(s0)
     ef2:	f018                	sd	a4,32(s0)
     ef4:	f41c                	sd	a5,40(s0)
     ef6:	03043823          	sd	a6,48(s0)
     efa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     efe:	00840613          	addi	a2,s0,8
     f02:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     f06:	85aa                	mv	a1,a0
     f08:	4505                	li	a0,1
     f0a:	00000097          	auipc	ra,0x0
     f0e:	de0080e7          	jalr	-544(ra) # cea <vprintf>
}
     f12:	60e2                	ld	ra,24(sp)
     f14:	6442                	ld	s0,16(sp)
     f16:	6125                	addi	sp,sp,96
     f18:	8082                	ret

0000000000000f1a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     f1a:	1141                	addi	sp,sp,-16
     f1c:	e422                	sd	s0,8(sp)
     f1e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     f20:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f24:	00001797          	auipc	a5,0x1
     f28:	9a47b783          	ld	a5,-1628(a5) # 18c8 <freep>
     f2c:	a02d                	j	f56 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     f2e:	4618                	lw	a4,8(a2)
     f30:	9f2d                	addw	a4,a4,a1
     f32:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     f36:	6398                	ld	a4,0(a5)
     f38:	6310                	ld	a2,0(a4)
     f3a:	a83d                	j	f78 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     f3c:	ff852703          	lw	a4,-8(a0)
     f40:	9f31                	addw	a4,a4,a2
     f42:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     f44:	ff053683          	ld	a3,-16(a0)
     f48:	a091                	j	f8c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f4a:	6398                	ld	a4,0(a5)
     f4c:	00e7e463          	bltu	a5,a4,f54 <free+0x3a>
     f50:	00e6ea63          	bltu	a3,a4,f64 <free+0x4a>
{
     f54:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f56:	fed7fae3          	bgeu	a5,a3,f4a <free+0x30>
     f5a:	6398                	ld	a4,0(a5)
     f5c:	00e6e463          	bltu	a3,a4,f64 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f60:	fee7eae3          	bltu	a5,a4,f54 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
     f64:	ff852583          	lw	a1,-8(a0)
     f68:	6390                	ld	a2,0(a5)
     f6a:	02059813          	slli	a6,a1,0x20
     f6e:	01c85713          	srli	a4,a6,0x1c
     f72:	9736                	add	a4,a4,a3
     f74:	fae60de3          	beq	a2,a4,f2e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
     f78:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     f7c:	4790                	lw	a2,8(a5)
     f7e:	02061593          	slli	a1,a2,0x20
     f82:	01c5d713          	srli	a4,a1,0x1c
     f86:	973e                	add	a4,a4,a5
     f88:	fae68ae3          	beq	a3,a4,f3c <free+0x22>
    p->s.ptr = bp->s.ptr;
     f8c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
     f8e:	00001717          	auipc	a4,0x1
     f92:	92f73d23          	sd	a5,-1734(a4) # 18c8 <freep>
}
     f96:	6422                	ld	s0,8(sp)
     f98:	0141                	addi	sp,sp,16
     f9a:	8082                	ret

0000000000000f9c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     f9c:	7139                	addi	sp,sp,-64
     f9e:	fc06                	sd	ra,56(sp)
     fa0:	f822                	sd	s0,48(sp)
     fa2:	f426                	sd	s1,40(sp)
     fa4:	ec4e                	sd	s3,24(sp)
     fa6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     fa8:	02051493          	slli	s1,a0,0x20
     fac:	9081                	srli	s1,s1,0x20
     fae:	04bd                	addi	s1,s1,15
     fb0:	8091                	srli	s1,s1,0x4
     fb2:	0014899b          	addiw	s3,s1,1
     fb6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
     fb8:	00001517          	auipc	a0,0x1
     fbc:	91053503          	ld	a0,-1776(a0) # 18c8 <freep>
     fc0:	c915                	beqz	a0,ff4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fc2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     fc4:	4798                	lw	a4,8(a5)
     fc6:	08977e63          	bgeu	a4,s1,1062 <malloc+0xc6>
     fca:	f04a                	sd	s2,32(sp)
     fcc:	e852                	sd	s4,16(sp)
     fce:	e456                	sd	s5,8(sp)
     fd0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
     fd2:	8a4e                	mv	s4,s3
     fd4:	0009871b          	sext.w	a4,s3
     fd8:	6685                	lui	a3,0x1
     fda:	00d77363          	bgeu	a4,a3,fe0 <malloc+0x44>
     fde:	6a05                	lui	s4,0x1
     fe0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
     fe4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     fe8:	00001917          	auipc	s2,0x1
     fec:	8e090913          	addi	s2,s2,-1824 # 18c8 <freep>
  if(p == (char*)-1)
     ff0:	5afd                	li	s5,-1
     ff2:	a091                	j	1036 <malloc+0x9a>
     ff4:	f04a                	sd	s2,32(sp)
     ff6:	e852                	sd	s4,16(sp)
     ff8:	e456                	sd	s5,8(sp)
     ffa:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
     ffc:	00001797          	auipc	a5,0x1
    1000:	8d478793          	addi	a5,a5,-1836 # 18d0 <base>
    1004:	00001717          	auipc	a4,0x1
    1008:	8cf73223          	sd	a5,-1852(a4) # 18c8 <freep>
    100c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    100e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1012:	b7c1                	j	fd2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    1014:	6398                	ld	a4,0(a5)
    1016:	e118                	sd	a4,0(a0)
    1018:	a08d                	j	107a <malloc+0xde>
  hp->s.size = nu;
    101a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    101e:	0541                	addi	a0,a0,16
    1020:	00000097          	auipc	ra,0x0
    1024:	efa080e7          	jalr	-262(ra) # f1a <free>
  return freep;
    1028:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    102c:	c13d                	beqz	a0,1092 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    102e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1030:	4798                	lw	a4,8(a5)
    1032:	02977463          	bgeu	a4,s1,105a <malloc+0xbe>
    if(p == freep)
    1036:	00093703          	ld	a4,0(s2)
    103a:	853e                	mv	a0,a5
    103c:	fef719e3          	bne	a4,a5,102e <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    1040:	8552                	mv	a0,s4
    1042:	00000097          	auipc	ra,0x0
    1046:	bb2080e7          	jalr	-1102(ra) # bf4 <sbrk>
  if(p == (char*)-1)
    104a:	fd5518e3          	bne	a0,s5,101a <malloc+0x7e>
        return 0;
    104e:	4501                	li	a0,0
    1050:	7902                	ld	s2,32(sp)
    1052:	6a42                	ld	s4,16(sp)
    1054:	6aa2                	ld	s5,8(sp)
    1056:	6b02                	ld	s6,0(sp)
    1058:	a03d                	j	1086 <malloc+0xea>
    105a:	7902                	ld	s2,32(sp)
    105c:	6a42                	ld	s4,16(sp)
    105e:	6aa2                	ld	s5,8(sp)
    1060:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1062:	fae489e3          	beq	s1,a4,1014 <malloc+0x78>
        p->s.size -= nunits;
    1066:	4137073b          	subw	a4,a4,s3
    106a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    106c:	02071693          	slli	a3,a4,0x20
    1070:	01c6d713          	srli	a4,a3,0x1c
    1074:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1076:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    107a:	00001717          	auipc	a4,0x1
    107e:	84a73723          	sd	a0,-1970(a4) # 18c8 <freep>
      return (void*)(p + 1);
    1082:	01078513          	addi	a0,a5,16
  }
}
    1086:	70e2                	ld	ra,56(sp)
    1088:	7442                	ld	s0,48(sp)
    108a:	74a2                	ld	s1,40(sp)
    108c:	69e2                	ld	s3,24(sp)
    108e:	6121                	addi	sp,sp,64
    1090:	8082                	ret
    1092:	7902                	ld	s2,32(sp)
    1094:	6a42                	ld	s4,16(sp)
    1096:	6aa2                	ld	s5,8(sp)
    1098:	6b02                	ld	s6,0(sp)
    109a:	b7f5                	j	1086 <malloc+0xea>
