namespace WorkCal.Mobile;

public class App : Application
{
    protected override Window CreateWindow(IActivationState? activationState)
    {
        var page = new ContentPage
        {
            Content = new Label
            {
                Text = "WorkCal",
                HorizontalOptions = LayoutOptions.Center,
                VerticalOptions = LayoutOptions.Center,
            },
        };
        return new Window(page);
    }
}
