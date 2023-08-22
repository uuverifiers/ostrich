(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2Edat\x2EToolbar\x7D\x7BOS\x3Atoolsbar\x2Ekuaiso\x2Ecom
(assert (not (str.in_re X (str.to_re ".dat.Toolbar}{OS:toolsbar.kuaiso.com\u{0a}"))))
; st=\s+www\.iggsey\.com.*BackAtTaCkadserver\.warezclient\.com
(assert (str.in_re X (re.++ (str.to_re "st=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.iggsey.com") (re.* re.allchar) (str.to_re "BackAtTaCkadserver.warezclient.com\u{0a}"))))
; ((\(\d{3}\) ?)|(\d{3}-))?\d{3}-\d{4}
(assert (str.in_re X (re.++ (re.opt (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")") (re.opt (str.to_re " "))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-")))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}abc/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".abc/i\u{0a}"))))
; /<body[^>]+?style\s*=\s*[\u{22}\u{27}](-ms-)?behavior\s*:.*?<body[^>]+?onreadystatechange\s*=[^>]+?>[\s\t\r\n]*?<\/body/si
(assert (str.in_re X (re.++ (str.to_re "/<body") (re.+ (re.comp (str.to_re ">"))) (str.to_re "style") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "\u{22}") (str.to_re "'")) (re.opt (str.to_re "-ms-")) (str.to_re "behavior") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ":") (re.* re.allchar) (str.to_re "<body") (re.+ (re.comp (str.to_re ">"))) (str.to_re "onreadystatechange") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.+ (re.comp (str.to_re ">"))) (str.to_re ">") (re.* (re.union (str.to_re "\u{09}") (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "</body/si\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
