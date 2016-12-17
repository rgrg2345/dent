# encoding utf-8
import re

from sys import argv


def h2i(h):
    return int(h, 16)


def readdata(s):
    h = h2i(s[0:2])
    l = h2i(s[2:4])
    if h > 127:
        h -= 256
        l -= 256
    return h * 256 + l


def extract(filename):
    # write to destination
    res = re.search('\d{5}.(TXT|txt)', filename)
    if res:
        targetname = res.group()
    print "[+] Extract : %s"%targetname

    with open(targetname, 'w') as fp2:
        with open(filename, 'r') as fp:
            # try:
            # data = readdata(fp.read(4))
            cnt = 0
            error = 0
            fp.read()
            end = fp.tell()
            fp.seek(0, 0)
            s = ''

            while(True):
                try:
                    h = fp.read(2).encode('hex')
                    if(h == 'ffff'):
                        # print 'find start'
                        continue
                    if(h == 'fefe'):
                        s = s[0:-1]
                        m = re.findall('(?:, )', s)
                        cnt += 1
                        if len(m) == 5:
                            # print cnt, '.',
                            # print s
                            fp2.write(s[:-1])
                            fp2.write('\n')
                        else:
                            error += 1
                        s = ''
                        continue
                    data = readdata(h)
                    s = s + str(data) + ', '

                except:
                    assert cnt>0,"0 data had been extracted!!"
                    #fp2.write("%d errors in %d datas\n, Error rate : %f" % (error, cnt, float(error) / cnt))
                    fp2.close()
                    if fp.tell() != end:
                        raise Exception('Read fail')
                    print "     %d errors in %d datas, Error rate : %f%s" % (error, cnt, float(error) / cnt*100 ,'%')
                    break
if __name__ == '__main__':
    extract(argv[1])
