(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Eonlinecasinoextra\x2Ecomsqlads\.grokads\.com
(assert (not (str.in_re X (str.to_re "www.onlinecasinoextra.comsqlads.grokads.com\u{0a}"))))
; Host\x3Aact=Host\u{3a}User-Agent\x3AUser-Agent\x3ALiteselect\x2FGet
(assert (not (str.in_re X (str.to_re "Host:act=Host:User-Agent:User-Agent:Liteselect/Get\u{0a}"))))
; Host\x3ASpyxpsp2-Host\u{3a}Host\x3Awjpropqmlpohj\u{2f}loregister\.asp
(assert (not (str.in_re X (str.to_re "Host:Spyxpsp2-Host:Host:wjpropqmlpohj/loregister.asp\u{0a}"))))
; ^(([a-zA-Z]:)|(\\{2}\w+)\$?)(\\(\w[\w ]*.*))+\.(txt|TXT)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":")) (re.++ (re.opt (str.to_re "$")) ((_ re.loop 2 2) (str.to_re "\u{5c}")) (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))))) (re.+ (re.++ (str.to_re "\u{5c}") (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_")) (re.* (re.union (str.to_re " ") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* re.allchar))) (str.to_re ".") (re.union (str.to_re "txt") (str.to_re "TXT")) (str.to_re "\u{0a}")))))
; ^[0-9]{1,}(,[0-9]+){0,}$
(assert (not (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.* (re.++ (str.to_re ",") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(check-sat)
