(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\dwww\x2Etrustedsearch\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.range "0" "9") (str.to_re "www.trustedsearch.com\u{0a}"))))
; ^((http|HTTP|https|HTTPS|ftp|FTP?)\:\/\/)?((www|WWW)+\.)+(([0-9]{1,3}){3}[0-9]{1,3}\.|([\w!~*'()-]+\.)*([\w^-][\w-]{0,61})?[\w]\.[a-z]{2,6})(:[0-9]{1,4})?((\/*)|(\/+[\w!~*'().;?:@&=+$,%#-]+)+\/*)$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "http") (str.to_re "HTTP") (str.to_re "https") (str.to_re "HTTPS") (str.to_re "ftp") (re.++ (str.to_re "FT") (re.opt (str.to_re "P")))) (str.to_re "://"))) (re.+ (re.++ (re.+ (re.union (str.to_re "www") (str.to_re "WWW"))) (str.to_re "."))) (re.union (re.++ ((_ re.loop 3 3) ((_ re.loop 1 3) (re.range "0" "9"))) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".")) (re.++ (re.* (re.++ (re.+ (re.union (str.to_re "!") (str.to_re "~") (str.to_re "*") (str.to_re "'") (str.to_re "(") (str.to_re ")") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "."))) (re.opt (re.++ (re.union (str.to_re "^") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) ((_ re.loop 0 61) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (str.to_re ".") ((_ re.loop 2 6) (re.range "a" "z")))) (re.opt (re.++ (str.to_re ":") ((_ re.loop 1 4) (re.range "0" "9")))) (re.union (re.* (str.to_re "/")) (re.++ (re.+ (re.++ (re.+ (str.to_re "/")) (re.+ (re.union (str.to_re "!") (str.to_re "~") (str.to_re "*") (str.to_re "'") (str.to_re "(") (str.to_re ")") (str.to_re ".") (str.to_re ";") (str.to_re "?") (str.to_re ":") (str.to_re "@") (str.to_re "&") (str.to_re "=") (str.to_re "+") (str.to_re "$") (str.to_re ",") (str.to_re "%") (str.to_re "#") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (re.* (str.to_re "/")))) (str.to_re "\u{0a}")))))
; ^\d+([.,]?\d+)?$
(assert (not (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (re.opt (re.union (str.to_re ".") (str.to_re ","))) (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; HWPE[^\n\r]*Basic.*LOGsearches\x2Eworldtostart\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "HWPE") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Basic") (re.* re.allchar) (str.to_re "LOGsearches.worldtostart.com\u{0a}"))))
; pgwtjgxwthx\u{2f}byb\.xkyLOGurl=enews\x2Eearthlink\x2Enet
(assert (str.in_re X (str.to_re "pgwtjgxwthx/byb.xkyLOGurl=enews.earthlink.net\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
