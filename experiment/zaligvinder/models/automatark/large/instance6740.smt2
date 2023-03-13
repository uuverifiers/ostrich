(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; 05\d{8}
(assert (str.in_re X (re.++ (str.to_re "05") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^(6553[0-5]|655[0-2]\d|65[0-4]\d\d|6[0-4]\d{3}|[1-5]\d{4}|[1-9]\d{0,3}|0)$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "6553") (re.range "0" "5")) (re.++ (str.to_re "655") (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "65") (re.range "0" "4") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "6") (re.range "0" "4") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (re.range "1" "5") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 0 3) (re.range "0" "9"))) (str.to_re "0")) (str.to_re "\u{0a}"))))
; www\x2Eserverlogic3\x2Ecom\d+ToolBar.*Host\x3AHWAEUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "www.serverlogic3.com") (re.+ (re.range "0" "9")) (str.to_re "ToolBar") (re.* re.allchar) (str.to_re "Host:HWAEUser-Agent:\u{0a}")))))
; ^[ .a-zA-Z0-9:-]{1,150}$
(assert (str.in_re X (re.++ ((_ re.loop 1 150) (re.union (str.to_re " ") (str.to_re ".") (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ":") (str.to_re "-"))) (str.to_re "\u{0a}"))))
; xbqyosoe\u{2f}cpvmwww\u{2e}urlblaze\u{2e}netconfigINTERNAL\.ini
(assert (str.in_re X (str.to_re "xbqyosoe/cpvmwww.urlblaze.netconfigINTERNAL.ini\u{0a}")))
(check-sat)
