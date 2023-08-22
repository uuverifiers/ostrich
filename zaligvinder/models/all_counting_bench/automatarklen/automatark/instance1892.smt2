(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\x2F40e800[0-9A-F]{30,}$/Ui
(assert (str.in_re X (re.++ (str.to_re "//40e800/Ui\u{0a}") ((_ re.loop 30 30) (re.union (re.range "0" "9") (re.range "A" "F"))) (re.* (re.union (re.range "0" "9") (re.range "A" "F"))))))
; /\u{2e}rt([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.rt") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^(([8]))$|^((([0-7]))$|^((([0-7])).?((25)|(50)|(5)|(75)|(0)|(00))))$
(assert (not (str.in_re X (re.union (str.to_re "8") (re.++ (re.union (re.range "0" "7") (re.++ (re.range "0" "7") (re.opt re.allchar) (re.union (str.to_re "25") (str.to_re "50") (str.to_re "5") (str.to_re "75") (str.to_re "0") (str.to_re "00")))) (str.to_re "\u{0a}"))))))
; Host\x3A\w+www.*ToolbartheServer\x3Awww\x2Esearchreslt\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "www") (re.* re.allchar) (str.to_re "ToolbartheServer:www.searchreslt.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
