(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Online\u{25}21\u{25}21\u{25}21\sUser-Agent\x3A\d+HXDownloadasdbiz\x2Ebiz
(assert (str.in_re X (re.++ (str.to_re "Online%21%21%21") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "User-Agent:") (re.+ (re.range "0" "9")) (str.to_re "HXDownloadasdbiz.biz\u{0a}"))))
; (\d*)'*-*(\d*)/*(\d*)"
(assert (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.* (str.to_re "'")) (re.* (str.to_re "-")) (re.* (re.range "0" "9")) (re.* (str.to_re "/")) (re.* (re.range "0" "9")) (str.to_re "\u{22}\u{0a}"))))
; [1-2][0|9][0-9]{2}[0-1][0-9][0-3][0-9][-][0-9]{4}
(assert (str.in_re X (re.++ (re.range "1" "2") (re.union (str.to_re "0") (str.to_re "|") (str.to_re "9")) ((_ re.loop 2 2) (re.range "0" "9")) (re.range "0" "1") (re.range "0" "9") (re.range "0" "3") (re.range "0" "9") (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; User-Agent\x3ABasedUser-Agent\x3A
(assert (str.in_re X (str.to_re "User-Agent:BasedUser-Agent:\u{0a}")))
; ^((http|HTTP|https|HTTPS|ftp|FTP?)\:\/\/)?((www|WWW)+\.)+(([0-9]{1,3}){3}[0-9]{1,3}\.|([\w!~*'()-]+\.)*([\w^-][\w-]{0,61})?[\w]\.[a-z]{2,6})(:[0-9]{1,4})?((\/*)|(\/+[\w!~*'().;?:@&=+$,%#-]+)+\/*)$
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "http") (str.to_re "HTTP") (str.to_re "https") (str.to_re "HTTPS") (str.to_re "ftp") (re.++ (str.to_re "FT") (re.opt (str.to_re "P")))) (str.to_re "://"))) (re.+ (re.++ (re.+ (re.union (str.to_re "www") (str.to_re "WWW"))) (str.to_re "."))) (re.union (re.++ ((_ re.loop 3 3) ((_ re.loop 1 3) (re.range "0" "9"))) ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".")) (re.++ (re.* (re.++ (re.+ (re.union (str.to_re "!") (str.to_re "~") (str.to_re "*") (str.to_re "'") (str.to_re "(") (str.to_re ")") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "."))) (re.opt (re.++ (re.union (str.to_re "^") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) ((_ re.loop 0 61) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (str.to_re ".") ((_ re.loop 2 6) (re.range "a" "z")))) (re.opt (re.++ (str.to_re ":") ((_ re.loop 1 4) (re.range "0" "9")))) (re.union (re.* (str.to_re "/")) (re.++ (re.+ (re.++ (re.+ (str.to_re "/")) (re.+ (re.union (str.to_re "!") (str.to_re "~") (str.to_re "*") (str.to_re "'") (str.to_re "(") (str.to_re ")") (str.to_re ".") (str.to_re ";") (str.to_re "?") (str.to_re ":") (str.to_re "@") (str.to_re "&") (str.to_re "=") (str.to_re "+") (str.to_re "$") (str.to_re ",") (str.to_re "%") (str.to_re "#") (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (re.* (str.to_re "/")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
