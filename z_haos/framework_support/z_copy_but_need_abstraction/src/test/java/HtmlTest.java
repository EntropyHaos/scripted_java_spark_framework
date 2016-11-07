import models.UserModel;
import java.util.Collections;
import org.junit.Test;
import org.easymock.EasyMock;
import static org.easymock.EasyMock.expect;

/**
 *
 * @author prash_000
 */
public class HtmlTest {
    
    public HtmlTest() {
    }

     @Test
    public void getAllPostsIsHandledCorrectlyInHtmlOutput() {
        UserModel model = EasyMock.createMock(UserModel.class);
        expect(model.sendElements()).andReturn(Collections.EMPTY_LIST);
    }

}
