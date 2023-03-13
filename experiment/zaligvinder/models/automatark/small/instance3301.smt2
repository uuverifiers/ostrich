(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (jar:)?file:/(([A-Z]:)?/([A-Z0-9\*\()\+\-\&$#@_.!~\[\]/])+)((/[A-Z0-9_()\[\]\-=\+_~]+\.jar!)|([^!])(/com/regexlib/example/))
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "jar:")) (str.to_re "file:/") (re.union (re.++ (str.to_re "/") (re.+ (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "(") (str.to_re ")") (str.to_re "[") (str.to_re "]") (str.to_re "-") (str.to_re "=") (str.to_re "+") (str.to_re "~"))) (str.to_re ".jar!")) (re.++ (re.comp (str.to_re "!")) (str.to_re "/com/regexlib/example/"))) (str.to_re "\u{0a}") (re.opt (re.++ (re.range "A" "Z") (str.to_re ":"))) (str.to_re "/") (re.+ (re.union (re.range "A" "Z") (re.range "0" "9") (str.to_re "*") (str.to_re "(") (str.to_re ")") (str.to_re "+") (str.to_re "-") (str.to_re "&") (str.to_re "$") (str.to_re "#") (str.to_re "@") (str.to_re "_") (str.to_re ".") (str.to_re "!") (str.to_re "~") (str.to_re "[") (str.to_re "]") (str.to_re "/")))))))
; TM_SEARCH3SearchUser-Agent\x3Aas\x2Estarware\x2EcomM\x2EzipCasinoResults_sq=aolsnssignin
(assert (not (str.in_re X (str.to_re "TM_SEARCH3SearchUser-Agent:as.starware.comM.zipCasinoResults_sq=aolsnssignin\u{0a}"))))
; /\u{2e}m4b([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.m4b") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; 3AFrom\x3Adddrep\x2Edudu\x2Ecomform-data\x3B\u{20}name=\u{22}pid\u{22}
(assert (not (str.in_re X (str.to_re "3AFrom:dddrep.dudu.comform-data; name=\u{22}pid\u{22}\u{0a}"))))
; ^[a-zA-Z0-9]+([_.-]?[a-zA-Z0-9]+)?@[a-zA-Z0-9]+([_-]?[a-zA-Z0-9]+)*([.]{1})[a-zA-Z0-9]+([.]?[a-zA-Z0-9]+)*$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.opt (re.++ (re.opt (re.union (str.to_re "_") (str.to_re ".") (str.to_re "-"))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))) (str.to_re "@") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.* (re.++ (re.opt (re.union (str.to_re "_") (str.to_re "-"))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))) ((_ re.loop 1 1) (str.to_re ".")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.* (re.++ (re.opt (str.to_re ".")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
(check-sat)
