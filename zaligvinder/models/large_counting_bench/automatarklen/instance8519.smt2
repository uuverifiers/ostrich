(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /<rt[^?]*?style\s*=\s*[\u{22}\u{27}]?-ms-hyphens\s*\x3A\s*auto\s*\x3B\s*[\u{27}\u{22}]?\>[\w\W]{680}/smi
(assert (not (str.in_re X (re.++ (str.to_re "/<rt") (re.* (re.comp (str.to_re "?"))) (str.to_re "style") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "-ms-hyphens") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ":") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "auto") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ";") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "'") (str.to_re "\u{22}"))) (str.to_re ">") ((_ re.loop 680 680) (re.union (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/smi\u{0a}")))))
; AdTools\sdownloadfile\u{2e}org\w+com\x3E[^\n\r]*as\x2Estarware\x2EcomOS\x2FSSKCstech\x2Eweb-nexus\x2Enet
(assert (not (str.in_re X (re.++ (str.to_re "AdTools") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "downloadfile.org") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "com>") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "as.starware.comOS/SSKCstech.web-nexus.net\u{0a}")))))
; ^(Sun|Mon|(T(ues|hurs))|Fri)(day|\.)?$|Wed(\.|nesday)?$|Sat(\.|urday)?$|T((ue?)|(hu?r?))\.?$
(assert (not (str.in_re X (re.union (re.++ (re.union (str.to_re "Sun") (str.to_re "Mon") (re.++ (str.to_re "T") (re.union (str.to_re "ues") (str.to_re "hurs"))) (str.to_re "Fri")) (re.opt (re.union (str.to_re "day") (str.to_re ".")))) (re.++ (str.to_re "Wed") (re.opt (re.union (str.to_re ".") (str.to_re "nesday")))) (re.++ (str.to_re "Sat") (re.opt (re.union (str.to_re ".") (str.to_re "urday")))) (re.++ (str.to_re "T") (re.union (re.++ (str.to_re "u") (re.opt (str.to_re "e"))) (re.++ (str.to_re "h") (re.opt (str.to_re "u")) (re.opt (str.to_re "r")))) (re.opt (str.to_re ".")) (str.to_re "\u{0a}"))))))
(assert (< 200 (str.len X)))
(check-sat)