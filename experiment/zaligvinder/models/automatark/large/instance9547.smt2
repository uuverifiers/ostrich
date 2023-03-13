(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\s+offers\x2Ebullseye-network\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "offers.bullseye-network.com\u{0a}"))))
; \u{03}\u{00}\u{1c}\u{00}\u{00}\u{00}\u{00}\u{00}\u{01}Furax
(assert (str.in_re X (str.to_re "\u{03}\u{00}\u{1c}\u{00}\u{00}\u{00}\u{00}\u{00}\u{01}Furax\u{0a}")))
; /null[^\u{7d}]{0,50}\.body\.innerHTML\s*?\u{3d}\s*?[\u{22}\u{27}]{2}[^\u{7d}]{0,50}CollectGarbage\u{28}\s*?\u{29}[^\u{7d}]{0,250}document\.write\u{28}\s*?[\u{22}\u{27}]{2}/smi
(assert (not (str.in_re X (re.++ (str.to_re "/null") ((_ re.loop 0 50) (re.comp (str.to_re "}"))) (str.to_re ".body.innerHTML") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (str.to_re "\u{22}") (str.to_re "'"))) ((_ re.loop 0 50) (re.comp (str.to_re "}"))) (str.to_re "CollectGarbage(") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ")") ((_ re.loop 0 250) (re.comp (str.to_re "}"))) (str.to_re "document.write(") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 2) (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "/smi\u{0a}")))))
; SpyBuddy\sPARSER.*Host\x3Aaction\x2Eforhttp\x3A\x2F\x2Fwww\.searchinweb\.com\x2Fsearch\.php\?said=bar
(assert (str.in_re X (re.++ (str.to_re "SpyBuddy") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "PARSER") (re.* re.allchar) (str.to_re "Host:action.forhttp://www.searchinweb.com/search.php?said=bar\u{0a}"))))
; /filename=[^\n]*\u{2e}f4a/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".f4a/i\u{0a}"))))
(check-sat)
