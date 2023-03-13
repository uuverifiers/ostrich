(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[a-zA-Z]\:\\.*|^\\\\.*
(assert (str.in_re X (re.union (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (str.to_re ":\u{5c}") (re.* re.allchar)) (re.++ (str.to_re "\u{5c}\u{5c}") (re.* re.allchar) (str.to_re "\u{0a}")))))
; Runner.*\x2Ehtml[^\n\r]*NetControl\x2EServer\d+media\x2Edxcdirect\x2Ecom\.smx\?PASSW=SAH
(assert (not (str.in_re X (re.++ (str.to_re "Runner") (re.* re.allchar) (str.to_re ".html") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "NetControl.Server\u{13}") (re.+ (re.range "0" "9")) (str.to_re "media.dxcdirect.com.smx?PASSW=SAH\u{0a}")))))
; ApofisAgentFunWebProductsUser-Agent\x3A
(assert (str.in_re X (str.to_re "ApofisAgentFunWebProductsUser-Agent:\u{0a}")))
; http://(www\.)?([^\.]+)\.com
(assert (str.in_re X (re.++ (str.to_re "http://") (re.opt (str.to_re "www.")) (re.+ (re.comp (str.to_re "."))) (str.to_re ".com\u{0a}"))))
; ^(([0]?[1-9]|[1][0-2])[\/|\-|\.]([0-2]\d|[3][0-1]|[1-9])[\/|\-|\.]([2][0])?\d{2}\s+((([0][0-9]|[1][0-2]|[0-9])[\:|\-|\.]([0-5]\d)\s*([aApP][mM])?)|(([0-1][0-9]|[2][0-3]|[0-9])[\:|\-|\.]([0-5]\d))))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.++ (re.opt (str.to_re "0")) (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (re.union (str.to_re "/") (str.to_re "|") (str.to_re "-") (str.to_re ".")) (re.union (re.++ (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1")) (re.range "1" "9")) (re.union (str.to_re "/") (str.to_re "|") (str.to_re "-") (str.to_re ".")) (re.opt (str.to_re "20")) ((_ re.loop 2 2) (re.range "0" "9")) (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "2")) (re.range "0" "9")) (re.union (str.to_re ":") (str.to_re "|") (str.to_re "-") (str.to_re ".")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.++ (re.union (str.to_re "a") (str.to_re "A") (str.to_re "p") (str.to_re "P")) (re.union (str.to_re "m") (str.to_re "M")))) (re.range "0" "5") (re.range "0" "9")) (re.++ (re.union (re.++ (re.range "0" "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3")) (re.range "0" "9")) (re.union (str.to_re ":") (str.to_re "|") (str.to_re "-") (str.to_re ".")) (re.range "0" "5") (re.range "0" "9"))))))
(check-sat)
