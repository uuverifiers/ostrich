(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; RequestWindowszzzvmkituktgr\u{2f}etieencoder
(assert (str.in_re X (str.to_re "RequestWindowszzzvmkituktgr/etieencoder\u{0a}")))
; /\/pte\.aspx\?ver=\d\.\d\.\d+\.\d\u{26}rnd=\d{5}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//pte.aspx?ver=") (re.range "0" "9") (str.to_re ".") (re.range "0" "9") (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re ".") (re.range "0" "9") (str.to_re "&rnd=") ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
; /^[0-9a-fA-F]+$/
(assert (str.in_re X (re.++ (str.to_re "/") (re.+ (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re "/\u{0a}"))))
; ([A-Z]|[a-z])|\/|\?|\-|\+|\=|\&|\%|\$|\#|\@|\!|\||\\|\}|\]|\[|\{|\;|\:|\'|\"|\,|\.|\>|\<|\*|([0-9])|\(|\)|\s
(assert (not (str.in_re X (re.union (str.to_re "/") (str.to_re "?") (str.to_re "-") (str.to_re "+") (str.to_re "=") (str.to_re "&") (str.to_re "%") (str.to_re "$") (str.to_re "#") (str.to_re "@") (str.to_re "!") (str.to_re "|") (str.to_re "\u{5c}") (str.to_re "}") (str.to_re "]") (str.to_re "[") (str.to_re "{") (str.to_re ";") (str.to_re ":") (str.to_re "'") (str.to_re "\u{22}") (str.to_re ",") (str.to_re ".") (str.to_re ">") (str.to_re "<") (str.to_re "*") (re.range "0" "9") (str.to_re "(") (str.to_re ")") (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}")) (re.range "A" "Z") (re.range "a" "z")))))
; www\x2Epcsentinelsoftware\x2Ecom
(assert (not (str.in_re X (str.to_re "www.pcsentinelsoftware.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
