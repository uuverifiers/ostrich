(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\u{3a}.*ver\dRobert\dDmInf\x5EinfoSimpsonUser-Agent\x3AClientwww\x2Einternet-optimizer\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "ver") (re.range "0" "9") (str.to_re "Robert") (re.range "0" "9") (str.to_re "DmInf^infoSimpsonUser-Agent:Clientwww.internet-optimizer.com\u{0a}")))))
; /\u{2f}b\u{2f}pkg\u{2f}T202[0-9a-z]{10}/U
(assert (not (str.in_re X (re.++ (str.to_re "//b/pkg/T202") ((_ re.loop 10 10) (re.union (re.range "0" "9") (re.range "a" "z"))) (str.to_re "/U\u{0a}")))))
; forum=\s+\x2Ftoolbar\x2Fico\x2F
(assert (str.in_re X (re.++ (str.to_re "forum=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/toolbar/ico/\u{0a}"))))
; ^(192\.168\.[0-9]|[1-9][0-9]|[1-2][0-5][0-5]\.[0-9]|[1-9][0-9]|[1-2][0-5][0-5])$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "192.168.") (re.range "0" "9")) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "1" "2") (re.range "0" "5") (re.range "0" "5") (str.to_re ".") (re.range "0" "9")) (re.++ (re.range "1" "9") (re.range "0" "9")) (re.++ (re.range "1" "2") (re.range "0" "5") (re.range "0" "5"))) (str.to_re "\u{0a}")))))
; /^Host\u{3a}\u{20}\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\r?\n/Hsmi
(assert (str.in_re X (re.++ (str.to_re "/Host: ") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (str.to_re "\u{0d}")) (str.to_re "\u{0a}/Hsmi\u{0a}"))))
(check-sat)
